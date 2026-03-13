FROM python:3.9-slim

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

COPY requirements.txt .

RUN apt-get update && apt-get upgrade -y \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --upgrade wheel jaraco.context \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY app.py .

EXPOSE 5000
CMD ["python", "app.py"]