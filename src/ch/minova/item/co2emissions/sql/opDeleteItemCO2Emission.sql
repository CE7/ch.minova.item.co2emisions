alter procedure dbo.opDeleteItemCO2Emission (
	@KeyLong int
)
with encryption as
	declare @ReturnCode int

	set @ReturnCode = 1

return @ReturnCode