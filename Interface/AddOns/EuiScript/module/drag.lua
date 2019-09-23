local E, L, DF = unpack(ElvUI); --Engine
if E.db["euiscript"].drag ~= true then return end
-- BlizzMmove, move the blizzard frames by yess
-- v1.8

local BlizzMove = {}

function BlizzMove:CreateOwnHandleFrame(frame, width, height, offX, offY, name)
	local handle = CreateFrame("Frame", "BlizzMovehandle"..name)
	handle:SetWidth(width)
	handle:SetHeight(height)
	handle:SetParent(frame)
	handle:EnableMouse(true)
	handle:SetMovable(true)
	handle:SetPoint("TOPLEFT", frame ,"TOPLEFT", offX, offY)
	--[[
	handle:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	                                        edgeFile = nil,
	                                       tile = true, tileSize = 16, edgeSize = 16,
	                                        insets = { left = 0, right = 0, top = 0, bottom = 0 }})
	handle:SetBackdropColor(1,0,0,0.5)
	--]]
	--handle:SetFrameStrata("MEDIUM")
	return handle
end

local function OnDragStart(self)
	local frameToMove = self.frameToMove
	if frameToMove:IsMovable() then
    frameToMove:StartMoving()
    frameToMove.isMoving = true
  end
end

local function OnDragStop(self)
	local frameToMove = self.frameToMove
	frameToMove:StopMovingOrSizing()
	frameToMove.isMoving = false
end


local function OnMouseWheel(self, vector, ...)
	if not IsControlKeyDown() then return end
	local scale = self.frameToMove:GetScale() or 1
	scale = scale + .1 * vector
	if scale > 1.5  then scale = 1.5
	elseif scale < .5 then scale = .5 end
	self.frameToMove:SetScale(scale)
end

function BlizzMove:CreateQuestTrackerHandle()
	local handle = CreateFrame("Frame", "BlizzMovehandleQuestTracker")
	handle:SetParent(ObjectiveTrackerFrame)
	handle:EnableMouse(true)
	handle:SetMovable(true)
	handle:SetAllPoints(ObjectiveTrackerFrame.HeaderMenu.Title)

	ObjectiveTrackerFrame.BlocksFrame.QuestHeader:EnableMouse(true)
	ObjectiveTrackerFrame.BlocksFrame.AchievementHeader:EnableMouse(true)
	ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader:EnableMouse(true)
	return handle
end

function BlizzMove:SetMoveHandle(frameToMove, handle)
	if not frameToMove then
	--	print("Expected frame got nil.")
		return
	end
	if not handle then handle = frameToMove end
	handle.frameToMove = frameToMove

	if not frameToMove.EnableMouse then return end
	frameToMove:SetMovable(true)
	handle:RegisterForDrag("LeftButton");

	handle:SetScript("OnDragStart", OnDragStart)
	handle:SetScript("OnDragStop", OnDragStop)
	handle:EnableMouseWheel(true)
	handle:HookScript("OnMouseWheel",OnMouseWheel)
end


--BlizzMmove.lua

movableFrames = { GameMenuFrame, QuestFrame, FriendsFrame, GossipFrame, DressUpFrame,
	MerchantFrame, HelpFrame, MailFrame, BankFrame, VideoOptionsFrame, InterfaceOptionsFrame, PVEFrame,
	LootFrame, RaidBrowserFrame, TradeFrame, TradeFrame, RaidBrowserFrame, QuestLogPopupDetailFrame, SUFWrapperFrame, TalkingHeadFramem
}

movableFramesWithhandle = { ["CharacterFrame"] =  { PaperDollFrame, fff, ReputationFrame, TokenFrame , PetPaperDollFrameCompanionFrame, ReputationFrame } ,
	["MailFrame"] = {SendMailFrame},
	["ColorPickerFrame"] = { BlizzMove:CreateOwnHandleFrame(ColorPickerFrame, 132, 32, 117, 8, "ColorPickerFrame") },
	["SpellBookFrame"] = { BlizzMove:CreateOwnHandleFrame(SpellBookFrame, 445, 32, 85, 0, "SpellBookFrame") },
	--["ObjectiveTrackerFrame"] = { createQuestTrackerHandle() , ObjectiveTrackerFrame.BlocksFrame.QuestHeader, ObjectiveTrackerFrame.BlocksFrame.AchievementHeader, ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader},
}

