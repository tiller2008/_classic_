local E, L, DF = unpack(ElvUI)
local RD = E:NewModule('RAIDCD', 'AceEvent-3.0')

----------------------------------------------------------------------------------------
--	Raid cooldowns
--  Modify by eui.cc at 2012.8.20
----------------------------------------------------------------------------------------
local show = {
	raid = true,
	party = true,
	arena = true,
}

local raid_spells
local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local sformat = string.format
local floor = math.floor
local GetTime = GetTime
local tremove, select, tostring, wipe = tremove, select, tostring, wipe
local SendChatMessage = SendChatMessage
local CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS
local UnitClass = UnitClass
local IsInInstance = IsInInstance
local GetSpellInfo = GetSpellInfo

local timer = 0
local bars = {}

local FormatTime = function(time)
	if time >= 60 then
		return sformat("%.2d:%.2d", floor(time / 60), time % 60)
	else
		return sformat("%.2d", time)
	end
end

local CreateFS = function(frame, fsize, fstyle)
	local fstring = frame:CreateFontString(nil, "OVERLAY")
	if E.db.euiscript.raidcd_style == 'bar' then
		fstring:FontTemplate(nil, E.db.general.fontSize, 'OUTLINE')
	else
		fstring:FontTemplate(nil, E.db.euiscript.raidcd_iconfontsize, 'OUTLINE')
	end
	return fstring
end

function RD:UpdatePositions()
	if E.db.euiscript.raidcd_style == 'bar' then
		for i = 1, #bars do
			bars[i]:ClearAllPoints()
			if i == 1 then
				bars[i]:Point("TOPLEFT", RaidCDAnchor, "TOPLEFT", 26, 0)
			else
				if self.db.raidcd_direction == "up" then
					bars[i]:Point("BOTTOMLEFT", bars[i-1], "TOPLEFT", 0, 5)
				else
					bars[i]:Point("TOPLEFT", bars[i-1], "BOTTOMLEFT", 0, -5)
				end
			end
			bars[i].id = i
		end
	else
		local button, lastButton, lastColumnButton, buttonsPerRow;
		for i = 1, #bars do
			buttonsPerRow = E.db.euiscript.raidcd_perrow
			lastButton = bars[i-1];
			lastColumnButton = bars[i-buttonsPerRow];
			
			if E.db.euiscript.raidcd_maxbars < E.db.euiscript.raidcd_perrow then
				E.db.euiscript.raidcd_perrow = E.db.euiscript.raidcd_maxbars;
			end
			bars[i]:ClearAllPoints()
			
			local pointx, pointy, space = "TOPLEFT", "TOPRIGHT", E.db.euiscript.raidcd_iconspace
			if E.db.euiscript.raidcd_icondirection == 'left' then
				pointx = "TOPRIGHT"
				pointy = "TOPLEFT"
				space = -(space)
			end
			if i == 1 then
				bars[i]:Point(pointx, RaidCDAnchor, pointx, 0, 0)
			elseif (i-1) % buttonsPerRow == 0 then
				bars[i]:Point("TOP", lastColumnButton.left, "BOTTOM", 0, -E.db.euiscript.raidcd_iconspace)
			else
				bars[i]:Point(pointx, lastButton, pointy, space, 0)
			end
			bars[i].id = i
		end
	end
end

