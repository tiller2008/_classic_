local E, L, V, P, G = unpack(select(2, ...)); --Engine
local UF = E:GetModule('UnitFrames');

local IsInInstance = IsInInstance
local CooldownFrame_Set = CooldownFrame_Set
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local GetSpellInfo = GetSpellInfo
local UnitGUID = UnitGUID
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown

----------------------------------------------------------------------------------------
--	Based on Tukui_DrTracker(by Ildyria)
----------------------------------------------------------------------------------------
local frameposition = {"TOPLEFT", "TOPRIGHT", 2, 2, "LEFT", "RIGHT", 3, 0}

local framelist = {
	--[FRAME NAME] = {UNITID, SIZE, ANCHOR, ANCHORFRAME, X, Y, "ANCHORNEXT", "ANCHORPREVIOUS", nextx, nexty},
	--["oUF_Player"] = {"player", 31, "TOPRIGHT", "TOPLEFT", -5, 2, "RIGHT", "LEFT", -3, 0},
	["ElvUF_Arena1"] = {"arena1", 46, unpack(frameposition)},
	["ElvUF_Arena2"] = {"arena2", 46, unpack(frameposition)},
	["ElvUF_Arena3"] = {"arena3", 46, unpack(frameposition)},
	["ElvUF_Arena4"] = {"arena4", 46, unpack(frameposition)},
	["ElvUF_Arena5"] = {"arena5", 46, unpack(frameposition)},
}

function UpdateDRTracker(self)
	local time = self.start + 18 - GetTime()

	if time < 0 then
		local frame = self:GetParent()
		frame.actives[self.cat] = nil
		self:SetScript("OnUpdate", nil)
		DisplayDrActives(frame)
	end
end

function DisplayDrActives(self, test)
	local _, instanceType = IsInInstance()
	if instanceType ~= "arena" and not test then return end
	
	if not self.actives then return end
	if not self.auras then self.auras = {} end
	local index
	local previous = nil
	index = 1

	for _, _ in pairs(self.actives) do
		local aura = self.auras[index]
		if not aura then
			aura = CreateFrame("Frame", "EuiDrFrame"..self.target..index, self)
			aura:SetTemplate()
			aura:SetSize(self.size, self.size)
			if index == 1 then
				if E.db.unitframe.units.arena.pvpTrinket.enable then
					aura:SetPoint(self.anchor, self:GetParent().Trinket, self.anchorframe, self.x, self.y)
				else
					aura:SetPoint(self.anchor, self:GetParent().Health, self.anchorframe, self.x, self.y)
				end
			elseif index == 2 then
				aura:SetPoint("TOP", previous, "BOTTOM", 0, -2)
			else
				aura:SetPoint(self.nextanchor, self.auras[1], self.nextanchorframe, self.nextx, self.nexty)
			end

			aura.icon = aura:CreateTexture("$parentIcon", "ARTWORK")
			aura.icon:SetPoint("TOPLEFT", 2, -2)
			aura.icon:SetPoint("BOTTOMRIGHT", -2, 2)
			aura.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

			aura.cooldown = CreateFrame("Cooldown", "$parentCD", aura, "CooldownFrameTemplate")
			aura.cooldown:SetAllPoints(aura.icon)
			aura.cooldown:SetReverse(true)
			E:RegisterCooldown(aura.cooldown)

			aura.count = aura:CreateFontString("$parentCount", "OVERLAY")
			aura.count:FontTemplate(UF.LSM:Fetch("font", E.db.unitframe.font), E.db.unitframe.fontSize*2, E.db.unitframe.fontOutline)
			aura.count:SetPoint("BOTTOMRIGHT", -2, 2)
			aura.count:SetJustifyH("CENTER")
			aura.cat = "cat"
			aura.start = 0
			

			self.auras[index] = aura
		end

		previous = aura
		index = index + 1
	end

	index = 1
	for cat, value in pairs(self.actives) do
		aura = self.auras[index]
		aura.icon:SetTexture(value.icon)
		aura.count:SetText(value.dr)
		aura.count:Hide()
		if value.dr == 1 then
			aura:SetBackdropBorderColor(0, 1, 0, 1)
		elseif value.dr == 2 then
			aura:SetBackdropBorderColor(1, 0.5, 0, 1)
		else
			aura:SetBackdropBorderColor(1, 0, 0, 1)
		end
		CooldownFrame_Set(aura.cooldown, value.start, 18, 1)
		aura.start = value.start
		aura.cat = cat
		aura:SetScript("OnUpdate", UpdateDRTracker)
		aura.cooldown:Show()

		aura:Show()
		index = index + 1
	end

	for i = index, #self.auras, 1 do
		local aura = self.auras[i]
		aura:SetScript("OnUpdate", nil)
		aura:Hide()
	end
end

