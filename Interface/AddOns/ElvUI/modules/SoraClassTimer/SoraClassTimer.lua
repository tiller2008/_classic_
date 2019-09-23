-- Engines
local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local Module = E:NewModule("SoraClassTimer", "AceEvent-3.0")
local PlayerAura, TargetAura, WhiteList, BlackList, playerFrame, targetFrame = {}, {}, nil, nil, nil, nil
local LSM = LibStub("LibSharedMedia-3.0")
local LibClassicDurations = LibStub("LibClassicDurations")

local _G = _G
local CreateFrame = CreateFrame
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local unpack = unpack
local CooldownFrame_SetTimer = CooldownFrame_Set
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local tonumber = tonumber
local UF = E:GetModule('UnitFrames');

function Module:BuildIcon(IconSize)
	local Aura = CreateFrame("Frame", nil, E.UIParent)
	Aura:SetSize(IconSize, IconSize)

	Aura.Icon = Aura:CreateTexture(nil, "ARTWORK") 
	Aura.Icon:SetInside(Aura, offset, offset)
	Aura.Icon:SetTexCoord(unpack(E.TexCoords))

	Aura.Icon:SetDrawLayer('ARTWORK')
		
	local offset = UF.thinBorders and E.mult or E.Border
	Aura:SetTemplate('Default', nil, nil, UF.thinBorders, true)
	
	Aura.Count = Aura:CreateFontString(nil, 'OVERLAY')
	Aura.Count:FontTemplate(LSM:Fetch("font", Module.db.font), Module.db.fontSize, Module.db.fontOutline)
	Aura.Count:SetPoint("BOTTOMRIGHT", offset, -offset)
	
	Aura.Cooldown = CreateFrame("Cooldown", nil, Aura) 
	Aura.Cooldown:SetInside(Aura, offset, offset)
	Aura.Cooldown:SetReverse(true)

	Aura.Cooldown.CooldownOverride = 'watch'

	E:RegisterCooldown(Aura.Cooldown)
	
	return Aura
end

function Module:BuildBar(IconSize, BarWidth)
	local Aura = CreateFrame("Frame", nil, E.UIParent)
	Aura:SetSize(BarWidth, IconSize)
	
	Aura.Icon = Aura:CreateTexture(nil, "ARTWORK")
	Aura.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	Aura.Icon:SetSize(IconSize, IconSize)
	Aura.Icon:SetPoint("LEFT", -2, 0)
	Aura.Icon.bg = CreateFrame("Frame", nil, Aura)
	Aura.Icon.bg:SetTemplate()
	Aura.Icon.bg:SetFrameLevel(Aura:GetFrameLevel()-1)
	Aura.Icon.bg:Point("TOPLEFT", Aura.Icon, "TOPLEFT", -2, 2)
	Aura.Icon.bg:Point("BOTTOMRIGHT", Aura.Icon, "BOTTOMRIGHT", 2, -2)
	
	Aura.Statusbar = CreateFrame("StatusBar", nil, Aura)
	Aura.Statusbar:SetSize(Aura:GetWidth()-Aura:GetHeight()-5, IconSize)
	Aura.Statusbar:SetPoint("BOTTOMRIGHT") 
	Aura.Statusbar:SetStatusBarTexture(E["media"].normTex) 
	Aura.Statusbar:SetStatusBarColor(RAID_CLASS_COLORS[E.myclass].r, RAID_CLASS_COLORS[E.myclass].g, RAID_CLASS_COLORS[E.myclass].b, 0.9)
	Aura.Statusbar.bg = CreateFrame("Frame", nil, Aura.Statusbar)
	Aura.Statusbar.bg:SetTemplate()
	Aura.Statusbar.bg:Point("TOPLEFT", -2, 2)
	Aura.Statusbar.bg:Point("BOTTOMRIGHT", 2, -2)
	Aura.Statusbar.bg:SetFrameLevel(Aura.Statusbar:GetFrameLevel()-1)
	
	Aura.Count = Aura:CreateFontString(nil, 'OVERLAY')
	Aura.Count:FontTemplate(LSM:Fetch("font", Module.db.font), Module.db.fontSize - 1, Module.db.fontOutline)
	Aura.Count:SetShadowColor(0,0,0)
	Aura.Count:SetShadowOffset(E.mult, -E.mult)
	Aura.Count:SetPoint("BOTTOMRIGHT", Aura.Icon, "BOTTOMRIGHT", -2, 1) 

	Aura.Time = Aura.Statusbar:CreateFontString(nil, 'OVERLAY')
	Aura.Time:FontTemplate(LSM:Fetch("font", Module.db.font), Module.db.fontSize, Module.db.fontOutline)
	Aura.Time:SetShadowColor(0,0,0)
	Aura.Time:SetShadowOffset(E.mult, -E.mult)
	Aura.Time:SetPoint("RIGHT", -2, 0) 

	Aura.Spellname = Aura.Statusbar:CreateFontString(nil, 'OVERLAY')
	Aura.Spellname:FontTemplate(LSM:Fetch("font", Module.db.font), Module.db.fontSize, Module.db.fontOutline)
	Aura.Spellname:SetShadowOffset(E.mult, -E.mult)
	Aura.Spellname:SetShadowColor(0,0,0)
	Aura.Spellname:SetPoint("LEFT", 5, 0)
		
	return Aura
