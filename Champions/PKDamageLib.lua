--[[

Usage:

---- Add this to your Champion Script ----

>>>>> This check Users scripts Folder if the Lib available and download if Lib does not exist <<<<<
-----------------------------------------------------------------------------------------------------
if not file_manager:file_exists("PKDamageLib.lua") then
	local file_name = "PKDamageLib.lua"
	local url = "http://raw.githubusercontent.com/Astraanator/test/main/Champions/PKDamageLib.lua"   	
	http:download_file(url, file_name)
end
-----------------------------------------------------------------------------------------------------




>>>>> With this command your script has access to the PKDamageLib <<<<< 
----------------------------
require "PKDamageLib" 
---------------------------- 




---- PKDamageLib API ----

>>>>>> Params: <<<<<<

getdmg("spell", target, source, stage)

spell == "Q" or "W" or "E" or "R" or "QM" or "WM" or "EM"   
		 "QM"/"WM"/"EM" == like Nidalee, Grar or Elise different Forms
		 "AA" <-- calculate Autoattack damage
		 "IGNITE" <-- calculate Ignite damage
		 "SMITE" <-- calculate Smite damage ///// stage 1 = "SummonerSmite" ///// stage 2 = "S5_SummonerSmiteDuel" or spellName == "S5_SummonerSmitePlayerGanker" ////
		 
target == I don't have to explain

source == game.local_player

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

--/////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////

--- Return if unit not killable or has buff like Sion ---

--Example add to your code /// Global: IsKillable(unit) 

local function CastQ()
	for i, target in ipairs(GetEnemyHeroes()) do     	
		if target.object_id ~= 0 then				
			if IsKillable(target) then  <--- return true if killable
				>>>>CastQ	
			end		
		end
	end
end	

]]


-- [ AutoUpdate ]
do  
    local function AutoUpdate()
		local Version = 22
		local file_name = "PKDamageLib.lua"
		local url = "http://raw.githubusercontent.com/Astraanator/test/main/Champions/PKDamageLib.lua"        
        local web_version = http:get("http://raw.githubusercontent.com/Astraanator/test/main/Champions/PKDamageLib.version")
		if tonumber(web_version) == Version then
            console:log("PKDamageLib successfully loaded.....")
        else
			http:download_file(url, file_name)
            console:log("New PKDamageLib Update available.....")
			console:log("Please reload via F5.....")
        end
    
    end
    
    AutoUpdate()

end

local function GetPercentHP(unit)
  return unit:health_percentage( )
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
	if unit:has_buff_type(23) then
		return true
	end
	return false
end

local function GetBaseHealth(unit)
    if unit.champ_name == "Chogath" then
        return 574.04 + 80 * unit.level
		
    elseif unit.champ_name == "Volibear" then
        return 580 + 65 * unit.level		
    end	
end


-->>>>>>>>>>>>>>>>>>>> GameVersion 11.22 <<<<<<<<<<<<<<<<<<<<<<<<<--

