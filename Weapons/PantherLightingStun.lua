local weaponName = "PantherLightningGunStun"
weaponDef = {
	weaponType              = "LightningCannon",
	name                    = "Lightning Gun",
	beamlaser               = 1,
	--physics / aiming--
	beamTTL 				= 16,
	range                   = 275,
	reloadtime              = 2.85,
	targetMoveError         = 0.1,
	turret                  = true,
	paralyzeTime = 3.75,
	paralyzer = true,
	--damage--
	damage                  = {
		default = 300,        
		},
	areaOfEffect            = 0,
	craterBoost             = 0,
	craterMult              = 0,
	avoidFeature			= false,
	--apperance--	
	thickness               = 8,
	soundStart = [[Weapons/lightning1]],
	soundStartVolume = 4,
	rgbColor                = [[0.35 0.6 1]],
	explosionGenerator = [[custom:pantherhit]]
--texture1                = [[largelaser]],
	--texture2                = [[flare]],
	--texture3                = [[flare]],
	--texture4                = [[smallflare]],	
	}
return lowerkeys({[weaponName] = weaponDef})