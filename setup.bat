@echo off
setlocal enabledelayedexpansion

REM Switch to script directory
cd %~dp0

REM Set environment variables
echo Setting environment variables...

REM Set general environment variables from .env file
for /f "tokens=2 delims==" %%a in ('findstr /r "^PROJECT_NAME=" .env') do set PROJECT_NAME=%%a

REM Set Poetry version and keep .venv in project
for /f "tokens=2 delims==" %%a in ('findstr /r "^POETRY_VERSION=" .env') do set POETRY_VERSION=%%a
for /f "tokens=2 delims==" %%a in ('findstr /r "^POETRY_VIRTUALENVS_IN_PROJECT=" .env') do set POETRY_VIRTUALENVS_IN_PROJECT=%%a

REM Set Git environment variables from .env file
for /f "tokens=2 delims==" %%a in ('findstr /r "^GIT_MAIN_BRANCH=" .env') do set GIT_MAIN_BRANCH=%%a
for /f "tokens=2 delims==" %%a in ('findstr /r "^USER_NAME=" .env') do set USER_NAME=%%a
for /f "tokens=2 delims==" %%a in ('findstr /r "^USER_EMAIL=" .env') do set USER_EMAIL=%%a

REM Set web app environment variables from .env file (may not be required)
for /f "tokens=2 delims==" %%a in ('findstr /r "^SERVER_HOST=" .env') do set SERVER_HOST=%%a
for /f "tokens=2 delims==" %%a in ('findstr /r "^SERVER_PORT=" .env') do set SERVER_PORT=%%a

REM Set Docker environment variables from .env file (may not be required)
for /f "tokens=2 delims==" %%a in ('findstr /r "^TZ=" .env') do set TZ=%%a
for /f "tokens=2 delims==" %%a in ('findstr /r "^CONTAINER_NAME=" .env') do set CONTAINER_NAME=%%a
for /f "tokens=2 delims==" %%a in ('findstr /r "^PYTHON_IMAGE=" .env') do set PYTHON_IMAGE=%%a

REM Install Poetry
echo Installing Poetry...
pip install poetry==%POETRY_VERSION%

REM Create the Poetry project env using .env vars and requirements.txt
echo Creating Poetry project...
mkdir ".\src\%PROJECT_NAME%"
type nul > ".\src\%PROJECT_NAME%\__init__.py"
mkdir ".\tests"
type nul > ".\tests\__init__.py"
poetry init -n

REM Read list of packages to install via Poetry from requirements.txt
for /f "delims=" %%a in (requirements.txt) do (
    set "tempVar=!PACKAGES! %%a"
    set "PACKAGES=!tempVar!"
)

REM Add packages to Poetry env
poetry add %PACKAGES%

REM Configure and create Git repository
echo Setting up Git...
git config --global user.name "%USER_NAME%"
git config --global user.email "%USER_EMAIL%"
git config --global init.defaultBranch "%GIT_MAIN_BRANCH%"
git config --global --add safe.directory /%PROJECT_NAME%
git init .

REM Install pre-commit hooks
echo Installing Pre-commit...
poetry run pre-commit install

endlocal
pause
