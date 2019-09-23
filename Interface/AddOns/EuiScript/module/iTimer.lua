local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
if not E.db.sao.enable then return; end
SetCVar('displaySpellActivationOverlays', 1)

-- SpellOverlayTimer v1.15.2 by DarkStarX, modified by nj55top  ( iTimer v1.1 )
-- modify by eui.cc at 2012/11/26
-- modify by eui.cc at 20130519 修正图标样式位置不能调整的问题,修正图标样式不影响系统自带特效.
local LSM = LibStub("LibSharedMedia-3.0")
local find = string.find

local SAO = {}
local nextUpdate = 0.2
local iconNum = 0
local OverlayRemap = {
	[88843] = 19615,
	[93426] = 91342,
	[60349] = 53817,
	[5143] = 79808,
}
local SAOF = SpellActivationOverlayFrame

local function SAO_UnitBuff(spellID, onwho)
	local i = 1
	local name, icon, count, _, _, expirationTime, _, _, _, id = UnitBuff(onwho, i)
	while name do
		i = i + 1
		if id == spellID then
			return expirationTime-GetTime(), name, count, icon
		end
		name, icon, count, _, _, expirationTime, _, _, _, id = UnitBuff(onwho, i)
	end
	return false
end

local function SAO_CreateText(self, isCount)
	local name = isCount and self.spellID .. "Count" or self.spellID .. "Timeleft"
	local color = isCount and GREEN_FONT_COLOR or ORANGE_FONT_COLOR
	local fontSize = isCount and floor(E.db.sao.iconSize/3) or E.db.sao.fontSize
	local text = self:CreateFontString(name, "ARTWORK", "CombatTextFont")
	text:SetTextColor(color.r, color.g, color.b)
	text:SetTextHeight(fontSize)
	return text
end

local function SAOTimer_OnUpdate(self, elapsed)
	nextUpdate = nextUpdate - elapsed
	if nextUpdate > 0 then return end
	local timeleft, spellname, count = SAO_UnitBuff(self.spellID, self.checkwho)
	if timeleft and timeleft < 0 then timeleft = 0 end
	if timeleft and E.db.sao.onlyTime ~= 'no' then
		spellname = (E.db.sao.onlyTime == 'time' or self.showicon) and "" or format("|cff3366ff%s|r ", spellname)
		self.text:SetText(spellname..(timeleft>0 and floor(timeleft) or ''))
	else
		self.text:SetText("")
	end
	if count and count > 1 and self.showicon then
		self.count:SetText(count)
	else
		self.count:SetText("")
	end
	nextUpdate = 0.2
	if timeleft and E.db.sao.onlyTime ~= 'no' and timeleft < 3 then --小于3秒以1位小数形式显示
		if timeleft>0 then
			self.text:SetFormattedText('%s %.1f s', spellname, timeleft)
		else
			self.text:SetText(spellname)
		end
		self.text:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		nextUpdate = 0.1
	end
end

