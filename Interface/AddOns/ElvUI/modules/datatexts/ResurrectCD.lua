local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule('DataTexts')

local GetSpellInfo = GetSpellInfo
local GetSpellCharges = GetSpellCharges
local IsInInstance = IsInInstance
local floor, time, select = math.floor, time, select
local SendChatMessage = SendChatMessage

local SPELLNAME = GetSpellInfo(20484)
----------------------------------------------------------------------------------------
--	Resurrect cooldowns
--  eui.cc at 2015.3.21
----------------------------------------------------------------------------------------
local function OnUpdate(self, elapsed)
	if(self.elapsed and self.elapsed > 0.4) then
		if select(2, IsInInstance()) == "raid" then
			local charges, maxCharges, started, duration = GetSpellCharges(20484) -- Rebirth
			if not charges then
				self.text:SetText(SPELLNAME)
				return;
			end
			local time = duration - (GetTime() - started)
			local m = floor(time/60)
			local s = mod(time, 60)
			self.text:SetFormattedText(SPELLNAME..":|cffC495DD%d|r %02d:%02d", charges, m, s)
		else
			self.text:SetText(SPELLNAME)
			return;
		end
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end		
end

local function Click(self)
	if self.text:GetText() ~= SPELLNAME then
		SendChatMessage(self.text:GetText(), E:CheckChat())
	end
end

DT:RegisterDatatext("ResurrectCD", nil, nil, OnUpdate, Click, nil, nil)