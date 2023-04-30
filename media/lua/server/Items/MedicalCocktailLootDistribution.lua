require "Items/ProceduralDistributions"

local function a(p, i, w)
	if type(p) == "string" then
		p = {p}
	end
	if type(i) == "string" then
		i = {i}
	end

	for _, pl in ipairs(p) do
		for _, it in ipairs(i) do
			table.insert(ProceduralDistributions.list[pl].items, it)
			table.insert(ProceduralDistributions.list[pl].items, w)
		end
	end
end

local components = {
	"MedicalCocktail.Amprenavir",
	"MedicalCocktail.Efavirenz",
	"MedicalCocktail.Nirmatrelvir",
	"MedicalCocktail.Nitazoxanide",
	"MedicalCocktail.Relenza",
}

a("StoreShelfMedical", components, 4)
a("ArmyStorageMedical", components, 2)
a("ArmyStorageMedical", "MedicalCocktail.Cocktail", 0.5)
a("MedicalClinicDrugs", components, 4)
a("MedicalStorageDrugs", components, 4)
a("MedicalStorageDrugs", components, 4)
a("MedicalStorageDrugs", components, 4)
a("MedicalStorageDrugs", components, 4)
a("MedicalStorageTools", "MedicalCocktail.Cocktail", 1)
a("SafehouseMedical", components, 4)
a("StoreShelfMedical", components, 1)
