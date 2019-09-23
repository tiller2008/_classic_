--------------------------------------------------------------------------
-- auto-dez (priority) or auto-greed green item at max level
-- yes... you are right... i'm totally lazy
-- auto-need Chaos Orbs
--------------------------------------------------------------------------

local E = unpack(ElvUI) -- Import Functions/Constants, Config, Locales
local GetNumGroupMembers = GetNumGroupMembers
local GetNumSubgroupMembers = GetNumSubgroupMembers
local STATICPOPUP_NUMDIALOGS = STATICPOPUP_NUMDIALOGS
local StaticPopup_OnClick = StaticPopup_OnClick

----------------------------------------------------------------------------------------
--	Disenchant confirmation(tekKrush by Tekkub)
----------------------------------------------------------------------------------------
if E.db["euiscript"].auto_confirm_de == true then
	local acd = CreateFrame("Frame")
	acd:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
	acd:RegisterEvent("CONFIRM_LOOT_ROLL")
	acd:RegisterEvent("LOOT_BIND_CONFIRM")
	acd:SetScript("OnEvent", function(self, event, id)
		if GetNumGroupMembers() == 0 and GetNumSubgroupMembers() == 0 then
			local elapsed = 0
			self:SetScript("OnUpdate", function(self, elap)
				elapsed = elapsed + elap
				if elapsed < 0.2 then
					StaticPopup_Hide("LOOT_BIND")
					return
				end
				elapsed = 0
				ConfirmLootSlot(id)
			end)
		else
			for i = 1, STATICPOPUP_NUMDIALOGS do
				local frame = _G["StaticPopup"..i]
				if (frame.which == "CONFIRM_LOOT_ROLL" or frame.which == "LOOT_BIND" or frame.which == "LOOT_BIND_CONFIRM") and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
			end
		end
	end)
end