--List of prefabs and image assets in this mod. 
PrefabFiles = 
{
	"city_lamp"
}

Assets = 
{
    Asset("ATLAS", "images/inventoryimages/city_lamp.xml")
}

AddMinimapAtlas("images/inventoryimages/city_lamp.xml")

------------------------------------------------------------------------------------

--//CONTENT//
--1. Configs
--2. Recipes
--3. Strings

------------------------------------------------------------------------------------
--1. Configs

if GetModConfigData("recipe") == 0 then
	_Ingredient = Ingredient("goldnugget", 2) 
elseif GetModConfigData("recipe") == 0 then
	_Ingredient = Ingredient("goldnugget", 10)
elseif GetModConfigData("recipe") == 0 then
	_Ingredient = Ingredient("redgem", 1)
elseif GetModConfigData("recipe") == 0 then
	_Ingredient = Ingredient("alloy", 1)
end

TUNING.CITYLAMP_LIGHT_ALWAYS_ON = GetModConfigData("ison")
TUNING.CITYLAMP_LIGHT_RADIUS = GetModConfigData("radius")
TUNING.CITYLAMP_MINIMAP = GetModConfigData("icon")
TUNING.CITYLAMP_SKIN= GetModConfigData("skin")

AddPrefabPostInit("nightmarefuel", function(inst)
	inst:AddComponent("tradable") -- so nightmare can be given to city_lamp
end)

------------------------------------------------------------------------------------
--2. Recipes

local _G = GLOBAL
local Ingredient = _G.Ingredient
local RECIPETABS = _G.RECIPETABS
local TECH = _G.TECH

AddRecipe(
	"city_lamp",
	{
		_Ingredient,
		Ingredient("transistor", 1),
		Ingredient("lantern", 1)
	},
	RECIPETABS.LIGHT,
	TECH.SCIENCE_TWO,
	"city_lamp_placer",
	nil, nil, nil, nil,
	"images/inventoryimages/city_lamp.xml")

------------------------------------------------------------------------------------
--3. Strings

local _S = _G.STRINGS

if _S.CHARACTERS.WALANI == nil then 	_S.CHARACTERS.WALANI = { DESCRIBE = {},} end -- DLC002
if _S.CHARACTERS.WARBUCKS == nil then 	_S.CHARACTERS.WARBUCKS = { DESCRIBE = {},} end -- DLC003
if _S.CHARACTERS.WHEELER == nil then 	_S.CHARACTERS.WHEELER = { DESCRIBE = {},} end -- DLC003
if _S.CHARACTERS.WILBA == nil then 		_S.CHARACTERS.WILBA = { DESCRIBE = {},} end -- DLC003
if _S.CHARACTERS.WOODLEGS == nil then 	_S.CHARACTERS.WOODLEGS = { DESCRIBE = {},} end -- DLC002

_S.NAMES.CITY_LAMP = "Lamp Post"
_S.RECIPE_DESC.CITY_LAMP = "I can't believe I can make this."

_S.CHARACTERS.GENERIC.DESCRIBE.CITY_LAMP 		= { GENERIC = "Plain fire. No science involved.", ON = "Lusterless.",}
_S.CHARACTERS.WALANI.DESCRIBE.CITY_LAMP 		= { GENERIC = "Thanks for keeping me safe, light!", ON = "Pretty sure that's a lamp.",}
_S.CHARACTERS.WARBUCKS.DESCRIBE.CITY_LAMP 		= { GENERIC = "What an intriguing civilization!", ON = "No need for light in the daytime, I suppose.",}
_S.CHARACTERS.WARLY.DESCRIBE.CITY_LAMP 			= { GENERIC = "It's a small comfort.", ON = "What a quaint street lamp.",}
_S.CHARACTERS.WATHGRITHR.DESCRIBE.CITY_LAMP		= { GENERIC = "It shines bright this night.", ON = "Nary a glimmer.",}
_S.CHARACTERS.WAXWELL.DESCRIBE.CITY_LAMP 		= { GENERIC = "A welcome sign of civilization.", ON = "It eases my mind.",}
_S.CHARACTERS.WEBBER.DESCRIBE.CITY_LAMP 		= { GENERIC = "They don't turn off when I get close!", ON = "I miss street lamps.",}
_S.CHARACTERS.WENDY.DESCRIBE.CITY_LAMP 			= { GENERIC = "It cannot ward off the darkness forever.", ON = "A place to hold light.",}
_S.CHARACTERS.WHEELER.DESCRIBE.CITY_LAMP 		= { GENERIC = "A free light source. I'll take it.", ON = "Not much to look at now, but wait'll nighttime.",}
_S.CHARACTERS.WICKERBOTTOM.DESCRIBE.CITY_LAMP 	= { GENERIC = "Quite radiant.", ON = "A dormant street lamp.",}
_S.CHARACTERS.WILBA.DESCRIBE.CITY_LAMP 			= { GENERIC = "'TIS A LAMP", ON = "'TIS ONLY ALIGHT AT NIGHT",}
_S.CHARACTERS.WILLOW.DESCRIBE.CITY_LAMP 		= { GENERIC = "Fire is so versatile.", ON = "They're kinda dull in the daytime.",}
_S.CHARACTERS.WOLFGANG.DESCRIBE.CITY_LAMP 		= { GENERIC = "Wolfgang does not like the dark.", ON = "Is lamp for night lights.",}
_S.CHARACTERS.WOODIE.DESCRIBE.CITY_LAMP 		= { GENERIC = "A little bit of safe haven.", ON = "Looks like a street lamp.",}
_S.CHARACTERS.WOODLEGS.DESCRIBE.CITY_LAMP 		= { GENERIC = "Sanctuary!", ON = "A landlamp.",}
_S.CHARACTERS.WORMWOOD.DESCRIBE.CITY_LAMP 		= { GENERIC = "Big light stick", ON = "No light",}
_S.CHARACTERS.WX78.DESCRIBE.CITY_LAMP 			= { GENERIC = "PRIMITIVE SOURCE OF ILLUMINATION", ON = "NONFUNCTIONING",}

--Not original quotes
_S.CHARACTERS.WORTOX.DESCRIBE.CITY_LAMP 		= { GENERIC = "It makes light out of nowhere!", ON = "Night is now hilarious, heehee!",}
_S.CHARACTERS.WURT.DESCRIBE.CITY_LAMP 			= { GENERIC = "Big science glowy!", ON = "No more scary night lady, flort!",}

