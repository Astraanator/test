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

getdmg("spell", target, source, stage)

spell == "Q" or "W" or "E" or "R" or "QM" or "WM" or "EM"   
		 "QM"/"WM"/"EM" == like Nidalee, Grar or Elise different Forms
		 "AA" <-- calculate Autoattack damage
		 "IGNITE" <-- calculate Ignite damage
		 "SMITE" <-- calculate Smite damage ///// stage 1 = "SummonerSmite" ///// stage 2 = "S5_SummonerSmiteDuel" or spellName == "S5_SummonerSmitePlayerGanker" ////
		 
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

>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<

--- Return if unit not killable or has buff like Sion ---

--Example add to your code /// IsKillable(unit) 

local function CastQ()
	for i, target in ipairs(GetEnemyHeroes()) do     	
		if target.object_id ~= 0 then				
			if IsKillable(target) then  <--- return true if killable
				>>>>CastQ	
			end		
		end
	end
end	

>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<


--/////////////////////////////////////////////////////////////////////////////////////
	------ITEM PassiveProc.Damage API------
--/////////////////////////////////////////////////////////////////////////////////////

---Return only PassiveDmg from Items---
getdmg_item(target, source)

---Return PassiveItemDmg + AADmg---
getdmg("AA", target, source, stage)
  stage(1) = returns only AADmg
  stage(2) = returns AADmg + ItemDmg



>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>> INCOMING DAMAGE API <<<<<<<<<<<<<<<<<<
>>>>>>>>>>>> BY BEN AND PUSSYKATE <<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<

-> GetIncomingDmg(game_object, hittime)
- game_object[myHero or Ally]
- hittime[Time-Before-Hit]  > Time from when the Spell Dmg should be calculated (default value = 0.1) <

Return all incoming damages[number]  (Minion-Dmgs, Tower-Dmgs, Champion-Dmgs) 

-----------Example-------------
local IncDmg = GetIncomingDmg(myHero, 0.2)
if IncDmg > 0 then
	local HpAfterDmg = myHero.health - IncDmg
	if IncDmg >= myHero.health and HpAfterDmg > 0 then
		console:log(tostring("Incoming-Dmg: "..IncDmg))
	end
end


>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<

>>>>>>>>>>>>>>> Get CCSpells API <<<<<<<<<<<<<<<<<<<<

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
local Version = 52
do  
    local function AutoUpdate()
		
		local file_name = "PKDamageLib.lua"
		local url = "http://raw.githubusercontent.com/Astraanator/test/main/Champions/PKDamageLib.lua"        
        local web_version = http:get("http://raw.githubusercontent.com/Astraanator/test/main/Champions/PKDamageLib.version")
		if tonumber(web_version) ~= Version then
			http:download_file(url, file_name)
        end
		
		if not file_manager:directory_exists("PussyFolder") then
			file_manager:create_directory("PussyFolder")
		end

		if file_manager:directory_exists("PussyFolder") then
			if not file_manager:file_exists("PussyFolder/PkMenu.png") then
				local file_name = "PussyFolder/PkMenu.png"
				local url = "https://raw.githubusercontent.com/Astraanator/test/main/Images/PkMenu.png"   	
				http:download_file(url, file_name)
			end	
		end			  
    end

    local function MustHave()	
		
		if not file_manager:file_exists("EvadeCore.lua") then
			local file_name = "EvadeCore.lua"
			local url = "https://raw.githubusercontent.com/Ark223/EvadeCore/main/EvadeCore.lua"   	
			http:download_file(url, file_name)	
		end

		if not file_manager:file_exists("Evade.lua") then
			local file_name = "Evade.lua"
			local url = "https://raw.githubusercontent.com/Ark223/Bruhwalker/main/Evade.lua"   	
			http:download_file(url, file_name)	
		end		
		
		if not file_manager:file_exists("Prediction.lib") then
		   local file_name = "Prediction.lib"
		   local url = "https://raw.githubusercontent.com/Ark223/Bruhwalker/main/Prediction.lib"
		   http:download_file(url, file_name)
		end			
	end	
	AutoUpdate()
	MustHave()	
end

local DmgReductTable = {
  ["Braum"] = {buff = "braumshieldbuff", amount = function(target) return 1 - ({0.3, 0.325, 0.35, 0.375, 0.4})[target:get_spell_slot(SLOT_E).level] end}, 			--E
  ["Alistar"] = {buff = "FerociousHowl", amount = function(target) return 1 - ({0.55, 0.66, 0.75})[target:get_spell_slot(SLOT_R).level] end}, 						--R
  ["Galio"] = {buff = "galiowbuff", amount = function(target) return 1 - ({0.2, 0.25, 0.3, 0.35, 0.4})[target:get_spell_slot(SLOT_W).level] end, damageType = 2}, 	--W
  ["Galio"] = {buff = "galiowbuff", amount = function(target) return 1 - ({0.1, 0.125, 0.15, 0.175, 0.2})[target:get_spell_slot(SLOT_W).level] end, damageType = 1},--W
  ["Garen"] = {buff = "GarenW", amount = function(target) return 0.7 end},																							--W
  ["Gragas"] = {buff = "gragaswself", amount = function(target) return 1 - ({0.1, 0.12, 0.14, 0.16, 0.18})[target:get_spell_slot(SLOT_W).level] end},				--W
  ["Irelia"] = {buff = "ireliawdefense", amount = function(target) return 1 - ((40+30/17*(target.level-1))/100) end, damageType = 1},								--W
  ["Irelia"] = {buff = "ireliawdefense", amount = function(target) return 1 - ((20+15/17*(target.level-1))/100) end, damageType = 2},  								--W
  ["Malzahar"] = {buff = "malzaharpassiveshield", amount = function(target) return 0.1 end},																		--Passive
  ["MasterYi"] = {buff = "Meditate", amount = function(target) return 1 - ({0.6, 0.625, 0.65, 0.675, 0.7})[target:get_spell_slot(SLOT_W).level] end},				--W
  ["Warwick"] = {buff = "WarwickE", amount = function(target) return 1 - ({0.35, 0.40, 0.45, 0.50, 0.55})[target:get_spell_slot(SLOT_E).level] end},  				--E
}

local function GetDistanceSqr(p1, p2)
	return (p1.x - p2.x) *  (p1.x - p2.x) + ((p1.z or p1.y) - (p2.z or p2.y)) * ((p1.z or p1.y) - (p2.z or p2.y)) 
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

local function DmgReduction(source, target, amount, DamageType)
	local CalcDmg = amount
	
	if source.is_hero then
		if source:has_buff("summonerexhaustdebuff") then
			CalcDmg = CalcDmg * 0.6
		end
	end

	if target.is_hero then

		if DmgReductTable[target.champ_name] then
			if target:has_buff(DmgReductTable[target.champ_name].buff) and (not DmgReductTable[target.champ_name].damagetype or DmgReductTable[target.champ_name].damagetype == DamageType) then
				CalcDmg = CalcDmg * DmgReductTable[target.champ_name].amount(target)
			end
		end

		if target.champ_name == "Amumu" and target:has_buff("Tantrum") and DamageType == 1 then --E
			CalcDmg = CalcDmg - (({2, 4, 6, 8, 10})[target:get_spell_slot(SLOT_E).level] + 0.03 * target.bonus_armor + 0.03 * target.bonus_mr)
		end
		
		if target.champ_name == "Leona" and target:has_buff("LeonaSolarBarrier") then --W
			if CalcDmg / 2 < (({8, 12, 16, 20, 24})[target:get_spell_slot(SLOT_W).level]) then
				CalcDmg = CalcDmg / 2
			else
				CalcDmg = CalcDmg - (({8, 12, 16, 20, 24})[target:get_spell_slot(SLOT_W).level])
			end			
		end	

		if target.champ_name == "Fizz" then --Passive
			if CalcDmg / 2 < (4+(0.01*target.ability_power)) then
				CalcDmg = CalcDmg / 2
			else
				CalcDmg = CalcDmg - (4+(0.01*target.ability_power))
			end
		end		

		if target.champ_name == "Kassadin" and DamageType == 2 then --Passive
			CalcDmg = CalcDmg * 0.9
		end
		
		if target:has_buff("4644shield") then  --Item /  Crown of the Shattered Queen
			CalcDmg = CalcDmg * 0.25
		end

		if target:has_buff("4401maxstacked") and DamageType == 2 then  --Item /  Force of Nature
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
	return {type = 0, name = "", startTime = 0, expireTime = 0, duration = 0, stacks = 0, count = 0}
end

local function HasPoison(unit)
	if unit:has_buff_type(24) then
		return true
	end
	return false
end

local function GetBaseHealth(unit)
    if unit.champ_name == "Chogath" then
		local BonusHealth = 0
		local ChampLvL = unit.level
		local UltLvL = unit:get_spell_slot(SLOT_R).level		
		if UltLvL >= 1 then
			local BaseHealth = unit.base_health
			local FeastBonus = ({80, 120, 160})[UltLvL] * unit:get_buff("Feast").stacks2
			BonusHealth = (math.ceil(unit.max_health) - BaseHealth - FeastBonus)
		end     		
		return BonusHealth
		
    elseif unit.champ_name == "Volibear" then
        return unit.base_health		
    end	
end


-->>>>>>>>>>>>>>>>>>>> GameVersion 12.9 <<<<<<<<<<<<<<<<<<<<<<<<<--

