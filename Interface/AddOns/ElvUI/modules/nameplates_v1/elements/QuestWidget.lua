local E, L, V, P, G = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local mod = E:GetModule('NamePlates_v1')

--Cache global variables
--Lua functions
--WoW API / Variables
local path = "Interface\\AddOns\\ElvUI\\media\\textures\\"
local playerName = UnitName("player")
local tooltipFrame = CreateFrame("GameTooltip", "Eui_Tooltip_Unit", nil, "GameTooltipTemplate")
tooltipFrame:SetOwner(WorldFrame, "ANCHOR_NONE")
local C_NamePlate_GetNamePlates = C_NamePlate.GetNamePlates
local match = string.match

function mod:UpdateElement_QuestIconSetting()
	if IsPRType() then return; end

	for _, frame in pairs(C_NamePlate_GetNamePlates()) do
		if(frame and frame.UnitFrame and frame.UnitFrame.QuestIcon) then
			if not self.db.QuestIcon.enable then
				frame.UnitFrame.QuestIcon:Hide()
			else
				frame.UnitFrame.QuestIcon:SetSize(self.db.QuestIcon.size, self.db.QuestIcon.size)
				frame.UnitFrame.QuestIcon:ClearAllPoints()

				if(frame.UnitFrame.HealthBar:IsShown()) then
					frame.UnitFrame.QuestIcon:SetPoint("BOTTOMRIGHT", frame.UnitFrame.HealthBar, "BOTTOMLEFT", self.db.QuestIcon.xOffset, self.db.QuestIcon.yOffset)
				else
					frame.UnitFrame.QuestIcon:SetPoint("RIGHT", frame.UnitFrame.Name, "LEFT", self.db.QuestIcon.xOffset, self.db.QuestIcon.yOffset)
				end
			end
		end
	end
end

function mod:UpdateElement_QuestIcon(frame)
	if E:IsPRType() then return; end

	if (self.db.units[frame.UnitType].enable == false) or (self.db.QuestIcon.enable == false) then
		return;
	end

	local icon = frame.QuestIcon;
	local questObjective = false
	local questNoObjective = false
	
	tooltipFrame:SetUnit(frame.unit)
	for i = 3, tooltipFrame:NumLines() do
		local line = _G["Eui_Tooltip_UnitTextLeft" .. i]
		local text = line:GetText()
		local text_r, text_g, text_b = line:GetTextColor()

		if text_r > 0.99 and text_g > 0.82 and text_b == 0 then
			questNoObjective = true
		end
		local unitName, progress = match(text, "^ ([^ ]-) ?%- (.+)$")

		if unitName and (unitName == "" or unitName == playerName) then
			if progress then
				local current, goal = match(progress, "(%d+)/(%d+)")

				if current and goal and current ~= goal then
					questObjective = true
				end
				if current and goal and current == goal then
					questNoObjective = false
				end
			end
		end
	end

	if questObjective or questNoObjective then
		frame.QuestIcon:Show();
	else
		frame.QuestIcon:Hide()
	end

	if(frame.HealthBar:IsShown()) then
		frame.QuestIcon:SetPoint("BOTTOMRIGHT", frame.HealthBar, "BOTTOMLEFT", self.db.QuestIcon.xOffset, self.db.QuestIcon.yOffset)
	else
		frame.QuestIcon:SetPoint("RIGHT", frame.Name, "LEFT", self.db.QuestIcon.xOffset, self.db.QuestIcon.yOffset)
	end
end

function mod:ConstructElement_QuestIcon(frame)
	local texture = frame:CreateTexture(nil, "OVERLAY")
	texture:SetSize(self.db.QuestIcon.size, self.db.QuestIcon.size)
	texture:SetPoint("BOTTOMRIGHT", frame.HealthBar, "BOTTOMLEFT", self.db.QuestIcon.xOffset, self.db.QuestIcon.yOffset)

	texture:SetTexture(path .. "quest")
	texture:Hide()

	return texture
end