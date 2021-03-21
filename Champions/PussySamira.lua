if game.local_player.champ_name ~= "Samira" then
	return
end

-- [ AutoUpdate ]
do
    
    Version = 2
	file_name = "PussySamira.lua"
    url = "http://raw.githubusercontent.com/Astraanator/test/main/Champions/PussySamira.lua"	
   
    local function AutoUpdate()
        
        web_version = http:get("http://raw.githubusercontent.com/Astraanator/test/main/Champions/PussySamira.version")
        console:log(Version)
		console:log(web_version)
		if web_version == Version then
            console:log("PussySamira successfully loaded.....")
        else
			http:download_file(url, file_name)
            console:log("New PussySamira Update available.....")
			console:log("Please reload via F5.....")
        end
    
    end
    
    AutoUpdate()

end

pred:use_prediction()


local myHero = game.local_player
local UltAlly = false		
local CastedR = false
local RTime = game.game_time
local CastEQ = false

local function Ready(spell)
    return spellbook:can_cast(spell)
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
		if unit and not unit.is_enemy and unit.object_id ~= myHero.object_id then
			table.insert(_AllyHeroes, unit)
		end
	end
	return _AllyHeroes
end

local function IsValid(unit)
    if (unit and unit.is_targetable and unit.is_alive and unit.is_visible and unit.object_id and unit.health > 0) then
        return true
    end
    return false
end

local function GetDistanceSqr(unit, p2)
	p2 = p2.origin or myHero.origin	
	p2x, p2y, p2z = p2.x, p2.y, p2.z
	p1 = unit.origin
	p1x, p1y, p1z = p1.x, p1.y, p1.z	
	local dx = p1x - p2x
	local dz = (p1z or p1y) - (p2z or p2y)
	return dx*dx + dz*dz
end

local function GetEnemyCount(range, unit)
	count = 0
	for i, hero in ipairs(GetEnemyHeroes()) do
	Range = range * range
		if unit.object_id ~= hero.object_id and GetDistanceSqr(unit, hero) < Range and IsValid(hero) then
		count = count + 1
		end
	end
	return count
end

local function GetMinionCount(range, unit)
	count = 0
	minions = game.minions
	for i, minion in ipairs(minions) do
	Range = range * range
		if minion.is_enemy and IsValid(minion) and unit.object_id ~= minion.object_id and GetDistanceSqr(unit, minion) < Range then
			count = count + 1
		end
	end
	return count
end

local function GetQDmg(unit)
	local Damage = 0
	local level = spellbook:get_spell_slot(0).level
	local BonusDmg = ({0.8, 0.9, 1, 1.1, 1.2})[level] * myHero.total_attack_damage
	local QDamage = (({0, 5, 10, 15, 20})[level] + BonusDmg)
	Damage = unit:calculate_phys_damage(QDamage)
	return Damage
end

local function GetEDmg(unit)
	local Damage = 0
	local level = spellbook:get_spell_slot(2).level
	local BonusDmg = 0.2 * (myHero.total_attack_damage - myHero.base_attack_damage)
	local EDamage = (({50, 60, 70, 80, 90})[level] + BonusDmg)
	Damage = unit:calculate_magic_damage(EDamage)
	return Damage
end

PussySamira_category = menu:add_category("Pussy Samira")
PussySamira_enabled = menu:add_checkbox("Enabled", PussySamira_category, 1)
Pcombo_combokey = menu:add_keybinder("Combo Key", PussySamira_category, 32)

Pcombo = menu:add_subcategory("Combo Features", PussySamira_category)
Pcombo_useq = menu:add_checkbox("Use Q", Pcombo, 1)
Pcombo_usew = menu:add_checkbox("Use W", Pcombo, 1)
Pcombo_usee = menu:add_checkbox("Use E", Pcombo, 1)
Pcombo_user = menu:add_checkbox("Use R", Pcombo, 1)

