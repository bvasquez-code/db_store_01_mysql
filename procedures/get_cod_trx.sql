DELIMITER ;;
CREATE PROCEDURE `db_store_01`.`get_cod_trx`(
	IN p_storeCod VARCHAR(4),
	IN p_SequenceTableType VARCHAR(32)
)
begin

	declare l_cod_trx VARCHAR(32);

	SET @@autocommit = 1;

	update store_sequence set SequenceTrx = SequenceTrx + 1
	where StoreCod = p_StoreCod
	and SequenceTableType = p_SequenceTableType
	and PeriodId in (select P.PeriodId from period P where P.Status = 'A');

	select CONCAT(Prefix,StoreCod,LPAD(PeriodId,4,0),LPAD(SequenceTrx, 7, '0')) into l_cod_trx
	from store_sequence 
	where StoreCod = p_StoreCod
	and SequenceTableType = p_SequenceTableType
	and PeriodId in (select P.PeriodId from period P where P.Status = 'A');

	select l_cod_trx as cod_trx;

END ;;
DELIMITER ;