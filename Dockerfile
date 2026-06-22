# 1. Use the official lightweight Python 3.12 slim image as the base engine
FROM python:3.12-slim

# 2. Set system environment variables to optimize Python inside a container
# PYTHONDONTWRITEBYTECODE: Prevents Python from writing .pyc files to disk
# PYTHONUNBUFFERED: Forces stdout/stderr streams to flush instantly for real-time CloudWatch logging
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    WORKDIR=/workspace

# 3. Establish our working directory inside the container filesystem
WORKDIR ${WORKDIR}

# 4. Install system dependencies if needed (slim lacks basic utilities)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 5. Copy over ONLY the requirements manifest first to leverage Docker layer caching
COPY requirements.txt .

# 6. Install Python application dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# 7. Copy the application source code files into the container workspace
COPY app/ ./app/

# 8. Expose the execution port that our app will listen on inside the VPC network
EXPOSE 8000

# 9. Define the default runtime execution command using Uvicorn
# We explicitly bind to 0.0.0.0 so the container can accept external requests from the AWS ALB
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
