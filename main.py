from fastapi import FastAPI,Depends
from auth.dependencies import get_current_user
from fastapi.middleware.cors import CORSMiddleware
from auth import signup, login

app = FastAPI()

app.include_router(signup.router, prefix="/auth", tags=["auth"])
app.include_router(login.router, prefix="/auth", tags=["auth"])

# Allow frontend to talk to backend (we'll use this when we build HTML)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://127.0.0.1:5500"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
@app.get("/me")
async def get_me(current_user: dict = Depends(get_current_user)):
    return current_user
@app.get("/")
def read_root():
    return {"message": "Backend is running"}
