CREATE DATABASE IF NOT EXISTS CCMS_DB;
USE CCMS_DB;

CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255),
    role ENUM('student', 'staff', 'admin') NOT NULL,
    department_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL
);

CREATE TABLE Complaint_Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE Complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_code VARCHAR(30) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category_id INT,
    department_id INT,
    submitted_by INT,
    assigned_to INT,
    is_anonymous BOOLEAN DEFAULT FALSE,
    status ENUM('submitted', 'in_review', 'in_progress', 'resolved', 'rejected') DEFAULT 'submitted',
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (category_id) REFERENCES Complaint_Categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL,
    FOREIGN KEY (submitted_by) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_to) REFERENCES Users(user_id) ON DELETE SET NULL
);

CREATE TABLE Complaint_Status_History (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    old_status ENUM('submitted', 'in_review', 'in_progress', 'resolved', 'rejected'),
    new_status ENUM('submitted', 'in_review', 'in_progress', 'resolved', 'rejected') NOT NULL,
    changed_by INT,
    remarks TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES Complaints(complaint_id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES Users(user_id) ON DELETE SET NULL
);

CREATE TABLE Complaint_Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    user_id INT,
    comment_text TEXT NOT NULL,
    is_internal BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES Complaints(complaint_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

INSERT INTO Departments (department_id, department_name)
VALUES
(1, 'Academic'),
(2, 'Administration'),
(3, 'Information Technology'),
(4, 'Maintenance');

INSERT INTO Users (full_name, email, password_hash, role)
VALUES
('Rahul Sharma', 'rahul@example.com', 'demo_hash_1', 'student'),
('Priya Singh', 'priya@example.com', 'demo_hash_2', 'staff'),
('Aman Verma', 'aman@example.com', 'demo_hash_3', 'admin'),
('Sneha Patel', 'sneha@example.com', 'demo_hash_4', 'student'),
('Karan Mehta', 'karan@example.com', 'demo_hash_5', 'staff');

INSERT INTO Complaint_Categories (category_id, category_name, description)
VALUES
(1, 'Infrastructure', 'Issues related to campus infrastructure');

INSERT INTO Complaints (
    complaint_code, title, description, category_id, department_id,
    submitted_by, assigned_to, is_anonymous, status, priority
)
VALUES (
    'CCMS-2026-0001',
    'Poor classroom maintenance',
    'The classroom requires proper maintenance and repair.',
    1, 4, NULL, NULL, TRUE, 'submitted', 'high'
);

INSERT INTO Complaint_Status_History (
    complaint_id, old_status, new_status, changed_by, remarks
)
VALUES (
    1, NULL, 'submitted', 3, 'Complaint successfully submitted.'
);

INSERT INTO Complaint_Comments (
    complaint_id, user_id, comment_text, is_internal
)
VALUES (
    1, 3, 'The complaint has been received for review.', FALSE
);

SHOW TABLES;

DESC Departments;
DESC Users;
DESC Complaint_Categories;
DESC Complaints;
DESC Complaint_Status_History;
DESC Complaint_Comments;

SELECT * FROM Departments;
SELECT * FROM Users;
SELECT * FROM Complaint_Categories;
SELECT * FROM Complaints;
SELECT * FROM Complaint_Status_History;
SELECT * FROM Complaint_Comments;

SELECT
    c.complaint_id,
    c.complaint_code,
    c.title,
    cc.category_name,
    d.department_name,
    CASE
        WHEN c.is_anonymous = TRUE THEN 'Anonymous'
        ELSE COALESCE(u.full_name, 'Unknown')
    END AS submitted_by,
    staff.full_name AS assigned_staff,
    c.status,
    c.priority
FROM Complaints c
LEFT JOIN Complaint_Categories cc ON c.category_id = cc.category_id
LEFT JOIN Departments d ON c.department_id = d.department_id
LEFT JOIN Users u ON c.submitted_by = u.user_id
LEFT JOIN Users staff ON c.assigned_to = staff.user_id
ORDER BY c.complaint_id;