end

function Module:ClearAura(unit)
	if unit == "player" then
		for key, value in pairs(PlayerAura) do
			value:ClearAllPoints()
			value:SetScript("OnUpdate", nil)
			value:Hide()
		end
		wipe(PlayerAura)
	end
	if unit == "target" then
		for key, value in pairs(TargetAura) do
			value:ClearAllPoints()
			value:SetScript("OnUpdate", nil)
			value:Hide()
		end
		wipe(TargetAura)
	end
end

function Module:UpdateAura(Aura, Parent, Mode, IconSize, BarWidth, Key, name, icon, count, duration, expires, isDebuff)
	if Mode == "Icon" then
		if not Aura[Key] then
			local w = floor(Parent:GetWidth()/(IconSize+5));
			if w == 0 then w = 1 end
			Aura[Key] = Module:BuildIcon(IconSize)
			if Key == 1 then
				Aura[Key]:SetPoint("CENTER", (Parent == ElvUF_Player) and playerSClassTimerAnchor or targetSClassTimerAnchor, "CENTER", 0, 0)
			elseif Key%w == 1 then
				Aura[Key]:SetPoint("BOTTOM", Aura[Key-w], "TOP", 0, 5)
			else
				Aura[Key]:SetPoint("LEFT", Aura[Key-1], "RIGHT", 5, 0)
			end
		end
		
		local Aura = Aura[Key]
		Aura.Icon:SetTexture(icon)
		Aura.Count:SetText(count > 1 and count or "")		
		if isDebuff then Aura:SetBackdropBorderColor(1,0,0) else Aura:SetBackdropBorderColor(unpack(E["media"].bordercolor)) end
		
		CooldownFrame_SetTimer(Aura.Cooldown, expires-duration, duration, 1)
		
		Aura:Show()
	end
	if Mode == "Bar" then		
		if not Aura[Key] then
			Aura[Key] = Module:BuildBar(IconSize, BarWidth)
			if Key == 1 then
				Aura[Key]:SetPoint("LEFT", (Parent == ElvUF_Player) and playerSClassTimerAnchor or targetSClassTimerAnchor, "LEFT", 0, 0)
			else
				Aura[Key]:SetPoint("BOTTOM", Aura[Key-1], "TOP", 0, 5)
			end
		end
		
		local Aura = Aura[Key]
		Aura.Icon:SetTexture(icon)
		Aura.Count:SetText(count > 1 and count or "")	
		if IsDebuff then
			Aura.Icon.bg:SetBackdropBorderColor(1,0,0)
			Aura.Statusbar.bg:SetBackdropBorderColor(1,0,0)
		else
			Aura.Icon.bg:SetBackdropBorderColor(unpack(E["media"].bordercolor))
			Aura.Statusbar.bg:SetBackdropBorderColor(unpack(E["media"].bordercolor))
		end
		
		Aura.Spellname:SetText(name)
		Aura.Statusbar:SetMinMaxValues(0, duration)
		Aura.Timer = 0
		Aura:SetScript("OnUpdate", function(self, elapsed)
			self.Timer = expires-GetTime()
			if self.Timer >= 60 then
				self.Time:SetFormattedText("%d:%.2d", self.Timer/60, self.Timer%60)
				self.Statusbar:SetValue(self.Timer)
			elseif self.Timer < 60 then
				self.Time:SetFormattedText("%.1f", self.Timer)
				self.Statusbar:SetValue(self.Timer)
			end
		end)
		
		Aura:Show()
	end
