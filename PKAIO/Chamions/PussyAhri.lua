local MenuValue = 1

local function GetMinionCount(range, MenuValue)
	if MenuValue == 0 then
		return 3
	end	
	count = 0
	minions = game.minions
	for i, minion in ipairs(minions) do
	Range = range * range
		if minion.is_enemy and IsValid(minion) and GetDistanceSqr(myHero.origin, minion.origin) < Range then
			count = count + 1
		end
	end
	return count
end

PussyAhri_category = menu:add_category_sprite("PussyAhri", "PussyFolder/PkMenu.png")
menu:add_label("Welcome "..client.username.." !!!", PussyAhri_category)
menu:add_label("Version "..tonumber(Version), PussyAhri_category)
	
PussyAhri_enabled = menu:add_checkbox("Enabled", PussyAhri_category, 1)
Pcombo_combokey = menu:add_keybinder("Combo Key", PussyAhri_category, 32)
Pcombomode_key = menu:add_keybinder("Start Combo with E On/Off", PussyAhri_category, string.byte("M"))

---Prediction---
Ppred = menu:add_subcategory("Prediction Features", PussyAhri_category)
	pred_table = {}
	pred_table[1] = "Bruh Pred."
	pred_table[2] = "Ark Pred."
	Ppred_mode = menu:add_combobox("Pred. Selection", Ppred, pred_table, 1)
	
	Ppred_ark = menu:add_subcategory("Ark Pred. Settings", Ppred)
		Ppred_q = menu:add_subcategory("Q Settings", Ppred_ark)
			q_hitchance = menu:add_slider("Q HitChance [%]", Ppred_q, 1, 99, 50)
			q_range = menu:add_slider("Q Max-Range ", Ppred_q, 300, 880, 800)
			q_radius = menu:add_slider("Q Radius >> Default = 100 <<", Ppred_q, 80, 120, 100)
			q_speed = menu:add_slider("Q Speed >> Default = 2500 <<", Ppred_q, 2300, 2700, 2500)		
			
		Ppred_e = menu:add_subcategory("E Settings", Ppred_ark)
			e_hitchance = menu:add_slider("E HitChance [%]", Ppred_e, 1, 99, 50)
			e_range = menu:add_slider("E Max-Range ", Ppred_e, 300, 1000, 900)
			e_radius = menu:add_slider("E Radius >> Default = 60 <<", Ppred_e, 40, 80, 60)
			e_speed = menu:add_slider("E Speed >> Default = 1550 <<", Ppred_e, 1350, 1750, 1550)

Pcombo = menu:add_subcategory("Combo Features", PussyAhri_category)
	Pcombo_useq = menu:add_checkbox("Use Q", Pcombo, 1)
	Pcombo_usew = menu:add_checkbox("Use W", Pcombo, 1)
	Pcombo_usee = menu:add_checkbox("Use E", Pcombo, 1)
	Pcombo_user = menu:add_checkbox("Use R to MousePos", Pcombo, 1)
	Pcombo_useItem = menu:add_checkbox("Use Item(Everfrost)", Pcombo, 1)
	

Pharass = menu:add_subcategory("Harass Features", PussyAhri_category)
Pharass_useq = menu:add_checkbox("Use Q", Pharass, 1)
Pharass_usew = menu:add_checkbox("Use W", Pharass, 1)
Pharass_usee = menu:add_checkbox("Use E", Pharass, 1)

Pclear = menu:add_subcategory("LaneClear Features", PussyAhri_category)
Pclear_useq = menu:add_checkbox("Use Q", Pclear, 1)
Pclear_qcount = menu:add_slider("Min. minions for Q", Pclear, 1, 7, 2)
Pclear_usew = menu:add_checkbox("Use W", Pclear, 1)
Pclear_usew2 = menu:add_checkbox("Only W if min 3 minions near", Pclear, 1)

Pjclear = menu:add_subcategory("JungleClear Features", PussyAhri_category)
Pjclear_useq = menu:add_checkbox("Use Q", Pjclear, 1)
Pjclear_usew = menu:add_checkbox("Use W", Pjclear, 1)

Pmisc = menu:add_subcategory("Misc Features", PussyAhri_category)
Pmisc_wrange = menu:add_slider("W Cast-Range", Pmisc, 200, 750, 600)
Pmisc_usee = menu:add_checkbox("Auto E on Gapclosing Enemies", Pmisc, 1)
Pmisc_useItem = menu:add_checkbox("AutoCast Everfrost on Feared Enemy", Pmisc, 1)


