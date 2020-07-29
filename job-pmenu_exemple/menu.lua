local PlayerData, CurrentActionData, HandcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, isHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
ESX = nil
locksound = false
onDuty = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)



RegisterNetEvent('esx_garbagejob:onDuty')
AddEventHandler('esx_garbagejob:onDuty', function()
	onDuty = true
end)

RegisterNetEvent('esx_garbagejob:offDuty')
AddEventHandler('esx_garbagejob:offDuty', function()
	onDuty = false
end)
---------- MENU VESTIAIRE-----

local MyMenus = {
	Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {255, 255, 255}, Title = "Vestiaire" },
	Data = { currentMenu = "Vos tenues", "Test" },
	Events = {
		onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
			PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			local slide = btn.slidenum
			local btn = btn.name
			local check = btn.unkCheckbox
			if btn == "Reprendre vos affaires" then
				TriggerServerEvent("player:serviceOff", "garbage")
				TriggerEvent('esx_garbagejob:offDuty')
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
				end)
				SetPedArmour(playerPed, 0)			
			elseif btn == "Tenue Eboueur" then
				TriggerServerEvent("player:serviceOn", "garbage")
				TriggerEvent('esx_garbagejob:onDuty')

				TriggerEvent('skinchanger:getSkin', function(skin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.eboueur_wear.male)
					elseif skin.sex == 1 then
						TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.eboueur_wear.female)
				end
			end)
		end
	end,
},
	Menu = {
		["Vos tenues"] = {
			b = {
				{name = "Reprendre vos affaires", ask = ">", askX = true},
				{name = "----------------------------------------"},
				{name = "Tenue Eboueur", ask = ">", askX = true},
			}
		}
	}
}
------------ FIN MENU VESTAIRE ----------
---------------- UNIFORME garbage -----------

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end


--------------- UNIFORM garbage ---------------------
----------------- GARAGE garbage ---------------------

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(50)
    end

    local vehicle = CreateVehicle(car, -585.81, -1594.99, 26.75, 356.74, true, false)
	SetEntityAsMissionEntity(vehicle, true, true)
	SetVehicleNumberPlateText(vehicle, "Eboueur")
        
end


local service = {
	"ON",
	"OFF"
}

local linked = {
	"ll",
	"oof"
}

local test = {
	false,
	true
}

--------------- GARAGE garbage FINI-------------
--------------- MENU F6 garbage ----------

function LoadingPrompt(loadingText, spinnerType)

    if IsLoadingPromptBeingDisplayed() then
        RemoveLoadingPrompt()
    end

    if (loadingText == nil) then
        BeginTextCommandBusyString(nil)
    else
        BeginTextCommandBusyString("STRING");
        AddTextComponentSubstringPlayerName(loadingText);
    end

    EndTextCommandBusyString(spinnerType)
end


local mobgarbageMenu = {
	Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {255, 255, 255}, Title = "Menu" },
	Data = { currentMenu = "Interaction Eboueur", "Test" },
	Events = {
		onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
			PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			local slide = btn.slidenum
			local btn = btn.name
			local check = btn.unkCheckbox
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			
			if slide == 1 and btn == "Mon service :" then
				TriggerServerEvent("player:serviceOn", "garbage")
				TriggerEvent('esx_garbagejob:onDuty')
				ESX.ShowColoredNotification("Vous êtes en service", 210)
			elseif slide == 2 and btn == "Mon service :" then 
				TriggerEvent('esx_garbagejob:offDuty')
				TriggerServerEvent("player:serviceOff", "garbage")
				ESX.ShowColoredNotification("~r~Vous n'êtes plus en service", 140)
			elseif btn == "Annonces" then
				OpenMenu("annonces :")
			elseif btn == "Annonce de recrutement" then
				if PlayerData.job.grade_name == 'boss' then
				LoadingPrompt("La central commence l'envoie de l'annonce", 5)
				Citizen.Wait(2500)
				RemoveLoadingPrompt()
				TriggerServerEvent("AnnounceEboueurRecrutement")
				self:CloseMenu("true")
				else
					ESX.ShowNotification("~r~ERREUR :\n~w~Vous ne pouvez pas rediger cette annonce !")
				end
			elseif btn == "Annonce de passage des eboueurs" then
				LoadingPrompt("La central commence l'envoie de l'annonce", 5)
				Citizen.Wait(2500)
				RemoveLoadingPrompt()
				TriggerServerEvent("AnnounceEboueurPassage")
				self:CloseMenu("true")
			
		end
	end,
},
	Menu = {
		["Interaction Eboueur"] = {
			b = {
				{name = "Annonces", ask = ">", askX = true},
				{name = "Mon service :", slidemax = service}
			}
		},
		["annonces :"] = {
			b = {
				{name = "Annonce de recrutement"},
				{name = "Annonce de passage des eboueurs"}
			}
		}
	}
}
---------------- FIN MENU F6 garbage ---------------

