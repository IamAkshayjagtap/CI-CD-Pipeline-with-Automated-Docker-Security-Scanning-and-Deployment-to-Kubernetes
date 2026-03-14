FROM python:3.9-slim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

COPY requirements.txt .

RUN apt-get update && \
    apt-get install -y --only-upgrade libc-bin libc6 libsystemd0 libudev1 openssl && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --upgrade wheel==0.46.3 jaraco.context==6.1.1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]