end

function Module:OnUpdate(unit)
	if unit == "player" and C["PlayerMode"] ~= "None" then
		local Key = 0
		
		for index = 1, 40 do
			local name, icon, count, dispelType, duration, expires, caster, _, _, spellID = UnitBuff(unit, index)
			if not name then break end
			if ((duration <= E.db.SoraClassTimer.timelimit and duration ~= 0) and caster == "player" and not BlackList[name]) or WhiteList[name] then
				Key = Key + 1
				Module:UpdateAura(PlayerAura, playerFrame, C["PlayerMode"], C["PlayerIconSize"], playerFrame:GetWidth()-8, Key, name, icon, count, duration, expires, false)
			end
		end
		
		for index = 1, 40 do
			local name, icon, count, dispelType, duration, expires, caster = UnitDebuff(unit, index)
			if not name then break end
			if WhiteList[name] then
				Key = Key + 1
				Module:UpdateAura(PlayerAura, playerFrame, C["PlayerMode"], C["PlayerIconSize"], playerFrame:GetWidth()-8, Key, name, icon, count, duration, expires, true)
			end
		end
		
		for index = Key + 1, #PlayerAura do
			PlayerAura[index]:Hide()
		end
	end
	if unit == "target" and C["TargetMode"] ~= "None" then
		local isFriends = UnitIsFriend("player", unit) and "HELPFUL" or "HARMFUL"   
		local Key = 0
		for index = 1, 40 do
			local name, icon, count, dispelType, duration, expires, caster = UnitAura(unit, index, isFriends)
			if not name then break end
			if LibClassicDurations then
				local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit(unit, spellID, caster, name)

				if durationNew and durationNew > 0 then
					duration = durationNew
					expires = expirationTimeNew
				end
			end
			if ((duration <= E.db.SoraClassTimer.timelimit and duration ~= 0) and caster == "player" and not BlackList[name]) or (WhiteList[name] and caster == "player") then
				Key = Key + 1
				Module:UpdateAura(TargetAura, targetFrame, C["TargetMode"], C["TargetIconSize"], targetFrame:GetWidth()-8, Key, name, icon, count, duration, expires, isFriends == "HARMFUL")
			end
		end
		
		for index = Key + 1, #TargetAura do
			TargetAura[index]:Hide()
			TargetAura[index]:SetScript("OnUpdate", nil)
		end
	end
end

function Module:OnEvent(event, unit, ...)
	if event == "UNIT_AURA" then
		Module:OnUpdate(unit)
	end
	if event == "PLAYER_TARGET_CHANGED" then
		Module:OnUpdate("target")
	end
end

-- BuildGUI
Module.BlackListTable, Module.WhiteListTable = {}, {}

