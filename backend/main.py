# main.py
from fastapi import FastAPI, HTTPException, Query
import sqlite3
from pydantic import BaseModel
from typing import Optional
from datetime import date, datetime
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods including OPTIONS
    allow_headers=["*"],
)

# Database initialization
DATABASE_NAME = "tailorshop.db"

# Pydantic Models
class CustomerCreate(BaseModel):
    name: str
    phone_number: str
    address: Optional[str] = None
    notes: Optional[str] = None

class CustomerResponse(CustomerCreate):
    customer_id: int
    created_at: datetime

class MeasurementCreate(BaseModel):
    customer_id: int
    measurement_date: date
    garment_type: str
    chest: Optional[float] = None
    waist: Optional[float] = None
    length: Optional[float] = None
    shoulder: Optional[float] = None
    arm_length: Optional[float] = None
    arm_opening: Optional[float] = None
    neck: Optional[float] = None
    shalwar_length: Optional[float] = None
    shalwar_bottom: Optional[float] = None
    kamee_length: Optional[float] = None
    hip: Optional[float] = None
    kurta_length: Optional[float] = None
    attribute: Optional[str] = None
    pajama_length: Optional[float] = None
    pajama_bottom: Optional[float] = None

class MeasurementResponse(MeasurementCreate):
    measurement_id: int

class OrderCreate(BaseModel):
    customer_id: int
    measurement_id: int
    order_date: date
    delivery_date: Optional[date] = None
    total_amount: float
    advance_payment: float = 0
    discount: float = 0
    status: str = "order-book"
    notes: Optional[str] = None
    garment_type: str

class OrderResponse(OrderCreate):
    order_id: int
    balance_due: float

# Update models
class CustomerUpdate(BaseModel):
    name: Optional[str] = None
    phone_number: Optional[str] = None
    address: Optional[str] = None
    notes: Optional[str] = None

class MeasurementUpdate(BaseModel):
    measurement_date: date
    garment_type: str
    chest: Optional[float] = None
    waist: Optional[float] = None
    length: Optional[float] = None
    shoulder: Optional[float] = None
    arm_length: Optional[float] = None
    arm_opening: Optional[float] = None
    neck: Optional[float] = None
    shalwar_length: Optional[float] = None
    shalwar_bottom: Optional[float] = None
    kamee_length: Optional[float] = None
    hip: Optional[float] = None
    kurta_length: Optional[float] = None
    attribute: Optional[str] = None
    pajama_length: Optional[float] = None
    pajama_bottom: Optional[float] = None

class OrderUpdate(BaseModel):
    delivery_date: Optional[date] = None
    total_amount: Optional[float] = None
    advance_payment: Optional[float] = None
    discount: Optional[float] = None
    status: Optional[str] = None
    notes: Optional[str] = None
    garment_type: Optional[str] = None

def init_database():
    """Initialize database with all tables"""
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    
    # Create CUSTOMER table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS CUSTOMER (
            customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone_number TEXT NOT NULL,
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

@app.get("/customers/", response_model=list[CustomerResponse])
def get_all_customers():
    """Get all customers - matches frontend API.customers.getAll()"""
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM CUSTOMER ORDER BY customer_id DESC')
    rows = cursor.fetchall()
    conn.close()
    
    return [{
        "customer_id": row[0],
        "name": row[1],
        "phone_number": row[2],
        "address": row[3],
        "notes": row[4],
        "created_at": row[5]
    } for row in rows]

@app.get("/customers/{customer_id}", response_model=CustomerResponse)
def get_customer(customer_id: int):
    """Get single customer by ID - matches frontend API.customers.getById()"""
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM CUSTOMER WHERE customer_id = ?', (customer_id,))
    row = cursor.fetchone()
    conn.close()

    if not row:
        raise HTTPException(status_code=404, detail="Customer not found")

    return {
        "customer_id": row[0],
        "name": row[1],
        "phone_number": row[2],
        "address": row[3],
        "notes": row[4],
        "created_at": row[5]
    }

