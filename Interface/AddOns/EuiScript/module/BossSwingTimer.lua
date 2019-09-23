local band = bit.band
local tinsert = table.insert
local tremove = table.remove
local next = next
local strsplit = strsplit
local strfind = strfind
local GetNetStats = GetNetStats
local E, L = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")

local k,v,_
-- Author: humfras, d07.RiV (Iroared)
-- Title: EuiBossSwingTimer
-- Notes: Displays a bar with timers for enemy auto attacks.
-- Version: 1.5b
-- SavedVariables: EuiBossSwingTimerDB

--EuiBossSwingTimer = LibStub("AceAddon-3.0"):NewAddon("EuiBossSwingTimer", "AceConsole-3.0", "AceEvent-3.0")
local EuiBossSwingTimer = E:NewModule('EuiBossSwingTimer', 'AceEvent-3.0')

local time = GetTime()

local function MergeTables(dst, src)
	for k, v in pairs (src) do
		if type (v) ~= "table" then
			if dst[k] == nil then
				dst[k] = v
			end
		else
			if type(dst[k]) ~= "table" then
				dst[k] = {}
			end
			MergeTables(dst[k], v)
		end
	end
end

local tankspec = {
	["DEATHKNIGHT"] = 1,
	["DRUID"] = 3,
	["MONK"] = 1,
	["PALADIN"] = 2,
	["WARRIOR"] = 3,
}
local unitclass
local function istankspec()
	local currentSpec = GetSpecialization() or 0
	unitClass = unitClass or select(2, UnitClass("player"))
	return currentSpec == tankspec[unitClass]
end

EuiBossSwingTimer.swings = {}

local unitList = {{id = "target", color = {r = 1, g = 0.2, b = 0.2}}, {id = "focus", color = {r = 1, g = 1, b = 0}}}

local function npcid(guid)
	local unitType, _, _, _, _, npcID = strsplit("-", guid or "")
	return npcID
end

local function isnpc(guid)
	if strfind(guid, "^Creature") or strfind(guid, "^Vehicle") then
		return true
	end
end

function EuiBossSwingTimer:ToggleEnable()
	if E.db.euiscript.BossSwing.enabled then
		self:OnEnable()
	else
		self:OnDisable()
	end
end

function EuiBossSwingTimer:OnEnable()
	if not E.db.euiscript.BossSwing.enabled then return end
	
	self:CreateUI()
	
	self:UpdateVisibility()

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	
	self.bar:SetScript("OnShow", function() time = GetTime() end)
	
end

function EuiBossSwingTimer:UpdateVisibility()
	if (E.db.euiscript.BossSwing.hideooc and not InCombatLockdown())
	or (E.db.euiscript.BossSwing.showonlyintankspec and not istankspec()) then
		self.bar:Hide()
	else
		self.bar:Show()
	end
end

function EuiBossSwingTimer:OnDisable()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnregisterEvent("PLAYER_TARGET_CHANGED")
	self:UnregisterEvent("PLAYER_FOCUS_CHANGED")
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	
	self.bar:SetScript("OnUpdate", nil)
	
	self.bar:Hide()
end

function EuiBossSwingTimer:ShowConfig()
	LibStub("AceConfigDialog-3.0"):Open("EuiBossSwingTimer")
end


