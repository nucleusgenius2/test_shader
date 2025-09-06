local unitName  =  "hunter"

local unitDef  =  {
    --Внутренние настройки
    BuildPic = "Hunter.png",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "model_for_test/Hunter.s3o",
    name = "Охотник 2",
    Side = "Vroomers",
    TEDClass = "Vech",
    UnitName = "Охотник",
   -- script = "EDF/land/scriptHunter.lua",
	icontype = "raider",
	mass = 100,
    --Ограничения и свойства блока
    BuildTime = 1280,
    Description = "Быстрый юнит рейдер.",
    MaxDamage = 320,
    idleTime = 300,
    idleAutoHeal = 0, --реген хп
    RadarDistance = 0,
    SightDistance = 560,
    SoundCategory = "TANK",
    Upright = 0,
	explodeAs = [[SmallExplosion]], -- взрыв после смерти юнита
	selfDestructAs = [[SmallExplosion]], -- взрыв после самоуничтожения
	sfxtypes = {
	    explosionGenerators = {
	        [[custom:huntermuzzleflash]],
	        [[custom:Sparks]],
	        [[custom:BuildSmoke]],
	        [[custom:projectile_blue_explosion_1]]
	    },
    }, -- массив эффектов, которые можно юзать в скрипте юнита
    corpse = [[hunter_dead]],
    --Энергетика и металлы
    BuildCostEnergy = 75,
    BuildCostMetal = 75,
    BuildTime = 75,
    --Поиск пути и связанные с ним
    --maxAcc = 0.20, --ускорение
    maxAcc = 0.03572, --ускорение
    maxDec = 0.07144, -- макс торможение
    BrakeRate = 0.35,

    FootprintX = 3, --область выделения юнита
    FootprintZ = 6,

    MaxSlope = 20, -- макс угол на который можно заехать
    MaxVelocity = 2.3, --макс скорость движения
    MaxWaterDepth = 5,
  MovementClass = "Large Hover",

    TurnRate = 500, --скорость поворота

    usePieceCollisionVolumes = true, -- коллизию считать по модели

    crushable = false, -- есть в баре

    --Способности
    Builder = 0,
    CanAttack = 1,
    CanGuard = 1,
    CanMove = 1,
    CanPatrol = 1,
    CanStop = 1,
    LeaveTracks = 1,
    Reclaimable = 1,
    canSelfDestruct = 1,
    repairable = 1,


    --Hitbox
    collisionVolumeOffsets =  "0 0 -2",
    collisionvolumescales  = "40 20 75", --2 значение ширина, последнее длинна
    collisionVolumeType    =  "box",


    --Оружие и связанное с ним
    NoChaseCategory = "AIR",

    weapons = {
        [1]={
            name = "HunterWeapons",
            turret = true
        },
    },
    --для следов
    tracktype = "huntertrack",
    trackOffset            = 0,
    trackStrength          = 8,
    trackStretch           = 1,
    trackWidth             = 30,
   -- turnRate               = 1920,

   --pushResistant = 1,

    customParams = {
        --едф стройка
        edfunit = 1,


        techlevel = 2,
        modelradius = 20,

        --описание параметров юнита
        mass = 75,
        energy = 75,
        buildtime = 75,
        xp = 320,
        regeneration = 0,
        targetType = 1, --1 тока ленд, 2 тока аир, 3 все.
        attack_1 = true,
        attack_1_target ='land',
        attack_1_count = 1,
        attack_1_type = 'turret',
        attack_1_damage = 10,
        attack_1_reload = 1,
        attack_1_radius = 100,
        attack_1_min_radius = 0,

        --гусеницы
        normaltex = "UnitTextures/bitmaps/Normals.dds",
        trackshader = 'trackShader',
        tankvel = 1.0,
        turnrate = 0.0,
        trackwidth = 0.1, --процент от верха текстуры

        loc_key_name = "name_hunter",
        loc_key_description = "description_hunter"
    }
}

return lowerkeys({ [unitName]  =  unitDef })
