# ------------------- Stage 1: Build Stage ------------------------------
FROM python:3.9-slim as builder

WORKDIR /app

# Install build dependencies (needed to compile mysqlclient)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirement file and install Python deps
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --prefix=/install -r requirements.txt

# ------------------- Stage 2: Final Stage ------------------------------
FROM python:3.9-slim

WORKDIR /app

# Install runtime MySQL shared libs
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libmariadb3 \
    && rm -rf /var/lib/apt/lists/*

# Copy installed Python packages from builder
COPY --from=builder /install /usr/local

# Copy the rest of the application
COPY . .

# Expose Flask port
EXPOSE 5000

# Run the Flask app
CMD ["python", "app.py"]

