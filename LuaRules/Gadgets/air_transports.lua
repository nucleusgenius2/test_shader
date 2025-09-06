function gadget:GetInfo()
   return {
      name = "Air Transports Handler",
      desc = "Slows down transport depending on loaded mass and fixes unloaded units sliding bug",
      author = "raaar",
      date = "2015",
      license = "PD",
      layer = 0,
      enabled = true,
   }
end

local TRANSPORTED_MASS_SPEED_PENALTY = 0.45 -- higher makes unit slower
local FRAMES_PER_SECOND = 30

local TRANSPORT_SQDISTANCE_TOLERANCE = 1200 -- about 35 elmos 
local DROP_ALTITUDE_LIMIT = 150

local airTransports = {}
local airTransportMaxSpeeds = {}
local unloadedUnits = {}
local spSetUnitRulesParam  = Spring.SetUnitRulesParam	
local spGetUnitPosition = Spring.GetUnitPosition
local spSetUnitVelocity = Spring.SetUnitVelocity
local spGetUnitVelocity = Spring.GetUnitVelocity
local spSetUnitPhysics = Spring.SetUnitPhysics
local spSetUnitDirection = Spring.SetUnitDirection
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spGetUnitIsTransporting = Spring.GetUnitIsTransporting
			
local missileDefIds = {
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then
-- BEGIN SYNCED
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local massUsageFraction = 0
local allowedSpeed = 0
local currentMassUsage = 0
-- update allowed speed for transport
function updateAllowedSpeed(transportId, transportUnitDef)
	-- get sum of mass and size for all transported units                                
	currentMassUsage = 0
	for _,tUnitId in pairs(spGetUnitIsTransporting(transportId)) do
		local tUd = UnitDefs[Spring.GetUnitDefID(tUnitId)]
		-- currentCapacityUsage = currentCapacityUsage + tUd.xsize 
		currentMassUsage = currentMassUsage + tUd.mass
	end
	massUsageFraction = (currentMassUsage / transportUnitDef.transportMass)
	allowedSpeed = transportUnitDef.speed * (1 - massUsageFraction * TRANSPORTED_MASS_SPEED_PENALTY) / FRAMES_PER_SECOND 
	--Spring.Echo("unit "..transportUnitDef.name.." is air transport at  "..(massUsageFraction*100).."%".." load, curSpeed="..vw.." allowedSpeed="..allowedSpeed)

	airTransportMaxSpeeds[transportId] = allowedSpeed
	
	-- load factor used for thruster effect
	spSetUnitRulesParam(transportId,"transport_load_factor",tostring(massUsageFraction),{public = true})
end


-- add transports to table when they load a unit
function gadget:UnitLoaded(unitId, unitDefId, unitTeam, transportId, transportTeam)
	local ud = UnitDefs[Spring.GetUnitDefID(transportId)]
	if ud.canFly and not airTransports[transportId] then
		airTransports[transportId] = ud

		-- update allowed speed
		updateAllowedSpeed(transportId, ud)
	end
end

-- cleanup transports and unloaded unit tables when destroyed
function gadget:UnitDestroyed(unitId, unitDefId, teamId, attackerId, attackerDefId, attackerTeamId)
	if airTransports[unitId] then
		airTransports[unitId] = nil
	end
	if unloadedUnits[unitId] then
		unloadedUnits[unitId] = nil
	end
	if airTransportMaxSpeeds[unitId] then
		airTransportMaxSpeeds[unitId] = nil
	end
end

-- every frame, adjust speed of air transports according to transported mass, if any
function gadget:GameFrame(n)
    
	-- prevent unloaded units from sliding across the map
	-- TODO remove when fixed in the engine
	for unitId,data in pairs(unloadedUnits) do
    	if (n > data.frame + 10 ) then
			-- reset position
			Spring.SetUnitPhysics(unitId,data.px,data.py,data.pz,0,0,0,0,0,0,0,0,0)
			Spring.SetUnitDirection(unitId,data.dx,data.dy,data.dz)
			Spring.GiveOrderToUnit(unitId,CMD.MOVE,{data.px+10*data.dx,data.py,data.pz+10*data.dz},CMD.OPT_SHIFT)

			-- remove from table
			unloadedUnits[unitId] = nil
		end
	end
    
	-- for each air transport with units loaded, reduce speed if currently greater than allowed
	local factor = 1
	local vx,vy,vz,vw = 0
	local alSpeed = 0
	local spdMod = 0
	for unitId,ud in pairs(airTransports) do
		vx,vy,vz,vw = spGetUnitVelocity(unitId)
		if vw then 
			alSpeed = airTransportMaxSpeeds[unitId]
			
			-- apply the modifier from upgrades
			-- TODO put this on the area buff handler gadget instead
			--spdMod = spGetUnitRulesParam(unitId, "upgrade_speed")
			--if spdMod and spdMod ~= 0 then
			--	alSpeed = alSpeed * (1+spdMod)
			--end
			if (GG.speedModifierUnitIds) then
				spdMod = GG.speedModifierUnitIds[unitId]
				if (spdMod and spdMod ~= 0) then
					alSpeed = alSpeed * spdMod
				end
			end 
			
			if (alSpeed and vw > alSpeed) then
				factor = alSpeed / vw
				spSetUnitVelocity(unitId,vx * factor,vy * factor,vz * factor)
			end
		else
			-- transport invalid, cleanup table entries
			airTransports[unitId] = nil
			airTransportMaxSpeeds[unitId] = nil
		end
	end
	
end


function gadget:UnitUnloaded(unitId, unitDefId, teamId, transportId)
	if( not missileDefIds[unitDefId]) then
		-- prevent unloaded units from sliding across the map
		-- TODO remove when fixed in the engine
		if not unloadedUnits[unitId] then
			local px,py,pz = Spring.GetUnitPosition(unitId,false,false)
			local dx,dy,dz = Spring.GetUnitDirection(unitId)
			local frame = Spring.GetGameFrame()
			unloadedUnits[unitId] = {["px"]=px,["py"]=py,["pz"]=pz,["dx"]=dx,["dy"]=dy,["dz"]=dz,["frame"]=frame}
		end
	
		if airTransports[transportId] and not spGetUnitIsTransporting(transportId)[1] then
			-- transport is empty, cleanup tables
			airTransports[transportId] = nil
			airTransportMaxSpeeds[transportId] = nil
			
			spSetUnitRulesParam(unitId,"transport_load_factor","0",{public = true})
		else
			-- update allowed speed
			updateAllowedSpeed(transportId, airTransports[transportId])
		end
	end
end


------------------------ LOAD / UNLOAD workarounds for 104.0.1-1327 maintenance and later
local function sqDist(pos1, pos2)
	local difX = pos1[1] - pos2[1]
	local difY = pos1[2] - pos2[2]
	local difZ = pos1[3] - pos2[3]
	return difX^2 + difY^2 + difZ^2
end

local function sqDistXZ(pos1, pos2)
	local difX = pos1[1] - pos2[1]
	local difZ = pos1[3] - pos2[3]
	return difX^2 + difZ^2
end

function gadget:AllowUnitTransportLoad(transporterID, transporterUnitDefID, transporterTeam, transporteeID, transporteeUnitDefID, transporteeTeam, goalX, goalY, goalZ)

	local pos1 = {spGetUnitPosition(transporterID)}
	local pos2 = {goalX, goalY, goalZ}
	--Spring.Echo("load d=".. sqDist(pos1, pos2))
	if sqDist(pos1, pos2) > TRANSPORT_SQDISTANCE_TOLERANCE then
		return false
	end
	
	-- immobilized units are considered "stuck" and can't be lifted
	if GG.mobilityModifier and GG.mobilityModifier[transporteeID] == 0 then
		return false
	end
	
	spSetUnitVelocity(transporterID, 0,0,0)
	return true
end

function gadget:AllowUnitTransportUnload(transporterID, transporterUnitDefID, transporterTeam, transporteeID, transporteeUnitDefID, transporteeTeam, goalX, goalY, goalZ)

	local pos1 = {spGetUnitPosition(transporterID)}
	local pos2 = {goalX, goalY, goalZ}
	--Spring.Echo("unload d=".. sqDist(pos1, pos2))
	if sqDistXZ(pos1, pos2) > TRANSPORT_SQDISTANCE_TOLERANCE and pos1[2] > 0 then
		return false
	end
	-- limit drop altitude
	if ( pos1[2] > 0 and pos1[2] - pos2[2] > DROP_ALTITUDE_LIMIT ) then
		return false
	end
	spSetUnitVelocity(transporterID, 0,0,0)
	return true
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
else
-- END SYNCED
-- BEGIN UNSYNCED
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- nothing to do here
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end
-- END UNSYNCED
--------------------------------------------------------------------------------
