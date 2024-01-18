#!/bin/bash

# Switch to script directory
cd "$(dirname "$0")"

# Set environment variables
echo "Setting environment variables..."

# Set general environment variables from .env file
export PROJECT_NAME=$(grep '^PROJECT_NAME=' .env | cut -d '=' -f 2- | tr -d '[:space:]')

# Set Poetry version and keep .venv in project
export POETRY_VERSION=$(grep '^POETRY_VERSION=' .env | cut -d '=' -f 2- | tr -d '[:space:]')
export POETRY_VIRTUALENVS_IN_PROJEC=$(grep '^POETRY_VIRTUALENVS_IN_PROJEC=' .env | cut -d '=' -f 2- | tr -d '[:space:]')

# Set Git environment variables from .env file
export GIT_MAIN_BRANCH=$(grep '^GIT_MAIN_BRANCH=' .env | cut -d '=' -f 2- | tr -d '[:space:]')
export USER_NAME=$(grep '^USER_NAME=' .env | cut -d '=' -f 2- | tr -d '[:space:]')
export USER_EMAIL=$(grep '^USER_EMAIL=' .env | cut -d '=' -f 2- | tr -d '[:space:]')

# Set web app environment variables from .env file (may not be required)
export SERVER_HOST=$(grep '^SERVER_HOST=' .env | cut -d '=' -f 2- | tr -d '[:space:]')
export SERVER_PORT=$(grep '^SERVER_HOST=' .env | cut -d '=' -f 2- | tr -d '[:space:]')

# Set Docker environment variables from .env file (may not be required)
export TZ=$(grep '^TZ=' .env | cut -d '=' -f 2- | tr -d '[:space:]')
export CONTAINER_NAME=$(grep '^CONTAINER_NAME=' .env | cut -d '=' -f 2- | tr -d '[:space:]')
export PYTHON_IMAGE=$(grep '^PYTHON_IMAGE=' .env | cut -d '=' -f 2- | tr -d '[:space:]')

# Install Poetry
echo "Installing Poetry..."
pip install poetry==$POETRY_VERSION

# Create the Poetry project env using .env vars and requirements.txt
echo "Creating Poetry project..."
mkdir -p ./src/$PROJECT_NAME
touch ./src/$PROJECT_NAME/__init__.py
mkdir -p ./tests
touch ./tests/__init__.py
poetry init -n
poetry add $(cat ./requirements.txt)

# Configure and create Git repository
echo "Setting up Git..."
git config --global user.name $USER_NAME
git config --global user.email $USER_EMAIL
git config --global init.defaultBranch $GIT_MAIN_BRANCH
git config --global --add safe.directory /$PROJECT_NAME
git init .

# Install pre-commit hooks
echo "Installing Pre-commit..."
poetry run pre-commit install
