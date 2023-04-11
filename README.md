# ch.minova.item.co2emissions
Dieses Modul beinhaltet eine Op für ein Produkt, in der man die CO2 Emissionen eintragen kann


Bei der Rechnung wird nicht mehr auf Tonnen umgerechnet, sondern direkt mit kg, da die Abgaben auch mit der Geweichtseinheit Kg erstellt wurden.

Ausgehend von der Unity, die wie folgt rechnet: 

![Bildschirmfoto 2023-04-11 um 15 01 18](https://user-images.githubusercontent.com/20420898/231170241-5d16e246-2840-4414-b483-e1ebe527782a.png)


Hier ein Beispiel mit anderen Zahlen

### Brennstoffemission der Lieferung: 
* Heizwert in (kg CO2/kWh) * Heiz. Emmisionsfaktor (kg Co2/KWh) * Dichte (Kg /L) * Liefermenge (L) 
* 11,88889 * 0,26640 * 0,845 * 1000 = 2676,2842... wird auf 3 Nachkommastellen gerundet!!
* =2676,284 kg CO2

### Preisbestandteil
* Brennstoffemission der Lieferung * Festpreis CO2 Zertifikat * Umsatzsteuer
* 2676,284 kg CO2/kWh * 0,030 € /Kg CO2 * 1,19€ hier wird auf die 2. Stelle nach dem Komma gerundet!!
* =95,54 €

### Energiegehalt der Lieferung
* Heizwert in (kg CO2/kWh) * Dichte (Kg/L) * gelieferte Liter (L), hier wird auf die 3. Stelle nach dem Komma gerundet!!
* 11,88889 * 0,845 * 1000
* =10046,112 kWh