Pharass = menu:add_subcategory("Harass Features", PussySamira_category)
Pharass_useq = menu:add_checkbox("Use Q", Pharass, 1)

Pclear = menu:add_subcategory("LaneClear Features", PussySamira_category)
Pclear_useq = menu:add_checkbox("Use Q melee", Pclear, 1)
Pclear_qcount = menu:add_slider("Min. minions for [Q]", Pclear, 1, 7, 3)

Pjclear = menu:add_subcategory("JungleClear Features", PussySamira_category)
Pjclear_useq = menu:add_checkbox("Use Q", Pjclear, 1)
Pjclear_usew = menu:add_checkbox("Use W", Pjclear, 1)

Pkill = menu:add_subcategory("KillSteal Features", PussySamira_category)
Pkill_useq = menu:add_checkbox("Use Q", Pkill, 1)
Pkill_usee = menu:add_checkbox("Use E", Pkill, 1)

local function CastQ(unit)
	pred_output = pred:predict(2600, 0.25, 950, 50, unit, true, true)
	if pred_output.can_cast then
		castPos = pred_output.cast_pos
		spellbook:cast_spell(SLOT_Q, 0.25, castPos.x, castPos.y, castPos.z) 			
		orbwalker:reset_aa()	
	end	
end	

local function Combo()
	if Ready(SLOT_R) and myHero:has_buff("samirarreadybuff") and menu:get_value(Pcombo_user) == 1 and menu:get_value(Pcombo_usee) == 1 and Ready(SLOT_E) then	
		for i, Ally in ipairs(GetAllyHeroes()) do 
			if Ally and myHero:distance_to(Ally.origin) <= 600 and IsValid(Ally) then
				if GetEnemyCount(600, myHero) == 0 and GetEnemyCount(600, Ally) >= 1 then
					if game.game_time - ReadyTimer <= 5.2 then
						Epos = Ally.origin
						Ex, Ey, Ez = Epos.x, Epos.y, Epos.z
						if spellbook:cast_spell(SLOT_E, 0.1, Ex, Ey, Ez) then					
							UltAlly = true
							CastedR = true
							spellbook:cast_spell(SLOT_R)
						end	
					end
				end
			end
		end
	end	
					
    	
	if UltAlly then return end
	target = selector:find_target(1000, health) 
	if target.object_id ~= 0 then	
		if Ready(SLOT_R) and myHero:has_buff("samirarreadybuff") and menu:get_value(Pcombo_user) == 1 then					
			
			if GetEnemyCount(1500, myHero) == 1 then
				if myHero:distance_to(target.origin) <= 500 then
					RTime = game.game_time
					CastedR = true
					spellbook:cast_spell(SLOT_R)
				else
					if menu:get_value(Pcombo_usee) == 1 and Ready(SLOT_E) then
						if myHero:distance_to(target.origin) <= 600 then
							Epos = target.origin
							Ex, Ey, Ez = Epos.x, Epos.y, Epos.z
							if spellbook:cast_spell(SLOT_E, 0.1, Ex, Ey, Ez) then				
								RTime = game.game_time
								CastedR = true
								spellbook:cast_spell(SLOT_R)
							end									
						end
					end	
				end
			else
				if GetEnemyCount(1500, myHero.pos) > 1 then
					if menu:get_value(Pcombo_usee) == 1 and Ready(SLOT_E) then
						if myHero:distance_to(target.origin) <= 600 and GetEnemyCount(600, target) >= 1 then
							Epos = target.origin
							Ex, Ey, Ez = Epos.x, Epos.y, Epos.z
							if spellbook:cast_spell(SLOT_E, 0.1, Ex, Ey, Ez) then					
								RTime = game.game_time
								CastedR = true
								spellbook:cast_spell(SLOT_R)
							end
						end
					else
						if myHero:distance_to(target.origin) <= 500 and GetEnemyCount(600, myHero) >= 2 then
							RTime = game.game_time
							CastedR = true
							spellbook:cast_spell(SLOT_R)	
						end	
					end
				end	
			end
		end			
		
		if CastedR then return end
		
		if menu:get_value(Pcombo_usee) == 1 and Ready(SLOT_E) then
			if myHero:distance_to(target.origin) <= 600 then					
				if menu:get_value(Pcombo_useq) == 1  and Ready(SLOT_Q) then
					Epos = target.origin
					Ex, Ey, Ez = Epos.x, Epos.y, Epos.z
					if spellbook:cast_spell(SLOT_E, 0.3, Ex, Ey, Ez) then					
						Qpos = target.origin
						Qx, Qy, Qz = Qpos.x, Qpos.y, Qpos.z				
						spellbook:cast_spell(SLOT_Q, 0.25, Qx, Qy, Qz) 
						orbwalker:reset_aa()
					end
				else
					E2pos = target.origin
					E2x, E2y, E2z = E2pos.x, E2pos.y, E2pos.z				
					spellbook:cast_spell(SLOT_E, 0.3, E2x, E2y, E2z)
				end	
			end
		end	
		
		if menu:get_value(Pcombo_usew) == 1 and Ready(SLOT_W) then
			if myHero:distance_to(target.origin) <= 325 then					
				spellbook:cast_spell(SLOT_W)
			end
		end			

		if menu:get_value(Pcombo_useq) == 1  and Ready(SLOT_Q) then 				 
			if menu:get_value(Pcombo_usee) == 1 and Ready(SLOT_E) and myHero:distance_to(target.origin) <= 600 then return end
			if myHero:distance_to(target.origin) <= 950 and myHero:distance_to(target.origin) > 325 then
				CastQ(target)		
			
			elseif myHero:distance_to(target.origin) < 325 then
				Qpos = target.origin
				Qx, Qy, Qz = Qpos.x, Qpos.y, Qpos.z				
				spellbook:cast_spell(SLOT_Q, 0.25, Qx, Qy, Qz) 
				orbwalker:reset_aa()					
			end				
		end
	end	
