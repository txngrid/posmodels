-- ================================================================================
-- Get block distance given the total number of miners and 
-- the number of miners to sign each block. 
-- ================================================================================
CREATE PROCEDURE [dbo].[usp_GetBlockDistance]
	@TotalMiners	int,
	@BlockMiners	int,
	@BlockDistance decimal(18,9) output
AS
BEGIN
	
	DECLARE @Distance table(
		num decimal(18,9)
		);

	-- Generate a random number for each miner.
	while @TotalMiners > 0
	begin
		insert @Distance(num)
		values (RAND())
		select @TotalMiners = @TotalMiners - 1
	end

	-- The sum of the smallest N distances 
	select @BlockDistance = sum(num) from 
	(select top (@BlockMiners) num from @Distance order by num) d
END
