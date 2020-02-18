local assets =
{
	Asset("ANIM", "anim/lamp_post2.zip"),
    Asset("ANIM", "anim/lamp_post2_city_build.zip"),    
    Asset("ANIM", "anim/lamp_post2_yotp_build.zip"),
    Asset("INV_IMAGE", "city_lamp"),
}

local INTENSITY = 0.6

-----------------------------------------------------------------------------------------------------------------

local function GetStatus(inst)
    return not inst.lighton and "ON" or nil
end

local function fadein(inst)
    inst.components.fader:StopAll()
    inst.AnimState:PlayAnimation("on")
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
    inst.AnimState:PushAnimation("idle", true)
    inst.Light:Enable(true)

	if inst:IsAsleep() then
		inst.Light:SetIntensity(INTENSITY)
	else
		inst.Light:SetIntensity(0)
		inst.components.fader:Fade(0, INTENSITY, 3+math.random()*2, function(v) inst.Light:SetIntensity(v) end)
	end
end

local function fadeout(inst)
    inst.components.fader:StopAll()
    inst.AnimState:PlayAnimation("off")    
    inst.AnimState:PushAnimation("idle", true)

	if inst:IsAsleep() then
		inst.Light:SetIntensity(0)
	else
		inst.components.fader:Fade(INTENSITY, 0, .75+math.random()*1, function(v) inst.Light:SetIntensity(v) end)
	end
end

local function updatelight(inst)
	if not TheWorld.state.isday or TUNING.CITYLAMP_LIGHT_ALWAYS_ON == 1 then
        if not inst.lighton then
            inst:DoTaskInTime(math.random()*2, function() fadein(inst) end)
        else            
            inst.Light:Enable(true)
            inst.Light:SetIntensity(INTENSITY)
        end
		
        inst.AnimState:Show("FIRE")
        inst.AnimState:Show("GLOW")        
        inst.lighton = true

	elseif TheWorld.state.isday and TUNING.CITYLAMP_LIGHT_ALWAYS_ON == 0 then
        if inst.lighton then
            inst:DoTaskInTime(math.random()*2, function() fadeout(inst) end)            
        else
            inst.Light:Enable(false)
            inst.Light:SetIntensity(0)
        end

        inst.AnimState:Hide("FIRE")
        inst.AnimState:Hide("GLOW")        
        inst.lighton = false
    end
end

-----------------------------------------------------------------------------------------------------------------

local function LightIsRed(inst)
	inst.Light:SetColour(.85,.35,.5)
	inst.lightstate = "red"
end

local function LightIsOrange(inst)
	inst.Light:SetColour(1,.65,0)
	inst.lightstate = "orange"
end

local function LightIsYellow(inst)
	inst.Light:SetColour(1,1,0)
	inst.lightstate = "yellow"
end

local function LightIsGreen(inst)
	inst.Light:SetColour(.2,1,.2)
	inst.lightstate = "green"
end

local function LightIsBlue(inst)
	inst.Light:SetColour(.4,.8,1)
	inst.lightstate = "blue"
end

local function LightIsPurple(inst)
	inst.Light:SetColour(.7,.3,.85)
	inst.lightstate = "purple"
end

local function LightIsBlack(inst)
	inst.Light:SetColour(.6,.6,.6)
	inst.lightstate = "black"
end

local function LightIsWhite(inst)
	inst.Light:SetColour(1,1,1)
	inst.lightstate = "white"
end

local function ShouldAcceptItem(inst, item)
	return inst.lighton and 
		(item.prefab == "red_cap" 		or item.prefab == "thulecite_pieces" or 
		item.prefab == "goldnugget"		or item.prefab == "green_cap" 		 or
		item.prefab == "blue_cap" 		or item.prefab == "spidergland" 	 or
		item.prefab == "nightmarefuel" 	or item.prefab == "lightbulb")
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.prefab == "red_cap" then
		LightIsRed(inst, true)
	elseif item.prefab == "thulecite_pieces" then
		LightIsOrange(inst, true)
	elseif item.prefab == "goldnugget" then
		LightIsYellow(inst, true)
	elseif item.prefab == "green_cap" then
		LightIsGreen(inst, true)
	elseif item.prefab == "blue_cap" then
		LightIsBlue(inst, true)
	elseif item.prefab == "spidergland" then
		LightIsPurple(inst, true)
	elseif item.prefab == "nightmarefuel" then
		LightIsBlack(inst, true)
	elseif item.prefab == "lightbulb" then
		LightIsWhite(inst, true)
	end
	
	inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end

