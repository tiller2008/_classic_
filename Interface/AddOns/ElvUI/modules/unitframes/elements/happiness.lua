local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');

--Lua functions
--WoW API / Variables

function UF:Construct_HappyIcon(frame)
	local HappyIndicator = frame.RaisedElementParent.TextureParent:CreateTexture(nil, 'OVERLAY')
	HappyIndicator:Size(16, 16)
	HappyIndicator:Point('TOPRIGHT', frame, 0, 0)
	return HappyIndicator
end

function UF:Configure_HappyIcon(frame)
	if not E.db.unitframe.units.pet then return end

	local HappinessIndicator = frame.HappinessIndicator
	HappinessIndicator:ClearAllPoints()
	HappinessIndicator:Point(E.db.unitframe.units.pet.happy.anchorPoint, frame.Health, E.db.unitframe.units.pet.happy.anchorPoint, E.db.unitframe.units.pet.happy.xOffset, E.db.unitframe.units.pet.happy.yOffset)

	local scale = E.db.unitframe.units.pet.happy.scale or 1
	HappinessIndicator:Size(16 * scale)

	if E.db.unitframe.units.pet.happy.enable and not frame:IsElementEnabled('HappinessIndicator') then
		frame:EnableElement('HappinessIndicator')
	elseif not E.db.unitframe.units.pet.happy.enable and frame:IsElementEnabled('HappinessIndicator') then
		frame:DisableElement('HappinessIndicator')
	end
end