@app.put("/customers/{customer_id}", response_model=CustomerResponse)
def update_customer(customer_id: int, customer: CustomerUpdate):
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    
    # Build dynamic update query
    updates = []
    values = []
    for field, value in customer.dict(exclude_unset=True).items():
        if value is not None:
            updates.append(f"{field} = ?")
            values.append(value)
    
    if not updates:
        raise HTTPException(status_code=400, detail="No fields to update")
    
    values.append(customer_id)
    query = f"UPDATE CUSTOMER SET {', '.join(updates)} WHERE customer_id = ?"
    cursor.execute(query, values)
    conn.commit()
    
    # Get updated customer
    cursor.execute('SELECT * FROM CUSTOMER WHERE customer_id = ?', (customer_id,))
    row = cursor.fetchone()
    conn.close()
    
    if not row:
        raise HTTPException(status_code=404, detail="Customer not found")
    
    return {
        "customer_id": row[0],
        "name": row[1],
        "phone_number": row[2],
        "address": row[3],
        "notes": row[4],
        "created_at": row[5]
    }

@app.delete("/customers/{customer_id}")
def delete_customer(customer_id: int):
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    cursor.execute('DELETE FROM CUSTOMER WHERE customer_id = ?', (customer_id,))
    conn.commit()
    deleted = cursor.rowcount
    conn.close()
    
    if deleted == 0:
        raise HTTPException(status_code=404, detail="Customer not found")
    
    return {"message": "Customer deleted successfully"}

@app.get("/measurements/", response_model=list[MeasurementResponse])
def get_all_measurements():
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM MEASUREMENT ORDER BY measurement_id DESC')
    rows = cursor.fetchall()
    conn.close()
    
    return [{
        "measurement_id": row[0],
        "customer_id": row[1],
        "measurement_date": row[2],
        "garment_type": row[3],
        "chest": row[4],
        "waist": row[5],
        "length": row[6],
        "shoulder": row[7],
        "arm_length": row[8],
        "arm_opening": row[9],
        "neck": row[10],
        "shalwar_length": row[11],
        "shalwar_bottom": row[12],
        "kamee_length": row[13],
        "hip": row[14],
        "kurta_length": row[15],
        "attribute": row[16],
        "pajama_length": row[17],
        "pajama_bottom": row[18]
    } for row in rows]

@app.get("/measurements/{measurement_id}", response_model=MeasurementResponse)
def get_measurement(measurement_id: int):
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM MEASUREMENT WHERE measurement_id = ?', (measurement_id,))
    row = cursor.fetchone()
    conn.close()
    
    if not row:
        raise HTTPException(status_code=404, detail="Measurement not found")
    
    return MeasurementResponse(**{
        "measurement_id": row[0],
        "customer_id": row[1],
        "measurement_date": row[2],
        "garment_type": row[3],
        "chest": row[4],
        "waist": row[5],
        "length": row[6],
        "shoulder": row[7],
        "arm_length": row[8],
        "arm_opening": row[9],
        "neck": row[10],
        "shalwar_length": row[11],
        "shalwar_bottom": row[12],
        "kamee_length": row[13],
        "hip": row[14],
        "kurta_length": row[15],
        "attribute": row[16],
        "pajama_length": row[17],
        "pajama_bottom": row[18]
    })

@app.put("/measurements/{measurement_id}", response_model=MeasurementResponse)
def update_measurement(measurement_id: int, measurement: MeasurementUpdate):
    """Update measurement - matches frontend API.measurements.update()"""
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()

    # Check measurement exists
    cursor.execute('SELECT * FROM MEASUREMENT WHERE measurement_id = ?', (measurement_id,))
    row = cursor.fetchone()
    if not row:
        conn.close()
        raise HTTPException(status_code=404, detail="Measurement not found")

    # Build dynamic update query
    updates = []
    values = []
    for field, value in measurement.dict(exclude_unset=True).items():
        updates.append(f"{field} = ?")
        values.append(value)

    values.append(measurement_id)
    query = f"UPDATE MEASUREMENT SET {', '.join(updates)} WHERE measurement_id = ?"
    cursor.execute(query, values)
    conn.commit()

    # Get updated measurement
    cursor.execute('SELECT * FROM MEASUREMENT WHERE measurement_id = ?', (measurement_id,))
    row = cursor.fetchone()
    conn.close()

    return {
        "measurement_id": row[0],
        "customer_id": row[1],
        "measurement_date": row[2],
        "garment_type": row[3],
        "chest": row[4],
        "waist": row[5],
        "length": row[6],
        "shoulder": row[7],
        "arm_length": row[8],
        "arm_opening": row[9],
        "neck": row[10],
        "shalwar_length": row[11],
        "shalwar_bottom": row[12],
        "kamee_length": row[13],
        "hip": row[14],
        "kurta_length": row[15],
        "attribute": row[16],
        "pajama_length": row[17],
        "pajama_bottom": row[18]
    }

