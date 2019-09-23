--Title: BanditsGuileHelper
--Notes: Rogue Bandit's Guile Helper
--Author: Indz
--Version: 0.9
local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BG = E:NewModule("BanditsGuile", 'AceEvent-3.0');
local LSM = LibStub("LibSharedMedia-3.0")
local GetSpellInfo = GetSpellInfo
local UnitAura = UnitAura
local select = select
local UnitBuff = UnitBuff
local GetTime = GetTime
local max, floor = math.max, math.floor


local inCombat = false
local BGState = 0
local BGCount = 0
local avg = 0
local buffName,_, buffIcon = GetSpellInfo(84745)

local function getTimeLeftOnBG3()
	local name, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID
	local unit = "player"
	local filter = "HELPFUL"
	local bg3name = GetSpellInfo(84747)

	spellID = select(10, UnitAura(unit, bg3name , nil, filter))
	if spellID == 84747 then
		expires = select(6, UnitAura(unit, bg3name ,nil, filter))
		return (expires-GetTime())
	end

	return 0
end

local function getActualPoint()
	local stage = BGState -- 0,1,2,3
	local intermediatestage
	if stage ~= 3 then
		intermediatestage = BGCount
		point = (4-intermediatestage)*avg+(2-stage)*4*avg+15
	else
		point = getTimeLeftOnBG3()
	end

	return point
end

function BG:PLAYER_REGEN_DISABLED()
	self.button:Show()
	self.button.count:SetText('0')
end

function BG:PLAYER_REGEN_ENABLED()
	self.button:Hide()
	avg = 0
end

local function getBufftime(id)
	local buffname = GetSpellInfo(id)
	
	local spellID = select(10, UnitBuff('player', buffname))
	if spellID == id then
		local expires = select(6, UnitBuff('player', buffname))
		return (expires-GetTime())
	end
end


function BG:UNIT_AURA(event, unit)
	local name, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID
	local unit = "player"
	local filter = "HELPFUL|PLAYER"
	for index=1,40 do
		name, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID = UnitAura(unit, index, filter)
		if spellID == 84745 then
			if BGState ~= 1 then
				BGState = 1
				BGCount = 0
				self.button.icon:SetTexture(icon)
				self.button.icon:SetDesaturated(false)
			end
			self.button:SetScript("OnUpdate", nil)
			self.button:SetScript("OnUpdate", function(self)
				BG.button.time:SetText(max(floor(getBufftime(spellID)),0)..'s')
			end)			
			return
		elseif spellID == 84746 then
			if BGState ~= 2 then
				BGState = 2
				BGCount = 0
				self.button.icon:SetTexture(icon)
				self.button.icon:SetDesaturated(false)
			end
			self.button:SetScript("OnUpdate", nil)
			self.button:SetScript("OnUpdate", function(self)
				BG.button.time:SetText(max(floor(getBufftime(spellID)),0)..'s')
			end)			
			return
		elseif spellID == 84747 then
			if BGState ~= 3 then
				BGState = 3
				BGCount = 0
				self.button.icon:SetTexture(icon)
				self.button.icon:SetDesaturated(false)
			end
			self.button:SetScript("OnUpdate", function(self)
				BG.button.count:SetText(max(floor(getActualPoint()),0)..'s')
			end)
			BG.button.time:SetText('')
			return
		end
	end
	
	self.button:SetScript("OnUpdate", nil)
	self.button.icon:SetTexture(buffIcon)
	self.button.icon:SetDesaturated(true)
--	self.button.count:SetText('0')
	BGState = 0
end
	
function BG:COMBAT_LOG_EVENT_UNFILTERED(eventName)
	local _, event, _, sourceGUID, source, _, _, _, destName, _, _, _, _, _, spellID, spellName,_,_,_,_,_,_,_,_,_,_,_,multistrike = CombatLogGetCurrentEventInfo()
	
	if source ~= UnitName("player") then
		return
	end

	if event == "SPELL_DAMAGE" and (spellId == 1752 and multistrike == false) then	
		BGCount = BGCount + 1
	elseif event == "SPELL_AURA_REMOVED" and (spellId == 84747 or spellId == 84746 or spellId == 84745) then
		BGCount = 0
	end

	if BGState < 3 then self.button.count:SetText(BGCount) end
end

function BG:CheckSpec()
	if (GetSpecialization() ~= 2) then
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	else
		self:RegisterEvent("UNIT_AURA")
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end
end

function BG:Toggle()
	if E.db.euiscript.bg.enable then
		if not self.button then self:CreateButton() end
		
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "CheckSpec")
		self:RegisterEvent("PLAYER_TALENT_UPDATE", "CheckSpec")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckSpec")
		
		self:CheckSpec()
		self:UpdateSize()
	else
		self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		self:UnregisterEvent("PLAYER_TALENT_UPDATE")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")	
		
		if self.button then self.button:ClearAllPoints(); self.button = nil; end
	end
	
end

function BG:UpdateSize()
	self.button:Size(E.db.euiscript.bg.size)
	self.button.count:SetFont(LSM:Fetch("font", E.db.unitframe.font), E.db.euiscript.bg.fontsize, 'OUTLINE')
	self.button.time:SetFont(LSM:Fetch("font", E.db.unitframe.font), E.db.euiscript.bg.fontsize, 'OUTLINE')
end

function BG:CreateButton()
	local f = CreateFrame("Button", "EuiBanditsGuileIcon", E.UIParent)
--	f:RegisterForClicks('AnyUp')
	f:SetTemplate()
	f:StyleButton()
	f:Hide()
	f:SetFrameLevel(5)
	f:Size(E.db.euiscript.bg.size)
	f:SetPoint("CENTER", E.UIParent, "CENTER", -400, -200)
	self.button = f

	f.icon = f:CreateTexture(nil, 'ARTWORK')
	f.icon:Point("TOPLEFT", 2, -2)
	f.icon:Point("BOTTOMRIGHT", -2, 2)
	f.icon:SetTexCoord(.08, .92, .08, .92)
	f.icon:SetTexture(buffIcon)
	f.icon:SetDesaturated(true)
	
	f.time = f:CreateFontString(nil, 'OVERLAY')
	f.time:FontTemplate(LSM:Fetch("font", E.db.unitframe.font), E.db.euiscript.bg.fontsize, 'OUTLINE')
	f.time:SetPoint("TOP", f, "BOTTOM", 0, -2)
	f.time:SetTextColor(1,1,0)	

	f.count = f:CreateFontString(nil, 'OVERLAY')
	f.count:FontTemplate(LSM:Fetch("font", E.db.unitframe.font), E.db.euiscript.bg.fontsize, 'OUTLINE')
	f.count:SetPoint("CENTER", f, "CENTER", 0, 0)
		
	E:CreateMover(f, "EuiBanditsGuileIconMover", buffName, nil, nil, nil, "ALL,EUI", nil, "euiscript", "db,euiscript,bg,enable")
end

function BG:Initialize()
	if E.myclass ~= 'ROGUE' then return; end
	
	self:Toggle()
end

E:RegisterModule(BG:GetName())