function RD:StopTimer(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	self:UpdatePositions()
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		RD:StopTimer(self)
		return
	end
	if E.db.euiscript.raidcd_style == 'bar' then
		self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	end
	self.right:SetText(FormatTime(self.endTime - curTime))
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddDoubleLine(self.name.. '-'.. self.spell, self.right:GetText())
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if button == "LeftButton" then
		SendChatMessage(sformat("EUI:".." %s: %s", self.name..' - '..self.spell, self.right:GetText()), E:CheckChat())
	elseif button == "RightButton" then
		RD:StopTimer(self)
	end
end

function RD:CreateBar(style)
	local bar
	if style == 'bar' then
		bar = CreateFrame("Statusbar", nil, E.UIParent)
		bar:SetFrameStrata("LOW")
		bar:Size(self.db.raidcd_width - self.db.raidcd_height - 6, self.db.raidcd_height)
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
		bar.left:Size(self.db.raidcd_width - self.db.raidcd_height, self.db.raidcd_height)

		bar.right = CreateFS(bar)
		bar.right:Point("RIGHT", 1, 0)
		bar.right:SetJustifyH("RIGHT")

		bar.icon = CreateFrame("Button", nil, bar)
		bar.icon:Size(self.db.raidcd_height)
		bar.icon:Point("BOTTOMRIGHT", bar, "BOTTOMLEFT", -6, 0)

		bar.icon.backdrop = CreateFrame("Frame", nil, bar.icon)
		bar.icon.backdrop:Point("TOPLEFT", -2, 2)
		bar.icon.backdrop:Point("BOTTOMRIGHT", 2, -2)
		bar.icon.backdrop:SetTemplate()
		bar.icon.backdrop:SetFrameStrata("BACKGROUND")
	else
		bar = CreateFrame("Button", nil, E.UIParent)
		bar:Size(self.db.raidcd_iconsize)

		bar.bg = CreateFrame("Frame", nil, bar)
		bar.bg:Point("TOPLEFT", -2, 2)

		bar.bg:Point("BOTTOMRIGHT", 2, -2)
		bar.bg:SetTemplate()
		bar.bg:SetFrameStrata("BACKGROUND")

		bar.left = CreateFS(bar)
		bar.left:Point("TOP", bar, "BOTTOM", 0, -4)
		bar.left:SetJustifyH("CENTER")
	--	bar.left:SetSize(self.db.raidcd_iconsize, 12)
		
		bar.right = CreateFS(bar)
		bar.right:Point("CENTER", 1, 0)
		bar.right:SetJustifyH("CENTER")
	end
	
	return bar
end

function RD:StartTimer(name, spellId)
	for i = 1, #bars do
		if bars[i].spell == GetSpellInfo(spellId) and bars[i].name == name then
			return
		end
	end
	if #bars > E.db.euiscript.raidcd_maxbars then return; end
	local bar = self:CreateBar(E.db.euiscript.raidcd_style)
	local spell,_, icon = GetSpellInfo(spellId)
	local class = select(2, UnitClass(name))

	if E.db.euiscript.raidcd_style == 'bar' then
		bar.endTime = GetTime() + raid_spells[tostring(spellId)].cd
		bar.startTime = GetTime()

		bar.left:SetText(E:ShortenString(name,2,true).." - "..E:ShortenString(spell,4,true))
		bar.right:SetText(FormatTime(raid_spells[tostring(spellId)].cd))
		bar.icon:SetNormalTexture(icon)
		bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		bar.spell = spell
		bar.name = name

		local color = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class])
		if color then
			bar:SetStatusBarColor(color.r, color.g, color.b)
			bar.bg:SetVertexColor(color.r, color.g, color.b, 0.25)
		else
			bar:SetStatusBarColor(0.3, 0.7, 0.3)
			bar.bg:SetVertexColor(0.3, 0.7, 0.3, 0.25)
		end
	else
		bar.endTime = GetTime() + raid_spells[tostring(spellId)].cd
		bar.startTime = GetTime()
		bar.left:SetText(E:ShortenString(name,4))
		bar.right:SetText(FormatTime(raid_spells[tostring(spellId)].cd))
		bar:SetNormalTexture(icon)
		bar:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		bar.spell = spell
		bar.name = name

		local color = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class])
		if color then
			bar.bg:SetBackdropBorderColor(color.r, color.g, color.b, 1)
			bar.left:SetTextColor(color.r, color.g, color.b)
		else
			bar.bg:SetStatusBarColor(0.3, 0.7, 0.3)
		end		
	end
	
	bar:SetScript("OnUpdate", BarUpdate)
	bar:EnableMouse(true)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)		
	bar:Show()	
	tinsert(bars, bar)
	self:UpdatePositions()
end

function RD:COMBAT_LOG_EVENT_UNFILTERED()
	local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags, _, _, _, _, _, spellId, _, _, arg15, arg16 = CombatLogGetCurrentEventInfo()
		
	if band(sourceFlags, filter) == 0 then return end

	if raid_spells[tostring(spellId)] and raid_spells[tostring(spellId)].enable and show[select(2, IsInInstance())] then
		if sourceName then
			sourceName = sourceName:gsub("-.+", "")
		else
			return
		end
		if raid_spells[tostring(spellId)].enable and raid_spells[tostring(spellId)].cc and not E.db.euiscript.raidcccd then
			return
		end
		local _, sclass = UnitClass(sourceName)

		if eventType == "SPELL_RESURRECT" and not spellId == 61999 then
			if spellId == 95750 then spellId = 6203 end
			self:StartTimer(sourceName, spellId)
		elseif eventType == "SPELL_AURA_APPLIED" then
			if spellId == 20707 and sclass == 'WARLOCK' then
				self:StartTimer(sourceName, spellId)
			end
			if spellId == 87023 and sclass == 'MAGE' then
				self:StartTimer(sourceName, spellId)
			end
			if spellId == 105763 and sclass == 'SHAMAN' then
				self:StartTimer(sourceName, 16190)
			end
			if spellId == 187616 or spellId == 187617 or spellId == 187618 or spellId == 187619 or spellId == 187620 then
				self:StartTimer(sourceName, spellId)
			end
		elseif eventType == "SPELL_CAST_SUCCESS" then
			self:StartTimer(sourceName, spellId)
		end
		if eventType == "SPELL_RESURRECT" and spellId == 20484 then self:StartTimer(sourceName, spellId) end
	end
end

function RD:ZONE_CHANGED_NEW_AREA()
	if select(2, IsInInstance()) == "arena" then
		for k, v in pairs(bars) do
			self:StopTimer(v)
		end
	end
end

function RD:ToggleRaidCD()
	raid_spells = E.db.euiscript.raid_spells
	
	if E.db.euiscript.raidcd then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	else
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	end
	self:UpdateSetting()
end

function RD:UpdateSetting()
	for i = 1, #bars do
		if bars[i] then
			bars[i]:SetScript("OnUpdate", nil)
			bars[i]:Hide()
		end
	end
	wipe(bars)
	
	RaidCDAnchor:SetSize(self.db.raidcd_width, self.db.raidcd_height)
end	

function RD:CreateAnchor()
	if RaidCDAnchor then return; end
	
	local RaidCDAnchor = CreateFrame("Frame", "RaidCDAnchor", E.UIParent)
	RaidCDAnchor:Point("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -28)
	RaidCDAnchor:SetSize(self.db.raidcd_width, self.db.raidcd_height)


	E:CreateMover(RaidCDAnchor, "RaidCDAnchorMover", L["raidcd"], nil, nil, nil, "ALL,EUI", nil, "euiscript,euiscript_raidcd", "db,euiscript,raidcd")
end

function RD:Initialize()
	self.db = E.db["euiscript"]
	
	self:CreateAnchor()
	self:ToggleRaidCD()
end	

E:RegisterModule(RD:GetName())