@app.delete("/measurements/{measurement_id}")
def delete_measurement(measurement_id: int):
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    cursor.execute('DELETE FROM MEASUREMENT WHERE measurement_id = ?', (measurement_id,))
    conn.commit()
    deleted = cursor.rowcount
    conn.close()
    
    if deleted == 0:
        raise HTTPException(status_code=404, detail="Measurement not found")
    
    return {"message": "Measurement deleted successfully"}

@app.get("/orders/", response_model=list[OrderResponse])
def get_all_orders():
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM "ORDER" ORDER BY order_id DESC')
    rows = cursor.fetchall()
    conn.close()
    
    return [{
        "order_id": row[0],
        "customer_id": row[1],
        "measurement_id": row[2],
        "order_date": row[3],
        "delivery_date": row[4],
        "total_amount": row[5],
        "advance_payment": row[6],
        "discount": row[7],
        "status": row[8],
        "balance_due": row[9],
        "notes": row[10],
        "garment_type": row[11]
    } for row in rows]


@app.get("/orders/{order_id}", response_model=OrderResponse)
def get_order(order_id: int):
    """Get single order by ID - matches frontend API.orders.getById()"""
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM "ORDER" WHERE order_id = ?', (order_id,))
    row = cursor.fetchone()
    conn.close()

    if not row:
        raise HTTPException(status_code=404, detail="Order not found")

    return {
        "order_id": row[0],
        "customer_id": row[1],
        "measurement_id": row[2],
        "order_date": row[3],
        "delivery_date": row[4],
        "total_amount": row[5],
        "advance_payment": row[6],
        "discount": row[7],
        "status": row[8],
        "balance_due": row[9],
        "notes": row[10],
        "garment_type": row[11]
    }


@app.put("/orders/{order_id}", response_model=OrderResponse)
def update_order(order_id: int, order: OrderUpdate):
    """Update order - matches frontend API.orders.update()"""
    valid_statuses = ('order-book', 'cutting', 'stitching', 'ready-to-deliver', 'delivered')
    if order.status is not None and order.status not in valid_statuses:
        raise HTTPException(status_code=400, detail=f"Invalid status. Must be one of: {', '.join(valid_statuses)}")
    if order.total_amount is not None and order.total_amount < 0:
        raise HTTPException(status_code=400, detail="Total amount cannot be negative")
    if order.advance_payment is not None and order.advance_payment < 0:
        raise HTTPException(status_code=400, detail="Advance payment cannot be negative")
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()

    # Check order exists
    cursor.execute('SELECT * FROM "ORDER" WHERE order_id = ?', (order_id,))
    row = cursor.fetchone()
    if not row:
        conn.close()
        raise HTTPException(status_code=404, detail="Order not found")

    # Build dynamic update query
    updates = []
    values = []
    for field, value in order.dict(exclude_unset=True).items():
        if value is not None:
            updates.append(f"{field} = ?")
            values.append(value)

    if not updates:
        conn.close()
        raise HTTPException(status_code=400, detail="No fields to update")

    values.append(order_id)
    query = f'UPDATE "ORDER" SET {", ".join(updates)} WHERE order_id = ?'
    cursor.execute(query, values)
    conn.commit()

    # Get updated order
    cursor.execute('SELECT * FROM "ORDER" WHERE order_id = ?', (order_id,))
    row = cursor.fetchone()
    conn.close()

    return {
        "order_id": row[0],
        "customer_id": row[1],
        "measurement_id": row[2],
        "order_date": row[3],
        "delivery_date": row[4],
        "total_amount": row[5],
        "advance_payment": row[6],
        "discount": row[7],
        "status": row[8],
        "balance_due": row[9],
        "notes": row[10],
        "garment_type": row[11]
    }

@app.delete("/orders/{order_id}")
def delete_order(order_id: int):
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    cursor.execute('DELETE FROM "ORDER" WHERE order_id = ?', (order_id,))
    conn.commit()
    deleted = cursor.rowcount
    conn.close()
    
    if deleted == 0:
        raise HTTPException(status_code=404, detail="Order not found")
    
    return {"message": "Order deleted successfully"}

