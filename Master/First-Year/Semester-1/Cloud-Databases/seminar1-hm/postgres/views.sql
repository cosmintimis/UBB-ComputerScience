CREATE OR REPLACE VIEW v_employee_complete_current_status AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.email,
    e.hire_date,
    p.position_title,
    p.position_level,
    d.department_name,
    m.first_name || ' ' || m.last_name AS manager_name,
    s.amount AS current_salary,
    s.currency,
    eh.employment_type
FROM employees e
LEFT JOIN (
    SELECT * 
    FROM salaries__as_of(CURRENT_TIMESTAMP)
    WHERE periods.contains(valid_from, valid_to, CURRENT_DATE)
) s ON e.employee_id = s.employee_id
LEFT JOIN (
    SELECT * 
    FROM employment_history__as_of(CURRENT_TIMESTAMP)
    WHERE periods.contains(valid_from, valid_to, CURRENT_DATE)
) eh ON e.employee_id = eh.employee_id
LEFT JOIN positions p ON eh.position_id = p.position_id
LEFT JOIN departments d ON eh.department_id = d.department_id
LEFT JOIN employees m ON eh.manager_id = m.employee_id
WHERE e.status = 'Active';


CREATE OR REPLACE VIEW v_employee_salary_history AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    s.salary_id,
    s.amount,
    s.currency,
    s.valid_from,
    s.valid_to,
    s.system_time_start,
    s.system_time_end,
    s.change_reason,
    CASE 
        WHEN s.system_time_end = 'infinity' THEN 'Current'
        ELSE 'Historical'
    END AS record_status,
    s.system_time_start::date - s.valid_from AS days_entry_delay
FROM employees e
JOIN (
    SELECT * FROM salaries
    UNION ALL
    SELECT * FROM salaries_history
) s ON e.employee_id = s.employee_id
ORDER BY e.employee_id, s.valid_from, s.system_time_start;

CREATE OR REPLACE VIEW v_backdated_salary_changes AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    s.amount,
    s.valid_from AS should_have_started,
    s.system_time_start AS actually_recorded,
    s.system_time_start::date - s.valid_from AS days_late,
    s.change_reason,
    CASE 
        WHEN s.system_time_start::date - s.valid_from > 60 THEN 'CRITICAL - Over 60 days late'
        WHEN s.system_time_start::date - s.valid_from > 30 THEN 'HIGH - Over 30 days late'
        WHEN s.system_time_start::date - s.valid_from > 14 THEN 'WARNING - Over 2 weeks late'
        ELSE 'Minor delay'
    END AS severity,
    ROUND((s.amount / 365) * (s.system_time_start::date - s.valid_from), 2) AS estimated_backpay
FROM employees e
JOIN (
    SELECT * FROM salaries
    UNION ALL
    SELECT * FROM salaries_history
) s ON e.employee_id = s.employee_id
WHERE s.system_time_start::date > s.valid_from
  AND s.system_time_end = 'infinity'
ORDER BY (s.system_time_start::date - s.valid_from) DESC;




CREATE OR REPLACE VIEW v_salaries_valid_current_quarter AS
WITH quarter AS (
    SELECT
        date_trunc('quarter', CURRENT_DATE)::date AS quarter_start,
        (date_trunc('quarter', CURRENT_DATE) + INTERVAL '3 months - 1 day')::date AS quarter_end
)
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    s.amount,
    s.currency,
    s.valid_from,
    s.valid_to,
    CASE 
        WHEN s.valid_from < q.quarter_start AND s.valid_to > q.quarter_end
            THEN 'Entire quarter'
        WHEN s.valid_from >= q.quarter_start AND s.valid_to <= q.quarter_end
            THEN 'Partial - within quarter'
        WHEN s.valid_from < q.quarter_start AND s.valid_to <= q.quarter_end
            THEN 'Partial - ended during quarter'
        ELSE 'Partial - started during quarter'
    END AS coverage_period
FROM employees e
JOIN quarter q ON TRUE
JOIN salaries__as_of(CURRENT_TIMESTAMP) s 
    ON e.employee_id = s.employee_id
LEFT JOIN employment_history__as_of(CURRENT_TIMESTAMP) eh 
    ON e.employee_id = eh.employee_id
    AND periods.overlaps(eh.valid_from, eh.valid_to, q.quarter_start, q.quarter_end)
LEFT JOIN departments d ON eh.department_id = d.department_id
ORDER BY e.employee_id;


-- CREATE OR REPLACE VIEW v_salaries_valid_q1_2023 AS
-- SELECT 
--     e.employee_id,
--     e.first_name || ' ' || e.last_name AS employee_name,
--     d.department_name,
--     s.amount,
--     s.currency,
--     s.valid_from,
--     s.valid_to,
--     CASE 
--         WHEN s.valid_from < DATE '2023-01-01' AND s.valid_to > DATE '2023-03-31' 
--             THEN 'Entire quarter'
--         WHEN s.valid_from >= DATE '2023-01-01' AND s.valid_to <= DATE '2023-03-31' 
--             THEN 'Partial - within quarter'
--         WHEN s.valid_from < DATE '2023-01-01' AND s.valid_to <= DATE '2023-03-31' 
--             THEN 'Partial - ended during quarter'
--         ELSE 'Partial - started during quarter'
--     END AS coverage_period
-- FROM employees e
-- JOIN salaries__as_of(TIMESTAMP '2023-03-31 23:59:59') s 
--     ON e.employee_id = s.employee_id
-- LEFT JOIN employment_history__as_of(TIMESTAMP '2023-03-31 23:59:59') eh 
--     ON e.employee_id = eh.employee_id
--     AND periods.overlaps(eh.valid_from, eh.valid_to, DATE '2023-01-01', DATE '2023-03-31')
-- LEFT JOIN departments d ON eh.department_id = d.department_id
-- ORDER BY e.employee_id;



CREATE OR REPLACE VIEW v_salary_as_of_today AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    s.amount,
    s.currency,
    s.valid_from,
    s.valid_to,
    s.system_time_start AS entered_into_system_on,
    s.change_reason,
    CASE 
        WHEN periods.contains(s.valid_from, s.valid_to, CURRENT_DATE) THEN 'Salary valid today'
        WHEN s.valid_from > CURRENT_DATE THEN 'Scheduled for future'
        ELSE 'Historical salary'
    END AS status_today
FROM employees e
JOIN salaries__as_of(CURRENT_TIMESTAMP) s
    ON e.employee_id = s.employee_id
ORDER BY e.employee_id;


-- CREATE OR REPLACE VIEW v_salary_as_of_2023_02_15 AS
-- SELECT 
--     e.employee_id,
--     e.first_name || ' ' || e.last_name AS employee_name,
--     s.amount,
--     s.currency,
--     s.valid_from,
--     s.valid_to,
--     s.system_time_start AS entered_into_system_on,
--     s.change_reason,
--     CASE 
--         WHEN periods.contains(s.valid_from, s.valid_to, DATE '2023-02-15') THEN 'Was valid on Feb 15, 2023'
--         WHEN s.valid_from > DATE '2023-02-15' THEN 'Scheduled for future'
--         ELSE 'Was historical on Feb 15, 2023'
--     END AS status_on_feb_15
-- FROM employees e
-- JOIN salaries__as_of(TIMESTAMP '2023-02-15 23:59:59') s
--     ON e.employee_id = s.employee_id
-- ORDER BY e.employee_id;


