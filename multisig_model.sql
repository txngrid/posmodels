declare 
	@TotalMiners int = 100,		-- Total miners.
	@BlockMiners int = 20,		-- Number of mniers to sign each block.
	@BlockHeight int = 1000		-- Blockchain length to simulate.

DECLARE @BlockDistance table(
	BlockHeight	int identity,
    BlockDistance decimal(18,9),
	ChainDistance decimal(18,9)
);


declare 
	@tempDistacne decimal(18,9)

while (@BlockHeight > 0)
begin
	exec [usp_GetBlockDistance] @TotalMiners, @BlockMiners, @tempDistacne output
		insert @BlockDistance 
		select @tempDistacne, isnull(sum(BlockDistance),0) + @tempDistacne from @BlockDistance
		select @BlockHeight = @BlockHeight - 1
end

select * from @BlockDistance
