alter procedure dbo.spDeleteItemCO2Emission (
	@KeyLong int
)
with encryption as
	declare @ReturnCode int

	set @ReturnCode = 1

return @ReturnCode