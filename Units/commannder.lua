local unitName  =  "commander"

local unitDef  =  {
--Internal settings
    BuildPic = "filename.png",
    Category = "TANK SMALL NOTAIR NOTSUB HOVER",
    ObjectName = "Commander.s3o",
    name = "Commander",
    Side = "Vroomers",
    TEDClass = "Vech",
    UnitName = "Commander",
    script = "commanderscript.lua",
	icontype = "commander",
--Unit limitations and properties
    Description = "Commander, Make sure not to lose it!",
    MaxDamage = 3750,
    idleTime = 0,
    idleAutoHeal = 10,
    RadarDistance = 2250,
    SightDistance = 600,
	sonarDistance = 2250,
    SoundCategory = "TANK",
    Upright = 0,
	corpse = [[commander_dead]],
	sfxtypes             = {
	explosionGenerators = {
	[[custom:buildermuzzleflash]],
	},
   },
--Energy and metal related
    BuildCostEnergy = 1000,
    BuildCostMetal = 1000,
    energyMake = 6,
	metalMake = 2,
	commander = true,
--Pathfinding and related
    maxAcc = 0.25,
    BrakeRate = 0.1,
    FootprintX = 4,
    FootprintZ = 4,
    MaxSlope = 45,
    MaxVelocity = 1.5,
    TurnRate = 1000,
	MovementClass = "Hover commander",
	floater = true,
	waterline = 5,

    
--Abilities
    CanAttack = 1,
    CanGuard = 1,
    CanMove = 1,
    CanPatrol = 1,
    CanStop = 1,
    LeaveTracks = 0,
    Reclaimable = 0,
    canSelfDestruct = 1,
    repairable = 1,
    onOffable =0,
   activateWhenBuilt = 1,
   canManualFire = 1,
   
--building
Builder = true,
ShowNanoSpray = true,
CanBeAssisted = true,	
workerTime = 15,
repairSpeed = 10,
reclaimSpeed = 15,
buildDistance = 200,
terraformSpeed = 9001,
buildoptions = 
	{
	[[edfarmoredplanttech1]],
	[[edfgeneratortech1]],
	[[edfmassstorage]],
	[[hunter]],
	[[rhino]]

	},

--Hitbox
   collisionVolumeOffsets    =  "0 -5 0",
   collisionVolumeScales     =  "51.5 46 61.5",
    collisionVolumeType       =  "box",

   
--Weapons and related
   explodeAs = [[CommanderExplosion]],
	selfDestructAs = [[CommanderExplosion]],
    NoChaseCategory = "AIR",
weapons = {
[1]={name  = "RapidCommanderLaser",
       turret = true
	},
[2]={name  = "CommanderTempDLaser",
       turret = true
	},
},



}

return lowerkeys({ [unitName]  =  unitDef })