# 1. Search by Phone
@app.get("/search/phone/{phone_number}")
def search_by_phone(phone_number: str):
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    
    # Get customer by phone
    cursor.execute('SELECT * FROM CUSTOMER WHERE phone_number LIKE ?', (f"%{phone_number}%",))
    customer = cursor.fetchone()
    
    if not customer:
        conn.close()
        return {"message": "No customer found with this phone"}
    
    # Get customer's measurements
    cursor.execute('SELECT * FROM MEASUREMENT WHERE customer_id = ?', (customer[0],))
    measurements = cursor.fetchall()
    
    # Get customer's orders
    cursor.execute('SELECT * FROM "ORDER" WHERE customer_id = ?', (customer[0],))
    orders = cursor.fetchall()
    
    conn.close()
    
    return {
        "customer": {
            "id": customer[0],
            "name": customer[1],
            "phone": customer[2],
            "address": customer[3]
        },
        "measurements": [
            {
                "id": m[0],
                "garment_type": m[3],
                "measurement_date": m[2]
            } for m in measurements
        ],
        "orders": [
            {
                "id": o[0],
                "status": o[8],
                "order_date": o[3],
                "total_amount": o[5],
                "balance_due": o[9]
            } for o in orders
        ]
    }

# 2. Search by Name
@app.get("/search/name/{customer_name}")
def search_by_name(customer_name: str):
    conn = None
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    
    cursor.execute('SELECT * FROM CUSTOMER WHERE name LIKE ? ORDER BY name', (f"%{customer_name}%",))
    customers = cursor.fetchall()
    conn.close()
    
    if not customers:
        return {"message": "No customers found with this name"}
    
    return {
        "customers": [
            {
                "id": c[0],
                "name": c[1],
                "phone": c[2],
                "address": c[3],
                "created_at": c[5]
            } for c in customers
        ]
    }

# 3. Search by Garment Type
@app.get("/search/garment/{garment_type}")
def search_by_garment_type(garment_type: str):
    conn = None
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    
    # Get measurements of this garment type
    cursor.execute('SELECT * FROM MEASUREMENT WHERE garment_type = ?', (garment_type,))
    measurements = cursor.fetchall()
    
    # Get orders of this garment type
    cursor.execute('SELECT * FROM "ORDER" WHERE garment_type = ?', (garment_type,))
    orders = cursor.fetchall()
    
    conn.close()
    
    return {
        "measurements": [
            {
                "id": m[0],
                "customer_id": m[1],
                "measurement_date": m[2]
            } for m in measurements
        ],
        "orders": [
            {
                "id": o[0],
                "customer_id": o[1],
                "status": o[8],
                "order_date": o[3]
            } for o in orders
        ]
    }

# search by date
@app.get("/search/date/")
def search_by_date(
    date_str: str = Query(..., description="Date to search for (YYYY-MM-DD)")
):
    """Search by order date - returns customers who have orders on this date with all their data"""
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    
    try:
        search_date = datetime.strptime(date_str, "%Y-%m-%d").date()
        
        # Get orders on this date
        cursor.execute('SELECT * FROM "ORDER" WHERE order_date = ? ORDER BY order_id DESC', (search_date,))
        orders = cursor.fetchall()
        
        if not orders:
            conn.close()
            return {"message": f"No orders found on date {search_date}"}
        
        # Get unique customer IDs from these orders
        customer_ids = list(set([order[1] for order in orders]))
        
        result = []
        for customer_id in customer_ids:
            # Get customer details
            cursor.execute('SELECT * FROM CUSTOMER WHERE customer_id = ?', (customer_id,))
            customer = cursor.fetchone()
            
            if customer:
                # Get customer's measurements
                cursor.execute('SELECT * FROM MEASUREMENT WHERE customer_id = ?', (customer_id,))
                measurements = cursor.fetchall()
                
                # Get customer's orders (all orders, not just the date searched)
                cursor.execute('SELECT * FROM "ORDER" WHERE customer_id = ? ORDER BY order_id DESC', (customer_id,))
                all_orders = cursor.fetchall()
                
                result.append({
                    "customer": {
                        "customer_id": customer[0],
                        "name": customer[1],
                        "phone_number": customer[2],
                        "address": customer[3],
                        "notes": customer[4],
                        "created_at": customer[5]
                    },
                    "measurements": [
                        {
                            "measurement_id": m[0],
                            "customer_id": m[1],
                            "measurement_date": m[2],
                            "garment_type": m[3],
                            "chest": m[4],
                            "waist": m[5],
                            "length": m[6],
                            "shoulder": m[7],
                            "arm_length": m[8],
                            "arm_opening": m[9],
                            "neck": m[10],
                            "shalwar_length": m[11],
                            "shalwar_bottom": m[12],
                            "kamee_length": m[13],
                            "hip": m[14],
                            "kurta_length": m[15],
                            "attribute": m[16],
                            "pajama_length": m[17],
                            "pajama_bottom": m[18]
                        } for m in measurements
                    ],
                    "orders": [
                        {
                            "order_id": o[0],
                            "customer_id": o[1],
                            "measurement_id": o[2],
                            "order_date": o[3],
                            "delivery_date": o[4],
                            "total_amount": o[5],
                            "advance_payment": o[6],
                            "discount": o[7],
                            "status": o[8],
                            "balance_due": o[9],
                            "notes": o[10],
                            "garment_type": o[11]
                        } for o in all_orders
                    ]
                })
        
        conn.close()
        return {"customers": result}
        
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format. Use YYYY-MM-DD")
# add customer
@app.post("/customers/", response_model=CustomerResponse)
def create_customer(customer: CustomerCreate):
    """Create customer - allows duplicate phone numbers"""
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    
    # Removed duplicate phone check - customers can have same phone numbers
    cursor.execute('''
        INSERT INTO CUSTOMER (name, phone_number, address, notes)
        VALUES (?, ?, ?, ?)
    ''', (customer.name, customer.phone_number, customer.address, customer.notes))
    
    conn.commit()
    customer_id = cursor.lastrowid
    
    # Fetch the created customer with created_at timestamp
    cursor.execute('SELECT * FROM CUSTOMER WHERE customer_id = ?', (customer_id,))
    row = cursor.fetchone()
    conn.close()
    
    return {
        "customer_id": row[0],
        "name": row[1],
        "phone_number": row[2],
        "address": row[3],
        "notes": row[4],
        "created_at": row[5]  # Get actual timestamp from database
    }

