Config = {}

Config.defaultlang = "de_lang"

-- Webhook Settings

Config.WebHook = false

Config.WHTitle = 'Robbery:'
Config.WHLink = ''  -- Discord WH link Here
Config.WHColor = 16711680 -- red
Config.WHName = 'Robbery:' -- name
Config.WHLogo = '' -- must be 30x30px
Config.WHFooterLogo = '' -- must be 30x30px
Config.WHAvatar = '' -- must be 30x30px

-- Script Settings

-- Cooldown Settings
-- Global Cooldowns for Robbery only 1 Robbery or Bank at a Time
Config.RobberyCooldown = 15 -- Time in Min
Config.BankCooldown = 30 -- Time in Min

-- Reset Robbed Locations

Config.ResetAllLocationsTime = 60 -- Time in Min i Recommended 60 mins or Higher it Resets on Server Restart Anyway

-- OnDuty Settings

Config.synSociety = false -- If You Use SYN Society and go OnDuty in Syn
Config.VorpDutySystem = true -- VORP DUtySystem
Config.DLSociety = false -- DL Society
Config.EZSociety = false -- EZ Society
Config.BCCSociety = false -- BCC Society
Config.SSPoliceJob = false -- SSPolice

-- xsound Settings Stores
Config.PlayAlarms = true
Config.Title = 'Alarm'
Config.Volume = 0.2
Config.EmbedLink = 'https://www.youtube.com/watch?v=qrNZrr9lD7k' -- Embed Link
Config.Radius = 250
Config.AlarmDuration = 10 -- time in Secouns

-- xsoundbomd
Config.TitleBomb = 'Dynamite'
Config.EmbedLinkBomb = 'https://www.youtube.com/watch?v=_u__1jsSeBc'
Config.VolumeBomb = 0.5
Config.AlarmDurationBomb = 10

-- Lockpick Settings

Config.DestroyLockpickOnSuccess = true
Config.DestroyLockpickChance = 50 -- Chance in % to Loose Lockpick on Success

Config.DestroyLockpickOnFail = true

Config.PoliceJobs = {
    { Job = 'police' },
    { Job = 'marshall' },
    { Job = 'deputy' },
    { Job = 'sheriff' },
    { Job = 'BWPolice' },
}

Config.CopModel = 'CS_VALSHERIFF'

