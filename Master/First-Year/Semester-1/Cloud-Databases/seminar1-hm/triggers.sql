USE hr_bitemporal_system;

DELIMITER $$

DROP TRIGGER IF EXISTS trg_salaries_before_insert$$
CREATE TRIGGER trg_salaries_before_insert
BEFORE INSERT ON salaries
FOR EACH ROW
BEGIN
    DECLARE v_employee_exists INT DEFAULT 0;
    DECLARE v_overlapping_count INT DEFAULT 0;
    
    IF NEW.transaction_start IS NULL THEN
        SET NEW.transaction_start = CURRENT_TIMESTAMP;
    END IF;
    
    IF NEW.transaction_end IS NULL THEN
        SET NEW.transaction_end = '9999-12-31 23:59:59';
    END IF;
    
  
    -- Valid period must be ordered correctly
    IF NEW.valid_start > NEW.valid_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: valid_start cannot be after valid_end';
    END IF;
    
    -- Transaction period must be ordered correctly
    IF NEW.transaction_start > NEW.transaction_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: transaction_start cannot be after transaction_end';
    END IF;
    
    -- Transaction time cannot be in the future (we can't know future data!)
    IF NEW.transaction_start > CURRENT_TIMESTAMP THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: transaction_start cannot be in the future';
    END IF;
   
    -- An employee can only have ONE salary valid at any given time
    SELECT COUNT(*) INTO v_overlapping_count
    FROM salaries
    WHERE employee_id = NEW.employee_id
      AND transaction_end = '9999-12-31 23:59:59'  -- Only check current records
      AND salary_id != IFNULL(NEW.salary_id, 0)
      AND (
          -- New period overlaps with existing period
          (NEW.valid_start >= valid_start AND NEW.valid_start < valid_end) OR
          (NEW.valid_end > valid_start AND NEW.valid_end <= valid_end) OR
          (NEW.valid_start <= valid_start AND NEW.valid_end >= valid_end)
      );
    
    IF v_overlapping_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Overlapping valid period detected. Use sp_bitemporal_update_salary.';
    END IF;
    
    
    SELECT COUNT(*) INTO v_employee_exists
    FROM employees
    WHERE employee_id = NEW.employee_id;
    
    IF v_employee_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FK Error: Employee does not exist';
    END IF;
    
    IF NEW.change_reason IS NULL OR TRIM(NEW.change_reason) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Audit Error: change_reason is required for audit trail';
    END IF;
    
END$$

DROP TRIGGER IF EXISTS trg_salaries_before_update$$
CREATE TRIGGER trg_salaries_before_update
BEFORE UPDATE ON salaries
FOR EACH ROW
BEGIN    
    IF OLD.valid_start != NEW.valid_start THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot UPDATE valid_start. Use sp_bitemporal_update_salary.';
    END IF;
    
    IF OLD.valid_end != NEW.valid_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot UPDATE valid_end. Use sp_bitemporal_update_salary.';
    END IF;
    
    IF OLD.transaction_start != NEW.transaction_start THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot UPDATE transaction_start. Use sp_bitemporal_update_salary.';
    END IF;
    
    IF OLD.transaction_end != '9999-12-31 23:59:59' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot modify historical records (already closed).';
    END IF;
    
    IF OLD.transaction_end = '9999-12-31 23:59:59' AND NEW.transaction_end != '9999-12-31 23:59:59' THEN
        -- This is the ONLY allowed UPDATE - closing a record
        SET NEW.transaction_end = CURRENT_TIMESTAMP;
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_salaries_before_update$$
CREATE TRIGGER trg_block_delete_salaries
BEFORE DELETE ON salaries
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Deletes are not allowed on the salaries table.';
END$$


DROP TRIGGER IF EXISTS trg_employment_history_before_insert$$
CREATE TRIGGER trg_employment_history_before_insert
BEFORE INSERT ON employment_history
FOR EACH ROW
BEGIN
    DECLARE v_employee_exists INT DEFAULT 0;
    DECLARE v_overlapping_count INT DEFAULT 0;
    
    IF NEW.transaction_start IS NULL THEN
        SET NEW.transaction_start = CURRENT_TIMESTAMP;
    END IF;
    
    IF NEW.transaction_end IS NULL THEN
        SET NEW.transaction_end = '9999-12-31 23:59:59';
    END IF;
    
    IF NEW.valid_start > NEW.valid_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: valid_start cannot be after valid_end';
    END IF;
    
    IF NEW.transaction_start > NEW.transaction_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: transaction_start cannot be after transaction_end';
    END IF;
    
    IF NEW.transaction_start > CURRENT_TIMESTAMP THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: transaction_start cannot be in the future';
    END IF;
    
    -- Prevent overlapping valid periods
    SELECT COUNT(*) INTO v_overlapping_count
    FROM employment_history
    WHERE employee_id = NEW.employee_id
      AND transaction_end = '9999-12-31 23:59:59'
      AND history_id != IFNULL(NEW.history_id, 0)
      AND (
          (NEW.valid_start >= valid_start AND NEW.valid_start < valid_end) OR
          (NEW.valid_end > valid_start AND NEW.valid_end <= valid_end) OR
          (NEW.valid_start <= valid_start AND NEW.valid_end >= valid_end)
      );
    
    IF v_overlapping_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Overlapping valid period. Use sp_bitemporal_update_employment.';
    END IF;
    
    -- FK validation
    SELECT COUNT(*) INTO v_employee_exists
    FROM employees
    WHERE employee_id = NEW.employee_id;
    
    IF v_employee_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FK Error: Employee does not exist';
    END IF;
    
    -- Audit trail
    IF NEW.change_reason IS NULL OR TRIM(NEW.change_reason) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Audit Error: change_reason is required';
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_employment_history_before_update$$
CREATE TRIGGER trg_employment_history_before_update
BEFORE UPDATE ON employment_history
FOR EACH ROW
BEGIN
    IF OLD.valid_start != NEW.valid_start THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot UPDATE valid_start. Use bitemporal procedure.';
    END IF;
    
    IF OLD.valid_end != NEW.valid_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot UPDATE valid_end. Use bitemporal procedure.';
    END IF;
    
    IF OLD.transaction_start != NEW.transaction_start THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot UPDATE transaction_start. Use bitemporal procedure.';
    END IF;
    
    IF OLD.transaction_end != '9999-12-31 23:59:59' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot modify historical records.';
    END IF;
    
    IF OLD.transaction_end = '9999-12-31 23:59:59' AND NEW.transaction_end != '9999-12-31 23:59:59' THEN
        SET NEW.transaction_end = CURRENT_TIMESTAMP;
    END IF;
END$$


DROP TRIGGER IF EXISTS trg_benefits_enrollment_before_insert$$
CREATE TRIGGER trg_benefits_enrollment_before_insert
BEFORE INSERT ON benefits_enrollment
FOR EACH ROW
BEGIN
    DECLARE v_employee_exists INT DEFAULT 0;
    
    IF NEW.transaction_start IS NULL THEN
        SET NEW.transaction_start = CURRENT_TIMESTAMP;
    END IF;
    
    IF NEW.transaction_end IS NULL THEN
        SET NEW.transaction_end = '9999-12-31 23:59:59';
    END IF;
    
    IF NEW.valid_start > NEW.valid_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: valid_start cannot be after valid_end';
    END IF;
    
    IF NEW.transaction_start > NEW.transaction_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: transaction_start cannot be after transaction_end';
    END IF;
    
    IF NEW.transaction_start > CURRENT_TIMESTAMP THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: transaction_start cannot be in the future';
    END IF;
    
    -- FK validation
    SELECT COUNT(*) INTO v_employee_exists
    FROM employees
    WHERE employee_id = NEW.employee_id;
    
    IF v_employee_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FK Error: Employee does not exist';
    END IF;
    
    -- Audit trail
    IF NEW.change_reason IS NULL OR TRIM(NEW.change_reason) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Audit Error: change_reason is required';
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_benefits_enrollment_before_update$$
CREATE TRIGGER trg_benefits_enrollment_before_update
BEFORE UPDATE ON benefits_enrollment
FOR EACH ROW
BEGIN
    IF OLD.valid_start != NEW.valid_start THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot UPDATE valid_start. Use bitemporal procedure.';
    END IF;
    
    IF OLD.valid_end != NEW.valid_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot UPDATE valid_end. Use bitemporal procedure.';
    END IF;
    
    IF OLD.transaction_start != NEW.transaction_start THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot UPDATE transaction_start. Use bitemporal procedure.';
    END IF;
    
    IF OLD.transaction_end != '9999-12-31 23:59:59' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot modify historical records.';
    END IF;
    
    IF OLD.transaction_end = '9999-12-31 23:59:59' AND NEW.transaction_end != '9999-12-31 23:59:59' THEN
        SET NEW.transaction_end = CURRENT_TIMESTAMP;
    END IF;
END$$


DROP TRIGGER IF EXISTS trg_performance_reviews_before_insert$$
CREATE TRIGGER trg_performance_reviews_before_insert
BEFORE INSERT ON performance_reviews
FOR EACH ROW
BEGIN
    DECLARE v_employee_exists INT DEFAULT 0;
    
    IF NEW.transaction_start IS NULL THEN
        SET NEW.transaction_start = CURRENT_TIMESTAMP;
    END IF;
    
    IF NEW.transaction_end IS NULL THEN
        SET NEW.transaction_end = '9999-12-31 23:59:59';
    END IF;
    
    IF NEW.valid_start > NEW.valid_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: valid_start cannot be after valid_end';
    END IF;
    
    IF NEW.transaction_start > NEW.transaction_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: transaction_start cannot be after transaction_end';
    END IF;
    
    IF NEW.transaction_start > CURRENT_TIMESTAMP THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: transaction_start cannot be in the future';
    END IF;
    
    SELECT COUNT(*) INTO v_employee_exists
    FROM employees
    WHERE employee_id = NEW.employee_id;
    
    IF v_employee_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FK Error: Employee does not exist';
    END IF;
    
    IF NEW.change_reason IS NULL OR TRIM(NEW.change_reason) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Audit Error: change_reason is required';
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_performance_reviews_before_update$$
CREATE TRIGGER trg_performance_reviews_before_update
BEFORE UPDATE ON performance_reviews
FOR EACH ROW
BEGIN
    IF OLD.valid_start != NEW.valid_start THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot UPDATE valid_start. Use bitemporal procedure.';
    END IF;
    
    IF OLD.valid_end != NEW.valid_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot UPDATE valid_end. Use bitemporal procedure.';
    END IF;
    
    IF OLD.transaction_start != NEW.transaction_start THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot UPDATE transaction_start. Use bitemporal procedure.';
    END IF;
    
    IF OLD.transaction_end != '9999-12-31 23:59:59' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bitemporal Error: Cannot modify historical records.';
    END IF;
    
    IF OLD.transaction_end = '9999-12-31 23:59:59' AND NEW.transaction_end != '9999-12-31 23:59:59' THEN
        SET NEW.transaction_end = CURRENT_TIMESTAMP;
    END IF;
END$$

DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_bitemporal_update_salary$$
CREATE PROCEDURE sp_bitemporal_update_salary(
    IN p_employee_id INT,
    IN p_new_amount DECIMAL(10,2),
    IN p_valid_start DATE,
    IN p_change_reason VARCHAR(255)
)
BEGIN
    DECLARE v_not_found INT DEFAULT 0;
    DECLARE v_salary_id INT;
    DECLARE v_amount DECIMAL(10,2);
    DECLARE v_currency VARCHAR(3);
    DECLARE v_valid_start_old DATE;
    DECLARE v_valid_end_old DATE;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_not_found = 1;

    IF p_new_amount IS NULL OR p_new_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: p_new_amount must be > 0';
    END IF;

    IF p_valid_start IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: p_valid_start must be provided';
    END IF;

    START TRANSACTION;

    SET v_not_found = 0;

    SELECT salary_id, amount, currency, valid_start, valid_end
    INTO v_salary_id, v_amount, v_currency, v_valid_start_old, v_valid_end_old
    FROM salaries
    WHERE employee_id = p_employee_id
      AND transaction_end = '9999-12-31 23:59:59'
      AND valid_start <= CURRENT_DATE
      AND valid_end > CURRENT_DATE
    ORDER BY transaction_start DESC
    LIMIT 1;

    IF v_not_found = 1 OR v_salary_id IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: No current salary record found for employee';
    END IF;

    IF NOT (v_valid_start_old <= p_valid_start AND p_valid_start < v_valid_end_old) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: p_valid_start must be within current valid range';
    END IF;

    UPDATE salaries
    SET transaction_end = CURRENT_TIMESTAMP
    WHERE salary_id = v_salary_id;

    IF v_valid_start_old < p_valid_start THEN
        INSERT INTO salaries (
            employee_id, amount, currency,
            valid_start, valid_end,
            transaction_start, transaction_end, change_reason
        ) VALUES (
            p_employee_id, v_amount, v_currency,
            v_valid_start_old, p_valid_start,
            CURRENT_TIMESTAMP, '9999-12-31 23:59:59',
            'Superseded by salary change'
        );
    END IF;

    INSERT INTO salaries (
        employee_id, amount, currency,
        valid_start, valid_end,
        transaction_start, transaction_end, change_reason
    ) VALUES (
        p_employee_id, p_new_amount, v_currency,
        p_valid_start, v_valid_end_old,
        CURRENT_TIMESTAMP, '9999-12-31 23:59:59',
        p_change_reason
    );

    COMMIT;
END$$

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_bitemporal_update_employment$$
CREATE PROCEDURE sp_bitemporal_update_employment(
    IN p_employee_id INT,
    IN p_new_department_id INT,
    IN p_new_position_id INT,
    IN p_new_manager_id INT,
    IN p_valid_start DATE,
    IN p_change_reason VARCHAR(255)
)
BEGIN
    DECLARE v_not_found INT DEFAULT 0;
    DECLARE v_history_id INT;
    DECLARE v_department_id INT;
    DECLARE v_position_id INT;
    DECLARE v_manager_id INT;
    DECLARE v_employment_type VARCHAR(20);
    DECLARE v_valid_start_old DATE;
    DECLARE v_valid_end_old DATE;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_not_found = 1;

    IF p_valid_start IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: p_valid_start must be provided';
    END IF;

    START TRANSACTION;

    SET v_not_found = 0;

    -- Find current employment record
    SELECT history_id, department_id, position_id, manager_id, employment_type, valid_start, valid_end
    INTO v_history_id, v_department_id, v_position_id, v_manager_id, v_employment_type, v_valid_start_old, v_valid_end_old
    FROM employment_history
    WHERE employee_id = p_employee_id
      AND transaction_end = '9999-12-31 23:59:59'
      AND valid_start <= CURRENT_DATE
      AND valid_end > CURRENT_DATE
    ORDER BY transaction_start DESC
    LIMIT 1;

    IF v_not_found = 1 OR v_history_id IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: No current employment record found for employee';
    END IF;

    IF NOT (v_valid_start_old <= p_valid_start AND p_valid_start < v_valid_end_old) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: p_valid_start must be within current valid range';
    END IF;

    -- Close the old record
    UPDATE employment_history
    SET transaction_end = CURRENT_TIMESTAMP
    WHERE history_id = v_history_id;

    -- Insert old record with shortened valid period (if needed)
    IF v_valid_start_old < p_valid_start THEN
        INSERT INTO employment_history (
            employee_id, department_id, position_id, manager_id, employment_type,
            valid_start, valid_end,
            transaction_start, transaction_end, change_reason
        ) VALUES (
            p_employee_id, v_department_id, v_position_id, v_manager_id, v_employment_type,
            v_valid_start_old, p_valid_start,
            CURRENT_TIMESTAMP, '9999-12-31 23:59:59',
            'Superseded by employment change'
        );
    END IF;

    -- Insert new record with changes
    INSERT INTO employment_history (
        employee_id, 
        department_id, 
        position_id, 
        manager_id, 
        employment_type,
        valid_start, 
        valid_end,
        transaction_start, 
        transaction_end, 
        change_reason
    ) VALUES (
        p_employee_id,
        COALESCE(p_new_department_id, v_department_id),
        COALESCE(p_new_position_id, v_position_id),
        p_new_manager_id,  -- Can be NULL
        v_employment_type,
        p_valid_start,
        v_valid_end_old,
        CURRENT_TIMESTAMP,
        '9999-12-31 23:59:59',
        p_change_reason
    );

    COMMIT;
END$$

DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_bitemporal_correct_salary$$
CREATE PROCEDURE sp_bitemporal_correct_salary(
    IN p_salary_id INT,
    IN p_corrected_amount DECIMAL(10,2),
    IN p_change_reason VARCHAR(255)
)
BEGIN
    DECLARE v_not_found INT DEFAULT 0;
    DECLARE v_employee_id INT;
    DECLARE v_amount DECIMAL(10,2);
    DECLARE v_currency VARCHAR(3);
    DECLARE v_valid_start DATE;
    DECLARE v_valid_end DATE;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_not_found = 1;

    IF p_corrected_amount IS NULL OR p_corrected_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: p_corrected_amount must be > 0';
    END IF;

    START TRANSACTION;

    SELECT employee_id, amount, currency, valid_start, valid_end
    INTO v_employee_id, v_amount, v_currency, v_valid_start, v_valid_end
    FROM salaries
    WHERE salary_id = p_salary_id
      AND transaction_end = '9999-12-31 23:59:59'
    LIMIT 1;

    IF v_not_found = 1 OR v_employee_id IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Salary record not found or not current';
    END IF;

    UPDATE salaries
    SET transaction_end = CURRENT_TIMESTAMP
    WHERE salary_id = p_salary_id;

    INSERT INTO salaries (
        employee_id, amount, currency,
        valid_start, valid_end,
        transaction_start, transaction_end, change_reason
    ) VALUES (
        v_employee_id, p_corrected_amount, v_currency,
        v_valid_start, v_valid_end,
        CURRENT_TIMESTAMP, '9999-12-31 23:59:59',
        p_change_reason
    );

    COMMIT;
END$$

DELIMITER ;
