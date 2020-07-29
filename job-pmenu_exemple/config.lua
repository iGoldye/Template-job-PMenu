Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableESXService           = false -- test
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds

Config.MaxInService               = 10
Config.Locale                     = 'fr'

Config.EboueurStations = {

	Eboueur = {

		Blip = {
			Coords  = vector3(-617.32, -1622.76, 33.01),
			Sprite  = 318,
			Display = 4,
			Scale   = 0.9,
			Colour  = 2
		},
	}
}


-- Tenue Eboueur

Config.Uniforms = {
	eboueur_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 0,
			['torso_1'] = 22,   ['torso_2'] = 0,
			['arms'] = 63,
			['pants_1'] = 36,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 0,
			['torso_1'] = 141,   ['torso_2'] = 0,
			['arms'] = 72,
			['pants_1'] = 35,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
		}
	}
}