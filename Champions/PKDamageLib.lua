--[[

Usage:

---- Add this to your Lua ----

>>>>> This check Users scripts Folder if the Lib available and download if Lib does not exist <<<<<
-----------------------------------------------------------------------------------------------------
if not file_manager:file_exists("PKDamageLib.lua") then
	local file_name = "PKDamageLib.lua"
	local url = "http://raw.githubusercontent.com/Astraanator/test/main/Champions/PKDamageLib.lua"   	
	http:download_file(url, file_name)
end
-----------------------------------------------------------------------------------------------------

>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<

---- PKDamageLib API ----

>>>>>> Params: <<<<<<

-> getdmg("spell", target, source, stage)

	spell == "Q" or "W" or "E" or "R" or "QM" or "WM" or "EM"   
			 "QM"/"WM"/"EM" == like Nidalee, Grar or Elise different Forms
			 "AA" <-- calculate Autoattack damage
			 "IGNITE" <-- calculate Ignite damage
			 "SMITE" <-- calculate Smite damage ///// stage 1 = "Smite" ///// stage 2 = "Upgrade 1" ///// stage 3 = "Upgrade 2"
			 
	target == game_object

	source == game_object

	stage == 1 or 2 / Check DamageLibTable if there more stages for your Champion Spell



	>>>>> stage check example Ahri Q <<<<<<
	  
	  ["Ahri"] = {
		{Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + 0.35 * source.ability_power end},
		{Slot = "Q", Stage = 2, DamageType = 3, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + 0.35 * source.ability_power end},
	  
	  You see Ahri Q have 2 Stages ,,,, Stage = 1 and Stage = 2
	  
	  Explanation:
					Stage = 1 / return the dmg for Ahri Q Orb if hit target after cast
					Stage = 2 / return the dmg for Ahri Q if the Orb hit the target when coming back


	  
	>>>>>>> Simble Example Killsteal function Akali E <<<<<<<

	local function KillSteal()
		for i, target in ipairs(GetEnemyHeroes()) do     	
			if target.object_id ~= 0 then	
				local EDmg = getdmg("E", target, game.local_player, 1)		
		
				if EDmg > target.health then
					>>>>CastE	
				end		
			end
		end
	end	
	

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

--/////////////////////////////////////////////////////////////////////////////////////
	------ITEM PassiveProc.Damage API------
--/////////////////////////////////////////////////////////////////////////////////////

---Return only PassiveDmg from Items---
-> getdmg_item(target, source)

---Return PassiveItemDmg + AADmg---
-> getdmg("AA", target, source, stage)
	stage(1) = returns only AADmg
	stage(2) = returns AADmg + ItemDmg
	
---------------------------------------------------------------------------------------------------------------------	
---------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>> INCOMING DAMAGE API <<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>> BY PUSSYKATE <<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<

-> GetIncomingDmg(game_object, hittime, DamageTyp Input)

	- game_object[myHero or Ally]
	- hittime[Time-Before-Hit]  > Time from when the Spell Dmg should be calculated (default value = 0.1) <
	- DamageTyp Input > Add here your table with the units from which you want to get the Incoming Damages 
 

	-----------Example-------------

	local IncDmg_Input = {
		Damages = {"minion", "hero", "turret"}
	}

	local function GetIncDmg()
		local IncDmg = GetIncomingDmg(myHero, 0.2, IncDmg_Input)
		if IncDmg > 0 then
			local PercentHpAfterDmg = (myHero.health-IncDmg)/myHero.max_health*100
			if PercentHpAfterDmg <= 20 then     ---<--- (if your hp falls below 20% due to the inc.dmg)
				console:log(tostring("Incoming-Dmg: "..IncDmg))
			end
		end
	end


---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>> Get CCSpells API <<<<<<<<<<<<<<<<<<<

-> GetCCSpells(game_object)
	- game_object[myHero or Ally]

	Return if CC Spell[boolean]
	Return Time-Before-Hit[number]
	Return Spell-Name[string]


	-----------Example-------------
	local IsCC, Hittime, Name = GetCCSpells(myHero)
	if IsCC then
		console:log(tostring("CC-SpellName: "..Name))
		console:log(tostring("Time-Before-Hit: "..tonumber(string.format("%.2f", Hittime)))) 
	end
]]



-- [ AutoUpdate ]
local Version = 78
do
	local function AutoUpdate()
		local file_name = "PKDamageLib.lua"
		local url = "http://raw.githubusercontent.com/Astraanator/test/main/Champions/PKDamageLib.lua"
		
		http:get_async("http://raw.githubusercontent.com/Astraanator/test/main/Champions/PKDamageLib.version", function(success, response)
			if success and tonumber(response) ~= Version then
				http:download_file_async(url, file_name, function(success)
					if success then
						console:log("PKDamageLib updated to Version: " .. tonumber(response))
					end	
				end)
			end
		end)
	end

	local function MustHave()
		if not file_manager:file_exists("Prediction.lib") then
			http:download_file_async("https://raw.githubusercontent.com/Ark223/Bruhwalker/main/Prediction.lib", "Prediction.lib", function(success)
				if success then
					---
				end	
			end)
		end
	end

	AutoUpdate()
	MustHave()
end

local DmgReductTable = {
	["Braum"] = { buff = "braumshieldbuff",
		amount = function(target) return 1 - ({ 0.3, 0.325, 0.35, 0.375, 0.4 })[target:get_spell_slot(SLOT_E).level] end }, --E
	["Alistar"] = { buff = "FerociousHowl",
		amount = function(target) return 1 - ({ 0.55, 0.66, 0.75 })[target:get_spell_slot(SLOT_R).level] end }, --R
	["Galio"] = { buff = "galiowbuff",
		amount = function(target) return 1 - ({ 0.2, 0.25, 0.3, 0.35, 0.4 })[target:get_spell_slot(SLOT_W).level] end,
		damageType = 2 }, --W
	["Galio"] = { buff = "galiowbuff",
		amount = function(target) return 1 - ({ 0.1, 0.125, 0.15, 0.175, 0.2 })[target:get_spell_slot(SLOT_W).level] end,
		damageType = 1 }, --W
	["Garen"] = { buff = "GarenW", amount = function(target) return 0.7 end }, --W
	["Gragas"] = { buff = "gragaswself",
		amount = function(target) return 1 - ({ 0.1, 0.12, 0.14, 0.16, 0.18 })[target:get_spell_slot(SLOT_W).level] end }, --W
	["Irelia"] = { buff = "ireliawdefense",
		amount = function(target) return 1 - ((40 + 30 / 17 * (target.level - 1)) / 100
				)
		end, damageType = 1 }, --W
	["Irelia"] = { buff = "ireliawdefense",
		amount = function(target) return 1 - ((20 + 15 / 17 * (target.level - 1)) / 100
				)
		end, damageType = 2 }, --W
	["Malzahar"] = { buff = "malzaharpassiveshield", amount = function(target) return 0.1 end }, --Passive
	["MasterYi"] = { buff = "Meditate",
		amount = function(target) return 1 - ({ 0.6, 0.625, 0.65, 0.675, 0.7 })[target:get_spell_slot(SLOT_W).level] end }, --W
	["Warwick"] = { buff = "WarwickE",
		amount = function(target) return 1 - ({ 0.35, 0.40, 0.45, 0.50, 0.55 })[target:get_spell_slot(SLOT_E).level] end }, --E
}

local function GetDistanceSqr(p1, p2)
	return (p1.x - p2.x) * (p1.x - p2.x) + ((p1.z or p1.y) - (p2.z or p2.y)) * ((p1.z or p1.y) - (p2.z or p2.y))
end

local function GetDistance(p1, p2)
	return math.sqrt(GetDistanceSqr(p1, p2))
end

local function GetEnemyHeroes()
	local _EnemyHeroes = {}
	players = game.players
	for i, unit in ipairs(players) do
		if unit and unit.is_enemy then
			table.insert(_EnemyHeroes, unit)
		end
	end
	return _EnemyHeroes
end

local function GetAllyHeroes()
	local _AllyHeroes = {}
	players = game.players
	for i, unit in ipairs(players) do
		if unit and not unit.is_enemy then
			table.insert(_AllyHeroes, unit)
		end
	end
	return _AllyHeroes
end

local function IsAlly(name)
	for i, ally in ipairs(GetAllyHeroes()) do 
		return ally and ally.champ_name == name
	end
end

local function DmgReduction(source, target, amount, DamageType)
	local CalcDmg = amount

	if source.is_hero then
		if source:has_buff("summonerexhaustdebuff") then
			CalcDmg = CalcDmg * 0.6
		end
	end

	if target.is_hero then

		if DmgReductTable[target.champ_name] then
			if target:has_buff(DmgReductTable[target.champ_name].buff) and
				(not DmgReductTable[target.champ_name].damagetype or DmgReductTable[target.champ_name].damagetype == DamageType) then
				CalcDmg = CalcDmg * DmgReductTable[target.champ_name].amount(target)
			end
		end

		if target.champ_name == "Amumu" and target:has_buff("Tantrum") and DamageType == 1 then --E
			CalcDmg = CalcDmg -
				(({ 2, 4, 6, 8, 10 })[target:get_spell_slot(SLOT_E).level] + 0.03 * target.bonus_armor + 0.03 * target.bonus_mr)
		end

		if target.champ_name == "Leona" and target:has_buff("LeonaSolarBarrier") then --W
			if CalcDmg / 2 < (({ 8, 12, 16, 20, 24 })[target:get_spell_slot(SLOT_W).level]) then
				CalcDmg = CalcDmg / 2
			else
				CalcDmg = CalcDmg - (({ 8, 12, 16, 20, 24 })[target:get_spell_slot(SLOT_W).level])
			end
		end

		if target.champ_name == "Fizz" then --Passive
			if CalcDmg / 2 < (4 + (0.01 * target.ability_power)) then
				CalcDmg = CalcDmg / 2
			else
				CalcDmg = CalcDmg - (4 + (0.01 * target.ability_power))
			end
		end

		if target.champ_name == "Kassadin" and DamageType == 2 then --Passive
			CalcDmg = CalcDmg * 0.9
		end

		if target:has_buff("4644shield") then --Item /  Crown of the Shattered Queen
			CalcDmg = CalcDmg * 0.25
		end

		if target:has_buff("4401maxstacked") and DamageType == 2 then --Item /  Force of Nature
			CalcDmg = CalcDmg * 0.75
		end

	end
	return CalcDmg
end

local function GetPercentHP(unit)
	return unit:health_percentage()
end

local function GotBuff(unit, buffname)
	local Buff = unit:get_buff(buffname)
	if Buff.count > 0 then
		return Buff.count
	end
	return 0
end

local function GotSpell(unit, spellslot, spellname)
	if unit:get_spell_slot(spellslot).spell_data.spell_name == spellname then
		return true
	end
	return false
end

local function GetBuffData(unit, buffname)
	local buff = unit:get_buff(buffname)
	if buff and buff.is_valid then
		return buff
	end
	return { type = 0, name = "", startTime = 0, expireTime = 0, duration = 0, stacks = 0, count = 0 }
end

local function HasPoison(unit)
	if unit:has_buff_type(24) then
		return true
	end
	return false
end

local function KSante_WDmg(source, target)
	local lvl = source:get_spell_slot(SLOT_W).level
	local Dmg = ({ 25, 35, 45, 55, 65 })[lvl] + 0.5 * source.total_attack_damage +
		({ 0.02, 0.0225, 0.025, 0.0275, 0.03 })[lvl] * target.max_health
	if source:has_buff("KSanteRTransform") then
		Dmg = ({ 110, 170, 230, 290, 350 })[lvl] + 0.5 * source.total_attack_damage +
			({ 0.07, 0.0725, 0.075, 0.0775, 0.08 })[lvl] * target.max_health
	end
	return Dmg
end

local function GetBaseHealth(unit)
	if unit.champ_name == "Chogath" then
		local BonusHealth = 0
		local ChampLvL = unit.level
		local UltLvL = unit:get_spell_slot(SLOT_R).level
		if UltLvL >= 1 then
			local BaseHealth = unit.base_health
			local FeastBonus = ({ 80, 120, 160 })[UltLvL] * unit:get_buff("Feast").stacks2
			BonusHealth = (math.ceil(unit.max_health) - BaseHealth - FeastBonus)
		end
		return BonusHealth

	elseif unit.champ_name == "Volibear" then
		return unit.base_health
	end
end

local function Azir_WResult(level)  
	if level <= 9 then
		return 0
	elseif level == 10 then
		return 2
	elseif level <= 13 then
		return (level * 5) - 48   
	else
		return (level * 15) - 178
	end	
end

-->>>>>>>>>>>>>>>>>>>> Game.Version 13.9 <<<<<<<<<<<<<<<<<<<<<<<<<--

local DamageLibTable = {
	["Aatrox"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 10, 30, 50, 70, 90 })[level] +
					({ 0.6, 0.65, 0.7, 0.75, 0.8 })[level] * source.total_attack_damage
			end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 30, 40, 50, 60, 70 })[level] + 0.4 * source.total_attack_damage end },
	},

	["Ahri"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 40, 65, 90, 115, 140 })[level] + 0.45 * source.ability_power end },
		{ Slot = "Q", Stage = 2, DamageType = 3,
			Damage = function(source, target, level) return ({ 40, 65, 90, 115, 140 })[level] + 0.45 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 75, 100, 125, 150 })[level] + 0.3 * source.ability_power end },
		{ Slot = "W", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 15, 22.5, 30, 37.5, 45 })[level] + 0.09 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 110, 140, 170, 200 })[level] + 0.6 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 90, 120 })[level] + 0.35 * source.ability_power end },
	},

	["Akali"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 30, 55, 80, 105, 130 })[level] + 0.6 * source.ability_power +
					0.65 * source.total_attack_damage
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 100, 187, 275, 362, 450 })[level] + 1.2 * source.ability_power +
					0.85 * source.total_attack_damage
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 220, 360 })[level] + 0.3 * source.ability_power +
					0.5 * source.bonus_attack_damage
			end },
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 130, 200 })[level] + 0.3 * source.ability_power end },
	},

	["Akshan"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 5, 25, 45, 65, 85 })[level] + 0.8 * source.total_attack_damage end }, -- Dmg one Pass
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 30, 45, 60, 75, 90 })[level] + 0.175 * source.bonus_attack_damage +
					0.3 * source.bonus_attack_speed
			end }, -- per Shot
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 25, 30 })[level] + 0.1 * source.total_attack_damage +
					((3 * (1 - target.health / target.max_health)) * (({ 20, 25, 30 })[level] + 0.1 * source.total_attack_damage))
			end }, -- per Bullet
	},

	["Alistar"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 100, 140, 180, 220 })[level] + 0.8 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 55, 110, 165, 220, 275 })[level] + source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 110, 140, 170, 200 })[level] + 0.7 * source.ability_power end },
	},

	["Amumu"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 95, 120, 145, 170 })[level] + 0.85 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 6, 8, 10, 12, 14 })[level] +
					(({ 0.01, 0.0115, 0.013, 0.0145, 0.016 })[level] + 0.025 * source.ability_power / 100) * target.max_health
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 65, 100, 135, 170, 205 })[level] + 0.5 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 200, 300, 400 })[level] + 0.8 * source.ability_power end },
	},

	["Anivia"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 70, 90, 110, 130 })[level] + 0.25 * source.ability_power end },
		{ Slot = "Q", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 95, 130, 165, 200 })[level] + 0.45 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return (({ 50, 75, 100, 125, 150 })[level] + 0.6 * source.ability_power) *
					(target:has_buff("aniviachilled") and 2 or 1)
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 30, 45, 60 })[level] + 0.125 * source.ability_power end },
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 90, 135, 180 })[level] + 0.375 * source.ability_power end },
	},

	["Annie"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 115, 150, 185, 220 })[level] + 0.8 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 115, 160, 205, 250 })[level] + 0.85 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 275, 400 })[level] + 0.65 * source.ability_power end },
	},

	["Aphelios"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 85, 110, 135, 160 })[level] + source.ability_power +
					0.6 * source.bonus_attack_damage
			end },
		{ Slot = "Q", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return (({ 10, 15, 20, 25, 30 })[level] + 0.30 * source.bonus_attack_damage)
					* 6
			end },
		{ Slot = "Q", Stage = 3, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 65, 80, 95, 110 })[level] + 0.7 * source.ability_power +
					0.35 * source.bonus_attack_damage
			end },
		{ Slot = "Q", Stage = 4, DamageType = 2,
			Damage = function(source, target, level) return ({ 25, 35, 45, 55, 65 })[level] + 0.7 * source.ability_power +
					0.8 * source.bonus_attack_damage
			end },
		{ Slot = "Q", Stage = 5, DamageType = 2,
			Damage = function(source, target, level) return ({ 25, 40, 55, 70, 85 })[level] + 0.5 * source.ability_power +
					0.5 * source.bonus_attack_damage
			end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 125, 175, 225 })[level] + source.ability_power +
					0.2 * source.bonus_attack_damage
			end },
		{ Slot = "R", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 175, 275, 375 })[level] + source.ability_power +
					0.45 * source.bonus_attack_damage
			end },
		{ Slot = "R", Stage = 3, DamageType = 1,
			Damage = function(source, target, level) return ({ 125, 175, 225 })[level] + source.ability_power +
					0.2 * source.bonus_attack_damage +
					(GotSpell(source, SLOT_Q, "ApheliosInfernumQ") * (({ 50, 100, 150 })[level] + 0.25 * source.bonus_attack_damage))
			end },
	},

	["Ashe"] = {
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 10, 25, 40, 55, 70 })[level] + source.total_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 200, 400, 600 })[level] + source.ability_power end },
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return (({ 100, 200, 300 })[level] + 0.5 * source.ability_power) end },
	},

	["AurelionSol"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 15, 25, 35, 45, 55 })[level] + 0.6 * source.ability_power + (30 + 50 / 17 * (source.level-1)) end }, --per sec
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 10, 15, 20, 25, 30 })[level] + 0.4 * source.ability_power end },				
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + 0.65 * source.ability_power end },
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 337, 562, 787 })[level] + 1.41 * source.ability_power end },	--EMPOWERED	
	},

	["Azir"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 80, 100, 120, 140 })[level] + 0.35 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 67, 84, 101, 118 })[level] + 0.55 * source.ability_power + Azir_WResult(source.level) end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 100, 140, 180, 220 })[level] + 0.4 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 200, 400, 600 })[level] + 0.75 * source.ability_power end },
	},

	["Blitzcrank"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 105, 155, 205, 255, 305 })[level] + 1.2 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return 1.75 * source.total_attack_damage + 0.25 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 275, 400, 525 })[level] + 1.25 * source.ability_power end },
	},

	["Bard"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 125, 170, 215, 260 })[level] + 0.65 * source.ability_power end },
	},

	["Brand"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 110, 140, 170, 200 })[level] + 0.55 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 120, 165, 210, 255 })[level] + 0.6 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 95, 120, 145, 170 })[level] + 0.45 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 100, 200, 300 })[level] + 0.25 * source.ability_power end },
	},

	["Belveth"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 10, 15, 20, 25, 30 })[level] + 1.1 * source.total_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 110, 150, 190, 230 })[level] + 1.25 * source.ability_power +
					source.bonus_attack_damage
			end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 8, 11, 14, 17, 20 })[level] + 0.06 * source.total_attack_damage end }, --Per Hit
		{ Slot = "R", Stage = 1, DamageType = 3,
			Damage = function(source, target, level) return ({ 150, 200, 250 })[level] + source.ability_power +
					(0.25 * (target.max_health - target.health))
			end },
	},

	["Braum"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 125, 175, 225, 275 })[level] + 0.025 * source.max_health end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 300, 450 })[level] + 0.6 * source.ability_power end },
	},

	["Caitlyn"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 50, 90, 130, 170, 210 })[level] +
					({ 1.25, 1.45, 1.65, 1.85, 2.05 })[level] * source.total_attack_damage
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 130, 180, 230, 280 })[level] + 0.8 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 300, 525, 750 })[level] + 2 * source.bonus_attack_damage end },
	},

	["Camille"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 0.2, 0.25, 0.3, 0.35, 0.4 })[level] * source.total_attack_damage end },
		{ Slot = "Q", Stage = 2, DamageType = 3,
			Damage = function(source, target, level) return ({ 0.2, 0.25, 0.3, 0.35, 0.4 })[level] * source.total_attack_damage *
					2
			end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 70, 100, 130, 160, 190 })[level] + 0.6 * source.bonus_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 80, 110, 140, 170, 200 })[level] + 0.9 * source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 5, 10, 15 })[level] + ({ 0.04, 0.06, 0.08 })[level] * target.health end },
	},

	["Cassiopeia"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 110, 145, 180, 215 })[level] + 0.9 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 20, 25, 30, 35, 40 })[level] + 0.15 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return 48 + 4 * source.level + 0.1 * source.ability_power +
					(HasPoison(target) and ({ 20, 40, 60, 80, 100 })[level] + 0.6 * source.ability_power or 0)
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + 0.5 * source.ability_power end },
	},

	["Chogath"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 140, 200, 260, 320 })[level] + source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 135, 190, 245, 300 })[level] + 0.7 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 22, 34, 46, 58, 70 })[level] + 0.3 * source.ability_power +
					0.03 * target.max_health
			end },
		{ Slot = "R", Stage = 1, DamageType = 3,
			Damage = function(source, target, level) return ({ 300, 475, 650 })[level] + 0.5 * source.ability_power +
					0.1 * GetBaseHealth(source)
			end },
	},

	["Corki"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 120, 165, 210, 255 })[level] + 0.5 * source.ability_power +
					0.7 * source.bonus_attack_damage
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 120, 180, 240, 300, 360 })[level] + 0.8 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 30, 45, 60, 75, 90 })[level] + (1.5 * source.total_attack_damage) +
					0.2 * source.ability_power
			end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 32, 44, 56, 68 })[level] + 0.4 * source.total_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 115, 155 })[level] + 0.12 * source.ability_power +
					({ 0.15, 0.45, 0.75 })[level] * source.total_attack_damage
			end },
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 160, 230, 300 })[level] + 0.24 * source.ability_power +
					({ 0.3, 0.9, 1.5 })[level] * source.total_attack_damage
			end },
	},

	["Darius"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 50, 80, 110, 140, 170 })[level] +
					(({ 1.0, 1.1, 1.2, 1.3, 1.4 })[level] * source.total_attack_damage)
			end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 0.4, 0.45, 0.5, 0.55, 0.6 })[level] * source.total_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 3,
			Damage = function(source, target, level) return ({ 125, 250, 375 })[level] + 0.75 * source.bonus_attack_damage end },
	},

	["Diana"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 95, 130, 165, 200 })[level] + 0.7 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 18, 30, 42, 54, 66 })[level] + 0.15 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 70, 90, 110, 130 })[level] + 0.5 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 200, 300, 400 })[level] + 0.6 * source.ability_power end }, --MainDmg
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 35, 60, 85 })[level] + 0.15 * source.ability_power end }, --+Dmg
	},

	["DrMundo"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) if target.is_minion then return math.min(({ 350, 425, 500, 575, 650 })[level
						], math.max(({ 80, 135, 190, 245, 300 })[level], ({ 20, 22.5, 25, 27.5, 30 })[level] / 100 * target.health))
				end
				return math
					.max(({ 80, 135, 190, 245, 300 })[level], ({ 20, 22.5, 25, 27.5, 30 })[level] / 100 * target.health)
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 20, 27, 35, 42, 50 })[level] + 0.1 * source.ability_power end }
	},

	["Draven"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 40, 45, 50, 55, 60 })[level] +
					(({ 0.75, 0.85, 0.95, 1, 05, 1.15 })[level] * source.bonus_attack_damage)
			end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 75, 110, 145, 180, 215 })[level] + 0.5 * source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 175, 275, 375 })[level] +
					({ 1.1, 1.3, 1.5 })[level] * source.bonus_attack_damage
			end },
	},

	["Ekko"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 75, 90, 105, 120 })[level] + 0.3 * source.ability_power end },
		{ Slot = "Q", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 40, 65, 90, 115, 140 })[level] + 0.6 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 75, 100, 125, 150 })[level] + 0.4 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 200, 350, 500 })[level] + 1.75 * source.ability_power end }
	},

	["Elise"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 40, 75, 110, 145, 180 })[level] +
					(0.04 + 0.03 / 100 * source.ability_power) * target.health
			end },
		{ Slot = "Q", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 90, 120, 150, 180 })[level] +
					(0.08 + 0.03 / 100 * source.ability_power) * (target.max_health - target.health)
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 105, 150, 195, 240 })[level] + 0.95 * source.ability_power end },
	},

	["Evelynn"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 25, 30, 35, 40, 45 })[level] + 0.3 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 55, 70, 85, 100, 115 })[level] +
					(0.03 + 0.15 / 100 * source.ability_power) * target.max_health
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 125, 250, 375 })[level] + 0.75 * source.ability_power end },
	},

	["Ezreal"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 45, 70, 95, 120 })[level] + 0.15 * source.ability_power +
					1.3 * source.total_attack_damage
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 135, 190, 245, 300 })[level] +
					(({ 0.7, 0.75, 0.8, 0.85, 0.9 })[level] * source.ability_power) + 0.6 * source.bonus_attack_damage
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 130, 180, 230, 280 })[level] + 0.75 * source.ability_power +
					0.5 * source.bonus_attack_damage
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 350, 500, 650 })[level] + 0.9 * source.ability_power +
					source.bonus_attack_damage
			end },
	},

	["FiddleSticks"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 0.06, 0.07, 0.08, 0.09, 0.1 })[level] +
					math.floor(source.ability_power / 10000) * target.health
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 120, 180, 240, 300, 360 })[level] + 0.7 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 0.5 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 750, 1250, 1750 })[level] + 2.5 * source.ability_power end },
	},

	["Fiora"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 70, 80, 90, 100, 110 })[level] +
					({ 0.9, 0.95, 1, 1.05, 1.1 })[level] * source.bonus_attack_damage
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 110, 150, 190, 230, 270 })[level] + source.ability_power end },
	},

	["Fizz"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 10, 25, 40, 55, 70 })[level] + 0.55 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 70, 90, 110, 130 })[level] + 0.5 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 130, 180, 230, 280 })[level] + 0.9 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + 0.8 * source.ability_power end },
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 225, 325, 425 })[level] + source.ability_power end },
		{ Slot = "R", Stage = 3, DamageType = 2,
			Damage = function(source, target, level) return ({ 300, 400, 500 })[level] + 1.2 * source.ability_power end },
	},

	["Galio"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 0.75 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 90, 130, 170, 210, 250 })[level] + 0.9 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + 0.7 * source.ability_power end },
	},

	["Gangplank"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 10, 40, 70, 100, 130 })[level] + source.total_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 40, 70, 100 })[level] + 0.1 * source.ability_power end },
	},

	["Garen"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 30, 60, 90, 120, 150 })[level] + 0.5 * source.total_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 4, 8, 12, 16, 20 })[level] + (0.471 + 0.471 * source.level) +
					({ 32, 34, 36, 38, 40 })[level] / 100 * source.total_attack_damage
			end },
		{ Slot = "R", Stage = 1, DamageType = 3,
			Damage = function(source, target, level) return ({ 150, 300, 450 })[level] +
					({ 25, 30, 35 })[level] / 100 * (target.max_health - target.health)
			end },
	},

	["Gnar"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 5, 45, 85, 125, 165 })[level] + 1.15 * source.total_attack_damage end },
		{ Slot = "QM", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 25, 70, 115, 160, 205 })[level] + 1.4 * source.total_attack_damage end },
		{ Slot = "WM", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 25, 55, 85, 115, 145 })[level] + source.total_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 50, 85, 120, 155, 190 })[level] + source.max_health * 0.06 end },
		{ Slot = "EM", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 80, 115, 150, 185, 220 })[level] + source.max_health * 0.06 end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 200, 300, 400 })[level] + source.ability_power +
					0.5 * source.bonus_attack_damage
			end },
	},

	["Gragas"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 120, 160, 200, 240 })[level] + 0.8 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 20, 50, 80, 110, 140 })[level] + 0.7 * source.ability_power +
					0.07 * target.max_health
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 125, 170, 215, 260 })[level] + 0.6 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 200, 300, 400 })[level] + 0.8 * source.ability_power end },
	},

	["Graves"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 45, 60, 75, 90, 105 })[level] + 0.8 * source.bonus_attack_damage end },
		{ Slot = "Q", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 85, 120, 155, 190, 225 })[level] +
					({ 0.4, 0.7, 1.0, 1.3, 1.6 })[level] * source.bonus_attack_damage
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 110, 160, 210, 260 })[level] + 0.6 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 275, 425, 575 })[level] + 1.5 * source.bonus_attack_damage end },
		{ Slot = "R", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 220, 340, 460 })[level] + 1.2 * source.bonus_attack_damage end },
	},

	["Gwen"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 10, 15, 20, 25, 30 })[level] + 0.05 * source.ability_power end }, --- noraml dmg each snap
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return 15 + 0.2 * source.ability_power end }, -- Bonus attack dmg for next aa
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 35, 65, 95 })[level] + 0.1 * source.ability_power +
					(((0.008 * source.ability_power / 100) + 0.01) * target.max_health)
			end }, --First Cast
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 105, 195, 285 })[level] + 0.3 * source.ability_power +
					(((0.024 * source.ability_power / 100) + 0.03) * target.max_health)
			end }, --Second Cast
		{ Slot = "R", Stage = 3, DamageType = 2,
			Damage = function(source, target, level) return ({ 175, 325, 475 })[level] + 0.5 * source.ability_power +
					(((0.04 * source.ability_power / 100) + 0.05) * target.max_health)
			end }, --Third Cast
	},

	["Hecarim"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 60, 85, 110, 135, 160 })[level] + 0.9 * source.bonus_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 20, 30, 40, 50, 60 })[level] + 0.2 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 30, 45, 60, 75, 90 })[level] + 0.5 * source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + source.ability_power end },
	},

	["Heimerdinger"] = {
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 75, 100, 125, 150 })[level] + 0.45 * source.ability_power end },
		{ Slot = "W", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 135, 180, 225 })[source:get_spell_slot(SLOT_R).level] +
					0.45 * source.ability_power
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 100, 140, 180, 220 })[level] + 0.6 * source.ability_power end },
		{ Slot = "E", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 100, 200, 300 })[source:get_spell_slot(SLOT_R).level] +
					0.6 * source.ability_power
			end },
	},

	["Illaoi"] = {
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return 0.04 * source.total_attack_damage / 100 +
					({ 0.03, 0.035, 0.04, 0.045, 0.05 })[level] * target.max_health
			end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + 0.5 * source.bonus_attack_damage end },
	},

	["Irelia"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 5, 25, 45, 65, 85 })[level] + 0.6 * source.total_attack_damage end },
		{ Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return 43 + 12 * source.level end }, --Minion Damage
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 10, 25, 40, 55, 70 })[level] + 0.4 * source.total_attack_damage +
					0.4 * source.ability_power
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 125, 170, 215, 260 })[level] + 0.8 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 125, 250, 375 })[level] + 0.7 * source.ability_power end },
	},

	["Ivern"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 125, 170, 215, 260 })[level] + 0.7 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 90, 110, 130, 150 })[level] + 0.8 * source.ability_power end },
	},

	["Janna"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 85, 110, 135, 160 })[level] + 0.35 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 110, 140, 170, 200 })[level] + 0.6 * source.ability_power +
					(
					({ 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35 })[
						source.level] * source.move_speed)
			end },
	},

	["JarvanIV"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 80, 120, 160, 200, 240 })[level] + 1.4 * source.bonus_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 120, 160, 200, 240 })[level] + 0.8 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 200, 325, 450 })[level] + 1.8 * source.bonus_attack_damage end },
	},

	["Jax"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 65, 105, 145, 185, 225 })[level] + source.bonus_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 85, 120, 155, 190 })[level] + 0.6 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 55, 85, 115, 145, 175 })[level] + 0.7 * source.ability_power + 0.04 * target.max_health end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 110, 160 })[level] + 0.6 * source.ability_power end },
	},

	["Jayce"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 60, 110, 160, 210, 260, 310 })[level] +
					1.2 * source.bonus_attack_damage
			end },
		{ Slot = "QM", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 55, 110, 165, 220, 275, 330 })[level] +
					1.2 * source.bonus_attack_damage
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 35, 50, 65, 80, 95, 110 })[level] + 0.25 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return (({ 8, 10.8, 13.6, 16.4, 19.2, 22 })[level] / 100) * target.max_health
					+ source.bonus_attack_damage
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 25, 65, 105, 145 })[level] + 0.25 * source.bonus_attack_damage end },
	},

	["Jhin"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 45, 70, 95, 120, 145 })[level] +
					(({ 0.35, 0.425, 0.5, 0.575, 0.65 })[level] * source.total_attack_damage) + 0.6 * source.ability_power
			end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 60, 95, 130, 165, 200 })[level] + 0.5 * source.total_attack_damage end },
		{ Slot = "W", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 37, 63, 90, 116, 142 })[level] + 0.37 * source.total_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 50, 125, 200 })[level] + 0.25 * source.total_attack_damage +
					0.03 * (target.max_health - target.health)
			end }, -- 1-3 singleHit
		{ Slot = "R", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return (
					({ 50, 125, 200 })[level] + 0.25 * source.total_attack_damage + 0.03 * (target.max_health - target.health))
			end } -- 4 Hit
	},

	["Jinx"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return 0.1 * source.total_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 10, 60, 110, 160, 210 })[level] + 1.6 * source.total_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 120, 170, 220, 270 })[level] + source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 24, 36, 48 })[level] +
					({ 20, 24, 28 })[level] / 100 * (target.max_health - target.health) + 0.12 * source.bonus_attack_damage
			end },
		{ Slot = "R", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 300, 450, 600 })[level] +
					({ 25, 30, 35 })[level] / 100 * (target.max_health - target.health) + 1.5 * source.bonus_attack_damage
			end },
	},

	["Kaisa"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 40, 55, 70, 85, 100 })[level] + 0.3 * source.ability_power +
					0.5 * source.bonus_attack_damage
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 30, 55, 80, 105, 130 })[level] + 1.3 * source.total_attack_damage +
					0.45 * source.ability_power
			end },
		{ Slot = "W", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return 0.05 * source.ability_power +
					((target.max_health - target.health) / 100 * 15)
			end },
	},

	["Karma"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 120, 170, 220, 270 })[level] + 0.4 * source.ability_power end },
		{ Slot = "Q", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 120, 170, 220, 270 })[level] +
					({ 40, 100, 160, 220 })[source:get_spell_slot(SLOT_R).level] + 0.7 * source.ability_power
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 130, 180, 230, 280 })[level] + 0.9 * source.ability_power end },
	},

	["Karthus"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return (({ 90, 125, 160, 195, 230 })[level] + 0.7 * source.ability_power) * 2 end }, --single Target Hero
		{ Slot = "Q", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 45, 62, 80, 97, 115 })[level] + 0.35 * source.ability_power end }, --AOE Hero
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 30, 50, 70, 90, 110 })[level] + 0.2 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 200, 350, 500 })[level] + 0.75 * source.ability_power end },
	},

	["Kassadin"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 65, 95, 125, 155, 185 })[level] + 0.7 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 95, 120, 145, 170 })[level] + 0.8 * source.ability_power end },
		{ Slot = "W", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return 20 + 0.1 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 90, 120, 150, 180 })[level] + 0.85 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 90, 110 })[level] + 0.4 * source.ability_power +
					0.02 * source.max_mana
			end },
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 35, 45, 55 })[level] + 0.1 * source.ability_power +
					0.01 * source.max_mana
			end }, -- Bonus per stack
	},

	["Katarina"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 110, 140, 170, 200 })[level] + 0.35 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 20, 35, 50, 65, 80 })[level] + 0.25 * source.ability_power +
					0.4 * source.total_attack_damage
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 25, 37.5, 50 })[level] + 0.19 * source.ability_power end }, -- calc for 1 Dagger AP
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 375, 562.5, 750 })[level] + 2.85 * source.ability_power end }, --full AP Dmg
		{ Slot = "R", Stage = 3, DamageType = 1,
			Damage = function(source, target, level) return (0.16 + 0.5 * source.attack_speed) * source.bonus_attack_damage end }, -- calc for 1 Dagger AD
	},

	["Kayle"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 100, 140, 180, 220 })[level] + 0.6 * source.bonus_attack_damage
					+ 0.5 * source.ability_power
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return 0.015 * source.ability_power +
					({ 0.08, 0.085, 0.09, 0.095, 0.10 })[level] * (target.max_health - target.health)
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 200, 300, 400 })[level] + 0.7 * source.ability_power +
					source.bonus_attack_damage
			end },
	},

	["Kennen"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 125, 175, 225, 275 })[level] + 0.85 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 95, 120, 145, 170 })[level] + 0.8 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 120, 160, 200, 240 })[level] + 0.8 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 40, 75, 110 })[level] + 0.225 * source.ability_power end }, --per Bolt
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 300, 562, 825 })[level] + 1.68 * source.ability_power end }, --total single target damage
	},

	["Khazix"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 70, 95, 120, 145, 170 })[level] + 1.15 * source.bonus_attack_damage end },
		{ Slot = "Q", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 147, 199, 252, 304, 357 })[level] +
					2.41 * source.bonus_attack_damage
			end }, --isolated Target
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 80, 115, 145, 175, 205 })[level] + source.bonus_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 65, 100, 135, 170, 205 })[level] + 0.2 * source.bonus_attack_damage end },
	},

	["KogMaw"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 90, 140, 190, 240, 290 })[level] + 0.7 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) local dmg = (
					({ 0.035, 0.0425, 0.05, 0.0575, 0.065 })[level] + (0.01 * source.ability_power)) * target.max_health;
				if target.is_minion
					and dmg > 100 then dmg = 100 end
				return dmg
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 120, 165, 210, 255 })[level] + 0.7 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return (
					({ 100, 140, 180 })[level] + 0.65 * source.bonus_attack_damage + 0.35 * source.ability_power) *
					(GetPercentHP(target) < 25 and 3 or (GetPercentHP(target) < 50 and 2 or 1))
			end },
	},

	["Kalista"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 85, 150, 215, 280 })[level] + source.total_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return (({ 14, 15, 16, 17, 18 })[level] / 100) * target.max_health end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) local count = GotBuff(target, "kalistaexpungemarker")
				if count > 0 then return (
						({ 20, 30, 40, 50, 60 })[level] + 0.7 * source.total_attack_damage) +
						(count - 1) *
						((({ 10, 16, 22, 28, 34 })[level]) + (({ 0.23, 0.27, 0.31, 0.36, 0.40 })[level] * source.total_attack_damage))
				end
				return 0
			end },
	},

	["Kayn"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 75, 95, 115, 135, 155 })[level] + 0.8 * source.bonus_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 90, 135, 180, 225, 270 })[level] + 1.3 * source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + 1.75 * source.bonus_attack_damage end },
	},

	["Kindred"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 60, 85, 110, 135, 160 })[level] + source.bonus_attack_damage * 0.75 end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 25, 30, 35, 40, 45 })[level] + 0.2 * source.bonus_attack_damage +
					0.015 * (target.max_health - target.health) +
					(GetBuffData(source, "kindredmarkofthekindredstackcounter").stacks / 100) * (target.max_health - target.health)
			end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 80, 100, 120, 140, 160 })[level] + 0.8 * source.bonus_attack_damage
					+ 0.08 * (target.max_health - target.health) +
					(GetBuffData(source, "kindredmarkofthekindredstackcounter").stacks / 200) * (target.max_health - target.health)
			end },
	},

	["Kled"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 30, 55, 80, 105, 130 })[level] + source.bonus_attack_damage * 0.65 end }, --Mounted
		{ Slot = "Q", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 35, 50, 65, 80, 95 })[level] + source.bonus_attack_damage * 0.8 end }, --UnMounted
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 30, 40, 50, 60 })[level] +
					(({ 0.045, 0.05, 0.055, 0.06, 0.065 })[level] + (0.05 * source.bonus_attack_damage)) * target.max_health
			end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 35, 60, 85, 110, 135 })[level] + source.bonus_attack_damage * 0.65 end },
	},

	["KSante"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 50, 75, 100, 125, 150 })[level] + 0.4 * source.total_attack_damage
					+ 0.3 * source.bonus_armor + 0.3 * source.bonus_mr
			end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return KSante_WDmg(source, target) end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 35, 70, 105 })[level] + 0.2 * source.total_attack_damage end },
		{ Slot = "R", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + 0.2 * source.total_attack_damage end }, --BonusDmg through terrain
	},

	["Leblanc"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 65, 90, 115, 140, 165 })[level] + 0.4 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 115, 155, 195, 235 })[level] + 0.6 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 70, 90, 110, 130 })[level] + 0.3 * source.ability_power end },
	},

	["LeeSin"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 55, 80, 105, 130, 155 })[level] + 1.1 * source.bonus_attack_damage end },
		{ Slot = "Q", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 55, 80, 105, 130, 155 })[level] + 1.1 * source.bonus_attack_damage +
					0.01 * (target.max_health - target.health)
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 100, 130, 160, 190, 220 })[level] + source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 175, 400, 625 })[level] + 2 * source.bonus_attack_damage end },
	},

	["Leona"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 10, 35, 60, 85, 110 })[level] + 0.3 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 55, 90, 125, 160, 195 })[level] + 0.4 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 90, 130, 170, 210 })[level] + 0.4 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 100, 175, 250 })[level] + 0.8 * source.ability_power end },
	},

	["Lissandra"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 110, 140, 170, 200 })[level] + 0.8 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 0.7 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 0.6 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + 0.75 * source.ability_power end },
	},

	["Lillia"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 35, 45, 55, 65, 75 })[level] + 0.4 * source.ability_power end },
		{ Slot = "Q", Stage = 2, DamageType = 3,
			Damage = function(source, target, level) return ({ 35, 45, 55, 65, 75 })[level] + 0.4 * source.ability_power end }, --outer edge/TrueDmg
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 100, 120, 140, 160 })[level] + 0.35 * source.ability_power end }, --AoeDmg
		{ Slot = "W", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 240, 300, 360, 420, 480 })[level] + 1.05 * source.ability_power end }, --CenterDmg
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 95, 120, 145, 170 })[level] + 0.45 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 100, 150, 200 })[level] + 0.4 * source.ability_power end },
	},

	["Lucian"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 95, 125, 155, 185, 215 })[level] +
					({ 0.6, 0.75, 0.9, 1.05, 1.2 })[level] * source.bonus_attack_damage
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 110, 145, 180, 215 })[level] + 0.9 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 15, 30, 45 })[level] + 0.15 * source.ability_power +
					0.25 * source.total_attack_damage
			end }, --per Shot
	},

	["Lulu"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 0.5 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 120, 160, 200, 240 })[level] + 0.4 * source.ability_power end },
	},

	["Lux"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 120, 160, 200, 240 })[level] + 0.6 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 120, 170, 220, 270 })[level] + 0.8 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 300, 400, 500 })[level] + 1.2 * source.ability_power +
					(target:has_buff("LuxIlluminatingFraulein") and (10 + 10 * source.level + 0.2 * source.ability_power) or 0)
			end },
	},

	["Malphite"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 120, 170, 220, 270 })[level] + 0.6 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 15, 25, 35, 45, 55 })[level] + 0.3 * source.ability_power +
					0.15 * source.armor
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 110, 150, 190, 230 })[level] + 0.4 * source.armor +
					0.6 * source.ability_power
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 200, 300, 400 })[level] + 0.9 * source.ability_power end },
	},

	["Malzahar"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 0.55 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 12, 14, 16, 18, 20 })[level] + 0.2 * source.ability_power +
					0.4 * source.bonus_attack_damage + (2 + 3 * source.level)
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 115, 150, 185, 220 })[level] + 0.8 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 125, 200, 275 })[level] + 0.8 * source.ability_power end },
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return 2.5 *
					(({ 10, 15, 20 })[level] / 100 + 0.015 * source.ability_power / 100) * target.max_health
			end },
	},

	["Maokai"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 120, 170, 220, 270 })[level] + 
					0.4 * source.ability_power + ({ 0.02, 0.025, 0.03, 0.035, 0.04 })[level] * target.max_health 
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 85, 110, 135, 160 })[level] + 0.4 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 75, 100, 125, 150 })[level] + 0.25 * source.ability_power +
					0.05 * (source.max_health - source.base_health)
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 225, 300 })[level] + 0.75 * source.ability_power end },
	},

	["MasterYi"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 30, 60, 90, 120, 150 })[level] + 0.5 * source.total_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 3,
			Damage = function(source, target, level) return ({ 30, 35, 40, 45, 50 })[level] + 0.3 * source.bonus_attack_damage end },
	},
	
	["Milio"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 90, 135, 180, 225, 270 })[level] + 0.9 * source.ability_power end },
	},	

	["MissFortune"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 45, 70, 95, 120 })[level] + 0.35 * source.ability_power +
					source.total_attack_damage
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 100, 130, 160, 190 })[level] + 1.2 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return 0.75 * source.total_attack_damage + 0.25 * source.ability_power end },
	},

	["MonkeyKing"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 45, 70, 95, 120 })[level] + 0.45 * source.bonus_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 110, 140, 170, 200 })[level] + source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 0.01, 0.15, 0.02 })[level] * target.max_health +
					0.275 * source.total_attack_damage
			end }, --Per Tick
	},

	["Mordekaiser"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 95, 115, 135, 155 })[level] + 0.6 * source.ability_power +
					({ 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 51, 61, 71, 81, 91, 107, 123, 139 })[source.level]
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 95, 110, 125, 140 })[level] + 0.6 * source.ability_power end },
	},

	["Morgana"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 135, 190, 245, 300 })[level] + 0.9 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 110, 160, 210, 260 })[level] + 0.07 * source.ability_power end }, -- minimum fullDmg
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 225, 300 })[level] + 0.7 * source.ability_power end },
	},

	["Nami"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 130, 185, 240, 295 })[level] + 0.5 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 110, 150, 190, 230 })[level] + 0.5 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 25, 40, 55, 70, 85 })[level] + 0.2 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + 0.6 * source.ability_power end },
	},

	["Nasus"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return GetBuffData(source, "nasusqstacks").stacks +
					({ 30, 50, 70, 90, 110 })[level]
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 55, 95, 135, 175, 215 })[level] + 0.6 * source.ability_power end },
		{ Slot = "E", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 11, 19, 27, 35, 43 })[level] + 0.12 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return (({ 3, 4, 5 })[level] / 100 + 0.01 / 100 * source.ability_power) *
					target.max_health
			end },
	},

	["Nautilus"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 115, 160, 205, 250 })[level] + 0.9 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 30, 40, 50, 60, 70 })[level] + 0.4 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 55, 90, 125, 160, 195 })[level] + 0.5 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 275, 400 })[level] + 0.8 * source.ability_power end },
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 125, 175, 225 })[level] + 0.4 * source.ability_power end },
	},

	["Neeko"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 125, 170, 215, 260 })[level] + 0.5 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 0.65 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 350, 550 })[level] +  source.ability_power end },
	},

	["Nidalee"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 90, 110, 130, 150 })[level] + 0.5 * source.ability_power end },
		{ Slot = "QM", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) local dmg = (
					({ 5, 30, 55, 80 })[source:get_spell_slot(SLOT_R).level] + 0.4 * source.ability_power +
						0.75 * source.total_attack_damage) * ((target.max_health - target.health) / target.max_health * 1.5 + 1)
				dmg = dmg * (GotBuff(target, "nidaleepassivehunted") > 0 and 1.4 or 1)
				return dmg
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 40, 80, 120, 160, 200 })[level] + 0.2 * source.ability_power end },
		{ Slot = "WM", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 110, 160, 210 })[source:get_spell_slot(SLOT_R).level] +
					0.3 * source.ability_power
			end },
		{ Slot = "E", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 140, 200, 260 })[source:get_spell_slot(SLOT_R).level] +
					0.45 * source.ability_power
			end },
	},

	["Nilah"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 5, 10, 15, 20, 25 })[level] +
					(({ 0.9, 0.975, 1.05, 1.125, 1.2 })[level] * source.total_attack_damage)
			end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 60, 90, 115, 140, 165 })[level] + 0.2 * source.total_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 15, 30, 45 })[level] + 0.28 * source.bonus_attack_damage end }, --Per Tick
		{ Slot = "R", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 125, 225, 325 })[level] + 1.2 * source.bonus_attack_damage end }, --Burst Dmg
	},

	["Nocturne"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 65, 110, 155, 200, 245 })[level] +
					0.85 * source.bonus_attack_damage
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 125, 170, 215, 260 })[level] + source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 150, 275, 400 })[level] + 1.2 * source.bonus_attack_damage end },
	},

	["Nunu"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 100, 140, 180, 220 })[level] + 0.65 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 36, 45, 54, 63, 72 })[level] + 0.3 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 16, 24, 32, 40, 48 })[level] + 0.1 * source.ability_power end }, --per Snowbal
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 625, 950, 1275 })[level] + 3 * source.ability_power end },
	},

	["Olaf"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 65, 115, 165, 215, 265 })[level] + source.bonus_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 3,
			Damage = function(source, target, level) return ({ 70, 115, 160, 205, 250 })[level] + 0.5 * source.total_attack_damage end },
	},

	["Orianna"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 90, 120, 150, 180 })[level] + 0.5 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 105, 150, 195, 240 })[level] + 0.7 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 90, 120, 150, 180 })[level] + 0.3 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 200, 275, 350 })[level] + 0.8 * source.ability_power end },
	},

	["Ornn"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 45, 70, 95, 120 })[level] + 1.1 * source.total_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 0.12, 0.13, 0.14, 0.15, 0.16 })[level] * target.max_health end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 80, 125, 170, 215, 260 })[level] + 0.4 * source.armor +
					0.4 * source.bonus_mr
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 125, 175, 225 })[level] + 0.2 * source.ability_power end },
	},

	["Pantheon"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 70, 100, 130, 160, 190 })[level] +
					1.15 * source.bonus_attack_damage
			end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 60, 100, 140, 180, 220 })[level] + source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 55, 105, 155, 205, 255 })[level] + 1.5 * source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 300, 500, 700 })[level] + source.ability_power end },
	},

	["Poppy"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 40, 60, 80, 100, 120 })[level] + 0.9 * source.bonus_attack_damage +
					0.09 * target.max_health
			end },
		{ Slot = "Q", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 80, 120, 160, 200, 240 })[level] + 1.8 * source.bonus_attack_damage
					+ 0.18 * target.max_health
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 110, 150, 190, 230 })[level] + 0.7 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 60, 80, 100, 120, 140 })[level] + 0.5 * source.bonus_attack_damage end },
		{ Slot = "E", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 120, 160, 200, 240, 280 })[level] + source.bonus_attack_damage end }, --Target collide with terrain
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 100, 150, 200 })[level] + 0.45 * source.bonus_attack_damage end },
	},

	["Pyke"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 100, 150, 200, 250, 300 })[level] +
					0.6 * source.bonus_attack_damage
			end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 105, 145, 185, 225, 265 })[level] + source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 3,
			Damage = function(source, target, level) return (
					{ 250, 250, 250, 250, 250, 250, 290, 330, 370, 400, 430, 450, 470, 490, 510, 530, 540, 550 })[source.level] +
					0.8 * source.bonus_attack_damage + 1.5 * source.lethality
			end },
	},

	["Qiyana"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 50, 85, 120, 155, 190 })[level] + 0.75 * source.bonus_attack_damage end },
		{ Slot = "Q", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 80, 136, 192, 248, 304 })[level] +
					1.2 * source.bonus_attack_damage
			end }, --Terrain Damage
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 8, 22, 36, 50, 64 })[level] + 0.1 * source.bonus_attack_damage +
					0.45 * source.ability_power
			end }, --Passive
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 50, 90, 130, 170, 210 })[level] + 0.5 * source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 100, 200, 300 })[level] + 1.7 * source.bonus_attack_damage +
					0.1 * target.max_health
			end },
	},

	["Quinn"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 45, 70, 95, 120 })[level] +
					(({ 0.8, 0.9, 1.0, 1.1, 1.2 })[level] * source.total_attack_damage) + 0.5 * source.ability_power
			end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 40, 70, 100, 130, 160 })[level] + 0.2 * source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return 0.7 * source.total_attack_damage end },
	},

	["Rakan"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 115, 160, 205, 250 })[level] + 0.7 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 120, 170, 220, 270 })[level] + 0.8 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 100, 200, 300 })[level] + 0.5 * source.ability_power end },
	},

	["Rammus"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 100, 125, 150, 175, 200 })[level] + source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 15, 25, 35, 45, 55 })[level] + 0.1 * source.armor end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 100, 175, 250 })[level] + 0.6 * source.ability_power end },
	},

	["Reksai"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 21, 27, 33, 39, 45 })[level] + 0.5 * source.bonus_attack_damage end }, --UNBURROWED
		{ Slot = "Q", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 60, 95, 130, 165, 200 })[level] + 0.5 * source.bonus_attack_damage
					+ 0.7 * source.ability_power
			end }, --BURROWED
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 55, 70, 85, 100, 115 })[level] + 0.8 * source.bonus_attack_damage end }, --BURROWED
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 55, 60, 65, 70, 75 })[level] + 0.85 * source.bonus_attack_damage end }, --UNBURROWED
		{ Slot = "E", Stage = 2, DamageType = 3,
			Damage = function(source, target, level) return ({ 100, 120, 140, 160, 180 })[level] +
					1.7 * source.bonus_attack_damage
			end }, --UNBURROWED + Max FURY
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 100, 250, 400 })[level] + 1.75 * source.bonus_attack_damage +
					({ 20, 25, 30 })[level] / 100 * (target.max_health - target.health)
			end },
	},

	["Rell"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 0.5 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 0.6 * source.ability_power end }, -- if mounted
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 120, 160, 200, 240 })[level] + 0.3 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 120, 200, 280 })[level] + 1.1 * source.ability_power end },
	},

	["Renata"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 125, 170, 215, 260 })[level] + 0.8 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 65, 95, 125, 155, 185 })[level] + 0.55 * source.ability_power end },
	},

	["Renekton"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 60, 90, 120, 150, 180 })[level] + source.bonus_attack_damage end },
		{ Slot = "Q", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 90, 135, 180, 225, 270 })[level] + 1.4 * source.bonus_attack_damage end }, --REIGN OF ANGER
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 10, 40, 70, 100, 130 })[level] + 0.75 * source.total_attack_damage end },
		{ Slot = "W", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 15, 60, 105, 150, 195 })[level] + 0.75 * source.total_attack_damage end }, --REIGN OF ANGER
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 40, 70, 100, 130, 160 })[level] + 0.9 * source.bonus_attack_damage end },
		{ Slot = "E", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 40, 70, 100, 130, 160 })[level] +
					0.9 * source.total_attack_damage * 1.5
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 25, 50, 75 })[level] + 0.05 * source.ability_power +
					0.05 * source.bonus_attack_damage
			end }, --per Tick
	},

	["Rengar"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 30, 60, 90, 120, 150 })[level] +
					({ 0, 5, 10, 15, 20 })[level] / 100 * source.total_attack_damage
			end },
		{ Slot = "Q", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return (
					{ 30, 45, 60, 75, 90, 105, 120, 135, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240 })[source.level] +
					0.4 * source.total_attack_damage
			end }, --EMPOWERED ACTIVE
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 80, 110, 140, 170 })[level] + 0.8 * source.ability_power end },
		{ Slot = "W", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return (40 + 10 * source.level) + 0.8 * source.ability_power end }, --EMPOWERED ACTIVE
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 55, 100, 145, 190, 235 })[level] + 0.8 * source.bonus_attack_damage end },
		{ Slot = "E", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return (35 + 15 * source.level) + 0.8 * source.bonus_attack_damage end }, --EMPOWERED ACTIVE
	},

	["Riven"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 15, 35, 55, 75, 95 })[level] +
					({ 45, 50, 55, 60, 65 })[level] / 100 * source.total_attack_damage
			end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 65, 95, 125, 155, 185 })[level] + source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return (({ 100, 150, 200 })[level] + 0.6 * source.bonus_attack_damage) *
					1 + math.min(2, (100 - GetPercentHP(target)) * 0.02667)
			end },
	},

	["Rumble"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 180, 220, 260, 300, 340 })[level] + 1.1 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 85, 110, 135, 160 })[level] + 0.4 * source.ability_power end },
		{ Slot = "E", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 90, 127.5, 165, 202.5, 240 })[level] + 0.6 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140 })[level] + 0.175 * source.ability_power end }, --per half Second
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 840, 1260, 1680 })[level] + 2.1 * source.ability_power end }, --full Damage
	},

	["Ryze"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 90, 110, 130, 150 })[level] + 0.55 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 110, 140, 170, 200 })[level] + 0.7 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 90, 120, 150, 180 })[level] + 0.45 * source.ability_power end },
	},

	["Samira"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 0, 5, 10, 15, 20 })[level] +
					({ 0.85, 0.95, 1.05, 1.15, 1.25 })[level] * source.total_attack_damage
			end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 35, 50, 65, 80 })[level] + 0.8 * source.bonus_attack_damage end }, -- 1 Hit
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 60, 70, 80, 90 })[level] + 0.2 * source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 50, 150, 250 })[level] + 5 * source.total_attack_damage end }, -- Full Damage Single Target
	},

	["Sejuani"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 90, 140, 190, 240, 290 })[level] + 0.6 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 20, 25, 30, 35, 40 })[level] + 0.2 * source.ability_power +
					0.02 * source.max_health
			end },
		{ Slot = "W", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 30, 70, 110, 150, 190 })[level] + 0.6 * source.ability_power +
					0.06 * source.max_health
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 55, 105, 155, 205, 255 })[level] + 0.6 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 200, 300, 400 })[level] + 0.8 * source.ability_power end },
	},

	["Senna"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 40, 70, 100, 130, 160 })[level] + 0.4 * source.bonus_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 70, 115, 160, 205, 250 })[level] + 0.7 * source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 250, 400, 550 })[level] + 1.15 * source.bonus_attack_damage +
					0.7 * source.ability_power
			end },
	},

	["Seraphine"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 55, 70, 85, 100, 115 })[level] +
					({ 45, 50, 55, 60, 65 })[level] / 100 * source.ability_power
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 80, 100, 120, 140 })[level] + 0.35 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 200, 250 })[level] + 0.6 * source.ability_power end },
	},

	["Sett"] = {
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 80, 100, 120, 140, 160 })[level] +
					0.25 * source.bonus_attack_damage
			end }, -- without expended Grit
		{ Slot = "W", Stage = 2, DamageType = 3,
			Damage = function(source, target, level) return ({ 80, 100, 120, 140, 160 })[level] +
					0.25 * source.bonus_attack_damage
			end }, -- True Damage without expended Grit
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 50, 70, 90, 110, 130 })[level] + 0.6 * source.total_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 200, 300, 400 })[level] + 1.2 * source.bonus_attack_damage end }, -- without Target BonusHealth
	},

	["Shaco"] = {
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 10, 15, 20, 25, 30 })[level] + 0.12 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) 
			local Incr_Dmg = not target:is_facing(source) and 15 * 35 / 17 * (source.level - 1) + 0.1 * source.ability_power or 0

			return (GetPercentHP(target) < 30 and
						({ 105, 142, 180, 217, 255 })[level] + 0.9 * source.ability_power + 1.2 * source.bonus_attack_damage + 1.5 * Incr_Dmg or
						({ 70, 95, 120, 145, 170 })[level] + 0.6 * source.ability_power + 0.8 * source.bonus_attack_damage + Incr_Dmg)
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 225, 300 })[level] + 0.7 * source.ability_power end },
	},

	["Shen"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) local dmg = (({ 2, 2.5, 3, 3.5, 4 })[level] + 0.015 * source.ability_power) *
					target.max_health / 100;
				if target.is_hero then return dmg end
				return math.min(({ 30, 50, 70, 90, 110 })[level] + dmg
					, ({ 75, 100, 125, 150, 175 })[level])
			end },
		{ Slot = "Q", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) local dmg = (({ 5, 5.5, 6, 6.5, 7 })[level] + 0.02 * source.ability_power) *
					target.max_health / 100;
				if target.is_hero then return dmg end
				return math.min(({ 30, 50, 70, 90, 110 })[level] + dmg
					, ({ 75, 100, 125, 150, 175 })[level])
			end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 60, 85, 110, 135, 160 })[level] + 0.15 * (540 + 85 * source.level) end },
	},

	["Shyvana"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 35, 50, 65, 80 })[level] / 100 * source.total_attack_damage +
					0.25 * source.ability_power
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 10, 16, 22, 28, 35 })[level] + 0.15 * source.bonus_attack_damage end }, --per tick
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 100, 140, 180, 220 })[level] + 0.9 * source.ability_power +
					0.4 * source.total_attack_damage
			end },
		{ Slot = "E", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return (60 + 5 * source.level) + 0.2 * source.ability_power +
					0.1 * source.total_attack_damage
			end }, --Dragon Form per Second
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + 1.3 * source.ability_power end },
	},

	["Singed"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 5, 7, 10, 12, 15 })[level] + 0.11 * source.ability_power end }, --per 0.25 Second
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 60, 70, 80, 90 })[level] + 0.60 * source.ability_power +
					({ 6, 6.5, 7, 7.5, 8 })[level] / 100 * target.max_health
			end },
	},

	["Sion"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 40, 60, 80, 100, 120 })[level] +
					({ 45, 52, 60, 67, 75 })[level] / 100 * source.total_attack_damage
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 40, 65, 90, 115, 140 })[level] + 0.4 * source.ability_power +
					({ 10, 11, 12, 13, 14 })[level] / 100 * target.max_health
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 65, 100, 135, 170, 205 })[level] + 0.55 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 150, 300, 450 })[level] + 0.4 * source.bonus_attack_damage end },
	},

	["Sivir"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 15, 30, 45, 60, 75 })[level] +
					({ 80, 85, 90, 95, 100 })[level] / 100 * source.total_attack_damage + 0.6 * source.ability_power
			end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 0.25, 0.3, 0.35, 0.4, 0.45 })[level] * source.total_attack_damage end },
	},

	["Skarner"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return 0.2 * source.total_attack_damage +
					({ 1, 1.5, 2, 2.5, 3 })[level] / 100 * target.max_health
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 40, 65, 90, 115, 140 })[level] + 0.2 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return (({ 20, 60, 100 })[level] + 0.5 * source.ability_power) +
					(0.60 * source.total_attack_damage)
			end },
	},

	["Sona"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 80, 110, 140, 170 })[level] + 0.4 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + 0.5 * source.ability_power end },
	},

	["Soraka"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 85, 120, 155, 190, 225 })[level] + 0.35 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 95, 120, 145, 170 })[level] + 0.4 * source.ability_power end },
	},

	["Swain"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 65, 85, 105, 125, 145 })[level] + 0.4 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 115, 150, 185, 220 })[level] + 0.55 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 35, 70, 105, 140, 175 })[level] + 0.25 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 20, 40, 60 })[level] + 0.1 * source.ability_power end }, --per Second
	},

	["Sylas"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 40, 60, 80, 100, 120 })[level] + 0.4 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 0.90 * source.ability_power end },
		{ Slot = "W", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 97, 150, 202, 255, 307 })[level] + 0.97 * source.ability_power end }, --if Target below 40%
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 130, 180, 230, 280 })[level] + source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 65, 80, 95, 180 })[level] + 0.4 * source.ability_power end },
	},

	["Syndra"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 0.7 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 110, 150, 190, 230 })[level] + 0.7 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 115, 155, 195, 235 })[level] + 0.45 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 270, 390, 510 })[level] + 0.51 * source.ability_power end },
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 90, 130, 170 })[level] + 0.17 * source.ability_power end }, -- PER SPHERE
	},

	["Talon"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 65, 85, 105, 125, 145 })[level] + source.bonus_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 40, 50, 60, 70, 80 })[level] + 0.4 * source.bonus_attack_damage end }, --INITIAL DAMAGE
		{ Slot = "W", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 50, 80, 110, 140, 170 })[level] + 0.8 * source.bonus_attack_damage end }, --RETURN DAMAGE
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 90, 135, 180 })[level] + source.bonus_attack_damage end },
	},

	["Taliyah"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 45, 65, 85, 105, 125 })[level] + 0.5 * source.ability_power end },
		{ Slot = "Q", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 117, 169, 221, 273, 325 })[level] + 1.3 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 105, 150, 195, 240 })[level] + 0.6 * source.ability_power end },
		{ Slot = "E", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 25, 45, 65, 85, 105 })[level] + 0.3 * source.ability_power end }, --detonate dmg
	},

	["Taric"] = {
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 90, 130, 170, 210, 250 })[level] end },
	},

	["TahmKench"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 130, 180, 230, 280 })[level] + source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return target.is_minion and ({ 400, 450, 500, 550, 600 })[level] or
					(({ 0.20, 0.23, 0.26, 0.29, 0.32 })[level] + 0.02 * source.ability_power / 100) * target.max_health
			end },
		{ Slot = "W", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 100, 135, 170, 205, 240 })[level] + 1.5 * source.ability_power end }, --PROJECTILE DAMAGE
	},

	["Teemo"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 125, 170, 215, 260 })[level] + 0.8 * source.ability_power end },
		{ Slot = "E", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 24, 48, 72, 96, 120 })[level] + 0.4 * source.ability_power end }, --Total DotDmg
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 14, 25, 36, 47, 58 })[level] + 0.3 * source.ability_power end }, --Ground Damage
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 200, 325, 450 })[level] + 0.55 * source.ability_power end },
	},

	["Thresh"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 100, 150, 200, 250, 300 })[level] + 0.9 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 115, 155, 195, 235 })[level] + 0.7 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 250, 400, 550 })[level] + source.ability_power end },
	},

	["Tristana"] = {
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 95, 145, 195, 245, 295 })[level] + 0.5 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 70, 80, 90, 100, 110 })[level] +
					({ 0.5, 0.75, 1, 1.25, 1.5 })[level] * source.bonus_attack_damage + 0.5 * source.ability_power
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 300, 400, 500 })[level] + source.ability_power end },
	},

	["Trundle"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 40, 60, 80, 100 })[level] +
					({ 0.15, 0.25, 0.35, 0.45, 0.55 })[level] * source.total_attack_damage
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return (({ 20, 25, 30 })[level] / 100 + 0.02 * source.ability_power / 100) *
					target.max_health
			end },
	},

	["Tryndamere"] = {
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 80, 110, 140, 170, 200 })[level] + 1.3 * source.bonus_attack_damage
					+ 0.8 * source.ability_power
			end },
	},

	["TwistedFate"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 100, 140, 180, 220 })[level] + 0.8 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 40, 60, 80, 100, 120 })[level] + source.total_attack_damage +
					1.15 * source.ability_power
			end }, --Blue Card
		{ Slot = "W", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 30, 45, 60, 75, 90 })[level] + source.total_attack_damage +
					0.7 * source.ability_power
			end }, --Red Card
		{ Slot = "W", Stage = 3, DamageType = 2,
			Damage = function(source, target, level) return ({ 15, 22.5, 30, 37.5, 45 })[level] + source.total_attack_damage +
					0.5 * source.ability_power
			end }, --Gold Card
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 65, 90, 115, 140, 165 })[level] + 0.5 * source.ability_power end },
	},

	["Twitch"] = {
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return (
					GotBuff(target, "twitchdeadlyvenom") * ({ 15, 20, 25, 30, 35 })[level] + 0.3 * source.ability_power +
						0.35 * source.bonus_attack_damage) + ({ 20, 30, 40, 50, 60 })[level]
			end },
	},

	["Udyr"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 30, 60, 90, 120, 150, 180 })[level] +
					(({ 110, 125, 140, 155, 170, 185 })[level] / 100) * source.total_attack_damage
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 144, 208, 272, 336, 400 })[level] + 1.4 * source.ability_power end },

	},

	["Urgot"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 25, 70, 115, 160, 205 })[level] + 0.7 * source.total_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 90, 120, 150, 180, 210 })[level] + source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 100, 225, 350 })[level] + 0.5 * source.bonus_attack_damage end },
	},

	["Varus"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 10, 47, 83, 120, 157 })[level] + source.total_attack_damage end },
		{ Slot = "Q", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 15, 70, 125, 180, 235 })[level] + 1.65 * source.total_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 7, 12, 17, 22, 27 })[level] + 0.3 * source.ability_power end },
		{ Slot = "W", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return (
					({ 3, 3.5, 4, 4.5, 5 })[level] / 100 + 0.02 * source.ability_power / 100) * target.max_health
			end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 60, 100, 140, 180, 220 })[level] + 0.9 * source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + source.ability_power end },
	},

	["Vayne"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 0.75, 0.85, 0.95, 1.05, 1.15 })[level] * source.total_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 3,
			Damage = function(source, target, level) return ({ 50, 65, 80, 95, 110 })[level] +
					(({ 0.06, 0.07, 0.08, 0.09, 0.1 })[level] * target.max_health)
			end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 50, 85, 120, 155, 190 })[level] + 0.5 * source.bonus_attack_damage end },
	},

	["Veigar"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 120, 160, 200, 240 })[level] + ({ 0.45, 0.5, 0.55, 0.6, 0.65 })[level] * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 85, 140, 195, 250, 305 })[level] + ({ 0.7, 0.8, 0.9, 1, 1.1 })[level] * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) local dmg = GetPercentHP(target) < 33.33 and
					({ 175, 250, 325 })[level] + ({ 0.65, 0.7, 0.75 })[level] * source.ability_power or 
					(({ 175, 250, 325 })[level] + ({ 0.65, 0.7, 0.75 })[level] * source.ability_power) * (0.015 * (target.health / target.max_health * 100))
					return dmg + ({ 175, 250, 325 })[level] + ({ 0.65, 0.7, 0.75 })[level] * source.ability_power
			end },
	},

	["Velkoz"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 120, 160, 200, 240 })[level] + 0.9 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 30, 50, 70, 90, 110 })[level] + ({ 45, 75, 105, 135, 165 })[level]
					+ 0.45 * source.ability_power
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 100, 130, 160, 190 })[level] + 0.3 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 3,
			Damage = function(source, target, level) return (
					GotBuff(target, "velkozresearchedstack") > 0 and ({ 450, 625, 800 })[level] + 1.25 * source.ability_power or
						target:calculate_magic_damage(({ 450, 625, 800 })[level] + 1.25 * source.ability_power))
			end },
	},

	["Vex"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 105, 150, 195, 240 })[level] + 0.7 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 120, 160, 200, 240 })[level] + 0.3 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 70, 90, 110, 130 })[level] +
					(({ 0.4, 0.45, 0.5, 0.55, 0.6 })[level] * source.ability_power)
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 125, 175 })[level] + 0.2 * source.ability_power end },
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + 0.5 * source.ability_power end },
	},

	["Viego"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return (({ 15, 30, 45, 60, 75 })[level] + 0.7 * source.total_attack_damage) *
					source.crit_chance
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 135, 190, 245, 300 })[level] + source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return (
					({ 0.12, 0.16, 0.20 })[level] + 0.05 * (source.bonus_attack_damage / 100) * (target.max_health - target.health)) +
					1.2 * source.total_attack_damage + source.crit_chance
			end },
	},

	["Vi"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 45, 70, 95, 120, 145 })[level] + 0.8 * source.bonus_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return (
					({ 4, 5.5, 7, 8.5, 10 })[level] / 100 + 0.01 * source.bonus_attack_damage / 35) * target.max_health
			end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 0, 15, 30, 45, 60 })[level] + 1.2 * source.total_attack_damage +
					source.ability_power
			end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 150, 325, 500 })[level] + 1.1 * source.bonus_attack_damage end },
	},

	["Viktor"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 75, 90, 105, 120 })[level] + 0.4 * source.ability_power end },
		{ Slot = "Q", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 20, 45, 70, 95, 120 })[level] + 0.6 * source.ability_power +
					source.total_attack_damage
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 110, 150, 190, 230 })[level] + 0.5 * source.ability_power end },
		{ Slot = "E", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 90, 170, 250, 330, 410 })[level] + 1.3 * source.ability_power end }, --Total Damage
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 100, 175, 250 })[level] + 0.5 * source.ability_power end },
		{ Slot = "R", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 65, 105, 145 })[level] + 0.45 * source.ability_power end }, --Per Tick
	},

	["Vladimir"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 100, 120, 140, 160 })[level] + 0.6 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 135, 190, 245, 300 })[level] +
					0.1 * (source.max_health - 537 + 96 * source.level)
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 30, 45, 60, 75, 90 })[level] + 0.35 * source.ability_power +
					0.025 * source.max_health
			end },
		{ Slot = "E", Stage = 2, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 90, 120, 150, 180 })[level] + 0.8 * source.ability_power +
					0.06 * source.max_health
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 150, 250, 350 })[level] + 0.7 * source.ability_power end },
	},

	["Volibear"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 10, 30, 50, 70, 90 })[level] + 1.2 * source.bonus_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return (({ 5, 30, 55, 80, 105 })[level]) + source.total_attack_damage +
					0.06 * (source.max_health - GetBaseHealth(source))
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 110, 140, 170, 200 })[level] + 0.8 * source.ability_power +
					({ 0.09, 0.1, 0.11, 0.12, 0.13 })[level] * target.max_health
			end }, --Hero Dmg
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 300, 500, 700 })[level] + 1.25 * source.ability_power +
					2.5 * source.bonus_attack_damage
			end },
	},

	["Warwick"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return (({ 6, 7, 8, 9, 10 })[level] / 100 * target.max_health) +
					source.ability_power + 1.2 * source.total_attack_damage
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 175, 350, 525 })[level] + 1.67 * source.bonus_attack_damage end },
	},

	["Xayah"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 45, 60, 75, 90, 105 })[level] + 0.5 * source.bonus_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 50, 60, 70, 80, 90 })[level] + 0.6 * source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 200, 300, 400 })[level] + source.bonus_attack_damage end },
	},

	["Xerath"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 110, 150, 190, 230 })[level] + 0.85 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 95, 130, 165, 200 })[level] + 0.6 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 80, 110, 140, 170, 200 })[level] + 0.45 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 200, 250, 300 })[level] + 0.45 * source.ability_power end },
	},

	["XinZhao"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 16, 25, 34, 43, 52 })[level] + 0.4 * source.bonus_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 50, 85, 120, 155, 190 })[level] + 0.9 * source.total_attack_damage
					+ 0.65 * source.ability_power
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 75, 100, 125, 150 })[level] + 0.6 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 75, 175, 275 })[level] + source.bonus_attack_damage +
					1.1 * source.ability_power + 0.15 * target.health
			end },
	},

	["Yasuo"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 45, 70, 95, 120 })[level] + 1.05 * source.total_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 70, 80, 90, 100 })[level] + 0.2 * source.bonus_attack_damage +
					0.6 * source.ability_power
			end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 200, 350, 500 })[level] + 1.5 * source.bonus_attack_damage end },
	},

	["Yone"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 20, 40, 60, 80, 100 })[level] + 1.05 * source.total_attack_damage end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 5, 10, 15, 20, 25 })[level] +
					({ 0.055, 0.06, 0.065, 0.07, 0.075 })[level] * target.max_health
			end }, -- Ap Damage
		{ Slot = "W", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 5, 10, 15, 20, 25 })[level] +
					({ 0.055, 0.06, 0.065, 0.07, 0.075 })[level] * target.max_health
			end }, -- AD Damage
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 100, 200, 300 })[level] + 0.4 * source.total_attack_damage end }, -- Ap Damage
		{ Slot = "R", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 100, 200, 300 })[level] + 0.4 * source.total_attack_damage end }, -- Ad Damage
	},

	["Yorick"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 30, 55, 80, 105, 130 })[level] + 0.4 * source.total_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 0.7 * source.ability_power +
					0.15 * target.health
			end },
	},

	["Yuumi"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 90, 120, 150, 180, 210 })[level] + 0.2 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 100, 125 })[level] + 0.2 * source.ability_power end },
	},

	["Zac"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 40, 55, 70, 85, 100 })[level] + 0.3 * source.ability_power +
					0.04 * source.max_health
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 35, 50, 65, 80, 95 })[level] +
					(({ 4, 5, 6, 7, 8 })[level] / 100 + 0.3 * source.ability_power / 100) * target.max_health
			end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 105, 150, 195, 240 })[level] + 0.8 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 140, 210, 280 })[level] + 0.4 * source.ability_power end },
	},

	["Zeri"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 1.14, 1.57, 2, 2.43, 2.86 })[level] +
					(({ 0.15, 0.1571, 0.1643, 0.1714, 0.1786 })[level] * source.total_attack_damage)
			end }, -- per bullet
		{ Slot = "Q", Stage = 2, DamageType = 1,
			Damage = function(source, target, level) return ({ 15, 17, 19, 21, 23 })[level] +
					(({ 1.04, 1.08, 1.12, 1.16, 1.2 })[level] * source.total_attack_damage)
			end }, -- Full Dmg
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 20, 60, 100, 140, 180 })[level] + 1.3 * source.total_attack_damage +
					0.25 * source.ability_power
			end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 175, 275, 375 })[level] + 0.85 * source.bonus_attack_damage +
					1.1 * source.ability_power
			end },
	},

	["Zed"] = {
		{ Slot = "Q", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 1.1 * source.bonus_attack_damage end },
		{ Slot = "E", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return ({ 65, 85, 105, 125, 145 })[level] + 0.65 * source.bonus_attack_damage end },
		{ Slot = "R", Stage = 1, DamageType = 1,
			Damage = function(source, target, level) return 0.65 * source.total_attack_damage end },
	},

	["Ziggs"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 95, 145, 195, 245, 295 })[level] + 0.65 * source.ability_power end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 105, 140, 175, 210 })[level] + 0.5 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 30, 70, 110, 150, 190 })[level] + 0.3 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 300, 450, 600 })[level] + 1.1 * source.ability_power end },
	},

	["Zilean"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 115, 165, 230, 300 })[level] + 0.9 * source.ability_power end },
	},

	["Zoe"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 50, 80, 110, 140, 170 })[level] + 0.6 * source.ability_power +
					({ 7, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 29, 32, 35, 38, 42, 46, 50 })[source.level]
			end },
		{ Slot = "W", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 75, 105, 135, 165, 195 })[level] + 0.4 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 70, 110, 150, 190, 230 })[level] + 0.45 * source.ability_power end },
	},

	["Zyra"] = {
		{ Slot = "Q", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 95, 130, 165, 200 })[level] + 0.6 * source.ability_power end },
		{ Slot = "E", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 60, 105, 150, 195, 240 })[level] + 0.5 * source.ability_power end },
		{ Slot = "R", Stage = 1, DamageType = 2,
			Damage = function(source, target, level) return ({ 180, 265, 350 })[level] + 0.7 * source.ability_power end },
	}
}

