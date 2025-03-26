# ai/Dockerfile

FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ai_service.py .

EXPOSE 8000

CMD ["python", "ai_service.py"]
