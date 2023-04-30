require("Items/ProceduralDistributions")
require("Items/SuburbsDistributions")
require("Vehicles/VehicleDistributions")

local function n(i, d)
	if not i then
		i = d
	end

	if type(i) == "string" then
		i = {i}
	end

	return i
end

local function a(p, i, w)
	p, i = n(p), n(i)

	for _, pl in ipairs(p) do
		for _, it in ipairs(i) do
			table.insert(ProceduralDistributions.list[pl].items, it)
			table.insert(ProceduralDistributions.list[pl].items, w)
		end
	end
end
local function z(o, i, w)
	o = n(o)
	i = n(i)

	for _, zb in ipairs(o) do
		for _, it in ipairs(i) do
			table.insert(SuburbsDistributions["all"][zb].items, it)
			table.insert(SuburbsDistributions["all"][zb].items, w)
		end
	end
end
local function v(o, i, w)
	o = n(o)
	i = n(i)

	for _, pl in ipairs(o) do
		for _, it in ipairs(i) do
			table.insert(VehicleDistributions[pl].items, it)
			table.insert(VehicleDistributions[pl].items, w)
		end
	end
end
local function b(o, i, w)
	o = n(o)
	i = n(i)

	for _, pl in ipairs(o) do
		for _, it in ipairs(i) do
			table.insert(SuburbsDistributions[pl].items, it)
			table.insert(SuburbsDistributions[pl].items, w)
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
z({"inventorymale", "inventoryfemale"}, components, 0.05)
z({"Outfit_AmbulanceDriver", "Outfit_Doctor", "Outfit_Nurse"}, components, 0.1)
z({"Outfit_FiremanFullSuit", "Outfit_Police", "Outfit_PoliceState", "Outfit_Ranger"}, components, 0.075)
z("Outfit_Pharmacist", components, 1)
v("GloveBox", components, 0.5)
v("SurvivalistGlovebox", components, 0.75)
v("SurvivalistTruckBed", components, 0.1)
v({"DoctorTruckBed", "DoctorGloveBox"}, components, 1)
v({"AmbulanceTruckBed", "AmbulanceGloveBox"}, components, 8)
b({"Bag_DoctorBag", "Bag_MedicalBag"}, components, 0.1)
b({"FirstAidKit"}, components, 0.05)