local E, L, DF = unpack(ElvUI)
if E.db["euiscript"].priestpet ~= true then return end
if E.myclass ~= "PRIEST" then return end

local CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS
local GetSpellInfo = GetSpellInfo
local spellname = GetSpellInfo(34433)
local spellname2 = GetSpellInfo(123040)
local sformat = string.format
local floor = math.floor
local timer = 0
local bars = {}
local addon = CreateFrame("Frame", "EuiPriestPet", E.UIParent)

local PRIESTAnchor = CreateFrame("Frame", "PRIESTAnchor", E.UIParent)
PRIESTAnchor:Point("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -68)
PRIESTAnchor:SetSize(E.db["euiscript"].priestpet_width, E.db["euiscript"].priestpet_height)

E:CreateMover(PRIESTAnchor, "PRIESTAnchorMover", spellname, nil, nil, nil, "ALL,EUI", nil, "euiscript")

local FormatTime = function(time)
	if time >= 60 then
		return sformat("%.2d:%.2d", floor(time / 60), time % 60)
	else
		return sformat("%.2d", time)
	end
end

local CreateFS = function(frame, fsize, fstyle)
	local fstring = frame:CreateFontString(nil, "OVERLAY")
	fstring:FontTemplate(nil, E.db.general.fontSize, 'OUTLINE')
	return fstring
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(FormatTime(self.endTime - curTime))
end

local OnMouseDown = function(self, button)
	if button == "RightButton" then
		StopTimer(self)
	end
end

local CreateBar = function()
	local bar = CreateFrame("Statusbar", nil, E.UIParent)
	bar:SetFrameStrata("LOW")
	bar:Size(E.db["euiscript"].priestpet_width - E.db["euiscript"].priestpet_height - 6, E.db["euiscript"].priestpet_height)
	bar:SetStatusBarTexture(E["media"].normTex)
	bar:SetMinMaxValues(0, 100)

	bar.backdrop = CreateFrame("Frame", nil, bar)
	bar.backdrop:Point("TOPLEFT", -2, 2)
	bar.backdrop:Point("BOTTOMRIGHT", 2, -2)
	bar.backdrop:SetTemplate()
	bar.backdrop:SetFrameStrata("BACKGROUND")
	if E.db.general.transparent and E.db.general.transparentStyle == 1 then bar.backdrop:SetAlpha(E.db.general.backdropfadecolor.a or 0.4) end

	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints(bar)
	bar.bg:SetTexture(E["media"].glossTex)

	bar.left = CreateFS(bar)
	bar.left:Point("LEFT", 2, 0)
	bar.left:SetJustifyH("LEFT")
	bar.left:Size(E.db["euiscript"].priestpet_width - E.db["euiscript"].priestpet_height, E.db["euiscript"].priestpet_height)

	bar.right = CreateFS(bar)
	bar.right:Point("RIGHT", 1, 0)
	bar.right:SetJustifyH("RIGHT")

	bar.icon = CreateFrame("Button", nil, bar)
	bar.icon:Size(E.db["euiscript"].priestpet_height)
	bar.icon:Point("BOTTOMRIGHT", bar, "BOTTOMLEFT", -6, 0)

	bar.icon.backdrop = CreateFrame("Frame", nil, bar.icon)
	bar.icon.backdrop:Point("TOPLEFT", -2, 2)
	bar.icon.backdrop:Point("BOTTOMRIGHT", 2, -2)
	bar.icon.backdrop:SetTemplate()
	bar.icon.backdrop:SetFrameStrata("BACKGROUND")

	return bar
end

local StartTimer = function(name, spellId)
	local bar = CreateBar()
	local spell = GetSpellInfo(spellId)
	local icon = GetSpellTexture(spellId)
	local dtime = 12 + (4.5 * E.db.euiscript.priestpet_lv)

	if spellId == 132604 then dtime = 15 + (1.5 * E.db.euiscript.priestpet_lv) end
	bar.endTime = GetTime() + dtime
	bar.startTime = GetTime()
	bar.left:SetText(name)
	bar.right:SetText(FormatTime(dtime))
	bar.icon:SetNormalTexture(icon)
	bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	bar.spell = spell
	bar:Show()
	local color = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
	if color then
		bar:SetStatusBarColor(color.r, color.g, color.b)
		bar.bg:SetVertexColor(color.r, color.g, color.b, 0.25)
	else
		bar:SetStatusBarColor(0.3, 0.7, 0.3)
		bar.bg:SetVertexColor(0.3, 0.7, 0.3, 0.25)
	end
	bar:SetScript("OnUpdate", BarUpdate)
	bar:EnableMouse(true)
	bar:SetScript("OnMouseDown", OnMouseDown)
	tinsert(bars, bar)
	bar:SetAllPoints(PRIESTAnchor);
end

addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
addon:SetScript("OnEvent", function(self, ...)
	local _, eventType, _, _, sourceName, sourceFlags, _, _, spellName, _, _, spellId = CombatLogGetCurrentEventInfo()
	if sourceName ~= E.myname then return; end
	
	if eventType == "SPELL_SUMMON" and (spellName == spellname or spellName == spellname2) then
		StartTimer(spellName, spellId); 
	end
end)