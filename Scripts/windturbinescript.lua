-- Body and gun
local TrueBase = piece "TrueBase"
local Base = piece "Base"
local TurbineHolder = piece "TurbineHolder"


function script.Create()
	Spin(TurbineHolder, z_axis, math.rad(90))
end

function script.WindChanged(heading,strength)

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