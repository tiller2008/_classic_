local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule('DataTexts')

local GREEN_FONT_COLOR = GREEN_FONT_COLOR
local RED_FONT_COLOR = RED_FONT_COLOR
local C_MountJournalGetNumMounts = C_MountJournal.GetNumMounts
local C_MountJournalGetMountInfo = C_MountJournal.GetMountInfo
local C_MountJournalGetMountInfoExtra = C_MountJournal.GetMountInfoExtra
local twipe, sort, pairs = table.wipe, table.sort, pairs

----------------------------------------------------------------------------------------
--	Mount Info
--  eui.cc at 2015.3.22
----------------------------------------------------------------------------------------
local MountDB = {}

local function OnEvent(self)
	wipe(MountDB)
	local maxNum = C_MountJournalGetNumMounts()
	local num = 0
	for i = 1, C_MountJournalGetNumMounts() do
		local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected = C_MountJournalGetMountInfo(i)
		if creatureName and not isCollected then
			local creatureDisplayID, descriptionText, sourceText, isSelfMount = C_MountJournalGetMountInfoExtra(i)
			MountDB[creatureDisplayID] = {
				['name'] = creatureName,
				['text'] = sourceText,
				['icon'] = icon
			}
			num = num + 1
		end
	end
	sort(MountDB)
	self.text:SetText(num.. '/'.. maxNum)
end

local function OnEnter(self)
	DT:SetupTooltip(self)
	
	local num = 0
	for k, v in pairs(MountDB) do
		num = num + 1
		if num > 20 then break; end
--		DT.tooltip:AddDoubleLine(v.name,v.text, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		DT.tooltip:AddLine(('|T%s:20:20:0:0:64:64:4:60:4:60|t %s'):format(v.icon, v.name), GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		DT.tooltip:AddLine(v.text, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	end
	
	DT.tooltip:Show()
end

local function Click(self)
	
end

DT:RegisterDatatext('MountInfo', {'PLAYER_ENTERING_WORLD', 'COMPANION_UPDATE'}, OnEvent, nil, Click, OnEnter)