PSpell_range = menu:add_subcategory("Drawing Features", PussyAhri_category)
Pdraw_cd = menu:add_checkbox("Draw only if ready", PSpell_range, 1)
Pdraw_q = menu:add_checkbox("Draw Q range", PSpell_range, 0)
Pdraw_w = menu:add_checkbox("Draw W range", PSpell_range, 0)
Pdraw_e = menu:add_checkbox("Draw E range", PSpell_range, 0)

local QPred_input = {
    source = myHero,
    speed = menu:get_value(q_speed), 
	range = menu:get_value(q_range),
    delay = 0.25, 
	radius = menu:get_value(q_radius),
    collision = {"wind_wall"},
    type = "linear", 
	hitbox = false
}

local EPred_input = {
    source = myHero,
    speed = menu:get_value(e_speed), 
	range = menu:get_value(e_range),
    delay = 0.25, 
	radius = menu:get_value(e_radius),
    collision = {"minion", "wind_wall", "enemy_hero"},
    type = "linear", 
	hitbox = true
}

local ItemPred_input = {
    source = myHero,
    speed = 1600, 
	range = 800,
    delay = 0.15, 
	radius = 40,
    collision = {},
    type = "linear", 
	hitbox = false
}


local function CastQ(unit)
	if menu:get_value(Ppred_mode) == 0 then	
		pred_output = pred:predict(menu:get_value(q_speed), 0.25, menu:get_value(q_range), menu:get_value(q_radius), unit, true, false)
		if pred_output.can_cast then
			castPos = pred_output.cast_pos
			spellbook:cast_spell(SLOT_Q, 0.3, castPos.x, castPos.y, castPos.z) 
		end
	else
		pred_output = arkpred:get_prediction(QPred_input, unit)
		if pred_output.hit_chance >= menu:get_value(q_hitchance)/100 then
			castPos = pred_output.cast_pos
			spellbook:cast_spell(SLOT_Q, 0.3, castPos.x, castPos.y, castPos.z)
		end
	end			
end

local function CastE(unit)
	if menu:get_value(Ppred_mode) == 0 then	
		pred_output = pred:predict(menu:get_value(e_speed), 0.25, menu:get_value(e_range), menu:get_value(e_radius), unit, true, true)
		if pred_output.can_cast then
			castPos = pred_output.cast_pos
			spellbook:cast_spell(SLOT_E, 0.3, castPos.x, castPos.y, castPos.z) 
		end
	else
		pred_output = arkpred:get_prediction(EPred_input, unit)
		if pred_output.hit_chance >= menu:get_value(e_hitchance)/100 then
			castPos = pred_output.cast_pos
			spellbook:cast_spell(SLOT_E, 0.3, castPos.x, castPos.y, castPos.z)
		end
	end		
end

local function CastEverFrost(unit, ItemSlot)
	if menu:get_value(Ppred_mode) == 0 then	
		pred_output = pred:predict(1600, 0.25, 800, 40, unit, false, false)
		if pred_output.can_cast then
			castPos = pred_output.cast_pos
			spellbook:cast_spell(ItemHotKey[ItemSlot], 0.3, castPos.x, castPos.y, castPos.z) 
		end
	else
		pred_output = arkpred:get_prediction(ItemPred_input, unit)
		if pred_output.hit_chance >= 0.5 then
			castPos = pred_output.cast_pos
			spellbook:cast_spell(ItemHotKey[ItemSlot], 0.3, castPos.x, castPos.y, castPos.z)
		end
	end
end

local function BuffActive()
    if menu:get_value(Pmisc_useItem) == 0 then return end
	
	local Everfrost = GetInventorySlotItem(6656)	
	if not Everfrost then return end	
	
	for i, target in ipairs(GetEnemyHeroes()) do
		if IsValid(target) and GetDistance(target.origin, myHero.origin) < 800 then
			local Buffs = target.buffs
			for k, buff in pairs(Buffs) do
				if buff.is_valid and buff.type == 23 then
					local time = buff.duration - 0.6
					client:delay_action(function() CastEverFrost(target, Everfrost) end, time)
				end
			end	
		end
	end	
end