local DamageLibTable = {
  ["Aatrox"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({10, 30, 50, 70, 90})[level] + ({0.6, 0.65, 0.7, 0.75, 0.8})[level] * source.total_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 40, 50, 60, 70})[level] + 0.4 * source.total_attack_damage end},
  },

  ["Ahri"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + 0.35 * source.ability_power end},
    {Slot = "Q", Stage = 2, DamageType = 3, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + 0.35 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + 0.3 * source.ability_power end},
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({12, 19.5, 27, 34.5, 42})[level] + 0.09 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + 0.4 * source.ability_power end},
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
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return (({50, 80, 110, 140, 170})[level] + 0.5 * source.ability_power) * (GotBuff(target, "chilled") and 2 or 1) end},
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
    {Slot = "R", Stage = 1, DamageType = 3, Damage = function(source, target, level) return ({300, 475, 650})[level] + 0.5 * source.ability_power + 0.1 * (source.max_health - GetBaseHealth(source)) end},
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
    {Slot = "R", Stage = 1, DamageType = 3, Damage = function(source, target, level) return ({100, 200, 300})[level] + 0.75 * source.bonus_attack_damage end},
  },

  ["Diana"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + 0.7 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({18, 30, 42, 54, 66})[level] + 0.15 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 60, 80, 100, 120})[level] + 0.4 * source.ability_power end},	
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({200, 300, 400})[level] + 0.6 * source.ability_power end},
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
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 97, 134, 171, 208})[level] + 0.85 * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({20, 30, 40, 50, 60})[level] + 0.2 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({30, 50, 70, 90, 110})[level] + 0.55 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + source.ability_power end},
  },

  ["Heimerdinger"] = {
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level] + 0.45 * source.ability_power end},
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({135, 180, 225})[source:get_spell_slot(SLOT_R).level] + 0.45 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({100, 200, 300})[source:get_spell_slot(SLOT_R).level] + 0.6 * source.ability_power end},
  },
  
  ["Illaoi"] = {
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return 0.02 * source.total_attack_damage / 100 + ({0.03, 0.035, 0.04, 0.045, 0.05})[level] * target.max_health end},
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
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({55, 85, 115, 145, 175})[level] + 0.5 * source.ability_power + (({0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35})[source.level] * source.ms) end},
  },

  ["JarvanIV"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({90, 130, 170, 210, 250})[level] + 1.2 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.8 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({200, 325, 450})[level] + 1.8 * source.bonus_attack_damage end},
  },

  ["Jax"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({65, 105, 145, 185, 225})[level] + source.bonus_attack_damage + 0.6 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({40, 75, 110, 145, 180})[level] + 0.6 * source.ability_power end},
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
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({30, 55, 80, 105, 130})[level] + 1.3 * source.total_attack_damage + 0.7 * source.ability_power end},
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return 0.025 * source.ability_power + ((target.max_health - target.health) / 100 * 15) end},	
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
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 105, 130, 155, 180})[level] + 0.8 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 100, 120})[level] + 0.4 * source.ability_power + 0.02 * source.mana end},
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({40, 50, 60})[level] + 0.1 * source.ability_power + 0.01 * source.mana end},-- per stack
  },

  ["Katarina"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 105, 135, 165, 195})[level] + 0.3 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({15, 30, 45, 60, 75})[level] + 0.25 * source.ability_power + 0.5 * source.total_attack_damage end},   
	{Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({25, 37.5, 50})[level] + 0.19 * source.ability_power end}, -- calc for 1 Dagger
    {Slot = "R", Stage = 2, DamageType = 2, Damage = function(source, target, level) return ({375, 562.5, 750})[level] + 2.85 * source.ability_power end},
	{Slot = "R", Stage = 3, DamageType = 1, Damage = function(source, target, level) return 0.16 * source.bonus_attack_damage + 0.128 * source.bonus_attack_speed end}, -- calc for 1 Dagger
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
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) local count = GotBuff(target, "kalistaexpungemarker") if count > 0 then return (({20, 30, 40, 50, 60})[level] + 0.7 * (source.total_attack_damage)) + ((count - 1)*(({10, 16, 22, 28, 34})[level]+({0.23, 0.27, 0.315, 0.36, 0.405})[level] * (source.total_attack_damage))) end; return 0 end},	
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
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({90, 165, 240, 315, 390})[level] + source.bonus_attack_damage * 1.8 end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 30, 40, 50, 60})[level] + (({0.045, 0.05, 0.055, 0.06, 0.065})[level] + (0.05*source.bonus_attack_damage)) * target.max_health end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({35, 60, 85, 110, 135})[level] + source.bonus_attack_damage * 0.6 end},
  },

  ["Leblanc"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({65, 90, 115, 140, 165})[level] + 0.4 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 115, 155, 195, 235})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 70, 90, 110, 130})[level] + 0.3 * source.ability_power end},
  },

  ["LeeSin"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({55, 80, 105, 130, 155})[level] + source.bonus_attack_damage end},
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({55, 80, 105, 130, 155})[level] + source.bonus_attack_damage + 0.01 * (target.max_health - target.health) end},
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
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 120, 170, 220, 270})[level] + 0.7 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({300, 400, 500})[level] + source.ability_power end},
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
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({25, 60, 95, 130, 165})[level] + 0.9 * source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 3, Damage = function(source, target, level) return ({30, 40, 50, 60, 70})[level] + 0.35 * source.bonus_attack_damage end},
  },

  ["MissFortune"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 40, 60, 80, 100})[level] + 0.35 * source.ability_power + source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 115, 150, 185, 220})[level] + 0.8 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return 0.75 * source.total_attack_damage + 0.2 * source.ability_power end},
  },

  ["MonkeyKing"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 45, 70, 95, 120})[level] + 0.45 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + 0.8 * source.ability_power end},
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
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({65, 110, 155, 200, 245})[level] + 0.75 * source.bonus_attack_damage end},
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
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + source.bonus_attack_damage end},
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
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + 0.4 * source.armor + 0.4 * source.bonusMagicResist end},
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
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({85, 135, 185, 235, 285})[level] + 0.6 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({105, 135, 165, 195, 225})[level] + source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({250, 250, 250, 250, 250, 250, 290, 330, 370, 400, 430, 450, 470, 490, 510, 530, 540, 550})[source.level] + 0.8 * source.bonus_attack_damage + 1.5 * source.armor_pen end},
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
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return 0.4 * source.total_attack_damage end},
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
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + 0.5 * source.bonus_attack_damage + 0.7 * source.ability_power end},--BURROWED 		
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({55, 70, 85, 100, 115})[level] + 0.8 * source.bonus_attack_damage end},--BURROWED   
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({50, 60, 70, 80, 90})[level] + 0.85 * source.bonus_attack_damage end},--UNBURROWED 
    {Slot = "E", Stage = 1, DamageType = 3, Damage = function(source, target, level) return ({100, 120, 140, 160, 180})[level] + 1.7 * source.bonus_attack_damage end},--UNBURROWED + Max FURY 
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({100, 250, 400})[level] + 1.75 * source.bonus_attack_damage + ({20, 25, 30})[level] / 100 * (target.max_health - target.health) end},
  }, 

  ["Rell"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.5 * source.ability_power end}, 		
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + 0.6 * source.ability_power end}, -- if mounted  
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.3 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({120, 200, 280})[level] + 1.1 * source.ability_power end},
  },  

  ["Renekton"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({65, 100, 135, 170, 205})[level] + 0.8 * source.bonus_attack_damage end},
    {Slot = "Q", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({100, 150, 200, 250, 300})[level] + 1.2 * source.bonus_attack_damage end},--REIGN OF ANGER	
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({10, 30, 50, 70, 90})[level] + 1.5 * source.total_attack_damage end},
    {Slot = "W", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({15, 45, 75, 105, 135})[level] + 2.25 * source.total_attack_damage end},--REIGN OF ANGER
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({40, 70, 100, 130, 160})[level] + 0.9 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({40, 70, 100, 130, 160})[level] + 0.9 * source.total_attack_damage * 1.5 end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({20, 40, 60})[level] + 0.1 * source.ability_power end},--per half Second
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
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({75, 100, 125, 150, 175})[level] + 0.4 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 80, 100, 120, 140})[level] + 0.3 * source.ability_power  end},
  },
  
  ["Samira"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({0, 5, 10, 15, 20})[level] + ({0.8, 0.9, 1, 1.1, 1.2})[level] * source.total_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 35, 50, 65, 80})[level] + 0.8 * source.bonus_attack_damage end}, -- 1 Hit
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 60, 70, 80, 90})[level] + 0.2 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({100, 200, 300})[level] + 6 * source.total_attack_damage end},	-- Full Damage
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
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({55, 75, 95, 115, 135})[level] + 0.4 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.7 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({35, 70, 105, 140, 175})[level] + 0.25 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({35, 50, 65})[level] + 0.14 * source.ability_power end},--per Second
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
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 105, 150, 195, 240})[level] + 0.65 * source.ability_power end},
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
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({7, 8, 9, 10, 11})[level] + 0.25 * source.ability_power end},
    {Slot = "W", Stage = 2, DamageType = 2, Damage = function(source, target, level) return (({3, 3.5, 4, 4.5, 5})[level] / 100 + 0.02 * source.ability_power / 100) * target.max_health end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + 0.9 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 200, 250})[level] + source.ability_power end},
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
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + 0.8 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({30, 50, 70, 90, 110})[level] + ({45, 75, 105, 135, 165})[level] + 0.4 * source.ability_power end},
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
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + source.ability_power + source.total_attack_damage end},
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
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({45, 65, 85, 105, 125})[level] + 0.5 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({55, 65, 75, 85, 95})[level] + 0.6 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({200, 300, 400})[level] + source.bonus_attack_damage end},
  },  

  ["Xerath"] = {
    {Slot = "Q", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + 0.85 * source.ability_power end},
    {Slot = "W", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + 0.6 * source.ability_power end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + 0.45 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({200, 250, 300})[level] + 0.43 * source.ability_power end},
  },

  ["XinZhao"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({16, 25, 34, 43, 52})[level] + 0.4 * source.bonus_attack_damage end},
    {Slot = "W", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + 1.1 * source.total_attack_damage + 0.5 * source.ability_power end},	
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level] + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({75, 175, 275})[level] + source.bonus_attack_damage + 1.1 * source.ability_power + 0.15 * target.health end},
  },

  ["Yasuo"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 45, 70, 95, 120})[level] + source.total_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({60, 70, 80, 90, 100})[level] + 0.2 * source.bonus_attack_damage + 0.6 * source.ability_power end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({200, 350, 500})[level] + 1.5 * source.bonus_attack_damage end},
  },
  
  ["Yone"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({20, 40, 60, 80, 100})[level] + source.total_attack_damage end},
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

  ["Zed"] = {
    {Slot = "Q", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({80, 115, 150, 185, 220})[level] + 1.1 * source.bonus_attack_damage end},
    {Slot = "E", Stage = 1, DamageType = 1, Damage = function(source, target, level) return ({70, 90, 110, 130, 150})[level] + 0.65 * source.bonus_attack_damage end},
    {Slot = "R", Stage = 1, DamageType = 1, Damage = function(source, target, level) return source.total_attack_damage end},
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
	if unit:has_buff_type(16) or unit:has_buff_type(18) or unit:has_buff("sionpassivezombie") then
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
								return target:calculate_phys_damage(spells.Damage(source, target, level)) - target:calculate_phys_damage(spells.Damage(source, target, level))*0.3
							else
								return target:calculate_phys_damage(spells.Damage(source, target, level))
							end
						elseif spells.DamageType == 2 then
							if Buff.count > 0 and Buff.source_id == target.object_id then
								return target:calculate_magic_damage(spells.Damage(source, target, level)) - target:calculate_magic_damage(spells.Damage(source, target, level))*0.3
							else
								return target:calculate_magic_damage(spells.Damage(source, target, level))
							end
						elseif spells.DamageType == 3 then
							if Buff.count > 0 and Buff.source_id == target.object_id then
								return spells.Damage(source, target, level) - spells.Damage(source, target, level)*0.3
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
		if Buff.count > 0 and Buff.source_id == target.object_id then
			return target:calculate_phys_damage(source.total_attack_damage) - target:calculate_phys_damage(source.total_attack_damage)*0.3
		else
			return target:calculate_phys_damage(source.total_attack_damage)
		end
	end
	if spell == "IGNITE" and IsKillable(target) then
		if Buff.count > 0 and Buff.source_id == target.object_id then
			return (50+20*source.level - (target.health_regen*3)) - (50+20*source.level - (target.health_regen*3)*0.3)
		else
			return 50+20*source.level - (target.health_regen*3)
		end
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
