
CREATE DATABASE IF NOT EXISTS CCMS_DB;
USE CCMS_DB;

CREATE TABLE IF NOT EXISTS Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255),
    role ENUM('student', 'staff', 'admin') NOT NULL,
    department_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (department_id)
        REFERENCES Departments(department_id)
        ON DELETE SET NULL
);


CREATE TABLE IF NOT EXISTS Complaint_Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);


CREATE TABLE IF NOT EXISTS Complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_code VARCHAR(30) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category_id INT,
    department_id INT,
    submitted_by INT NULL,
    is_anonymous BOOLEAN DEFAULT FALSE,
    assigned_to INT NULL,

    status ENUM(
        'submitted',
        'in_review',
        'in_progress',
        'resolved',
        'rejected'
    ) DEFAULT 'submitted',

    priority ENUM(
        'low',
        'medium',
        'high',
        'urgent'
    ) DEFAULT 'medium',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,

    FOREIGN KEY (category_id)
        REFERENCES Complaint_Categories(category_id)
        ON DELETE SET NULL,

    FOREIGN KEY (department_id)
        REFERENCES Departments(department_id)
        ON DELETE SET NULL,

    FOREIGN KEY (submitted_by)
        REFERENCES Users(user_id)
        ON DELETE SET NULL,

    FOREIGN KEY (assigned_to)
        REFERENCES Users(user_id)
        ON DELETE SET NULL
);


CREATE TABLE IF NOT EXISTS Complaint_Status_History (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    old_status VARCHAR(30),
    new_status VARCHAR(30) NOT NULL,
    changed_by INT NULL,
    remarks TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (complaint_id)
        REFERENCES Complaints(complaint_id)
        ON DELETE CASCADE,

    FOREIGN KEY (changed_by)
        REFERENCES Users(user_id)
        ON DELETE SET NULL
);


CREATE TABLE IF NOT EXISTS Complaint_Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    user_id INT NULL,
    comment_text TEXT NOT NULL,
    is_internal BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (complaint_id)
        REFERENCES Complaints(complaint_id)
        ON DELETE CASCADE,

    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE SET NULL
);


INSERT IGNORE INTO Departments (department_name)
VALUES
('Computer Science'),
('Mechanical Engineering'),
('Electrical Engineering'),
('Administration');


INSERT IGNORE INTO Complaint_Categories
(category_name, description)
VALUES
('Infrastructure', 'Issues related to campus buildings and facilities'),
('Academics', 'Academic and examination related complaints'),
('Hostel', 'Hostel facilities and accommodation issues'),
('Transport', 'College transportation related issues'),
('Cleanliness', 'Campus hygiene and sanitation issues'),
('Other', 'Other campus related complaints');

INSERT INTO Complaints (
    complaint_code,
    title,
    description,
    category_id,
    department_id,
    submitted_by,
    is_anonymous,
    priority
)
VALUES (
    'CCMS-2026-0001',
    'Poor classroom maintenance',
    'Classroom projectors are not working properly.',
    1,
    4,
    NULL,
    TRUE,
    'high'
);


SHOW TABLES;
SELECT * FROM Departments;
SELECT * FROM Complaint_Categories;
SELECT * FROM Complaints;
SELECT * FROM Complaint_Status_History;
SELECT * FROM Complaint_Comments;
USE CCMS_DB;
SELECT * FROM Complaints;