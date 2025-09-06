function gadget:GetInfo()
    return {
        name    = "Bonus Connect Storage",
        desc    = "Хранит информацию о связях бонусных зданий по игрокам и применяет бонусы.",
        author  = "nucleus_genius",
        date    = "2025",
        layer   = 0,
        enabled = true,
    }
end

local json = VFS.Include("LuaRules/Utilities/json.lua")

if not gadgetHandler:IsSyncedCode() then return end

local playerBonusConnections = {}

-- Надёжный split (НЕ теряет пустые поля)
local function split(str, sep)
    local t = {}
    local from = 1
    while true do
        local to = string.find(str, sep, from, true)
        if to then
            table.insert(t, string.sub(str, from, to-1))
            from = to + 1
        else
            table.insert(t, string.sub(str, from))
            break
        end
    end
    return t
end

local function parseCustomParams(str)
    local tbl = {}
    for pair in string.gmatch(str, "([^;]+)") do
        local k, v = pair:match("([^=]+)=([^=]+)")
        if k and v then
            if v == "true" then v = true elseif v == "false" then v = false elseif tonumber(v) then v = tonumber(v) end
            tbl[k] = v
        end
    end
    return tbl
end

local function parseConnected(str)
    local t = {}
    for unitBlock in string.gmatch(str or "", "([^;]+)") do
        local conn = {}
        local first = true
        for chunk in string.gmatch(unitBlock, "([^,]+)") do
            if first then
                conn.id = tonumber(chunk)
                first = false
            else
                local k, v = chunk:match("([^=]+)=([^=]+)")
                if k and v then
                    if v == "true" then v = true elseif v == "false" then v = false elseif tonumber(v) then v = tonumber(v) end
                    conn[k] = v
                end
            end
        end
        if conn.id then table.insert(t, conn) end
    end
    return t
end

local function getBaseParams(unitID)
    local unitDefID = Spring.GetUnitDefID(unitID)
    if not unitDefID then return {} end
    local cp = UnitDefs[unitDefID].customParams or {}
    return {
        base_mass = tonumber(cp.base_production_mass or 0),
        base_energy = tonumber(cp.base_production_energy or 0),
        base_buildspeed = tonumber(cp.base_buildspeed or 0),
    }
end

-- Собираем итоговые бонусы для здания по всем бонус-юнитам
local function CalcBonusesForBoostable(teamID, boostableID)
    local allBonuses = {
        mass = 1,
        energy = 1,
        buildtime = 1,
        mass_discount = 0,
        energy_discount = 0,
    }
    local techLevelMultiplier = 1

    local bonusConnections = playerBonusConnections[teamID] or {}
    for bonusUnitID, data in pairs(bonusConnections) do
        if data.customParams and data.connected then
            for _, conn in ipairs(data.connected) do
                if conn.id == boostableID then
                    local bonus = data.customParams
                    local boostable = conn.customParams
                    if bonus.bonus_mass and boostable.boostable_mass then
                        allBonuses.mass = allBonuses.mass * tonumber(boostable.boostable_mass or 1)
                    end
                    if bonus.bonus_energy and boostable.boostable_energy then
                        allBonuses.energy = allBonuses.energy * tonumber(boostable.boostable_energy or 1)
                    end
                    if bonus.bonus_buildtime and boostable.boostable_buildtime then
                        allBonuses.buildtime = allBonuses.buildtime * tonumber(boostable.boostable_buildtime or 1)
                    end
                    if bonus.bonus_mass_discount and boostable.boostable_mass_discount then
                        allBonuses.mass_discount = allBonuses.mass_discount + tonumber(boostable.boostable_mass_discount or 0)
                    end
                    if bonus.bonus_energy_discount and boostable.boostable_energy_discount then
                        allBonuses.energy_discount = allBonuses.energy_discount + tonumber(boostable.boostable_energy_discount or 0)
                    end
                    local techlevel = tonumber(bonus.techlevel or 1)
                    local boostable_tech = tonumber(boostable["boostable_tech_"..techlevel] or 1)
                    techLevelMultiplier = techLevelMultiplier * boostable_tech
                end
            end
        end
    end

    allBonuses.mass = allBonuses.mass * techLevelMultiplier
    allBonuses.energy = allBonuses.energy * techLevelMultiplier
    allBonuses.buildtime = allBonuses.buildtime * techLevelMultiplier

    return allBonuses
end

-- Применить бонусы к юниту
local function ApplyBonusesToBoostable(teamID, boostableID, bonuses)
    local base = getBaseParams(boostableID)
    -- Если нет базы — не применяем
    if (base.base_mass == 0 and base.base_energy == 0 and base.base_buildspeed == 0) then
        Spring.Echo("[BonusStorage] Нет base_* customParams у юнита "..boostableID)
        return
    end
    -- Устанавливаем новые параметры
    if base.base_mass > 0 then
        Spring.SetUnitResourcing(boostableID, "m", base.base_mass * bonuses.mass)
    end
    if base.base_energy > 0 then
        Spring.SetUnitResourcing(boostableID, "e", base.base_energy * bonuses.energy)
    end
    if base.base_buildspeed > 0 then
        Spring.SetUnitBuildSpeed(boostableID, base.base_buildspeed * bonuses.buildtime)
    end
    -- скидки логируем, а применять ты можешь в билдере (см. ниже)
    Spring.Echo("[BonusStorage] APPLY to " .. boostableID .. " bonuses: " .. json.encode(bonuses))
end

local function BONUS_CONNECT(msg)
    local parts = split(msg, "|")
    if parts[1] == "BonusConnect" and parts[2]:sub(1,14) == "BONUS_CONNECT:" then
        local unitID = tonumber(parts[2]:sub(15))
        local teamID = tonumber(parts[3])
        if unitID == nil or teamID == nil then
            Spring.Echo("Ошибка: unitID или teamID nil", tostring(unitID), tostring(teamID))
            return
        end
        local customParams = parseCustomParams(parts[4] or "")
        local connected = parseConnected(parts[5] or "")
        local data = {
            type = "BonusConnect",
            unitID = unitID,
            teamID = teamID,
            customParams = customParams,
            connected = connected,
        }
        playerBonusConnections[teamID] = playerBonusConnections[teamID] or {}
        playerBonusConnections[teamID][tostring(unitID)] = data
        Spring.Echo("[BonusStorage] FULL OBJECT (connect): " .. json.encode(playerBonusConnections))

        -- Автоматически применяем бонусы
        for _, conn in ipairs(connected) do
            local bonuses = CalcBonusesForBoostable(teamID, conn.id)
            ApplyBonusesToBoostable(teamID, conn.id, bonuses)
        end

    elseif parts[1] == "BonusDisconnect" then
        local unitID = tonumber(parts[2])
        local teamID = tonumber(parts[3])
        if not unitID or teamID == nil then
            Spring.Echo("Ошибка Disconnect: unitID или teamID nil", tostring(unitID), tostring(teamID))
            return
        end
        if playerBonusConnections[teamID] then
            playerBonusConnections[teamID][tostring(unitID)] = nil
        end
        Spring.Echo("[BonusStorage] FULL OBJECT (disconnect): " .. json.encode(playerBonusConnections))
    else
        Spring.Echo("[BonusStorage] Неизвестное сообщение:", tostring(msg))
    end
end

function gadget:Initialize()
    GG.BONUS_CONNECT = BONUS_CONNECT
end

function gadget:GetPlayerBonusConnections(teamID)
    return playerBonusConnections[teamID]
end
