name 				= "Lamp Post without alloy"
description 		= "Configurable Hamlet lamp post"
author				= "Mentalistpro and CrazyCat"
version 			= "1.2"
api_version 		= 10

dst_compatible 			= true
all_clients_require_mod = true
client_only_mod 		= false

server_filter_tags 	= {"hamlet"}

icon_atlas 			= "modicon.xml"
icon 				= "modicon.tex"

configuration_options = {
	{
	name = "light_radius", 
	label = "Light Radius",
	options = {
			  {description = "1", data = 1},
			  {description = "2", data = 2},
			  {description = "3", data = 3},
			  {description = "4", data = 4},
			  {description = "5", data = 5},
			  {description = "6", data = 6},
			  {description = "7", data = 7},
			  {description = "8", data = 8},
			  {description = "9", data = 9},
			  {description = "10", data = 10},
	          },
	default = 5
	},
	{
	name = "light_always_on", 
	label = "Light Availability",
	options = {
			  {description = "Default", data = 0},
			  {description = "Always ON", data = 1},
	          },
	default = 0
	},
	{
	name = "lamp_skin", 
	label = "Lamp Appearance",
	options = {
			  {description = "Default", data = 0},
			  {description = "Pig Fiesta", data = 1},
	          },
	default = 0
	},
	{
	name = "rec_difficulty", 
	label = "Recipe Difficulty",
	options = {
			  {description = "Realistic", data = 0},
			  {description = "Default", data = 1},
			  {description = "Cheating", data = 2},
	          },
	default = 1
	},
	{
	name = "minimap_icon", 
	label = "Minimap Icon",
	options = {
			  {description = "OFF", data = 0},
			  {description = "ON", data = 1},
	          },
	default = 0
	},
}
