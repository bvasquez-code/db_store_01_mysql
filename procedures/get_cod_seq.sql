DELIMITER ;;
CREATE PROCEDURE `db_store_01`.`get_cod_seq`(
	IN p_SequenceTableType VARCHAR(32)
)
begin

	declare l_cod_trx VARCHAR(32);

	SET @@autocommit = 1;

	update table_sequence set SequenceTrx = SequenceTrx + 1
	where SequenceTableType = p_SequenceTableType;

	select CONCAT(Prefix,LPAD(SequenceTrx, length - length(Prefix)  , '0')) into l_cod_trx
	from table_sequence 
	where SequenceTableType = p_SequenceTableType;

	select l_cod_trx as cod_trx;

END ;;
DELIMITER ;