local DamageLibTable = {
  ["Aatrox"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({10, 30, 50, 70, 90})[level] + ({0.6, 0.65, 0.7, 0.75, 0.8})[level] * source.total_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 40, 50, 60, 70})[level] + 0.4 * source.total_attack_damage end},
  },

  ["Ahri"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + 0.4 * source.ability_power end},
    {Slot = "Q", Stage = 2, DamageType = 3, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + 0.4 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level] + 0.3 * source.ability_power end},
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({15, 22.5, 30, 37.5, 45})[level] + 0.09 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 90, 120})[level] + 0.35 * source.ability_power end},
  },

  ["Akali"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({30, 55, 80, 105, 130})[level] + 0.6 * source.ability_power + 0.65 * source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({100, 187, 275, 362, 450})[level] + 1.2 * source.ability_power + 0.85 * source.total_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 220, 360})[level] + 0.3 * source.ability_power + 0.5 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({60, 130, 200})[level] + 0.3 * source.ability_power end},	
  },
  
  ["Akshan"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({5, 25, 45, 65, 85})[level] + 0.8 * source.total_attack_damage end}, -- Dmg one Pass
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 45, 60, 75, 90})[level] + 0.175 * source.bonus_attack_damage + 0.3 * source.bonus_attack_speed end}, -- per Shot
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 25, 30})[level] + 0.1 * source.total_attack_damage + ((3 * (1 - target.health / target.max_health)) * (({20, 25, 30})[level] + 0.1 * source.total_attack_damage)) end}, -- per Bullet	
  },  

  ["Alistar"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + 0.5 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({55, 110, 165, 220, 275})[level] + 0.7 * source.ability_power end},
	{Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + 0.4 * source.ability_power end},
  },

  ["Amumu"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 95, 120, 145, 170})[level] + 0.85 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({12, 16, 20, 24, 28})[level] + (({0.01, 0.0115, 0.013, 0.0145, 0.016})[level] + 0.05 * source.ability_power / 100) * target.max_health end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 100, 125, 150, 175})[level] + 0.5 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + 0.8 * source.ability_power end},
  },

  ["Anivia"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 70, 90, 110, 130})[level] + 0.25 * source.ability_power end},
    {Slot = "Q", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + 0.45 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return (({50, 75, 100, 125, 150})[level] + 0.6 * source.ability_power) * (target:has_buff("aniviachilled") and 2 or 1) end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({30, 45, 60})[level] + 0.125 * source.ability_power end},
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({90, 135, 180})[level] + 0.375 * source.ability_power end},
  },

  ["Annie"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 115, 150, 185, 220})[level] + 0.75 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + 0.85 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 275, 400})[level] + 0.65 * source.ability_power end},
  },
  
  ["Aphelios"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 85, 110, 135, 160})[level] + source.ability_power + 0.6 * source.bonus_attack_damage end},
    {Slot = "Q", Stage = 2, DamageType = 2, Damage = function(source, target, level) return (({10, 15, 20, 25, 30})[level] + 0.30 * source.bonus_attack_damage) * 6 end},
    {Slot = "Q", Stage = 3, DamageType = 2, Damage = function(source, target, level) return ({50, 65, 80, 95, 110})[level] + 0.7 * source.ability_power + 0.35 * source.bonus_attack_damage end},
    {Slot = "Q", Stage = 4, DamageType = 2, Damage = function(source, target, level) return ({25, 35, 45, 55, 65})[level] + 0.7 * source.ability_power + 0.8 * source.bonus_attack_damage end},
    {Slot = "Q", Stage = 5, DamageType = 2, Damage = function(source, target, level) return ({25, 40, 55, 70, 85})[level] + 0.5 * source.ability_power + 0.5 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({125, 175, 225})[level] + source.ability_power + 0.2 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({175, 275, 375})[level] + source.ability_power + 0.45 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 3, DamageType = 1, Damage = function(source, target, level) return ({125, 175, 225})[level] + source.ability_power + 0.2 * source.bonus_attack_damage + (GotSpell(source, SLOT_Q, "ApheliosInfernumQ") * (({50, 100, 150})[level] + 0.25 * source.bonus_attack_damage)) end},
  }, 

  ["Ashe"] = {
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 35, 50, 65, 80})[level] + source.total_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({200, 400, 600})[level] + source.ability_power end},
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return (({100, 200, 300})[level] + 0.5 * source.ability_power) end},
  },

  ["AurelionSol"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + 0.65 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + 0.7 * source.ability_power end},
  },
  
  ["Azir"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 90, 110, 130, 150})[level] + 0.3 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({55, 60, 75, 80, 90})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + 0.4 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({175, 325, 475})[level] + 0.6 * source.ability_power end},
  },

  ["Blitzcrank"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({90, 140, 190, 240, 290})[level] + 1.2 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return source.total_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({250, 375, 500})[level] + source.ability_power end},
  },

  ["Bard"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + 0.65 * source.ability_power end},
  },

  ["Brand"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + 0.55 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 120, 165, 210, 255})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 95, 120, 145, 170})[level] + 0.45 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({100, 200, 300})[level] + 0.25 * source.ability_power end},
  },

  ["Braum"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 125, 175, 225, 275})[level] + 0.025 * source.max_health end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 300, 450})[level] + 0.6 * source.ability_power end},
  },

  ["Caitlyn"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({50, 90, 130, 170, 210})[level] + ({1.3, 1.45, 1.6, 1.75, 1.9})[level] * source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + 0.8 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({300, 525, 750})[level] + 2 * source.bonus_attack_damage end},
  },
  
  ["Camille"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({0.2, 0.25, 0.3, 0.35, 0.4})[level] * source.total_attack_damage end},
    {Slot = "Q", Stage = 2, DamageType = 3, Damage = function(source, target, level) return ({0.2, 0.25, 0.3, 0.35, 0.4})[level] * source.total_attack_damage * 2 end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({70, 100, 130, 160, 190})[level] + 0.6 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + 0.75 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({5, 10, 15})[level] + ({0.04, 0.06, 0.08})[level] * target.health end},	
  },  

  ["Cassiopeia"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 110, 145, 180, 215})[level] + 0.9 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({20, 25, 30, 35, 40})[level] + 0.15 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return 48 + 4 * source.level + 0.1 * source.ability_power + (HasPoison(target) and ({20, 40, 60, 80, 100})[level] + 0.6 * source.ability_power or 0) end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + 0.5 * source.ability_power end},
  },

  ["Chogath"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 135, 190, 245, 300})[level] + source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 125, 175, 225, 275})[level] + 0.7 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({22, 34, 46, 58, 70})[level] + 0.3 * source.ability_power + 0.03 * target.max_health end},
    {Slot = "R", Stage = 1, DamageType = 3, Damage = function(source, target, level) return ({300, 475, 650})[level] + 0.5 * source.ability_power + 0.1 * GetBaseHealth(source) end},
  },

  ["Corki"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 120, 165, 210, 255})[level] + 0.5 * source.ability_power + 0.7 * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({120, 180, 240, 300, 360})[level] + 0.8 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({30, 45, 60, 75, 90})[level] + (1.5 * source.total_attack_damage) + 0.2 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 32, 44, 56, 68})[level] + 0.4 * source.total_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({90, 125, 160})[level] + 0.2 * source.ability_power + ({0.15, 0.45, 0.75})[level] * source.total_attack_damage end},
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({180, 250, 320})[level] + 0.4 * source.ability_power + ({0.3, 0.90, 1.5})[level] * source.total_attack_damage end},
  },

  ["Darius"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({50, 80, 110, 140, 170})[level] + (({1.0, 1.1, 1.2, 1.3, 1.4})[level] * source.total_attack_damage) end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({0.4, 0.45, 0.5, 0.55, 0.6})[level] * source.total_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 3, Damage = function(source, target, level) return ({125, 250, 375})[level] + 0.75 * source.bonus_attack_damage end},
  },

  ["Diana"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + 0.7 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({18, 30, 42, 54, 66})[level] + 0.15 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 60, 80, 100, 120})[level] + 0.4 * source.ability_power end},	
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({200, 300, 400})[level] + 0.6 * source.ability_power end}, --MainDmg
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({35, 60, 85})[level] + 0.15 * source.ability_power end},	--+Dmg 
  },

  ["DrMundo"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) if target.is_minion then return math.min(({350, 425, 500, 575, 650})[level],math.max(({80, 135, 190, 245, 300})[level], ({20, 22.5, 25, 27.5, 30})[level] / 100 * target.health)) end; return math.max(({80, 135, 190, 245, 300})[level],({20, 22.5, 25, 27.5, 30})[level] / 100 * target.health) end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({20, 27, 35, 42, 50})[level] + 0.1 * source.ability_power end}
  },

  ["Draven"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({40, 45, 50, 55, 60})[level] + (({0.7, 0.8, 0.9, 1, 1.1})[level] * source.bonus_attack_damage) end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({75, 110, 145, 180, 215})[level] + 0.5 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({175, 275, 375})[level] + ({1.1, 1.3, 1.5})[level] * source.bonus_attack_damage end},
  },

  ["Ekko"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 75, 90, 105, 120})[level] + 0.3 * source.ability_power end},
    {Slot = "Q", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level] + 0.4 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 300, 450})[level] + 1.5 * source.ability_power end}
  },

  ["Elise"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 70, 100, 130, 160})[level] + (0.04 + 0.03 / 100 * source.ability_power) * target.health end},
    {Slot = "QM", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + (0.08 + 0.03 / 100 * source.ability_power) * (target.max_health - target.health) end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 105, 150, 195, 240})[level] + 0.95 * source.ability_power end},
  },

  ["Evelynn"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({25, 30, 35, 40, 45})[level] + 0.3 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({55, 70, 85, 100, 115})[level] + (0.03 + 0.15 / 100 * source.ability_power) * target.max_health end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({125, 250, 375})[level] + 0.75 * source.ability_power end},
  },

  ["Ezreal"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 45, 70, 95, 120})[level] + 0.15 * source.ability_power + 1.3 * source.total_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 135, 190, 245, 300})[level] + (({0.7, 0.75, 0.8, 0.85, 0.9})[level] * source.ability_power) + 0.6 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 130, 180, 230, 280})[level] + 0.75 * source.ability_power + 0.5 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({350, 500, 650})[level] + 0.9 * source.ability_power + source.bonus_attack_damage end},
  },
  
  ["FiddleSticks"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({0.06, 0.07, 0.08, 0.09, 0.1})[level] + math.floor(source.ability_power/10000) * target.health end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({120, 180, 240, 300, 360})[level] + 0.7 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.5 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({625, 1125 , 1625})[level] + 2.25 * source.ability_power end},
  },  

  ["Fiora"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({70, 80, 90, 100, 110})[level] + ({0.95, 1, 1.05, 1.1, 1.15})[level] * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({110, 150, 190, 230, 270})[level] + source.ability_power end},
  },

  ["Fizz"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({10, 25, 40, 55, 70})[level] + 0.55 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 70, 90, 110, 130})[level] + 0.5 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 120, 170, 220, 270})[level] + 0.75 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + 0.8 * source.ability_power end},
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({225, 325, 425})[level] + source.ability_power end},
    {Slot = "R", Stage = 3, DamageType = 2, Damage = function(source, target, level) return ({300, 400, 500})[level] + 1.2 * source.ability_power end},
  },

  ["Galio"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.75 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({90, 130, 170, 210, 250})[level] + 0.9 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + 0.7 * source.ability_power end},
  },

  ["Gangplank"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 45, 70, 95, 120})[level] + source.total_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 70, 100})[level] + 0.1 * source.ability_power end},
  },

  ["Garen"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 60, 90, 120, 150})[level] + 0.5 * source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({4, 8, 12, 16, 20})[level] + (0.471 + 0.471 * source.level) + ({32, 34, 36, 38, 40})[level] / 100 * source.total_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 3, Damage = function(source, target, level) return ({150, 300, 450})[level] + ({25, 30, 35})[level] / 100 * (target.max_health - target.health) end},
  },

  ["Gnar"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({5, 45, 85, 125, 165})[level] + 1.15 * source.total_attack_damage end},
    {Slot = "QM", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({25, 70, 115, 160, 205})[level] + 1.4 * source.total_attack_damage end},
    {Slot = "WM", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({25, 55, 85, 115, 145})[level] + source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({50, 85, 120, 155, 190})[level] + source.max_health * 0.06 end},
    {Slot = "EM", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({80, 115, 150, 185, 220})[level] + source.max_health * 0.06 end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({200, 300, 400})[level] + source.ability_power + 0.5 * source.bonus_attack_damage end},
  },

  ["Gragas"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.7 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({20, 50, 80, 110, 140})[level] + 0.7 * source.ability_power + 0.07 * target.max_health end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({200, 300, 400})[level] + 0.8 * source.ability_power end},
  },

  ["Graves"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({45, 60, 75, 90, 105})[level] +  0.8 * source.bonus_attack_damage end},
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({85, 120, 155, 190, 225})[level] + ({0.4, 0.7, 1.0, 1.3, 1.6})[level] * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 110, 160, 210, 260})[level] + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({250, 400, 550})[level] + 1.5 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({200, 320, 440})[level] + 1.2 * source.bonus_attack_damage end},	
  },
  
  ["Gwen"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({8, 10.75, 13.5, 16.25, 19})[level] + 0.05 * source.ability_power end}, --- noraml dmg each snap
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({10, 15, 20, 25, 30})[level] + 0.8 * source.ability_power end}, -- Bonus attack dmg for next aa
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({30, 55, 80})[level] + 0.08 * source.ability_power + (((0.008 * source.ability_power / 100) + 0.01) * target.max_health) end}, --First Cast
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({90, 165, 240})[level] + 0.24 * source.ability_power + (((0.024 * source.ability_power / 100) + 0.03) * target.max_health) end}, --Second Cast
    {Slot = "R", Stage = 3, DamageType = 2, Damage = function(source, target, level) return ({150, 275, 400})[level] + 0.4 * source.ability_power + (((0.04 * source.ability_power / 100) + 0.05) * target.max_health) end},	--Third Cast
  },  

  ["Hecarim"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + 0.9 * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({20, 30, 40, 50, 60})[level] + 0.2 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 45, 60, 75, 90})[level] + 0.55 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + source.ability_power end},
  },

  ["Heimerdinger"] = {
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level] + 0.45 * source.ability_power end},
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({135, 180, 225})[source:get_spell_slot(SLOT_R).level] + 0.45 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({100, 200, 300})[source:get_spell_slot(SLOT_R).level] + 0.6 * source.ability_power end},
  },
  
  ["Illaoi"] = {
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return 0.04 * source.total_attack_damage / 100 + ({0.03, 0.035, 0.04, 0.045, 0.05})[level] * target.max_health end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({150, 250, 350})[level] + 0.5 * source.bonus_attack_damage end},
  },  

  ["Irelia"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({5, 25, 45, 65, 85})[level] + 0.6 * source.total_attack_damage end},
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return 43 + 12 * source.level end},--Minion Damage
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({10, 25, 40, 55, 70})[level] + 0.4 * source.total_attack_damage + 0.4 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + 0.8 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({125, 250, 375})[level] + 0.7 * source.ability_power end},
  },
  
  ["Ivern"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + 0.7 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 90, 110, 130, 150})[level] + 0.8 * source.ability_power end},
  },  

  ["Janna"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 85, 110, 135, 160})[level] + 0.35 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 100, 130, 160, 190})[level] + 0.5 * source.ability_power + (({0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35})[source.level] * source.ms) end},
  },

  ["JarvanIV"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({90, 130, 170, 210, 250})[level] + 1.2 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.8 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({200, 325, 450})[level] + 1.8 * source.bonus_attack_damage end},
  },

  ["Jax"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({65, 105, 145, 185, 225})[level] + source.bonus_attack_damage + 0.6 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 85, 120, 155, 190})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({55, 80, 105, 130, 155})[level] + 0.5 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({100, 140, 180})[level] + 0.7 * source.ability_power end},
  },

  ["Jayce"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({55, 95, 135, 175, 215, 255})[level] + 1.2 * source.bonus_attack_damage end},
    {Slot = "QM", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({55, 110, 165, 220, 275, 330})[level] + 1.2 * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({25, 40, 55, 70, 85, 100})[level] + 0.25 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return (({8, 10.4, 12.8, 15.2, 17.6, 20})[level] / 100) * target.max_health + source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({25, 65, 105, 145})[level] + 0.25 * source.bonus_attack_damage end},
  },

  ["Jhin"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({45, 70, 95, 120, 145})[level] + (({0.35, 0.425, 0.5, 0.575, 0.65})[level] * source.total_attack_damage) + 0.6 * source.ability_power end},
	{Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + 0.5 * source.total_attack_damage end},
    {Slot = "W", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({37, 63, 90, 116, 142})[level] + 0.37 * source.total_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({50, 125, 200})[level] + 0.25 * source.total_attack_damage + 0.03 * (target.max_health - target.health) end}, -- 1-3 singleHit
    {Slot = "R", Stage = 2, DamageType = 1, Damage = function(source, target, level) return (({50, 125, 200})[level] + 0.25 * source.total_attack_damage + 0.03 * (target.max_health - target.health)) end} -- 4 Hit
  },

  ["Jinx"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return 0.1 * source.total_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({10, 60, 110, 160, 210})[level] + 1.6 * source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 120, 170, 220, 270})[level] + source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({25, 35, 45})[level] + ({25, 30, 35})[level] / 100 * (target.max_health - target.health) + 0.15 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({250, 350, 450})[level] + ({25, 30, 35})[level] / 100 * (target.max_health - target.health) + 1.5 * source.bonus_attack_damage end},
  },
  
  ["Kaisa"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({40, 55, 70, 85, 100})[level] + 0.25 * source.ability_power + 0.4 * source.bonus_attack_damage end},	
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({30, 55, 80, 105, 130})[level] + 1.3 * source.total_attack_damage + 0.45 * source.ability_power end},
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return 0.05 * source.ability_power + ((target.max_health - target.health) / 100 * 15) end},	
  },  

  ["Karma"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 120, 170, 220, 270})[level] + 0.4 * source.ability_power end},
    {Slot = "Q", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({70, 120, 170, 220, 270})[level] + ({40, 100, 160, 220})[source:get_spell_slot(SLOT_R).level] + 0.7 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 130, 180, 230, 280})[level] + 0.9 * source.ability_power end},
  },

  ["Karthus"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return (({90, 125, 160, 195, 230})[level] + 0.7 * source.ability_power) * 2 end},--single Target Hero
    {Slot = "Q", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({45, 62, 80, 97, 115})[level] + 0.35 * source.ability_power end},--AOE Hero
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({30, 50, 70, 90, 110})[level] + 0.2 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({200, 350, 500})[level] + 0.75 * source.ability_power end},
  },

  ["Kassadin"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({65, 95, 125, 155, 185})[level] + 0.7 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 95, 120, 145, 170})[level] + 0.8 * source.ability_power end},
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return 20 + 0.1 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 105, 130, 155, 180})[level] + 0.85 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 100, 120})[level] + 0.4 * source.ability_power + 0.02 * source.mana end},
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({40, 50, 60})[level] + 0.1 * source.ability_power + 0.01 * source.mana end},-- per stack
  },

  ["Katarina"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 105, 135, 165, 195})[level] + 0.3 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({15, 30, 45, 60, 75})[level] + 0.25 * source.ability_power + 0.5 * source.total_attack_damage end},   
	{Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({25, 37.5, 50})[level] + 0.19 * source.ability_power end}, -- calc for 1 Dagger
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({375, 562.5, 750})[level] + 2.85 * source.ability_power end},
	{Slot = "R", Stage = 3, DamageType = 1, Damage = function(source, target, level) return (0.16 + 0.128 * source.attack_speed) * source.bonus_attack_damage end}, -- calc for 1 Dagger
  },

  ["Kayle"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + 0.6 * source.bonus_attack_damage + 0.5 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return 0.02 * source.ability_power / 100 + ({0.08, 0.09, 0.10, 0.11, 0.12})[level] * (target.max_health - target.health) end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({200, 350, 500})[level] + 0.8 * source.ability_power + source.bonus_attack_damage end},	
  },

  ["Kennen"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 120, 165, 210, 255})[level] + 0.75 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 85, 110, 135, 160})[level] + 0.8 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.8 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 75, 110})[level] + 0.2 * source.ability_power end},--per Bolt
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({300, 562, 825})[level] + 1.5 * source.ability_power end},--total single target damage	
  },

  ["Khazix"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 85, 110, 135, 160})[level] + 1.15 * source.bonus_attack_damage end},
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({126, 178, 231, 283, 336})[level] + 2.41 * source.bonus_attack_damage end},--isolated Target
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({80, 115, 145, 175, 205})[level] + source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({65, 100, 135, 170, 205})[level] + 0.2 * source.bonus_attack_damage end},
  },

  ["KogMaw"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({90, 140, 190, 240, 290})[level] + 0.7 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) local dmg = (({0.03, 0.04, 0.05, 0.06, 0.07})[level] + (0.01*source.ability_power)) * target.max_health ; if target.is_minion and dmg > 100 then dmg = 100 end ; return dmg end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 120, 165, 210, 255})[level] + 0.7 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return (({100, 140, 180})[level] + 0.65 * source.bonus_attack_damage + 0.35 * source.ability_power) * (GetPercentHP(target) < 25 and 3 or (GetPercentHP(target) < 50 and 2 or 1)) end},
  },

  ["Kalista"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 85, 150, 215, 280})[level] + source.total_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return (({14, 15, 16, 17, 18})[level] / 100) * target.max_health end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) local count = GotBuff(target, "kalistaexpungemarker") if count > 0 then return (({20, 30, 40, 50, 60})[level] + 0.7 * source.total_attack_damage) + (count-1) * ((({10, 16, 22, 28, 34})[level])+(({0.23, 0.27, 0.31, 0.36, 0.40})[level] * source.total_attack_damage)) end; return 0 end},	
  },  
  
  ["Kayn"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({75, 95, 115, 135, 155})[level] + 0.65 * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({90, 135, 180, 225, 270})[level] + 1.3 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({150, 250, 350})[level] + 1.75 * source.bonus_attack_damage end},
  },  

  ["Kindred"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 85, 110, 135, 160})[level] + source.bonus_attack_damage * 0.75 end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({25, 30, 35, 40, 45})[level] + 0.2 * source.bonus_attack_damage + 0.015 * (target.max_health - target.health) + (GetBuffData(source, "kindredmarkofthekindredstackcounter").stacks/100) * (target.max_health - target.health) end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({80, 100, 120, 140, 160})[level] + 0.8 * source.bonus_attack_damage + 0.08 * (target.max_health - target.health) + (GetBuffData(source, "kindredmarkofthekindredstackcounter").stacks/200) * (target.max_health - target.health) end},
  },
  
  ["Kled"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 55, 80, 105, 130})[level] + source.bonus_attack_damage * 0.6 end}, --Mounted
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({35, 50, 65, 80, 95})[level] + source.bonus_attack_damage * 0.8 end}, --UnMounted
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 30, 40, 50, 60})[level] + (({0.045, 0.05, 0.055, 0.06, 0.065})[level] + (0.05*source.bonus_attack_damage)) * target.max_health end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({35, 60, 85, 110, 135})[level] + source.bonus_attack_damage * 0.65 end},
  },

  ["Leblanc"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({65, 90, 115, 140, 165})[level] + 0.4 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 110, 145, 180, 215})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 70, 90, 110, 130})[level] + 0.3 * source.ability_power end},
  },

  ["LeeSin"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level] + source.bonus_attack_damage end},
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level] + source.bonus_attack_damage + 0.01 * (target.max_health - target.health) end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({100, 130, 160, 190, 220})[level] + source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({175, 400, 625})[level] + 2 * source.bonus_attack_damage end},
  },

  ["Leona"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({10, 35, 60, 85, 110})[level] + 0.3 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({45, 80, 115, 150, 185})[level] + 0.4 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 90, 130, 170, 210})[level] + 0.4 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({100, 175, 250})[level] + 0.8 * source.ability_power end},
  },

  ["Lissandra"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + 0.8 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.7 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + 0.75 * source.ability_power end},
  },
  
  ["Lillia"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({35, 50, 65, 80, 95})[level] + 0.4 * source.ability_power end},
    {Slot = "Q", Stage = 2, DamageType = 3, Damage = function(source, target, level) return ({35, 50, 65, 80, 95})[level] + 0.4 * source.ability_power end},--outer edge/TrueDmg	
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 100, 120, 140, 160})[level] + 0.35 * source.ability_power end},--AoeDmg
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({240, 300, 360, 420, 480})[level] + 1.05 * source.ability_power end},--CenterDmg
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 95, 120, 145, 170})[level] + 0.45 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({100, 150, 200})[level] + 0.4 * source.ability_power end},
  },  

  ["Lucian"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({95, 130, 165, 200, 235})[level] + ({0.6, 0.75, 0.9, 1.05, 1.2})[level] * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 110, 145, 180, 215})[level] + 0.9 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({15, 30, 45})[level] + 0.15 * source.ability_power + 0.25 * source.total_attack_damage end},--per Shot
  },

  ["Lulu"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.5 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.4 * source.ability_power end},
  },

  ["Lux"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 120, 170, 220, 270})[level] + 0.7 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({300, 400, 500})[level] + source.ability_power + (target:has_buff("LuxIlluminatingFraulein") and (10+10*source.level + 0.2*source.ability_power) or 0)end},
  },

  ["Malphite"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 120, 170, 220, 270})[level] + 0.6 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 45, 60, 75, 90})[level] + 0.2 * source.ability_power + 0.15 * source.armor end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + 0.4 * source.armor + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({200, 300, 400})[level] + 0.8 * source.ability_power end},
  },

  ["Malzahar"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.55 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({12, 14, 16, 18, 20})[level] + 0.2 * source.ability_power + 0.4 * source.bonus_attack_damage + (2 + 3 * source.level) end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 115, 150, 185, 220})[level] + 0.8 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({125, 200, 275})[level] + 0.8 * source.ability_power end},	
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return 2.5 * (({10, 15, 20})[level] / 100 + 0.015 * source.ability_power / 100) * target.max_health end},
  },

  ["Maokai"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + 0.4 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 85, 110, 135, 160})[level] + 0.4 * source.ability_power  end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({20, 45, 70, 95, 120})[level] + (({0.07, 0.0725, 0.075, 0.0775, 0.08})[level] + (0.007*source.ability_power)) * target.max_health end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 225, 300})[level] + 0.75 * source.ability_power end},
  },

  ["MasterYi"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 60, 90, 120, 150})[level] + 0.5 * source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 3, Damage = function(source, target, level) return ({30, 37, 44, 51, 58})[level] + 0.3 * source.bonus_attack_damage end},
  },

  ["MissFortune"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 40, 60, 80, 100})[level] + 0.35 * source.ability_power + source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 115, 150, 185, 220})[level] + 0.8 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return 0.75 * source.total_attack_damage + 0.2 * source.ability_power end},
  },

  ["MonkeyKing"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 45, 70, 95, 120})[level] + 0.45 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({0.01, 0.15, 0.02})[level] * target.max_health + 0.275 * source.total_attack_damage end}, --Per Tick
  },

  ["Mordekaiser"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 95, 115, 135, 155})[level] + 0.6 * source.ability_power + ({5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 51, 61, 71, 81, 91, 107, 123, 139})[source.level] end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 95, 110, 125, 140})[level] + 0.6 * source.ability_power end},
  },

  ["Morgana"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 135, 190, 245, 300})[level] + 0.9 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 110, 160, 210, 260})[level] + 0.07 * source.ability_power end}, -- minimum fullDmg
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 225, 300})[level] + 0.7 * source.ability_power end},
  },

  ["Nami"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 130, 185, 240, 295})[level] + 0.5 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + 0.5 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({25, 40, 55, 70, 85})[level] + 0.2 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + 0.6 * source.ability_power end},
  },

  ["Nasus"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return GetBuffData(source, "nasusqstacks").stacks + ({30, 50, 70, 90, 110})[level] end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({55, 95, 135, 175, 215})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({11, 19, 27, 35, 43})[level] + 0.12 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return (({3, 4, 5})[level] / 100 + 0.01 / 100 * source.ability_power) * target.max_health end},
  },

  ["Nautilus"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + 0.9 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({30, 40, 50, 60, 70})[level] + 0.4 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({55, 85, 115, 145, 175})[level] + 0.3 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 275, 400})[level] + 0.8 * source.ability_power end},
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({125, 175, 225})[level] + 0.4 * source.ability_power end},
  },
  
  ["Neeko"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + 0.5 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 115, 150, 185, 220})[level] + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({200, 425, 650})[level] + 1.3 * source.ability_power end},
  },  

  ["Nidalee"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 90, 110, 130, 150})[level] + 0.5 * source.ability_power end},
    {Slot = "QM", Stage = 2, DamageType = 2, Damage = function(source, target, level) local dmg = (({5, 30, 55, 80})[source:get_spell_slot(SLOT_R).level] + 0.4 * source.ability_power + 0.75 * source.total_attack_damage) * ((target.max_health - target.health) / target.max_health * 1.5 + 1) dmg = dmg * (GotBuff(target, "nidaleepassivehunted") > 0 and 1.4 or 1) return dmg end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 80, 120, 160, 200})[level] + 0.2 * source.ability_power end},
    {Slot = "WM", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({60, 110, 160, 210})[source:get_spell_slot(SLOT_R).level] + 0.3 * source.ability_power end},
    {Slot = "E", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({80, 140, 200, 260})[source:get_spell_slot(SLOT_R).level] + 0.45 * source.ability_power end},
  },

  ["Nocturne"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({65, 110, 155, 200, 245})[level] + 0.85 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({150, 275, 400})[level] + 1.2 * source.bonus_attack_damage end},
  },

  ["Nunu"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + 0.65 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({36, 45, 54, 63, 72})[level] + 0.3 * source.ability_power end},	
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({16, 24, 32, 40, 48})[level] + 0.1 * source.ability_power end},--per Snowbal
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({625, 950, 1275})[level] + 2.5 * source.ability_power end},
  },

  ["Olaf"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 110, 160, 210, 260})[level] + source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 3, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + 0.5 * source.total_attack_damage end},
  },

  ["Orianna"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + 0.5 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 105, 150, 195, 240})[level] + 0.7 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + 0.3 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({200, 275, 350})[level] + 0.8 * source.ability_power end},
  },
  
  ["Ornn"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 45, 70, 95, 120})[level] + 1.1 * source.total_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({0.12, 0.13, 0.14, 0.15, 0.16})[level] * target.max_health end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + 0.4 * source.armor + 0.4 * source.bonus_mr end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({125, 175, 225})[level] + 0.2 * source.ability_power end},
  },  

  ["Pantheon"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({70, 100, 130, 160, 190})[level] + 1.15 * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({55, 105, 155, 205, 255})[level] + 1.5 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({300, 500, 700})[level] + source.ability_power end},
  },

  ["Poppy"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({40, 60, 80, 100, 120})[level] + 0.9 * source.bonus_attack_damage + 0.08 * target.max_health end},
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 1.8 * source.bonus_attack_damage + 0.16 * target.max_health end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + 0.7 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 80, 100, 120, 140})[level] + 0.5 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({120, 160, 200, 240, 280})[level] + source.bonus_attack_damage end},--Target collide with terrain
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({100, 150, 200})[level] + 0.45 * source.bonus_attack_damage end},
  },
  
  ["Pyke"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({100, 150, 200, 250, 300})[level] + 0.6 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({105, 135, 165, 195, 225})[level] + source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 3, Damage = function(source, target, level) return ({250, 250, 250, 250, 250, 250, 290, 330, 370, 400, 430, 450, 470, 490, 510, 530, 540, 550})[source.level] + 0.8 * source.bonus_attack_damage + 1.5 * source.lethality end},
  }, 

  ["Qiyana"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({50, 80, 110, 140, 170})[level] + 0.75 * source.bonus_attack_damage end},
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({96, 136, 176, 216, 256})[level] + 1.44 * source.bonus_attack_damage end},--Terrain Damage	
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({8, 22, 36, 50, 64})[level] + 0.1 * source.bonus_attack_damage + 0.45 * source.ability_power end},--Passive
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({50, 90, 130, 170, 210})[level] + 0.5 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({100, 200, 300})[level] + 1.7 * source.bonus_attack_damage + 0.1 * target.max_health end},
  },  

  ["Quinn"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 45, 70, 95, 120})[level] + (({0.8, 0.9, 1.0, 1.1, 1.2})[level] * source.total_attack_damage) + 0.5 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({40, 70, 100, 130, 160})[level] + 0.2 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return 0.7 * source.total_attack_damage end},
  },
  
  ["Rakan"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + 0.6 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 125, 180, 235, 290})[level] + 0.7 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({100, 200, 300})[level] + 0.5 * source.ability_power end},
  },  

  ["Rammus"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({100, 130, 160, 190, 220})[level] + source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({15, 25, 35, 45, 55})[level] + 0.1 * source.armor end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({100, 175, 250})[level] + 0.6 * source.ability_power end},
  },
  
  ["Reksai"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({21, 27, 33, 39, 45})[level] + 0.5 * source.bonus_attack_damage end},--UNBURROWED 
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + 0.5 * source.bonus_attack_damage + 0.7 * source.ability_power end},--BURROWED 		
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({55, 70, 85, 100, 115})[level] + 0.8 * source.bonus_attack_damage end},--BURROWED   
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({55, 60, 65, 70, 75})[level] + 0.85 * source.bonus_attack_damage end},--UNBURROWED 
    {Slot = "E", Stage = 2, DamageType = 3, Damage = function(source, target, level) return ({100, 120, 140, 160, 180})[level] + 1.7 * source.bonus_attack_damage end},--UNBURROWED + Max FURY 
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({100, 250, 400})[level] + 1.75 * source.bonus_attack_damage + ({20, 25, 30})[level] / 100 * (target.max_health - target.health) end},
  }, 

  ["Rell"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.5 * source.ability_power end}, 		
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.6 * source.ability_power end}, -- if mounted  
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.3 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({120, 200, 280})[level] + 1.1 * source.ability_power end},
  },

  ["Renata"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + 0.8 * source.ability_power end}, 		  
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({65, 95, 125, 155, 185})[level] + 0.55 * source.ability_power end},
  },   

  ["Renekton"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({65, 100, 135, 170, 205})[level] + 0.8 * source.bonus_attack_damage end},
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({100, 150, 200, 250, 300})[level] + 1.2 * source.bonus_attack_damage end},--REIGN OF ANGER	
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({10, 40, 70, 100, 130})[level] + 0.75 * source.total_attack_damage end},
    {Slot = "W", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({15, 60, 105, 150, 195})[level] + 0.75 * source.total_attack_damage end},--REIGN OF ANGER
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({40, 70, 100, 130, 160})[level] + 0.9 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({40, 70, 100, 130, 160})[level] + 0.9 * source.total_attack_damage * 1.5 end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 100, 150})[level] + 0.1 * source.ability_power end},--per Second
  },

  ["Rengar"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 60, 90, 120, 150})[level] + ({0, 5, 10, 15, 20})[level] / 100 * source.total_attack_damage end},
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({30, 45, 60, 75, 90, 105, 120, 135, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240})[source.level] + 0.4 * source.total_attack_damage end},--EMPOWERED ACTIVE
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 80, 110, 140, 170})[level] + 0.8 * source.ability_power end},
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return (40 + 10 * source.level) + 0.8 * source.ability_power end},--EMPOWERED ACTIVE	
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({55, 100, 145, 190, 235})[level] + 0.8 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 2, DamageType = 1, Damage = function(source, target, level) return (35 + 15 * source.level) + 0.8 * source.bonus_attack_damage end},--EMPOWERED ACTIVE
  },

  ["Riven"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({15, 35, 55, 75, 95})[level] + ({45, 50, 55, 60, 65})[level] / 100 * source.total_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({65, 95, 125, 155, 185})[level] + source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return (({100, 150, 200})[level] + 0.6 * source.bonus_attack_damage) * math.max(0.04 * math.min(100 - GetPercentHP(target), 75), 1) end},
  },

  ["Rumble"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({180, 220, 260, 300, 340})[level] + 1.1 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 85, 110, 135, 160})[level] + 0.4 * source.ability_power end},
    {Slot = "E", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({90, 127.5, 165, 202.5, 240})[level] + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140})[level] + 0.175 * source.ability_power end},--per half Second
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({840, 1260, 1680})[level] + 2.1 * source.ability_power end},--full Damage
  },

  ["Ryze"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 90, 110, 130, 150})[level] + 0.5 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 80, 100, 120, 140})[level] + 0.3 * source.ability_power  end},
  },
  
  ["Samira"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({0, 5, 10, 15, 20})[level] + ({0.8, 0.9, 1, 1.1, 1.2})[level] * source.total_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 35, 50, 65, 80})[level] + 0.8 * source.bonus_attack_damage end}, -- 1 Hit
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 60, 70, 80, 90})[level] + 0.2 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({50, 150, 250})[level] + 5 * source.total_attack_damage end},	-- Full Damage Single Target
  },  

  ["Sejuani"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({90, 140, 190, 240, 290})[level] + 0.6 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({20, 25, 30, 35, 40})[level] + 0.2 * source.ability_power + 0.02 * source.max_health end},
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({30, 70, 110, 150, 190})[level] + 0.6 * source.ability_power + 0.06 * source.max_health end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({55, 105, 155, 205, 255})[level] + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({200, 300, 400})[level] + 0.8 * source.ability_power end},
  },
  
  ["Senna"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({40, 70, 100, 130, 160})[level] + 0.4 * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + 0.7 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({250, 375, 500})[level] + source.bonus_attack_damage + 0.7 * source.ability_power end},
  },
  
  ["Seraphine"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({55, 70, 85, 100, 115})[level] + ({45, 50, 55, 60, 65})[level] / 100 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 80, 100, 120, 140})[level] + 0.35 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 200, 250})[level] + 0.6 * source.ability_power end},
  },

  ["Sett"] = {
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({80, 100, 120, 140, 160})[level] + 0.1 * source.bonus_attack_damage end}, -- without expended Grit
    {Slot = "W", Stage = 2, DamageType = 3, Damage = function(source, target, level) return ({80, 100, 120, 140, 160})[level] + 0.1 * source.bonus_attack_damage end}, -- True Damage without expended Grit
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({50, 70, 90, 110, 130})[level] + 0.6 * source.total_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({200, 300, 400})[level] + 1.2 * source.bonus_attack_damage end}, -- without Target BonusHealth
  },  

  ["Shaco"] = {
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({25, 40, 55, 70, 85})[level] + 0.2 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return (GetPercentHP(target) < 30 and ({105, 142, 180, 217, 255})[level] + 0.9 * source.ability_power + 1.2 * source.bonus_attack_damage or ({70, 95, 120, 145, 170})[level] + 0.5 * source.ability_power + 0.7 * source.bonus_attack_damage) end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 225, 300})[level] + 0.7 * source.ability_power end},
  },

  ["Shen"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) local dmg = (({2, 2.5, 3, 3.5, 4})[level] + 0.015 * source.ability_power) * target.max_health / 100; if target.is_hero then return dmg end; return math.min(({30, 50, 70, 90, 110})[level]+dmg, ({75, 100, 125, 150, 175})[level]) end},
    {Slot = "Q", Stage = 2, DamageType = 2, Damage = function(source, target, level) local dmg = (({5, 5.5, 6, 6.5, 7})[level] + 0.02 * source.ability_power) * target.max_health / 100; if target.is_hero then return dmg end; return math.min(({30, 50, 70, 90, 110})[level]+dmg, ({75, 100, 125, 150, 175})[level]) end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 85, 110, 135, 160})[level] + 0.15 * (540 + 85 * source.level) end},
  },

  ["Shyvana"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 35, 50, 65, 80})[level] / 100 * source.total_attack_damage + 0.25 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({20, 32, 45, 57, 70})[level] + 0.2 * source.bonus_attack_damage end},--per Second
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + 0.7 * source.ability_power + 0.3 * source.total_attack_damage end},
    {Slot = "E", Stage = 2, DamageType = 2, Damage = function(source, target, level) return (60 + 5 * source.level) + 0.2 * source.ability_power + 0.1 * source.total_attack_damage end},--Dragon Form per Second	
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + source.ability_power end},
  },

  ["Singed"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({5, 7, 10, 12, 15})[level] + 0.11 * source.ability_power end},--per 0.25 Second
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 60, 70, 80, 90})[level] + 0.60 * source.ability_power + ({6, 6.5, 7, 7.5, 8})[level] / 100 * target.max_health end},
  },

  ["Sion"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 50, 70, 90, 110})[level] + ({45, 52, 60, 67, 75})[level] / 100 * source.total_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + 0.4 * source.ability_power + ({10, 11, 12, 13, 14})[level] / 100 * target.max_health end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({65, 100, 135, 170, 205})[level] + 0.55 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({150, 300, 450})[level] + 0.4 * source.bonus_attack_damage end},
  },

  ["Sivir"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({35, 50, 65, 80, 95})[level] + ({70, 85, 100, 115, 130})[level] / 100 * source.total_attack_damage + 0.5 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 45, 60, 75, 90})[level] / 100 * source.total_attack_damage end},
  },

  ["Skarner"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return 0.2 * source.total_attack_damage + ({1, 1.5, 2, 2.5, 3})[level] / 100 * target.max_health end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + 0.2 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return (({20, 60, 100})[level] + 0.5 * source.ability_power) + (0.60 * source.total_attack_damage) end},
  },

  ["Sona"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 70, 100, 130, 160})[level] + 0.4 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + 0.5 * source.ability_power end},
  },

  ["Soraka"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({85, 120, 155, 190, 225})[level] + 0.35 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 95, 120, 145, 170})[level] + 0.4 * source.ability_power end},
  },

  ["Swain"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 80, 100, 120, 140})[level] + 0.38 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.7 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({35, 70, 105, 140, 175})[level] + 0.25 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({20, 40, 60})[level] + 0.1 * source.ability_power end},--per Second
  },
  
  ["Sylas"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 60, 80, 100, 120})[level] + 0.4 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.90 * source.ability_power end},
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({97, 150, 202, 255, 307})[level] + 0.97 * source.ability_power end},--if Target below 40%	
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 130, 180, 230, 280})[level] + source.ability_power end},
	{Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 65, 80, 95, 180})[level] + 0.4 * source.ability_power end},     
  },  

  ["Syndra"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.65 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + 0.7 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({85, 130, 175, 220, 265})[level] + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({270, 420, 570})[level] + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({90, 140, 190})[level] + 0.2 * source.ability_power end},-- PER SPHERE
  },

  ["Talon"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({65, 85, 105, 125, 145})[level] + source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({40, 50, 60, 70, 80})[level] + 0.4 * source.bonus_attack_damage end},--INITIAL DAMAGE
    {Slot = "W", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({50, 80, 110, 140, 170})[level] + 0.8 * source.bonus_attack_damage end},--RETURN DAMAGE
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({90, 135, 180})[level] + source.bonus_attack_damage end},
  },

  ["Taliyah"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 95, 120, 145, 170})[level] + 0.45 * source.ability_power end},
    {Slot = "Q", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({210, 285, 360, 435, 510})[level] + 1.35 * source.ability_power end},--Single Target
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 80, 100, 120, 140})[level] + 0.4 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 90, 110, 130, 150})[level] + 0.4 * source.ability_power end},
    {Slot = "E", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({160, 210, 260, 310, 360})[level] + 0.8 * source.ability_power end},
  },

  ["Taric"] = {
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({90, 130, 170, 210, 250})[level] end},
  },

  ["TahmKench"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 130, 180, 230, 280})[level] + 0.7 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return target.is_minion and ({400, 450, 500, 550, 600})[level] or (({0.20, 0.23, 0.26, 0.29, 0.32})[level] + 0.02 * source.ability_power / 100) * target.max_health end},
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({100, 135, 170, 205, 240})[level] + 0.6 * source.ability_power end},--PROJECTILE DAMAGE
  },


  ["Teemo"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + 0.8 * source.ability_power end},
    {Slot = "E", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({24, 48, 72, 96, 120})[level] + 0.4 * source.ability_power end}, --Total DotDmg
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({14, 25, 36, 47, 58})[level] + 0.3 * source.ability_power end}, --Ground Damage
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({200, 325, 450})[level] + 0.5 * source.ability_power end},
  },

  ["Thresh"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.5 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({65, 95, 125, 155, 185})[level] + 0.4 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({250, 400, 550})[level] + source.ability_power end},
  },

  ["Tristana"] = {
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({95, 145, 195, 245, 295})[level] + 0.5 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({70, 80, 90, 100, 110})[level] + ({0.5, 0.75, 1, 1.25, 1.5})[level] * source.bonus_attack_damage + 0.5 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({300, 400, 500})[level] + source.ability_power end},
  },

  ["Trundle"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 40, 60, 80, 100})[level] + ({0.15, 0.25, 0.35, 0.45, 0.55})[level] * source.total_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return (({20, 27, 35})[level] / 100 + 0.02 * source.ability_power / 100) * target.max_health end},
  },

  ["Tryndamere"] = {
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + 1.3 * source.bonus_attack_damage + 0.8 * source.ability_power end},
  },

  ["TwistedFate"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + 0.7 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 60, 80, 100, 120})[level] + source.total_attack_damage + 0.9 * source.ability_power end},--Blue Card
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({30, 45, 60, 75, 90})[level] + source.total_attack_damage + 0.6 * source.ability_power end},--Red Card
    {Slot = "W", Stage = 3, DamageType = 2, Damage = function(source, target, level) return ({15, 22.5, 30, 37.5, 45})[level] + source.total_attack_damage + 0.5 * source.ability_power end},--Gold Card
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({65, 90, 115, 140, 165})[level] + 0.5 * source.ability_power end},
  },

  ["Twitch"] = {
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return (GotBuff(target, "twitchdeadlyvenom") * ({15, 20, 25, 30, 35})[level] + 0.25 * source.ability_power + 0.35 * source.bonus_attack_damage) + ({20, 35, 50, 65, 80})[level] end},
    {Slot = "E", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({15, 20, 25, 30, 35})[level] + 0.333 * source.ability_power + 0.35 * source.bonus_attack_damage + ({20, 35, 50, 65, 80})[level] end},
  },

  ["Udyr"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 60, 90, 120, 150, 180})[level] + (({110, 125, 140, 155, 170, 185})[level] / 100) * source.total_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 110, 160, 210, 260, 310})[level] + 0.8 * source.ability_power end},

  },

  ["Urgot"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({25, 70, 115, 160, 205})[level] + 0.7 * source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({90, 120, 150, 180, 210})[level] + source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({100, 225, 350})[level] + 0.5 * source.bonus_attack_damage end},	
  },

  ["Varus"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({10, 47, 83, 120, 157})[level] + source.total_attack_damage end},
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({15, 70, 125, 180, 235})[level] + 1.65 * source.total_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({7, 12, 17, 22, 27})[level] + 0.3 * source.ability_power end},
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return (({3, 3.5, 4, 4.5, 5})[level] / 100 + 0.02 * source.ability_power / 100) * target.max_health end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + 0.9 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + source.ability_power end},
  },

  ["Vayne"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 65, 70, 75, 80})[level] / 100 * source.total_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 3, Damage = function(source, target, level) return math.max(({50, 65, 80, 95, 110})[level], (({4, 6.5, 9, 11.5, 14})[level] / 100) * target.max_health) end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({50, 85, 120, 155, 190})[level] + 0.5 * source.bonus_attack_damage end},
  },

  ["Veigar"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.6 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({100, 150, 200, 250, 300})[level] + source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) local dmg = GetPercentHP(target) > 33.3 and ({175, 250, 325})[level] + 0.75 * source.ability_power or ({350, 500, 650})[level] + 1.5 * source.ability_power; return dmg+((0.015 * dmg) * (100 - ((target.health / target.max_health) * 100))) end},
  },

  ["Velkoz"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.9 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({30, 50, 70, 90, 110})[level] + ({45, 75, 105, 135, 165})[level] + 0.45 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 100, 130, 160, 190})[level] + 0.3 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 3, Damage = function(source, target, level) return (GotBuff(target, "velkozresearchedstack") > 0 and ({450, 625, 800})[level] + 1.25* source.ability_power or target:calculate_magic_damage(({450, 625, 800})[level] + 1.25 * source.ability_power)) end},
  },
  
  ["Vex"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 105, 150, 195, 240})[level] + 0.6 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.3 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 70, 90, 110, 130})[level] + (({0.4, 0.45, 0.5, 0.55, 0.6})[level] * source.ability_power) end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 125, 175})[level] + 0.2 * source.ability_power end},
	{Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + 0.5 * source.ability_power end},
  },  
  
  ["Viego"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return (({15, 30, 45, 60, 75})[level] + 0.7 * source.total_attack_damage) * source.crit_chance end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 135, 190, 245, 300})[level] + source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return (({0.15, 0.20, 0.25})[level] * (target.max_health - target.health)) + 1.2 * source.total_attack_damage + 0.075 * source.crit_chance end},
  },  

  ["Vi"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({55, 80, 105, 130, 155})[level] + 0.7 * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return (({4, 5.5, 7, 8.5, 10})[level] / 100 + 0.01 * source.bonus_attack_damage / 35) * target.max_health end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({10, 30, 50, 70, 90})[level] + 1.1 * source.total_attack_damage + 0.9 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({150, 325, 500})[level] + 1.1 * source.bonus_attack_damage end},
  },

  ["Viktor"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 75, 90, 105, 120})[level] + 0.4 * source.ability_power end},
    {Slot = "Q", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({20, 45, 70, 95, 120})[level] + 0.6 * source.ability_power + source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + 0.5 * source.ability_power end},
    {Slot = "E", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({90, 170, 250, 330, 410})[level] + 1.3 * source.ability_power end},--Total Damage
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({100, 175, 250})[level] + 0.5 * source.ability_power end},
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({65, 105, 145})[level] + 0.45 * source.ability_power end},--Per Tick
  },

  ["Vladimir"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 100, 120, 140, 160})[level] + 0.6 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 135, 190, 245, 300})[level] + 0.1 * (source.max_health - 537 + 96 * source.level) end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({30, 45, 60, 75, 90})[level] + 0.35 * source.ability_power + 0.025 * source.max_health end},
    {Slot = "E", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + 0.8 * source.ability_power + 0.06 * source.max_health end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + 0.7 * source.ability_power end},
  },

  ["Volibear"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 40, 60, 80, 100})[level] + 1.2 * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return (({10, 35, 60, 85, 110})[level]) + source.total_attack_damage + 0.06 * (source.max_health - GetBaseHealth(source)) end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + 0.8 * source.ability_power + ({0.11, 0.12, 0.13, 0.14, 0.15})[level] * target.max_health end}, --Hero Dmg
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({300, 500, 700})[level] + 1.25 * source.ability_power + 2.5 * source.bonus_attack_damage end},
  },

  ["Warwick"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return (({6, 7, 8, 9, 10})[level] / 100  * target.max_health) + source.ability_power + 1.2 * source.total_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({175, 350, 525})[level] + 1.67 * source.bonus_attack_damage end},
  },
  
  ["Xayah"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({45, 60, 75, 90, 105})[level] + 0.5 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({55, 65, 75, 85, 95})[level] + 0.6 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({200, 300, 400})[level] + source.bonus_attack_damage end},
  },  

  ["Xerath"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + 0.85 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + 0.45 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({200, 250, 300})[level] + 0.45 * source.ability_power end},
  },

  ["XinZhao"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({16, 25, 34, 43, 52})[level] + 0.4 * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + 1.1 * source.total_attack_damage + 0.5 * source.ability_power end},	
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level] + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({75, 175, 275})[level] + source.bonus_attack_damage + 1.1 * source.ability_power + 0.15 * target.health end},
  },

  ["Yasuo"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 45, 70, 95, 120})[level] + 1.05 * source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 70, 80, 90, 100})[level] + 0.2 * source.bonus_attack_damage + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({200, 350, 500})[level] + 1.5 * source.bonus_attack_damage end},
  },
  
  ["Yone"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 40, 60, 80, 100})[level] + 1.05 * source.total_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({5, 10, 15, 20, 25})[level] + ({0.055, 0.06, 0.065, 0.07, 0.075})[level] * target.max_health end}, -- Ap Damage
    {Slot = "W", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({5, 10, 15, 20, 25})[level] + ({0.055, 0.06, 0.065, 0.07, 0.075})[level] * target.max_health end}, -- AD Damage
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({100, 200, 300})[level] + 0.4 * source.total_attack_damage end}, -- Ap Damage
    {Slot = "R", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({100, 200, 300})[level] + 0.4 * source.total_attack_damage end}, -- Ad Damage
  },  

  ["Yorick"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 55, 80, 105, 130})[level] + 0.4 * source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.7 * source.ability_power + 0.15 * target.health end},
  },
  
  ["Yuumi"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 80, 110, 140, 170, 200})[level] + 0.3 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({240, 320, 400})[level] + 0.8 * source.ability_power end},
  },  

  ["Zac"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 55, 70, 85, 100})[level] + 0.3 * source.ability_power + 0.025 * source.max_health end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({35, 50, 65, 80, 95})[level] + (({4, 5, 6, 7, 8})[level] / 100 + 0.04 * source.ability_power / 100) * target.max_health end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 110, 160, 210, 260})[level] + 0.9 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({140, 210, 280})[level] + 0.4 * source.ability_power end},
  },
  
  ["Zeri"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({1, 1.29, 1.57, 1.86, 2.14})[level] + (({0.1571, 0.1607, 0.1643, 0.1679, 0.1714})[level] * source.total_attack_damage) end}, -- per bullet
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({7, 9, 11, 13, 15})[level] + (({1.1, 1.125, 1.15, 1.175, 1.20})[level] * source.total_attack_damage) end}, -- Full Dmg
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({10, 45, 80, 115, 150})[level] + 1.4 * source.total_attack_damage + 0.7 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + 0.8 * source.bonus_attack_damage + 0.8 * source.ability_power end},
  },  

  ["Zed"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({80, 115, 150, 185, 220})[level] + 1.1 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({70, 90, 110, 130, 150})[level] + 0.65 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return 0.65 * source.total_attack_damage end},
  },

  ["Ziggs"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({85, 135, 185, 235, 285})[level] + 0.65 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.5 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({30, 70, 110, 150, 190})[level] + 0.3 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({300, 450, 600})[level] + 1.1 * source.ability_power end},
  },

  ["Zilean"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 115, 165, 230, 300})[level] + 0.9 * source.ability_power end},
  },
  
  ["Zoe"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 80, 110, 140, 170})[level] + 0.6 * source.ability_power + ({7, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 29, 32, 35, 38, 42, 46, 50})[source.level] end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 105, 135, 165, 195})[level] + 0.4 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + 0.4 * source.ability_power end},
  },  

  ["Zyra"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 105, 150, 195, 240})[level] + 0.5 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({180, 265, 350})[level] + 0.7 * source.ability_power end},
  }
}