function EuiBossSwingTimer:CreateUI()
	local bartexture = 	LSM:Fetch("statusbar", E.db.euiscript.BossSwing.frame.texture)

	if not self.bar then
		self.bar = CreateFrame("Frame", "EuiBossSwingTimerBar", E.UIParent)
		self.bar:SetClampedToScreen(true)
		self.bar:EnableMouse(true)
		self.bar:SetSize(E.db.euiscript.BossSwing.frame.width, E.db.euiscript.BossSwing.frame.height)
		self.bar:SetScale(E.db.euiscript.BossSwing.frame.scale)

		self.bar:SetPoint("CENTER", "E.UIParent", "CENTER", 0, 300)

		E:CreateMover(EuiBossSwingTimerBar, "EuiBossSwingTimerBarMover", L["EuiBossSwingTimerBar"], nil, nil, nil, "ALL,EUI")
	end
	if not self.bar.lag then
		self.bar.lag = self.bar:CreateTexture(nil, "BACKGROUND")
		self.bar.lag:SetPoint("TOPLEFT", self.bar, "TOPLEFT", 0, 0)
		self.bar.lag:SetPoint("BOTTOMLEFT", self.bar, "BOTTOMLEFT", 0, 0)
	end
	self.bar.lag:SetWidth(1)
	self.bar.lag:SetTexture(bartexture)
	self.bar.lag:SetVertexColor(0.6, 0.0, 0.0)
	self.bar.lag:SetAlpha(E.db.euiscript.BossSwing.frame.alpha)
	if not self.bar.background then
		self.bar.background = self.bar:CreateTexture(nil, "BACKGROUND")
	end
	self.bar.background:SetTexture(bartexture)
	self.bar.background:SetVertexColor(0.4, 0.4, 0.4)
	self.bar.background:SetAlpha(E.db.euiscript.BossSwing.frame.alpha)
	
	if E.db.euiscript.BossSwing.frame.lag then
		self.bar.background:ClearAllPoints()
		self.bar.background:SetPoint("TOPLEFT", self.bar.lag, "TOPRIGHT", 0, 0)
		self.bar.background:SetPoint("BOTTOMRIGHT", self.bar, "BOTTOMRIGHT", 0, 0)
		self.bar.lag:Show()
	else
		self.bar.background:ClearAllPoints()
		self.bar.background:SetPoint("TOPLEFT", self.bar, "TOPLEFT", 0, 0)
		self.bar.background:SetPoint("BOTTOMRIGHT", self.bar, "BOTTOMRIGHT", 0, 0)
		self.bar.background:SetTexCoord(0,1,0,1)
		self.bar.lag:Hide()
	end
	
	self.bar:SetScript("OnUpdate", function(f,elapsed) self:OnUpdate(elapsed) end)

	self.bar:SetSize(E.db.euiscript.BossSwing.frame.width, E.db.euiscript.BossSwing.frame.height)
	self.bar:SetScale(E.db.euiscript.BossSwing.frame.scale)
end

function EuiBossSwingTimer:UpdateAttackSpeeds()
	for _, u in ipairs(unitList) do
		local uid = UnitGUID(u.id)
		if uid and isnpc(uid) then
			local speed = UnitAttackSpeed(u.id)
			if speed then
				E.global.BossSwing.speeds[npcid(uid)] = {value = speed, api = true}
			end
		end
	end
end

function EuiBossSwingTimer:OnSwing(time, guid, damage)
	time = time
	self:UpdateAttackSpeeds()

	local id = npcid(guid)
	self.swings[guid] = self.swings[guid] or {}
	local prev = self.swings[guid].time
	self.swings[guid].time = time
	local speed = nil
	if prev and (time - prev) < 5 then
		speed = time - prev
	end
	if E.global.BossSwing.speeds[id] and E.global.BossSwing.speeds[id].api then
		speed = E.global.BossSwing.speeds[id].value
	elseif speed then
		E.global.BossSwing.speeds[id] = {value = speed}
	end
	if speed then
		self.swings[guid].next = time + speed
		if damage then
			self.swings[guid].damage = damage
		end
	end
end

-- gui --

EuiBossSwingTimer.texpool = {}
function EuiBossSwingTimer:CreateTick()
	if #self.texpool > 0 then
		return tremove(self.texpool)
	end
	local result = self.bar:CreateTexture(nil, "ARTWORK")
	result:SetTexture("Interface\\AddOns\\EuiScript\\textures\\tick.tga")
	result:SetTexCoord(0.40625, 0.5625, 0, 1)
	result:SetPoint("TOP", self.bar, "TOP", 0, 0)
	result:SetPoint("BOTTOM", self.bar, "BOTTOM", 0, 0)
	result:SetWidth(5)
	return result
end
function EuiBossSwingTimer:RecycleTick(tex)
	tinsert(self.texpool, tex)
	tex:Hide()
end