local spell = G.DiminishingSpells
local icon = G.DiminishingIcons
local eventRegistered = {
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_AURA_REFRESH"] = true,
	["SPELL_AURA_REMOVED"] = true
}

local function CombatLogCheck(self)
	local _, instanceType = IsInInstance()
	if instanceType ~= "arena" then return end
	local _, eventType, _, _, _, _, _, destGUID, _, _, _, spellID, _, _, auraType = CombatLogGetCurrentEventInfo()
	if not eventRegistered[eventType] then return end
	if destGUID ~= UnitGUID(self.target) then return end

	local needupdate = false
	if eventType == "SPELL_AURA_APPLIED" then
		if auraType == "DEBUFF" and spell[spellID] then
			if not self.actives then self.actives = {} end
			for _, cat in pairs(spell[spellID]) do
				if self.actives[cat] then
					if self.actives[cat].start + 18 < GetTime() then
						self.actives[cat].start = GetTime()
						self.actives[cat].dr = 1
						self.actives[cat].icon = icon[cat]
					else
						self.actives[cat].start = GetTime()
						self.actives[cat].dr = 2 * self.actives[cat].dr
						self.actives[cat].icon = icon[cat]
					end
				else
					self.actives[cat] = {}
					self.actives[cat].start = GetTime()
					self.actives[cat].dr = 1
					self.actives[cat].icon = icon[cat]
				end
			end
			needupdate = true
		end
	elseif eventType == "SPELL_AURA_REFRESH" then
		if auraType == "DEBUFF" and spell[spellID] then
			if not self.actives then self.actives = {} end
			for _, cat in pairs(spell[spellID]) do
				if not self.actives[cat] then
					self.actives[cat] = {}
					self.actives[cat].dr = 1
				end
				self.actives[cat].start = GetTime()
				self.actives[cat].dr = 2 * self.actives[cat].dr
				self.actives[cat].icon = icon[cat]
			end
			needupdate = true
		end
	elseif eventType == "SPELL_AURA_REMOVED" then
		if auraType == "DEBUFF" and spell[spellID] then
			if not self.actives then self.actives = {} end
			for _, cat in pairs(spell[spellID]) do
				if self.actives[cat] then
					if self.actives[cat].start + 18 < GetTime() then
						self.actives[cat].start = GetTime()
						self.actives[cat].dr = 1
						self.actives[cat].icon = icon[cat]
					else
						self.actives[cat].start = GetTime()
						self.actives[cat].dr = self.actives[cat].dr
						self.actives[cat].icon = icon[cat]
					end
				else
					self.actives[cat] = {}
					self.actives[cat].start = GetTime()
					self.actives[cat].dr = 1
					self.actives[cat].icon = icon[cat]
				end
			end
			needupdate = true
		end
	end

	if needupdate then DisplayDrActives(self) end
end

function UF:CreateDiminishingCD()
	for frame, target in pairs(framelist) do
		self = _G[frame]
		if self and not self.DrTracker then
			local DrTracker = CreateFrame("Frame", nil, self)
			DrTracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			DrTracker:SetScript("OnEvent", CombatLogCheck)
			DrTracker.target = target[1]
			if E.db.unitframe.units.arena.pvpTrinket.enable then
				DrTracker.size = E.db.unitframe.units.arena.pvpTrinket.size*0.5 or target[2]
			else
				DrTracker.size = E.db.unitframe.units.arena.height*0.67 or target[2]
			end
			DrTracker.anchor = target[3]
			DrTracker.anchorframe = target[4]
			DrTracker.x = target[5]
			DrTracker.y = target[6]
			DrTracker.nextanchor = target[7]
			DrTracker.nextanchorframe = target[8]
			DrTracker.nextx = target[9]
			DrTracker.nexty = target[10]
			self.DrTracker = DrTracker
		end
	end

	for spell in pairs(G.DiminishingSpells) do
		local name = GetSpellInfo(spell)
		if not name then
			E:Print("|cffff0000WARNING: spell ID ["..tostring(spell).."] no longer exists! Report this to Shestak.|r")
		end
	end
end

local function tdr()
	if InCombatLockdown() then print("|cffffff00"..ERR_NOT_IN_COMBAT.."|r") return end

	local testlist = {"stun", "root", "silence"}

	for frame, target in pairs(framelist) do
		self = _G[frame].DrTracker
		if not self.actives then self.actives = {} end
		local dr = 1
		for _, cat in pairs(testlist) do
			if not self.actives[cat] then self.actives[cat] = {} end
			self.actives[cat].dr = dr
			self.actives[cat].start = GetTime()
			self.actives[cat].icon = icon[cat]
			dr = dr * 2
		end
		DisplayDrActives(self, true)
	end
end

SlashCmdList.DIMINISHINGCD = tdr
SLASH_DIMINISHINGCD1 = "/tdr"