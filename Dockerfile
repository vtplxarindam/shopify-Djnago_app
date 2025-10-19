# Dockerfile
FROM python:3.8-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install pipenv
RUN pip install --upgrade pip && pip install pipenv==2022.1.8

# Copy Pipfile
COPY Pipfile Pipfile.lock ./

# Install Python dependencies in virtualenv (remove --system flag)
RUN pipenv install --deploy

# Copy project files
COPY . .

# Expose port
EXPOSE 8000

# Run migrations and start server with pipenv run
CMD pipenv run python manage.py migrate && \
    pipenv run python manage.py collectstatic --noinput && \
    pipenv run python manage.py runserver 0.0.0.0:$PORT