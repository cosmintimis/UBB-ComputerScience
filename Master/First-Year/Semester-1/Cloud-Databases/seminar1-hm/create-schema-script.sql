DROP DATABASE IF EXISTS hr_bitemporal_system;

-- Create database
CREATE DATABASE hr_bitemporal_system 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;

USE hr_bitemporal_system;


-- Create tables

CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    department_code VARCHAR(10) NOT NULL UNIQUE,
    location VARCHAR(100)
)  ENGINE=INNODB;

CREATE TABLE positions (
    position_id INT PRIMARY KEY AUTO_INCREMENT,
    position_title VARCHAR(100) NOT NULL UNIQUE,
    position_level VARCHAR(20) NOT NULL,
    min_salary DECIMAL(10,2),
    max_salary DECIMAL(10,2)
) ENGINE=InnoDB;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL,
    hire_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    
    CONSTRAINT chk_employee_status CHECK (status IN ('Active', 'Terminated'))
) ENGINE=InnoDB;

CREATE TABLE salaries (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    
    valid_start DATE NOT NULL,
    valid_end DATE NOT NULL DEFAULT '9999-12-31',
    transaction_start DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transaction_end DATETIME NOT NULL DEFAULT '9999-12-31 23:59:59',
    
    change_reason VARCHAR(255),
    
    CONSTRAINT fk_salary_employee FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id) ON DELETE CASCADE,
    CONSTRAINT chk_salary_amount CHECK (amount > 0),
    CONSTRAINT chk_salary_valid_period CHECK (valid_start <= valid_end),
    CONSTRAINT chk_salary_transaction_period CHECK (transaction_start <= transaction_end),
    
    INDEX idx_salary_current (employee_id, transaction_end),
    INDEX idx_salary_bitemporal (employee_id, valid_start, valid_end, 
                                 transaction_start, transaction_end)
) ENGINE=InnoDB;

CREATE TABLE employment_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    department_id INT NOT NULL,
    position_id INT NOT NULL,
    manager_id INT,
    employment_type VARCHAR(20) NOT NULL DEFAULT 'Full-Time',
    
    valid_start DATE NOT NULL,
    valid_end DATE NOT NULL DEFAULT '9999-12-31',
    transaction_start DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transaction_end DATETIME NOT NULL DEFAULT '9999-12-31 23:59:59',
    
    change_reason VARCHAR(255),
    
    CONSTRAINT fk_history_employee FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_history_department FOREIGN KEY (department_id) 
        REFERENCES departments(department_id) ON DELETE RESTRICT,
    CONSTRAINT fk_history_position FOREIGN KEY (position_id) 
        REFERENCES positions(position_id) ON DELETE RESTRICT,
    CONSTRAINT fk_history_manager FOREIGN KEY (manager_id) 
        REFERENCES employees(employee_id) ON DELETE SET NULL,
    CONSTRAINT chk_history_valid_period CHECK (valid_start <= valid_end),
    CONSTRAINT chk_history_transaction_period CHECK (transaction_start <= transaction_end),
    
    INDEX idx_history_current (employee_id, transaction_end),
    INDEX idx_history_bitemporal (employee_id, valid_start, valid_end, 
                                  transaction_start, transaction_end)
) ENGINE=InnoDB;


CREATE TABLE benefits_enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    benefit_type VARCHAR(50) NOT NULL,
    coverage_level VARCHAR(20) DEFAULT 'Individual',
    monthly_cost DECIMAL(8,2),
    
    valid_start DATE NOT NULL,
    valid_end DATE NOT NULL DEFAULT '9999-12-31',
    transaction_start DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transaction_end DATETIME NOT NULL DEFAULT '9999-12-31 23:59:59',
    
    change_reason VARCHAR(255),
    
    CONSTRAINT fk_benefits_employee FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id) ON DELETE CASCADE,
    CONSTRAINT chk_benefits_valid_period CHECK (valid_start <= valid_end),
    CONSTRAINT chk_benefits_transaction_period CHECK (transaction_start <= transaction_end),
    CONSTRAINT chk_benefits_cost CHECK (monthly_cost >= 0),
    
    INDEX idx_benefits_current (employee_id, transaction_end),
    INDEX idx_benefits_bitemporal (employee_id, valid_start, valid_end, 
                                   transaction_start, transaction_end)
) ENGINE=InnoDB;

CREATE TABLE performance_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    reviewer_id INT NOT NULL,
    review_period_start DATE NOT NULL,
    review_period_end DATE NOT NULL,
    review_date DATE NOT NULL,
    overall_rating DECIMAL(3,2) NOT NULL,
    comments TEXT,
    
    valid_start DATE NOT NULL,
    valid_end DATE NOT NULL DEFAULT '9999-12-31',
    transaction_start DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transaction_end DATETIME NOT NULL DEFAULT '9999-12-31 23:59:59',
    
    change_reason VARCHAR(255),
    
    CONSTRAINT fk_review_employee FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_review_reviewer FOREIGN KEY (reviewer_id) 
        REFERENCES employees(employee_id) ON DELETE RESTRICT,
    CONSTRAINT chk_review_period CHECK (review_period_start <= review_period_end),
    CONSTRAINT chk_review_valid_period CHECK (valid_start <= valid_end),
    CONSTRAINT chk_review_transaction_period CHECK (transaction_start <= transaction_end),
    CONSTRAINT chk_review_rating CHECK (overall_rating BETWEEN 1.00 AND 5.00),
    
    INDEX idx_review_current (employee_id, transaction_end),
    INDEX idx_review_bitemporal (employee_id, valid_start, valid_end, 
                                 transaction_start, transaction_end)
) ENGINE=InnoDB;