--------------------- Global functions --------------------


--- Return if unit killable or has buff like Sion ---
function IsKillable(unit)
	if unit:has_buff_type(16) or unit:has_buff_type(18) or unit:has_buff_type(38) or unit:has_buff("sionpassivezombie") then
		return false
	end
	return true
end

--- Calculate and return correct Damage ---
function getdmg(spell, target, source, stage, level)
	local source = source or game.local_player
	local stage = stage or 1
	local swagtable = {}
	local Buff = source:get_buff("8001EnemyDebuff")
	if stage > 4 then stage = 4 end
	if spell == "Q" or spell == "W" or spell == "E" or spell == "R" or spell == "QM" or spell == "WM" or spell == "EM" then
		local level = level or source:get_spell_slot(({["Q"] = SLOT_Q, ["QM"] = SLOT_Q, ["W"] = SLOT_W, ["WM"] = SLOT_W, ["E"] = SLOT_E, ["EM"] = SLOT_E, ["R"] = SLOT_R})[spell]).level
		if level <= 0 then return 0 end
		if level > 5 then level = 5 end
		if DamageLibTable[source.champ_name] then
			for i, spells in ipairs(DamageLibTable[source.champ_name]) do
				if spells.Slot == spell then
					table.insert(swagtable, spells)
				end
			end
			if stage > #swagtable then stage = #swagtable end
			for v = #swagtable, 1, -1 do
				local spells = swagtable[v]
				if spells.Stage == stage then
					if IsKillable(target) then
						
						if spells.DamageType == 1 then
							if Buff.count > 0 and Buff.source_id == target.object_id then
								local ReductionStackDmg = 1-(target:get_buff("8001DRStackBuff").stacks2/100)
								return DmgReduction(source, target, ReductionStackDmg * target:calculate_phys_damage(spells.Damage(source, target, level)), 1)
							else
								return DmgReduction(source, target, target:calculate_phys_damage(spells.Damage(source, target, level)), 1)
							end
						elseif spells.DamageType == 2 then
							if Buff.count > 0 and Buff.source_id == target.object_id then
								local ReductionStackDmg = 1-(target:get_buff("8001DRStackBuff").stacks2/100)
								return DmgReduction(source, target, ReductionStackDmg * target:calculate_magic_damage(spells.Damage(source, target, level)), 2)
							else
								return DmgReduction(source, target, target:calculate_magic_damage(spells.Damage(source, target, level)), 2)
							end
						elseif spells.DamageType == 3 then
							if source.champ_name == "Pyke" then
								local ExecuteDmg = spells.Damage(source, target, level)
								if ExecuteDmg > target.health then
									return 999999
								else
									if Buff.count > 0 and Buff.source_id == target.object_id then
										local ReductionStackDmg = 1-(target:get_buff("8001DRStackBuff").stacks2/100)
										return DmgReduction(source, target, ReductionStackDmg * target:calculate_phys_damage(spells.Damage(source, target, level)), 1) /2
									else
										return DmgReduction(source, target, target:calculate_phys_damage(spells.Damage(source, target, level)), 1) /2
									end								
								end
							else
								return spells.Damage(source, target, level)
							end	
						end
					end	
				end
			end
		end
	end
	
	if spell == "AA" then
		if stage == 2 then -- Calculate and return AA-Damage + Items PassiveDmg
			if Buff.count > 0 and Buff.source_id == target.object_id then
				local ReductionStackDmg = 1-(target:get_buff("8001DRStackBuff").stacks2/100)
				return DmgReduction(source, target, ReductionStackDmg * target:calculate_phys_damage(source.total_attack_damage), 1)+getdmg_item(target, source)
			else
				return DmgReduction(source, target, target:calculate_phys_damage(source.total_attack_damage), 1)+getdmg_item(target, source)
			end
		else -- Calculate and return AA-Damage
			if Buff.count > 0 and Buff.source_id == target.object_id then
				local ReductionStackDmg = 1-(target:get_buff("8001DRStackBuff").stacks2/100)
				return DmgReduction(source, target, ReductionStackDmg * target:calculate_phys_damage(source.total_attack_damage), 1)
			else
				return DmgReduction(source, target, target:calculate_phys_damage(source.total_attack_damage), 1)
			end
		end
	end
	
	if spell == "IGNITE" and IsKillable(target) then
		return 50+20*source.level - (target.health_regen*3)
	end
	
	if spell == "SMITE" then
		if stage == 1 then
			return 450 			-- SummSpellName == "SummonerSmite"
		elseif stage == 2 then
			return 900      	-- SummSpellName == "S5_SummonerSmiteDuel" or spellName == "S5_SummonerSmitePlayerGanker"
		end
	end
	return 0