function Module:UpdateBlackListTable()
	wipe(Module.BlackListTable)
	Module.BlackListTable["BlackListNew"] = {
		type = "input", order = 1,
		name = L["Add New Aura ID"], width = "full",
		get = function() return L["None"] end,
		set = function(_, value)
			local Name = GetSpellInfo(tonumber(value))
			E.db.SoraClassTimer["BlackList"][Name] = true
			self:UpdateBlackListTable()
		end,
	}
	Module.BlackListTable["BlackListDel"] = {
		type = "input", order = 1,
		name = L["Delete Aura ID"], width = "full",
		get = function() return L["None"] end,
		set = function(_, value)
			local Name = GetSpellInfo(tonumber(value))
			E.db.SoraClassTimer["BlackList"][Name] = nil
			self:UpdateBlackListTable()
		end,
	}
	
	local Order = 2
	for key, value in pairs(E.db.SoraClassTimer["BlackList"]) do
		Order = Order + 1
		Module.BlackListTable[key] = {
			type = "toggle", order = Order,
			name = key, desc = L["Enable/Disable"],
			get = function() return value end,
			set = function(_, val)
				E.db.SoraClassTimer["BlackList"][key] = val
				self:UpdateBlackListTable()
			end,
		}
	end
end

function Module:UpdateWhiteListTable()
	wipe(Module.WhiteListTable)
	Module.WhiteListTable["WhiteListNew"] = {
		type = "input", order = 1,
		name = L["Add New Aura ID"], width = "full",
		get = function() return L["None"] end,
		set = function(_, value)
			local Name = GetSpellInfo(tonumber(value))
			E.db.SoraClassTimer["WhiteList"][Name] = true
			self:UpdateWhiteListTable()
		end,
	}
	Module.WhiteListTable["WhiteListDel"] = {
		type = "input", order = 1,
		name = L["Delete Aura ID"], width = "full",
		get = function() return L["None"] end,
		set = function(_, value)
			local Name = GetSpellInfo(tonumber(value))
			E.db.SoraClassTimer["WhiteList"][Name] = nil
			self:UpdateWhiteListTable()
		end,
	}	
	local Order = 2
	for key, value in pairs(E.db.SoraClassTimer["WhiteList"]) do
		Order = Order + 1
		Module.WhiteListTable[key] = {
			type = "toggle", order = Order,
			name = key, desc = L["Enable/Disable"],
			get = function() return value end,
			set = function(_, val)
				E.db.SoraClassTimer["WhiteList"][key] = val
				self:UpdateWhiteListTable()
			end,
		}
	end
end

function Module:Initialize()
	if E.private.SoraClassTimer.enable ~= true then return end

	self.db = E.db["SoraClassTimer"]
	
	C = E.db.SoraClassTimer	
	self:UpdateBlackListTable()
	self:UpdateWhiteListTable()
	WhiteList = C["WhiteList"]
	BlackList = C["BlackList"]
	playerFrame = _G["ElvUF_Player"]
	targetFrame = _G["ElvUF_Target"]
	Module:RegisterEvent("PLAYER_TARGET_CHANGED", "OnEvent")
	Module:RegisterEvent("UNIT_AURA", "OnEvent")

	local playerAnchor = CreateFrame("Frame", "playerSClassTimerAnchor", E.UIParent)
	playerAnchor:Size(C["PlayerIconSize"])
	playerAnchor:Point("BOTTOMLEFT", ElvUF_Player, "TOPLEFT", 0, 12)
	E:CreateMover(playerAnchor, "playerAnchorMover", L["player"]..L["SoraClassTimer"], nil, nil, nil, 'ALL,EUI', nil, 'Watch,SoraClassTimer', "private,SoraClassTimer,enable")

	
	local targetAnchor = CreateFrame("Frame", "targetSClassTimerAnchor", E.UIParent)
	targetAnchor:Size(C["TargetIconSize"])
	targetAnchor:Point("BOTTOMLEFT", ElvUF_Target, "TOPLEFT", 0, 12)

	E:CreateMover(targetAnchor, "targetAnchorMover", L["target"]..L["SoraClassTimer"], nil, nil, nil, 'ALL,EUI', nil, 'Watch,SoraClassTimer', "private,SoraClassTimer,enable")
	
end

E:RegisterModule(Module:GetName())