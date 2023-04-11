alter procedure dbo.opInsertItemCO2Emission(
	@KeyLong int output,
	@CalorificValueKG float, 
	@CalorificValueT float,
	@HeatingRelatedEmissionValueKG float, 
	@HeatingRelatedEmissionValueT float,
	@PriceCertificate money, 
	@ExampleQty int,
	@CalculatedEmissionOfDelivery float, 
	@CalculatedPricePartCO2Costs float,
	@EnergyOfDelivery float,
	@EmissionActive bit,
	@UseGJ bit

)
with encryption as
	declare @ReturnCode int
	
	exec opUpdateItemCO2Emission 
				@KeyLong, 
				@CalorificValueKG, 
				@CalorificValueT,
				@HeatingRelatedEmissionValueKG, 
				@HeatingRelatedEmissionValueT,
				@PriceCertificate, 
				@ExampleQty,
				@CalculatedEmissionOfDelivery, 
				@CalculatedPricePartCO2Costs,
				@EnergyOfDelivery,
				@EmissionActive,
				@UseGJ
	
	set @ReturnCode = 1

return @ReturnCode