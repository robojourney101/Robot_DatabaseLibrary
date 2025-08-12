*** Settings ***
Library    DatabaseLibrary
Library    Collections

*** Variables ***
${DB_API}        psycopg2
${DB_NAME}       testdb
${DB_USER}       robot
${DB_PASSWORD}   robot123
${DB_HOST}       localhost
${DB_PORT}       5432

*** Test Cases ***
Test CRUD with Local PostgreSQL
    Connect To Database    ${DB_API}    ${DB_NAME}    ${DB_USER}    ${DB_PASSWORD}    ${DB_HOST}    ${DB_PORT}

    # UPSERT: Insert หรือ Update 'Jacob'
    Execute Sql String    
    ...    INSERT INTO users (role, name, status) VALUES ('guest', 'Jacob', 'pending')
    ...    ON CONFLICT (name) DO UPDATE SET status = EXCLUDED.status;

    # SELECT ALL
    ${result}=    Query    SELECT * FROM users 
    FOR    ${row}    IN    @{result}
        Log    ID=${row[0]} | Role=${row[1]} | Name=${row[2]} | Status=${row[3]}
    END

    # ตรวจสอบว่า Jacob มีสถานะ pending
    ${result}=    Query    SELECT status FROM users WHERE name = 'Jacob'
    Should Be Equal As Strings    ${result[0][0]}    pending

    # UPDATE Jacob เป็น active
    Execute Sql String    UPDATE users SET status='active' WHERE name='Jacob'
    ${updated}=    Query    SELECT status FROM users WHERE name = 'Jacob'
    Should Be Equal As Strings    ${updated[0][0]}    active

    # DELETE Jacob ออก
    Execute Sql String    DELETE FROM users WHERE name='Jacob'
    ${deleted}=    Query    SELECT COUNT(*) FROM users WHERE name = 'Jacob'
    Should Be Equal As Integers    ${deleted[0][0]}    ${0}

    # SELECT ALL อีกรอบ
    ${result}=    Query    SELECT * FROM users 
    FOR    ${row}    IN    @{result}
        Log    ID=${row[0]} | Role=${row[1]} | Name=${row[2]} | Status=${row[3]}
    END

    Disconnect From Database
