# 🧪 Robot Framework + PostgreSQL CRUD Testing (with Docker)

โปรเจกต์นี้สาธิตการเขียน Test Automation แบบครบวงจร ด้วย **Robot Framework**  
เพื่อทดสอบ **ฐานข้อมูล PostgreSQL** ผ่านคำสั่ง SQL (CRUD)  
ใช้งานได้ทันทีผ่าน Docker โดยไม่ต้องติดตั้ง PostgreSQL เองบนเครื่อง

---

## 🧠 ทำไมต้องใช้โปรเจกต์นี้?

- ✅ ทดสอบระบบฐานข้อมูล (Database) ได้อย่างอัตโนมัติ
- ✅ ไม่ต้องติดตั้ง PostgreSQL เอง
- ✅ เขียน test case ได้แบบ readable และ repeatable
- ✅ ฝึกแนวคิด Test Automation + Database Integration Test

---

## 🐳 Docker คืออะไร?

**Docker** คือเครื่องมือที่สร้าง “Container” ซึ่งเปรียบเหมือนกล่องจำลองระบบ  
คุณสามารถติดตั้ง PostgreSQL, API, หรือ App ใด ๆ ไว้ในกล่องนี้ และรันได้โดยไม่รบกวนเครื่องของคุณ

### 🔧 ข้อดีของ Docker:
- ✅ ไม่ต้องติดตั้งโปรแกรมจริง
- ✅ รันซ้ำได้เสมอ ทุกเครื่องเหมือนกัน
- ✅ Portable ย้ายไปไหนก็ได้
- ✅ ใช้งานคู่กับระบบ CI/CD ได้ดี

---

## 🤖 `robotframework-databaselibrary` คืออะไร?

เป็นไลบรารีของ **Robot Framework** สำหรับการ:
- เชื่อมต่อฐานข้อมูล (PostgreSQL, MySQL, SQLite, Oracle)
- รันคำสั่ง SQL เช่น `SELECT`, `INSERT`, `UPDATE`, `DELETE`
- ตรวจสอบผลลัพธ์ผ่าน `Should Be Equal`, `Row Count` ฯลฯ

### 🧩 รองรับฐานข้อมูล:
| Database     | Python driver ที่ต้องติดตั้ง |
|--------------|------------------------------|
| PostgreSQL   | `psycopg2` หรือ `psycopg2-binary` |
| MySQL/MariaDB| `pymysql`                    |
| Oracle       | `cx_Oracle`       |
| MSSQL        | `pyodbc`      |

---

## 📁 โครงสร้างโปรเจกต์
- project_folder/
- ├── docker-compose.yml # รัน PostgreSQL ด้วย Docker
- ├── init.sql # SQL สร้างตาราง + ข้อมูลตั้งต้น
- └── db_test.robot # Robot Framework test case

---

## 🚀 ขั้นตอนการใช้งาน
 
### ✅ STEP 1: เตรียมเครื่องมือ

ติดตั้ง:
- Python 3.7+
- Docker Desktop → [ดาวน์โหลด](https://www.docker.com/products/docker-desktop)
  ---> เปิด Docker Desktop ให้ running ไว้ด้วยนะครับ

ติดตั้ง databaselibrary:
```bash
pip3 install robotframework robotframework-databaselibrary
pip3 install robotframework robotframework-databaselibrary psycopg2
```

### ✅ STEP 2: สร้าง Database ด้วย Docker

```bash
docker-compose up -d
```
📌 สิ่งที่จะเกิดขึ้น:
- สร้าง PostgreSQL ที่ localhost:5432
- สร้าง database ชื่อ testdb
- ผู้ใช้: robot / รหัสผ่าน: robot123
- โหลด init.sql อัตโนมัติ

---

### ✅ STEP 3: ตรวจสอบว่า PostgreSQL พร้อมใช้งาน
```bash
docker-compose up -d  หรือ  docker ps
```
ควรเห็น container ชื่อ robot_postgres แสดงว่า PostgreSQL พร้อมใช้งาน

### ✅ STEP 4: รันทดสอบด้วย Robot Framework
```bash
robot -d result_db db_test.robot
```

สิ่งที่จะเกิดขึ้นใน test:
- เชื่อมต่อ PostgreSQL
- UPSERT Jacob (insert ถ้าไม่มี, update ถ้ามี)
- SELECT และแสดงข้อมูลทุกคน
- UPDATE สถานะ Jacob → active
- DELETE Jacob และเช็คว่าหายไป
- SELECT อีกครั้งเพื่อแสดงข้อมูลที่เหลือ
- Disconnect ออกจากฐานข้อมูล

### ✅ STEP 5: ปิด PostgreSQL Container
```bash
docker-compose down
```

ถ้าต้องการล้างข้อมูลทั้งหมด:
```bash
docker-compose down -v
```

---