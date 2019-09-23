local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local Module = E:NewModule("AuraWatch", "AceTimer-3.0")
local MaxFrame, Index = 12, 1
local LSM = LibStub("LibSharedMedia-3.0")
local LibClassicDurations = LibStub("LibClassicDurations")
Module.Aura = {}

local CreateFrame = CreateFrame
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local pairs = pairs
local CooldownFrame_SetTimer = CooldownFrame_Set
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local GetSpellCooldown = GetSpellCooldown
local GetSpellInfo = GetSpellInfo
local GetItemInfo = GetItemInfo
local GetItemCooldown = GetItemCooldown
local twipe, tinsert= table.wipe, tinsert

function Module:LoadSettings()
	local Default = Module.Default

	if E.db.AuraWatch.loadDefault ~= true then
		for key, value in pairs(Default[E.myclass]) do
			if E.db.AuraWatch.DB[key] == nil then E.db.AuraWatch.DB[key] = value end
		end
		E.db.AuraWatch.loadDefault = true
		E.db.AuraWatch.ver = 2
		E.db.AuraWatch.myclass = E.myclass
	end
	twipe(Default)
end

local function UpdateCooldownSettings(cd)
	if cd and cd.CooldownSettings then
		cd.CooldownSettings.font = LSM:Fetch("font", Module.db.font)
		cd.CooldownSettings.fontSize = Module.db.fontSize
		cd.CooldownSettings.fontOutline = Module.db.fontOutline
		if cd.timer then
			E:Cooldown_OnSizeChanged(cd.timer, cd:GetSize(), 'override')
		end
	end
end

local UF = E:GetModule('UnitFrames');
-- BuildICON
local function BuildICON(IconSize, i)
	local Frame = CreateFrame("Frame", "AuraWatchIcon".. i, E.UIParent)
	local offset = UF.thinBorders and E.mult or E.Border
	Frame:SetTemplate('Default', nil, nil, UF.thinBorders, true)

	Frame:SetSize(IconSize, IconSize)
	
	
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 

	Frame.Icon:SetInside(Frame, offset, offset)
	Frame.Icon:SetTexCoord(unpack(E.TexCoords))
	Frame.Icon:SetDrawLayer('ARTWORK')
	
	Frame.Count = Frame:CreateFontString(nil, 'OVERLAY')
	Frame.Count:FontTemplate(LSM:Fetch("font", Module.db.font), Module.db.fontSize, Module.db.fontOutline)
	Frame.Count:SetPoint("BOTTOMRIGHT", offset, -offset)

	if E.db.AuraWatch.Spellname then
		Frame.Spellname = Frame:CreateFontString(nil, 'OVERLAY')
		Frame.Spellname:FontTemplate(LSM:Fetch("font", Module.db.font), Module.db.fontSize2, Module.db.fontOutline)
		Frame.Spellname:SetPoint("TOP", Frame, "BOTTOM", 0, -2)
		Frame.Spellname:SetTextColor(1,1,0)
	end

	Frame.Cooldown = CreateFrame("Cooldown", nil, Frame, 'CooldownFrameTemplate')
	Frame.Cooldown:SetReverse(true)
	Frame.Cooldown:SetInside(Frame, offset, offset)

	Frame.Cooldown.CooldownOverride = 'watch'

	E:RegisterCooldown(Frame.Cooldown)
	Frame:Hide()
	return Frame
end