local CalcPassiveDmg = {
	{Id = "Aatrox", -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("aatroxpassiveready") then return 0 end
			local Dmg = (0.04 + 0.08 / 17 * (source.level- 1)) * target.max_health
			return target:calculate_phys_damage(Dmg)
		end
	},	
	
	{Id = "Akali", -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("akalishadowstate") then return 0 end
			local Dmg = ({35, 38, 41, 44, 47, 50, 53, 62, 71, 80, 89, 98, 107, 122, 137, 152, 167, 182})[source.level] +
						0.55 * source.ability_power + 0.6 * source.bonus_attack_damage
			return target:calculate_magic_damage(Dmg)
		end
	},
	
	{Id = "Akshan", -- AAdmg value
		Damage = function(source, target)
            local buff = target:get_buff("AkshanPassiveDebuff")
            if not buff or buff.count ~= 2 then return 0 end
			local Dmg = ({10, 15, 20, 25, 30, 35, 40, 45, 55, 65, 75, 85, 95, 105, 120, 135, 150, 165})[source.level]
			return target:calculate_magic_damage(Dmg)
		end
	},
	
	{Id = "Ashe", -- AAdmg value
		Damage = function(source, target)
            local Dmg = 0
			if target:has_buff("ashepassiveslow") then
				local Passive = 0.0075 + (source:has_item(3031) and 0.0035 or 0)
				local percent = 0.1 + source.crit_chance * Passive
				Dmg = Dmg + percent * source.total_attack_damage
			end	
			if source:has_buff("AsheQAttack") then
				local lvl = source:get_spell_slot(SLOT_Q).level
				Dmg = Dmg + ((Dmg + source.total_attack_damage) * (1 + 0.05 * lvl))
			end
			return target:calculate_phys_damage(Dmg)
		end
	},
	
	{Id = "Bard", -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("bardpspiritammocount") then return 0 end
            local chime = source:get_buff("bardpdisplaychimecount")
            if not chime or chime.count <= 0 then return 0 end			
            local Dmg = (14 * math.floor(chime.count / 5)) + 35 + 0.3 * source.ability_power			
			return target:calculate_magic_damage(Dmg)
		end
	},
	
	{Id = "Blitzcrank", -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("PowerFist") then return 0 end
            local Dmg1 = 0.25 * source.ability_power + 0.75 * source.total_attack_damage		
            local Dmg2 = 1.5 * source.ability_power + 2.5 * source.total_attack_damage			
			return target.is_hero and target:calculate_phys_damage(Dmg1) or target:calculate_phys_damage(Dmg2)
		end
	},
	
	{Id = "Braum", Slot = "Q", -- AAdmg//QDmg value
		Damage = function(source, target)
            local buff = target:get_buff("BraumMark")
            if not buff or buff.count ~= 3 then return end
            local Dmg = 16 + 10 * source.level		
			return target:calculate_magic_damage(Dmg)
		end
	},
	
	{Id = "Caitlyn", -- AAdmg
		Damage = function(source, target)
            if not source:has_buff("caitlynpassivedriver") then return 0 end
            local bonus = 1.3125 + (source:has_item(3031) and 0.2625 or 0)
            local Dmg1 = ({0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2})[source.level]
			local Dmg2 = ({1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.15, 1.15, 1.15, 1.15, 1.15, 1.15, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2})[source.level]		
			return target.is_hero and target:calculate_phys_damage((Dmg1 + (bonus * 0.01 * source.crit_chance)) * source.total_attack_damage) or
				   target:calculate_phys_damage((Dmg2 + (bonus * 0.01 * source.crit_chance)) * source.total_attack_damage)
		end
	},

	{Id = "Camille", -- AAdmg value
		Damage = function(source, target)
			local lvl = source:get_spell_slot(SLOT_Q).level
			if source:has_buff("CamilleQ") then
				return target:calculate_phys_damage((0.15 + 0.05 * lvl) * source.total_attack_damage)
			elseif source:has_buff("CamilleQ2") then
				local Dmg1 = (0.3 + 0.1 * lvl) * source.total_attack_damage
				local Dmg2 = math.min(0.36 + (0.04 * source.level), 1) * Dmg1
				return target:calculate_phys_damage(Dmg1) + Dmg2
			else
				return 0		
			end
		end
	},

	{Id = "Chogath", -- AAdmg value
		Damage = function(source, target)
            if not source:has_buff("VorpalSpikes") then return 0 end
            local lvl = source:get_spell_slot(SLOT_E).level
            local Dmg = (10 + 12 * lvl) + 0.3 * source.ability_power + ((0.03 + 0.05 * source:get_buff("Feast").stacks2) * target.max_health)
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Darius", -- AAdmg value
		Damage = function(source, target)
            if not source:has_buff("DariusNoxianTacticsONH") then return 0 end
            local lvl = source:get_spell_slot(SLOT_W).level
            local Dmg = (0.35 + 0.05 * lvl) * source.total_attack_damage
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "Diana", -- AAdmg value
		Damage = function(source, target)
            local buff = source:get_buff("dianapassivemarker")
            if not buff or buff.count ~= 2 then return 0 end
            local Dmg = ({20, 25, 30, 35, 40, 45, 55, 65, 75, 85, 95, 110, 125, 140, 155, 170, 195, 220})[source.level] + 0.5 * source.ability_power
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Draven", -- AAdmg value
		Damage = function(source, target)
            if not source:has_buff("DravenSpinningAttack") then return 0 end
            local lvl = source:get_spell_slot(SLOT_Q).level
			local Dmg = (35 + 5 * lvl) + ((0.65 + 0.1 * lvl) * source.bonus_attack_damage)
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "DrMundo", -- AAdmg value
		Damage = function(source, target)
            if not target.is_hero then return 0 end
			if not source:has_buff("DrMundoE") then return 0 end
            local lvl = source:get_spell_slot(SLOT_E).level
			local BonusHP = source.max_health - source.base_health
			local Dmg1 = ({5, 15, 25, 35, 45})[lvl] + 0.07 * BonusHP
			local Dmg2 = (1 - math.min((source.max_health - source.health) / source.max_health, 0.4)) * Dmg1
			return Dmg2 < 1 and target:calculate_phys_damage(Dmg1+Dmg2) or target:calculate_phys_damage(Dmg1)
		end
	},

	{Id = "Ekko", Slot = "All", -- AAdmg//SpellDmg value
		Damage = function(source, target)
            local buff = target:get_buff("ekkostacks")
            if not buff or buff.count ~= 2 then return 0 end
			local Dmg = ({30, 40, 50, 60, 70, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140})[source.level] + 0.9 * source.ability_power
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Ekko", -- AAdmg value
		Damage = function(source, target)
            if not source:has_buff("ekkoeattackbuff") then return 0 end
			local lvl = source:get_spell_slot(SLOT_E).level
			local Dmg = (25 + 25 * lvl) + 0.4 * source.ability_power
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Fizz", -- AAdmg value
		Damage = function(source, target)
            if not source:has_buff("FizzW") then return 0 end
			local lvl = source:get_spell_slot(SLOT_W).level
			local Dmg = (30 + 20 * lvl) + 0.5 * source.ability_power
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Galio", -- AAdmg value
		Damage = function(source, target)
            if not source:has_buff("galiopassivebuff") then return 0 end
			local Dmg = 15 + 185 / 17 * (source.level - 1) + source.total_attack_damage + 0.5 * source.ability_power + 0.6 * source.bonus_mr
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Garen", -- AAdmg value
		Damage = function(source, target)
            if not source:has_buff("GarenQ") then return 0 end
			local lvl = source:get_spell_slot(SLOT_Q).level
			local Dmg = 30 * lvl + 0.5 * source.total_attack_damage
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "Gnar", Slot = "All", -- AAdmg//All Spells Dmg value
		Damage = function(source, target)
            local buff = target:get_buff("gnarwproc")
            if not buff or buff.count ~= 2 then return 0 end
			local lvl = source:get_spell_slot(SLOT_W).level
			local Dmg = ({0, 10, 20, 30, 40})[lvl] + ((0.04 + 0.02 * lvl) * target.max_health) + source.ability_power
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Gragas", -- AAdmg value
		Damage = function(source, target)
            if not source:has_buff("gragaswattackbuff") then return 0 end
			local lvl = source:get_spell_slot(SLOT_W).level
			local Dmg = ({20, 50, 80, 110, 140})[lvl] + 0.07 * target.max_health + 0.7 * source.ability_power
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Gwen", Slot = "Q",  -- AAdmg // QDmg value
		Damage = function(source, target)
			local Dmg = (0.01 + 0.008 * 0.01 * source.ability_power) * target.max_health
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Gwen", Slot = "R",  -- AAdmg // RDmg value
		Damage = function(source, target)
			local Dmg = (0.01 + 0.008 * 0.01 * source.ability_power) * target.max_health
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Illaoi", -- AAdmg value
		Damage = function(source, target)
            if not target.is_hero then return 0 end
			if not source:has_buff("IllaoiW") then return 0 end
			local lvl = source:get_spell_slot(SLOT_W).level
			local Dmg = math.max(10 + 10 * lvl, target.max_health * ((0.025 + 0.005 * lvl) + 0.04 * source.total_attack_damage))
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "Irelia", -- AAdmg value
		Damage = function(source, target)
            local buff = source:get_buff("ireliapassivestacks")
            if not buff or buff.count ~= 4 then return 0 end
			local Dmg = (7 + 3 * source.level) + 0.2 * source.bonus_attack_damage
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "JarvanIV", -- AAdmg value
		Damage = function(source, target)
            if not target:has_buff("jarvanivmartialcadencecheck") then return 0 end
			local Dmg = math.min(400, math.max(20, 0.08 * target.health))
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "Jax", Slot = "Q",  -- AAdmg // QDmg value
		Damage = function(source, target)
			if not source:has_buff("JaxEmpowerTwo") then return 0 end
			local lvl = source:get_spell_slot(SLOT_W).level
			local Dmg = (15 + 35 * lvl) + 0.6 * source.ability_power
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Jax",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("JaxRelentlessAssault") then return 0 end
			local lvl = source:get_spell_slot(SLOT_R).level
			local Dmg = (10 + 50 * lvl) + 0.6 * source.ability_power
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Jayce",  -- AAdmg value
		Damage = function(source, target)
            local Damage = 0
			if source:has_buff("JaycePassiveMeleeAttack") then
                local Dmg = ({25, 25, 25, 25, 25, 65, 65, 65, 65, 65, 105, 105, 105, 105, 105, 145, 145, 145})[source.level] + 0.25 * source.bonus_attack_damage
                Damage = Damage + target:calculate_magic_damage(Dmg)                
            end
            if source:has_buff("HyperChargeBuff") then
                local lvl = source:get_spell_slot(SLOT_W).level
                local Dmg = ({0.3, 0.22, 0.14, 0.06, 0.02, 0.1})[lvl] * source.total_attack_damage
                Damage = Damage + (lvl >= 5 and target:calculate_phys_damage(Dmg) or (- target:calculate_phys_damage(Dmg)))
            end
			return Damage
		end
	},

	{Id = "Jhin",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("jhinpassiveattackbuff") then return 0 end
			local MissHp = target.max_health - target.health
			local Percent = source.level < 6 and 0.15 or source.level < 11 and 0.2 or 0.25
			local Dmg = Percent * MissHp
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "Jinx",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("JinxQ") then return 0 end
			local Dmg = 0.1 * source.total_attack_damage
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "Kaisa", Slot = "W",  -- AAdmg // WDmg value
		Damage = function(source, target)
			local buff = target:get_buff("kaisapassivemarker")
			if not buff then return 0 end
			local Dmg1 = 5 + 1.0588 * (source.level - 1)
			local Dmg2 = (1 + 0.6470 * (source.level - 1)) * buff.count
			local Dmg3 = math.min(0.15 + 0.025 * buff.count, 0.25) * source.ability_power
			local Dmg4 = (0.15 + (0.06 * source.ability_power / 100)) * (target.max_health - target.health)
			local Dmg = buff.count < 4 and (Dmg1+Dmg2+Dmg3) or (Dmg1+Dmg2+Dmg3+Dmg4)
			return target:calculate_magic_damage(Dmg)
		end
	},		

	{Id = "Kassadin",  -- AAdmg value
		Damage = function(source, target)
			local lvl = source:get_spell_slot(SLOT_W).level
			if source:has_buff("NetherBlade") then
				local Dmg = (25 + 25 * lvl) + 0.8 * source.ability_power
				return target:calculate_magic_damage(Dmg)			
			elseif lvl > 0 then
				local Dmg = 20 + 0.1 * source.ability_power
				return target:calculate_magic_damage(Dmg)
			end
		end
	},

	{Id = "Kayle",  -- AAdmg value
		Damage = function(source, target)
			local lvl = source:get_spell_slot(SLOT_E).level
			if lvl <= 0 then return 0 end
			local Dmg = (10 + 5 * lvl) + 0.2 * source.ability_power + 0.1 * source.bonus_attack_damage			
			if source:has_buff("JudicatorRighteousFury") then
				local Dmg = Dmg + ((0.075 + 0.005 * lvl) + (0.015 * source.ability_power / 100)) * (target.max_health - target.health)
			end
			return target:calculate_magic_damage(Dmg)  
		end
	},

	{Id = "Kennen",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("kennendoublestrikelive") then return 0 end
			local lvl = source:get_spell_slot(SLOT_W).level
			local Dmg = (25 + 10 * lvl) + ((0.7 + 0.1 * lvl) * source.bonus_attack_damage) + 0.35 * source.ability_power		
			return target:calculate_magic_damage(Dmg)  
		end
	},

	{Id = "KogMaw",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("KogMawBioArcaneBarrage") then return 0 end
			local lvl = source:get_spell_slot(SLOT_W).level
			local Dmg = target.is_hero and ((0.0275 + 0.0075 * lvl) + 0.01 * source.ability_power / 100) * target.max_health or
						math.min(100, ((0.0275 + 0.0075 * lvl) + 0.01 * source.ability_power / 100) * target.max_health)
			return target:calculate_magic_damage(Dmg)  
		end
	},

	{Id = "Leona",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("LeonaShieldOfDaybreak") then return 0 end
			local lvl = source:get_spell_slot(SLOT_Q).level
			local Dmg = ({10, 35, 60, 85, 110})[lvl] + 0.3 * source.ability_power
			return target:calculate_magic_damage(Dmg)  
		end
	},

	{Id = "All", Slot = "All",  -- AAdmg // all spells Dmg value //// Leona
		Damage = function(source, target)
			if not IsAlly("Leona") then return 0 end
			if source.champ_name == "Leona" then return 0 end
			if not target:has_buff("LeonaSunlight") then return 0 end
			local Dmg = 24 + 8 * source.level
			return target:calculate_magic_damage(Dmg) 
		end
	},	
	
	{Id = "Lux", Slot = "R",  -- AAdmg // RDmg value
		Damage = function(source, target)
			if not target:has_buff("LuxIlluminatingFraulein") then return 0 end
			local Dmg = 10 + 10 * source.level + 0.2 * source.ability_power
			return target:calculate_magic_damage(Dmg)  
		end
	},

	{Id = "Malphite",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("MalphiteCleave") then return 0 end
			local lvl = source:get_spell_slot(SLOT_W).level
			local Dmg = (20 + 10 * lvl) + 0.2 * source.ability_power + 0.15 * source.armor
			return target:calculate_phys_damage(Dmg)  
		end
	},

	{Id = "MasterYi",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("wujustylesuperchargedvisual") then return 0 end
			local lvl = source:get_spell_slot(SLOT_E).level
			return (25 + 5 * lvl) + 0.3 * source.bonus_attack_damage  
		end
	},

	{Id = "MissFortune",  -- AAdmg value
		Damage = function(source, target)
			if not target:has_buff("Needcheck") then return 0 end                            ---<<<<<<< need target buff name >>>>>>>>>>>>>>>>>>>
			local Dmg = (source.level < 4 and 0.5 or 
						 source.level < 7 and 0.6 or 
						 source.level < 9 and 0.7 or 
						 source.level < 11 and 0.8 or
						 source.level < 13 and 0.9 or 1) * source.total_attack_damage
			return target.is_hero and target:calculate_phys_damage(Dmg) or target:calculate_phys_damage((Dmg/2))
		end
	},

	{Id = "Mordekaiser",  -- AAdmg value
		Damage = function(source, target)
			return target:calculate_magic_damage(0.4 * source.ability_power)
		end
	},

	{Id = "All", Slot = "All",  -- AAdmg // all spells Dmg value //// Nami
		Damage = function(source, target)
			if not IsAlly("Nami") then return 0 end
			if not source:has_buff("NamiE") then return 0 end
			local lvl = source:get_spell_slot(SLOT_E).level
			local Dmg = 5 + 15 * lvl + 0.2 * source.ability_power
			return target:calculate_magic_damage(Dmg) 
		end
	},

	{Id = "Nasus",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("NasusQ") then return 0 end
            local buff = source:get_buff("NasusQStacks")
            local stacks = buff ~= nil and buff.count or 0
            local lvl = source:get_spell_slot(SLOT_Q).level
			local Dmg = (10 + 20 * lvl) + stacks
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "Nautilus",  -- AAdmg value
		Damage = function(source, target)
			if target:has_buff("nautiluspassivecheck") then return 0 end
			local Dmg = 8 + 6 * source.level
			return target:calculate_phys_damage(Dmg) 
		end
	},

	{Id = "Nidalee",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("Takedown") then return 0 end
			local lvl = source:get_spell_slot(SLOT_Q).level
			local Dmg = ((-20 + 25 * lvl) + 0.75 * source.total_attack_damage + 0.4 * source.ability_power) * ((target.max_health - target.health) / target.max_health + 1)
			if target:has_buff("NidaleePassiveHunted") then
				Dmg = Dmg * 1.4
			end
			return target:calculate_magic_damage(Dmg) 
		end
	},

	{Id = "Neeko",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("neekowpassiveready") then return 0 end
			local lvl = source:get_spell_slot(SLOT_W).level
			local Dmg = 20 + 30 * lvl + 0.6 * source.ability_power
			return target:calculate_magic_damage(Dmg) 
		end
	},

	{Id = "Nocturne",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("nocturneumbrablades") then return 0 end
			local Dmg = 0.2 * source.total_attack_damage
			return target:calculate_phys_damage(Dmg) 
		end
	},

	{Id = "Orianna",  -- AAdmg value
		Damage = function(source, target)
			local Dmg = (10 + 40 / 17 * (source.level - 1)) + 0.15 * source.ability_power
            local buff = source:get_buff("orianapowerdaggerdisplay")
            if buff and buff.count ~= 0 then 
				Dmg = Dmg * (1 + 0.2 * buff.count)			
			end
			return target:calculate_magic_damage(Dmg) 
		end
	},

	{Id = "Poppy",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("poppypassivebuff") then return 0 end
			local Dmg = 20 + 160 / 17 * (source.level - 1)
			return target:calculate_magic_damage(Dmg) 
		end
	},

	{Id = "Quinn",  -- AAdmg value
		Damage = function(source, target)
			if not target:has_buff("QuinnW") then return 0 end
			local Dmg = (5 + 5 * source.level) + ((0.14 + 0.02 * source.level) * source.total_attack_damage)
			return target:calculate_phys_damage(Dmg) 
		end
	},

	{Id = "RekSai",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("RekSaiQ") then return 0 end
			local lvl = source:get_spell_slot(SLOT_Q).level
			local Dmg = (15 + 6 * lvl) + 0.5 * source.bonus_attack_damage
			return target:calculate_phys_damage(Dmg) 
		end
	},

	{Id = "Rell",  -- AAdmg value
		Damage = function(source, target)
			local Dmg = 7.53 + 0.47 * source.level
			if source:has_buff("RellWEmpoweredAttack") then
				local lvl = source:get_spell_slot(SLOT_W).level
				Dmg = Dmg + ((-5 + 15 * lvl) + 0.4 * source.ability_power)
			end
			return target:calculate_magic_damage(Dmg) 
		end
	},

	{Id = "Rengar",  -- AAdmg value
		Damage = function(source, target)
            local lvl = source:get_spell_slot(SLOT_Q).level
			if source:has_buff("RengarQ") then
                local Dmg = ({30, 60, 90, 120, 150})[lvl] + (({0, 0.05, 0.1, 0.15, 0.2})[lvl] * source.total_attack_damage)
				return target:calculate_phys_damage(Dmg)
            elseif source:has_buff("RengarQEmp") then
                local Dmg = ({30, 45, 60, 75, 90, 105, 120, 135, 145, 155, 165, 175, 185, 195, 205, 215, 225, 235})[source.level] + 0.4 * source.total_attack_damage
				return target:calculate_phys_damage(Dmg)	
            end 
		end
	},

	{Id = "Riven",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("RivenPassiveAABoost") then return 0 end
			local Dmg = source.level <= 17 and ((0.3 + 0.0175 * (source.level - 1)) * source.total_attack_damage) or 0.6 * source.total_attack_damage
			return target:calculate_phys_damage(Dmg) 
		end
	},

	{Id = "Rumble",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("RumbleOverheat") then return 0 end
			local Dmg = 5 + 35 / 17 * (source.level -1) + 0.25 * source.ability_power + 0.06 * target.max_health
			return target:calculate_magic_damage(Dmg) 
		end
	},

	{Id = "Sett",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("SettQ") then return 0 end
			local lvl = source:get_spell_slot(SLOT_Q).level
			local Dmg = 10 * lvl + (0.01 + (0.005 + 0.005 * lvl) * 0.01 * source.total_attack_damage) * target.max_health
			return target:calculate_phys_damage(Dmg) 
		end
	},

	{Id = "Shen",  -- AAdmg value
		Damage = function(source, target)
            local lvl = source:get_spell_slot(SLOT_Q).level
            if source:has_buff("shenqbuffweak") then
                local Dmg = 4 + 6 * math.ceil(source.level / 3) + ((0.015 + 0.005 * lvl + 0.015 * source.ability_power / 100) * target.max_health)
				return target:calculate_magic_damage(Dmg)
			elseif source:has_buff("shenqbuffstrong") then
                local Dmg = 4 + 6 * math.ceil(source.level / 3) + ((0.035 + 0.005 * lvl + 0.02 * source.ability_power / 100) * target.max_health)
				return target:calculate_magic_damage(Dmg)
			end
		end
	},

	{Id = "Shyvana",  -- AAdmg value
		Damage = function(source, target)
            local Dmg = 0
			local Qlvl = source:get_spell_slot(SLOT_Q).level
			local Elvl = source:get_spell_slot(SLOT_E).level
            if source:has_buff("ShyvanaDoubleAttack") then
                local QDmg = (0.05 + 0.15 * Qlvl) * source.total_attack_damage + 0.25 * source.ability_power
				Dmg = Dmg + target:calculate_phys_damage(QDmg)
            end
            if target:has_buff("ShyvanaFireballMissile") then
                Dmg = Dmg + target:calculate_magic_damage(0.03 * target.max_health)
            end
			return Dmg
		end
	},

	{Id = "Skarner",  -- AAdmg value
		Damage = function(source, target)
			if not target:has_buff("skarnerpassivebuff") then return 0 end
			local lvl = source:get_spell_slot(SLOT_E).level
			local Dmg = 10 + 20 * lvl
			return target:calculate_phys_damage(Dmg) 
		end
	},

	{Id = "Sona",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("SonaQProcAttacker") then return 0 end
			local lvl = source:get_spell_slot(SLOT_Q).level
			local Dmg = 5 + 5 * lvl + 0.2 * source.ability_power
			return target:calculate_magic_damage(Dmg) 
		end
	},

	{Id = "Sylas",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("SylasPassiveAttack") then return 0 end
			local Dmg = 0.25 * source.ability_power + 1.3 * source.total_attack_damage
			return target:calculate_magic_damage(Dmg) - target:calculate_phys_damage(source.total_attack_damage)
		end
	},

	{Id = "TahmKench", Slot = "Q",  -- AAdmg // QDmg value
		Damage = function(source, target)
			local Dmg = (8 + 52 / 17 * (source.level - 1)) + (((0.02 * source.ability_power / 100) + 0.03) * (source.max_health - source.base_health)) 
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Taric",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("taricgemcraftbuff") then return 0 end
			local Dmg = 21 + 4 * source.level + 0.15 * source.bonus_armor
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Teemo",  -- AAdmg value
		Damage = function(source, target)
			local lvl = source:get_spell_slot(SLOT_E).level
			local Dmg = lvl > 0 and (3 + 11 * lvl) + 0.3 * source.ability_power or 0
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Trundle",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("TrundleTrollSmash") then return 0 end
			local lvl = source:get_spell_slot(SLOT_Q).level
			local Dmg = 20 * lvl + ((0.05 + 0.1 * lvl) * source.total_attack_damage)
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "TwistedFate",  -- AAdmg value
		Damage = function(source, target)
            local FullDmg = 0
			local lvl = source:get_spell_slot(SLOT_W).level
            if source:has_buff("BlueCardPreAttack") then
                local Dmg = 20 + 20 * lvl + source.total_attack_damage + 1.15 * source.ability_power
				FullDmg = target:calculate_magic_damage(Dmg) - target:calculate_phys_damage(source.total_attack_damage)
			elseif source:has_buff("RedCardPreAttack") then
                local Dmg = 15 + 15 * lvl + source.total_attack_damage + 0.7 * source.ability_power
				FullDmg = target:calculate_magic_damage(Dmg) - target:calculate_phys_damage(source.total_attack_damage)
            elseif source:has_buff("GoldCardPreAttack") then
                local Dmg = 7.5 + 7.5 * lvl + source.total_attack_damage + 0.5 * source.ability_power
				FullDmg = target:calculate_magic_damage(Dmg) - target:calculate_phys_damage(source.total_attack_damage)
            end
            if source:has_buff("cardmasterstackparticle") then
                local Elvl = source:get_spell_slot(SLOT_E).level
                local Dmg = (40 + 25 * Elvl) + 0.5 * source.ability_power
				FullDmg = FullDmg + target:calculate_magic_damage(Dmg)
            end			
		end
	},

	{Id = "Varus",  -- AAdmg value
		Damage = function(source, target)
			local lvl = source:get_spell_slot(SLOT_W).level
			local Dmg = lvl > 0 and (2 + 5 * lvl) + 0.3 * source.ability_power or 0
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Vayne",  -- AAdmg value
		Damage = function(source, target)
			if not source:has_buff("vaynetumblebonus") then return 0 end
			local Qlvl = source:get_spell_slot(SLOT_Q).level
            local Dmg = ((0.65 + 0.1 * Qlvl) * source.bonus_attack_damage)
            return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "Vayne", Slot = "E",  -- AAdmg // EDmg value /// truedmg
		Damage = function(source, target)		
            local buff = target:get_buff("VayneSilveredDebuff")
			if not buff or buff.count ~= 2 then return 0 end
			local Wlvl = source:get_spell_slot(SLOT_W).level
			local Dmg = math.max((0.05 + 0.01 * Wlvl) * target.max_health, 35 + 15 * Wlvl)
			return Dmg
		end
	},

	{Id = "Vi",  -- AAdmg
		Damage = function(source, target)		
			if not source:has_buff("ViE") then return 0 end
			local lvl = source:get_spell_slot(SLOT_E).level
			local Dmg = ({0, 15, 30, 45, 60})[lvl] + 0.2 * source.total_attack_damage + source.ability_power
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "Vi", Slot = "Q",  -- AAdmg // QDmg value
		Damage = function(source, target)		
            local buff = target:get_buff("viwproc")
			if not buff or buff.count ~= 2 then return 0 end
			local lvl = source:get_spell_slot(SLOT_W).level
			local Dmg = (0.025 + 0.015 * lvl + 0.01 * source.bonus_attack_damage / 35) * target.max_health
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "Viego",  -- AAdmg
		Damage = function(source, target)		
            local lvl = source:get_spell_slot(SLOT_Q).level
			if lvl <= 0 then return 0 end			
			local Dmg = math.max(5 + 5 * lvl, ({0.02, 0.03, 0.04, 0.05, 0.06})[lvl] * target.health)						
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "Viktor",  -- AAdmg
		Damage = function(source, target)		
            if not source:has_buff("ViktorPowerTransferReturn") then return 0 end
			local lvl = source:get_spell_slot(SLOT_Q).level		
			local Dmg = ({20, 45, 70, 95, 120})[lvl] + source.total_attack_damage + 0.6 * source.ability_power						
			return target:calculate_magic_damage(Dmg) - target:calculate_phys_damage(source.total_attack_damage)
		end
	},

	{Id = "Volibear",  -- AAdmg
		Damage = function(source, target)		
            local FullDmg = 0
			if source:has_buff("volibearpapplicator") then	
				local Dmg = ({11, 12, 13, 15, 17, 19, 22, 25, 28, 31, 34, 37, 40, 44, 48, 52, 56, 60})[source.level] + 0.4 * source.ability_power						
				FullDmg = FullDmg + target:calculate_magic_damage(Dmg)
			end	
			if source:has_buff("VolibearQ") then	
				local lvl = source:get_spell_slot(SLOT_Q).level	
				local Dmg = ({10, 30, 50, 70, 90})[lvl] + 1.2 * source.bonus_attack_damage						
				FullDmg = FullDmg + target:calculate_phys_damage(Dmg)
			end
			return FullDmg
		end
	},

	{Id = "Warwick",  -- AAdmg
		Damage = function(source, target)		
			local Dmg = (10 + 2 * source.level) + 0.15 * source.bonus_attack_damage + 0.1 * source.ability_power						
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "MonkeyKing",  -- AAdmg
		Damage = function(source, target)		
            if not source:has_buff("MonkeyKingDoubleAttack") then return 0 end
			local lvl = source:get_spell_slot(SLOT_Q).level		
			local Dmg = ({20, 45, 70, 95, 120})[lvl] + 0.45 * source.bonus_attack_damage 						
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "XinZhao",  -- AAdmg
		Damage = function(source, target)		
            if not source:has_buff("XinZhaoQ") then return 0 end
			local lvl = source:get_spell_slot(SLOT_Q).level		
			local Dmg = ({16, 25, 34, 43, 52})[lvl] + 0.4 * source.bonus_attack_damage						
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "XinZhao", Slot = "W",  -- AAdmg // WDmg value
		Damage = function(source, target)		
            local buff = source:get_buff("XinZhaoP")
			if not buff or buff.count ~= 3 then return 0 end
			local Dmg = source.level < 6 and 0.15 * source.total_attack_damage or
						source.level < 11 and 0.3 * source.total_attack_damage or
						source.level < 16 and 0.45 * source.total_attack_damage or 
						0.6 * source.total_attack_damage
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "Yorick",  -- AAdmg
		Damage = function(source, target)		
            if not source:has_buff("yorickqbuff") then return 0 end
			local lvl = source:get_spell_slot(SLOT_Q).level		
			local Dmg = 5 + 25 * lvl + 0.4 * source.total_attack_damage						
			return target:calculate_phys_damage(Dmg)
		end
	},

	{Id = "Zed",  -- AAdmg
		Damage = function(source, target)		
            if target:health_percentage() > 50 then return 0 end	
			local Dmg = source.level < 7 and 0.06 * target.max_health or
						source.level < 17 and 0.08 * target.max_health or
						0.1 * target.max_health
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Ziggs",  -- AAdmg
		Damage = function(source, target)		
            if not source:has_buff("ZiggsShortFuse") then return 0 end	
			local Dmg = ({20, 24, 28, 32, 36, 40, 48, 56, 64, 72, 80, 88, 100, 112, 124, 136, 148, 160})[source.level] + 0.5 * source.ability_power						
			return target:calculate_magic_damage(Dmg)
		end
	},

	{Id = "Zoe", Slot = "W",  -- AAdmg // WDmg value
		Damage = function(source, target)		
            if not source:has_buff("zoepassivesheenbuff") then return 0 end	
			local Dmg = ({16, 20, 24, 28, 32, 36, 42, 48, 54, 60, 66, 74, 82, 90, 100, 110, 120, 130})[source.level] + 0.2 * source.ability_power						
			return target:calculate_magic_damage(Dmg)
		end
	},		
}

