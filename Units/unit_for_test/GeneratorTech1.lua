local unitName  =  "edfgeneratortech1"

local unitDef  =  {
    --Internal settings
BuildPic = "Hover Factory.png",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "model_for_test/GeneratorTech1.dae",
    name = "Генератор",
    Side = "Vroomers",
    TEDClass = "Building",
    UnitName = "Генератор",
    script = "script_for_test/scriptGeneratorTech1.lua",
	icontype = "buildingenergy",
    --Unit limitations and properties
    Description = "Basic Energy generator (2E).",
    MaxDamage = 500,
    damageModifier = 0.25,
    idleTime = 0,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 400,
    SoundCategory = "Building",
    Upright = 0,
	maxWaterDepth = 4,
	showNanoFrame = false; --отключает стандартную анимацию строительства
    sfxtypes = {
        explosionGenerators = {
    	    [[custom:SparksBig]],
    	    [[custom:BuildSmokeBig]]
        },
    },
	corpse = [[solarpanel_dead]],
    --Energy and metal related
    BuildCostEnergy = 75,
    BuildCostMetal = 75,
    Buildtime = 75,
	--2 energy
    energyMake = 500,

    --Size and Abilites
   MaxSlope = 33,

   FootprintX = 6,
   FootprintZ = 6,

   canSelfDestruct = 1,
   repairable = 1,
   CanMove = 0,
   CanPatrol = 0,
   onOffable = 1,
   activateWhenBuilt = 1,

    collisionVolumeScales     =  "170 98 175",
   --Hitbox
   collisionVolumeOffsets    =  "0 0 0",
   collisionVolumeScales     =  "60 70 60",
   collisionVolumeType       =  "box",
   YardMap = "oooooo oooooo oooooo oooooo",
   --Weapons and related
   explodeAs = [[MediumBuildingExplosion]],
   selfDestructAs = [[MediumBuildingExplosion]],

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
       hp_unit_level_1 = "1" -- от апгрейда
   }


}

return lowerkeys({ [unitName]  =  unitDef })
