USE hr_bitemporal_system;

-- Complete current employee status (combines all current data)
CREATE OR REPLACE VIEW v_employee_complete_current_status AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.email,
    e.hire_date,
    p.position_title,
    p.position_level,
    d.department_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    s.amount AS current_salary,
    s.currency,
    eh.employment_type
FROM employees e

-- Get most recent current salary (latest transaction_start if multiple exist)
LEFT JOIN (
    SELECT 
        employee_id,
        amount,
        currency,
        valid_start
    FROM salaries
    WHERE valid_start <= CURRENT_DATE 
      AND valid_end > CURRENT_DATE
      AND transaction_end = '9999-12-31 23:59:59'
) s ON e.employee_id = s.employee_id

-- Get most recent current employment history
LEFT JOIN (
    SELECT 
        employee_id,
        position_id,
        department_id,
        manager_id,
        employment_type,
        valid_start
    FROM employment_history
    WHERE valid_start <= CURRENT_DATE 
      AND valid_end > CURRENT_DATE
      AND transaction_end = '9999-12-31 23:59:59'
) eh ON e.employee_id = eh.employee_id

LEFT JOIN positions p ON eh.position_id = p.position_id
LEFT JOIN departments d ON eh.department_id = d.department_id
LEFT JOIN employees m ON eh.manager_id = m.employee_id

WHERE e.status = 'Active';


CREATE OR REPLACE VIEW v_employee_salary_history AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    s.salary_id,
    s.amount,
    s.currency,
    s.valid_start,
    s.valid_end,
    s.transaction_start,
    s.transaction_end,
    s.change_reason,
    CASE 
        WHEN s.transaction_end = '9999-12-31 23:59:59' THEN 'Current'
        ELSE 'Historical'
    END AS record_status,
    DATEDIFF(s.transaction_start, s.valid_start) AS days_entry_delay
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id
ORDER BY e.employee_id, s.valid_start, s.transaction_start;

--  Manager change history
CREATE OR REPLACE VIEW v_employee_manager_history AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    eh.valid_start AS manager_assignment_start,
    eh.valid_end AS manager_assignment_end,
    eh.transaction_start AS recorded_date,
    eh.change_reason,
    CASE 
        WHEN eh.transaction_end = '9999-12-31 23:59:59' THEN 'Current'
        ELSE 'Historical'
    END AS record_status
FROM employees e
JOIN employment_history eh ON e.employee_id = eh.employee_id
LEFT JOIN employees m ON eh.manager_id = m.employee_id
ORDER BY e.employee_id, eh.valid_start;

-- Position change history (promotions, transfers)
CREATE OR REPLACE VIEW v_employee_position_history AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    p.position_title,
    p.position_level,
    d.department_name,
    eh.valid_start AS position_start_date,
    eh.valid_end AS position_end_date,
    eh.transaction_start AS recorded_date,
    eh.change_reason,
    CASE 
        WHEN eh.transaction_end = '9999-12-31 23:59:59' THEN 'Current'
        ELSE 'Historical'
    END AS record_status
FROM employees e
JOIN employment_history eh ON e.employee_id = eh.employee_id
JOIN positions p ON eh.position_id = p.position_id
JOIN departments d ON eh.department_id = d.department_id
ORDER BY e.employee_id, eh.valid_start;


--  Backdated salary changes (late HR entry)
CREATE OR REPLACE VIEW v_backdated_salary_changes AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    s.amount,
    s.valid_start AS should_have_started,
    s.transaction_start AS actually_recorded,
    DATEDIFF(s.transaction_start, s.valid_start) AS days_late,
    s.change_reason,
    CASE 
        WHEN DATEDIFF(s.transaction_start, s.valid_start) > 30 THEN 'CRITICAL - Over 30 days late'
        WHEN DATEDIFF(s.transaction_start, s.valid_start) > 14 THEN 'WARNING - Over 2 weeks late'
        ELSE 'Minor delay'
    END AS severity
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.transaction_start > s.valid_start
  AND s.transaction_end = '9999-12-31 23:59:59'
ORDER BY days_late DESC;



