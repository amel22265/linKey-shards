from email import errors
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from passlib.context import CryptContext
from database import get_db
from psycopg2 import errors as pg_errors

router = APIRouter() 
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Shape of the data the frontend will send
class SignupData(BaseModel):
    name: str
    username: str
    email: str
    password: str
    
@router.post("/signup", status_code=201)
def signup(data: SignupData):
    conn = get_db()
    cursor = conn.cursor()

    try:
         # Check if username already exists
        cursor.execute(
        "SELECT id FROM users WHERE username = %s",
        (data.username,)
    )
        if cursor.fetchone():
            raise HTTPException(
            status_code=400,
            detail="Username already registered"
        )
        # Check if email already exists
        cursor.execute(
            "SELECT id FROM users WHERE email = %s",
            (data.email,)
        )
        if cursor.fetchone():
            raise HTTPException(
                status_code=400,
                detail="Email already registered"
            )

        # Hash the password — never store plain text
        hashed = pwd_context.hash(data.password)

        # Save the new user
        cursor.execute(
              "INSERT INTO users (username, email, password_hash,full_name)"
            " VALUES (%s, %s, %s, %s)",
            (data.username,data.email, hashed,data.name )
        )
        conn.commit()
        return {"message": "Account created"}

    except pg_errors.UniqueViolation as e:
        conn.rollback()
        constraint = e.diag.constraint_name
        if constraint == "users_username_key":
            raise HTTPException(status_code=400, detail="Username already registered")
        elif constraint == "users_email_key":
         raise HTTPException(status_code=400, detail="Email already registered")
        raise HTTPException(status_code=400, detail="User already exists")

    finally:
        cursor.close()
        conn.close()
