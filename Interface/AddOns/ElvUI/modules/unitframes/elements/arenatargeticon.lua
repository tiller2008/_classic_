local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');

--Cache global variables
--Lua functions

--WoW API / Variables
local CreateFrame = CreateFrame

function UF:Construct_ArenaTargetIcon(frame)
	local targetIcon = CreateFrame("Frame", nil, frame)
	targetIcon:SetFrameLevel(frame.RaisedElementParent:GetFrameLevel() + 10)

	targetIcon.bg = CreateFrame("Frame", nil, targetIcon)
	targetIcon.bg:SetTemplate("Default", nil, nil, self.thinBorders)
	targetIcon.bg:SetFrameLevel(targetIcon:GetFrameLevel() - 1)
	targetIcon:SetInside(targetIcon.bg)
	
	targetIcon.Name = targetIcon:CreateFontString(nil, 'OVERLAY')
	UF:Configure_FontString(targetIcon.Name)

	return targetIcon
end

function UF:Configure_ArenaTargetIcon(frame)
	if not frame.VARIABLES_SET then return end
	local db = frame.db
	local targetIcon = frame.ArenaTargetIcon

	targetIcon.bg:Size(db.arenaTargetIcon.size)
	targetIcon.bg:ClearAllPoints()
	if db.arenaTargetIcon.position == 'RIGHT' then
		targetIcon.bg:Point('LEFT', frame, 'RIGHT', db.arenaTargetIcon.xOffset, db.arenaTargetIcon.yOffset)
	else
		targetIcon.bg:Point('RIGHT', frame, 'LEFT', db.arenaTargetIcon.xOffset, db.arenaTargetIcon.yOffset)
	end
	targetIcon.showEnemy = db.arenaTargetIcon.showEnemy

	targetIcon.Name:ClearAllPoints()
	if db.arenaTargetIcon.Name then
		targetIcon.Name:Point("CENTER", targetIcon, "CENTER", db.arenaTargetIcon.NamexOffset, db.arenaTargetIcon.NameyOffset)
	end

	if db.arenaTargetIcon.enable and not frame:IsElementEnabled('ArenaTargetIcon') then
		frame:EnableElement('ArenaTargetIcon')
	elseif not db.arenaTargetIcon.enable and frame:IsElementEnabled('ArenaTargetIcon') then
		frame:DisableElement('ArenaTargetIcon')
	end
end