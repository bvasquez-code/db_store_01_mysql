DELIMITER $$

DROP TRIGGER IF EXISTS trg_after_insert_store$$

CREATE TRIGGER trg_after_insert_store
AFTER INSERT ON store
FOR EACH ROW
BEGIN
    CALL sp_initalize_store_automation(NEW.StoreCod, NEW.Name, NEW.Description);
END$$

