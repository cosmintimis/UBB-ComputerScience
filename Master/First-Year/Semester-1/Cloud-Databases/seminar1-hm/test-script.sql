USE hr_bitemporal_system;

-- Query 1: Current valid records for employee
SELECT * FROM v_employee_complete_current_status WHERE employee_id = 1;

-- Query 2: History of changes (salary progression)
SELECT * FROM v_employee_salary_history WHERE employee_id = 1 ORDER BY valid_start;

-- Query 3: Temporal conflicts (late data entry)
SELECT * FROM v_backdated_salary_changes ORDER BY days_late DESC;

-- Query 4: Valid during specific period (Q1 2023)
SELECT * FROM v_salaries_valid_q1_2023 ORDER BY employee_id;

-- Query 5: As-of query (February 15, 2023)
SELECT * FROM v_salary_as_of_2023_02_15
ORDER BY employee_id;


select * from salaries
where employee_id = 1;

-- Data quality metrics
SELECT * FROM v_data_quality_metrics;


-- //////////////// Test triggers

INSERT INTO salaries (employee_id, amount, valid_start, valid_end, change_reason)
VALUES (1, 70000.00, '2023-06-01', '2024-06-01', 'TEST: Overlapping');
-- Expected: Bitemporal Error: Overlapping valid period detected


INSERT INTO salaries (employee_id, amount, valid_start, valid_end, change_reason)
VALUES (1, 68000.00, '2025-01-01', '2024-01-01', 'TEST: Invalid order');
-- Expected: Bitemporal Error: valid_start cannot be after valid_end


INSERT INTO salaries (
    employee_id, amount, valid_start, valid_end,
    transaction_start, change_reason
)
VALUES (
    1, 68000.00, '2024-01-01', '9999-12-31',
    '2050-01-01 00:00:00', 'TEST: Future transaction'
);
-- Expected: Bitemporal Error: transaction_start cannot be in the future



UPDATE salaries 
SET valid_start = '2024-06-01'
WHERE employee_id = 1
  AND transaction_end = '9999-12-31 23:59:59'
LIMIT 1;
-- Expected: Bitemporal Error: Cannot UPDATE valid_start


CALL sp_bitemporal_update_salary(
    1,
    70000.00,
    '2024-07-01',
    'TEST: Proper procedure update'
);

-- Verify bitemporal records
SELECT 
    employee_id,
    amount,
    valid_start,
    valid_end,
    transaction_start,
    CASE 
        WHEN transaction_end = '9999-12-31 23:59:59' THEN 'CURRENT'
        ELSE 'HISTORICAL'
    END AS status,
    change_reason
FROM salaries
WHERE employee_id = 1
  AND change_reason LIKE 'TEST:%'
ORDER BY transaction_start DESC;

-- Clean up
DELETE FROM salaries WHERE change_reason LIKE 'TEST:%';


INSERT INTO salaries (employee_id, amount, valid_start, valid_end, change_reason)
VALUES (999, 68000.00, '2024-01-01', '9999-12-31', 'TEST: Invalid FK');
-- Expected: FK Error: Employee does not exist

INSERT INTO salaries (employee_id, amount, valid_start, valid_end)
VALUES (1, 68000.00, '2024-01-01', '9999-12-31');
-- Expected: Audit Error: change_reason is required

delete from salaries where employee_id = 1;



