local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
FireMage = E:NewModule("FireMage", 'AceEvent-3.0', 'AceTimer-3.0');
local LSM = LibStub("LibSharedMedia-3.0")
local FS = FireMage

local GetSpellInfo = GetSpellInfo
local select, tostring = select, tostring
local UnitClass = UnitClass
local floor, tremove, tinsert = math.floor, tremove, tinsert
local UnitDebuff = UnitDebuff
local GetSpecialization = GetSpecialization
local CreateFrame = CreateFrame


local buffName,_, buffIcon = GetSpellInfo(12654)
local buffSpell = GetSpellInfo(11129)
local class = select(2, UnitClass("player"));
local unusedOverlays = {}

local function OnUpdate(self)
	if self.Expires then
		local t = self.Expires - GetTime()
		if t >= 6 then
			self.time:SetFormattedText('%s', tostring(floor(t)))
		else
			self.time:SetFormattedText('%.1f', t)
		end
	else
		self.time:SetText('')
	end
end	

local function createOverlay(btn)
	local isize = FS.db.size
	local overlay = tremove(unusedOverlays)
	if not overlay then
		overlay = CreateFrame("Frame", nil, btn, "FSSpellActivationAlert")
	end
	overlay:ClearAllPoints()
	overlay:SetParent(btn)
	overlay:SetAlpha(0.7)
	overlay:Point("TOPLEFT", btn, "TOPLEFT", -isize * 0.4, isize * 0.4)
	overlay:Point("BOTTOMRIGHT", btn, "BOTTOMRIGHT", isize * 0.4, -isize * 0.4);
	btn.overlay = overlay
	overlay.animIn:Play()
end

function FS:OverlayGlowAnimOutFinished(animGroup)
    local overlay = animGroup:GetParent()
    overlay:Hide()
    tinsert(unusedOverlays, overlay)
end

function FS:ThrottleSound()
	self.SoundPlayed = nil;
end

function FS:Update(event, unit)
	if event == 'UNIT_AURA' and unit ~= 'target' then return; end
	
	if not UnitDebuff('target', buffName, nil,"PLAYER") then
		self.button:SetAlpha(0)
		self.button:SetScript("OnUpdate", nil)
		return;
	else
		self.button:SetAlpha(1)
	end
	
	local start, duration = GetSpellCooldown(buffSpell)
	
	if start and start > 0 then
		self.button.sb:SetAlpha(1);
		self.button.sb:SetValue(floor(duration - GetTime() + start));
	else
		self.button.sb:SetAlpha(0);
		self.button.sb:SetValue(0);
	end
	
	local _,_,_,_,_, Expires, _,_,_,_,_,_,_,value = UnitDebuff('target', buffName, nil,"PLAYER");
	if value >= self.db.maxValue and start == 0 then
		if self.db.sound ~= 'None' and not self.SoundPlayed then
			PlaySoundFile(LSM:Fetch("sound", self.db.sound), "Master")
			self.SoundPlayed = true
			self.SoundTimer = FS:ScheduleTimer('ThrottleSound', 2)
		end
		if not self.button.overlay then	self.button:CreateOverlay(); end
	else
		if self.button.overlay then
			if self.button.overlay.animIn:IsPlaying() then
				self.button.overlay.animIn:Stop()
			end
			self.button.overlay.animOut:Play()
			self.button.overlay = nil
		end	
	end
	
	self.button.text:SetText(E:ShortValue(value))
	self.button.Expires = Expires
	
	self.button:SetScript("OnUpdate", OnUpdate)
end

function FS:Toggle()
	if self.db.enable and GetSpecialization() == 2 then
		self:RegisterEvent("UNIT_AURA", "Update");
		self:RegisterEvent("PLAYER_TARGET_CHANGED", "Update");
		self.button:Show()
	else
		self:UnregisterEvent("UNIT_AURA");
		self:UnregisterEvent("PLAYER_TARGET_CHANGED");
		self.button:SetAlpha(0);
		self.button:Hide()
	end
	self:UpdateSize()
end

function FS:UpdateSize()
	self.button:Size(self.db.size)
	self.button.time:SetFont(LSM:Fetch("font", E.db.unitframe.font), self.db.fontsize * .7, 'OUTLINE')
	self.button.text:SetFont(LSM:Fetch("font", E.db.unitframe.font), self.db.fontsize, 'OUTLINE')
end

function FS:Initialize()
	if class ~= 'MAGE' then return end;
	self.db = E.db.euiscript.fsbutton
	
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", "Toggle")
	
	local f = CreateFrame("Button", nil, E.UIParent, "SecureActionButtonTemplate")
--	local f = CreateFrame("Button", nil, E.UIParent)
	f:RegisterForClicks('AnyUp')
	f:SetTemplate()
--	f:StyleButton()
	f:SetFrameLevel(5)
	f:SetAlpha(0)
	f:Size(self.db.size)
	f:Point("CENTER", E.UIParent, "CENTER", -400, 0)
	self.button = f

	f.CreateOverlay = createOverlay
	
	f.Icon = f:CreateTexture(nil, 'ARTWORK')
	f.Icon:Point("TOPLEFT", 2, -2)
	f.Icon:Point("BOTTOMRIGHT", -2, 2)
	f.Icon:SetTexCoord(.08, .92, .08, .92)
	f.Icon:SetTexture(buffIcon)		
	
	f.time = f:CreateFontString(nil, 'OVERLAY')
	f.time:FontTemplate(LSM:Fetch("font", E.db.unitframe.font), self.db.fontsize * .7, 'OUTLINE')
	f.time:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
	f.time:SetTextColor(1,1,0)

	f.text = f:CreateFontString(nil, 'OVERLAY')
	f.text:FontTemplate(LSM:Fetch("font", E.db.unitframe.font), self.db.fontsize, 'OUTLINE')
	f.text:Point("CENTER", f, "CENTER", 0, 2)
	f.text:SetTextColor(1,1,0)
	
	f.sb = CreateFrame("StatusBar", nil, f)
	f.sb:SetStatusBarTexture(E["media"].normTex)
	f.sb:SetStatusBarColor(0.8, 0.1, 0.1)
	f.sb:CreateBackdrop()	
	f.sb:SetAlpha(0)
	f.sb:Point("BOTTOMLEFT", f, "TOPLEFT", 2, 4)
	f.sb:Point("TOPRIGHT", f, "TOPRIGHT", -2, 10)
	f.sb:SetMinMaxValues(0, 45)
	
	f:SetAttribute("type1", "spell")
	f:SetAttribute("spell1", buffSpell)
	
	E:CreateMover(f, "EuiMageFireMover", buffName, nil, nil, nil, "ALL,EUI", nil, "euiscript,fsbutton","db,euiscript,fsbutton,enable")

	self:Toggle()
end

E:RegisterModule(FS:GetName())