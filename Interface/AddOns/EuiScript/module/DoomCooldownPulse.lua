local fadeInTime, fadeOutTime, maxAlpha, animScale, iconSize, holdTime, showSpellName, ignoredSpells, invertIgnored
local E, L = unpack(ElvUI) -- Import Functions/Constants, Config, Locales
local CF = E:NewModule("CooldownFlash", "AceEvent-3.0", "AceHook-3.0")
CF.modName = L["ÖÐ²¿ÀäÈ´ÉÁ¹â"]

local cooldowns, animating, watching = { }, { }, { }
local GetTime = GetTime

local defaultSettings = {
    fadeInTime = 0.3,
    fadeOutTime = 0.7,
    maxAlpha = 0.7,
    animScale = 1.5,
    iconSize = 75,
    holdTime = 0,
    petOverlay = {1,1,1},
    showSpellName = nil,
    x = UIParent:GetWidth()*UIParent:GetEffectiveScale()/2,
    y = UIParent:GetHeight()*UIParent:GetEffectiveScale()/2
}

local defaultSettingsPerCharacter = {
    ignoredSpells = "",
    invertIgnored = false
}

local DCP = CreateFrame("frame", "DCP", E.UIParent)
DCP:SetAlpha(0)
DCP:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
DCP.TextFrame = DCP:CreateFontString(nil, "ARTWORK")
DCP.TextFrame:SetPoint("TOP",DCP,"BOTTOM",0,-5)
DCP.TextFrame:SetWidth(185)
DCP.TextFrame:SetJustifyH("CENTER")
DCP.TextFrame:SetTextColor(1,1,1)
DCP.ignoredSpells = {}

local DCPT = DCP:CreateTexture(nil,"BACKGROUND")
DCPT:SetTexCoord(.08, .92, .08, .92)
DCPT:SetAllPoints(DCP)

-----------------------
-- Utility Functions --
-----------------------
local function tcount(tab)
    local n = 0
    for _ in pairs(tab) do
        n = n + 1
    end
    return n
end

local function memoize(f)
    local cache = nil

    local memoized = {}

    local function get()
        if (cache == nil) then
            cache = f()
        end

        return cache
    end

    memoized.resetCache = function()
        cache = nil
    end

    setmetatable(memoized, {__call = get})

    return memoized
end

local function GetPetActionIndexByName(name)
    for i=1, NUM_PET_ACTION_SLOTS, 1 do
        if (GetPetActionInfo(i) == name) then
            return i
        end
    end
    return nil
end

local function RefreshLocals()
    fadeInTime = CF.db.fadeInTime
    fadeOutTime = CF.db.fadeOutTime
    maxAlpha = CF.db.maxAlpha
    animScale = CF.db.animScale
    iconSize = CF.db.iconSize
    holdTime = CF.db.holdTime
    showSpellName = CF.db.showSpellName
    invertIgnored = DCP_SavedPerCharacter.invertIgnored

    ignoredSpells = { }
    for _,v in ipairs({strsplit(",",DCP_SavedPerCharacter.ignoredSpells)}) do
        ignoredSpells[strtrim(v)] = true
    end
end

