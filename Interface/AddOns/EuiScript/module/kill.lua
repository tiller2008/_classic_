local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
EuiExecute = E:NewModule("Execute", 'AceEvent-3.0', 'AceTimer-3.0');
local LSM = LibStub("LibSharedMedia-3.0")

local select = select
local GetSpellInfo = GetSpellInfo
local GetSpellCooldown = GetSpellCooldown
local UnitHealth = UnitHealth
local GetInventoryItemID = GetInventoryItemID
local tremove = tremove
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local UnitCanAttack = UnitCanAttack
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitIsConnected = UnitIsConnected
local UnitHealthMax = UnitHealthMax
local PlaySoundFile = PlaySoundFile
local UnitName = UnitName

local class = select(2, UnitClass("player"));
local spellname = GetSpellInfo(5308)
local K = EuiExecute
local unusedOverlays = {}

local function CanSpellBeUsed(id)
	local name = GetSpellInfo(id);
	if not name then return false end
	local start, duration, enabled = GetSpellCooldown(name)
	if enabled == 0 or start == nil or duration == nil then 
		return false
	elseif start > 0 and duration > 1.5 then	--On Cooldown
		return false
	else --Off Cooldown
		return true
	end
end

local function CanKiller(current, max, perc)
	if perc < 100 then
		if (current / max ) * 100 > perc then
			return false;
		else
			return true
		end
	else
		if UnitHealth('player') < current then
			return false;
		else
			return true
		end
	end
end

local function createOverlay(btn)
	local isize = K.db.size
	local overlay = tremove(unusedOverlays)
	if not overlay then
		overlay = CreateFrame("Frame", nil, btn, "ExecuteSpellActivationAlert")
	end
	overlay:ClearAllPoints()
	overlay:SetParent(btn)
	overlay:SetAlpha(0.7)
	overlay:Point("TOPLEFT", btn, "TOPLEFT", -isize * 0.4, isize * 0.4)
	overlay:Point("BOTTOMRIGHT", btn, "BOTTOMRIGHT", isize * 0.4, -isize * 0.4);
	btn.overlay = overlay
	overlay.animIn:Play()
end

function K:OverlayGlowAnimOutFinished(animGroup)
    local overlay = animGroup:GetParent()
    overlay:Hide()
    tinsert(unusedOverlays, overlay)
end

function K:ThrottleSound()
	self.SoundPlayed = nil;
end

function K:Update(event, unit)
	if not UnitName('target') or UnitIsDead('target') or UnitIsGhost('target') or not UnitIsConnected('target') then
		self.button:Hide();
		return
	end
	if event == 'PLAYER_TARGET_CHANGED' then
		unit = 'target'
	end
	if unit ~= 'target' then return; end
	
	if not InCombatLockdown() then
		self.button:Hide();
		return
	end
	
	local _, instanceType = IsInInstance()
	if self.db.instance and (instanceType ~= "party" and instanceType ~= "raid" and instanceType ~= 'arena') then
		self.button:Hide();
		return
	end
	
	if unit == 'target' and not UnitCanAttack("player", unit) then
		self.button:Hide();
		return;
	end
	
	if not unit then
		self.button:Hide();
		return
	end
	
	local db = E.db.euiscript.executebutton.spellList[class][GetSpecialization()]
	if not db or not db.spellid or not db.enabled then
		self.button:Hide()
		return;
	end

	local current, max = UnitHealth(unit), UnitHealthMax(unit)
	if CanKiller(current, max, db.perc) then
		self.button:Show()
		self.button.text:SetText(GetSpellInfo(db.spellid))
	else
		self.button:Hide()
		return;
	end
	if CanSpellBeUsed(db.spellid) then
		if self.db.sound ~= 'None' and not self.SoundPlayed then
			PlaySoundFile(LSM:Fetch("sound", self.db.sound), "Master")
			self.SoundPlayed = true
			self.SoundTimer = K:ScheduleTimer('ThrottleSound', 2)
		end
	--	if not self.button.overlay then	self.button:CreateOverlay(); end	
	else
		if self.button.overlay then
			if self.button.overlay.animIn:IsPlaying() then
				self.button.overlay.animIn:Stop()
			end
			self.button.overlay.animOut:Play()
			self.button.overlay = nil
		end	
	end
end

function K:UpdateTalent()
	local db = E.db.euiscript.executebutton.spellList[class][0]
	if not db or not db.spellid then return; end
	
	local spellName,_, spellIcon = GetSpellInfo(db.spellid)
--	self.button:SetAttribute("type1", "spell")
--	self.button:SetAttribute("spell1", spellName)
	self.button.Icon:SetTexture(spellIcon)
end

function K:Toggle()
	if self.db.enable and (UnitLevel('player') > 30) then
		self:RegisterEvent("PLAYER_TARGET_CHANGED", "Update");
		self:RegisterEvent("UNIT_HEALTH_FREQUENT", "Update");
		self:RegisterEvent("PLAYER_FLAGS_CHANGED", "Update");
		self:RegisterEvent("CHARACTER_POINTS_CHANGED", "UpdateTalent");
	else
		self:UnregisterEvent("PLAYER_TARGET_CHANGED");
		self:UnregisterEvent("UNIT_HEALTH_FREQUENT");
		self:UnregisterEvent("PLAYER_FLAGS_CHANGED");	
		self:UnregisterEvent("CHARACTER_POINTS_CHANGED");
		self.button:Hide();
	end
	self:UpdateSize()
	self:UpdateTalent()
end

function K:UpdateSize()
	self.button:Size(self.db.size)
end

function K:Initialize()
	self.db = E.db.euiscript.executebutton
	
	local f = CreateFrame("Button", nil, E.UIParent)
	f:RegisterForClicks('AnyUp')
	f:SetTemplate()
	f:StyleButton()
	f:SetFrameLevel(5)
	f:Hide()
	f:Size(self.db.size)
	f:Point("CENTER", E.UIParent, "CENTER", -400, 200)
	self.button = f  
	
	f.CreateOverlay = createOverlay
	
	f.Icon = f:CreateTexture(nil, 'ARTWORK')
	f.Icon:Point("TOPLEFT", 2, -2)
	f.Icon:Point("BOTTOMRIGHT", -2, 2)
	f.Icon:SetTexCoord(.08, .92, .08, .92)
	
	f.text = f:CreateFontString(nil, 'OVERLAY')
	f.text:FontTemplate(LSM:Fetch("font", E.db.unitframe.font), self.db.fontsize, 'OUTLINE')
	f.text:Point("TOP", f, "BOTTOM", 0, -4)
	f.text:SetTextColor(1,1,0)
	
	E:CreateMover(f, "EuiExecuteMover", spellname, nil, nil, nil, "ALL,EUI", nil, "euiscript,executebutton", "db,euiscript,executebutton,enable")
	
	self:Toggle()
end

E:RegisterModule(K:GetName())