local DmgItems = {	
	['ArdentCenser'] = 3504,		
	['BladeoftheRuinedKing'] = 3153,
	['DeadMansPlate'] = 3742,		
	["DivineSunderer"] = 6632,
    ["DoransRing"] = 1056,
    ["DoransShield"] = 1054,	
	['DuskbladeofDraktharr'] = 6691,
	["EssenceReaver"] = 3508,		
	["Eclipse"] = 6692,				
	['Evenshroud'] = 3001,			
	['HextechAlternator'] = 3145, 	
	['HorizonFocus'] = 4628,		
	["ImperialMandate"] = 4005,		
	['KircheisShard'] = 2015,		
	["KrakenSlayer"] = 6672,		
  --["LiandryAnguish"] = 6653,			--only for spells 
	['LichBane'] = 3100,			
	['LordDominiksRegards'] = 3036,	
  --["LudensTempest"] = 6655,			--only for spells
	['NashorsTooth'] = 3115,		
  --["NightHarvester"] = 4636,			--spells/AA AP-Dmg =  Broken by riot // Dont give cooldown/buff ingame
	["Noonquiver"] = 6670,
	["ProwlersClaw"] = 6693,
	["RelicShield"] = 3302,				
	['RecurveBow'] = 1043,			
	['RapidFirecannon'] = 3094,		
	['Riftmaker'] = 4633,			
	['Sheen'] = 3057, 				
	['Stormrazor'] = 3095,
	["SteelShoulderguards"] = 3854,	
	['TrinityForce'] = 3078,
	["TearoftheGoddess"] = 3070,      
	["TheCollector"] = 6676, 		
	['TitanicHydra'] = 3748,		
	['WitsEnd'] = 3091,						
}

