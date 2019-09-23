local E, _, DF = unpack(ElvUI)
if not E.db.euiscript.dispel then return; end

local CreateFrame = CreateFrame
local GetNumMacros = GetNumMacros
local GetMacroInfo = GetMacroInfo
local DeleteMacro = DeleteMacro
local UnitClass = UnitClass
local IsSpellKnown = IsSpellKnown
local GetSpellInfo = GetSpellInfo
local CreateMacro = CreateMacro
local SetBinding = SetBinding
local SetBindingMacro = SetBindingMacro
local SaveBindings = SaveBindings

local L = {}

L.CLICKSET_MOUSE_ERR = "你的宏已经满了，请留两个空位后才能启用鼠标滚轮解Debuff功能！"
L.CLICKSET_TIP1 = "鼠标滚轮上下被绑定到鼠标指向解DEBUFF上"
L.CLICKSET_TIP2 = "原视野放大缩小变更为Alt+鼠标滚轮"
L.CLICKSET_TIP3 = "不需此功能请至点击施法设置中关闭"

--创建两个用于解DBUFF的宏,并绑定到鼠标滚轮上
local Debuffmw = CreateFrame("Frame")
Debuffmw:RegisterEvent("PLAYER_ENTERING_WORLD")
Debuffmw:SetScript("OnEvent", function(self, event)
	Debuffmw:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not E.db.euiscript.dispel then return; end

	if GetMacroInfo("EuiDebuffa") then DeleteMacro("EuiDebuffa") end
	if GetMacroInfo("EuiDebuffb") then DeleteMacro("EuiDebuffb") end	

	if select(2, GetNumMacros()) > 34 then
		DEFAULT_CHAT_FRAME:AddMessage(L.CLICKSET_MOUSE_ERR,1,0,0)
		return;
	end

	local _, class = UnitClass("player")
	local CanDispel = {
		PRIEST = { 527, 528, },
		SHAMAN = { 370, 51886, },
		PALADIN = { 4987, },
		MAGE = {},
		DRUID = { 2782, 88423},
		MONK = { 115450, },
		ROGUE = {},
		HUNTER = {},
		WARRIOR = {},
		WARLOCK = {},
		DEATHKNIGHT = {},
		DEMONHUNTER = {},
	}

	local macroa, macrob
	local indexa, indexb
	if CanDispel[class][1] and IsSpellKnown(CanDispel[class][1]) then
		macroa = GetSpellInfo(CanDispel[class][1]) or ""
		index_a = CreateMacro("EuiDebuffa", 1, "/cast [@mouseover] "..macroa..";", 1)
		local a=SetBinding("ALT-MOUSEWHEELUP", "CAMERAZOOMIN")
		local b=SetBinding("ALT-MOUSEWHEELDOWN", "CAMERAZOOMOUT")
		if a and b then
			SaveBindings(2)
			DEFAULT_CHAT_FRAME:AddMessage(L.CLICKSET_TIP1,1,0,0)
			DEFAULT_CHAT_FRAME:AddMessage(L.CLICKSET_TIP2,1,0,0)
			DEFAULT_CHAT_FRAME:AddMessage(L.CLICKSET_TIP3,1,0,0)
		end
	end
	if CanDispel[class][2] and IsSpellKnown(CanDispel[class][2]) then
		macrob = GetSpellInfo(CanDispel[class][2]) or ""
		index_b = CreateMacro("EuiDebuffb", 1, "/cast [@mouseover] "..macrob..";", 1)
	end
	if index_a then SetBindingMacro("MOUSEWHEELUP", index_a) end
	if index_b then SetBindingMacro("MOUSEWHEELDOWN", index_b) end
	if index_a and not index_b then SetBindingMacro("MOUSEWHEELDOWN", index_a) end
	if index_a or index_b then SaveBindings(2) end
end)