alter procedure dbo.hpCalculateExampleItemCO2Emission (
	@KeyLong int output,
	@CalorificValueKG float output, 
	@CalorificValueT float output, 
	@HeatingRelatedEmissionValueKG float output, 
	@HeatingRelatedEmissionValueT float output, 
	@PriceCertificate money output, 
	@ExampleQty float output, 
	@CalculatedEmissionOfDelivery float output, 
	@CalculatedPricePartCO2Costs float output, 
	@EnergyOfDelivery float output,
	@UseGJ bit output
)
with encryption as
	declare @Density float
	declare @GJ float = 277.77777778 -- kWh
	select @Density = DefaultDensity from tItem where KeyLong = @KeyLong
	
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
	
	--Dichte wird hier immer pro 1000l eingetragen, demnach nochmal durhc 1000 dividieren
	if(@Density > 100)
	begin
		set @Density = @Density / 1000
	end 
	
	if((@CalorificValueKG is null and @CalorificValueT is null) or (@HeatingRelatedEmissionValueKG is null and @HeatingRelatedEmissionValueT is null) or @PriceCertificate is null)
	begin
		raiserror('ADO | 30 | msg.NoValidItemCO2EmissionValues | Es fehlen Emissionsbezogene Stammdaten für dieses Produkt!',16, 1)
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
	
	-- Brennstoffemissionen der Lieferung
	if(@UseGJ=1)
	begin
		set @CalculatedEmissionOfDelivery = Round(@CalorificValueT * @HeatingRelatedEmissionValueT * @Density * @ExampleQty, 3)
	end 
	else
	begin
		set @CalculatedEmissionOfDelivery = Round(@CalorificValueKG * @HeatingRelatedEmissionValueKG * @Density * @ExampleQty, 3)
	end
	
	
	-- Preisbestandteil CO2-Kosten (inklusive der Mehrwertsteuer)
	set @CalculatedPricePartCO2Costs = ROUND(@CalculatedEmissionOfDelivery * @PriceCertificate / 1000 * 1.19,3)
	
	
	-- Energiegehalt der Lieferung
	if(@UseGJ=1)
	begin
		set @EnergyOfDelivery = ROUND(@CalorificValueT * @Density / 1000 * @ExampleQty * @GJ, 3)
	end 
	else
	begin
		set @EnergyOfDelivery = ROUND(@CalorificValueKG * @Density * @ExampleQty, 3)
	end
