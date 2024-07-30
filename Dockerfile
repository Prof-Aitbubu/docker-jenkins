# Dockerfile:
    FROM python:3.9-slim 
    WORKDIR /app 
    COPY . /app 
    RUN pip install --no-cache-dir flask 
    EXPOSE 80 
    ENV NAME World 
    CMD ["python", "app.py"]