end

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
						return 0.12*target.max_health
					else
						return 0.09*target.max_health
					end
				
				elseif target.is_jungle_minion then
					
					if source.is_melee then
						return (0.12*target.max_health > 2.5*source.base_attack_damage) and 2.5*source.base_attack_damage or 0.12*target.max_health
					else
						return (0.09*target.max_health > 2.5*source.base_attack_damage) and 2.5*source.base_attack_damage or 0.09*target.max_health
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
				return 60+(0.45*source.bonus_attack_damage)
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
			local Bonus = 0.02*(source.max_health-source.base_health)
			if source.is_melee then
				return Bonus+5+(0.015*source.max_health)
			else
				return Bonus+3.75+(0.01125*source.max_health)
			end
		end
	},

	{Id = DmgItems.WitsEnd, DamageType = 2, spell = "AA",	
		ItemDamage = function(source, target)
			return ({15, 16.25, 17.5, 18.75, 20, 21.25, 22.5, 23.75, 25, 35, 45, 55, 65, 75, 76.25, 77.5, 78.75, 80})[source.level]
		end
	},
}

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
	
	if target.is_hero then
		if source.champ_name == "Ashe" and target:has_buff("ashepassiveslow") then
			PhysicalDamage = PhysicalDamage + (0.1+0.75*source.crit_chance/100)*source.total_attack_damage
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

