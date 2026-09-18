FROM python:3.11-slim AS builder

WORKDIR /install

COPY requirements.txt .

RUN apt-get update && apt-get install -y --no-install-recommends nano \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --target=/install/deps -r requirements.txt

FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/deps/lib/python3.11/site-packages
ENV PATH=/deps/bin:$PATH

WORKDIR /app

RUN useradd -m contuser

COPY --from=builder /install/deps /deps

COPY app/ /app/
COPY data/ /app/data/

RUN chown -R contuser:contuser /app
USER contuser

CMD ["python", "load_data.py"]