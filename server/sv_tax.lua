local config = require 'config.sv_config'
local logger = require '@qbx_core.modules.logger'
local QBOX = exports.qbx_core

local function SendNotification(playerID, msg, type)
    exports.qbx_core:Notify(playerID, msg, type, 5000, 'GOV TAX PROGRAM')
end

local function addMoneyToAccount(amount, text)
    if not config.TaxesAccountEnabled then return end
    -- Type Business
    if config.TaxesAccount.accountType == 'business' then
        local business = exports['Renewed-Banking']:addAccountMoney(config.TaxesAccount.name, amount)
        if business then business.addBalance(amount, text) end
        -- Type Player
    elseif config.TaxesAccount.accountType == 'player' then
        local onlinePlayer = QBOX:GetPlayerByCitizenId(config.TaxesAccount.playerCitizenId)
        if onlinePlayer then
            -- if player is online
            onlinePlayer.Functions.SetMoney('bank', amount, text)
        else
            -- if player is offline
            local offlinePlayer = QBOX:GetOfflinePlayerByCitizenId(config.TaxesAccount.playerCitizenId)
            offlinePlayer.Functions.SetMoney('bank', amount, text)
        end
    end
end

function PlayersTax()
    local taxAmount = 0
    local Players = GetPlayers()
    for i = 1, #Players, 1 do
        local Player = QBOX:GetPlayer(Players[i])
        if Player then
            local Amount = 0
            local taxPercentage = config.EconomyTaxPercentage
            local economyTax = config.EconomyTax
            if (Player.PlayerData.money.bank or Player.PlayerData.money.cash) > economyTax.low then
                Amount = (Player.PlayerData.money.bank * taxPercentage.low / 1000)
                SendNotification(Players[i], string.format(locale('Tax.Players'), taxPercentage.low, Amount))
            elseif (Player.PlayerData.money.bank or Player.PlayerData.money.cash) > economyTax.medium then
                Amount = (Player.PlayerData.money.bank * taxPercentage.medium / 1000)
                SendNotification(Players[i], string.format(locale('Tax.Players'), taxPercentage.medium, Amount))
            elseif (Player.PlayerData.money.bank or Player.PlayerData.money.cash) > economyTax.high then
                Amount = (Player.PlayerData.money.bank * taxPercentage.high / 1000)
                SendNotification(Players[i], string.format(locale('Tax.Players'), taxPercentage.high, Amount))
            elseif (Player.PlayerData.money.bank or Player.PlayerData.money.cash) > economyTax.ultra then
                Amount = (Player.PlayerData.money.bank * taxPercentage.ultra / 1000)
                SendNotification(Players[i], string.format(locale('Tax.Players'), taxPercentage.ultra, Amount))
            elseif (Player.PlayerData.money.bank or Player.PlayerData.money.cash) > economyTax.extreme then
                SendNotification(Players[i], string.format(locale('Tax.Players'), taxPercentage.extreme, Amount))
                Amount = (Player.PlayerData.money.bank * taxPercentage.extreme / 1000)
            else
                Amount = config.DefaultTax
                SendNotification(Players[i], string.format(locale('Tax.Default'), Amount))
            end
            Player.Functions.RemoveMoney('bank', math.floor(Amount), 'incometax')

            logger.log({
            source = cache.source,
            event = 'Tax Cut',
            message = string.format(locale('Logs.Players'), Player.PlayerData.citizenid, math.floor(Amount))
            })
            taxAmount = taxAmount + Amount
        end
    end
    local amount = math.floor(taxAmount)
    addMoneyToAccount(amount, string.format(locale('Lang.player_tax'), amount))
end

function CarsTax()
    local taxAmount = 0
    local Players = GetPlayers()
    local Vehicles = MySQL.query('SELECT * FROM player_vehicles', {})
    for i = 1, #Players, 1 do
        local VehCount = 0
        local LP = QBOX.GetPlayer(Players[i])
        if LP then
            for a = 1, #Vehicles, 1 do
                if LP.PlayerData.citizenid == Vehicles[a].citizenid then
                    VehCount = VehCount + 1
                end
            end
            if VehCount > 0 then
                local VehTax = VehCount * config.CarTaxRate
                local Player = QBOX.GetPlayerByCitizenId(LP.PlayerData.citizenid)
                if Player then
                    Player.Functions.RemoveMoney('bank', math.floor(VehTax), 'vehicletax') 
                    SendNotification(Player.PlayerData.source, string.format(locale('Tax.Cars'), math.floor(VehTax)))
                    logger.log({
                        source = cache.source,
                        event = 'Vehicle Tax',
                        message = string.format(locale('Logs.Cars'), Player.PlayerData.citizenid, math.floor(VehTax))
                    })
                    taxAmount = taxAmount + VehTax
                end
            end
        end
    end
    local amount = math.floor(taxAmount)
    addMoneyToAccount(amount, string.format(locale('Lang.car_tax'), amount))
end

function HousesTax()
    local taxAmount = 0
    local Players = GetPlayers()
    local Houses = MySQL.query('SELECT * FROM player_houses', {})

    for i = 1, #Players, 1 do
        local HouseCount = 0
        local LP = QBOX.GetPlayer(Players[i])
        if LP then
            for a = 1, #Houses, 1 do
                if LP.PlayerData.citizenid == Houses[a].citizenid then
                    HouseCount = HouseCount + 1
                end
            end
            if HouseCount > 0 then
                local HouseTax = HouseCount * config.HouseTaxRate
                local Player = QBOX.GetPlayerByCitizenId(LP.PlayerData.citizenid)
                if Player then
                    Player.Functions.RemoveMoney('bank', math.floor(HouseTax), 'housetax')
                    SendNotification(Player.PlayerData.source, string.format(locale('Tax.Houses'), math.floor(HouseTax)))
                    
                    logger.log({
                        source = cache.source,
                        event = 'Tax Cut',
                        message = string.format(locale('Logs.Houses'), Player.PlayerData.citizenid, math.floor(HouseTax))
                    })
                    taxAmount = taxAmount + HouseTax
                end
            end
        end
    end
    local amount = math.floor(taxAmount)
    addMoneyToAccount(amount, string.format(locale('Lang.house_tax'), amount))
end

function GetCurrentTax(src, taxeType)
    local Player = QBOX.GetPlayer(src)
    if Player then
        if taxeType == 'income' then
            if (Player.PlayerData.money.bank or Player.PlayerData.money.cash) > config.EconomyTax['low'] then
                return config.EconomyTax['low']
            elseif (Player.PlayerData.money.bank or Player.PlayerData.money.cash) > config.EconomyTax['medium'] then
                return config.EconomyTax['medium']
            elseif (Player.PlayerData.money.bank or Player.PlayerData.money.cash) > config.EconomyTax['high'] then
                return config.EconomyTax['high']
            elseif (Player.PlayerData.money.bank or Player.PlayerData.money.cash) > config.EconomyTax['ultra'] then
                return config.EconomyTax['ultra']
            elseif (Player.PlayerData.money.bank or Player.PlayerData.money.cash) > config.EconomyTax['extreme'] then
                return config.EconomyTax['extreme']
            else
                return config.DefaultTax
            end
        elseif taxeType == 'vehicle' then
            return config.CarTaxRate
        elseif taxeType == 'house' then
            return config.HouseTaxRate
        end
    end
end

-- Documentation : https://overextended.dev/ox_lib/Modules/Cron/Server
cron.new("30 7 1 * *", function(task, date)
    PlayersTax()
    CarsTax()
    HousesTax()
end)