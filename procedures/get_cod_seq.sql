DELIMITER ;;
DROP PROCEDURE IF EXISTS `get_cod_seq`;;
CREATE PROCEDURE `get_cod_seq`(
	IN p_SequenceTableType VARCHAR(32)
)
begin

	declare l_cod_trx VARCHAR(32);

	SET @@autocommit = 1;

	update table_sequence set SequenceTrx = SequenceTrx + 1
	where SequenceTableType = p_SequenceTableType;

	select 
        CASE 
            WHEN UsePrefix = 'S' THEN CONCAT(Prefix, LPAD(SequenceTrx, length - length(Prefix), '0'))
            ELSE LPAD(SequenceTrx, length, '0')
        END into l_cod_trx
	from table_sequence 
	where SequenceTableType = p_SequenceTableType;

	select l_cod_trx as cod_trx;

END ;;
DELIMITER ;