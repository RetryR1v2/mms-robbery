-- Server Side
local VORPcore = exports.vorp_core:GetCore()

local AlreadyRobbedCoords = {}
local AlreadyBombedCoords = {}
local AllBanks = {}

Citizen.CreateThread(function()
    local Timer = Config.ResetLocationTime * 60000
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
            Timer = Config.ResetLocationTime * 60000
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

RegisterServerEvent('mms-robbery:server:Reward',function(Reward)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    if Reward.Money then
        local Amount = math.random(Reward.MoneyMin,Reward.MoneyMax)
        Character.addCurrency(Reward.MoneyType,Amount)
        VORPcore.NotifyRightTip(src,_U('RewardedMoney') .. Amount .. ' $',5000)
    end
    if Reward.Item then
        for h,v in ipairs(Reward.Items) do
            exports.vorp_inventory:addItem(src, v.ItemName, v.Amount)
            VORPcore.NotifyRightTip(src,_U('RewardItem') .. v.Amount .. ' ' .. v.ItemLabel,5000)
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
                        TriggerClientEvent('mms-robbery:client:SendAlertToPolice',src,CurrentLocation,Name)
                    end
                end
            end
        end
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