local CalcItemDmg = {
	{Id = DmgItems.ArdentCenser, DamageType = 2, spell = "AA",
		ItemDamage = function(source, target)
			if source:has_buff("3504buff") then
				return 5+15/17*(source.level-1)
			end			
			return 0
		end
	},
	
	{Id = DmgItems.BladeoftheRuinedKing, DamageType = 1, spell = "AA", 
		ItemDamage = function(source, target)
			if target.is_hero then
				if source.is_melee then
					return 0.12*target.health
				else
					return 0.08*target.health	
				end
				
			elseif target.is_minion or target.is_jungle_minion then
				
				if source.is_melee then
					return (0.12*target.health >= 61) and 60 or 0.12*target.health
				else
					return (0.08*target.health >= 61) and 60 or 0.08*target.health
				end				
			end	
		end
	},

	{Id = DmgItems.BladeoftheRuinedKing, DamageType = 2, spell = "AA",
		ItemDamage = function(source, target)
			if target.is_hero then
				if target:get_buff("item3153botrkstacks").stacks2 == 2 then
					return 40+110/17*(source.level-1)
				end
			end	
			return 0
		end
	},	
	
	{Id = DmgItems.DeadMansPlate, DamageType = 1, spell = "AA",
		ItemDamage = function(source, target)
			local Dmg1 = 0.4*source:get_item(3742).count2
			local Dmg2 = source:get_item(3742).count2/100*source.base_attack_damage
			return Dmg1+Dmg2
		end
	},	

	{Id = DmgItems.DivineSunderer, DamageType = 1, spell = "AA",
		ItemDamage = function(source, target)
			if source:has_buff("6632buff") then
				if target.is_hero or target.is_minion then
					if source.is_melee then
						return 0.06*target.max_health
					else
						return 0.03*target.max_health
					end
				
				elseif target.is_jungle_minion then
					
					if source.is_melee then
						return (0.06*target.max_health > 2.5*source.base_attack_damage) and 2.5*source.base_attack_damage or 0.06*target.max_health
					else
						return (0.03*target.max_health > 2.5*source.base_attack_damage) and 2.5*source.base_attack_damage or 0.03*target.max_health
					end					
				end
			end			
			return 0
		end
	},	
	
	{Id = DmgItems.DuskbladeofDraktharr, DamageType = 1, spell = "AA",
		ItemDamage = function(source, target)
			if target.is_hero then
				if game.game_time > source:get_spell_slot(source:get_item(6691).spell_slot).current_cooldown then
					if source.is_melee then
						return 75+0.3*source.bonus_attack_damage
					else
						return 55+0.25*source.bonus_attack_damage
					end
				end	
			end	
			return 0
		end
	},
	
	{Id = DmgItems.DoransRing, DamageType = 1, spell = "AA",	
		ItemDamage = function(source, target)
			if target.is_minion then
				return 5
			end
			return 0
		end
	},	

	{Id = DmgItems.DoransShield, DamageType = 1, spell = "AA",	
		ItemDamage = function(source, target)
			if target.is_minion then
				return 5
			end
			return 0
		end
	},		

	{Id = DmgItems.EssenceReaver, DamageType = 1, spell = "AA",
		ItemDamage = function(source, target)
			if source:has_buff("3508buff") then
				return source.base_attack_damage+0.4*source.bonus_attack_damage
			end			
			return 0
		end
	},
	--[[
	{Id = DmgItems.Eclipse, DamageType = 1, spell = "AA",   -- cant count second hit
		ItemDamage = function(source, target)
			if game.game_time > source:get_spell_slot(source:get_item(6692).spell_slot).current_cooldown then
				return source.total_attack_damage+0.06*target.max_health
			end			
			return 0
		end
	},
	]]
	{Id = DmgItems.Evenshroud, DamageType = 1, spell = "AA",  ---for spells too
		ItemDamage = function(source, target)
			if target.is_hero then
				if target:has_buff("item3001debuff") then
					return 0.09*source.total_attack_damage
				end
			end	
			return 0
		end
	},

	{Id = DmgItems.HextechAlternator, DamageType = 2, spell = "AA",  ---for spells too
		ItemDamage = function(source, target)
			if target.is_hero then
				if game.game_time > source:get_spell_slot(source:get_item(3145).spell_slot).current_cooldown then
					return 50+75/17*(source.level-1)
				end	
			end	
			return 0
		end
	},

	{Id = DmgItems.HorizonFocus, DamageType = 1, spell = "AA",  ---for spells too
		ItemDamage = function(source, target)
			if target.is_hero then
				if target:has_buff("4628marker") and target:get_buff("4628marker").source_id == source.object_id then
					return 0.1*source.total_attack_damage
				end	
			end	
			return 0
		end
	},

	{Id = DmgItems.KircheisShard, DamageType = 2, spell = "AA", 
		ItemDamage = function(source, target)
			if source:get_buff("itemstatikshankcharge").stacks2 == 100 then
				return 80
			end			
			return 0
		end
	},

	{Id = DmgItems.KrakenSlayer, DamageType = 3, spell = "AA", 
		ItemDamage = function(source, target)
			if source:get_buff("6672buff").stacks2 == 2 then
				return 50+(0.4*source.bonus_attack_damage)
			end			
			return 0
		end
	},

	{Id = DmgItems.LichBane, DamageType = 2, spell = "AA", 
		ItemDamage = function(source, target)
			if source:has_buff("lichbane") then
				return 0.75*source.base_attack_damage + 0.5*source.ability_power
			end			
			return 0
		end
	},	
	
	{Id = DmgItems.LordDominiksRegards, DamageType = 1, spell = "AA",  ---for ADspells too
		ItemDamage = function(source, target)
            if target.is_hero then
				local DiffHP = math.abs(source.max_health - target.max_health)
				return 0.0075 * DiffHP / 100 * source.total_attack_damage
			end	
			return 0
		end
	},	
	
	{Id = DmgItems.NashorsTooth, DamageType = 2, spell = "AA",
		ItemDamage = function(source, target)
			return 15+(0.2*source.ability_power)			
		end
	},
	
	{Id = DmgItems.Noonquiver, DamageType = 1, spell = "AA",
		ItemDamage = function(source, target)
			if target.is_minion then
				return 20
			end
			return 0
		end
	},	

	{Id = DmgItems.ProwlersClaw, DamageType = 1, spell = "AA",		---for spells too
		ItemDamage = function(source, target)
			if target.is_hero then
				if target:has_buff("6693amp") and target:get_buff("6693amp").source_id == source.object_id then
					return 0.15*source.total_attack_damage
				end
			end	
			return 0
		end
	},			
	
	{Id = DmgItems.RelicShield, DamageType = 3, spell = "AA",
		ItemDamage = function(source, target)
			if target.is_minion then
				for i, Ally in ipairs(GetAllyHeroes()) do
					if Ally.object_id ~= source.object_id and GetDistance(Ally.origin, source.origin) < 1050 and Ally.is_alive then
						local Buff = source:has_buff("talentreaperstacksone") or source:has_buff("talentreaperstackstwo") or source:has_buff("talentreaperstacksthree")
						if Buff then
							if source.is_melee then
								if target.max_health * 0.5 > target.health then
									return 99999
								end								
							else								
								if target.max_health * 0.3 > target.health then
									return 99999
								end
							end						
						end
					end
				end
			end	
			return 0			
		end
	},	
	
	{Id = DmgItems.RecurveBow, DamageType = 1, spell = "AA",
		ItemDamage = function(source, target)
			return 15			
		end
	},

	{Id = DmgItems.RapidFirecannon, DamageType = 2, spell = "AA", 
		ItemDamage = function(source, target)
			if source:get_buff("itemstatikshankcharge").stacks2 == 100 then
				return 120
			end			
			return 0
		end
	},

	{Id = DmgItems.Riftmaker, DamageType = 1, spell = "AA",		---for spells too
		ItemDamage = function(source, target)
			if target.is_hero then
				if source:has_buff("4633stackcounter") then
					return (source:get_buff("4633stackcounter").stacks2*0.03)*source.total_attack_damage
				end
			end	
			return 0
		end
	},

	{Id = DmgItems.Riftmaker, DamageType = 3, spell = "AA",		---for spells too
		ItemDamage = function(source, target)
			if target.is_hero then
				if source:has_buff("4633enragebuff") then
					return 0.09*source.total_attack_damage
				end
			end	
			return 0
		end
	},

	{Id = DmgItems.Sheen, DamageType = 1, spell = "AA",	
		ItemDamage = function(source, target)
			if source:has_buff("sheen") then
				return source.base_attack_damage
			end
			return 0
		end
	},	
	
	{Id = DmgItems.Stormrazor, DamageType = 2, spell = "AA", 
		ItemDamage = function(source, target)
			if source:get_buff("itemstatikshankcharge").stacks2 == 100 then
				return 120
			end			
			return 0
		end
	},
	
	{Id = DmgItems.SteelShoulderguards, DamageType = 3, spell = "AA",
		ItemDamage = function(source, target)
			if target.is_minion then
				for i, Ally in ipairs(GetAllyHeroes()) do
					if Ally.object_id ~= source.object_id and GetDistance(Ally.origin, source.origin) < 1050 and Ally.is_alive then
						local Buff = source:has_buff("talentreaperstacksone") or source:has_buff("talentreaperstackstwo") or source:has_buff("talentreaperstacksthree")
						if Buff then
							if source.is_melee then
								if target.max_health * 0.5 > target.health then
									return 99999
								end								
							else								
								if target.max_health * 0.3 > target.health then
									return 99999
								end
							end						
						end
					end
				end
			end	
			return 0			
		end
	},	
	
	{Id = DmgItems.TearoftheGoddess, DamageType = 1, spell = "AA",	
		ItemDamage = function(source, target)
			if target.is_minion then
				return 5
			end
			return 0
		end
	},	

	{Id = DmgItems.TrinityForce, DamageType = 1, spell = "AA",	
		ItemDamage = function(source, target)
			if source:has_buff("3078trinityforce") then
				return 2*source.base_attack_damage
			end
			return 0
		end
	},

	{Id = DmgItems.TitanicHydra, DamageType = 1, spell = "AA",	
		ItemDamage = function(source, target)
			return source.is_melee and 4+(0.015*source.max_health) or 3+(0.01125*source.max_health)
		end
	},

	{Id = DmgItems.WitsEnd, DamageType = 2, spell = "AA",	
		ItemDamage = function(source, target)
			return ({15, 15, 15, 15, 15, 15, 15, 15, 25, 35, 45, 55, 65, 75, 76.25, 77.5, 78.75, 80})[source.level]
		end
	},
}