movableFramesLoD = {
	["Blizzard_Collections"] = function() BlizzMove:SetMoveHandle(CollectionsJournal); BlizzMove:SetMoveHandle(WardrobeFrame) end,
	["Blizzard_InspectUI"] = function() BlizzMove:SetMoveHandle(InspectFrame) end,
--	["Blizzard_GuildBankUI"] = function() BlizzMove:SetMoveHandle(GuildBankFrame) end,
	["Blizzard_TradeSkillUI"] = function() BlizzMove:SetMoveHandle(TradeSkillFrame) end,
	["Blizzard_ItemSocketingUI"] = function() BlizzMove:SetMoveHandle(ItemSocketingFrame) end,
	["Blizzard_BarbershopUI"] = function() BlizzMove:SetMoveHandle(BarberShopFrame) end,
	["Blizzard_MacroUI"] = function() BlizzMove:SetMoveHandle(MacroFrame) end,
--	["Blizzard_VoidStorageUI"] = function() BlizzMove:SetMoveHandle(VoidStorageFrame) end,
	["Blizzard_ItemAlterationUI"] = function() BlizzMove:SetMoveHandle(TransmogrifyFrame) end,
	["Blizzard_TalentUI"] = function() 	BlizzMove:SetMoveHandle(PlayerTalentFrame) end,
	["Blizzard_Calendar"] = function() BlizzMove:SetMoveHandle(CalendarFrame) end,
	["Blizzard_TrainerUI"] = function() BlizzMove:SetMoveHandle(ClassTrainerFrame) end,
	["Blizzard_BindingUI"] = function() BlizzMove:SetMoveHandle(KeyBindingFrame) end,
	["Blizzard_AuctionUI"] = function() BlizzMove:SetMoveHandle(AuctionFrame) end,
	["Blizzard_ArchaeologyUI"] = function() BlizzMove:SetMoveHandle(ArchaeologyFrame) end,
	["Blizzard_LookingForGuildUI"] = function() BlizzMove:SetMoveHandle(LookingForGuildFrame) end,
	["Blizzard_AchievementUI"] = function() BlizzMove:SetMoveHandle(AchievementFrame, AchievementFrameHeader) end,
	["Blizzard_Communities"] = function() BlizzMove:SetMoveHandle(CommunitiesFrame) end,
	["Blizzard_ReforgingUI"] = function() BlizzMove:SetMoveHandle(ReforgingFrame, ReforgingFrameInvisibleButton) end,
	["Blizzard_EncounterJournal"] = function() BlizzMove:SetMoveHandle(EncounterJournal, BlizzMove:CreateOwnHandleFrame(EncounterJournal, 775, 20, 0, 0, "EncounterJournal")) end,
--	["Blizzard_GarrisonUI"] = function() BlizzMove:SetMoveHandle(GarrisonMissionFrame); BlizzMove:SetMoveHandle(GarrisonCapacitiveDisplayFrame); BlizzMove:SetMoveHandle(GarrisonLandingPage) end,
--	["Blizzard_OrderHallUI"] = function() BlizzMove:SetMoveHandle(OrderHallMissionFrame) end,
--	["Blizzard_ArtifactUI"] = function() BlizzMove:SetMoveHandle(ArtifactRelicForgeFrame) end,
--	["Blizzard_AzeriteUI"] = function() BlizzMove:SetMoveHandle(AzeriteEmpoweredItemUI) end,
}

function movableFramesLoD:EuiScript() --by eui.cc
	for _, frame in pairs(movableFrames) do
			BlizzMove:SetMoveHandle(frame)
	end

	for frame, handles in pairs(movableFramesWithhandle) do
			for index, handle in pairs(handles) do
					if _G[frame] then BlizzMove:SetMoveHandle(_G[frame],handle) end
			end
	end
end

local function ADDON_LOADED(self, event, addonName)
	--[===[@debug@
 	--print(addonName)
  	--@end-debug@]===]
	if movableFramesLoD[addonName] then movableFramesLoD[addonName]() end
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", ADDON_LOADED)
frame:RegisterEvent("ADDON_LOADED")