-- Create blips
Citizen.CreateThread(function()

	for k,v in pairs(Config.EboueurStations) do
		local blip = AddBlipForCoord(v.Blip.Coords)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(_U('map_blip'))
		EndTextCommandSetBlipName(blip)
	end

end)



local cloak = {
    {x = -619.92, y = -1617.95, z = 33.01},
}

local garage = {
    {x = -589.89, y = -1595.87, z = 26.9}
}

local boss = {
    {x = -616.83, y = -1622.91, z = 33.01}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if IsControlJustPressed(1,167) and PlayerData.job and PlayerData.job.name == 'garbage' then
			CreateMenu(mobgarbageMenu)
		end

		for k in pairs(cloak) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, cloak[k].x, cloak[k].y, cloak[k].z)

            if dist <= 1.2 and PlayerData.job and PlayerData.job.name == 'garbage' then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour accéder à votre ~b~casier~s~")
				if IsControlJustPressed(1,38) then 
					CreateMenu(MyMenus)
				end
            end
		end
		for k in pairs(garage) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, garage[k].x, garage[k].y, garage[k].z)

            if dist <= 1.2 and onDuty and PlayerData.job and PlayerData.job.name == 'garbage' then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour intéragir avec ~g~Mark~s~")
				if IsControlJustPressed(1,38) then 
					FreezeEntityPosition(GetPlayerPed(-1), true)
					DrawSub("~g~[Mark]~w~ : Salut tu as besoin de véhicule ?", 2000)
					Citizen.Wait(1500)
					DrawSub("~b~[Vous]~w~ : Oui , je voudrais biens avoir un trash s'il vous plaît .", 2000)
					Citizen.Wait(2500)
					DrawSub("~g~[Mark]~w~ : Biensur , je vous prépare sa !", 2000)
					Citizen.Wait(1500)
					LoadingPrompt("Préparation du véhicule ...", 5)
					Citizen.Wait(5000)
					ESX.ShowNotification("~g~Informations :\n\n~w~Ton véhicule se trouve a ta gauche")
					FreezeEntityPosition(GetPlayerPed(-1), false)
					RemoveLoadingPrompt()
					spawnCar("trash")
				end
            end
		end
		for k in pairs(boss) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, boss[k].x, boss[k].y, boss[k].z)

            if dist <= 1.2 and onDuty and PlayerData.job and PlayerData.job.name == 'garbage' and PlayerData.job.grade_name == 'boss' then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour accéder à l'ordinateur de ~b~l'entreprise~s~")
				if IsControlJustPressed(1,38) then 
					TriggerEvent('esx_society:openBossMenu', 'garbage', function(data, menu)
						menu.close()
					end, {wash = false})
				end
            end
        end
    end
end)


Citizen.CreateThread(function()
    local hash = GetHashKey("s_m_y_armymech_01")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", "s_m_y_armymech_01", -589.93, -1596.48, 25.9, 348.77, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
end)

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end


print("^0======================================================================^7") print("^0[^4Author^0] ^7:^0 Kadir , Péèlo^7") print("^0[^1Discord^0] ^7:^0 ^5https://discord.gg/3hdA8J4^7") print("^0======================================================================^7") 
