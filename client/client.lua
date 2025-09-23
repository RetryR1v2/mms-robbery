local VORPcore = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()
local xSound = exports.xsound

local PoliceAlerted = false
local NPCPoliceSpawned = false
local CreatedCops = {}
local InRobbery = false
local InBankRobbery = false
local CanStartRobbery = true

Citizen.CreateThread(function()
    local StoreGroup = BccUtils.Prompts:SetupPromptGroup()
    local LockpickPrompt = StoreGroup:RegisterPrompt(_U('LockpickPrompt'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) -- KEY G

    local BankGroup1 = BccUtils.Prompts:SetupPromptGroup()
    local DynamitePromp = BankGroup1:RegisterPrompt(_U('DynamitePrompt'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) -- KEY G

    while true do
        Wait(3)
        for h,v in pairs(Config.RobberyLocations) do
            local MyCoords = GetEntityCoords(PlayerPedId())
            local Name = v.Name
            local Type = v.Type
            local LockpickItem = v.LockpickItem
            local LocationAlreadyRobbed = false
            local LocationAlreadyBombed = false
            local DynamiteItem = v.DynamiteItem
            local Safe = v.Safe
            local Chance = v.ChanceToAlertPolice
            local Reward = v.Reward
            local SpawnNPCS = v.SpawnNpcsCops
            local NPCLocations = v.NPCCopLocations
            local Dynamite = v.Dynamite
            local Door = v.VaultDoor
            local BankCoords = v.CashLocations
            local OnDutyCopsNeeded = v.OnDutyCopsNeeded
            for h,v in ipairs(v.Locations) do
                local CurrentLocation = v.Coord
                local dist = #(MyCoords - v.Coord)
                local CooldownInMin = v.Cooldown * 60000
                if dist < 1.5 then
                    if Type == 'Store' then
                        StoreGroup:ShowGroup(Name)

                        if LockpickPrompt:HasCompleted() then
                            local PickedLocations = VORPcore.Callback.TriggerAwait('mms-robbery:callback:PickedLocations')
                            if #PickedLocations > 0 then
                                for h,v in ipairs(PickedLocations) do
                                    if v.Coords == CurrentLocation and v.IsRobbed then
                                        LocationAlreadyRobbed = true
                                    end
                                end
                            end
                            local CopsOnDuty = VORPcore.Callback.TriggerAwait('mms-robbery:callback:GetOnDutyPolice')
                            if OnDutyCopsNeeded <= CopsOnDuty then
                                CanStartRobbery = true
                            else
                                CanStartRobbery = false
                            end
                            if not LocationAlreadyRobbed and CanStartRobbery then
                                TriggerEvent('mms-robbery:client:InRobberyProgress',CurrentLocation)
                                local CurrentChance = math.random(1,100)
                                local HasLockpick = VORPcore.Callback.TriggerAwait('mms-robbery:callback:CheckForLockpick',LockpickItem)
                                if HasLockpick then
                                    FreezeEntityPosition(PlayerPedId(),true)
                                    local res = exports["qadr-safe"]:createSafe(Safe)
                                    if res then -- Lockpicking Success
                                        if Config.DestroyLockpickOnSuccess then
                                            local Chance = math.random(1,100)
                                            if Chance <= Config.DestroyLockpickChance then
                                                TriggerServerEvent('mms-robbery:server:DestroyLockpick',LockpickItem)
                                            end
                                        end
                                        FreezeEntityPosition(PlayerPedId(),false)
                                        TriggerServerEvent('mms-robbery:server:AddLocationToAlreadyPicked',CurrentLocation,CooldownInMin)
                                        TriggerServerEvent('mms-robbery:server:Reward',Reward,Type,Name)
                                        if CurrentChance <= Chance and not PoliceAlerted then
                                            if not NPCPoliceSpawned then
                                                TriggerEvent('mms-robbery:client:SpawnNpcPolice',SpawnNPCS,NPCLocations)
                                            end
                                            if Config.PlayAlarms then
                                                TriggerServerEvent('mms-robbery:server:PlaySound',CurrentLocation)
                                            end
                                            TriggerEvent('mms-robbery:client:ResetAlert')
                                            if Config.UseAlertSystem then
                                                TriggerServerEvent('mms-robbery:server:AlertPolice',CurrentLocation,Name)
                                            end
                                        end
                                    else -- Lockpicking Failed
                                        FreezeEntityPosition(PlayerPedId(),false)
                                        VORPcore.NotifyTip(_U('LockpickingFailed'), 5000)
                                        if Config.DestroyLockpickOnFail then
                                            TriggerServerEvent('mms-robbery:server:DestroyLockpick',LockpickItem)
                                        end
                                        if CurrentChance <= Chance and not PoliceAlerted then
                                            if not NPCPoliceSpawned then
                                                TriggerEvent('mms-robbery:client:SpawnNpcPolice',SpawnNPCS,NPCLocations)
                                            end
                                            if Config.PlayAlarms then
                                                TriggerServerEvent('mms-robbery:server:PlaySound',CurrentLocation)
                                            end
                                            TriggerEvent('mms-robbery:client:ResetAlert')
                                            if Config.UseAlertSystem then
                                                TriggerServerEvent('mms-robbery:server:AlertPolice',CurrentLocation,Name)
                                            end
                                        end
                                    end
                                else
                                    VORPcore.NotifyRightTip(_U('NoLockpick'))
                                end
                            elseif LocationAlreadyRobbed then
                                VORPcore.NotifyRightTip(_U('LocationAlreadyRobbed'))
                            elseif not CanStartRobbery then
                                VORPcore.NotifyRightTip(_U('NotEnoghCops') .. OnDutyCopsNeeded)
                            elseif CooldownStatus then
                                VORPcore.NotifyRightTip(_U('CantRobCurrently'))
                            end
                        end
                    elseif Type == 'Bank' then
                        BankGroup1:ShowGroup(Name)
                        if DynamitePromp:HasCompleted() then
                            local BombedLocations = VORPcore.Callback.TriggerAwait('mms-robbery:callback:BombedLocations')
                            if #BombedLocations >   0 then
                                for h,v in ipairs(BombedLocations) do
                                    if v.Coords == CurrentLocation and v.IsRobbed then
                                        LocationAlreadyBombed = true
                                    end
                                end
                            end
                            local CopsOnDuty = VORPcore.Callback.TriggerAwait('mms-robbery:callback:GetOnDutyPolice')
                            if OnDutyCopsNeeded <= CopsOnDuty then
                                CanStartRobbery = true
                            else
                                CanStartRobbery = false
                            end
                            if not LocationAlreadyBombed and CanStartRobbery then
                                local HasDynamite = VORPcore.Callback.TriggerAwait('mms-robbery:callback:CheckForDynamite',DynamiteItem)
                                if HasDynamite then
                                    local DynamiteObject = CreateObject(GetHashKey(Dynamite.Model),Dynamite.x,Dynamite.y,Dynamite.z,true,true,false)
                                    SetEntityRotation(DynamiteObject, Dynamite.pitch,Dynamite.roll,Dynamite.yaw )
                                    if Config.PlayAlarms then
                                        TriggerServerEvent('mms-robbery:server:PlaySoundBomb',CurrentLocation,Dynamite)
                                    end
                                    TriggerServerEvent('mms-robbery:server:AddLocationToAlreadyBombed',CurrentLocation,CooldownInMin,Door)
                                    TriggerServerEvent('mms-robbery:server:SetDoorState',Door)
                                    TriggerServerEvent('mms-robbery:server:SetBankState',CurrentLocation)
                                    if not PoliceAlerted then
                                        if not NPCPoliceSpawned then
                                            TriggerEvent('mms-robbery:client:SpawnNpcPolice',SpawnNPCS,NPCLocations)
                                        end
                                        if Config.PlayAlarms then
                                            TriggerServerEvent('mms-robbery:server:PlaySound',CurrentLocation)
                                        end
                                        TriggerEvent('mms-robbery:client:ResetAlert')
                                        if Config.UseAlertSystem then
                                            TriggerServerEvent('mms-robbery:server:AlertPolice',CurrentLocation,Name)
                                        end
                                    end
                                    DeleteEntity(DynamiteObject)
                                    Citizen.Wait(2500)
                                    TriggerEvent('mms-robbery:client:CheckOpenBanks',CurrentLocation,Reward,BankCoords,Name,LockpickItem,Safe)
                                else
                                    VORPcore.NotifyRightTip(_U('NoDynamite'))
                                end
                            elseif LocationAlreadyBombed then
                                VORPcore.NotifyRightTip(_U('LocationAlreadyBombed'))
                            elseif not CanStartRobbery then
                                VORPcore.NotifyRightTip(_U('NotEnoghCops') .. OnDutyCopsNeeded)
                            end
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('mms-robbery:client:CheckOpenBanks')
AddEventHandler('mms-robbery:client:CheckOpenBanks',function (CurrentLocation,Reward,BankCoords,Name,LockpickItem,Safe)
    InBankRobbery = true
    local BankGroup2 = BccUtils.Prompts:SetupPromptGroup()
    local LockpickBank = BankGroup2:RegisterPrompt(_U('LockpickPrompt'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) -- KEY G
    while InBankRobbery do
        local LocationAlreadyRobbed = false
        local LocationAlreadyCracked = false
        Citizen.Wait(5)
        for h,v in ipairs(BankCoords) do
            MyCoords = GetEntityCoords(PlayerPedId())
            Distance = #(MyCoords - v.Coord)
            Coords = v.Coord
            if Distance <= 1 then
                BankGroup2:ShowGroup(Name)
                if LockpickBank:HasCompleted() then
                    local PickedLocations = VORPcore.Callback.TriggerAwait('mms-robbery:callback:PickedLocations')
                    if #PickedLocations > 0 then
                        for h,v in ipairs(PickedLocations) do
                            if v.Coords == CurrentLocation and v.IsRobbed then
                                LocationAlreadyRobbed = true
                            end
                        end
                    end
                    local CrackedOpenBanks = VORPcore.Callback.TriggerAwait('mms-robbery:callback:CrackedOpenBanks')
                    if #CrackedOpenBanks > 0 then
                        for h,v in ipairs(CrackedOpenBanks) do
                            if v.Coord == CurrentLocation and v.Cracked == true then
                                LocationAlreadyCracked = true
                            end
                        end
                    end
                    if not LocationAlreadyRobbed and LocationAlreadyCracked then
                        TriggerEvent('mms-robbery:client:InRobberyProgress',CurrentLocation)
                        local HasLockpick = VORPcore.Callback.TriggerAwait('mms-robbery:callback:CheckForLockpick',LockpickItem)
                            if HasLockpick then
                                FreezeEntityPosition(PlayerPedId(),true)
                                local res = exports["qadr-safe"]:createSafe(Safe)
                                if res then -- Lockpicking Success
                                    if Config.DestroyLockpickOnSuccess then
                                        local Chance = math.random(1,100)
                                        if Chance <= Config.DestroyLockpickChance then
                                            TriggerServerEvent('mms-robbery:server:DestroyLockpick',LockpickItem)
                                        end
                                    end
                                    FreezeEntityPosition(PlayerPedId(),false)
                                    TriggerServerEvent('mms-robbery:server:AddLocationToAlreadyPicked',v.Coord)
                                    TriggerServerEvent('mms-robbery:server:Reward',Reward,Type,Name)
                                else -- Lockpicking Failed
                                    FreezeEntityPosition(PlayerPedId(),false)
                                    VORPcore.NotifyTip(_U('LockpickingFailed'), 5000)
                                    if Config.DestroyLockpickOnFail then
                                        TriggerServerEvent('mms-robbery:server:DestroyLockpick',LockpickItem)
                                    end
                                end
                            else
                                VORPcore.NotifyRightTip(_U('NoLockpick'))
                            end
                    else
                        VORPcore.NotifyRightTip(_U('LocationAlreadyRobbed'))
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('mms-robbery:client:InRobberyProgress',function(CurrentLocation)
    InRobbery = true
    local RobberyTimer = 300000
    while InRobbery do
        -- Check if Flee from Robbery
        local MyCoords = GetEntityCoords(PlayerPedId())
        local Distance = #(CurrentLocation - MyCoords)
        if Distance > 300 then
            InRobbery = false
            if #CreatedCops > 0 then
                for _, ped in ipairs(CreatedCops) do
                    if DoesEntityExist(ped) then
                        DeleteEntity(ped)
                    end
                end
            end
        end
        Citizen.Wait(5000)
        RobberyTimer = RobberyTimer - 5000
        -- Check if Player Dead
        if IsEntityDead(PlayerPedId()) then
            InRobbery = false
            if #CreatedCops > 0 then
                for _, ped in ipairs(CreatedCops) do
                    if DoesEntityExist(ped) then
                        DeleteEntity(ped)
                    end
                end
            end
        end
        if RobberyTimer <= 0 then
            InRobbery = false
            InBankRobbery = false
        end
    end
end)

RegisterNetEvent('mms-robbery:client:SetDoorState')
AddEventHandler('mms-robbery:client:SetDoorState',function (Door)
    DoorSystemSetDoorState(Door, 0)
end)

RegisterNetEvent('mms-robbery:client:SendAlertToPolice')
AddEventHandler('mms-robbery:client:SendAlertToPolice',function(CurrentLocation,Name)
    VORPcore.NotifySimpleTop(_U('NotifyTitle'), Name, 15000)
    StartGpsMultiRoute(GetHashKey("COLOR_YELLOW"), true, true)
    AddPointToGpsMultiRoute(CurrentLocation)
    SetGpsMultiRouteRender(true)
    local AtRobbery = false
    while not AtRobbery do
        local CopCoords = GetEntityCoords(PlayerPedId())
        Citizen.Wait(500)
        local Distance = #(CopCoords - CurrentLocation)
        if Distance <= 25 then
            VORPcore.NotifyRightTip(_U('LocationReached'),5000)
            AtRobbery = true
        end
        ClearGpsMultiRoute()
    end
end)

RegisterNetEvent('mms-robbery:client:PlaySound',function(CurrentLocation)
    xSound:PlayUrlPos(Config.Title, Config.EmbedLink, Config.Volume, CurrentLocation, 0)
    xSound:Distance(Config.Title,Config.Radius)
    Citizen.Wait(Config.AlarmDuration*1000)
    xSound:Destroy(Config.Title)
end)

RegisterNetEvent('mms-robbery:client:PlaySoundBomb',function(CurrentLocation)
    xSound:PlayUrlPos(Config.TitleBomb, Config.EmbedLinkBomb, Config.VolumeBomb, CurrentLocation, 0)
    xSound:Distance(Config.TitleBomb,Config.Radius)
    Citizen.Wait(Config.AlarmDurationBomb*1000)
    xSound:Destroy(Config.TitleBomb)
end)

RegisterNetEvent('mms-robbery:client:PlayBombFXSynced',function(Dynamite)
    Citizen.Wait(Config.AlarmDurationBomb*1000)
    local explosionTag_id = 25
    local explosion_vfxTag_hash = 0xD06E43B6
    local damageScale = 1.0
    local isAudible = true
    local isInvisible = false
    local cameraShake = true
    Citizen.InvokeNative(0x53BA259F3A67A99E, Dynamite.x,Dynamite.y,Dynamite.z, explosionTag_id, explosion_vfxTag_hash, damageScale, isAudible, isInvisible, cameraShake)
end)


RegisterNetEvent('mms-robbery:client:ResetAlert',function()
    PoliceAlerted = true
    Citizen.Wait(300000)
    PoliceAlerted = false
end)

RegisterNetEvent('mms-robbery:client:SpawnNpcPolice',function(SpawnNPCS,NPCLocations)
    if SpawnNPCS then
        local modelHash = GetHashKey(Config.CopModel)
        while not HasModelLoaded(modelHash) do
            RequestModel(modelHash)
            Citizen.Wait(0)
        end
        for h, v in pairs(NPCLocations) do
        local PlayerPedAttack = PlayerPedId()
        local copped = CreatePed(modelHash, v.Coord.x,v.Coord.y,v.Coord.z, true, true, false, false)
        if DoesEntityExist(copped) then
            SetPedRelationshipGroupHash(copped, `cops`)
            SetRelationshipBetweenGroups(5, `PLAYER`, `cops`)
            SetRelationshipBetweenGroups(5, `cops`, `PLAYER`)
            Citizen.InvokeNative(0x283978A15512B2FE, copped, true)
            Citizen.InvokeNative(0x23f74c2fda6e7c61,953018525, copped)
            TaskCombatPed(copped, PlayerPedAttack)
            SetEntityAsMissionEntity(copped, true, true)
            Citizen.InvokeNative(0x740CB4F3F602C9F4, copped, true)
            CreatedCops[#CreatedCops + 1] = copped
        end
        end
        SetModelAsNoLongerNeeded(modelHash)
    end
    NPCPoliceSpawned = true
    local CopAmount = #CreatedCops
    while NPCPoliceSpawned do
        Citizen.Wait(5)
        local KilledCops = GetNumberofDeadPeds(CreatedCops)
        if KilledCops == CopAmount then
            Citizen.Wait(5000)
            for _, ped in ipairs(CreatedCops) do
                DeleteEntity(ped)
                TriggerEvent('mms-robbery:client:ResetNPCCops')
            end
        end
    end
end)

RegisterNetEvent('mms-robbery:client:ResetNPCCops',function()
    Citizen.Wait(300000)
    NPCPoliceSpawned = false
end)

function GetNumberofDeadPeds(CreatedCops)
    local KilledCops = 0
    for _, ped in ipairs(CreatedCops) do
        if DoesEntityExist(ped) then
            if IsEntityDead(ped) then
                KilledCops = KilledCops + 1
            end
        end
    end
    return KilledCops
end

----------------- Utilities -----------------


------ Progressbar

function Progressbar(Time,Text)
    progressbar.start(Text, Time, function ()
    end, 'linear')
    Wait(Time)
    ClearPedTasks(PlayerPedId())
end

------ Animation

function CrouchAnim()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TaskPlayAnim(ped, dict, "inspectfloor_player", 0.5, 8.0, -1, 1, 0, false, false, false)
end

---- CleanUp on Resource Restart 

RegisterNetEvent('onResourceStop',function(resource)
    if resource == GetCurrentResourceName() then
        for h, v in pairs(Config.RobberyLocations) do
            if v.VaultDoor and v.State ~= nil then
                if not IsDoorRegisteredWithSystem(v.VaultDoor) then
                    Citizen.InvokeNative(0xD99229FE93B46286, v.VaultDoor, 1, 1, 0, 0, 0, 0)
                end
                DoorSystemSetDoorState(v.VaultDoor, v.State)
            end
        end
    end
end)

-- DOORS

CreateThread(function()
    for h, v in pairs(Config.RobberyLocations) do
        if v.VaultDoor and v.State ~= nil then
            if not IsDoorRegisteredWithSystem(v.VaultDoor) then
                Citizen.InvokeNative(0xD99229FE93B46286, v.VaultDoor, 1, 1, 0, 0, 0, 0)
            end
            DoorSystemSetDoorState(v.VaultDoor, v.State)
        end
    end
end)

RegisterNetEvent('mms-robbery:client:ResetDoors')
AddEventHandler('mms-robbery:client:ResetDoors',function(Door)
    if not IsDoorRegisteredWithSystem(Door) then
        Citizen.InvokeNative(0xD99229FE93B46286, Door, 1, 1, 0, 0, 0, 0)
    end
    DoorSystemSetDoorState(Door, 1)
end)