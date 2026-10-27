USE hr_bitemporal_system;


INSERT INTO departments (department_name, department_code, location) VALUES
('Information Technology', 'IT', 'Building A - Floor 3'),
('Human Resources', 'HR', 'Building B - Floor 1'),
('Finance', 'FIN', 'Building B - Floor 2'),
('Sales', 'SALES', 'Building C - Floor 1'),
('Marketing', 'MKT', 'Building C - Floor 2'),
('Operations', 'OPS', 'Building A - Floor 1');

INSERT INTO positions (position_title, position_level, min_salary, max_salary) VALUES
('Junior Developer', 'Entry', 40000.00, 55000.00),
('Junior Accountant', 'Entry', 38000.00, 50000.00),
('Sales Representative', 'Entry', 35000.00, 48000.00),
('Software Developer', 'Junior', 55000.00, 70000.00),
('Accountant', 'Junior', 50000.00, 65000.00),
('HR Specialist', 'Mid', 52000.00, 68000.00),
('Marketing Specialist', 'Mid', 54000.00, 70000.00),
('Senior Developer', 'Senior', 75000.00, 95000.00),
('Senior Accountant', 'Senior', 70000.00, 88000.00),
('Sales Manager', 'Manager', 80000.00, 105000.00),
('IT Manager', 'Manager', 90000.00, 120000.00),
('Finance Director', 'Director', 110000.00, 150000.00);

