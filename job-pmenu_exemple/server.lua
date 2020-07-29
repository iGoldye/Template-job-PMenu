ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- if Config.EnableESXService then
-- 	TriggerEvent('esx_service:activateService', 'garbage', Config.MaxInService)
-- end


TriggerEvent('esx_society:registerSociety', 'garbage', 'Little Pricks', 'society_garbage', 'society_garbage', 'society_garbage', {type = 'public'})

RegisterServerEvent('AnnounceEboueurRecrutement')
AddEventHandler('AnnounceEboueurRecrutement', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showNotification', xPlayers[i], '~y~Little Pricks\n\n~b~Annonce :\n\n~w~Les Eboueurs recrute des personnes sérieuse n\'hésite pas !')
	end
end)

RegisterServerEvent('AnnounceEboueurPassage')
AddEventHandler('AnnounceEboueurPassage', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showNotification', xPlayers[i], '~y~Little Pricks\n\n~b~Annonce :\n\n~w~Les Eboueurs viennent tourner en ville sortez vos poubelles !')
	end
end)