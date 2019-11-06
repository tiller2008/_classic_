local E = unpack(ElvUI)
local AutoTrackQuests = {}
AutoTrackQuests.Frame = CreateFrame("Frame")
AutoTrackQuests.Frame:SetScript("OnEvent", function(self, event, ...)
	if IsAddOnLoaded('ButterQuestTracker') then
		E.db.euiscript.autoTrackQuest = false
		return
	end
	if event == "QUEST_ACCEPTED" then
		local qindex = ...
		if E.db.euiscript.autoTrackQuest then
			AutoTrackQuests.WatchQuest(qindex)
		end
	elseif event == "QUEST_WATCH_UPDATE" then
		-- If someone's using this AddOn, they probably want things auto-tracked anyway, so don't bother checking
		--if GetCVar("autoQuestWatch") == "0" then return end -- Don't do the auto-watching on objective stuff if it's disabled in interface options
		if E.db.euiscript.autoTrackQuest then
			local qindex = ...
			AutoTrackQuests.WatchQuest(qindex)
		end
	end
end)
AutoTrackQuests.Frame:RegisterEvent("QUEST_ACCEPTED")
AutoTrackQuests.Frame:RegisterEvent("QUEST_WATCH_UPDATE")

function AutoTrackQuests.WatchQuest(qindex)
	local num_objectives = GetNumQuestLeaderBoards(qindex)
	
	if num_objectives == 0 then return end    -- Don't watch an untrackable quest (no objectives)
	if IsQuestWatched(qindex) then return end -- Don't watch an already-watched quest
	
	-- If we're tracking 5 or more quests, keep untracking the oldest ones until we're at 4 so we can track the new one
	while GetNumQuestWatches() >= 5 do
		RemoveQuestWatch(GetQuestIndexForWatch(1))
		QuestWatch_Update()
	end
	
	AddQuestWatch(qindex)
end