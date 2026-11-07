from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, EmailStr
import bcrypt
from database import get_db
from auth.jwt_handler import create_access_token

router = APIRouter()


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


@router.post("/login")
def login(data: LoginRequest):
    conn = get_db()
    cur = conn.cursor()

    cur.execute(
        "SELECT id, password_hash FROM users WHERE email = %s",
        (data.email,)
    )
    user = cur.fetchone()

    cur.close()
    conn.close()

    if user is None:
        raise HTTPException(status_code=401, detail="Invalid email or password")

    user_id, password_hash = user

    password_matches = bcrypt.checkpw(
        data.password.encode("utf-8"),
        password_hash.encode("utf-8")
    )

    if not password_matches:
        raise HTTPException(status_code=401, detail="Invalid email or password")

    token = create_access_token({"sub": str(user_id)})

    return {"access_token": token, "token_type": "bearer"}