function SAO_ShowTimer(...)
	local self, spellID, texturePath, position = ...
	if E.db.sao.useIcon and not E.db.sao.spells[E.myclass] then return; end
	if E.db.sao.useIcon and not E.db.sao.spells[E.myclass][spellID] then return; end
	
	local overlay = SpellActivationOverlay_GetOverlay(self, spellID, position)
	if OverlayRemap[spellID] then spellID = OverlayRemap[spellID] end
	local checkwho = "player"
	local timeleft, spellname, count, icon = SAO_UnitBuff(spellID, checkwho)
	if timeleft == false then
		checkwho = "pet"
		timeleft, spellname, count, icon = SAO_UnitBuff(spellID, checkwho)
	end
	if timeleft == false then return end

	local showicon = not find(texturePath, "TEXTURES\\SPELLACTIVATIONOVERLAYS\\")
	if not showicon and E.db.sao.useIcon then
		overlay.texture:SetTexture(icon)
		showicon = true
	end

	if not SAO[spellID] then
		SAO[spellID] = {}
		SAO[spellID].timer = CreateFrame("frame", spellID)
		SAO[spellID].timer:SetFrameStrata("DIALOG")
		SAO[spellID].timer.spellID = spellID
		SAO[spellID].timer.checkwho = checkwho
		SAO[spellID].timer.showicon = showicon
		SAO[spellID].timer.text = SAO_CreateText(SAO[spellID].timer)
		SAO[spellID].timer.count = SAO_CreateText(SAO[spellID].timer, true)
		SAO[spellID].timer:Hide()
		SAO[spellID].position = position
		SAO[spellID].active = false
	end
	if not SAO[spellID].active then
		if SAO[spellID].timer.showicon then iconNum = iconNum + 1 end
		SAO[spellID].active = true
		SAO[spellID].timer:Show()
		SAO[spellID].timer:SetScript("OnUpdate", SAOTimer_OnUpdate)
	end

	SAO[spellID].timer.text:ClearAllPoints()
	
	if SAO[spellID].timer.showicon then
		overlay:SetSize(E.db.sao.iconSize, E.db.sao.iconSize)
		overlay:ClearAllPoints()
		if E.db.sao.spells[E.myclass][spellID] then
			overlay:SetPoint("CENTER", SAOF, "CENTER", E.db.sao.spells[E.myclass][spellID].offsetX or 0, E.db.sao.spells[E.myclass][spellID].offsetY or 0)
		else	
		--	overlay:SetPoint("TOP", SAOF, "BOTTOM", ( iconNum - 1 ) * ( E.db.sao.iconSize + E.db.sao.iconGap ), -16)
		end
		SAO[spellID].timer.count:SetPoint("BOTTOMRIGHT", overlay, "BOTTOMRIGHT", -1, 1)
		SAO[spellID].timer.text:SetPoint("CENTER", overlay, "CENTER")
	elseif SAO[spellID].position ~= position then
		SAO[spellID].timer.text:SetPoint("CENTER", overlay, "BOTTOM", 135, 0)
	else
		SAO[spellID].timer.text:SetPoint("CENTER", overlay, "BOTTOM", E.db.sao.offsetX, E.db.sao.offsetY)
	end
end

function SAO_HideTimer(...)
	local self, spellID = ...
	if OverlayRemap[spellID] then spellID = OverlayRemap[spellID] end
	if not SAO[spellID] or not SAO[spellID].active then return end
	if SAO[spellID].timer.showicon then iconNum = iconNum - 1 end
	SAO[spellID].active = false
	SAO[spellID].timer:Hide()
	SAO[spellID].timer:SetScript("OnUpdate", nil)
end

hooksecurefunc("SpellActivationOverlay_ShowOverlay", SAO_ShowTimer)
hooksecurefunc("SpellActivationOverlay_HideOverlays", SAO_HideTimer)


-- tracker of important buffs by nj55top

local class = select(2, UnitClass("player"))
local Tracker = CreateFrame("FRAME")
Tracker:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, ...) end end)
Tracker:RegisterUnitEvent("UNIT_AURA", "player")

function Tracker:UNIT_AURA(unit)
	if unit ~= "player" or not E.db.sao.spells[class] then return end

	local i = 1
	local name, icon, _, _, _, _, _, _, _, id = UnitAura(unit, i, "HELPFUL")
	while name do
		local buff = E.db.sao.spells[class][id]
		if buff and buff.enable then
			if not buff.active then
				local path = E.db.sao.useBuffIcon and icon or LSM:Fetch("sao", buff.texture)
				local position = buff.position
				SpellActivationOverlay_ShowOverlay(SAOF, id, path, position, 1, 255, 255, 255)
				buff.active = true
			end
			buff.showing = true
		end
		i = i + 1
		name, icon, _, _, _, _, _, _, _, id = UnitAura(unit, i, "HELPFUL")
	end

	for index, value in pairs(E.db.sao.spells[class]) do
		if not value.showing and value.active then
			SpellActivationOverlay_HideOverlays(SAOF, index)
			value.active = false
		end
		value.showing = false
	end
end