Config.RobberyLocations = {
    { -- Blackwater General Store
        Type = 'Store',
        Name = 'Blackwater General Store',
        LockpickItem = 'lockpick',
        Locations = {
            { Coord = vector3(-789.28, -1326.11, 44.0) },
            { Coord = vector3(-783.2,  -1326.48, 44.0) },
            { Coord = vector3(-780.0,  -1321.43, 44.0) },
        },
        Safe = {math.random(0,99),math.random(0,99),math.random(0,99)}, -- Every math.random(0,99) is 1 in This case its 3 locks
        ChanceToAlertPolice = 100, -- Chance in %
        Reward = {
            Money = true,
            MoneyMin = 15,
            MoneyMax = 30,
            MoneyType = 0, -- 0 Money 1 Gold 2 Blackmoney
            Item = true,
            Items = {
                { ItemName = 'diamond', Amount = 1, ItemLabel = 'Diamant'},
            }
        },
        OnDutyCopsNeeded = 0,
        SpawnNpcsCops = true,
        NPCCopLocations = {
            { Coord = vector3(-804.18, -1291.56, 43.59) },
            { Coord = vector3(-816.43, -1309.71, 43.79) },
            { Coord = vector3(-809.54, -1329.6, 43.79) },
            { Coord = vector3(-793.77, -1350.37, 43.88) },
            { Coord = vector3(-772.87, -1336.48, 43.68) },
            { Coord = vector3(-775.99, -1302.19, 43.96) },
        },
    },
    { -- Valentine General Store
        Type = 'Store',
        Name = 'Valentine General Store',
        LockpickItem = 'lockpick',
        Locations = {
            { Coord = vector3(-321.36, 806.43, 118.0) },
            { Coord = vector3(-321.39, 799.56, 118.0) },
            { Coord = vector3(-325.35, 797.21, 118.0) },
        },
        Safe = {math.random(0,99),math.random(0,99),math.random(0,99)}, -- Every math.random(0,99) is 1 in This case its 3 locks
        ChanceToAlertPolice = 100, -- Chance in %
        Reward = {
            Money = true,
            MoneyMin = 15,
            MoneyMax = 30,
            MoneyType = 0, -- 0 Money 1 Gold 2 Blackmoney
            Item = true,
            Items = {
                { ItemName = 'diamond', Amount = 1, ItemLabel = 'Diamant'},
            }
        },
        OnDutyCopsNeeded = 0,
        SpawnNpcsCops = true,
        NPCCopLocations = {
            { Coord = vector3(-328.76, 799.37, 117.6) },
            { Coord = vector3(-327.19, 812.95, 117.4) },
            { Coord = vector3(-301.05, 819.26, 118.53) },
            { Coord = vector3(-286.03, 782.88, 118.84) },
            { Coord = vector3(-297.65, 763.75, 118.89) },
            { Coord = vector3(-336.87, 775.04, 116.08) },
        },
    },
    { -- Valentine Weapon Store
        Type = 'Store',
        Name = 'Valentine Weapon Store',
        LockpickItem = 'lockpick',
        Locations = {
            { Coord = vector3(-279.54, 782.84, 119.62) },
            { Coord = vector3(-278.02, 777.91, 119.62) },
            { Coord = vector3(-282.52, 780.55, 119.65) },
        },
        Safe = {math.random(0,99),math.random(0,99),math.random(0,99)}, -- Every math.random(0,99) is 1 in This case its 3 locks
        ChanceToAlertPolice = 100, -- Chance in %
        Reward = {
            Money = true,
            MoneyMin = 15,
            MoneyMax = 30,
            MoneyType = 0, -- 0 Money 1 Gold 2 Blackmoney
            Item = true,
            Items = {
                { ItemName = 'diamond', Amount = 1, ItemLabel = 'Diamant'},
            }
        },
        OnDutyCopsNeeded = 0,
        SpawnNpcsCops = true,
        NPCCopLocations = {
            { Coord = vector3(-328.76, 799.37, 117.6) },
            { Coord = vector3(-327.19, 812.95, 117.4) },
            { Coord = vector3(-301.05, 819.26, 118.53) },
            { Coord = vector3(-286.03, 782.88, 118.84) },
            { Coord = vector3(-297.65, 763.75, 118.89) },
            { Coord = vector3(-336.87, 775.04, 116.08) },
        },
    },
    { -- Rhodes General Store
        Type = 'Store',
        Name = 'Rhodes General Store',
        LockpickItem = 'lockpick',
        Locations = {
            { Coord = vector3(1326.59, -1289.08, 77.14) },
            { Coord = vector3(1329.58, -1290.48, 77.14) },
            { Coord = vector3(1327.78, -1292.2, 77.14) },
        },
        Safe = {math.random(0,99),math.random(0,99),math.random(0,99)}, -- Every math.random(0,99) is 1 in This case its 3 locks
        ChanceToAlertPolice = 100, -- Chance in %
        Reward = {
            Money = true,
            MoneyMin = 15,
            MoneyMax = 30,
            MoneyType = 0, -- 0 Money 1 Gold 2 Blackmoney
            Item = true,
            Items = {
                { ItemName = 'diamond', Amount = 1, ItemLabel = 'Diamant'},
            }
        },
        OnDutyCopsNeeded = 0,
        SpawnNpcsCops = true,
        NPCCopLocations = {
            { Coord = vector3(1313.85, -1292.97, 75.92) },
            { Coord = vector3(1297.82, -1311.19, 76.84) },
            { Coord = vector3(1317.63, -1319.92, 76.99) },
            { Coord = vector3(1343.85, -1307.41, 76.68) },
            { Coord = vector3(1303.97, -1271.0, 76.62) },
            { Coord = vector3(1270.19, -1284.06, 75.35) },
        },
    },
    { -- Rhodes Weapon Store
        Type = 'Store',
        Name = 'Rhodes Weapon Store',
        LockpickItem = 'lockpick',
        Locations = {
            { Coord = vector3(1322.35, -1320.81, 78.01) },
            { Coord = vector3(1320.14, -1326.09, 78.0) },
            { Coord = vector3(1328.35, -1323.65, 78.01) },
        },
        Safe = {math.random(0,99),math.random(0,99),math.random(0,99)}, -- Every math.random(0,99) is 1 in This case its 3 locks
        ChanceToAlertPolice = 100, -- Chance in %
        Reward = {
            Money = true,
            MoneyMin = 15,
            MoneyMax = 30,
            MoneyType = 0, -- 0 Money 1 Gold 2 Blackmoney
            Item = true,
            Items = {
                { ItemName = 'diamond', Amount = 1, ItemLabel = 'Diamant'},
            }
        },
        OnDutyCopsNeeded = 0,
        SpawnNpcsCops = true,
        NPCCopLocations = {
            { Coord = vector3(1313.85, -1292.97, 75.92) },
            { Coord = vector3(1297.82, -1311.19, 76.84) },
            { Coord = vector3(1317.63, -1319.92, 76.99) },
            { Coord = vector3(1343.85, -1307.41, 76.68) },
            { Coord = vector3(1303.97, -1271.0, 76.62) },
            { Coord = vector3(1270.19, -1284.06, 75.35) },
        },
    },
    { -- Annesburg Weapon Store
        Type = 'Store',
        Name = 'Annesburg Weapon Store',
        LockpickItem = 'lockpick',
        Locations = {
            { Coord = vector3(2947.55, 1322.7, 44.94) },
            { Coord = vector3(2949.38, 1319.45, 44.94) },
            { Coord = vector3(2945.85, 1316.09, 44.94) },
        },
        Safe = {math.random(0,99),math.random(0,99),math.random(0,99)}, -- Every math.random(0,99) is 1 in This case its 3 locks
        ChanceToAlertPolice = 100, -- Chance in %
        Reward = {
            Money = true,
            MoneyMin = 15,
            MoneyMax = 30,
            MoneyType = 0, -- 0 Money 1 Gold 2 Blackmoney
            Item = true,
            Items = {
                { ItemName = 'diamond', Amount = 1, ItemLabel = 'Diamant'},
            }
        },
        OnDutyCopsNeeded = 0,
        SpawnNpcsCops = true,
        NPCCopLocations = {
            { Coord = vector3(2934.33, 1310.82, 44.63) },
            { Coord = vector3(2909.26, 1317.88, 45.09) },
            { Coord = vector3(2907.58, 1330.73, 48.25) },
            { Coord = vector3(2928.67, 1356.63, 44.42) },
            { Coord = vector3(2943.5, 1362.38, 44.19) },
            { Coord = vector3(2947.7, 1345.86, 44.94) },
        },
    },
    { -- Saint Denis General Store
        Type = 'Store',
        Name = 'Saint Denis General Store',
        LockpickItem = 'lockpick',
        Locations = {
            { Coord = vector3(2828.54, -1312.96, 46.88) },
            { Coord = vector3(2833.48, -1312.56, 46.88) },
            { Coord = vector3(2826.46, -1321.29, 46.88) },
        },
        Safe = {math.random(0,99),math.random(0,99),math.random(0,99)}, -- Every math.random(0,99) is 1 in This case its 3 locks
        ChanceToAlertPolice = 100, -- Chance in %
        Reward = {
            Money = true,
            MoneyMin = 15,
            MoneyMax = 30,
            MoneyType = 0, -- 0 Money 1 Gold 2 Blackmoney
            Item = true,
            Items = {
                { ItemName = 'diamond', Amount = 1, ItemLabel = 'Diamant'},
            }
        },
        OnDutyCopsNeeded = 0,
        SpawnNpcsCops = true,
        NPCCopLocations = {
            { Coord = vector3(2820.72, -1299.02, 46.9) },
            { Coord = vector3(2840.58, -1290.69, 46.55) },
            { Coord = vector3(2852.98, -1308.88, 46.41) },
            { Coord = vector3(2836.37, -1333.98, 46.11) },
            { Coord = vector3(2808.35, -1349.59, 46.69) },
            { Coord = vector3(2801.69, -1333.19, 46.47) },
        },
    },
    { -- Saint Denis Weapon Store
        Type = 'Store',
        Name = 'Saint Denis Weapon Store',
        LockpickItem = 'lockpick',
        Locations = {
            { Coord = vector3(2720.73, -1286.35, 49.75) },
            { Coord = vector3(2717.47, -1280.07, 49.75) },
            { Coord = vector3(2710.21, -1286.95, 49.75) },
        },
        Safe = {math.random(0,99),math.random(0,99),math.random(0,99)}, -- Every math.random(0,99) is 1 in This case its 3 locks
        ChanceToAlertPolice = 100, -- Chance in %
        Reward = {
            Money = true,
            MoneyMin = 15,
            MoneyMax = 30,
            MoneyType = 0, -- 0 Money 1 Gold 2 Blackmoney
            Item = true,
            Items = {
                { ItemName = 'diamond', Amount = 1, ItemLabel = 'Diamant'},
            }
        },
        OnDutyCopsNeeded = 0,
        SpawnNpcsCops = true,
        NPCCopLocations = {
            { Coord = vector3(2736.38, -1268.67, 49.65) },
            { Coord = vector3(2752.66, -1253.72, 49.43) },
            { Coord = vector3(2740.69, -1304.01, 47.67) },
            { Coord = vector3(2719.88, -1332.26, 47.71) },
            { Coord = vector3(2713.55, -1254.14, 49.96) },
            { Coord = vector3(2698.19, -1275.65, 50.64) },
        },
    },

    { -- Blackwater Bank
        Type = 'Bank',
        Name = 'Blackwater Bank',
        DynamiteItem = 'dynamite',
        Dynamite = { Model = 'p_dynamite01x', x = -817.4871215820313, y = -1273.9844970703126 ,z = 42.84000015258789, pitch = 0.0, roll = -90.0, yaw = -0.11473552882671 },
        VaultDoor = 1462330364,
        State = 1, -- Blackwater bank, vault,
        LockpickItem = 'lockpick',
        Locations = {
            { Coord = vector3(-817.04, -1273.83, 43.77) }, -- Always Use VAULT DOOR 
        },
        CashLocations = {
            { Coord = vector3(-820.96, -1274.97, 43.77) }, -- ONLY for Banks
            { Coord = vector3(-820.96, -1273.33, 43.77) }, -- ONLY for Banks
            { Coord = vector3(-818.81, -1273.49, 43.78) }, -- ONLY for Banks
        },
        Safe = {math.random(0,99),math.random(0,99),math.random(0,99)}, -- Every math.random(0,99) is 1 in This case its 3 locks
        ChanceToAlertPolice = 100, -- Chance in %
        Reward = {
            Money = true,
            MoneyMin = 15,
            MoneyMax = 30,
            MoneyType = 0, -- 0 Money 1 Gold 2 Blackmoney
            Item = true,
            Items = {
                { ItemName = 'diamond', Amount = 1, ItemLabel = 'Diamant'},
            }
        },
        OnDutyCopsNeeded = 0,
        SpawnNpcsCops = true,
        NPCCopLocations = {
            { Coord = vector3(-807.1, -1276.58, 43.78)  },
            { Coord = vector3(-792.95, -1280.55, 43.75) },
            { Coord = vector3(-808.38, -1261.82, 43.79) },
            { Coord = vector3(-832.42, -1276.27, 43.7)  },
            { Coord = vector3(-793.71, -1293.32, 43.75) },
            { Coord = vector3(-785.89, -1256.81, 43.67) },
        },
    },
    { -- Valentine Bank
        Type = 'Bank',
        Name = 'Valentine Bank',
        DynamiteItem = 'dynamite',
        Dynamite = { Model = 'p_dynamite01x', x = -307.2300109863281, y = 766.6699829101562 ,z = 117.9000015258789, pitch = 0.0, roll = -90.0, yaw = 99.99998474121094 },
        VaultDoor = 576950805,
        State = 1, -- Valentine bank, vault,
        LockpickItem = 'lockpick',
        Locations = {
            { Coord = vector3(-307.3, 767.21, 118.82) }, -- Always Use VAULT DOOR 
        },
        CashLocations = {
            { Coord = vector3(-308.08, 762.62, 118.82) }, -- ONLY for Banks
            { Coord = vector3(-308.65, 765.18, 118.82) }, -- ONLY for Banks
            { Coord = vector3(-304.33, 763.29, 118.82) }, -- ONLY for Banks
        },
        Safe = {math.random(0,99),math.random(0,99),math.random(0,99)}, -- Every math.random(0,99) is 1 in This case its 3 locks
        ChanceToAlertPolice = 100, -- Chance in %
        Reward = {
            Money = true,
            MoneyMin = 15,
            MoneyMax = 30,
            MoneyType = 0, -- 0 Money 1 Gold 2 Blackmoney
            Item = true,
            Items = {
                { ItemName = 'diamond', Amount = 1, ItemLabel = 'Diamant'},
            }
        },
        OnDutyCopsNeeded = 0,
        SpawnNpcsCops = true,
        NPCCopLocations = {
            { Coord = vector3(-328.76, 799.37, 117.6) },
            { Coord = vector3(-327.19, 812.95, 117.4) },
            { Coord = vector3(-301.05, 819.26, 118.53) },
            { Coord = vector3(-286.03, 782.88, 118.84) },
            { Coord = vector3(-297.65, 763.75, 118.89) },
            { Coord = vector3(-336.87, 775.04, 116.08) },
        },
    },
    { -- Rhodes Bank
        Type = 'Bank',
        Name = 'Rhodes Bank',
        DynamiteItem = 'dynamite',
        Dynamite = { Model = 'p_dynamite01x', x = 1282.80810546875, y = -1308.8900146484375 ,z = 76.2300033569336, pitch = 0.0, roll = -90.0, yaw = -86.0 },
        VaultDoor = 3483244267,
        State = 1, -- Rhodes bank, vault,
        LockpickItem = 'lockpick',
        Locations = {
            { Coord = vector3(1282.49, -1308.41, 77.16) }, -- Always Use VAULT DOOR 
        },
        CashLocations = {
            { Coord = vector3(1282.07, -1311.69, 77.16) }, -- ONLY for Banks
            { Coord = vector3(1288.13, -1313.52, 77.16) }, -- ONLY for Banks
            { Coord = vector3(1286.91, -1315.47, 77.16) }, -- ONLY for Banks
        },
        Safe = {math.random(0,99),math.random(0,99),math.random(0,99)}, -- Every math.random(0,99) is 1 in This case its 3 locks
        ChanceToAlertPolice = 100, -- Chance in %
        Reward = {
            Money = true,
            MoneyMin = 15,
            MoneyMax = 30,
            MoneyType = 0, -- 0 Money 1 Gold 2 Blackmoney
            Item = true,
            Items = {
                { ItemName = 'diamond', Amount = 1, ItemLabel = 'Diamant'},
            }
        },
        OnDutyCopsNeeded = 0,
        SpawnNpcsCops = true,
        NPCCopLocations = {
            { Coord = vector3(1313.85, -1292.97, 75.92) },
            { Coord = vector3(1297.82, -1311.19, 76.84) },
            { Coord = vector3(1317.63, -1319.92, 76.99) },
            { Coord = vector3(1343.85, -1307.41, 76.68) },
            { Coord = vector3(1303.97, -1271.0, 76.62) },
            { Coord = vector3(1270.19, -1284.06, 75.35) },
        },
    },
    { -- Saint Denis Bank
        Type = 'Bank',
        Name = 'Saint Denis Bank',
        DynamiteItem = 'dynamite',
        Dynamite = { Model = 'p_dynamite01x', x = 2643.72998046875, y = -1300.52001953125 ,z = 51.43999862670898, pitch = 0.0, roll = -90.0, yaw = -155.41461181640625 },
        VaultDoor = 1751238140,
        State = 1, -- Saint Denis bank, vault,
        LockpickItem = 'lockpick',
        Locations = {
            { Coord = vector3(2643.96, -1299.84, 52.37) }, -- Always Use VAULT DOOR 
        },
        CashLocations = {
            { Coord = vector3(2644.91, -1304.73, 52.37) }, -- ONLY for Banks
            { Coord = vector3(2643.17, -1307.04, 52.37) }, -- ONLY for Banks
            { Coord = vector3(2641.2, -1302.71, 52.37) }, -- ONLY for Banks
        },
        Safe = {math.random(0,99),math.random(0,99),math.random(0,99)}, -- Every math.random(0,99) is 1 in This case its 3 locks
        ChanceToAlertPolice = 100, -- Chance in %
        Reward = {
            Money = true,
            MoneyMin = 15,
            MoneyMax = 30,
            MoneyType = 0, -- 0 Money 1 Gold 2 Blackmoney
            Item = true,
            Items = {
                { ItemName = 'diamond', Amount = 1, ItemLabel = 'Diamant'},
            }
        },
        OnDutyCopsNeeded = 0,
        SpawnNpcsCops = true,
        NPCCopLocations = {
            { Coord = vector3(2643.46, -1312.24, 51.12) },
            { Coord = vector3(2633.43, -1285.7, 52.39) },
            { Coord = vector3(2660.3, -1272.32, 52.17) },
            { Coord = vector3(2648.51, -1257.79, 52.49) },
            { Coord = vector3(2612.5, -1319.93, 51.28) },
            { Coord = vector3(2626.8, -1336.73, 50.25) },
        },
    },
}