# add measurement
@app.post("/measurements/", response_model=MeasurementResponse)
def create_measurement(measurement: MeasurementCreate):
    """Create measurement - matches frontend API.measurements.create()"""
    valid_garment_types = ('2-piece', '3-piece', 'prince-coat', 'shirt', 'pants', 'coat')
    if measurement.garment_type not in valid_garment_types:
        raise HTTPException(status_code=400, detail=f"Invalid garment_type. Must be one of: {', '.join(valid_garment_types)}")
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO MEASUREMENT 
        (customer_id, measurement_date, garment_type, chest, waist, length, 
         shoulder, arm_length, arm_opening, neck, shalwar_length, shalwar_bottom, 
         kamee_length, hip, kurta_length, attribute, pajama_length, pajama_bottom)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (
        measurement.customer_id, measurement.measurement_date, measurement.garment_type,
        measurement.chest, measurement.waist, measurement.length,
        measurement.shoulder, measurement.arm_length, measurement.arm_opening,
        measurement.neck, measurement.shalwar_length, measurement.shalwar_bottom,
        measurement.kamee_length, measurement.hip, measurement.kurta_length,
        measurement.attribute, measurement.pajama_length, measurement.pajama_bottom
    ))
    conn.commit()
    measurement_id = cursor.lastrowid
    conn.close()
    
    return {
        "measurement_id": measurement_id,
        **measurement.dict()
    }

# add order
@app.post("/orders/", response_model=OrderResponse)
def create_order(order: OrderCreate):
    """Create order - matches frontend API.orders.create()"""
    valid_garment_types = ('2-piece', '3-piece', 'prince-coat', 'shirt', 'pants', 'coat')
    valid_statuses = ('order-book', 'cutting', 'stitching', 'ready-to-deliver', 'delivered')
    if order.garment_type not in valid_garment_types:
        raise HTTPException(status_code=400, detail=f"Invalid garment_type. Must be one of: {', '.join(valid_garment_types)}")
    if order.status not in valid_statuses:
        raise HTTPException(status_code=400, detail=f"Invalid status. Must be one of: {', '.join(valid_statuses)}")
    if order.total_amount < 0:
        raise HTTPException(status_code=400, detail="Total amount cannot be negative")
    if order.advance_payment < 0:
        raise HTTPException(status_code=400, detail="Advance payment cannot be negative")
    conn = sqlite3.connect(DATABASE_NAME)
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO "ORDER" 
        (customer_id, measurement_id, order_date, delivery_date, total_amount, 
         advance_payment, discount, status, notes, garment_type)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (
        order.customer_id, order.measurement_id, order.order_date,
        order.delivery_date, order.total_amount, order.advance_payment,
        order.discount, order.status, order.notes, order.garment_type
    ))
    conn.commit()
    order_id = cursor.lastrowid
    conn.close()
    
    return {
        "order_id": order_id,
        **order.dict(),
        "balance_due": order.total_amount - order.advance_payment - order.discount
    }