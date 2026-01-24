# main.py
from fastapi import FastAPI
import sqlite3
import os

app = FastAPI()

# Database initialization
DATABASE_NAME = "tailorshop.db"

def init_database():
    """Create database and tables if they don't exist"""
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    
    # Create your tables here later
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS test (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            message TEXT
        )
    ''')
    
    conn.commit()
    conn.close()

# Initialize database on startup
init_database()

@app.get("/")
def test_endpoint():
    return {"message": "Tailor Management System API is working"}

@app.get("/test-db")
def test_database():
    """Test database connection"""
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    cursor.execute("SELECT 'Database connected successfully'")
    result = cursor.fetchone()
    conn.close()
    return {"database_test": result[0]}

