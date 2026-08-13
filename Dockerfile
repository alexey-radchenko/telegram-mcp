# Use an official Python runtime as a parent image (Alpine-based for minimal vulnerabilities)
FROM python:3.13-alpine

# Set the working directory in the container
WORKDIR /app

# Prevent Python from writing pyc files to disc
ENV PYTHONDONTWRITEBYTECODE=1
# Ensure Python output is sent straight to terminal (useful for logs)
ENV PYTHONUNBUFFERED=1

# Install system dependencies if needed (e.g., for certain Python packages)
# RUN apt-get update && apt-get install -y --no-install-recommends some-package && rm -rf /var/lib/apt/lists/*

# Copy dependency definition files
COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY main.py sanitize.py ./
COPY telegram_mcp ./telegram_mcp

# Create a non-root user and switch to it
RUN adduser --disabled-password --gecos "" appuser && chown -R appuser:appuser /app
USER appuser

# Telegram credentials and session strings must be supplied at runtime
# (for example as Railway service variables). Do not define empty defaults here:
# an empty TELEGRAM_SESSION_STRING is interpreted by telegram-mcp as an
# additional "default" account and causes startup to fail when a labeled
# session such as TELEGRAM_SESSION_STRING_MCP is also configured.

# Define the command to run the application
CMD ["python", "main.py"]
