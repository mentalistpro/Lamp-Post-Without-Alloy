local assets =
{
    Asset("ANIM", "anim/lamp_post2.zip"),
    Asset("ANIM", "anim/lamp_post2_city_build.zip"),    
    Asset("ANIM", "anim/lamp_post2_yotp_build.zip")
}

local INTENSITY = 0.6

--------------------------------------------------------------------------------------------------

--//CONTENT//
--1. Light fades
--2. Light effects
--3. Trades
--4. Miscellaneous
--5. Fn

--------------------------------------------------------------------------------------------------
--1. Light fades

local function fadein(inst)
    inst.components.fader:StopAll()
    inst.AnimState:PlayAnimation("on")
    inst.AnimState:PushAnimation("idle", true)
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
    inst.Light:Enable(true)

    if inst:IsAsleep() then
        inst.Light:SetIntensity(INTENSITY)
    else
        inst.components.fader:Fade(0, INTENSITY, 3+math.random()*2, function(v) inst.Light:SetIntensity(v) end)
        inst.Light:SetIntensity(0)
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
--2. Light effects

local function updateaura(inst)
	if inst.lightstate == "red" then
		inst.Light:SetColour(.85,.35,.5)
		inst.Light:SetIntensity(0.8)
		inst.components.heater.heat = 30
		inst.components.heater:SetThermics(true, false)
	elseif inst.lightstate == "blue" then
		inst.Light:SetColour(.4,1,1)
		inst.Light:SetIntensity(0.8)
		inst.components.heater.heat = -30
		inst.components.heater:SetThermics(false, true)
	else
		inst.components.heater.heat = 0	
	end
	
	--//TODO: aura functions have not been defined yet
	if inst.lightstate == "orange" then
		inst.Light:SetColour(1,.65,0)
		--//It's about laziness
		--AuraNoHungerCost
		inst.Light:SetIntensity(0.8)
		inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL_TINY
		
	elseif inst.lightstate == "green" then
		inst.Light:SetColour(.5,1,0)
		--//It's about perfection
		--AuraNoHalthCost
		inst.Light:SetIntensity(0.8)
		inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL_TINY

	elseif inst.lightstate == "yellow" then
		inst.Light:SetColour(1,1,0)
		--//It's about heaven
		--AuraHeal
		inst.Light:SetIntensity(0.8)
		inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL_TINY
		
	elseif inst.lightstate == "purple" then
		inst.Light:SetColour(.9,.2,.8)
		--//It's about chaos
		--AuraAttackSummonsThunder
		inst.Light:SetIntensity(0.8)
		inst.components.sanityaura.aura = -TUNING.SANITYAURA_TINY
	--//TODO: END
	elseif inst.lightstate == "black" then
		inst.Light:SetColour(.5,.5,.5)
		inst.Light:SetIntensity(0.8)
		inst.components.sanityaura.aura = 0
		
	elseif inst.lightstate == "white" then
		inst.Light:SetColour(1,1,1)
		inst.Light:SetIntensity(0.8)
		inst.components.sanityaura.aura = 0	
	
	else
		inst.Light:SetIntensity(0.6)
		inst.components.sanityaura.aura = 0	
	end
	
	if inst.lightstate == "default" then
		inst.Light:SetColour(197/255, 197/255, 10/255)
	end
	
	--when light is OFF, effects must be OFF
	if TheWorld.state.isday and TUNING.CITYLAMP_LIGHT_ALWAYS_ON == 0 then
		inst.components.heater.heat = 0	
		inst.components.sanityaura.aura = 0
	end
end

-----------------------------------------------------------------------------------------------------------------
--3. Trades

--//TODO: Replace giver component with container component

local function ShouldAcceptItem(inst, item)
    return inst.lighton and 
	(
		item.prefab == "red_cap"        or item.prefab == "thulecite_pieces" or 
        item.prefab == "honey"      	or item.prefab == "green_cap"        or
        item.prefab == "blue_cap"       or item.prefab == "spidergland"      or
        item.prefab == "nightmarefuel"  or item.prefab == "lightbulb"		 or
		item.prefab == "goldnugget"
	)
end

local function OnGetItemFromPlayer(inst, giver, item)
    if item.prefab == "red_cap" then
		inst.lightstate = "red"
    elseif item.prefab == "thulecite_pieces" then
		inst.lightstate = "orange"
    elseif item.prefab == "honey" then
		inst.lightstate = "yellow"
    elseif item.prefab == "green_cap" then
		inst.lightstate = "green"
    elseif item.prefab == "blue_cap" then
		inst.lightstate = "blue"
    elseif item.prefab == "spidergland" then
		inst.lightstate = "purple"
    elseif item.prefab == "nightmarefuel" then
		inst.lightstate = "black"
    elseif item.prefab == "lightbulb" then
		inst.lightstate = "white"
    elseif item.prefab == "goldnugget" then
		inst.lightstate = "default"
    end
	updateaura(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end

local function OnRefuseItem(inst, item)
    inst.SoundEmitter:PlaySound("dontstarve/common/together/spot_light/electricity")
    inst.AnimState:PlayAnimation("idle", true)
end

-----------------------------------------------------------------------------------------------------------------
--4. Miscellaneous

local function GetStatus(inst)
    return not inst.lighton and "ON" or nil
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
    inst:DoTaskInTime(0, function() updatelight(inst) end)
end

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
		
		inst.lightstate = data.lightstate
		updateaura(inst)
    end
end

-----------------------------------------------------------------------------------------------------------------
--5. fn

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddPhysics()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
    local minimap = inst.entity:AddMiniMapEntity()
    if TUNING.CITYLAMP_MINIMAP == 0 then
        minimap:SetIcon( "city_lamp.tex" )
    end
    
    MakeObstaclePhysics(inst, 0.25)
    MakeSnowCoveredPristine(inst)
        
    local light = inst.entity:AddLight()
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)
    inst.Light:SetColour(197/255, 197/255, 10/255)
    inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(INTENSITY)
    inst.Light:SetRadius(TUNING.CITYLAMP_LIGHT_RADIUS)

    inst.AnimState:Hide("FIRE")
    inst.AnimState:Hide("GLOW")
    inst.AnimState:PlayAnimation("idle", true)
    if TUNING.CITYLAMP_SKIN == 0 then
        inst.AnimState:SetBuild("lamp_post2_city_build")
    elseif TUNING.CITYLAMP_SKIN == 1 then
        inst.AnimState:SetBuild("lamp_post2_yotp_build")
    end
    inst.AnimState:SetBank("lamp_post")
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("CITY_LAMP")
    inst:AddTag("city_hammerable")
    inst:AddTag("lightsource")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("fader")
    inst:WatchWorldState("iscavedusk", function() updatelight(inst) end)
    inst:WatchWorldState("iscaveday", function() updatelight(inst) end)
    inst:WatchWorldState("isdusk", function() updateaura(inst) end)
    inst:WatchWorldState("isday", function() updateaura(inst) end)
    
    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus 
       
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)  
   	
    inst:AddComponent("heater")
    inst:AddComponent("lootdropper")
    inst:AddComponent("sanityaura")

    inst:ListenForEvent("onbuilt", onbuilt)
	--inst:ListenForEvent("onattackother", onAttackOther) //TODO: will trigger aura when player is attacked
        
    inst.OnSave = onsave
    inst.OnLoad = onload
    
    return inst
end

return Prefab("common/objects/city_lamp", fn, assets),
    MakePlacer("common/city_lamp_placer", "lamp_post", "lamp_post2_city_build", "idle", false, false, true)