end

local function Harass() 
	target = selector:find_target(1000, health)   
	
	if target.object_id ~= 0 and menu:get_value(Pharass_useq) == 1 and Ready(SLOT_Q) then
		if myHero:distance_to(target.origin) <= 950 and myHero:distance_to(target.origin) > 325 then
			CastQ(target)		
		
		elseif myHero:distance_to(target.origin) < 325 then
			Qpos = target.origin
			Qx, Qy, Qz = Qpos.x, Qpos.y, Qpos.z				
			spellbook:cast_spell(SLOT_Q, 0.25, Qx, Qy, Qz) 
			orbwalker:reset_aa()	
		end           
	end	       
end

local function KillSteal()
	if not Ready(SLOT_Q) and CastEQ then CastEQ = false end
	for i, target in ipairs(GetEnemyHeroes()) do     	
		
		if target.object_id ~= 0 and myHero:distance_to(target.origin) <= 950 and IsValid(target) then
			local QDmg = GetQDmg(target)
			local EDmg = GetEDmg(target)
			
			if CastEQ then
				if CastedR then
					if myHero:distance_to(target.origin) > 500 then
						Epos = target.origin
						Ex, Ey, Ez = Epos.x, Epos.y, Epos.z
						if spellbook:cast_spell(SLOT_E, 0.3, Ex, Ey, Ez) then
							Qpos = target.origin
							Qx, Qy, Qz = Qpos.x, Qpos.y, Qpos.z				
							spellbook:cast_spell(SLOT_Q, 0.25, Qx, Qy, Qz) 
							orbwalker:reset_aa()
						end
					end
				else
					Epos = target.origin
					Ex, Ey, Ez = Epos.x, Epos.y, Epos.z
					if spellbook:cast_spell(SLOT_E, 0.3, Ex, Ey, Ez) then
						Qpos = target.origin
						Qx, Qy, Qz = Qpos.x, Qpos.y, Qpos.z				
						spellbook:cast_spell(SLOT_Q, 0.25, Qx, Qy, Qz) 
						orbwalker:reset_aa()
					end				
				end	
			end	
			
			if menu:get_value(Pkill_useq) == 1 and menu:get_value(Pkill_usee) == 1 and Ready(SLOT_Q) and Ready(SLOT_E) then
				if myHero:distance_to(target.origin) <= 600 then
					if QDmg+EDmg > target.health then
						CastEQ = true
					end
				end
			end
			
			if not CastEQ and menu:get_value(Pkill_useq) == 1 and Ready(SLOT_Q) then	 
				if myHero:distance_to(target.origin) <= 950 and myHero:distance_to(target.origin) > 325 and QDmg > target.health then
					CastQ(target)		
				
				elseif myHero:distance_to(target.origin) < 325 then
					Qpos = target.origin
					Qx, Qy, Qz = Qpos.x, Qpos.y, Qpos.z				
					spellbook:cast_spell(SLOT_Q, 0.25, Qx, Qy, Qz) 
					orbwalker:reset_aa()	
				end
			end
			
			if menu:get_value(Pkill_usee) == 1 and Ready(SLOT_E) then
				if myHero:distance_to(target.origin) <= 600 and EDmg > target.health then
					if CastedR then
						if myHero:distance_to(target.origin) > 500 then					
							Epos = target.origin
							Ex, Ey, Ez = Epos.x, Epos.y, Epos.z
							spellbook:cast_spell(SLOT_E, 0.1, Ex, Ey, Ez)
						end	
					else
						Epos = target.origin
						Ex, Ey, Ez = Epos.x, Epos.y, Epos.z
						spellbook:cast_spell(SLOT_E, 0.1, Ex, Ey, Ez)					
					end	
				end
			end
		end
	end	