local DmgPerks = {	
	['PressTheAttack'] = 8005,
	['PressTheAttack2'] = 8005,
	['CoupdeGrace'] = 8014,
	['CutDown'] = 8017,		
	["LastStand"] = 8299,
    ["FirstStrike"] = 8369,	
	["Predator"] = 8124,		
	["DarkHarvest"] = 8128,				
	['GraspoftheUndying'] = 8437,				
	['ShieldBash'] = 8401,											
}

local CalcPerkDmg = {
	{Id = DmgPerks.PressTheAttack, type = "Dmg_Value", OnlyAA = true, -- AAdmg value
		Damage = function(source, target)
			if not target.is_hero then return 0 end
			local buff = target:get_buff("ASSETS/Perks/Styles/Precision/PressTheAttack/PressTheAttackStack.lua")
			if buff and buff.is_valid and buff.stacks2 == 2 then 
				local Dmg = 40 + 140 / 17 * (source.level - 1)
				return source.bonus_attack_damage >= source.ability_power and target:calculate_phys_damage(Dmg) or target:calculate_magic_damage(Dmg)
			end			
			return 0
		end
	},
	
	{Id = DmgPerks.PressTheAttack2, type = "Dmg_Percent",  -- AADmg/SpellDmg %
		Damage = function(source, target)
			if not target.is_hero then return 0 end
			local buff = target:get_buff("ASSETS/Perks/Styles/Precision/PressTheAttack/PressTheAttackDamageAmp.lua")
			if buff and buff.is_valid then 
				return (0.08 + 0.04 / 17 * (source.level - 1))
			end			
			return 0
		end
	},

	{Id = DmgPerks.CoupdeGrace, type = "Dmg_Percent",  -- AADmg/SpellDmg %
		Damage = function(source, target)
			if not target.is_hero then return 0 end
			if target:health_percentage() > 40 then return 0 end		
			return 0.08
		end
	},

	{Id = DmgPerks.CutDown, type = "Dmg_Percent",  -- AADmg/SpellDmg %
		Damage = function(source, target)
			if not target.is_hero then return 0 end
            local DiffHP = target.max_health * 100 / source.max_health - 100
            if DiffHP < 10 then
                return 0
            end
            local calc = (0.05 + (DiffHP - 10) * 0.001111111111111)

            return calc >= 0.15 and 0.15 or calc
		end
	},

	{Id = DmgPerks.LastStand, type = "Dmg_Percent",  -- AADmg/SpellDmg %
		Damage = function(source, target)
			if not target.is_hero then return 0 end
            if source:health_percentage() > 60 then return 0 end
			local hpPercent = source:health_percentage()
            if hpPercent < 30 then
                hpPercent = 30
            end
            if hpPercent <= 60 then
                hpPercent = hpPercent / 100
                return (1 - hpPercent) * 0.2 - 0.03
            end
		end
	},

	{Id = DmgPerks.FirstStrike, type = "Dmg_Percent",  -- AADmg/SpellDmg TrueDmg%
		Damage = function(source, target)
			if not target.is_hero then return 0 end
			local buff = source:get_buff("ASSETS/Perks/Styles/Inspiration/FirstStrike/FirstStrike.lua")
			if buff and buff.is_valid then 
				return 0.09
			end			
			return 0
		end
	},

	{Id = DmgPerks.Predator, type = "Dmg_Value", OnlyAA = false,  -- AADmg/SpellDmg Value
		Damage = function(source, target)
			if not target.is_hero then return 0 end
			local buff = source:get_buff("ASSETS/Perks/Styles/Domination/Predator/PredatorActive.lua")
			if buff and buff.is_valid then 
				local Dmg = (20 + 160 / 17 * (source.level - 1)) + 0.25 * source.bonus_attack_damage + 0.15 * source.ability_power
				return 0.25 * source.bonus_attack_damage >= 0.15 * source.ability_power and target:calculate_phys_damage(Dmg) or target:calculate_magic_damage(Dmg)
			end			
			return 0
		end
	},

	{Id = DmgPerks.DarkHarvest, type = "Dmg_Value", OnlyAA = false,  -- AADmg/SpellDmg Value
		Damage = function(source, target)
			if not target.is_hero then return 0 end
			if target:health_percentage() >= 50 then return 0 end
			if source:has_buff("ASSETS/Perks/Styles/Domination/DarkHarvest/DarkHarvestCooldown.lua") then return 0 end
			local buff = source:get_buff("ASSETS/Perks/Styles/Domination/DarkHarvest/DarkHarvest.lua")
			if buff and buff.is_valid then 
				local Dmg = (20 + 40 / 17 * (source.level - 1)) + 0.25 * source.bonus_attack_damage + 0.15 * source.ability_power + 5 * buff.stacks2
				return source.bonus_attack_damage >= source.ability_power and target:calculate_phys_damage(Dmg) or target:calculate_magic_damage(Dmg)
			end			
			return 0
		end
	},

	{Id = DmgPerks.GraspoftheUndying, type = "Dmg_Value", OnlyAA = true,  -- AADmg Value
		Damage = function(source, target)
			if not target.is_hero then return 0 end
			local buff = source:get_buff("ASSETS/Perks/Styles/Resolve/GraspOfTheUndying/GraspOfTheUndyingONH.lua")
			if buff and buff.is_valid then 
				local Dmg = source.is_melee and (0.035 * source.max_health) or (0.021 * source.max_health)
				return target:calculate_magic_damage(Dmg)
			end			
			return 0
		end
	},

	{Id = DmgPerks.ShieldBash, type = "Dmg_Value", OnlyAA = true,  -- AADmg Value
		Damage = function(source, target)
			if not target.is_hero then return 0 end
			if source.shield <= 0 then return 0 end
			local Bonus_HP = source.max_health - source.base_health
			local Dmg = (5 + 25 / 17 * (source.level - 1)) + 0.015 * Bonus_HP + 0.085 * source.shield
			return source.bonus_attack_damage >= source.ability_power and target:calculate_phys_damage(Dmg) or target:calculate_magic_damage(Dmg)
		end
	},
}

