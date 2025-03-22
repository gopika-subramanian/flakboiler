
FROM python:3.10-slim as base

EXPOSE 5000
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY requirements.txt .
RUN python -m pip install -r requirements.txt

WORKDIR /flask_starterkit
COPY . /flask_starterkit


RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /flask_starterkit
USER appuser

FROM base as debugger

RUN pip install debugpy

CMD ["python", "-m", "debugpy", "--listen", "0.0.0.0:5678", "--wait-for-client", "-m", "flask", "run", "-h","0.0.0.0" , "-p","5000"]

FROM base as debug
CMD ["flask", "run", "--host", "0.0.0.0"]

FROM base as test

RUN pip install pytest

CMD ["python","-m","pytest"]


FROM base as prod

CMD ["flask", "run", "--host", "0.0.0.0"]

