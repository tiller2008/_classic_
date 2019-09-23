local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');

--Cache global variables
--Lua functions

--WoW API / Variables
local CreateFrame = CreateFrame

function UF:Construct_MouseGlow(frame)
	frame:CreateShadow(2)
	local x = frame.shadow
	frame.shadow = nil
	--x:SetFrameStrata('BACKGROUND')
	x:Hide();
	
	local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass]
	if UF.db and UF.db.colors.healthclass then
		x:SetBackdropBorderColor(UF.db.colors.targetGlowColor.r, UF.db.colors.targetGlowColor.g, UF.db.colors.targetGlowColor.b)
	else
		x:SetBackdropBorderColor(color.r, color.g, color.b)
	end
	
	return x
end