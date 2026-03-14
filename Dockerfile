FROM python:3.9-alpine

ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apk update && apk add --no-cache \
    bash \
    build-base \
    libffi-dev \
    openssl-dev \
    && rm -rf /var/cache/apk/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --upgrade wheel==0.46.3 jaraco.context==6.1.1

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]