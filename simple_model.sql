-- number of miners
declare @totalMiners int = 100, @participateMiners int = 100
	
-- total seconds to run
declare @times int = 10000


-- table to save randoms numbers for miners
declare @RandomNumbers table(
    num decimal(18,14) 
);

-- the block chain
declare @BlockChain table(
    sec		int,	-- time in second
	miners	int,	-- number of winning miners - fork if > 1
	height	int		-- block height
);

-- difficult factor or target
declare @target decimal(18,14)
set @target = 1.0/@totalMiners/10.0

declare @t int = 0
-- total miners
declare @miners int

while @t < @times
begin
	
	set @miners = @participateMiners;

	delete @RandomNumbers
		
	-- each miner gets a random number between 0 and 1
	while @miners > 0
	begin
		insert @RandomNumbers(num)
		values (rand())
		select @miners = @miners - 1
	end

	declare @stakeCnt int
	select @stakeCnt = count(1) from @RandomNumbers where num < @target
	
	-- add a new block if any miner got a number < target
	if (@stakeCnt > 0) 
		insert @BlockChain 
		select @t, @stakeCnt, 1 + isnull((select max(height) from @BlockChain), 0)

	select @t = @t + 1
end

select * from @BlockChain
