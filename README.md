# LinKey Shards

> Shard by shard, until the badge is whole.

LinKey Shards is a gamified cybersecurity learning platform. Learners go through short courses, quizzes and hands-on labs, earn **shards** for every completed step, and collect shards into **badges** that mark bigger milestones. The platform also builds a CV that grows with the learner's progress.

A personal project to learn and practice cybersecurity and web development.
# Screenshots![Landing page](docs/landing.png)


   ![Member badge shard reveal](docs/member_badge.gif)

## Features.

| Area                           | Description                                                                                                                                                                       | Status    |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| Landing page                   | Presentation of the platform, links to log in / sign up                                                                                                                           | Done      |
| Authentication                 | Sign up and log in with hashed passwords and JWT access tokens and a member shard animation once the signup is complete.                                                          | Done      |
| Module 1: What's Cybersecurity | 5 pages: definition, CIA triad, real-world stats, four key words, how they connect                                                                                                | Done      |
| Module 2: Attack Types         | 6 pages: social engineering, software exploits, network disruption, access attacks, vocabulary, plus a phishing "attention to detail" test that awards the *Eye for Detail* badge | Done      |
| Shards and badges              | Shard progress per mo, badge reveal animation                                                                                                                                     | Prototype |
| Quizzes and labs               | Planned                                                                                                                                                                           | To do     |
| CV builder                     | Planned                                                                                                                                                                           | To do     |

## Tech stack

- **Frontend:** HTML, CSS, vanilla JavaScript (no framework)
- **Backend:** Python, FastAPI
- **Database:** PostgreSQL (via `psycopg2`)
- **Security:** bcrypt password hashing, JWT access tokens

## Project structure

```
Cybersecurity_learning_platform/
├── docs/ │ ├── landing.png # Screenshot used in the README 
│ └── badge-reveal.gif # Member badge shard reveal animation
├── front-end/
│   ├── index.html # Landing page: presents LinKey Shards and links to log in / sign up
│   ├── login.html
│   ├── signup.html
│   ├── style.css
│   ├── script.js
│   ├── auth.js
│   └── courses/
│       ├── module1.html
│       └── module2.html
├── auth/
│   ├── __init__.py
│   ├── dependencies.py
│   ├── jwt_handler.py
│   ├── login.py
│   └── signup.py
├── main.py              # FastAPI entry point
├── database.py          # PostgreSQL connection helper
├── requirements.txt
├── .env.example
└── .gitignore
```

## Getting started

### Prerequisites

- Python 3.10+
- PostgreSQL running locally
- Git

### 1. Clone the repository

```bash
git clone https://github.com/amel22265/linKey-shards.git
cd linKey-shards
```

### 2. Create a virtual environment and install dependencies

```bash
python -m venv venv
# Windows
venv\Scripts\activate
# Linux / macOS
source venv/bin/activate

pip install -r requirements.txt
```

### 3. Configure environment variables

Copy the example file and fill in your own values:

```bash
cp .env.example .env
```

| Variable       | Purpose                                                                                                                                               |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `DATABASE_URL` | PostgreSQL connection string, e.g. `postgresql://user:password@localhost:5432/dbname`                                                                 |
| `SECRET_KEY`   | Secret key used to sign JWT tokens. Generate one with `python -c "import secrets; print(secrets.token_hex(32))" or manually create a super long key ` |

### 4. Create the database table

The `users` table needs at least these columns: `id`, `username` (unique), `email` (unique), `password_hash`.

### 5. Run the backend

```bash
uvicorn main:app --reload
```

The API runs at `http://127.0.0.1:8000`. Interactive docs are available at `http://127.0.0.1:8000/docs`.

### 6. Open the frontend

Open `front-end/index.html` in your browser, or serve the folder:

```bash
cd front-end
python -m http.server 5500
```

Then visit `http://localhost:5500`.

## API overview

| Method | Endpoint | Description |
|---|---|---|
| POST | `/signup` | Create an account (`username`, `email`, `password`) |
| POST | `/login` | Authenticate (`email`, `password`) and receive a JWT access token |

## Security notes

- Passwords are hashed with bcrypt and never stored in plain text.
- Login returns the same error for an unknown email and a wrong password.
- Secrets live in `.env`, which is excluded from version control.

## Roadmap

- [x] Landing, login and signup pages
- [x] Signup and login endpoints
- [x] Connect forms to the API and store the token
- [x] Module 1 and Module 2 content
- [ ] Module 3: Cybersecurity jobs
- [ ] Shard and badge tracking per user
- [ ] Quizzes and hands-on labs
- [ ] CV builder

## Author

 Amel ben Hassen 
 https://www.linkedin.com/in/amel-ben-hassen-3a7477374/
 https://github.com/amel22265

