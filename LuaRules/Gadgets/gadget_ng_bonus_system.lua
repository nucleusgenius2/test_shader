function gadget:GetInfo()
    return {
        name    = "Bonus Connect Synced",
        desc    = "Проверяет коннекты зданий одного игрока, вызывает ShowTube и отправляет данные во второй гаджет",
        author  = "nucleus_genius",
        date    = "2025",
        layer   = 1,
        enabled = true
    }
end

if not gadgetHandler:IsSyncedCode() then return false end

local boosters, biggestBooster, boostables, biggestBoostable = {}, 0, {}, 0
for unitDefID, unitDef in pairs(UnitDefs) do
    if unitDef.customParams and unitDef.customParams.bonus then
        local size = math.max(unitDef.zsize, unitDef.xsize) / 2 * 8
        boosters[unitDefID] = size
        biggestBooster = math.max(biggestBooster, size)
    elseif unitDef.customParams and unitDef.customParams.boostable then
        local size = math.max(unitDef.zsize, unitDef.xsize) / 2 * 8
        boostables[unitDefID] = size
        biggestBoostable = math.max(biggestBoostable, size)
    end
end

local function areWeTouching(x1, z1, fx1, fz1, x2, z2, fx2, fz2)
    local dx, dz = x2 - x1, z2 - z1
    local TOLERANCE = 8
    local AXIS_TOLERANCE = 64
    if math.abs(dx) < (fx1 + fx2 + TOLERANCE) and math.abs(dz) < (fz1 + fz2 + TOLERANCE) then
        if math.abs(dx) >= math.abs(dz) then
            if math.abs(dz) <= AXIS_TOLERANCE then
                if dx < 0 then return "right" else return "left" end
            end
        else
            if math.abs(dx) <= AXIS_TOLERANCE then
                if dz < 0 then return "up" else return "down" end
            end
        end
    end
end

local flipSide = {left="right", right="left", up="down", down="up"}

local connectedUnits = {}

-- Получить ВСЕ customParams из bonus-юнита
local function getBonusCustomParams(unitID)
    local unitDefID = Spring.GetUnitDefID(unitID)
    if not unitDefID then return {} end
    -- Просто копируем всю таблицу customParams
    local cp = UnitDefs[unitDefID].customParams or {}
    local result = {}
    for k, v in pairs(cp) do
        result[k] = v
    end
    return result
end

-- Получить ВСЕ customParams из boostable-юнита
local function getBoostableCustomParams(unitID)
    local unitDefID = Spring.GetUnitDefID(unitID)
    if not unitDefID then return {} end
    local cp = UnitDefs[unitDefID].customParams or {}
    local result = {}
    for k, v in pairs(cp) do
        result[k] = v
    end
    return result
end

local function serializeBonusData(unitID, teamID, customParams, connected)
    local customStr = ""
    for k,v in pairs(customParams or {}) do
        customStr = customStr .. k .. "=" .. tostring(v) .. ";"
    end
    -- boostable: id,boostable=1,...,side=right,from=left;
    local connectedStr = ""
    for _,conn in ipairs(connected or {}) do
        connectedStr = connectedStr .. tostring(conn.id)
        for k,v in pairs(conn.customParams or {}) do
            connectedStr = connectedStr .. "," .. k .. "=" .. tostring(v)
        end
        if conn.side then
            connectedStr = connectedStr .. ",side=" .. tostring(conn.side)
        end
        if conn.from then
            connectedStr = connectedStr .. ",from=" .. tostring(conn.from)
        end
        connectedStr = connectedStr .. ";"
    end
    return string.format("BONUS_CONNECT:%d|%d|%s|%s", unitID, teamID, customStr, connectedStr)
end

function gadget:UnitFinished(unitID, unitDefID, teamID)
    local sizeToCheck, booster
    if boosters[unitDefID] then
        sizeToCheck = boosters[unitDefID] + biggestBoostable
        booster = true
    elseif boostables[unitDefID] then
        sizeToCheck = boostables[unitDefID] + biggestBooster
        booster = false
    else
        return
    end

    local x, y, z = Spring.GetUnitPosition(unitID)
    local nearUnits = Spring.GetUnitsInRectangle(x - sizeToCheck, z - sizeToCheck, x + sizeToCheck, z + sizeToCheck, teamID)

    local connected = {}

    if booster then
        for _, nearUnitID in ipairs(nearUnits) do
            if unitID ~= nearUnitID then
                local nearUnitDefID = Spring.GetUnitDefID(nearUnitID)
                if boostables[nearUnitDefID] then
                    local nx, ny, nz = Spring.GetUnitPosition(nearUnitID)
                    local side = areWeTouching(
                        x, z,
                        UnitDefs[unitDefID].xsize * 4, UnitDefs[unitDefID].zsize * 4,
                        nx, nz,
                        UnitDefs[nearUnitDefID].xsize * 4, UnitDefs[nearUnitDefID].zsize * 4
                    )
                    if side then
                        local scriptEnv = Spring.UnitScript.GetScriptEnv(unitID)
                        if scriptEnv and scriptEnv["ShowTube"] then
                            Spring.UnitScript.CallAsUnit(unitID, scriptEnv["ShowTube"], side)
                        end
                        local oppSide = flipSide[side]
                        local scriptEnv2 = Spring.UnitScript.GetScriptEnv(nearUnitID)
                        if scriptEnv2 and scriptEnv2["ShowTube"] then
                            Spring.UnitScript.CallAsUnit(nearUnitID, scriptEnv2["ShowTube"], oppSide)
                        end
                        connected[nearUnitID] = {side = oppSide, from = side}
                    end
                end
            end
        end

        if next(connected) then
            connectedUnits[unitID] = connected
            local myCustom = getBonusCustomParams(unitID)
            local connectInfo = {}
            for cid, sides in pairs(connected) do
                connectInfo[#connectInfo + 1] = {
                    id = cid,
                    customParams = getBoostableCustomParams(cid),
                    side = sides.side,
                    from = sides.from,
                }
            end
            local msg = serializeBonusData(unitID, teamID, myCustom, connectInfo)
            msg = 'BonusConnect|'..msg
            GG.BONUS_CONNECT(msg)
        end
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
    local myConns = connectedUnits[unitID]
    if myConns then
        for otherID, sideTbl in pairs(myConns) do
            local oppSide = sideTbl.side
            local scriptEnv2 = Spring.UnitScript.GetScriptEnv(otherID)
            if scriptEnv2 and scriptEnv2["ShowTube"] then
                Spring.UnitScript.CallAsUnit(otherID, scriptEnv2["ShowTube"], oppSide, false)
            end
        end
        connectedUnits[unitID] = nil
        local msg = 'BonusDisconnect|'..unitID..'|'..teamID
        GG.BONUS_CONNECT(msg)
    else
        for boosterID, list in pairs(connectedUnits) do
            if list[unitID] then
                local sideTbl = list[unitID]
                local oppSide = sideTbl.side
                local scriptEnv = Spring.UnitScript.GetScriptEnv(boosterID)
                if scriptEnv and scriptEnv["ShowTube"] then
                    Spring.UnitScript.CallAsUnit(boosterID, scriptEnv["ShowTube"], oppSide, false)
                end
                list[unitID] = nil
            end
        end
    end
end