local function OnRefuseItem(inst, item)
	inst.SoundEmitter:PlaySound("dontstarve/common/together/spot_light/electricity")
	inst.AnimState:PlayAnimation("idle", true)
end

-----------------------------------------------------------------------------------------------------------------

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)
    inst:DoTaskInTime(0.3, function() updatelight(inst) end)
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
    inst:DoTaskInTime(0, function() updatelight(inst) end)
end

local function onsave (inst, data)
	if inst.lighton then
		data.lighton = inst.lighton
    end	
	
	if inst.lightstate then
		data.lightstate = inst.lightstate
	end
end       

local function onload(inst, data)
	if data then
		if data.lighton then 
			fadein(inst)
			inst.Light:Enable(true)
			inst.Light:SetIntensity(INTENSITY)            
			inst.AnimState:Show("FIRE")
			inst.AnimState:Show("GLOW")        
		 	inst.lighton = true
		end
	
		if data.lightstate == "red" then
			LightIsRed(inst)
		elseif data.lightstate == "orange" then
			LightIsBlue(inst)
		elseif data.lightstate == "yellow" then
			LightIsBlue(inst)
		elseif data.lightstate == "green" then
			LightIsBlue(inst)
		elseif data.lightstate == "cyan" then
			LightIsCyan(inst)
		elseif data.lightstate == "blue" then
			LightIsBlue(inst)
		elseif data.lightstate == "purple" then
			LightIsPurple(inst)	
		elseif data.lightstate == "dark" then
			LightIsPurple(inst)	
		elseif data.lightstate == "white" then
			LightIsPurple(inst)				
		end
	end
end

-----------------------------------------------------------------------------------------------------------------

local function fn(Sim)
	local inst = CreateEntity()
	local minimap = inst.entity:AddMiniMapEntity()
	if TUNING.CITYLAMP_MINIMAP == 1 then
		minimap:SetIcon( "city_lamp.tex" )
	end
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	inst.entity:AddPhysics()
	inst.entity:AddSoundEmitter()
	
	MakeObstaclePhysics(inst, 0.25)
	MakeSnowCoveredPristine(inst)
	
	inst.Light:SetColour(197/255, 197/255, 10/255)
	inst.Light:SetFalloff(0.9)
	inst.Light:SetIntensity(INTENSITY)
	inst.Light:SetRadius(TUNING.CITYLAMP_LIGHT_RADIUS)
	inst.Light:Enable(false)
	inst.Light:EnableClientModulation(true)

	if TUNING.CITYLAMP_LAMP_SKIN == 0 then
		inst.AnimState:SetBuild("lamp_post2_city_build")
	elseif TUNING.CITYLAMP_LAMP_SKIN == 1 then
		inst.AnimState:SetBuild("lamp_post2_yotp_build")
	end
	
	inst.AnimState:SetBank("lamp_post")
    inst.AnimState:SetRayTestOnBB(true);
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("FIRE")
	inst.AnimState:Hide("GLOW")

	inst:AddTag("CITY_LAMP")
    inst:AddTag("city_hammerable")
    inst:AddTag("lightsource")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("fader")
	inst:WatchWorldState("iscavedusk", function() updatelight(inst)	end)
	inst:WatchWorldState("iscaveday", function() updatelight(inst) end)
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus 
	
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)  
	
    inst:ListenForEvent("onbuilt", onbuilt)
		
	inst.OnSave = onsave
    inst.OnLoad = onload
	
	return inst
end

return Prefab("common/objects/city_lamp", fn, assets),
	MakePlacer("common/city_lamp_placer", "lamp_post", "lamp_post2_city_build", "idle", false, false, true)

