DROP DATABASE IF EXISTS hr_bitemporal_system;

CREATE DATABASE hr_bitemporal_system 
    ENCODING 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
	TEMPLATE=template0;

-- btree_gist: Required for exclusion constraints with ranges
CREATE EXTENSION IF NOT EXISTS btree_gist;
-- periods: Temporal table support with PERIOD FOR and system versioning
CREATE EXTENSION IF NOT EXISTS periods;

CREATE TABLE departments (
    department_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    department_code VARCHAR(10) NOT NULL UNIQUE,
    location VARCHAR(100)
);

CREATE TABLE positions (
    position_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    position_title VARCHAR(100) NOT NULL UNIQUE,
    position_level VARCHAR(20) NOT NULL,
    min_salary NUMERIC(10,2),
    max_salary NUMERIC(10,2)
);

CREATE TABLE employees (
    employee_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL,
    hire_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    
    CONSTRAINT chk_employee_status CHECK (status IN ('Active', 'Terminated'))
);


CREATE TABLE salaries (
    salary_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    currency CHAR(3) DEFAULT 'USD',
    
    -- Application Time (Valid Time) - use standard column names
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL DEFAULT '9999-12-31',
    
    -- Audit
    change_reason VARCHAR(255),
    
    -- Foreign Keys
    CONSTRAINT fk_salary_employee 
        FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id) 
        ON DELETE CASCADE
);

-- Add Application Time Period
-- This creates a generated column for the period
SELECT periods.add_period('salaries', 'valid_time', 'valid_from', 'valid_to');

-- Add System Time Period (creates system_time_start and system_time_end columns)
SELECT periods.add_system_time_period('salaries', 'system_time_start', 'system_time_end');

-- Add System Versioning (creates history table and triggers)
SELECT periods.add_system_versioning('salaries');

SELECT periods.add_unique_key('salaries', ARRAY['employee_id'], 'valid_time');

-- ALTER TABLE salaries ADD CONSTRAINT salaries_no_overlaps
--     EXCLUDE USING gist (
--         employee_id WITH =,
--         daterange(valid_from, valid_to, '[)') WITH &&
--     );

CREATE INDEX idx_salaries_employee ON salaries(employee_id);
CREATE INDEX idx_salaries_valid_from ON salaries(valid_from);
CREATE INDEX idx_salaries_valid_to ON salaries(valid_to);

CREATE INDEX idx_salaries_history_employee ON salaries_history(employee_id);
CREATE INDEX idx_salaries_history_system_time_start ON salaries_history(system_time_start);
CREATE INDEX idx_salaries_history_system_time_end ON salaries_history(system_time_end);


CREATE TABLE employment_history (
    history_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    department_id INTEGER NOT NULL,
    position_id INTEGER NOT NULL,
    manager_id INTEGER,
    employment_type VARCHAR(20) NOT NULL DEFAULT 'Full-Time',
    
    -- Application Time
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL DEFAULT '9999-12-31',
    
    -- Audit
    change_reason VARCHAR(255),
    
    -- Foreign Keys
    CONSTRAINT fk_history_employee 
        FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_history_department 
        FOREIGN KEY (department_id) 
        REFERENCES departments(department_id) 
        ON DELETE RESTRICT,
    CONSTRAINT fk_history_position 
        FOREIGN KEY (position_id) 
        REFERENCES positions(position_id) 
        ON DELETE RESTRICT,
    CONSTRAINT fk_history_manager 
        FOREIGN KEY (manager_id) 
        REFERENCES employees(employee_id) 
        ON DELETE SET NULL
);


SELECT periods.add_period('employment_history', 'valid_time', 'valid_from', 'valid_to');
SELECT periods.add_system_time_period('employment_history', 'system_time_start', 'system_time_end');
SELECT periods.add_system_versioning('employment_history');
ALTER TABLE employment_history ADD CONSTRAINT employment_history_no_overlaps
    EXCLUDE USING gist (
        employee_id WITH =,
        daterange(valid_from, valid_to, '[)') WITH &&
    );