local special = {}
local alpha = 1
local color = {r = 0.7, g = 0.7, b = 0.7}
function EuiBossSwingTimer:OnUpdate(elapsed)
	
	time = time + elapsed
	
	for _, u in ipairs(unitList) do
		local uid = UnitGUID(u.id)
		if uid then
			special[uid] = u.color
		end
	end

	local length = E.db.euiscript.BossSwing.frame.length
	
	if E.db.euiscript.BossSwing.frame.lag then
		local _,_,_,lag = GetNetStats()
		--lag = lag / 1000
		if lag > length then
			lag = length
		end
		local lagwidth = lag / length
		self.bar.lag:SetWidth(lagwidth * E.db.euiscript.BossSwing.frame.width)
		self.bar.lag:SetTexCoord(0,lagwidth,0,1)
		self.bar.background:SetTexCoord(lagwidth,1,0,1)
	end

	local maxDamage = 1
	local length = E.db.euiscript.BossSwing.frame.length / 1000
	for k, v in pairs(self.swings) do
		if not v.next or v.next < time then
			v.next = nil
			if v.tick then
				self:RecycleTick(v.tick)
				v.tick = nil
			end
		elseif v.damage and v.damage > maxDamage then
			maxDamage = v.damage
		end
	end
	for k, v in pairs(self.swings) do
		if v.next and v.next < time + length then
			if not v.tick then
				v.tick = self:CreateTick()
			end
			local c
			if special[k] then
				c = special[k]
			else
				if v.damage and v.damage < maxDamage then
					alpha = v.damage / maxDamage
				end
				c = color
			end
			v.tick:SetVertexColor(c.r, c.g, c.b, alpha)
			v.tick:SetPoint("LEFT", self.bar, "LEFT", (v.next - time) / length * E.db.euiscript.BossSwing.frame.width - 2, 0)
			if special[k] then
				v.tick:SetDrawLayer("ARTWORK", 2)
			else
				v.tick:SetDrawLayer("ARTWORK", 0)
			end
			v.tick:Show()
		end 
	end
	for k,v in pairs(special) do
	  special[k] = nil
	end
end

---------
local events = {
	["SWING_DAMAGE"] = true,
	["SWING_MISSED"] = true,
	["UNIT_DIED"] = true,
}
function EuiBossSwingTimer:COMBAT_LOG_EVENT_UNFILTERED()
	local _, mainevent, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, _, _, extraArg3 = CombatLogGetCurrentEventInfo()
	if not events[event] then return end
	if sourceGUID == "0x0000000000000000" or sourceGUID == nil or sourceName == nil then return end	--check for environmental damage
	if (event == "SWING_DAMAGE" or event == "SWING_MISSED") and destGUID == UnitGUID("player") and isnpc(sourceGUID) then
		self:OnSwing(GetTime(), sourceGUID, event == "SWING_DAMAGE" and extraArg3)
	elseif event == "UNIT_DIED" then
		local v = EuiBossSwingTimer.swings[destGUID]
		if v and v.tick then
			self:RecycleTick(v.tick)
			v.tick = nil
		end
		EuiBossSwingTimer.swings[destGUID] = nil	--remove the UnitGUID from the table if the unit dies
	end
end

function EuiBossSwingTimer:PLAYER_REGEN_DISABLED()
	if not (E.db.euiscript.BossSwing.showonlyintankspec and not istankspec()) then
		self.bar:Show()
	end
end

function EuiBossSwingTimer:PLAYER_REGEN_ENABLED()
	if E.db.euiscript.BossSwing.hideooc then
		self.bar:Hide()
	end
end

EuiBossSwingTimer.PLAYER_TARGET_CHANGED = EuiBossSwingTimer.UpdateAttackSpeeds
EuiBossSwingTimer.PLAYER_FOCUS_CHANGED = EuiBossSwingTimer.UpdateAttackSpeeds

function EuiBossSwingTimer:Initialize()
	if IsAddOnLoaded("BossSwingTimer") then return; end

	self:OnEnable()
end

E:RegisterModule(EuiBossSwingTimer:GetName())