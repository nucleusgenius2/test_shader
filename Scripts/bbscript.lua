-- Body and gun
local TrueBase = piece "TrueBase"
local Base = piece "Base"
local Turret = piece "Turret"
local TurretLaser = piece "TurretMuzzle"
local Flare = piece "Flare"
local Pusher = piece "Pusher"
aimSpeed = 0.33
local bbmuzzleflash = SFX.CEG

function script.Create()
	
end

SIG_DELAYEDSTOP = 1
local SIG_AIM = 1

local function Restore()
Sleep(2000)
  Turn(Turret, y_axis, 0, aimSpeed)
    Turn(Turret, x_axis, 0, aimSpeed)
    WaitForTurn(Turret, y_axis)
	WaitForTurn(Turret, x_axis)
end

----aimining & fire weapon
function script.AimFromWeapon1() 
	return Turret
	
end

function script.QueryWeapon1() 
	return Flare 
end

function script.AimWeapon1( heading, pitch )
	Signal(SIG_AIM)
    SetSignalMask(SIG_AIM)
    --aiming animation: instantly turn the gun towards the enemy
    Turn(Turret, y_axis, heading, aimSpeed)
    Turn(Turret, x_axis, -pitch, aimSpeed)
    WaitForTurn(Turret, y_axis)
	StartThread(Restore)
    return true
end

function script.FireWeapon1()
	EmitSfx(Flare, bbmuzzleflash)
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