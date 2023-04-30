MedicalCocktail = MedicalCocktail or {}
MedicalCocktail.OnEat = MedicalCocktail.OnEat or {}
MedicalCocktail.Settings = MedicalCocktail.Settings or {}
MedicalCocktail.SideEffects = MedicalCocktail.SideEffects or {}

local SETTING_MODE = "MedicalCocktail.HealMode"
local SETTING_INSTANT = "MedicalCocktail.HealInstant"
local SETTING_SE_STD = "MedicalCocktail.SideEffects.Standard"
local SETTING_SE_INTOX = "MedicalCocktail.SideEffects.Intoxicated"
local SETTING_SE_NUTI = "MedicalCocktail.SideEffects.Nutrition"
local SETTING_SE_TRAIT = "MedicalCocktail.SideEffects.Trait"
local SETTING_SE_KILL = "MedicalCocktail.SideEffects.Death"
local MODES = {
	GOD = 1,
	FULL = 2,
	INFECT = 3,
	ZOMB = 4
}

local settings = SandboxVars

function MedicalCocktail.Settings.Mode()
	return settings[SETTING_MODE] or 2
end

function MedicalCocktail.Settings.Instant()
	return settings[SETTING_INSTANT] or false
end

function MedicalCocktail.Settings.SideEffects()
	return settings[SETTING_SE_STD] or true
end

function MedicalCocktail.Settings.SideEffects_Intox()
	return settings[SETTING_SE_INTOX] or true
end

function MedicalCocktail.Settings.SideEffects_Nutrition()
	return settings[SETTING_SE_NUTI] or true
end

function MedicalCocktail.Settings.SideEffects_Trait()
	return settings[SETTING_SE_TRAIT] or true
end

function MedicalCocktail.Settings.SideEffects_Death()
	return settings[SETTING_SE_KILL] or true
end

function MedicalCocktail.ResetInfection(mode, dmg)
	local instant, all = MedicalCocktail.Settings.Instant(), mode <= MODES.INFECT

	if instant then
		-- someone using the shitty mode >:(
		dmg:setInfectionLevel(0)
		dmg:setInfected(false)
		dmg:setFakeInfectionLevel(0)
		dmg:setIsFakeInfected(false)
		dmg:setInfectionTime(-1)
		dmg:setInfectionMortalityDuration(-1)

		if all then
			dmg:setHasACold(false)
			dmg:setColdStrength(0)
			dmg:setPoisonLevel(0)
			dmg:setFoodSicknessLevel(0)
			dmg:setColdReduction(0)
		end
	else
		-- Start by setting the fake infection to the same level as the current infection.
		dmg:setFakeInfectionLevel(
			math.max(
				dmg:getInfectionLevel(),
				dmg:getFakeInfectionLevel()
			)
		)
		dmg:setIsFakeInfected(true)

		-- We're alive, and "cleared" the real infection, so start reducing the fake one.
		-- This emulates the healing process, so it doesn't just do a "god heal".
		dmg:setReduceFakeInfection(true)

		-- Finally clear our regular infections.
		dmg:setInfectionLevel(0)
		dmg:setInfected(false)
		dmg:setInfectionTime(-1)
		dmg:setInfectionMortalityDuration(-1)

		if all then
			-- For food poisoning, clear any poisons.
			dmg:setPoisonLevel(0)

			-- We can't set a reducing level for colds, so yeah.
		end
	end
end

function MedicalCocktail.Heal(ply)
	local mode = MedicalCocktail.Settings.Mode()
	if mode == 1 then
		ply:getBodyDamage():RestoreToFullHealth()
	elseif mode == 2 then
		ply:setReduceInfectionPower(0)

		local dmg = ply:getBodyDamage()
		local parts = dmg:getBodyParts()
		for part = 1, BodyPartType.MAX:index() do
			part = parts:get(part - 1)
			part:setDeepWounded(false)
			part:setDeepWoundTime(0)

			part:setScratchTime(0)
			part:setScratched(false, false)

			part:setCutTime(0)
			part:setCut(false)

			part:setBiteTime(0)
			part:SetBitten(false)

			part:setBleedingTime(0)
			part:setBleeding(false)

			part:setHaveBullet(false, 0)
			part:setHaveGlass(false)

			part:setBurnTime(0)
			part:setNeedBurnWash(false)
			part:setLastTimeBurnWash(0)

			part:setFractureTime(0)

			part:setAlcoholLevel(0)
			part:setWoundInfectionLevel(0)
			part:setGarlicFactor(0)

			part:SetInfected(false)
			part:SetFakeInfected(false)
		end

		MedicalCocktail.ResetInfection(mode, dmg)
	elseif mode == 3 then
		local dmg = ply:getBodyDamage()
		local parts = dmg:getBodyParts()

		for part = 1, BodyPartType.MAX:index() do
			part = parts:get(part - 1)
			part:SetInfected(false)
			part:SetFakeInfected(false)
			part:setWoundInfectionLevel(0)
		end

		MedicalCocktail.ResetInfection(mode, dmg)
	elseif mode == 4 then
		local dmg = ply:getBodyDamage()
		local parts = dmg:getBodyParts()

		for part = 1, BodyPartType.MAX:index() do
			part = parts:get(part - 1)
			part:SetInfected(false)
			part:SetFakeInfected(false)
		end

		MedicalCocktail.ResetInfection(mode, dmg)
	end
end

function MedicalCocktail.SideEffects.Plain(stats, canPanic, canStarve)
	stats:setEndurance(stats:getEndurance() / 2)
	stats:setDrunkenness(100)

	if getServerOptions():getBoolean("SleepNeeded") then
		stats:setFatigue(math.max(stats:getFatigue(), 0.95))
	end
	if canPanic then
		stats:setPanic(100)
		stats:setBoredom(0)
	end
	if canStarve then
		stats:setHunger(100)
	end

	stats:setStress(1)
end


function MedicalCocktail.OnEat.Cocktail(_, ply, pct)
	if pct ~= 1 then
		return
	end

	if ZombRand(100) == 0 then
		ply:Say("I will survive.")
	end

	MedicalCocktail.Heal(ply)

	if not MedicalCocktail.Settings.SideEffects() then
		return
	end

	local allowTox, allowNut, allowTrait, allowDie =
		MedicalCocktail.Settings.SideEffects_Intox(),
		MedicalCocktail.Settings.SideEffects_Nutrition(),
		MedicalCocktail.Settings.SideEffects_Trait(),
		MedicalCocktail.Settings.SideEffects_Death()

	local canPanic = true
	if allowTrait then
		canPanic = not ply:HasTrait("Desensitized") and not ply:HasTrait("Brave")
	end

	local canStarve = true
	if allowTrait then
		canStarve = not ply:HasTrait("Iron Gut")
	end

	local stats, nut = ply:getStats(), ply:getNutrition()

	if not allowTox and not allowNut then
		MedicalCocktail.SideEffects.Plain(stats, canPanic, canStarve)
	else
		MedicalCocktail.SideEffects.Plain(stats, canPanic, canStarve)
	end
end
