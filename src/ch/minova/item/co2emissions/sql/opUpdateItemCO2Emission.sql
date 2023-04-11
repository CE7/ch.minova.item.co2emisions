alter procedure dbo.opUpdateItemCO2Emission (
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
	@EmissionActive bit,
	@UseGJ bit
)
with encryption as
	declare @ReturnCode int
	set @ReturnCode = 1
	declare @Density float = null
	select @Density = DefaultDensity from tItem where KeyLong = @KeyLong
	
	declare @GJ float = 277.77777778 -- kWh
	
	if(@EmissionActive = 1)
	begin
	
		if(@UseGJ=1)
		begin 
			set @CalorificValueKG = null
			set @HeatingRelatedEmissionValueKG = null
		end 
		else
		begin
			set @CalorificValueT = null
			set @HeatingRelatedEmissionValueT = null
		end 
		
		
		if(@Density is null)
		begin 
			raiserror('ADO | 30 | msg.NoDefaultDenisty | Es fehlen die Standarddichte für dieses Produkt!',16, 1)
		end 
		
		if((@CalorificValueKG is null and @CalorificValueT is null) or (@HeatingRelatedEmissionValueKG is null and @HeatingRelatedEmissionValueT is null) or @PriceCertificate is null)
		begin
			raiserror('ADO | 30 | msg.NoValidItemCO2EmissionValues | Es fehlen Emissionsbezogene Stammdaten für dieses Produkt! Hinweis: wenn Sie mit GJ Rechnen wollen, müssen die Angaben in GJ gefüllt sein!',16, 1)
		end 
	
		if(@HeatingRelatedEmissionValueKG is not null and @HeatingRelatedEmissionValueT is null)
		begin
			set @HeatingRelatedEmissionValueT = ROUND(@GJ * @HeatingRelatedEmissionValueKG / 1000, 5)
		end 
		
		if(@HeatingRelatedEmissionValueKG is null and @HeatingRelatedEmissionValueT is not null)
		begin
			set @HeatingRelatedEmissionValueKG = ROUND(@HeatingRelatedEmissionValueT * 1000 / @GJ, 5)
		end 
		
		if(@CalorificValueKG is not null and @CalorificValueT is null)
		begin
			set @CalorificValueT = ROUND(@CalorificValueKG * 1000 / @GJ, 5)
		end 
		
		if(@CalorificValueT is not null and @CalorificValueKG is null)
		begin
			set @CalorificValueKG = ROUND(@CalorificValueT /1000 * @GJ, 5)
		end 
		
		
		
		update tItem
		set CalorificValueKG = @CalorificValueKG,
		CalorificValueT = @CalorificValueT,
		HeatingRelatedEmissionValueKG = @HeatingRelatedEmissionValueKG,
		HeatingRelatedEmissionValueT = @HeatingRelatedEmissionValueT,
		PriceCertificate = @PriceCertificate,
		UseGJ = @UseGJ,
		LastUser = current_user,
		LastDate = getDate(),
		LastAction = 2
		where KeyLong = @KeyLong
	
	end
		
	update tItem
	set EmissionActive = @EmissionActive,
		LastUser = current_user,
		LastDate = getDate(),
		LastAction = 2
	where KeyLong = @KeyLong
	
return @ReturnCode