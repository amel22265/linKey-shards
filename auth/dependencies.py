# function tverifi token
import os
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import JWTError, jwt
from database import get_db 

bearer_scheme = HTTPBearer()

SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = "HS256"

async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme)):
    token = credentials.credentials
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    conn = get_db()
    cursor = conn.cursor()
    cursor.execute(
        "SELECT id, full_name, email FROM users WHERE id = %s",
        (int(user_id),)
    ) 
    user = cursor.fetchone()
    cursor.close()
    conn.close() 
    

    if user is None:
        raise credentials_exception

    return {"id": user[0], "full_name": user[1], "email": user[2]}