local function getdmg_perk(target, source, dmg, SpellDmg)
	local Damage = 0
    for i = 1, #CalcPerkDmg do
        local Perk = CalcPerkDmg[i]
		
		if source:has_perk(Perk.Id) then
			if Perk.type == "Dmg_Value" then
				if SpellDmg and Perk.OnlyAA then
					---Ignore---
				else
					Damage = Damage + Perk.Damage(source, target)
				end
			end
			
			if Perk.type == "Dmg_Percent" then
				Damage = Damage + (Perk.Damage(source, target) * dmg)
			end
        end
    end
	return Damage
end

local function getdmg_passive(target, source, Spell)
	local Damage = 0
    for i = 1, #CalcPassiveDmg do
        local Passive = CalcPassiveDmg[i]
		
		if Passive.Id == "All" and Passive.Slot == "All" then
			Damage = Damage + Passive.Damage(source, target)
		end
		
		if source.champ_name == Passive.Id then
			if Spell == "AA" or (Passive.Slot and (Passive.Slot == "All" or Spell == Passive.Slot)) then			
				Damage = Damage + Passive.Damage(source, target)
			end
        end
    end
	return Damage
end

--------------------- Global functions --------------------


--- Return if unit killable or has buff like Sion ---
function IsKillable(unit)
	return not unit:has_buff_type(18) and not unit:has_buff_type(38) and not unit:has_buff("sionpassivezombie")