-- Salaries valid during Q1 2023
CREATE OR REPLACE VIEW v_salaries_valid_q1_2023 AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.department_name,
    s.amount,
    s.currency,
    s.valid_start,
    s.valid_end,
    CASE 
        WHEN s.valid_start < '2023-01-01' AND s.valid_end > '2023-03-31' 
            THEN 'Entire quarter'
        WHEN s.valid_start >= '2023-01-01' AND s.valid_end <= '2023-03-31' 
            THEN 'Partial - within quarter'
        WHEN s.valid_start < '2023-01-01' AND s.valid_end <= '2023-03-31' 
            THEN 'Partial - ended during quarter'
        ELSE 'Partial - started during quarter'
    END AS coverage_period
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id
LEFT JOIN employment_history eh ON e.employee_id = eh.employee_id
    AND eh.valid_start <= '2023-03-31'
    AND eh.valid_end > '2023-01-01'
    AND eh.transaction_end = '9999-12-31 23:59:59'
LEFT JOIN departments d ON eh.department_id = d.department_id
WHERE s.valid_start <= '2023-03-31'
  AND s.valid_end > '2023-01-01'
  AND s.transaction_end = '9999-12-31 23:59:59'
ORDER BY e.employee_id;


--  Salary as known on February 15, 2023
CREATE OR REPLACE VIEW v_salary_as_of_2023_02_15 AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    s.amount,
    s.currency,
    s.valid_start,
    s.valid_end,
    s.transaction_start AS entered_into_system_on,
    s.change_reason,
    CASE 
        WHEN s.valid_start <= '2023-02-15' AND s.valid_end > '2023-02-15' 
            THEN 'Was valid on Feb 15, 2023'
        WHEN s.valid_start > '2023-02-15' 
            THEN 'Scheduled for future'
        ELSE 'Was historical on Feb 15, 2023'
    END AS status_on_feb_15
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.transaction_start <= '2023-02-15 23:59:59'
  AND s.transaction_end > '2023-02-15 23:59:59'
ORDER BY e.employee_id;


-- Data quality metrics
CREATE OR REPLACE VIEW v_data_quality_metrics AS
SELECT 
    'Salaries' AS table_name,
    COUNT(*) AS total_records,
    SUM(CASE WHEN transaction_end = '9999-12-31 23:59:59' THEN 1 ELSE 0 END) AS current_records,
    SUM(CASE WHEN transaction_end != '9999-12-31 23:59:59' THEN 1 ELSE 0 END) AS historical_records,
    SUM(CASE WHEN transaction_start > valid_start THEN 1 ELSE 0 END) AS backdated_records,
    AVG(CASE WHEN transaction_start > valid_start 
        THEN DATEDIFF(transaction_start, valid_start) ELSE 0 END) AS avg_days_late
FROM salaries

UNION ALL

SELECT 
    'Employment History',
    COUNT(*),
    SUM(CASE WHEN transaction_end = '9999-12-31 23:59:59' THEN 1 ELSE 0 END),
    SUM(CASE WHEN transaction_end != '9999-12-31 23:59:59' THEN 1 ELSE 0 END),
    SUM(CASE WHEN transaction_start > valid_start THEN 1 ELSE 0 END),
    AVG(CASE WHEN transaction_start > valid_start 
        THEN DATEDIFF(transaction_start, valid_start) ELSE 0 END)
FROM employment_history

UNION ALL

SELECT 
    'Benefits Enrollment',
    COUNT(*),
    SUM(CASE WHEN transaction_end = '9999-12-31 23:59:59' THEN 1 ELSE 0 END),
    SUM(CASE WHEN transaction_end != '9999-12-31 23:59:59' THEN 1 ELSE 0 END),
    SUM(CASE WHEN transaction_start > valid_start THEN 1 ELSE 0 END),
    AVG(CASE WHEN transaction_start > valid_start 
        THEN DATEDIFF(transaction_start, valid_start) ELSE 0 END)
FROM benefits_enrollment

UNION ALL

SELECT 
    'Performance Reviews',
    COUNT(*),
    SUM(CASE WHEN transaction_end = '9999-12-31 23:59:59' THEN 1 ELSE 0 END),
    SUM(CASE WHEN transaction_end != '9999-12-31 23:59:59' THEN 1 ELSE 0 END),
    SUM(CASE WHEN transaction_start > valid_start THEN 1 ELSE 0 END),
    AVG(CASE WHEN transaction_start > valid_start 
        THEN DATEDIFF(transaction_start, valid_start) ELSE 0 END)
FROM performance_reviews;

-- Show all created views
SELECT TABLE_NAME, TABLE_TYPE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'hr_bitemporal_system'
  AND TABLE_TYPE = 'VIEW'
ORDER BY TABLE_NAME;
