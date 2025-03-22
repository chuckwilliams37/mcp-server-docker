# Base image
FROM python:3.11-slim

# Set environment variables
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies
RUN apt-get update && apt-get install -y     build-essential     git     curl     wget     vim     netcat-openbsd     && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy application files
COPY ./app /app
WORKDIR /app

# Expose port
EXPOSE 8080

# Run the MCP server
CMD ["python", "app.py"]