--------------------------
-- Cooldown / Animation --
--------------------------
local elapsed = 0
local runtimer = 0
local function OnUpdate(_,update)
    elapsed = elapsed + update
    if (elapsed > 0.05) then
        for i,v in pairs(watching) do
            if (GetTime() >= v[1] + 0.5) then
                local getCooldownDetails
                if (v[2] == "spell") then
                    getCooldownDetails = memoize(function()
                        local start, duration, enabled = GetSpellCooldown(v[3])
                        return {
                            name = GetSpellInfo(v[3]),
                            texture = GetSpellTexture(v[3]),
                            start = start,
                            duration = duration,
                            enabled = enabled
                        }
                    end)
                elseif (v[2] == "item") then
                    getCooldownDetails = memoize(function()
                        local start, duration, enabled = GetItemCooldown(i)
                        return {
                            name = GetItemInfo(i),
                            texture = v[3],
                            start = start,
                            duration = duration,
                            enabled = enabled
                        }
                    end)
                elseif (v[2] == "pet") then
                    getCooldownDetails = memoize(function()
                        local name, texture = GetPetActionInfo(v[3])
                        local start, duration, enabled = GetPetActionCooldown(v[3])
                        return {
                            name = name,
                            texture = texture,
                            isPet = true,
                            start = start,
                            duration = duration,
                            enabled = enabled
                        }
                    end)
                end

                local cooldown = getCooldownDetails()
                if ((ignoredSpells[cooldown.name] ~= nil) ~= invertIgnored) then
                    watching[i] = nil
                else
                    if (cooldown.enabled ~= 0) then
                        if (cooldown.duration and cooldown.duration > 2.0 and cooldown.texture) then
                            cooldowns[i] = getCooldownDetails
                        end
                    end
                    if (not (cooldown.enabled == 0 and v[2] == "spell")) then
                        watching[i] = nil
                    end
                end
            end
        end
        for i,getCooldownDetails in pairs(cooldowns) do
            local cooldown = getCooldownDetails()
            local remaining = cooldown.duration-(GetTime()-cooldown.start)
            if (remaining <= 0) then
                tinsert(animating, {cooldown.texture,cooldown.isPet,cooldown.name})
                cooldowns[i] = nil
            end
        end

        elapsed = 0
        if (#animating == 0 and tcount(watching) == 0 and tcount(cooldowns) == 0) then
            DCP:SetScript("OnUpdate", nil)
            return
        end
    end

    if (#animating > 0) then
        runtimer = runtimer + update
        if (runtimer > (fadeInTime + holdTime + fadeOutTime)) then
            tremove(animating,1)
            runtimer = 0
            DCP.TextFrame:SetText(nil)
            DCPT:SetTexture(nil)
            DCPT:SetVertexColor(1,1,1)
            DCP:SetSize(CF.db.iconSize, CF.db.iconSize)
        elseif CF.db.enable then
            if (not DCPT:GetTexture()) then
                if (animating[1][3] ~= nil and showSpellName) then
                    DCP.TextFrame:SetText(animating[1][3])
                end
                DCPT:SetTexture(animating[1][1])
                if animating[1][2] then
                    DCPT:SetVertexColor(unpack(CF.db.petOverlay))
                end
            end
            local alpha = maxAlpha
            if (runtimer < fadeInTime) then
                alpha = maxAlpha * (runtimer / fadeInTime)
            elseif (runtimer >= fadeInTime + holdTime) then
                alpha = maxAlpha - ( maxAlpha * ((runtimer - holdTime - fadeInTime) / fadeOutTime))
            end
            DCP:SetAlpha(alpha)
            local scale = iconSize+(iconSize*((animScale-1)*(runtimer/(fadeInTime+holdTime+fadeOutTime))))
            DCP:SetWidth(scale)
            DCP:SetHeight(scale)
        end
    end
end

--------------------
-- Event Handlers --
--------------------
function DCP:UNIT_SPELLCAST_SUCCEEDED(unit,spell,spellID)	
    if (unit == "player") then
        watching[spell] = {GetTime(),"spell",spellID}
        self:SetScript("OnUpdate", OnUpdate)
    end
end

function DCP:COMBAT_LOG_EVENT_UNFILTERED()
	local _, event, _, sourceGUID, sourceName, sourceFlags, _, _, _, _, _, spellID, _, _, arg15, arg16 = CombatLogGetCurrentEventInfo()
    if (event == "SPELL_CAST_SUCCESS") then
        if (band(sourceFlags,COMBATLOG_OBJECT_TYPE_PET) == COMBATLOG_OBJECT_TYPE_PET and bit.band(sourceFlags,COMBATLOG_OBJECT_AFFILIATION_MINE) == COMBATLOG_OBJECT_AFFILIATION_MINE) then
            local name = GetSpellInfo(spellID)
            local index = GetPetActionIndexByName(name)
            if (index and not select(6,GetPetActionInfo(index))) then
                watching[name] = {GetTime(),"pet",index}
            elseif (not index and name) then
                watching[name] = {GetTime(),"spell",spellID}
            else
                return
            end
            self:SetScript("OnUpdate", OnUpdate)
        end
    end
end

function DCP:PLAYER_ENTERING_WORLD()
    local inInstance,instanceType = IsInInstance()
    if (inInstance and instanceType == "arena") then
        self:SetScript("OnUpdate", nil)
        wipe(cooldowns)
        wipe(watching)
    end
end

function CF:UseAction(slot)
    local actionType,itemID = GetActionInfo(slot)
    if (actionType == "item") then
        local texture = GetActionTexture(slot)
        watching[itemID] = {GetTime(),"item",texture}
	--	DCP:SetScript("OnUpdate", OnUpdate)
    end
end

function CF:UseInventoryItem(slot)
    local itemID = GetInventoryItemID("player", slot);
    if (itemID) then
        local texture = GetInventoryItemTexture("player", slot)
        watching[itemID] = {GetTime(),"item",texture}
	--	DCP:SetScript("OnUpdate", OnUpdate)
    end
end

function CF:UseContainerItem(bag,slot)
    local itemID = GetContainerItemID(bag, slot)
    if (itemID) then
        local texture = select(10, GetItemInfo(itemID))
        watching[itemID] = {GetTime(),"item",texture}
	--	DCP:SetScript("OnUpdate", OnUpdate)
    end
end

function CF:EnableCooldownFlash()
    self:SecureHook("UseContainerItem")
    self:SecureHook("UseInventoryItem")
    self:SecureHook("UseAction")
--	self:SecureHook("UseItemByName")
    DCP:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    DCP:RegisterEvent("PLAYER_ENTERING_WORLD")
	if self.db.enablePet then
		DCP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

function CF:DisableCooldownFlash()
    self:Unhook("UseContainerItem")
    self:Unhook("UseInventoryItem")
    self:Unhook("UseAction")
--	self:Unhook("UseItemByName")
    DCP:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    DCP:UnregisterEvent("PLAYER_ENTERING_WORLD")
    DCP:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function CF:Initialize()
	CF.db = E.db.CooldownFlash
    DCP:SetSize(CF.db.iconSize, CF.db.iconSize)
    DCP:CreateShadow()
    DCP.TextFrame:FontTemplate(E["media"].font, 18, "OUTLINE")
    DCP.TextFrame:SetShadowOffset(2, -2)
    if self.db.enable then
        self:EnableCooldownFlash()
    end
    DCP:SetPoint("CENTER", E.UIParent, "CENTER", -100, 50)
	E:CreateMover(DCP, "CooldownFlashMover", L["Middle CD Reminder"], true, nil, nil, "ALL, EUI", nil, "Watch,CooldownFlash", "db,CooldownFlash,enable")  

    for _,v in ipairs({strsplit(",",CF.db.ignoredSpells)}) do
        DCP.ignoredSpells[strtrim(v)] = true
    end
	
    local spellname,_, icon = GetSpellInfo(16914)
    testtable = { icon, nil, spellname }
	
	DCP.animating = animating
	DCP.testtable = testtable
end

E:RegisterModule(CF:GetName())