-- Indexes
CREATE INDEX idx_employment_history_employee ON employment_history(employee_id);
CREATE INDEX idx_employment_history_valid_from ON employment_history(valid_from);
CREATE INDEX idx_employment_history_valid_to ON employment_history(valid_to);

CREATE INDEX idx_employment_history_history_employee ON employment_history_history(employee_id);
CREATE INDEX idx_employment_history_history_system_time_start ON employment_history_history(system_time_start);
CREATE INDEX idx_employment_history_history_system_time_end ON employment_history_history(system_time_end);


CREATE TABLE benefits_enrollment (
    enrollment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    benefit_type VARCHAR(50) NOT NULL,
    coverage_level VARCHAR(20) DEFAULT 'Individual',
    monthly_cost NUMERIC(8,2),
    
    -- Application Time
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL DEFAULT '9999-12-31',
    
    -- Audit
    change_reason VARCHAR(255),
    
    -- Foreign Keys
    CONSTRAINT fk_benefits_employee 
        FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id) 
        ON DELETE CASCADE
);


SELECT periods.add_period('benefits_enrollment', 'valid_time', 'valid_from', 'valid_to');
SELECT periods.add_system_time_period('benefits_enrollment', 'system_time_start', 'system_time_end');
SELECT periods.add_system_versioning('benefits_enrollment');

ALTER TABLE benefits_enrollment ADD CONSTRAINT benefits_enrollment_no_overlaps
    EXCLUDE USING gist (
        employee_id WITH =,
        daterange(valid_from, valid_to, '[)') WITH &&
    );


-- Indexes
CREATE INDEX idx_benefits_enrollment_employee ON benefits_enrollment(employee_id);
CREATE INDEX idx_benefits_enrollment_valid_from ON benefits_enrollment(valid_from);
CREATE INDEX idx_benefits_enrollment_valid_to ON benefits_enrollment(valid_to);

CREATE INDEX idx_benefits_enrollment_history_employee ON benefits_enrollment_history(employee_id);
CREATE INDEX idx_benefits_enrollment_history_system_time_start ON benefits_enrollment_history(system_time_start);
CREATE INDEX idx_benefits_enrollment_history_system_time_end ON benefits_enrollment_history(system_time_end);

CREATE TABLE performance_reviews (
    review_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    reviewer_id INTEGER NOT NULL,
    review_period_start DATE NOT NULL,
    review_period_end DATE NOT NULL,
    review_date DATE NOT NULL,
    overall_rating NUMERIC(3,2) NOT NULL,
    comments TEXT,
    
    -- Application Time
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL DEFAULT '9999-12-31',
    
    -- Audit
    change_reason VARCHAR(255),
    
    -- Foreign Keys
    CONSTRAINT fk_review_employee 
        FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_review_reviewer 
        FOREIGN KEY (reviewer_id) 
        REFERENCES employees(employee_id) 
        ON DELETE RESTRICT
);

SELECT periods.add_period('performance_reviews', 'valid_time', 'valid_from', 'valid_to');
SELECT periods.add_system_time_period('performance_reviews', 'system_time_start', 'system_time_end');
SELECT periods.add_system_versioning('performance_reviews');

ALTER TABLE performance_reviews ADD CONSTRAINT performance_reviews_no_overlaps
    EXCLUDE USING gist (
        employee_id WITH =,
        daterange(valid_from, valid_to, '[)') WITH &&
    );

-- Indexes
CREATE INDEX idx_performance_reviews_employee ON performance_reviews(employee_id);
CREATE INDEX idx_performance_reviews_valid_from ON performance_reviews(valid_from);
CREATE INDEX idx_performance_reviews_valid_to ON performance_reviews(valid_to);

CREATE INDEX idx_performance_reviews_history_employee ON performance_reviews_history(employee_id);
CREATE INDEX idx_performance_reviews_history_system_time_start ON performance_reviews_history(system_time_end);
CREATE INDEX idx_performance_reviews_history_system_time_end ON performance_reviews_history(system_time_end);

