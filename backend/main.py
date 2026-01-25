# main.py
from fastapi import FastAPI
import sqlite3

app = FastAPI()

# Database initialization
DATABASE_NAME = "tailorshop.db"

# main.py - Add this function after imports, before routes
def init_database():
    """Initialize database with all tables"""
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    
    # Create CUSTOMER table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS CUSTOMER (
            customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone_number TEXT NOT NULL UNIQUE,
            address TEXT,
            notes TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Create MEASUREMENT table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS MEASUREMENT (
            measurement_id INTEGER PRIMARY KEY AUTOINCREMENT,
            customer_id INTEGER NOT NULL,
            measurement_date DATE NOT NULL,
            garment_type TEXT NOT NULL CHECK(garment_type IN ('2-piece', '3-piece', 'prince-coat', 'shirt', 'pants', 'coat')),
            chest REAL,
            waist REAL,
            length REAL,
            shoulder REAL,
            arm_length REAL,
            arm_opening REAL,
            neck REAL,
            shalwar_length REAL,
            shalwar_bottom REAL,
            kamee_length REAL,
            hip REAL,
            kurta_length REAL,
            attribute TEXT,
            pajama_length REAL,
            pajama_bottom REAL,
            FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE
        )
    ''')
    
    # Create ORDER table (quoted because ORDER is a SQL keyword)
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS "ORDER" (
            order_id INTEGER PRIMARY KEY AUTOINCREMENT,
            customer_id INTEGER NOT NULL,
            measurement_id INTEGER NOT NULL,
            order_date DATE NOT NULL DEFAULT CURRENT_DATE,
            delivery_date DATE,
            total_amount REAL NOT NULL,
            advance_payment REAL DEFAULT 0,
            discount REAL DEFAULT 0,
            status TEXT NOT NULL DEFAULT 'order-book' 
                CHECK(status IN ('order-book', 'cutting', 'stitching', 'ready-to-deliver', 'delivered')),
            balance_due REAL GENERATED ALWAYS AS (total_amount - advance_payment - discount) VIRTUAL,
            notes TEXT,
            garment_type TEXT NOT NULL,
            FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE,
            FOREIGN KEY (measurement_id) REFERENCES MEASUREMENT(measurement_id)
        )
    ''')
    
    conn.commit()
    conn.close()
    print(f"Database '{DATABASE_NAME}' initialized successfully")

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

