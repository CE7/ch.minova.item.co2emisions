alter procedure dbo.spUpdateItemCO2Emission (
	@KeyLong int,
	@CalorificValueKG float, 
	@CalorificValueT float,
	@HeatingRelatedEmissionValueKG float, 
	@HeatingRelatedEmissionValueT float,
	@Pricecertificate money, 
	@ExampleQty int,
	@CalculatedEmissionOfDelivery float, 
	@CalculatedPricePartCO2Costs float,
	@EnergyOfDelivery float,
	@EmissionActive bit

)
with encryption as
	declare @ReturnCode int
	set @ReturnCode = 1
	declare @Density float = null
	select @Density = DefaultDensity from tItem where KeyLong = @KeyLong
	
	if(@EmissionActive = 1)
	begin
	
		if(@Density is null)
		begin 
			raiserror('ADO | 30 | msg.NoDefaultDenisty | Es fehlen die Standarddichte für dieses Produkt!',16, 1)
		end 
		
		if((@CalorificValueKG is null and CalorificValueT is null) or (@HeatingRelatedEmissionValueKG is null and @HeatingRelatedEmissionValueT is null) or @PriceCertificate is null)
		begin
			raiserror('ADO | 30 | msg.NoValidItemCO2EmissionValues | Es fehlen Emissionsbezogene Stammdaten für dieses Produkt!',16, 1)
		end 
	
		
		declare @GJ float = 277,778 -- kWh
		
		if(@HeatingRelatedEmissionValueKG is not null and @HeatingRelatedEmissionValueT is null)
		begin
			set @HeatingRelatedEmissionValueT = ROUND(@GJ * @HeatingRelatedEmissionValueKG / 1000, 5)
		end 
		
		if(HeatingRelatedEmissionValueKG is null and HeatingRelatedEmissionValueT is not null)
		begin
			set @HeatingRelatedEmissionValueKG = ROUND(@HeatingRelatedEmissionValueT * 1000 / @GJ, 5)
		end 
		
		if(@CalorificValueKG is not null and @CalorificValueT is null)
		begin
			set @CalorificValueT = ROUND(CalorificValueKG * 1000 / @GJ, 5)
		end 
		
		if(@CalorificValueT is not null and @CalorificValueKG is null)
		begin
			set @CalorificValueKG = ROUND(@CalorificValueT /1000 * @GJ, 5)
		end 
		
		update tItem
		set @CalorificValueKG = @CalorificValueKG,
		@CalorificValueT = @CalorificValueT,
		@HeatingRelatedEmissionValueKG = @HeatingRelatedEmissionValueKG,
		@HeatingRelatedEmissionValueT = @HeatingRelatedEmissionValueT,
		@PriceCertificate = @PriceCertificate,
		
		where KeyLong = @KeyLong
	
	end
		
	update tItem
	set EmissionActive = @EmissionActive
	where KeyLong = @KeyLong
	
return @ReturnCode