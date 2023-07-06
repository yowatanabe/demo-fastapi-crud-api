FROM python:3.11.4-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /src

COPY requirements.txt /src

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

ENTRYPOINT [ "uvicorn", "app.main:app", "--host", "0.0.0.0", "--reload" ]