local function Clear()
	if menu:get_value(Pclear_useq) == 1 and Ready(SLOT_Q) then
		minions = game.minions
		for i, minion in ipairs(minions) do
		
			if myHero:distance_to(minion.origin) < 880 and minion.is_enemy and IsValid(minion) then					
				local Count = GetLineTargetCount(myHero, minion, 0.25, 2500, 100, 880)
				if Count >= menu:get_value(Pclear_qcount) then	
					spellbook:cast_spell(SLOT_Q, 0.2, minion.origin.x, minion.origin.y, minion.origin.z)
				end					 
			end
		end
	end

	if menu:get_value(Pclear_usew) == 1 and Ready(SLOT_W) then					
		local Count = GetMinionCount(600, menu:get_value(Pclear_usew2))
		if Count >= 3 then	
			spellbook:cast_spell(SLOT_W, 0.2)
		end					 
	end	
end

function JungleClear()
	if menu:get_value(Pjclear_useq) == 1 and Ready(SLOT_Q) then
		minions = game.jungle_minions
		for i, minion in ipairs(minions) do
		
			if myHero:distance_to(minion.origin) <= 880 and IsValid(minion) then					
				spellbook:cast_spell(SLOT_Q, 0.3, minion.origin.x, minion.origin.y, minion.origin.z) 	 
			end
		end
	end
	
	if menu:get_value(Pjclear_usew) == 1 and Ready(SLOT_W) then
		minions = game.jungle_minions
		for i, minion in ipairs(minions) do
		
			if myHero:distance_to(minion.origin) <= 600 and IsValid(minion) then					
				spellbook:cast_spell(SLOT_W, 0.3) 	 
			end
		end
	end	
end	

local QObject = nil
local EObject = nil

local function on_tick()
	--console:log(tostring(menu:get_value(PEF, PussyAct_category)))
	if menu:get_value(PussyAhri_enabled) == 1 then
		
		if menu:get_value(Pcombo_useItem) == 1 then
			if menu:get_value(PEF, PussyAct_category) and menu:get_value(PEF, PussyAct_category) == 1 then
				menu:set_value(PEF, 0)
			end
		end			
				
		if MyHeroReady() then          						
			local Mode = combo:get_mode()
			local ComboMode = game:is_key_down(menu:get_value(Pcombo_combokey))
			local HarassMode = Mode == MODE_HARASS
			local ClearMode = Mode == MODE_LANECLEAR

			if ClearMode then
				Clear()
				JungleClear()
			end

			if Ready(SLOT_E) then
				
				if (ComboMode and menu:get_value(Pcombo_usee) == 1) or (HarassMode and menu:get_value(Pharass_usee) == 1) then
					local ETarget = selector:find_target(menu:get_value(e_range), mode_health)
					if IsValid(ETarget) then
					
						if CastE(ETarget) then
							return
						end
					end
				end

				if ComboMode and MenuValue == 1 then
					return
				end
			end

			BuffActive()

			if Ready(SLOT_Q) then
				if (ComboMode and menu:get_value(Pcombo_useq) == 1) or (HarassMode and menu:get_value(Pharass_useq) == 1) then
					local QTarget = selector:find_target(menu:get_value(q_range), mode_health)
					if IsValid(QTarget) then
					
						if CastQ(QTarget) then
							return
						end
					end
				end
			end

			if Ready(SLOT_W) then
				if (ComboMode and menu:get_value(Pcombo_usew) == 1) or (HarassMode and menu:get_value(Pharass_usew) == 1) then
					local WTarget = selector:find_target(menu:get_value(Pmisc_wrange), mode_health)
					if IsValid(WTarget) then 

						if WTarget:health_percentage() < 40 then
							spellbook:cast_spell(SLOT_W, 0.3)
						elseif not Ready(SLOT_Q) and not Ready(SLOT_E) then
							spellbook:cast_spell(SLOT_W, 0.3)
						end
					end
				end
			end
			
			if Ready(SLOT_R) and not Ready(SLOT_Q) and not QObject then
				if ComboMode and menu:get_value(Pcombo_user) == 1 then
					local Target = selector:find_target(1500, mode_health)
					if IsValid(Target) then 
						spellbook:cast_spell(SLOT_R, 0.3, game.mouse_pos.x, game.mouse_pos.y, game.mouse_pos.z)
					end
				end
			end			
			
			if EObject then return end
			if Ready(SLOT_E) then return end
			if ComboMode and menu:get_value(Pcombo_useItem) == 1 then
				local Everfrost = GetInventorySlotItem(6656)
				if (ComboMode and Everfrost) then
					local target = selector:find_target(750, mode_health)
					if IsValid(target) and not target:has_buff_type(23) then
						CastEverFrost(target, Everfrost)
						return
					end	
				end
			end					
		end	
	end	
