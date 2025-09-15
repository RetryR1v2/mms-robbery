-- Server Side
local VORPcore = exports.vorp_core:GetCore()

local AlreadyRobbedCoords = {}
local AlreadyBombedCoords = {}
local AllBanks = {}

local RobberyCooldown = false

Citizen.CreateThread(function()
    local Timer = Config.ResetAllLocationsTime * 60000
    while true do
        Citizen.Wait(60000)
        Timer = Timer - 60000
        if Timer <= 0 then
            AlreadyRobbedCoords = {}
            AlreadyBombedCoords = {}
            AllBanks = {}
            for h,v in ipairs(GetPlayers()) do
                TriggerClientEvent('mms-robbery:client:ResetDoors',v)
            end
            Timer = Config.ResetAllLocationsTime * 60000
        end
    end
end)

RegisterServerEvent('mms-robbery:server:AddLocationToAlreadyPicked',function(CurrentLocation)
    table.insert(AlreadyRobbedCoords,CurrentLocation)
end)

RegisterServerEvent('mms-robbery:server:AddLocationToAlreadyBombed',function(CurrentLocation)
    table.insert(AlreadyBombedCoords,CurrentLocation)
end)

RegisterServerEvent('mms-robbery:server:AlertPolice',function(CurrentLocation,Name)
    if Config.synSociety then
        for h,v in ipairs(GetPlayers()) do
            local src = v
            local Character = VORPcore.getUser(src).getUsedCharacter
            local Job = Character.job
            for h,v in ipairs(Config.PoliceJobs) do
                if v.Job == Job then
                    local DutyStatus = exports["syn_society"]:IsPlayerOnDuty(src, Job)
                    if DutyStatus then
                        TriggerClientEvent('mms-robbery:client:SendAlertToPolice',src,CurrentLocation,Name)
                    end
                end
            end
        end
    elseif Config.DLSociety then
        for h,v in ipairs(GetPlayers()) do
            local src = v
            local Character = VORPcore.getUser(src).getUsedCharacter
            local Job = Character.job
            for h,v in ipairs(Config.PoliceJobs) do
                if v.Job == Job then
                    local DutyStatus = exports.dl_society:getPlayerDutyStatus(src)
                    if DutyStatus then
                        TriggerClientEvent('mms-robbery:client:SendAlertToPolice',src,CurrentLocation,Name)
                    end
                end
            end
        end
    elseif Config.EZSociety then
        for h,v in ipairs(GetPlayers()) do
            local src = v
            local Character = VORPcore.getUser(src).getUsedCharacter
            local Job = Character.job
            for h,v in ipairs(Config.PoliceJobs) do
                if v.Job == Job then
                    local DutyStatus = exports["ez_society"]:IsPlayerOnDuty(src)
                    if DutyStatus then
                        TriggerClientEvent('mms-robbery:client:SendAlertToPolice',src,CurrentLocation,Name)
                    end
                end
            end
        end
    elseif Config.BCCSociety then
        local BccSociety = exports['bcc-society']:getSocietyAPI()
        for h,v in ipairs(GetPlayers()) do
            local src = v
            local Character = VORPcore.getUser(src).getUsedCharacter
            local Job = Character.job
            for h, jobDef in ipairs(Config.PoliceJobs) do
                if jobDef.Job == Job then
                    local DutyStatus = BccSociety.MiscAPI:CheckIfPlayerHasJobAndIsOnDuty(Job, src)
                    if DutyStatus then
                        TriggerClientEvent('mms-robbery:client:SendAlertToPolice', src, CurrentLocation, Name)
                    end
                end
            end
        end
    elseif Config.SSPoliceJob then
        local notify = "Robbery in Progress!"
        local bliptype = 1366733613
        local blipradius = 30.0
        local blipname = "Robbery!"
        local blipremove = 10
        exports["SS-PoliceJob"]:PoliceAlert(CurrentLocation, notify, blipradius, bliptype, blipname, blipremove)
    elseif Config.VorpDutySystem then
        for h,v in ipairs(GetPlayers()) do
            local DutyStatus = Player(v).state.isPoliceDuty
            if DutyStatus then
                TriggerClientEvent('mms-robbery:client:SendAlertToPolice',v,CurrentLocation,Name)
            end
        end
    end
end)

