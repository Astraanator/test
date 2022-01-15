arkpred = _G.Prediction
pred:use_prediction()

local myHero = game.local_player
local ItemHotKey = {[1] = SLOT_ITEM1, [2] = SLOT_ITEM2,[3] = SLOT_ITEM3, [4] = SLOT_ITEM4, [5] = SLOT_ITEM5, [6] = SLOT_ITEM6}

local function Ready(spell)
    return spellbook:can_cast(spell) 
end

local function IsValid(unit)
    if (unit and unit.is_targetable and unit.is_alive and unit.is_visible and unit.object_id ~= 0 and unit.health > 0 and IsKillable(unit)) then
        return true
    end
    return false
end

local function GetDistanceSqr(p1, p2)
	return (p1.x - p2.x) *  (p1.x - p2.x) + ((p1.z or p1.y) - (p2.z or p2.y)) * ((p1.z or p1.y) - (p2.z or p2.y)) 
end

local function GetDistance(p1, p2)
	return math.sqrt(GetDistanceSqr(p1, p2))
end

local function DirectionMag(vec, mag)
    x, y, z = vec.x, vec.y, vec.z
    new_x = mag * x 
    new_y = mag * y 
    new_z = mag * z 
    output = vec3.new(new_x, new_y, new_z)
    return output
end

local function VectorAdd(vec1, vec2)
    new_x = vec1.x + vec2.x
    new_y = vec1.y + vec2.y
    new_z = vec1.z + vec2.z
    add = vec3.new(new_x, new_y, new_z)
    return add
end					
				
local function VectorSub(vec1, vec2)
    new_x = vec1.x - vec2.x
    new_y = vec1.y - vec2.y
    new_z = vec1.z - vec2.z
    sub = vec3.new(new_x, new_y, new_z)
    return sub
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

local function GetInventorySlotItem(itemID)
    for i, Item in ipairs(myHero.items) do 
		if Item.item_id == itemID and Ready(Item.spell_slot) then return Item.slot end
    end
    return nil
end

local function VectorPointProjectionOnLineSegment(v1, v2, v)
	local cx, cy, ax, ay, bx, by = v.x, v.z, v1.x, v1.z, v2.x, v2.z
	local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) ^ 2 + (by - ay) ^ 2)
	local pointLine = { x = ax + rL * (bx - ax), y = ay + rL * (by - ay) }
	local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
	local isOnSegment = rS == rL
	local pointSegment = isOnSegment and pointLine or { x = ax + rS * (bx - ax), y = ay + rS * (by - ay) }
	return pointSegment, pointLine, isOnSegment
end

local function GetTargetMS(target)
	local ms = target.path.is_dashing and target.path.dash_speed or target.move_speed
	return ms
end

local function PredictUnitPosition(unit, delay)
	local predictedPosition = unit.origin
	local timeRemaining = delay
	local pathNodes = {}
	if unit.path.is_moving then
		pathNodes = unit.path.current_waypoints
	else	
		table.insert(pathNodes, unit.origin)
	end
	
	for i = 1, #pathNodes -1 do
		local nodeDistance = GetDistance(pathNodes[i], pathNodes[i +1])
		local nodeTraversalTime = nodeDistance / GetTargetMS(unit)
			
		if timeRemaining > nodeTraversalTime then
			timeRemaining =  timeRemaining - nodeTraversalTime
			predictedPosition = pathNodes[i + 1]
		else
			local directionVector = VectorSub(pathNodes[i+1], pathNodes[i]):normalized()
			predictedPosition = DirectionMag(DirectionMag(VectorAdd(pathNodes[i], directionVector), GetTargetMS(unit)), timeRemaining)
			break;
		end
	end
	return predictedPosition
end

local function GetLineTargetCount(source, Pos, delay, speed, width, range)
	local Count = 0
	minions = game.minions
	for i, minion in ipairs(minions) do 
		if minion.is_enemy and myHero:distance_to(minion.origin) < range and IsValid(minion) then
			
			local predictedPos = PredictUnitPosition(minion, (delay + GetDistance(source.origin, minion.origin) / speed))
			local proj1, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(source.origin, Pos.origin, predictedPos)
			if proj1 and isOnSegment and (GetDistanceSqr(predictedPos, proj1) <= (minion.bounding_radius + width) * (minion.bounding_radius + width)) then
				Count = Count + 1
			end
		end
	end
	return Count
end

local function MyHeroReady()
	if myHero.is_recalling or game.is_chat_opened or game.is_shop_opened or evade:is_evading() then
		return false
	end
	return true
end