INSERT INTO employees (first_name, last_name, email, date_of_birth, hire_date, status) VALUES
('John', 'Smith', 'john.smith@company.com', '1990-03-15', '2020-01-15', 'Active'),
('Sarah', 'Johnson', 'sarah.johnson@company.com', '1988-07-22', '2019-06-01', 'Active'),
('Michael', 'Williams', 'michael.williams@company.com', '1992-11-08', '2021-03-10', 'Active'),
('Emily', 'Brown', 'emily.brown@company.com', '1995-05-30', '2022-08-01', 'Active'),
('David', 'Jones', 'david.jones@company.com', '1987-09-12', '2018-02-20', 'Active'),
('Lisa', 'Garcia', 'lisa.garcia@company.com', '1991-12-05', '2020-09-15', 'Active'),
('James', 'Martinez', 'james.martinez@company.com', '1993-04-18', '2021-11-01', 'Active'),
('Jennifer', 'Rodriguez', 'jennifer.rodriguez@company.com', '1989-08-25', '2019-04-12', 'Active'),
('Robert', 'Wilson', 'robert.wilson@company.com', '1994-01-30', '2022-01-10', 'Active'),
('Maria', 'Lopez', 'maria.lopez@company.com', '1990-06-14', '2020-05-20', 'Active'),
('William', 'Gonzalez', 'william.gonzalez@company.com', '1992-10-03', '2021-07-01', 'Active'),
('Patricia', 'Anderson', 'patricia.anderson@company.com', '1988-03-28', '2019-09-05', 'Active'),
('Richard', 'Thomas', 'richard.thomas@company.com', '1991-07-16', '2020-11-18', 'Active'),
('Linda', 'Taylor', 'linda.taylor@company.com', '1993-02-09', '2021-12-01', 'Active'),
('Charles', 'Moore', 'charles.moore@company.com', '1986-11-21', '2017-08-15', 'Active'),
('Barbara', 'Jackson', 'barbara.jackson@company.com', '1989-05-17', '2019-01-10', 'Active'),
('Thomas', 'White', 'thomas.white@company.com', '1991-09-23', '2020-03-01', 'Active'),
('Nancy', 'Harris', 'nancy.harris@company.com', '1987-12-11', '2018-06-15', 'Active'),
('Daniel', 'Martin', 'daniel.martin@company.com', '1994-04-06', '2022-02-01', 'Active'),
('Jessica', 'Thompson', 'jessica.thompson@company.com', '1990-08-19', '2020-07-10', 'Active'),
('Matthew', 'Garcia', 'matthew.garcia@company.com', '1992-01-25', '2021-04-20', 'Active'),
('Ashley', 'Martinez', 'ashley.martinez@company.com', '1988-06-30', '2019-10-05', 'Active'),
('Christopher', 'Robinson', 'christopher.robinson@company.com', '1993-11-14', '2022-05-01', 'Active'),
('Amanda', 'Clark', 'amanda.clark@company.com', '1990-02-28', '2020-01-20', 'Active'),
('Joshua', 'Lewis', 'joshua.lewis@company.com', '1987-07-05', '2018-09-10', 'Active'),
('Melissa', 'Lee', 'melissa.lee@company.com', '1992-10-18', '2021-06-01', 'Active'),
('Andrew', 'Walker', 'andrew.walker@company.com', '1989-03-22', '2019-11-15', 'Active'),
('Stephanie', 'Hall', 'stephanie.hall@company.com', '1991-08-07', '2020-08-01', 'Active'),
('Kevin', 'Allen', 'kevin.allen@company.com', '1988-12-13', '2019-03-20', 'Active'),
('Michelle', 'Young', 'michelle.young@company.com', '1994-05-26', '2022-04-10', 'Active'),
('Brian', 'Hernandez', 'brian.hernandez@company.com', '1990-09-09', '2020-10-05', 'Active'),
('Rebecca', 'King', 'rebecca.king@company.com', '1986-01-17', '2017-12-01', 'Active'),
('Edward', 'Wright', 'edward.wright@company.com', '1992-06-21', '2021-08-15', 'Active'),
('Donna', 'Lopez', 'donna.lopez@company.com', '1991-11-04', '2021-01-10', 'Active'),
('Ronald', 'Hill', 'ronald.hill@company.com', '1989-04-16', '2019-07-01', 'Active'),
('Kimberly', 'Scott', 'kimberly.scott@company.com', '1993-08-29', '2022-03-15', 'Active'),
('Jason', 'Green', 'jason.green@company.com', '1987-02-12', '2018-05-20', 'Active'),
('Deborah', 'Adams', 'deborah.adams@company.com', '1990-07-07', '2020-09-01', 'Active'),
('Mark', 'Baker', 'mark.baker@company.com', '1992-12-20', '2021-10-10', 'Active'),
('Laura', 'Gonzalez', 'laura.gonzalez@company.com', '1988-05-03', '2019-02-15', 'Active'),
('George', 'Nelson', 'george.nelson@company.com', '1991-09-15', '2020-12-01', 'Active'),
('Carol', 'Carter', 'carol.carter@company.com', '1994-01-28', '2022-06-01', 'Active'),
('Steven', 'Mitchell', 'steven.mitchell@company.com', '1989-06-11', '2019-08-10', 'Active'),
('Betty', 'Perez', 'betty.perez@company.com', '1990-10-24', '2020-04-15', 'Active'),
('Paul', 'Roberts', 'paul.roberts@company.com', '1992-03-07', '2021-05-01', 'Active'),
('Sandra', 'Turner', 'sandra.turner@company.com', '1988-07-19', '2019-12-10', 'Active'),
('Jack', 'Phillips', 'jack.phillips@company.com', '1991-01-31', '2020-06-20', 'Active'),
('Karen', 'Campbell', 'karen.campbell@company.com', '1989-11-08', '2019-05-15', 'Active'),
('Larry', 'Parker', 'larry.parker@company.com', '1993-04-21', '2021-09-01', 'Active'),
('Helen', 'Evans', 'helen.evans@company.com', '1987-08-14', '2018-11-20', 'Active');


