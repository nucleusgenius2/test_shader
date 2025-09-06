local Base = piece "Base"
local Tube_Down = piece "Tube_Down"
local Tube_Left = piece "Tube_Left"
local Tube_Right = piece "Tube_Right"
local Tube_Up = piece "Tube_Up"
local Vent = piece "Vent"



 --рабочий пример получение данных из гаджета
function ShowTube(direction)
    Spring.Echo('пришли данные'..direction)
    if direction == "down" then
        Show(Tube_Down)
    elseif direction == "up" then
        Show(Tube_Up)
    elseif direction == "left" then
        Show(Tube_Left)
    elseif direction == "right" then
        Show(Tube_Right)
    end
end


--дым и огонь если меньше 30% хп для зданий
local function SmokeLoop()
  while true do
    local health = Spring.GetUnitHealth(unitID) --получить хп юнита, макс и текущее
    local maxHealth = UnitDefs[unitDefID].health

    if health and maxHealth and health < 0.3 * maxHealth then
      EmitSfx(Vent, SFX.CEG)
      EmitSfx(Vent, SFX.CEG+1)
    end
    Sleep(1000)
  end
end



function script.Create()
    Hide(Tube_Down)
    Hide(Tube_Left)
    Hide(Tube_Right)
    Hide(Tube_Up)

    StartThread(WaitForBuildComplete)
end


function WaitForBuildComplete()
    -- Ждём, пока юнит полностью достроится
    while Spring.GetUnitIsStunned(unitID) do
        Sleep(250)
    end

    -- Запускаем дымовой эффект
    StartThread(SmokeLoop)
end



---death animation
function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode (TrueBase, SFX.SHATTER)
	local severity = recentDamage / maxHealth
	if severity <= 0.33 then
	    return 1
	else
	    return 2
	end
end

