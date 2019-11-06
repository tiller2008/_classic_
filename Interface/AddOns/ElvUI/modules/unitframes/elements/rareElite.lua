local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');

--Cache global variables
--Lua functions

--WoW API / Variables
local CreateFrame = CreateFrame

function UF:Configure_RareElite(frame)
	--Rare texture
	local rare = frame.Rare
	local db = frame.db

	rare:ClearAllPoints()
	if db.DragonOverlayStyle == 'classic' then
		rare:Size(256, 128)
		rare:Point('TOPRIGHT', frame, 'TOPRIGHT', 100, 15)
		rare:Show()
	elseif db.DragonOverlayStyle == 'modern' then
		rare:Size(100, 100)
		rare:Point('TOPRIGHT', frame, 'TOPRIGHT', 36, 8)
		rare:Show()
	else
		rare:Hide()
	end
	rare.DragonOverlayStyle = db.DragonOverlayStyle

	if E.db.unitframe.units.pet.happy.enable and not frame:IsElementEnabled('RareElite') then
		frame:EnableElement('RareElite')
	elseif not E.db.unitframe.units.pet.happy.enable and frame:IsElementEnabled('RareElite') then
		frame:DisableElement('RareElite')
	end
end

function UF:Construct_RareElite(frame)
	local SimpleRareElite = CreateFrame('Frame', nil, frame)
	SimpleRareElite.Texture = SimpleRareElite:CreateTexture('ARTWORK')
	SimpleRareElite.Texture:SetAllPoints()
	SimpleRareElite:SetFrameLevel(15)
	SimpleRareElite:SetSize(256, 128)
	SimpleRareElite:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 100, 15)
	SimpleRareElite.Texture:SetTexture(0, 1, 0, 1)	
	
	return SimpleRareElite
end