-- Employee 1: John Smith - Normal salary progression (4 raises)
INSERT INTO salaries (employee_id, amount, valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(1, 50000.00, '2020-01-15', '2021-01-01', '2020-01-15 09:00:00', '2020-12-15 14:30:00', 'Initial hire'),
(1, 55000.00, '2021-01-01', '2022-01-01', '2020-12-15 14:30:00', '2021-12-10 10:15:00', 'Annual performance raise'),
(1, 60000.00, '2022-01-01', '2023-01-01', '2021-12-10 10:15:00', '2022-12-08 11:20:00', 'Annual performance raise'),
(1, 65000.00, '2023-01-01', '9999-12-31', '2022-12-08 11:20:00', '9999-12-31 23:59:59', 'Annual performance raise');

-- Employee 2: Sarah Johnson - With promotion
INSERT INTO salaries (employee_id, amount, valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(2, 70000.00, '2019-06-01', '2021-06-01', '2019-06-01 08:30:00', '2021-05-15 13:45:00', 'Initial hire'),
(2, 80000.00, '2021-06-01', '9999-12-31', '2021-05-15 13:45:00', '9999-12-31 23:59:59', 'Promotion to Senior Developer');

-- Employee 3: Michael Williams - BACKDATED raise (50 days late!)
INSERT INTO salaries (employee_id, amount, valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(3, 48000.00, '2021-03-10', '2023-01-01', '2021-03-10 10:00:00', '2023-02-20 16:30:00', 'Initial hire'),
(3, 56000.00, '2023-01-01', '9999-12-31', '2023-02-20 16:30:00', '9999-12-31 23:59:59', 'Annual raise - BACKDATED (late HR entry)');

-- Employee 4: Emily Brown - Simple current salary
INSERT INTO salaries (employee_id, amount, valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(4, 42000.00, '2022-08-01', '9999-12-31', '2022-08-01 11:00:00', '9999-12-31 23:59:59', 'Initial hire');

-- Employee 5: David Jones - BACKDATED raise (74 days late!)
INSERT INTO salaries (employee_id, amount, valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(5, 75000.00, '2018-02-20', '2022-01-01', '2018-02-20 09:15:00', '2022-03-15 14:20:00', 'Initial hire'),
(5, 85000.00, '2022-01-01', '9999-12-31', '2022-03-15 14:20:00', '9999-12-31 23:59:59', 'Senior level raise - backdated');

-- Employee 10: Maria Lopez
INSERT INTO salaries (employee_id, amount, valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(10, 59000.00, '2020-05-20', '9999-12-31', '2020-05-20 11:20:00', '2020-06-05 15:30:00', 'Initial hire'),
(10, 61000.00, '2020-05-20', '9999-12-31', '2020-06-05 15:30:00', '9999-12-31 23:59:59', 'Salary correction - amount was incorrect');

-- Employee 25: Joshua Lewis (Finance Director) - MULTIPLE RAISES
INSERT INTO salaries (employee_id, amount, valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(25, 110000.00, '2018-09-10', '2020-01-01', '2018-09-10 09:30:00', '2019-12-15 10:00:00', 'Initial hire - Finance Director'),
(25, 120000.00, '2020-01-01', '2022-01-01', '2019-12-15 10:00:00', '2021-12-10 11:30:00', 'Annual director raise'),
(25, 135000.00, '2022-01-01', '9999-12-31', '2021-12-10 11:30:00', '9999-12-31 23:59:59', 'Annual director raise');

INSERT INTO salaries (employee_id, amount, valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
-- IT Department (6-9, 11-15)
(6, 58000.00, '2020-09-15', '9999-12-31', '2020-09-15 08:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(7, 45000.00, '2021-11-01', '9999-12-31', '2021-11-01 10:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(8, 72000.00, '2019-04-12', '9999-12-31', '2019-04-12 09:15:00', '9999-12-31 23:59:59', 'Initial hire'),
(9, 44000.00, '2022-01-10', '9999-12-31', '2022-01-10 14:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(11, 53000.00, '2021-07-01', '9999-12-31', '2021-07-01 08:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(12, 69000.00, '2019-09-05', '9999-12-31', '2019-09-05 13:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(13, 57000.00, '2020-11-18', '9999-12-31', '2020-11-18 10:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(14, 46000.00, '2021-12-01', '9999-12-31', '2021-12-01 09:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(15, 95000.00, '2017-08-15', '9999-12-31', '2017-08-15 11:00:00', '9999-12-31 23:59:59', 'Initial hire - IT Manager'),

-- HR Department (16-23)
(16, 65000.00, '2019-01-10', '9999-12-31', '2019-01-10 09:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(17, 54000.00, '2020-03-01', '9999-12-31', '2020-03-01 10:15:00', '9999-12-31 23:59:59', 'Initial hire'),
(18, 70000.00, '2018-06-15', '9999-12-31', '2018-06-15 08:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(19, 43000.00, '2022-02-01', '9999-12-31', '2022-02-01 11:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(20, 62000.00, '2020-07-10', '9999-12-31', '2020-07-10 09:20:00', '9999-12-31 23:59:59', 'Initial hire'),
(21, 48000.00, '2021-04-20', '9999-12-31', '2021-04-20 14:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(22, 58000.00, '2019-10-05', '9999-12-31', '2019-10-05 10:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(23, 41000.00, '2022-05-01', '9999-12-31', '2022-05-01 13:15:00', '9999-12-31 23:59:59', 'Initial hire'),

-- Finance Department (24, 26-33)
(24, 52000.00, '2020-01-20', '9999-12-31', '2020-01-20 08:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(26, 49000.00, '2021-06-01', '9999-12-31', '2021-06-01 10:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(27, 74000.00, '2019-11-15', '9999-12-31', '2019-11-15 11:20:00', '9999-12-31 23:59:59', 'Initial hire'),
(28, 60000.00, '2020-08-01', '9999-12-31', '2020-08-01 08:15:00', '9999-12-31 23:59:59', 'Initial hire'),
(29, 71000.00, '2019-03-20', '9999-12-31', '2019-03-20 09:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(30, 40000.00, '2022-04-10', '9999-12-31', '2022-04-10 13:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(31, 56000.00, '2020-10-05', '9999-12-31', '2020-10-05 10:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(32, 88000.00, '2017-12-01', '9999-12-31', '2017-12-01 08:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(33, 47000.00, '2021-08-15', '9999-12-31', '2021-08-15 11:15:00', '9999-12-31 23:59:59', 'Initial hire'),

-- Sales Department (34-43)
(34, 38000.00, '2021-01-10', '9999-12-31', '2021-01-10 09:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(35, 92000.00, '2019-07-01', '9999-12-31', '2019-07-01 10:00:00', '9999-12-31 23:59:59', 'Initial hire - Sales Manager'),
(36, 36000.00, '2022-03-15', '9999-12-31', '2022-03-15 08:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(37, 85000.00, '2018-05-20', '9999-12-31', '2018-05-20 11:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(38, 37500.00, '2020-09-01', '9999-12-31', '2020-09-01 09:15:00', '9999-12-31 23:59:59', 'Initial hire'),
(39, 39000.00, '2021-10-10', '9999-12-31', '2021-10-10 14:20:00', '9999-12-31 23:59:59', 'Initial hire'),
(40, 86000.00, '2019-02-15', '9999-12-31', '2019-02-15 10:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(41, 38500.00, '2020-12-01', '9999-12-31', '2020-12-01 08:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(42, 35000.00, '2022-06-01', '9999-12-31', '2022-06-01 13:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(43, 88000.00, '2019-08-10', '9999-12-31', '2019-08-10 09:00:00', '9999-12-31 23:59:59', 'Initial hire'),

-- Marketing Department (44-47)
(44, 59000.00, '2020-04-15', '9999-12-31', '2020-04-15 10:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(45, 62000.00, '2021-05-01', '9999-12-31', '2021-05-01 09:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(46, 68000.00, '2019-12-10', '9999-12-31', '2019-12-10 11:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(47, 55000.00, '2020-06-20', '9999-12-31', '2020-06-20 08:15:00', '9999-12-31 23:59:59', 'Initial hire'),

-- Operations Department (48-50)
(48, 64000.00, '2019-05-15', '9999-12-31', '2019-05-15 10:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(49, 51000.00, '2021-09-01', '9999-12-31', '2021-09-01 09:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(50, 73000.00, '2018-11-20', '9999-12-31', '2018-11-20 11:45:00', '9999-12-31 23:59:59', 'Initial hire');


-- Employee 1: John Smith - Promotion scenario
INSERT INTO employment_history (employee_id, department_id, position_id, manager_id, employment_type, 
                                valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(1, 1, 1, 15, 'Full-Time', '2020-01-15', '2022-07-01', '2020-01-15 09:00:00', '2022-06-15 14:30:00', 'Initial hire'),
(1, 1, 4, 15, 'Full-Time', '2022-07-01', '9999-12-31', '2022-06-15 14:30:00', '9999-12-31 23:59:59', 'Promotion to Software Developer');

-- Employee 2: Sarah Johnson - Senior Developer
INSERT INTO employment_history (employee_id, department_id, position_id, manager_id, employment_type, 
                                valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(2, 1, 8, 15, 'Full-Time', '2019-06-01', '9999-12-31', '2019-06-01 08:30:00', '9999-12-31 23:59:59', 'Initial hire - Senior Developer');

-- Employee 3: Michael Williams - Junior Developer
INSERT INTO employment_history (employee_id, department_id, position_id, manager_id, employment_type, 
                                valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(3, 1, 1, 15, 'Full-Time', '2021-03-10', '9999-12-31', '2021-03-10 10:00:00', '9999-12-31 23:59:59', 'Initial hire');

-- Employee 4: Emily Brown - Junior Developer
INSERT INTO employment_history (employee_id, department_id, position_id, manager_id, employment_type, 
                                valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(4, 1, 1, 15, 'Full-Time', '2022-08-01', '9999-12-31', '2022-08-01 11:00:00', '9999-12-31 23:59:59', 'Initial hire');

-- Employee 5: David Jones - Manager change scenario (BACKDATED!)
INSERT INTO employment_history (employee_id, department_id, position_id, manager_id, employment_type, 
                                valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(5, 1, 8, 15, 'Full-Time', '2018-02-20', '2023-01-01', '2018-02-20 09:15:00', '2023-02-10 11:20:00', 'Initial hire - Senior Developer'),
(5, 1, 8, 2, 'Full-Time', '2023-01-01', '9999-12-31', '2023-02-10 11:20:00', '9999-12-31 23:59:59', 'Manager change - backdated entry');

-- Employees 6-15: IT Department
INSERT INTO employment_history (employee_id, department_id, position_id, manager_id, employment_type, 
                                valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(6, 1, 4, 15, 'Full-Time', '2020-09-15', '9999-12-31', '2020-09-15 08:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(7, 1, 1, 15, 'Full-Time', '2021-11-01', '9999-12-31', '2021-11-01 10:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(8, 1, 8, 15, 'Full-Time', '2019-04-12', '9999-12-31', '2019-04-12 09:15:00', '9999-12-31 23:59:59', 'Initial hire'),
(9, 1, 1, 15, 'Full-Time', '2022-01-10', '9999-12-31', '2022-01-10 14:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(10, 1, 4, 15, 'Full-Time', '2020-05-20', '9999-12-31', '2020-05-20 11:20:00', '9999-12-31 23:59:59', 'Initial hire'),
(11, 1, 4, 15, 'Full-Time', '2021-07-01', '9999-12-31', '2021-07-01 08:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(12, 1, 8, 15, 'Full-Time', '2019-09-05', '9999-12-31', '2019-09-05 13:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(13, 1, 4, 15, 'Full-Time', '2020-11-18', '9999-12-31', '2020-11-18 10:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(14, 1, 1, 15, 'Full-Time', '2021-12-01', '9999-12-31', '2021-12-01 09:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(15, 1, 11, NULL, 'Full-Time', '2017-08-15', '9999-12-31', '2017-08-15 11:00:00', '9999-12-31 23:59:59', 'Initial hire - IT Manager');

-- Employees 16-23: HR Department
INSERT INTO employment_history (employee_id, department_id, position_id, manager_id, employment_type, 
                                valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(16, 2, 6, 18, 'Full-Time', '2019-01-10', '9999-12-31', '2019-01-10 09:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(17, 2, 6, 18, 'Full-Time', '2020-03-01', '9999-12-31', '2020-03-01 10:15:00', '9999-12-31 23:59:59', 'Initial hire'),
(18, 2, 6, NULL, 'Full-Time', '2018-06-15', '9999-12-31', '2018-06-15 08:30:00', '9999-12-31 23:59:59', 'Initial hire - HR Manager'),
(19, 2, 6, 18, 'Full-Time', '2022-02-01', '9999-12-31', '2022-02-01 11:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(20, 2, 6, 18, 'Full-Time', '2020-07-10', '9999-12-31', '2020-07-10 09:20:00', '9999-12-31 23:59:59', 'Initial hire'),
(21, 2, 6, 18, 'Full-Time', '2021-04-20', '9999-12-31', '2021-04-20 14:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(22, 2, 6, 18, 'Full-Time', '2019-10-05', '9999-12-31', '2019-10-05 10:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(23, 2, 6, 18, 'Full-Time', '2022-05-01', '9999-12-31', '2022-05-01 13:15:00', '9999-12-31 23:59:59', 'Initial hire');

-- Employees 24-33: Finance Department
INSERT INTO employment_history (employee_id, department_id, position_id, manager_id, employment_type, 
                                valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(24, 3, 5, 25, 'Full-Time', '2020-01-20', '9999-12-31', '2020-01-20 08:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(25, 3, 12, NULL, 'Full-Time', '2018-09-10', '9999-12-31', '2018-09-10 09:30:00', '9999-12-31 23:59:59', 'Initial hire - Finance Director'),
(26, 3, 5, 25, 'Full-Time', '2021-06-01', '9999-12-31', '2021-06-01 10:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(27, 3, 9, 25, 'Full-Time', '2019-11-15', '9999-12-31', '2019-11-15 11:20:00', '9999-12-31 23:59:59', 'Initial hire'),
(28, 3, 5, 25, 'Full-Time', '2020-08-01', '9999-12-31', '2020-08-01 08:15:00', '9999-12-31 23:59:59', 'Initial hire'),
(29, 3, 9, 25, 'Full-Time', '2019-03-20', '9999-12-31', '2019-03-20 09:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(30, 3, 2, 25, 'Full-Time', '2022-04-10', '9999-12-31', '2022-04-10 13:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(31, 3, 5, 25, 'Full-Time', '2020-10-05', '9999-12-31', '2020-10-05 10:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(32, 3, 9, 25, 'Full-Time', '2017-12-01', '9999-12-31', '2017-12-01 08:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(33, 3, 5, 25, 'Full-Time', '2021-08-15', '9999-12-31', '2021-08-15 11:15:00', '9999-12-31 23:59:59', 'Initial hire');

-- Employees 34-43: Sales Department
INSERT INTO employment_history (employee_id, department_id, position_id, manager_id, employment_type, 
                                valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(34, 4, 3, 35, 'Full-Time', '2021-01-10', '9999-12-31', '2021-01-10 09:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(35, 4, 10, NULL, 'Full-Time', '2019-07-01', '9999-12-31', '2019-07-01 10:00:00', '9999-12-31 23:59:59', 'Initial hire - Sales Manager'),
(36, 4, 3, 35, 'Full-Time', '2022-03-15', '9999-12-31', '2022-03-15 08:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(37, 4, 10, NULL, 'Full-Time', '2018-05-20', '9999-12-31', '2018-05-20 11:30:00', '9999-12-31 23:59:59', 'Initial hire - Sales Manager'),
(38, 4, 3, 35, 'Full-Time', '2020-09-01', '9999-12-31', '2020-09-01 09:15:00', '9999-12-31 23:59:59', 'Initial hire'),
(39, 4, 3, 35, 'Full-Time', '2021-10-10', '9999-12-31', '2021-10-10 14:20:00', '9999-12-31 23:59:59', 'Initial hire'),
(40, 4, 10, NULL, 'Full-Time', '2019-02-15', '9999-12-31', '2019-02-15 10:45:00', '9999-12-31 23:59:59', 'Initial hire - Sales Manager'),
(41, 4, 3, 35, 'Full-Time', '2020-12-01', '9999-12-31', '2020-12-01 08:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(42, 4, 3, 35, 'Full-Time', '2022-06-01', '9999-12-31', '2022-06-01 13:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(43, 4, 10, NULL, 'Full-Time', '2019-08-10', '9999-12-31', '2019-08-10 09:00:00', '9999-12-31 23:59:59', 'Initial hire - Sales Manager');

-- Employees 44-47: Marketing Department
INSERT INTO employment_history (employee_id, department_id, position_id, manager_id, employment_type, 
                                valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(44, 5, 7, 46, 'Full-Time', '2020-04-15', '9999-12-31', '2020-04-15 10:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(45, 5, 7, 46, 'Full-Time', '2021-05-01', '9999-12-31', '2021-05-01 09:45:00', '9999-12-31 23:59:59', 'Initial hire'),
(46, 5, 7, NULL, 'Full-Time', '2019-12-10', '9999-12-31', '2019-12-10 11:00:00', '9999-12-31 23:59:59', 'Initial hire - Marketing Lead'),
(47, 5, 7, 46, 'Full-Time', '2020-06-20', '9999-12-31', '2020-06-20 08:15:00', '9999-12-31 23:59:59', 'Initial hire');

-- Employees 48-50: Operations Department
INSERT INTO employment_history (employee_id, department_id, position_id, manager_id, employment_type, 
                                valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
(48, 6, 7, 50, 'Full-Time', '2019-05-15', '9999-12-31', '2019-05-15 10:00:00', '9999-12-31 23:59:59', 'Initial hire'),
(49, 6, 7, 50, 'Full-Time', '2021-09-01', '9999-12-31', '2021-09-01 09:30:00', '9999-12-31 23:59:59', 'Initial hire'),
(50, 6, 7, NULL, 'Full-Time', '2018-11-20', '9999-12-31', '2018-11-20 11:45:00', '9999-12-31 23:59:59', 'Initial hire - Operations Lead');


INSERT INTO benefits_enrollment (employee_id, benefit_type, coverage_level, monthly_cost,
                                 valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
-- Employee 1: Health insurance progression
(1, 'Health Insurance', 'Individual', 250.00, '2020-02-01', '2021-01-01', '2020-01-20 10:30:00', '2020-12-01 09:15:00', 'New hire enrollment'),
(1, 'Health Insurance', 'Family', 650.00, '2021-01-01', '9999-12-31', '2020-12-01 09:15:00', '9999-12-31 23:59:59', 'Annual open enrollment - added family'),

-- Employee 2: 401k enrollment (BACKDATED!)
(2, '401k', 'Individual', 0.00, '2023-01-01', '9999-12-31', '2023-01-25 14:45:00', '9999-12-31 23:59:59', '401k enrollment - backdated to start of year'),

-- Employee 5: Dental insurance
(5, 'Dental', 'Family', 85.00, '2018-03-01', '9999-12-31', '2018-02-25 11:00:00', '9999-12-31 23:59:59', 'New hire benefit enrollment'),

-- Employee 25: Life insurance (Future-dated!)
(25, 'Life Insurance', 'Individual', 45.00, '2025-01-01', '9999-12-31', '2024-11-15 09:00:00', '9999-12-31 23:59:59', 'Open enrollment - coverage starts next year');


INSERT INTO performance_reviews (employee_id, reviewer_id, review_period_start, review_period_end, 
                                 review_date, overall_rating, comments,
                                 valid_start, valid_end, transaction_start, transaction_end, change_reason) VALUES
-- Employee 1: Normal review
(1, 15, '2022-01-01', '2022-12-31', '2023-01-15', 4.25, 
 'Strong performance. Excellent technical skills and good team collaboration. Ready for promotion.',
 '2023-01-15', '9999-12-31', '2023-01-15 14:30:00', '9999-12-31 23:59:59', 'Annual performance review'),

-- Employee 2: Backdated review
(2, 15, '2021-01-01', '2021-12-31', '2022-02-28', 4.50,
 'Outstanding performance. Promoted to Senior Developer.',
 '2022-01-01', '9999-12-31', '2022-02-28 16:15:00', '9999-12-31 23:59:59', 'Annual review - conducted late, backdated effective date'),

-- Employee 3: Review correction scenario
(3, 15, '2022-01-01', '2022-12-31', '2023-01-20', 3.25,
 'Good progress, meets expectations.',
 '2023-01-20', '9999-12-31', '2023-01-20 11:00:00', '2023-02-05 09:45:00', 'Annual performance review'),
(3, 15, '2022-01-01', '2022-12-31', '2023-01-20', 4.00,
 'Good progress, exceeds expectations in several areas. Rating corrected.',
 '2023-01-20', '9999-12-31', '2023-02-05 09:45:00', '9999-12-31 23:59:59', 'Review correction - rating was too low'),

-- Employee 5: Mid-year review
(5, 15, '2022-01-01', '2022-06-30', '2022-07-10', 4.75,
 'Exceptional senior developer. Technical leader on major projects.',
 '2022-07-10', '9999-12-31', '2022-07-10 10:30:00', '9999-12-31 23:59:59', 'Mid-year performance review'),

-- Employee 25: Executive review
(25, 1, '2022-01-01', '2022-12-31', '2023-01-30', 4.80,
 'Exceptional leadership. Successfully managed budget optimization and team expansion.',
 '2023-01-30', '9999-12-31', '2023-01-30 15:00:00', '9999-12-31 23:59:59', 'Annual executive review');







