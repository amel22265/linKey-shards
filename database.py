import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()  # reads .env file

def get_db():
    conn = psycopg2.connect(os.getenv("DATABASE_URL"))
    return conn