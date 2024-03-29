﻿local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

local find, sub, format, select = string.find, string.sub, string.format, select
local UnitGUID = UnitGUID
local GetAchievementNumCriteria = GetAchievementNumCriteria
local format, select = format, select
local GetAchievementInfo = GetAchievementInfo
local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo
local ACHIEVEMENT_EARNED_BY, ACHIEVEMENT_NOT_COMPLETED_BY, ACHIEVEMENT_COMPLETED_BY = ACHIEVEMENT_EARNED_BY, ACHIEVEMENT_NOT_COMPLETED_BY, ACHIEVEMENT_COMPLETED_BY

----------------------------------------------------------------------------------------
--	Your achievement status in tooltip(Enhanced Achievements by Syzgyn)
----------------------------------------------------------------------------------------
local colors = {
	["GREEN"] = {
		["r"] = 0.25,
		["g"] = 0.75,
		["b"] = 0.25,
	},
	["GRAY"] = {
		["r"] = 0.5,
		["g"] = 0.5,
		["b"] = 0.5,
	},
}

local function hookSetHyperlink(tooltip, refString)
	if E.private["tooltip"].enable ~= true then return end

	if E:IsPRType() then return end

	local _, achievementID, numCriteria, GUID, name, completed, quantity, reqQuantity, month, day, year
	local output = {[0] = {}, [1] = {}}
	if select(3, find(refString, "(%a-):")) ~= "achievement" then return end

	achievementID = select(3, find(refString, ":(%d+):"))
	numCriteria = GetAchievementNumCriteria(achievementID)
	GUID = select(3, find(refString, ":%d+:(.-):"))

	if GUID == sub(UnitGUID("player"), 3) then
		tooltip:Show()
		return
	end

	tooltip:AddLine(" ")
	_, _, _, completed, month, day, year, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(achievementID)

	if completed then
		if year < 10 then year = "0" .. year end

		tooltip:AddLine(L["Your Status: Completed on "].. month .. "/" .. day .. "/" .. year, 0, 1, 0)

		if earnedBy then
			tooltip:AddLine(format(ACHIEVEMENT_EARNED_BY, earnedBy))
			if not wasEarnedByMe then
				tooltip:AddLine(format(ACHIEVEMENT_NOT_COMPLETED_BY, E.myname))
			elseif E.myname ~= earnedBy then
				tooltip:AddLine(format(ACHIEVEMENT_COMPLETED_BY, E.myname))
			end
		end
	elseif numCriteria == 0 then
		tooltip:AddLine(L["Your Status: Incomplete"])
	else
		tooltip:AddLine(L["Your Status:"])
		for i = 1, numCriteria, 2 do
			for a = 0, 1 do
				output[a].text = nil
				output[a].color = nil
				if i + a <= numCriteria then
					name, _, completed, quantity, reqQuantity = GetAchievementCriteriaInfo(achievementID, i + a)
					if completed then
						output[a].text = name
						output[a].color = "GREEN"
					else
						if quantity < reqQuantity and reqQuantity > 1 then
							output[a].text = name .. " (" .. quantity .. "/" .. reqQuantity .. ")"
							output[a].color = "GRAY"
						else
							output[a].text = name
							output[a].color = "GRAY"
						end
					end
				else
					output[a].text = nil
				end
			end
			if output[1].text == nil then
				tooltip:AddLine(output[0].text, colors[output[0].color].r, colors[output[0].color].g, colors[output[0].color].b)
			else
				tooltip:AddDoubleLine(output[0].text, output[1].text, colors[output[0].color].r, colors[output[0].color].g, colors[output[0].color].b, colors[output[1].color].r, colors[output[1].color].g, colors[output[1].color].b)
			end
			output = {[0] = {}, [1] = {}}
		end
	end
	tooltip:Show()
end

hooksecurefunc(GameTooltip, "SetHyperlink", hookSetHyperlink)
hooksecurefunc(ItemRefTooltip, "SetHyperlink", hookSetHyperlink)