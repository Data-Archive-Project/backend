# Design of DCS Generic Data Archive - Backend

This repository contains the backend code for the  Data Archive System, a project designed to manage and archive departmental records and documents efficiently. The backend is built using Django, a Python web framework.

## Table of Contents

- [Getting Started](#getting-started)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [API Documentation](#api-documentation)

## Getting Started

To get started with the backend of the Data Archive System, follow these instructions:

### Features

- User authentication and authorization
- Document management and version control
- Access control with role-based permissions
- Notification and alert system
- Audit logging for system activity tracking

### Prerequisites

Before you begin, ensure you have met the following requirements:

- Python 3.7+
- [Django](https://www.djangoproject.com/)
- [MySQL](https://www.mysql.com/) or another supported database
- [Virtual environment](https://docs.python.org/3/library/venv.html) (recommended)

### Installation

Follow these steps to set up the backend:

1. Clone this repository to your local machine:

   ```bash
   git clone <repository-url>
    ```
2. Navigate to the project directory:

   ```bash
   cd backend
   ```
3. Create a virtual environment:

   ```bash
    python -m venv env
    ```
4. Activate the virtual environment:
5. Install the project dependencies:

   ```bash
   pip install -r requirements.txt
   ```
   
6. Create a `.env` file in the root directory of the project `data_archive/` and add the following environment variables:

   ```bash
    SECRET_KEY=
    DEBUG=True
    DATABASE_ENGINE=django.db.backends.sqlite3
    DATABASE_NAME=db
    DATABASE_USER=
    DATABASE_PASSWORD=
    DATABASE_HOST=
    DATABASE_PORT=
    ```
   
7. Run the database migrations:

   ```bash
   python manage.py migrate
   ```

8. Create a superuser account:

   ```bash
    python manage.py createsuperuser
    ```
   
9. Run the development server:

   ```bash
   python manage.py runserver
   ```

### API Documentation
To view the docs, navigate to `http://localhost:8000/docs/` in your browser.
