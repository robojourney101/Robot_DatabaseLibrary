CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    role TEXT NOT NULL,
    name TEXT NOT NULL UNIQUE,
    status TEXT NOT NULL
);

INSERT INTO users (role, name, status) VALUES
('admin', 'Kachain', 'active'),
('guest', 'John', 'inactive');
