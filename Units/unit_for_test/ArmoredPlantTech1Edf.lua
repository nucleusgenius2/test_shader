local unitName  =  "edfarmoredplanttech1"

local unitDef  =  {
    --Internal settings
BuildPic = "Hover Factory.png",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "model_for_test/ArmoredPlant.dae",
    name = "EDF Armored Plant",
    Side = "Vroomers",
    TEDClass = "Building",
    UnitName = "EDF Armored Plant",
   -- script = "EDF/buildings/scriptArmoredPlantTech1Edf.lua",
	corpse = [[groundfactory_dead]],
	icontype = "buildinglandfactory",
    --Unit limitations and properties
    Description = "Makes ground units.",
    MaxDamage = 3500,
    idleTime = 0,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 600,
    SoundCategory = "Building",
    Upright = 1,
	maxWaterDepth = 4,
	showNanoFrame = false; --отключает стандартную анимацию строительства
	sfxtypes             = {
        explosionGenerators = {
	        [[custom:Sparks]],
	        [[custom:BuildSmoke]]
        },
    },
    --Energy and metal related
    BuildCostEnergy = 750,
    BuildCostMetal = 750,
    Buildtime = 750, 
    --Size and Abilites
    MaxSlope = 33,

    FootprintX = 12,
    FootprintZ = 16,

   --FootprintX = 8,
  -- FootprintZ = 11,

    canSelfDestruct = 1,
    repairable = 1,
   -- CanMove = 1,
    CanPatrol = 0,
    --Building
    Builder = true,
    canBeAssisted = true,
    canAssist = false,
    ShowNanoSpray = true,
    CanBeAssisted = true,
    canCapture = false,
    canResurrect = false,
    canReclaim = false,
    canRepair = true,
    canRestore = false,
    workerTime = 10,
    buildoptions =
    {
       [[hunter]],
       [[swamper]],
       [[shell]],
       [[typhoon-t]],
       [[paladin]],
       [[zenith_9]],

	},
	--Hitbox
    collisionVolumeOffsets    =  "0 0 -7.5",
    collisionVolumeScales     =  "170 98 175",
    collisionVolumeType       =  "box",
	--YardMap = "oooooooo oooooooo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo yyyyyyyy",
    YardMap =
    "oooooooooooo" .. -- 1 (добавлено)
    "oooooooooooo" .. -- 2 (добавлено)
    "oooooooooooo" .. -- 3 (добавлено)
    "oooooooooooo" .. -- 4 (добавлено)
    "oooooooooooo" .. -- 5 (добавлено)
    "oooooooooooo" .. -- 6 (добавлено)
    "oooooooooooo" .. -- 7 (оригинал 1)
    "oooooooooooo" .. -- 8 (оригинал 2)
    "oeeeeeeeeeeo" .. -- 9 (оригинал 3)
    "oeeeeeeeeeeo" .. -- 10
    "oeeeeeeeeeeo" .. -- 11
    "oeeeeeeeeeeo" .. -- 12
    "oeeeeeeeeeeo" .. -- 13
    "oeeeeeeeeeeo" .. -- 14
    "oeeeeeeeeeeo" .. -- 15
    "oeeeeeeeeeeo" , -- 16

    buildingMask = 1,

    --Weapons and related
	explodeAs = [[FactoryExplosion]],
	selfDestructAs = [[FactoryExplosion]],


	 energyMake = 100,

	customParams = {
   	   boostable = true,
       boostable_mass = 1, --множитель
       boostable_energy = 2, --множитель
       boostable_buildtime = 3, --множитель
       boostable_mass_discount = 50, --проценты
       boostable_energy_discount = 50, --проценты
       boostable_tech_2 = 1.1,--множитель всех бонус если пристроен т2

       show_resources = true,

   	   --строитель едф
       builder_type = 'edf',

	   --едф стройка
       edfunit = 1,
       normaltex = "",

       --тех левел
       techlevel = 1,

       --для меню
       mass = 75,
       energy = 75,
       buildtime = 75,

       loc_key_name = "name_hunter"
    }

}

return lowerkeys({ [unitName]  =  unitDef })