RegisterServerEvent('mms-robbery:server:DestroyLockpick',function(LockpickItem)
    local src = source
    exports.vorp_inventory:subItem(src, LockpickItem, 1)
end)

RegisterServerEvent('mms-robbery:server:Reward',function(Reward,Type,Name)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local RobberName = Character.firstname .. ' ' .. Character.lastname
    if Reward.Money then
        local Amount = math.random(Reward.MoneyMin,Reward.MoneyMax)
        Character.addCurrency(Reward.MoneyType,Amount)
        VORPcore.NotifyRightTip(src,_U('RewardedMoney') .. Amount .. ' $',5000)
        if Config.WebHook and Type == 'Bank' then
            VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, RobberName .. _U('WHRobbedBank') .. Name .. _U('WHAndRobbed') .. Amount .. ' $', Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
        elseif Config.WebHook and Type == 'Store' then
            ORPcore.AddWebhook(Config.WHTitle, Config.WHLink, RobberName .. _U('WHRobbedStore') .. Name .. _U('WHAndRobbed') .. Amount .. ' $', Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
        end
    end
    if Reward.Item then
        for h,v in ipairs(Reward.Items) do
            exports.vorp_inventory:addItem(src, v.ItemName, v.Amount)
            VORPcore.NotifyRightTip(src,_U('RewardItem') .. v.Amount .. ' ' .. v.ItemLabel,5000)
        end
    end
    if Type == 'Bank' and not RobberyCooldown then
        local RobberyCooldownTimer = Config.BankCooldown * 60000
        RobberyCooldown = true
        TriggerEvent('mms-robbery:server:RobberyCooldown',RobberyCooldownTimer)
    elseif Type == 'Store' and not RobberyCooldown then
        local RobberyCooldownTimer = Config.RobberyCooldown * 60000
        RobberyCooldown = true
        TriggerEvent('mms-robbery:server:RobberyCooldown',RobberyCooldownTimer)
    end
    if Config.WebHook and Type == 'Bank' then
        VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, RobberName .. _U('WHRobbedBank') .. Name, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
    elseif Config.WebHook and Type == 'Store' then
        VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, RobberName .. _U('WHRobbedStore') .. Name, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
    end
end)

RegisterServerEvent('mms-robbery:server:RobberyCooldown',function(RobberyCooldownTimer)
    Citizen.Wait(500)
    while RobberyCooldown do
        Citizen.Wait(30000)
        RobberyCooldownTimer = RobberyCooldownTimer - 30000
        if RobberyCooldownTimer <= 0 then
            RobberyCooldown = false
        end
    end
end)

RegisterServerEvent('mms-robbery:server:SetDoorState',function(Door)
    for h,v in ipairs(GetPlayers()) do
        TriggerClientEvent('mms-robbery:client:SetDoorState',v,Door)
    end
end)

Citizen.CreateThread(function()
    for h,v in ipairs(Config.RobberyLocations) do
        if v.Type == 'Bank' then
            BankData = { Name = v.Name , Coord = v.Locations[1].Coord, Cracked = false }
            table.insert(AllBanks,BankData)
        end
    end
end)

RegisterServerEvent('mms-robbery:server:SetBankState',function(CurrentLocation)
    for h,v in ipairs(AllBanks) do
        if v.Coord == CurrentLocation then
            AllBanks[h].Cracked = true
        end
    end
end)

-----------------------------------------------
------------- Register Callback ---------------
-----------------------------------------------

VORPcore.Callback.Register('mms-robbery:callback:CheckForLockpick', function(source,cb,LockpickItem)
    local src = source
    local LockpickAmount = exports.vorp_inventory:getItemCount(src, nil, LockpickItem)
    if LockpickAmount > 0 then
        return cb(true)
    else
        return cb(false)
    end
end)

VORPcore.Callback.Register('mms-robbery:callback:CheckForDynamite', function(source,cb,DynamiteItem)
    local src = source
    local LockpickAmount = exports.vorp_inventory:getItemCount(src, nil, DynamiteItem)
    if LockpickAmount > 0 then
        exports.vorp_inventory:subItem(src, DynamiteItem, 1)
        return cb(true)
    else
        return cb(false)
    end
end)

VORPcore.Callback.Register('mms-robbery:callback:PickedLocations', function(source,cb)
    local src = source
    return cb(AlreadyRobbedCoords)
end)

VORPcore.Callback.Register('mms-robbery:callback:BombedLocations', function(source,cb)
    local src = source
    return cb(AlreadyBombedCoords)
end)

VORPcore.Callback.Register('mms-robbery:callback:CrackedOpenBanks', function(source,cb)
    local src = source
    return cb(AllBanks)
end)

VORPcore.Callback.Register('mms-robbery:callback:GetCooldownStatus', function(source,cb)
    if RobberyCooldown then
        return cb(true)
    else
        return cb(false)
    end
end)

VORPcore.Callback.Register('mms-robbery:callback:GetCooldownStatusStore', function(source,cb)
    if RobberyCooldown then
        return cb(true)
    else
        return cb(false)
    end
end)

VORPcore.Callback.Register('mms-robbery:callback:GetOnDutyPolice', function(source,cb)
    local OnDutyPolice = 0
    if Config.synSociety then
        for h,v in ipairs(GetPlayers()) do
            local src = v
            local Character = VORPcore.getUser(src).getUsedCharacter
            local Job = Character.job
            for h,v in ipairs(Config.PoliceJobs) do
                if v.Job == Job then
                    local DutyStatus = exports["syn_society"]:IsPlayerOnDuty(src, Job)
                    if DutyStatus then
                        OnDutyPolice = OnDutyPolice + 1
                    end
                end
            end
        end
    elseif Config.DLSociety then
        for h,v in ipairs(GetPlayers()) do
            local src = v
            local Character = VORPcore.getUser(src).getUsedCharacter
            local Job = Character.job
            for h,v in ipairs(Config.PoliceJobs) do
                if v.Job == Job then
                    local DutyStatus = exports.dl_society:getPlayerDutyStatus(src)
                    if DutyStatus then
                        OnDutyPolice = OnDutyPolice + 1
                    end
                end
            end
        end
    elseif Config.EZSociety then
        for h,v in ipairs(GetPlayers()) do
            local src = v
            local Character = VORPcore.getUser(src).getUsedCharacter
            local Job = Character.job
            for h,v in ipairs(Config.PoliceJobs) do
                if v.Job == Job then
                    local DutyStatus = exports["ez_society"]:IsPlayerOnDuty(src)
                    if DutyStatus then
                        if DutyStatus then
                            OnDutyPolice = OnDutyPolice + 1
                        end
                    end
                end
            end
        end
    elseif Config.BCCSociety then
        local BccSociety = exports['bcc-society']:getSocietyAPI()
        for h,v in ipairs(GetPlayers()) do
            local src = v
            local Character = VORPcore.getUser(src).getUsedCharacter
            local Job = Character.job
            for h, jobDef in ipairs(Config.PoliceJobs) do
                if jobDef.Job == Job then
                    local DutyStatus = BccSociety.MiscAPI:CheckIfPlayerHasJobAndIsOnDuty(Job, src)
                    if DutyStatus then
                        OnDutyPolice = OnDutyPolice + 1
                    end
                end
            end
        end
    elseif Config.SSPoliceJob then
        OnDutyPolice = exports["SS-PoliceJob"]:GetPoliceONDUTY()
    elseif Config.VorpDutySystem then
        for h,v in ipairs(GetPlayers()) do
            local DutyStatus = Player(v).state.isPoliceDuty
            if DutyStatus then
                OnDutyPolice = OnDutyPolice + 1
            end
        end
    end
    return cb(OnDutyPolice)
end)

RegisterServerEvent('mms-robbery:server:PlaySound',function(CurrentLocation)
    for h,v in ipairs(GetPlayers()) do
        TriggerClientEvent('mms-robbery:client:PlaySound',v,CurrentLocation)
    end
end)

RegisterServerEvent('mms-robbery:server:PlaySoundBomb',function(CurrentLocation,Dynamite)
    for h,v in ipairs(GetPlayers()) do
        TriggerClientEvent('mms-robbery:client:PlaySoundBomb',v,CurrentLocation)
        TriggerClientEvent('mms-robbery:client:PlayBombFXSynced',v,Dynamite)
    end
end)