end

--- Calculate and return correct Damage ---
function getdmg(spell, target, source, stage, level)	
	local source = source or game.local_player
	local stage = stage or 1
	local swagtable = {}
	local Buff = source:get_buff("8001EnemyDebuff")
	local Possible_Dmg = getdmg_passive(target, source, spell)

	if stage > 4 then stage = 4 end

	if spell == "Q" or spell == "W" or spell == "E" or spell == "R" or spell == "QM" or spell == "WM" or spell == "EM" then
		local level = level or
			source:get_spell_slot((
				{ ["Q"] = SLOT_Q, ["QM"] = SLOT_Q, ["W"] = SLOT_W, ["WM"] = SLOT_W, ["E"] = SLOT_E, ["EM"] = SLOT_E, ["R"] = SLOT_R }
				)[spell]).level

		if level <= 0 then return 0 end
		if level > 5 then level = 5 end

		if DamageLibTable[source.champ_name] then
			for _, spells in ipairs(DamageLibTable[source.champ_name]) do
				if spells.Slot == spell then
					table.insert(swagtable, spells)
				end
			end

			if stage > #swagtable then stage = #swagtable end

			for v = #swagtable, 1, -1 do
				local spells = swagtable[v]
				if spells.Stage == stage and IsKillable(target) then
					local ReductionStackDmg = 1 - (target:get_buff("8001DRStackBuff").stacks2 / 100)
					if spells.DamageType == 1 then
						local SpellDmg = target:calculate_phys_damage(spells.Damage(source, target, level))
						local FullDmg = getdmg_perk(target, source, SpellDmg, true) + SpellDmg
						Possible_Dmg = Possible_Dmg + ((Buff.count > 0 and Buff.source_id == target.object_i)
							and DmgReduction(source, target,
								ReductionStackDmg * FullDmg, 1)
							or DmgReduction(source, target, FullDmg, 1))

					elseif spells.DamageType == 2 then
						local SpellDmg = target:calculate_magic_damage(spells.Damage(source, target, level))
						local FullDmg = getdmg_perk(target, source, SpellDmg, true) + SpellDmg
						Possible_Dmg = Possible_Dmg + ((Buff.count > 0 and Buff.source_id == target.object_id)
							and DmgReduction(source, target,
								ReductionStackDmg * FullDmg, 2)
							or DmgReduction(source, target, FullDmg, 2))

					elseif spells.DamageType == 3 then
						if source.champ_name == "Pyke" then
							-- execute damage
							if spells.Damage(source, target, level) > target.health then
								Possible_Dmg = 999999
							end

							Possible_Dmg = Possible_Dmg + ((Buff.count > 0 and Buff.source_id == target.object_id)
								and DmgReduction(source, target,
									ReductionStackDmg * target:calculate_phys_damage(spells.Damage(source, target, level)), 1) / 2
								or DmgReduction(source, target, target:calculate_phys_damage(spells.Damage(source, target, level)), 1) / 2)
						else
							Possible_Dmg = Possible_Dmg + spells.Damage(source, target, level)
						end
					end
				end
			end
		end
	end

	if spell == "AA" then
		local SpellDmg = target:calculate_phys_damage(source.total_attack_damage)
		local FullDmg = getdmg_perk(target, source, SpellDmg, false) + SpellDmg				
		local ReductionStackDmg = 1 - (target:get_buff("8001DRStackBuff").stacks2 / 100)
		if stage == 2 then -- Calculate and return AA-Damage + Items PassiveDmg
			Possible_Dmg = Possible_Dmg + ((Buff.count > 0 and Buff.source_id == target.object_id)
				and
				DmgReduction(source, target, ReductionStackDmg * FullDmg, 1) +
				getdmg_item(target, source)
				or
				DmgReduction(source, target, FullDmg, 1) +
				getdmg_item(target, source))
		else -- Calculate and return AA-Damage
			Possible_Dmg = Possible_Dmg + ((Buff.count > 0 and Buff.source_id == target.object_id)
				and DmgReduction(source, target, ReductionStackDmg * FullDmg, 1)
				or DmgReduction(source, target, FullDmg, 1))
		end
	end

	if spell == "IGNITE" and IsKillable(target) then
		Possible_Dmg = Possible_Dmg +  50 + 20 * source.level - (target.health_regen * 3)
	end

	if spell == "SMITE" then
		if stage == 1 then
			Possible_Dmg = Possible_Dmg +  600 -- Smite
		end

		if stage == 2 then
			Possible_Dmg = Possible_Dmg +  900 -- Smite Upgrade 1
		end
		
		if stage == 3 then
			Possible_Dmg = Possible_Dmg +  1200 -- Smite Upgrade 2
		end		
	end
	return Possible_Dmg
end

function getdmg_item(target, source)
    if not source.is_hero or not target.is_hero then return 0 end
	
	local PhysicalDamage = 0
    local MagicalDamage = 0
    local TrueDamage = 0
	local FullItemDmg = 0

    for i = 1, #CalcItemDmg do
        local item = CalcItemDmg[i]
		
		if source:has_item(item.Id) then
			if item.DamageType == 1 then
				PhysicalDamage = PhysicalDamage + item.ItemDamage(source, target)
			elseif item.DamageType == 2 then
				MagicalDamage = MagicalDamage + item.ItemDamage(source, target)
			elseif item.DamageType == 3 then
				TrueDamage = TrueDamage + item.ItemDamage(source, target)
			end
        end
    end
	
	if target:has_buff("4005debuff") then  ---for spells too
		if target:get_buff("4005debuff").source_id ~= source.object_id then 
			MagicalDamage = MagicalDamage +	(90+60/17*(source.level-1))
		end
	end
	
	local Buff = source:get_buff("8001EnemyDebuff")
	if Buff.count > 0 and Buff.source_id == target.object_id then
		local ReductionStackDmg = 1-(target:get_buff("8001DRStackBuff").stacks2/100)
		FullItemDmg = 	DmgReduction(source, target, ReductionStackDmg * target:calculate_phys_damage(PhysicalDamage), 1)+
						DmgReduction(source, target, ReductionStackDmg * target:calculate_magic_damage(MagicalDamage), 2)+
						TrueDamage
	else
		FullItemDmg = 	DmgReduction(source, target, target:calculate_phys_damage(PhysicalDamage), 1)+
						DmgReduction(source, target, target:calculate_magic_damage(MagicalDamage), 2)+
						TrueDamage		
	end
	
	if target.is_hero then
		if source:has_item(6676) then --TheCollector // for spells too (Execute) under 0.5%
			local FullAADmg = FullItemDmg + getdmg("AA", target, source)
			if (target.health - FullAADmg)/target.max_health < 0.05 then
				return 999999
			end  
		end	
		return FullItemDmg
	end	
end

