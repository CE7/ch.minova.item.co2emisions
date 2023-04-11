alter procedure dbo.spReadItemCO2Emission (
	@KeyLong int output,
	@CalorificValueKG float output, 
	@CalorificValueT float output,
	@HeatingRelatedEmissionValueKG float output, 
	@HeatingRelatedEmissionValueT float output,
	@PriceCertificate money output, 
	@ExampleQty int output,
	@CalculatedEmissionOfDelivery float output, 
	@CalculatedPricePartCO2Costs float output,
	@EnergyOfDelivery float output,
	@EmissionActive bit output
)
with encryption as
	declare @ReturnCode int
	set @ReturnCode = 1
	
	set @CalculatedEmissionOfDelivery = null
	set @CalculatedPricePartCO2Costs = null
	set @EnergyOfDelivery = null
	set @ExampleQty = null
	
	select 
		@CalorificValueKG =CalorificValueKG,
		@CalorificValueT =CalorificValueT,
		@HeatingRelatedEmissionValueKG = HeatingRelatedEmissionValueKG,
		@HeatingRelatedEmissionValueT = HeatingRelatedEmissionValueT,
		@PriceCertificate = PriceCertificate,
		@EmissionActive = EmissionActive
	from tItem where Keylong = @KeyLong

	
return @ReturnCode