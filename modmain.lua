PrefabFiles =
{
}

Assets =
{
    Asset("ATLAS", "images/inventoryimages/city_lamp.xml")
}

-----------------------------------------------------------------------------------------

--[[[CONTENT]]
--#1 Configs
--#2 City_lamp
--#3 PostInit

-----------------------------------------------------------------------------------------
--#1 Configs

AddMinimapAtlas("images/inventoryimages/city_lamp.xml")

TUNING.CITYLAMP_LIGHT_ALWAYS_ON = GetModConfigData("ison")
TUNING.CITYLAMP_LIGHT_RADIUS = GetModConfigData("radius")
TUNING.CITYLAMP_MINIMAP = GetModConfigData("icon")
TUNING.CITYLAMP_SKIN= GetModConfigData("skin")

AddPrefabPostInit("nightmarefuel", function(inst)
    inst:AddComponent("tradable") -- so nightmare can be given to city_lamp
end)

-----------------------------------------------------------------------------------------
--#2 City_lamp

local _G = GLOBAL
local INTENSITY = 0.6

local function fadein(inst)
    inst.components.fader:StopAll()
    inst.AnimState:PlayAnimation("on")
    inst.AnimState:PushAnimation("idle", true)
    inst.SoundEmitter:PlaySound("Hamlet/common/objects/city_lamp/fire_on")
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

local function updatelight_new(inst)
    if not _G.TheWorld.state.isday or TUNING.CITYLAMP_LIGHT_ALWAYS_ON == 1 then
        if not inst.lighton then
            inst:DoTaskInTime(math.random()*2, function() fadein(inst) end)
        else
            inst.Light:Enable(true)
            inst.Light:SetIntensity(INTENSITY)
        end
        inst.AnimState:Show("FIRE")
        inst.AnimState:Show("GLOW")
        inst.lighton = true

    elseif _G.TheWorld.state.isday and TUNING.CITYLAMP_LIGHT_ALWAYS_ON == 0 then
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
    if _G.TheWorld.state.isday and TUNING.CITYLAMP_LIGHT_ALWAYS_ON == 0 then
        inst.components.heater.heat = 0
        inst.components.sanityaura.aura = 0
    end
end

local function ShouldAcceptItem(inst, item)
    return inst.lighton and
    (
        item.prefab == "red_cap"        or item.prefab == "thulecite_pieces" or
        item.prefab == "honey"          or item.prefab == "green_cap"        or
        item.prefab == "blue_cap"       or item.prefab == "spidergland"      or
        item.prefab == "nightmarefuel"  or item.prefab == "lightbulb"        or
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

local function onsave_new (inst, data)
    if inst.lighton then
        data.lighton = inst.lighton
    end

    if inst.lightstate then
        data.lightstate = inst.lightstate
    end
end

local function onload_new(inst, data)
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

-----------------------------------------------------------------------------------------
--#3 PostInit

AddPrefabPostInit("city_lamp", function(inst)
    local minimap = inst.entity:AddMiniMapEntity()
    if TUNING.CITYLAMP_MINIMAP == 0 then
        minimap:SetIcon( "city_lamp.tex" )
    end

    inst.Light:SetRadius(TUNING.CITYLAMP_LIGHT_RADIUS)

    if TUNING.CITYLAMP_SKIN == 0 then
        inst.AnimState:SetBuild("lamp_post2_city_build")
    elseif TUNING.CITYLAMP_SKIN == 1 then
        inst.AnimState:SetBuild("lamp_post2_yotp_build")
    end

    inst:WatchWorldState("iscavedusk", function() updatelight_new(inst) end)
    inst:WatchWorldState("iscaveday", function() updatelight_new(inst) end)
    inst:WatchWorldState("isdusk", function() updateaura(inst) end)
    inst:WatchWorldState("isday", function() updateaura(inst) end)

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem

    inst:AddComponent("heater")
    inst:AddComponent("lootdropper")
    inst:AddComponent("sanityaura")

    inst.onsave_new = onsave_new
    inst.onload_new = onload_new
end)