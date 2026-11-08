# Define image
FROM python:3.14-slim

# Define work dir
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source
COPY app/analyzer .

# Expose port
EXPOSE 80

# Run main
CMD ["python", "main.py"]