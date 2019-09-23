local E, L, V, P, G = unpack(ElvUI); --Engine

----------------------------------------------------------------------------------------
--	Announce some spells
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", function(self, _, ...)
	if E.db.euiscript.spellSay ~= true then return end
	
	local _, event, _, sourceGUID, sourceName, _, _, _, destName, _, _, spellID = CombatLogGetCurrentEventInfo()
	
	local spells = G.AnnounceSpells
	local _, _, difficultyID = GetInstanceInfo()
	if difficultyID == 0 or event ~= "SPELL_CAST_SUCCESS" then return end

	if sourceName then sourceName = sourceName:gsub("%-[^|]+", "") end
	if destName then destName = destName:gsub("%-[^|]+", "") end
	if not sourceName then return end

	for i, spells in pairs(spells) do
		if spellID == spells then
			if destName == nil then
				SendChatMessage(string.format(L.ANNOUNCE_FP_USE, sourceName, GetSpellLink(spellID)), E:CheckChat())
			else
				SendChatMessage(string.format(L.ANNOUNCE_FP_USE, sourceName, GetSpellLink(spellID).." -> "..destName), E:CheckChat())
			end
		end
	end
end)