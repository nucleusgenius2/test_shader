local unitName  =  "edfmassstorage"

local unitDef  =  {
    --Internal settings
    BuildPic = "Hover Factory.png",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "model_for_test/MassStorage.dae",
    name = "Storage",
    Side = "Vroomers",
    TEDClass = "Building",
    UnitName = "Storage",
    script = "script_for_test/scriptStorageScript.lua",
	icontype = "buildingstorage",
    --Unit limitations and properties
    Description = "Stores 500 of each reasource.",
    MaxDamage = 500,
    idleTime = 600,
    idleAutoHeal = 2,
    RadarDistance = 0,
    SightDistance = 600,
    SoundCategory = "Building",
    Upright = 0,
    floater = true,
	corpse = [[storage_dead]],
    --Energy and metal related
    BuildCostEnergy = 100,
    BuildCostMetal = 100,
    buildTime = 100,
	metalStorage = 1000,
	--energyStorage = 20000,
    --Size and Abilites
    MaxSlope = 33,
    FootprintX = 3,
    FootprintZ = 3,
    canSelfDestruct = 1,
    repairable = 1,
    CanAttack = 1,
    CanGuard = 1,
    CanStop = 1,
    CanMove = 0,
    CanPatrol = 0,

    --Hitbox
    collisionVolumeOffsets    =  "0 15 0",
    collisionVolumeScales     =  "25 42 25",
    collisionVolumeType       =  "box",
    --    collisionVolumeType       =  "box",
    YardMap = "ooooooooo",
    --Weapons and related
    explodeAs = [[SmallBuildingExplosion]],
    elfDestructAs = [[SmallBuildingExplosion]],

    sfxtypes = {
        explosionGenerators = {
        	[[custom:SparksBig]],
        	[[custom:BuildSmokeBig]]
        },
    },


    customParams = {

        bonus = true,
        bonus_mass = true,
        bonus_energy = false,
        bonus_buildtime = false,
        bonus_mass_discount = true,
        bonus_energy_discount = true,

            --едф стройка
            edfunit = 1,
            normaltex = "",

            techlevel = 1,

            --апгрейды
            hp_level_1 = "1" -- от апгрейда
    }

}

return lowerkeys({ [unitName]  =  unitDef })