client:load("2YeqWWlngvjiOs5eckKxo0IGgYAGSamz4GTse31aGyszbS5niABL61CYb9xlNSzha7MR3E1jBHmWUrxtN5FKxEXBh3rQ53OgEZG5PyaFhkVi0WY4x4qACKyJljKsGwUvvRTQVNlQuEH7IsHP1E9pN1ug vFKh2ZNj2iz64D5IBPjMSdItJfjOdCnXnKB3SPphR9eSVCW90UxgIhocAJhPQm6LCS69d1nKxcAhVQ651UiINKz9XOja8RClYLym39nf1JqOVBz1k8jkWVHjJ3p28d7 GrR4QBf1m1kA4mvd06DAid29MQpfbvDLNFkgIIZbbs5Ak9o0rTjbu9A3ZJ+VSYxW4XzZAq4bEaY3polOdD79Cp+NsypOwWmZUTKTGXo0IAEJQZQ4XPQfml6bZM8ZGGmPAA661UiCoplGCznZ8VnkE gmnTQu7UIOZ5CreHvi2DzhJzm33 9bGrkggBFOX2Jyuczeh2DzEqv cPoubDM29Ui0Mfga8rPrSVAO1Z5VP1AfJtNhn h3fTbfOdMbdassZfu3QGfGG3ogLSuhLqsaUYunALRgs9WJUIKNGZeemDk AEwb9TvjEFejsBmb2az9W7jcJoD7YdK0RzNgnBr0Z5H10lxhXDx533l14p6WWa NClxKmQwx48ubjmIydduIHEhtbOye9Jg6sYncSYm1kNrM8PvIv1AfJtNhiswqKDsaUTsIVl70KQh2EjsGGuB4rztgL nb0Tu90 8s3ZJYgaO4WvhOn97aEgsdvqv6AAYWXqtYsdz 2HfZ7Rm5jrk6I5Mg14IrTk13EXliGKMg33zO4OPIE1j4U13M0btyuDBbLNG6Y6p bovt8i2FXlbtsXICL2zOyoPrljq LlFeigMiyY W4vmbUJxaFKsg5ElNj7w maCgcKKIL4tcgqpWGYBs25NcfryfW26dXT79eMGKwHzhU5ei7UxKYqp wmyC7pJQWrzinTQs1Qm1ZlM0UqxRSrzhtOg19OfMmXeh1Rf1mYpja9BK42DzEqv 88vubjFd34f0JD7IwQm1kdrxLDuXrBEeicHh2rvbj55aVOoXkCugZEsBFXoam3siu7p5rF7PQqv9qLCt8JO0 ah22j LH9dXd7RCGCPkEF8iLJsa2UEXXHPKPZR7d75k1eNtrlt1qMKxEisimbNhpiKrXqa mWzHUVsOAvOZYGPd5WMAE00anD90vbze3UkvN2wcb252uoPOr7yGvkDM4Ziin7mr0TubgqscYunuqTo4Z1FamK7hnig5vcICOap mY8v3JW0adMfXL52Wma ennYMmqPFRQjsyjdIUua177bRpo7 Hhzn4Et7JoDpRH219kimDD3 PvzOWQanPaiA5t2mwrx4lvI1xm6VJ1KsDgfL3CLORRutQjdrbmN1Rv3rTfaSBwf3EMjG3zcpc5X0anIVP70Jfi1AaCWmes3SPfgLVedE7lmkLRUWlnZ 7K4S3een5aaFTvRMmriVl501asa2Yzayu6dSZVkE108RC7UVlnOlBKNV532GZk54HI04V6NCHc3U1jAmoly4cld4mHm G09vYuU6i1FXlfgoIYbSkq2ihv3MKgNrAaM4ZG5WrLQdCOCOa3bk3junop4ZSnNSq7gSbli mndFBgVCXFUmk7D4JDgmOyFgCyA8ozYN562E9S62yGa3FlNSzPd8NV7eWulX1ns2ZjM6NOOUPvSmLM5M70036aAgqyHUVsOAzNZ4cAZYpXmd kA6oygMPift4792bjbMskIUlA017ualpwfJY2Imm2pK55aUYxIW3jvHUDKkHs GmGPwPhibijdA KN0UDf8FQJSaVZ3zaeGOhGXUwbMc0iYhekHleU9qq GvDY75IQV6gmnTQu7UqxGAKxEmsiAe1hN7jN3B6aGeoNB0eKm6nAOqEOI6zBQm0WMMngMOMe Jfg8ssKFvOrels18GgVnwrgoBHhGVAo4q5IEaxIYaufZsy3Qnsbmur4InzgRqqbFCom7dH2IkNJUeNHgiydWf6ajwwbwPFhE9PVqGnb2KZ 0fedNlTjkSp6EhE4HBf1pQy20LsiGnRgN70AtSn 3j V09s3HUzyKT6a4WI08pJAFrJUFjVT8Nmg2EqIs7l3FJ7OVmJAFl5ei9D1GwJok8lPQqCajaqtKUo2kWcTGaA4KPvYvqYKFqvnCHSUWk7VgZDgGvD1WiaGV3ncSLviExohLYYLsUm WS6Cro67dak0Ry7Ullj1pQ2rV1okHLQhpzDF8SlXWDhQABS0WbphOqOakRG6XSwXLAsabDL2XpbtsXICb661kN6017uGtdwh1tM42wuojmsREQqKZGfupkl4UCn9Ga7ivjt5HpICUamTKUpu9RhcgBDhkfegCS+GVDnYMmqPEd7i1JsZ8uyXV7Pa75IQU6gzHTXvKRt35VQHED3PDUqOKKg3Nma iHPg1dj2kstAP4mPfBK6Y0uXprJtv7B13w7sMsYdvsyOQAexLfpbwRAfi2yh36h00lCCeavbjCftFIp2ETL W2nUHywI6qqb0ChmGYEt9MEQ6Zd4WLPe30VREY Kx9njkdakHUtcsas9W2eCro7Kd5vAjPD3HBx05lK1F5ri3Gyg32g04G79XPoPEV0NW2pav5xajyGAjmvbwPo2Hiy2N8AUWsnZ8IE00ly1MLo SQgZ3tL5Vew64D5KFqycQ e7lHwyYLBXCqGfRjshwSmb1F66KIBg1RTTUJhPHzkfyC6NV3nawD6kEli6XilY2QqJmv7dRZR6kqgBHvJtlkHrTk2rOCMhWVBXNZnxK569Wa9WE1lxCDkl c6Z42B8ZSr9LAsuRfNgJ5ptMfYLrI5NVJtO2OsGwNCeiFKi2Fwr0moYVC3ZexnUVHKs8rs mFQHFiKIL0sZy KNULRsMVWcfiRNDY622XiX 8DbwXa6VJoJlakb9xl9Su6aRZVjQHpzjPNuLFn2qMG0EcBi2LRQZzk1DtyAWrbNEhj2miyx55lZj6zzepgWL8k0tjRYtFis2Xmav2D1wkm3Lfl 8AVGcs1gWlho4cDbwUmaYuruIfuOd7sGDPfNrHD4LqYbFauTmYptsQEbUiQgy37139ebEYmcTTriEwjkruqa2FlWW3 IRlIkEdulX1ns2ZjM6NOOUPvSnDKh OgE056KyHPfEVsrgvNZYDvbKOSzdhgNHEptbLWe3c72EIlZMYp1UcuxqGiJrBa2jRF5XdtW4zqckXsCy HUTvJs8rs HCsfLWggv0wbwUh97dxvsVDdgZDgGujgmXh9dTnYMmqPEhajrXsY2C59XXaXdRT7dDs9o5Furdj3I9HOASbWSrh44HnO4Vj 2Pf4UNYM2wo5P9uZj5Y08pJAFrJUFi1d3Y7sM2wbnbmN1Rv3rTfaSBwf3EMgXagbkc5b0u3dYuhsBI01Y1BAg QHFiJgL hREQnTHmos25HSUoFNCq61X1gaZMsZtHp5Ux947uZdMYkWXPPY7RO5jXhzXTLgXhmO0JNAAT35XzF54OprnpyAQragFNjrgvNZYCPUpyJBUF9Gvklub6M13NQs36jXSUBOUxyAsLs SQrTf8ySCZipK8lIjtlIYYwUjrJs8qQASpnNvflibcsYUC0l1lte9NU0 VKQnLhe386Na3nMITnikQ6Pq2gIMYDAgiyC1o6K Gg6HvJur8sNZNh0Vgo43DO53vsAuSh 3W6UR0eBiMlyu8mIIVw6YdyA6nJUFi1FZA70MojcbezNUN602XlVSNH3iFKRnatpq8lPRPjMQqftpXgyDOpGGYFNv3phptHCO JNZ Mt2cEQ6ZagG7PLHlYGY8wbsTnikQ667KYZMQsIFLhbdUPQZXhAnrJvHwe0JVQ1wCji3yySHmJrXpyAWrj3YRrOyLc5ODAYnSHmQFrGuQEtLa2FXkzU22sZpvOrOlr1rOJA6kU3icCIgJmpK8OCe NCdOtulIpBUHIX3yCYLjugLdsIEauTKIEf2lWdMFZ4XPuemcicb4wbcDBilMdTYpuMIllbGDnZcZmS qgmHl8UVlnOlBTO11y0WbMg37uxOWdXW zHOkH0W9kc4vEbn2DzEqv 88puQ7hg4Jog3Xedvoq1eoPrViJ9L5uV39FODnhojmoREQqIUhe2Fno4Ye XXyPfMPzRIJnKhpuYGHz4YkOZa7JhHHa2DH9WdAqXSX7kE9552GYY2CwV2P7b7JK7 nBm4XTa1ls0Z9MAAT35XzF54OprnpyAW1hh0UIrQvNZ4DAYnSHmQF9GvoufPPL2FAh0MMwaSIDOUQbN7DsWQ9shjZN3231r4XoaZYnYdQfg51oGdjF 0Qwgbjvh8BedEuy 6h82Y8WJOM1HQjaem8yAynQZMmqJelairFICYPyW27jcccP7avsz3qMvL9x3KJH1kurhWVBXNZnzZpzAXPaiFVw1iMtyu5Kbjdu0E0uXprK3HZtZDo+7pa+P9a+Eh4+Eo2+N94+TGb+Vjr+3Hl+PhTaPVl67GD8FVCeNDleUsu8VsB6PBl80HTfUp4+Qxr+Uj2+Sjl+NB7+P l+Wh4+WoT+PpT+NjuXPOAuXVC8cEKv7Iw6EGwpEBOaWDmpVKuKEq9+Nj +Uh4+Eje+brl+PH5+cB9+N97+792+SKwY7JD6PsDcEBwdEIu8NswiT0EpVDU93YG+PhT+PBT+7ma+FB +NjT+U92+V99+PhT+0nqf7JwvQRUpUDuXSDOXNVzePtOdWBwXWIl6CpT+Nj2+Pu8+XB +ckh+7o4+Em4+Ehl+WjU+Vqu8EKBXNDCXUBw6EDHbbLOdP1xlcVB8NszK792+Sq4+7pa+P9a+Eh4+Eo2+N94+TGb+Vjr+31OcPBlaPVl67GD8FVCeNDleUsu8VsB6Pyd+0nq+7p4+Qxr+Uj2+Sjl+NB7+P l+Wh4+WoT6PJlcNDuXPOAuXVC8cEKv7Iw6EGwpEBOaJjU+Vq2+Eq9+Nj +Uh4+Eje+brl+PH5+cB9+N9z87supSKwY7JD6PsDcEBwdEIu8NswiT0E2Vjr+3Hl+PhT+PBT+7ma+FB +NjT+U92+V99+PBl80HTf7JwvQRUpUDuXSDOXNVzePtOdWyozSXPeVM7uayzcZ8VMjETvzXeNtrdi1ZcG3EXB62LhRJzo04WP9W7aPQB3135kk XAI4mBzEdyXHzgsHzQ24RRusaedvou2wBB1nztcHBM2pZHjm31pq0lYUUnIYGttqXg2YryXSqqfvDu5RZsLgTgm6lus2NNZ UyVXzeLGDoGWgsduDA509ih1UlRMQsIHP7cxhIlUCgyHznvLlrOVk2rhl+WjU+Vq2+Eq9+Nj +Uh4+Eje+brl+PH5+cBB8Nsz87supSKwY7JD6PsDcEBwdEIu8NswVTGb+Vjr+3Hl+PhT+PBT+7ma+FB +NjT+U92+VsB6PBl80HTf7JwvQRUpUDuXSDOXNVzePqG+Wh4+WoT+PpT+Nj2+Pu8+XB +ckh+7o4+Em4pEBOaWDmpVKu8EKBXNDCXUBw6EDHbbLOdCJ2r0E41 bQ0sL7MLNdbvMssYRfy1UlAO7PtXnha2jRF5XdtW4zudFGsbdJnUjspPAHzWXC70v735MOGaVFg0mXE0MFS0QZF3WZaOmv7 dYmdwDz6QAiPLmfc9GZ 3bacvlMlUG+cTOX0MRmOZ4y3Eq66Xz0g4PzxK56KCHagkQIrWIzk XyI4iDBZWp LXg7HzGd4RQs28jIvfDxBAABVmJ v9u2iEygWsk54isIBPjMSdHtJfjOdCnaGYGNsYg1b0hdEYyZortvEhnZa7F4XOje31eXjoBKGGPJelbi8xeXElla2rebRBWiYe06HzS0LluNZlQ2wzokmvC50nz09qh HTdg1RxzCvt5O9BCElXyd3gaRwptvvRdN9Q6rYnbL2Z1Yhv3Hfw SMAM0bySCZipK8lc0isbYmxsJf0EDXw WK1gPfpjrmub1BpTHTg0MhNeVeHgWSg22XiX 8zYN9rikNUPMGmZ2TOAQiyCro6Kdrul15RgDA7xJlMNY9w6yqJONbl3NWiXynof0lq1HYsya8AcpyJBUBgbvIygRThOJBps8sqbwUt11QAN7DzbvVJOcsyIgIKcjmpCO MCyajtpXJsyqRAW7shb7linF7IE3hm0gCuMxFf iQhwmy2mqnGYnzIwzrjk86h1Tea3qm9XHoKRlIkEelAzyEgL8IrTlHOgTr6XzNRtjzM90jXW7UNEFsOCMNz9gnb4my8Ymlabap0wPG2347UmrHCLsrxEhr2r6uWRhsfjJxhm3ucfSdPQplQjunvJE52AOnWWUrNvflibcsYUC0l1lte9NU0 VKQnX7eGD GYIBZsTu6VJkSruhdMa7XV7ocRZPjUazzHmn0I07xGMy3Ezoige1IXiJ03 9PG7cNB0e0WfndOitI0tumj00Xv4n2rH Lpw7vMMwZR25AABuO2HvIFoUGcs2IQIKcjPEZUapIY7jupeuOdT79XOs2SLw5LCqLlOhmKIs0MFS0QZG4XHkOmX9bYo9ZLqFjEVhiHUYY3ysXXP5a7UDXa6gBHTWg7VYAp9A0kcmkFZH5Jz00N0jAgqyHOkIrQvNZ4DsI4izAEcuWLQ0sMXD0 Nmg2EqLbsEM0F73L7hbwRs2oAyjGFmpEGOCO MCdasf3YtPQGfGGaB3PPt5nFpIEuyl7YGg2QtZf3K3177gX9kVjI7dwXphZ9 51QfZ8Jt9GTnbJADlYLym39n2VoHrTk1OUPC6Qe1IXiJr2Sh 3W6UQBmOXUz8uXpd4mfmcdzavYstr3ReN9Q0J77IsHlNU5qxHHRG8BGgDw1IQIKQdClIAqrZeyt3pMj4Yr9XVYGhvTshr xbEY0THmg0JEEZ sCNCHMLiTkayrQCGCPJOk6PHqmZ3yAJmD9dRpo7cezAH9QtH5x1J9hxBhbPDyy433kxJOuGiHkheoHrQvNZYCmI0CCmeOvJbIjvvjj229puM2qbrbE1E96xIY9GsMr2icCOC7TWGTAcgqxadlIUTrJs8r0PGQuNsYg0RCtdAq+0WYCs2wEZ sCNGbagG9iXQk0bwq6SABP52ylZ3FxGGfacxbMQYey6EO8UVkHrTlH1k5HiW3yVZzp1tSt Wi6PwBRGGbrZoCPCdmzzEVKAFnJgL3CFXozU22sZpvOOU5qrVmJA6lxfpQygSUh4jvDbYQsbEattlIp2AHwaGuwhcKoXR0YRUUlm1IVs25NcfsRPDClPDShGZUoccvrkAkePLGtCm O9WW6Q7hVjh7pznzTtnBY0JVMreCMJWbEOLDn2tdC9Waeg04s0XYjAPcEcKWd6ZWoXL7KUFi1F3lkf6YrZnHdxElAN5PtXnACMZoGQHewrpcDSEa3cQPv2VvwBBWwIztwPbDygSGwZUF6962Af79FeaeN22DPgGX99ibrYMin60UdX13wb6Qu mjkbtADlYLym39n2VoHrTlD1F5oJga1IXjp1tSt Wi6UQBn1mYIy4umKWCvAEywabYk6bLzeNN6f32YbQfm3FRnN7rfXvFE2ilDQE3oqKqSaUUsbjTq0KYh3EjsbC CR8yKIFpHZUUkNULRU2VS0OM14W3 FgCiJdQCbd5BiEUViLYlKNGAa3Pna79KSYrul15RgDknrjlQOV94jmUyg33jGN6cGAvagkQ=")
