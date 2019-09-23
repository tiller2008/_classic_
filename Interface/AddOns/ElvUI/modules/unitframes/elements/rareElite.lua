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
	UF:UpdateTargetRare();
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

function UF:UpdateTargetRare(event)
	if UnitName('target') then
		local TargetClass = UnitIsPlayer('target') and select(2, UnitClass('target')) or UnitClassification('target')
		if TargetClass == 'worldboss' or TargetClass == 'elite' or TargetClass == 'rare' or TargetClass == 'rareelite' then
			ElvUF_Target.Rare.Texture:SetTexture('Interface\\AddOns\\EuiScript\\textures\\'.. E.db.unitframe.units.target.DragonOverlayStyle ..'\\'..TargetClass..'.tga')
		else
			ElvUF_Target.Rare.Texture:SetTexture()
		end
	else
		ElvUF_Target.Rare.Texture:SetTexture()
	end
end