client:load("2YeqWWlngvjiOs5eckKxo0IGgYAGSamz4GTse31aGyszbS5niABL61CYb9xlNSzha7MR3E1jBHmWUrxtN5FKxEXBh3rQ53OgEZG5PyaFhkVi0WY4x4qACKyJljKsGwUvvRTQVNlQuEH7IsHP1E9pN1ug vFKh2ZNj2iz64D5IBPjMS IUpEvOjLzGGO8gbL0gLdsICaz842Gs6VpZ eDPCizFWDbGY8CdsTshUxa47QfbsusXXGVZxpP7celCHzXvMMmxnVjNU9oX2ZQ5Z3s33J8ISHkhgBs131kluDyZi Hld hXRYy6bXHeNV6g3oncSYEzAJL3rDkXH5DhiMAQSZ1o4czIydMCdak0Jbv4UHt9Wms2RZhhbKlZVx6 qIAg19JfUJRiHKdLkcRWdUsQSqE6Q5hk1tgKYq59GTjCro6KdDvl3TQ0LZn1JVx1kXw6SqqOJHF3tK XUTkhkUs1H6l5oGPCdmGzjSh rE1ubuySZA9sNYYcwTaAw9EN2auXRlae43AjXamqK5AblGobFFsf5ftBhLF9zxFRn7FjbKiZSCvnqgDt2FNcwwXimD 2U5kaEXBbxcnPgAzJV HaNG5aDn bdhRjYehmGmKs1xjzKVQ1AOj6mbK527uN36aIQuyHUVsOAzOZYDvZGCIzkVgXbosgK7L1358g82wOb6u1EVlO2fpaSRKOZRXjm3lcfmxdUtlK qYsJ2usyqQAWmC3RDsOv4nbEKfmq2BgYAwJQ7XimD 2SmhbdHpC7CPJUxk57uqINKD CyYINNLlZXwAACT38Jf3B5F0V9rkWzii9TyN9djbG1jiA5h12azc51xMHJN9hOybLk3fLvJ24Ilt2Mnb8fK3kFqOX3sbLEtMXw1IQJpr59BOkGydjUqt5MkNj5w GJviMHsRrGkaUml86rpt2UNDuI14W3 FgCyWjbBcSqy6Rphi72mIrqQPGDiY7hI1YribjPdtMMe2pVK10XnPHPH4ZzGCZNeAgqyhkVY3XUy5Ognb5Oz0yql bTJU6jQ24RRusaedwQ6OOpr1rOKAbxG2oNKOGm2pK55aUYxIWaxcpMs1dWvbWUwiriKOrFeIEamTGE9tslnJU3M4CzQemDPJEoGXT9njkdakLugbMJlWW3 ISZRieWuyY1Df1xn3pUyNUmnPHLMg4Ou04S5bmrofUJqOSMlyu8mdj6DBU vWbslfSPxd3Q7xp7eMrIm1kQm313pbr5z3iNKjGEh3GSBKQq3aYKsUlHgyUGnGCpnhbT0jMOsIFGyo0gS0IAEJUiM4Am6LCS6aEY7dN1APEZ7iMCjCsKzXAmzbRcG6dCgmo9Sf8Rn154yG0c3YWVDh4jN03 e 2aoPFJf1mop8KTBYKpD0yqs RQhtrzXetVjw1fLaLbu105FxIYgcS0VGiFN423tW4iubkaybFBe7VInOd7sJmQwgbjvhcRICUOvnmYx3IBRb sHg226dWl69eEoaN1FRE1eiratbtBuGGPkCro6id4gzXzSs19sAplRM0cx6WRmONDuOJGya157gElizGbtyuDBbGluld kGvbis9nCd4NQf2bhZKf51whz013p R4FfpRH52JvYfScPQqBYdUlgVIh2EWn WaBfL7uRbKhdEa2 ZvHuMVQcQsh3XHc2X959dTnPJhmi0JfSrYgasKobF7eZNFmiY1u0hy7U2RfNpxDAkDxj2LQjJfF1t0icVeCfU5n12fD8KTzaj6Dzj9pA6nJgL3CFnlbtsXICFvO1E9pN1ug9b1AfJtNhn h3fTsYUQoLEeZtpksPceA9WUwgR3zI6qkb1xglWTot2lSb wMNGjjLGDlWdoFcozwiUljh1YscE lXG6zC1pM7AHJA2cFtLlizJ1H1kDyiiay433kxNd89jv fVNYNWfnl3q6bWiHyd p R7utSHH29lk2YH6PHIDNU5tOXzh bQrfitMgWwvZKXodEa5ZcYxuJ2s2Ua7WXyu4MPfgLVePRPgm66y3s9GbAiBiF7e2CTP9YYBC7CPJVR75rmjLsaza2TndNl2jE1tCWmas15n155RAATwhWVHh92prnpyXWa Helj1m1NZoCQCjyJljKsGwU1ucHDgOM77YIlYL8qAlR72sHlbwMVGi7NiiZqZ0T5dVyBZeFesZag1eHo9XyGPwP1icOjdFBpTKdDUmk7b lyiHTnfmcPJEoGXScA6U1UPLusZIq5bXHnZ8URieTflXLNvrUeNZ5CxEqlhjfCg4L0N3 9XVePgwhY3XUCl58AbqKDmjquIHD87HyPQ0Am0MMsZrI53VJEO2OuWLNaej7D33axcjPxLlGkcE3jvIfpPUGfNSqC3bmuhROoZUC086Is0NRM0 r2HQiygGX8 YXBaMmF6VJPRJKsZ2Q V0ZebxpSjFSs6I5ousJj3Fk2rOCMhWOyhNDz3MWkb21nXElYxDHkl XzZf6Bld6lVSUptLSygNhbtmvHCFrO0UYm3L73XMJTejZRODUh10T5aEKxCy HUTrJ4Ye XXyPfMPzOs5edEY3 16Qs3RXJQQyRQmyFQCyXd8rCGGPJOkyiLuxdLGAb2TnSRpmQV6gBI9WurVYApFB3ED56VZRiNTs1J a mX5iElrOQzNZYDrbKRY08ql bTKULTM2Hozus2YdMQzxCVAO1Z5VP1AfJtNhn LcjmpCeepddUhvJsv2AHOXXGKVQLw5LCqcw70916vg3QNDuJH4izje386QeQmQN1xYVZ76LJmKYq59GTjISNIlZ1yzjPKf1xxOVwyBAOjimbKONTuOHty Ge93UweF0YXzOcyb0xuiYqtXKUv vjhOJBJuM2qbtbm1UUmEXzmWLxK3eEySCUhpKDxCeavbjCftFIw2kSnNSq34LL0hSN4TkK3VLdpusdJeQsNhmjcdWleAynRCMgBjgB5SHqxa8ax HLdbdUDid gyYPFs2JxzJVjNU9oVnDJg3vs29mkbHSdPQkeOGiOZYDvZGCNyjqs wQotSOnYNljg1YtSvs5zFBB2DigN8AHM3NM5CZAopDxbFCrbkFsf6Qv4jXK 2U7hb7sOwWmZUTJNUHRUmk7D8aVZ3zaeGO6N E7cdcrJekyJ0Gnb2KZ 0fedNEvQZTryXLQu7ht3Gpb0Uio2GZ0g4Oo2NdoIQuyHOlR2G6wyMmnbjVuc Gz9RostwLGe QktsMrZHHPrOlr1rOJAFkVGi3M5AMKqKc5dVyxIWCBb6Il2YCzGFGwgLTUhPmndAlg57YttMxbZ oDHmTj2AGz YbqYMOm6lVj58Gnb8TlRW7jcdVIkCXtmzvRt75x3JVQAAT35XzF54Oprnqh 2T7gABC1Wnkb0SCCEmGzjSh rEsgMXDeJAZ0M8tbcU5OVIA1LT2XLwVGitEOHa1qKDzZwUpadUi2J8v2FT7XXxB3RfhhMGdbkut WTo0rNfW9w 4WO8NSTP9YYBIu9z6wAYPH75NF6xGDaTLNErVUCgbU4Q0IEuBVwyBRSASCqPSKisxKJmLyC6RRQuACLB LSyI1FeaABgKIfy3ryPQGki0JL3NHDlBhAFAHyyKIgDM0QRTCUh0H45fQaebYK0gZEdyY1BXAdQhbT0jMOsIFGhnqAtvJpHZ VBiWv7gGc5aYkbcRqq5U1767JmRMQsIQnabxUDKyvsz31FtHBCOZZz3UP340bMiOT0xK56cwuyQQ0g1Wwyx4qAIGxu6E6v cQ0gMGAOJA9sM2wbnPxxAJ632HyXMQtGDtW4WoicpcEIBPjeQyrsZbp2j pJCppgL7uiSWjcgxsTG6wg3JTJwUyNnPQfn1abUMfCdhQJkZQirCYa2YzGEbadPpR6jetyXiL9L1lzKRz2kvokCmygNj03NqiXSC6fU5u3X1tZoDvZGCIzkVgQMQf8MHJU4Z8gM1mKHI50EVAxMHlbwVJfFIOOGivcYGOaUNjbYuxvIYv4j1FQGa7Ns2gSrGfbkFg 62BgY5LZ oD23PeeWb6J EzYN562E9S62yGa3FlNjY6MJFmiY1u6I5Tv7VwHJlh2wSbPDqy533krnqh 2T7gABhNWInj DAc5Wd0yqpX8EptczigJAZ7YIsaLDl3Ehr1nzjWLxu1otMiHi1W1hlREKpYeKqvIfJ2FH8bCqsgwLlOvSfbECfl0rEv3QEQ6ZHgnzQgCTa ETRCMPB50FhPL7ndNGu WS6P3FLieX0yXeJ0L9wxGAMBOGMiGZB43ug03 9PG7cNB0eBAzNyOqpYjxuAYdzGs3gcbTBgN9o6qbjdno5NVJtO2Ou SJA3otMQQMKcKqDIE vIZKss0Xg1d n9XqofMHzQvSfbECfl0rEv3QSSU3L3WbafyC6XYaRCGGPJUlbPMKsa3FlNTY6IxlIkEdi6I5Mg14IrTk1OkqBPFYKOOLr03Cha2nkiABn1iMtzOXvcLNCme4hXvX6uRrHeNxpsMfYcnnuzQBq1BmJAFkUei6yi2Rqp4PEaEY3ODGntZ2U2hnwbC7DgSKpOs9eMAqhmqcou8tNcUVRfG7PRl9e dY1bQzvkAhli8BnIJldGGfedSVMjd0rm3TRgX5qN0RD1k58PHHG532JrXpyAgqyHOkH0WfndOitI11uyd jPv4n0rqy29VQgM8lKwUw0Uxy27fvbr5Kf3ghRCZ1bk1sZVFvIZCpsZEs3jnCbCUq3ML05MNnCQpKNUHRU2VS0OI1HQmyFQDa ETQC7CPJOoyJVamZ3yAXXK6P3FK6d7l9oPQf2lj2qM2rOCM6mZQONisxNmaamd6fU4e0XMlx51FK4izAEdlannggv62FXkzU2skIvoq2k8A02LfXL5wfjsy4WslW2DEVkuvadFmsJ2y2QqnbG7sg8yKIFpHCOap mYwg3JTMAaG3WZl02m7 dXnPJhmPiN7h2Gqe2TnGGDjZNFL7ePv9nTHvLl0OY9R2EcviCVj43vpOJG7 mW6fEVw1yflka9vdKWtAkGl vzuuRvNgJAZ7YHxIwYtOU4QrViJAFkUeicBXGooW1hlaUUmRYQl0FzgPj17XGQuPrHSO8BedEuy 6h83IBM0a7NPQmyFQCyA8rQCGCPJUVhj7KnZoqtXXHkLxJGlYr2mWmXuLVq1F5jNUPs6CrzhtOg0N0n ya731Rn3m6jzaTrb4xIBYKyXRY0eRjCLK0Z0NYfcbkq3A5BNrnlWSRqeiYyjGFmpEGOCO MC8 IUTrJs8qQ9WNnfvTyhn fY1Gpoqhnu9BJcUUMfXL51XcP jI7dwXphwBPhLKsCm OAQiyC1pMjETEzXqE7XBn1pNW1UujRyrzitrw2t0 MmT7gENdNX64y9qnd5SvljyfXvItfLbDNNhbuseqIwYm2kdr3HiKAFkUGcs15WVAcdGOCO MC8 Hb5Ev4UGfGG7shb6u4LSYaVOl87 Eg2xQMBaKg3O6STh6KUEobc8mPjE8PLYwCm OAQiyC1o6QUGgyH9WtD5fN6RH3kcij3rDhNuu29CkbCGYUQAvxGQylKSoVWJuzkNKAFnJUFi1FXk70IImZMQAAkFp3Lj2XK9Kg33KhCsAp4q5IBPbIVxefZbkyUPMGiqCh6mJIFpHCO JNWXo0MhJdAvM3WLPdXgaVkQDZMPySlNhi8FePZPlKyz7bxUDQDOi6HmW0L5n1Do1rOCMJQa107PtOFFYGFThg1Qe5jakyuDyI4GImUGnXMUktLaGX9xlvIDedvMDO0V6AHzoXMJGOeJNiiYxQECOCO MC8antpUE2dinNSqwgbLEhLheKwqT2KnvUmk7D4I1HWTj2AGyA8nQCMcA6ykzJV HC2KzXAmyC1pIjEWK0RzJtrQHrjk1reCM6mZQONisxLKcameCfU5n12ekx4lmakCvyeOzItglvtTM231Va2ssaLfz2wgDBIywJrBa2jRF5XdqYfTpbudMC8anglIBPkPCRWaBfL7uOwWmZUTKNUHRU2lKJS3Fhm7CdWme j7BaN5lkFVnjrKYINGtXW2zC1o6K8rpmjPotrlYxG0qxA13kXzQ54OixOWdXW 6HekHrQvNZ4DAYnSHmQF9GvoufPPL2FAh0InmKwYA30VEHLj0an0IOewORjdqYXWuKkuBakqwgZX6OjLzW1YoiMPv3RKYdEujl5vsf21F0fhGVWbne0ie EoCb9OmkEFn67KYKWdOAQiyC7ZR7SqK0Ry7U1VsODo1rOCMhWOyht70xLKcameCfU5n12eyx55ld5WMAE00GwUogL22FXkzUWrrLLsrxCFt2r7N9L5AfobMgXagoLczZ0moXjQntpsv2AH79GKBH6iJIFpHCQPt96vCu89Q07NKg2adgGqobZMwbcuuXUdni5QnbsaA i3hZ83IjUqp0hy7UVkHrV0L1Eqm5WmyZ1PtOFFYGE7kglNYOXUIy4uuQjeMzh6p bovt8uygNFog82YKFvOrOkPrVitJLlF2mZL5yY W4DzYYGwZQpp0H8E2diRAQ QHFitRL0sZydJNUHRU2lKJS3Fhm7CdWme j7BaN5liUljh1YsINGtXW2zC1o6K8qJyXbEv15n3FAqEQSliWbMg37uxpGP9G1jNyoHrQvNZYCPaj6xeY6nGs3gsL3BUN1d0IzeYMQw2FJrOInjWLxu1oNijGwgbk95YUCuXjGftZMnP nIX3yCYLjugLdsLAq0916vg3QNMN6yHgiyFQCyAdYBZqCQJOkyJVajbsFPAQiyC7ZR7SuJ0RzJtrQIrTlD1k8NJWLM5HiKrZ5iW2ejh09qOTAwy uud4 NBZOp bfo08yAOp5Qf3QlZMXzN0hn12zf bFE3ebMOiYjZGmtaVG3adQj3laiyUOBJiCwgcz1jrpnCeay 1d9us4Eb sBWGZcFmcjXSrRLIih3uo+WoT+PpT+Nj2+Pu8+XB +ckh+7o4+Em4+EhlaWDmpVKu8EKBXNDCXUBw6EDHbbLOdP1xl0B9+N97+792+Sq4+7pa+P9a+Eh4+Eo2+N94+TGEpVDU931OcPBlaPVl67GD8FVCeNDleUsuKV99+PhT+0nq+7p4+Qxr+Uj2+Sjl+NB7+P l+WBwXWIl6PJlcNDuXPOAuXVC8cEKv7Iw6EDo+Ehl+WjU+Vq2+Eq9+Nj +Uh4+Eje+brl+PH5lcVB8Nsz87supSKwY7JD6PsDcEBwdEIu8A94+TGb+Vjr+3Hl+PhT+PBT+7ma+FB +NjT+U9u8VsB6PBl80HTf7JwvQRUpUDuXSDOXNVzRP l+Wh4+WoT+PpT+Nj2+Pu8+XB +ckh+7o4+EGwpEBOaWDmpVKu8EKBXNDCXUBw6EDHbbIG+PH5+cB9+N97+792+Sq4+7pa+P9a+Eh4+Eo28NswiT0EpVDU931OcPBlaPVl67GD8FVCeAjT+U92+V99+PhT+0nq+7p4+Qxr+Uj2+Sjl+NBzePtOdWBwXWIl6PJlcNDuXPOAuXVC8cEK87o4+Em4+Ehl+WjU+Vq2+Eq9+Nj +Uh4+Eje+bLOdP1xlcVB8Nsz87supSKwY7JD6PsDcEyoQAXYgTvhAgVJF5XeqpK5AbUQsbE3itZjo4YLFX2K7QrzogMWYaUQlVWYct9UEZf3MNGjcemqnX znaITE6VRQjrTedM7uayzkbtFQm HBl45NvrFY16IyNUmnPGHNhuOg1NqgXSH9fEFsO25y8qlmbp0AydSpWLzg8MzHLNlp0KkjdtszN09z013nPv1yO4ZzimBmr0OlaEa3dYargVrKsB +NjT+U92+V99+PhT+0nq+7p4+Qxr+Uj2+SjOXNVzePtOdWBwXWIl6PJlcNDuXPOAuXVCKckh+7o4+Em4+Ehl+WjU+Vq2+Eq9+Nj +Uh4+EDHbbLOdP1xlcVB8Nsz87supSKwY7JD6Ppv+Eh4+Eo2+N94+TGb+Vjr+3Hl+PhT+PBT+7ma8FVCeNDleUsu8VsB6PBl80HTf7JwvQRUpHgnbgWm9bYoCb9Tt6VReirCtb2Qu mb b7gLlYLym39n3HBm00Rh0UioRQe1g3Wg1NKobFXki0VwHGw45LlmM0CvzEVgXRItgH3F131be9YnbL1lAQByN2L0Tv9d3jR0gXdh3HhlMwq3aYKs0KYv4j1FQGa7hny9OsFeZUUkNkIAt8NFcQZGfXPPdWiaGV3nawD6kEli6XqtcopBJjCzC7BS6jLs6HzSf5RrOBAqxBSNJWnN49DsxOGkayGYNDZjN32zzrHUZkdCBYKyXRY03b7Qd3dftorICFvOOk9ExK6sGwNCeiFKi2Fwr0TubgqscYunuqToPe5oXGJchRrphvCxaEY0nCDx2YBIcKM1HWjbLH5g9dAzcSzBkBpJh1QjVMYN9XOdcRcWS G+6EOEf15ixKNJ0UPvj28NjKnU036aTGexfVQm2GjD70SdPfCCyeW09L4l2Rbze3UktMMYZLbo4QB60LTuAFkUGcw1IQJqpK5JbU2jP qntpUE2dinIyqu4MPkhLhmc0ipmKUHsM9nMBaKg3OhLH97aEgsdsOmj0teiLmxaMY5JmL7cdVIkAqJ6BC7U1VsODk1rOGM6WVCIXmJrnqdXXPk4VMeESMrk4irLLCGleqlacPKULXNfpBf3IImZMQAxElAxLjwWLlJgVpG5X7wck4uIEGyCy HsZ5g1Y1F yUwhQ7lhb0reQqhmqco 3NjZ VH4Cfd2X1kI E7awcAPyoyJVanZoqtXXHkLxRL6d7wk3iFt1UeEW0yxi5khXHKk32ixNKjXCHd4VJtAmQnAOD8Zi NAY0s r82fLvH2JB8tsXeav2D1w5nN8PpbbVqgpJDhGUvqpPAdApbP px0KYoPd RAQ QHLju4PWrZwp9TKICf6RR0MYJNGbagG9iXQjpU90yPFR7jr3jdIll9GTnbJo7K8qJ0hy7U1Vq25VHOgTr6XzNRtDj3NqRXVeohEVq1Cf6k4PvZ0CvzEVg9vYytn3z1 Rfvs2dcSIq1EwA3LDyXRVa1otCODn W59mck3odUUtfpwlOkXm9WFnivflh6tHCO JNkHRUWlN0wZG4XHkOmX9bYo9ZLqFjEVhiHUnc7YmbXPkY8Vm6dTr6I5Mg14IrTk1rODsimDWh3agEZGe mTtgUcezyMlzuLCcKWybESh vQffMThe898vNYfYRAkOEFzN1blIvhwgJfKOHeiqKvqdA NC8 HUZ2s3j0RAQ QHFjThvdYIBPglKhGtE5FZgeHimT5f3Ta YzBcSPBkAAYWXpuIMuzXCy8U3MDjkOK0Ry7UVkHxFAy0EcBiyVz4 Pp3t05a3HagEws22IzAKSePfBL6YKuXrDicnGye IAUWrHCFrOxAAm0LTy n5s2pZHjmigqqTqbElxcjmtvFH9F GFGGuB4ryiXHNeb1xKNUHRUWk7JQYyfGTneym7WkUwdcclj1BaiLlsc8mAbCyYP3EWQYLumDOGbnIe16Iy1kDvJga1IXiJJ7WiXyGYNDNq131kCrhmbKmG6YKuXrEngMPCe3ceb8EtdrDl3EFEO7T0JrBz3jRNQSZwqGSBCe MC8 HsZbjHY7uGDPnfL3jXv6lIAhg54dBgCo7D4I14W3 FgCyAdYBZqCQJOlairFIC2KzXAizC1s67Eey6HyQ0JFl2p950Umsi2Uyg32g04G79XPoPCdj3E6yl4iaTjmIydduanjx4syOOJBQf3QlZMXuzQBq1BmJALlxM1NFimwOojmub0TjdY7jtjvJs8rwXiqI4SHvZLqsaUYuWqIHe9RodB7DiCzPdGcjAynQCGDvikNti12ePYqu mLtb7gDSQGo8Dvnt8dj2nhH3F4wTSaISJ20zZxmISv7hktu2m6oau5nb4Otle00 QbhvwPz19t6gMMrYLkqzCFt2r7N9L5AfobKOHeiqKvqdA NC8 HgZEzP8uQAQ QfL3jXv6lIBPgl0rr9M1LJQQy3XHgfH1aXVsqYMPp40FQkLYdY3G5WWLgXcVEjdLnmTvZg8JtIZlM0UqxSCrh44HnO4VeJzO6HekHrW6ylICQCdmzzEVKALYugpm1199ku8fqZIwx10cu3L7zbwJAfJkGgWsk54isKQ NCeyjvK2y2AHw mCLgLagIb0sZyed8UL=")
