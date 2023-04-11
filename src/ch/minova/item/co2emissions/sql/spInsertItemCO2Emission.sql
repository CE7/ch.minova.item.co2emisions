alter procedure dbo.spInsertItemCO2Emission(
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
	@EmissionActive bit

)
with encryption as
	declare @ReturnCode int
	
	exec updateItemCO2Emission 
				@KeyLong, 
				@CalorificValueKG, 
				@CalorificValueT,
				@HeatingRelatedEmissionValueKG, 
				@HeatingRelatedEmissionValueT,
				@PriceCertificate money, 
				@ExampleQty,
				@CalculatedEmissionOfDelivery, 
				@CalculatedPricePartCO2Costs,
				@EnergyOfDelivery,
				@EmissionActive
	
	set @ReturnCode = 1

return @ReturnCode