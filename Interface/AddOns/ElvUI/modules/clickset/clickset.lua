-- Auther: eui.cc
local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local CLICKSET = E:NewModule('ClickSet', 'AceEvent-3.0')
local UF = E:GetModule('UnitFrames');

local pairs, select = pairs, select
local GetSpellInfo = GetSpellInfo
local InCombatLockdown = InCombatLockdown

function CLICKSET:Initialize()

end

function CLICKSET:LoadClassOpt()
--	E.ClickSets = CLICKSET
	local C = E.Options.args.clickset.args
	if E.db["clickset"].enable == true then
		--Custom spell list write to config dropmenu
		for k, v in pairs(E.db["clickset"].clicksetlist) do
			if GetSpellInfo(k) then
				C.CustomClickSetSpell.args.clicksetlist.values[k] = GetSpellInfo(k) .. " (" .. k .. ")"
				if v == true then
					for key, value in pairs(C.spec1.args) do
						for key2, value2 in pairs(C.spec1.args[key].args) do
							C.spec1.args[key].args[key2].values[GetSpellInfo(k)] = GetSpellInfo(k)
						end
					end			
				end
			end
		end
		
		--default spell list write config dropmenu
		for k,v in pairs(E.ClickSets_Sets[E.myclass]) do
			if GetSpellInfo(v) then
				for key, value in pairs(C.spec1.args) do
					for key2, value2 in pairs(C.spec1.args[key].args) do
						C.spec1.args[key].args[key2].values[GetSpellInfo(v)] = GetSpellInfo(v)
					end
				end
			end
		end
		for k,v in pairs(E.ClickSets_Sets3[E.myclass]) do
			if GetSpellInfo(v) then
				for key, value in pairs(C.spec1.args) do
					for key2, value2 in pairs(C.spec1.args[key].args) do
						C.spec1.args[key].args[key2].values[GetSpellInfo(v)] = GetSpellInfo(v)
					end
				end
			end
		end		
		
		-- player macro write config dropmenu
		for i = 121, 550 do
			if GetMacroInfo(i) then
				for key, value in pairs(C.spec1.args) do
					for key2, value2 in pairs(C.spec1.args[key].args) do
						C.spec1.args[key].args[key2].values["#*".. select(3, GetMacroInfo(i))] = "|cffC495DD#".. select(1, GetMacroInfo(i)).."|r"
					end
				end
			end
		end

		--写入菜单和目标两个功能项。
		for key, value in pairs(C.spec1.args) do
			for key2, value2 in pairs(C.spec1.args[key].args) do
				C.spec1.args[key].args[key2].values["menu"] = L["menu"]
				C.spec1.args[key].args[key2].values["target"] = L["target"]
			--	C.spec1.args[key].args[key2].values["focus"] = L["focus"]
			end
		end		
	end
end

function CLICKSET:updateClickset()
	local UF = E:GetModule('UnitFrames');
	if not E.private.unitframe.enable then return; end

	UF:CreateAndUpdateHeaderGroup('raid');
--	UF:CreateAndUpdateHeaderGroup('raid40');
	UF:CreateAndUpdateHeaderGroup('party')
end
--[[
CLICKSET:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", function() 
	if InCombatLockdown() then CLICKSET:RegisterEvent('PLAYER_REGEN_ENABLED'); return end
	CLICKSET:updateClickset();
end);

function CLICKSET:PLAYER_REGEN_ENABLED()
	CLICKSET:updateClickset();
	self:UnregisterEvent('PLAYER_REGEN_ENABLED');
end]]

E:RegisterModule(CLICKSET:GetName())