-- BuildBAR
local function BuildBAR(BarWidth, IconSize, i)
	local Frame = CreateFrame("Frame", "AuraWatchBar".. i, E.UIParent)
	Frame:SetSize(BarWidth, IconSize)
	
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK")
	Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	Frame.Icon:SetSize(IconSize, IconSize)
	Frame.Icon:SetPoint("LEFT", -2, 0)
	Frame.Icon.bg = CreateFrame("Frame", nil, Frame)
	Frame.Icon.bg:SetTemplate()
	Frame.Icon.bg:SetFrameLevel(Frame:GetFrameLevel()-1)
	Frame.Icon.bg:Point("TOPLEFT", Frame.Icon, "TOPLEFT", -2, 2)
	Frame.Icon.bg:Point("BOTTOMRIGHT", Frame.Icon, "BOTTOMRIGHT", 2, -2)

	Frame.Statusbar = CreateFrame("StatusBar", nil, Frame)
	Frame.Statusbar:SetSize(Frame:GetWidth()-Frame:GetHeight()-5, IconSize)
	Frame.Statusbar:SetPoint("BOTTOMRIGHT") 
	Frame.Statusbar:SetStatusBarTexture(E["media"].normTex) 
	Frame.Statusbar:SetStatusBarColor(RAID_CLASS_COLORS[E.myclass].r, RAID_CLASS_COLORS[E.myclass].g, RAID_CLASS_COLORS[E.myclass].b, 0.9)
	Frame.Statusbar:SetMinMaxValues(0, 1) 
	Frame.Statusbar:SetValue(0) 	
	Frame.Statusbar:CreateBackdrop("Transparent")
	if E.db.general.transparent and E.db.general.transparentStyle == 1 then Frame.Statusbar.backdrop:SetAlpha(E.db.general.backdropfadecolor.a or 0.4) end

	Frame.Count = Frame:CreateFontString(nil, 'OVERLAY')
	Frame.Count:FontTemplate(LSM:Fetch("font", Module.db.font), Module.db.fontSize, Module.db.fontOutline)
	Frame.Count:SetShadowColor(0, 0, 0)
	Frame.Count:SetShadowOffset(E.mult, -E.mult)
	Frame.Count:SetPoint("BOTTOMRIGHT", Frame.Icon, "BOTTOMRIGHT", 3, -1) 

	Frame.Time = Frame.Statusbar:CreateFontString(nil, 'OVERLAY')
	Frame.Time:FontTemplate(LSM:Fetch("font", Module.db.font), Module.db.fontSize, Module.db.fontOutline)
	Frame.Time:SetShadowColor(0, 0, 0, 0)
	Frame.Time:SetShadowOffset(E.mult, -E.mult)
	Frame.Time:SetPoint("RIGHT", -2, 0) 

	Frame.Spellname = Frame.Statusbar:CreateFontString(nil, 'OVERLAY')
	Frame.Spellname:FontTemplate(LSM:Fetch("font", Module.db.font), Module.db.fontSize2, Module.db.fontOutline)
	Frame.Spellname:SetShadowOffset(E.mult, -E.mult)
	Frame.Spellname:SetShadowColor(0, 0, 0)
	Frame.Spellname:SetPoint("LEFT", 5, 0)
	
	Frame:Hide()
	return Frame
end

function Module:BuildAura()
	for key, value in pairs(E.db.AuraWatch.DB) do
		if value.Name and value.Name == '通用监视组' then
			E.db.AuraWatch.DB[key] = nil
		else
			local FrameTable = {}
			for i = 1, MaxFrame do
				local Frame = nil
				if value.Mode:lower() == "icon" then
					Frame = BuildICON(value.IconSize, i)
				elseif value.Mode:lower() == "bar" then
					Frame = BuildBAR(value.BarWidth, value.IconSize, i)
				end
				if i == 1 then
					Frame:SetPoint(unpack(value.Pos))
					if value.Name ~= L["New Group"] then E:CreateMover(Frame, value.Name, value.Name, nil, nil, nil, 'ALL,EUI', nil, 'Watch,AuraWatch', "private,AuraWatch,enable") end
				end
				tinsert(FrameTable, Frame)
			end
			tinsert(Module.Aura, FrameTable)
		end
	end
end

function Module:UpdatePos()
	for key, value in pairs(Module.Aura) do
		local Direction, Interval = E.db.AuraWatch.DB[key].Direction, E.db.AuraWatch.DB[key].Interval
		for i = 1, MaxFrame do
			if i ~= 1 then value[i]:ClearAllPoints() end
			if i == 1 then
				value[i]:SetPoint("CENTER", value[i].mover)
			elseif Direction:lower() == "right" then
				value[i]:SetPoint("LEFT", value[i-1], "RIGHT", Interval, 0)
			elseif Direction:lower() == "left" then
				value[i]:SetPoint("RIGHT", value[i-1], "LEFT", -Interval, 0)
			elseif Direction:lower() == "up" then
				value[i]:SetPoint("BOTTOM", value[i-1], "TOP", 0, Interval)
			elseif Direction:lower() == "down" then
				value[i]:SetPoint("TOP", value[i-1], "BOTTOM", 0, -Interval)
			end
		end
	end
end

local function CleanUp()
	for _, VALUE in pairs(Module.Aura) do
		for _, value in pairs(VALUE) do
			if value then
				value:Hide()
				value:SetScript("OnUpdate", nil)
			end
			if value.Icon then value.Icon:SetTexture(nil) end
			if value.Count then value.Count:SetText(nil) end
			if valueSpellname then value.Spellname:SetText(nil) end
			if value.Statusbar then
				value.Statusbar:SetMinMaxValues(0, 1) 
				value.Statusbar:SetValue(0)
			end
		end
	end
end

function Module:DeleteAllFrame()
	for _, VALUE in pairs(self.Aura) do
		for _, value in pairs(VALUE) do
			if value.Icon then value.Icon:SetTexture(nil); value.Icon = nil; end
			if value.Count then value.Count:SetText(nil); value.Count = nil; end
			if valueSpellname then value.Spellname:SetText(nil); value.Spellname = nil; end
			if value.Statusbar then
				value.Statusbar:SetMinMaxValues(0, 1) 
				value.Statusbar:SetValue(0)
				value.Statusbar = nil
			end
			if value then
				value:Hide()
				value:SetScript("OnUpdate", nil)
				value = nil
			end
		end
		twipe(VALUE)
	end
	twipe(self.Aura)
end

