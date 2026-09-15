FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends nano \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN useradd -m contuser

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app/ /app/
COPY data/ /app/data/

RUN chown -R contuser:contuser /app
USER contuser

CMD ["python", "load_data.py"]