end	

local function Clear()
	minions = game.minions
	for i, target in ipairs(minions) do               
	
		if menu:get_value(Pclear_useq) == 1 and Ready(SLOT_Q) then
			if target.object_id ~= 0 and target.is_enemy and myHero:distance_to(target.origin) < 325 and IsValid(target) then
				if GetMinionCount(500, target) >= menu:get_value(Pclear_qcount) then
					Qpos = target.origin
					Qx, Qy, Qz = Qpos.x, Qpos.y, Qpos.z				
					spellbook:cast_spell(SLOT_Q, 0.25, Qx, Qy, Qz) 
					orbwalker:reset_aa()				
				end
			end	
		end
	end	
end

local function JungleClear()
	minions = game.jungle_minions
	for i, target in ipairs(minions) do              
	
		if target.object_id ~= 0 and menu:get_value(Pjclear_useq) == 1 and Ready(SLOT_Q) and myHero:distance_to(target.origin) < 950 and IsValid(target) then				
			Qpos = target.origin
			Qx, Qy, Qz = Qpos.x, Qpos.y, Qpos.z				
			spellbook:cast_spell(SLOT_Q, 0.25, Qx, Qy, Qz) 
			orbwalker:reset_aa()	            
		
		elseif target.object_id ~= 0 and menu:get_value(Pjclear_usew) == 1 and Ready(SLOT_W) and myHero:distance_to(target.origin) < 325 and IsValid(target) then
			spellbook:cast_spell(SLOT_W) 
		end	
	end	
end

local function on_tick()

	if CastedR and game.game_time - RTime < 2.3 then 
		orbwalker:disable_auto_attacks()
	elseif CastedR then
		UltAlly = false
		CastedR = false
		orbwalker:enable_auto_attacks()
	end	
	
	local Mode = combo:get_mode()
	if game:is_key_down(menu:get_value(Pcombo_combokey)) then
		Combo()
	elseif Mode == MODE_HARASS then
		Harass()
	elseif Mode == MODE_LANECLEAR then
		Clear()
		JungleClear()
	end	
	
	KillSteal()
end

client:set_event_callback("on_tick", on_tick) 



--console:log("player.bonus_attack_damage: " .. tostring(player.bonus_attack_damage))