local function SetTime(self)
	if self.Timer < 60 then
		if self.Time then self.Time:SetFormattedText("%.1f", self.Timer) end
		self.Statusbar:SetValue(self.Timer)
	else
		if self.Time then self.Time:SetFormattedText("%d:%.2d", self.Timer/60, self.Timer%60) end
		self.Statusbar:SetValue(self.Timer)
	end
end

local function UpdateAuraFrame(KEY, value, name, icon, count, duration, expires, caster)
	if value.Caster and (value.Caster ~= caster and value.Caster ~= 'all') then return end
	if value.Stack and count and value.Stack > count then return end
	local Frame = Module.Aura[KEY][Index]
	if Frame then Frame:Show() else return end
	if Frame.Icon then Frame.Icon:SetTexture(icon) end
	if Frame.Count and count then Frame.Count:SetText(count > 1 and count or nil) end
	if Frame.Cooldown and expires then
		Frame.Cooldown:SetReverse(true)
		CooldownFrame_SetTimer(Frame.Cooldown, expires-duration, duration, 1)
	end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.Timer = 0
		Frame.Statusbar:SetMinMaxValues(0, duration)
		Frame:SetScript("OnUpdate", function(self, elapsed)
			if expires then
				self.Timer = expires-GetTime()
				if expires == 0 then self.Timer = 0 end
				SetTime(self)
			end
		end)
	end
	Index = Index + 1
end

local function UpdateCDFrame(KEY, name, icon, start, duration)
	local Frame = Module.Aura[KEY][Index]
	if Frame then Frame:Show() else return end
	if Frame.Icon then Frame.Icon:SetTexture(icon) end
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(false)
		CooldownFrame_SetTimer(Frame.Cooldown, start, duration, 1)
	end
	if Frame.Count then Frame.Count:SetText(nil) end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.Timer = 0
		Frame.Statusbar:SetMinMaxValues(0, duration)
		Frame:SetScript("OnUpdate", function(self, elapsed)
			self.Timer = start+duration-GetTime()
			SetTime(self)
		end)
	end
	Index = Index + 1
end

local function CheckSpellIsTrue(name, spellid, auraid)
	if E.private.AuraWatch.checkSpellid then
		if auraid == spellid then
			return true
		end
	else
		if auraid == spellid or name == GetSpellInfo(auraid) then
			return true
		end
	end
	return false
end


local function UpdateFrame()
	for KEY, VALUE in pairs(E.db.AuraWatch.DB) do
		Index = 1
		for _, value in pairs(VALUE.List) do
			if value.AuraID and (value.filter == "BUFF" or not value.filter) then
				for i = 1, 40 do
					local name, icon, count, _, duration, expires, caster, _, _, spellID = UnitBuff(value.UnitID, i)
					if name and CheckSpellIsTrue(name, spellID, value.AuraID) then
						if LibClassicDurations then
							local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit(value.UnitID, spellID, caster, name)

							if durationNew and durationNew > 0 then
								duration = durationNew
								expires = expirationTimeNew
							end
						end
						UpdateAuraFrame(KEY, value, name, icon, count, duration, expires, caster)
						break
					end
				end
			elseif value.AuraID and (value.filter == "DEBUFF" or not value.filter) then
				for i = 1, 40 do
					local name, icon, count, _, duration, expires, caster, _, _, spellID = UnitDebuff(value.UnitID, i)
					if name and CheckSpellIsTrue(name, spellID, value.AuraID) then
						if LibClassicDurations then
							local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit(value.UnitID, spellID, caster, name)

							if durationNew and durationNew > 0 then
								duration = durationNew
								expires = expirationTimeNew
							end
						end
						UpdateAuraFrame(KEY, value, name, icon, count, duration, expires, caster)
						break
					end
				end
			elseif (value.AuraID or value.SpellID) and value.filter == "CD" then
				value.SpellID = value.SpellID or value.AuraID
				local start, duration = GetSpellCooldown(value.SpellID)
				if IsPlayerSpell(value.SpellID) and start and duration > 1.5 then
					local name,_, icon = GetSpellInfo(value.SpellID)
					UpdateCDFrame(KEY, name, icon, start, duration)
				end
			elseif value.ItemID then
				local start, duration = GetItemCooldown(value.ItemID)
				if start and duration > 1.5 then
					local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(value.ItemID)
					UpdateCDFrame(KEY, name, icon, start, duration)
				end
			end
		end
	end
end

local function OnUpdate()
	CleanUp()
	UpdateFrame()
end

function Module:Initialize()
	self.db = E.db["AuraWatch"]

	if E.db.AuraWatch.myclass == '' then
		E.db.AuraWatch.myclass = E.myclass
	elseif E.db.AuraWatch.myclass ~= E.myclass then
		E.db.AuraWatch.loadDefault = false
	end		
	
	if E.db.AuraWatch.loadDefault ~= true then self:LoadSettings() end

	if E.private.AuraWatch.enable ~= true then return end

	self:BuildAura()
	self:UpdatePos()
	Module:ScheduleRepeatingTimer(OnUpdate, self.db.delay or 0.5)
end

E:RegisterModule(Module:GetName())