end

local function on_draw()	
	screen_size = game.screen_size
	
	if MenuValue == 1 then
		renderer:draw_text_big_centered(screen_size.width - menu:get_value(PTextX), screen_size.height - menu:get_value(PTextY), "StartCombo(E): On", 50, 205, 50, 255)
	else
		renderer:draw_text_big_centered(screen_size.width - menu:get_value(PTextX), screen_size.height - menu:get_value(PTextY), "StartCombo(E): Off", 220, 20, 60, 255)
	end
	
	if file_manager:directory_exists("PussyFolder") then
		if file_manager:file_exists("PussyFolder/PK-Image.png") and sprite ~= nil and game.game_time <= 10 then
			sprite:draw(screen_size.width / 90, -600 )
		end
	end

	local_player = game.local_player
	if local_player.object_id ~= 0 then
		origin = local_player.origin
		x, y, z = origin.x, origin.y, origin.z

		if menu:get_value(Pdraw_cd) == 1 then
			if menu:get_value(Pdraw_q) == 1 and Ready(SLOT_Q) then
				renderer:draw_circle(x, y, z, menu:get_value(q_range), 0, 137, 255, 255)
			end
			
			if menu:get_value(Pdraw_w) == 1 and Ready(SLOT_W) then
				renderer:draw_circle(x, y, z, menu:get_value(Pmisc_wrange), 0, 137, 110, 255)
			end			
			
			if menu:get_value(Pdraw_e) == 1 and Ready(SLOT_E) then
				renderer:draw_circle(x, y, z, menu:get_value(e_range), 0, 225, 180, 255)
			end		
		else
			if menu:get_value(Pdraw_q) == 1 then
				renderer:draw_circle(x, y, z, menu:get_value(q_range), 0, 137, 255, 255)
			end
			
			if menu:get_value(Pdraw_w) == 1 then
				renderer:draw_circle(x, y, z, menu:get_value(Pmisc_wrange), 0, 137, 110, 255)
			end			
			
			if menu:get_value(Pdraw_e) == 1 then
				renderer:draw_circle(x, y, z, menu:get_value(e_range), 0, 225, 180, 255)
			end
		end		
	end		
end

local function on_wnd_proc(msg, wparam)
	if game.is_chat_opened or game.is_shop_opened then return end
	if msg ~= 256 then return end		
	
	if menu:get_value(Pcombomode_key) == wparam then
		MenuValue = MenuValue % 2 + 1
	end
end

local function on_object_created(object, obj_name, object_type)
	if object then
		--console:log(tostring(object_type))
		if (obj_name == "AhriOrbMissile" or obj_name == "AhriOrbReturn") then
			QObject = object
		end
		if obj_name == "AhriSeduceMissile" then
			EObject = object
		end
	end
end

local function on_object_deleted(object, obj_name, object_type)
	if object then
		if (obj_name == "AhriOrbMissile" or obj_name == "AhriOrbReturn") then
			QObject = nil			
		end
		if obj_name == "AhriSeduceMissile" then
			EObject = nil			
		end		
	end
end

local function on_gap_close(obj, data)
	if menu:get_value(Pmisc_usee) == 0 then return end
	if not Ready(SLOT_E) then return end
	if not obj.is_hero then return end
	if not obj.is_enemy then return end
	if not data then return end
	if GetDistance(myHero.origin, data.end_pos) <= 500 and data.end_time - game.game_time <= 0.5 then
		spellbook:cast_spell(SLOT_E, 0.2, data.end_pos.x, data.end_pos.y, data.end_pos.z)
	end
end

client:set_event_callback("on_gap_close", on_gap_close)
client:set_event_callback("on_object_deleted", on_object_deleted)
client:set_event_callback("on_object_created", on_object_created)
client:set_event_callback("on_wnd_proc", on_wnd_proc)
client:set_event_callback("on_tick", on_tick)
client:set_event_callback("on_draw", on_draw)