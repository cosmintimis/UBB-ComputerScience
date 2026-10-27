SELECT * FROM v_employee_complete_current_status WHERE employee_id = 1;

SELECT * FROM v_employee_salary_history WHERE employee_id = 1 ORDER BY valid_from;

SELECT * FROM v_backdated_salary_changes ORDER BY days_late DESC;

SELECT * 
FROM v_salary_as_of_today
ORDER BY employee_id;

SELECT * 
FROM v_salaries_valid_current_quarter
ORDER BY employee_id;

select * from salaries;

select * from salaries_history;

INSERT INTO salaries (employee_id, amount, valid_from, valid_to, change_reason)
VALUES (1, 60000, '2025-09-15', '2025-12-31', 'test');

-- DELETE FROM salaries
-- WHERE employee_id = 51

-- SELECT * FROM v_salaries_valid_q1_2023 ORDER BY employee_id;

-- SELECT * FROM v_salary_as_of_2023_02_15 ORDER BY employee_id;
