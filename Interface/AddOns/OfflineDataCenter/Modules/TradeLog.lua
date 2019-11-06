local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local ODC = LibStub("AceAddon-3.0"):GetAddon("OfflineDataCenter")
local ODC_SMF = ODC:GetModule("ScrollingMessageFrame")
if not ODC_SMF then return end
local Module = ODC:NewModule("OfflineTradeLog", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("OfflineDataCenter")
local alreadySend = false

Module.description = L["Offline Trade Log"]
Module.type = "tab"
Module.name = "OfflineTradeLog"
Module.tabs = {
	tradelog = {
		Textures = "Interface\\AddOns\\OfflineDataCenter\\Textures\\Ability_Racial_TimeIsMoney",
		Tooltip = L['Offline Trade Log'],
		CallTabFunc = function()
			ODC_SMF:CreateOrShowSubFrame("tradelog", Module.OutputFunc)
		end,
		CharChangedFunc = function()
			ODC_SMF:CreateOrShowSubFrame("tradelog", Module.OutputFunc)
		end,
		Settings = {
			type = "group",
			name = L['Offline Trade Log'],
			order = 1,
			args = {
				group1 = { 
					type = "group", order = 1, 
					name = L['Offline Trade Log'],guiInline = true, 
					args = { 
						enable = {
							type = "toggle",
							name = ENABLE,
							order = 1,
							set = function(info,val)
								if val then
									ODC:EnableTab("tradelog")
								else
									ODC:DisableTab("tradelog")
								end
							end,
							get = function(info)
								return ODC_Config.toggle.tradelog
							end,
						}, 
					} 
				},
				group2 = { 
					type = "group", order = 2, 
					name = " ",guiInline = true, 
					disabled = function() return ODC_Config.toggle.tradelog == false end,
					args = { 
						autowhisper = {
							type = "select",
							name = L["Auto report"],
							order = 1,
							values = {
								whisper = WHISPER,
								say = SAY,
								yell = YELL,
								party = PARTY,
								raid = RAID,
								none = NONE,
							},
							set = function(info,val)
								if ODC_Config.toggle.tradelog == false then return end
								ODC_Config.Options.tradelog.autowhisper = val
							end,
							get = function(info)
								return ODC_Config.Options.tradelog.autowhisper
							end,
						},
						maxmsg = {
							type = "range",
							name = L["Maximum messages"],
							order = 2,
							min = 30, max = 500, step = 1,
							set = function(info,val)
								ODC_Config.Options.tradelog.maxmsg = val
							end,
							get = function(info)
								return ODC_Config.Options.tradelog.maxmsg
							end,
						},
					} 
				},
			},
		},
		DefaultConfig = {
			autowhisper = "whisper",
			maxmsg = 50,		
		},
	},
}


local playername, selectChar, selectTab = ODC.playername, ODC.selectChar, ODC.selectTab
local currentTrade

local function CreateTrade()
	local t = {[1]={},[2]={}}
	t.playerMoney = 0
	t.targetMoney = 0
	t.events = {}
	return t
end

local function GetTrade()
	if not currentTrade then currentTrade = CreateTrade() end
	return currentTrade
end

if(GetLocale() == "zhCN") then
	CANCEL_REASON_TEXT = {
		self = "我取消了交易",
		other = "对方取消了交易",
		toofar = "双方距离过远",
		selfrunaway = "我超出了距离",
		selfhideui = "我隐藏了界面,交易窗口关闭",
		unknown = "未知原因",
	}
	TRADE_LOG_SUCCESS_NO_EXCHANGE = "与[%t]交易成功, 但是没有做任何交换。";
	TRADE_LOG_SUCCESS = "与[%t]交易成功。";
	TRADE_LOG_DETAIL = "详情";
	TRADE_LOG_CANCELLED = "与[%t]交易取消: %r。";
	TRADE_LOG_FAILED = "与[%t]交易失败: %r。";
	TRADE_LOG_FAILED_NO_TARGET = "交易失败: %r。";
	TRADE_LOG_HANDOUT = "交出";
	TRADE_LOG_RECEIVE = "收到";
	TRADE_LOG_ENCHANT = "附魔";
	TRADE_LOG_ITEM_NUMBER = "%d件物品";
elseif(GetLocale() == "zhTW") then
	CANCEL_REASON_TEXT = {
		self = "我取消了交易",
		other = "對方取消了交易",
		toofar = "雙方距離過遠",
		selfrunaway = "我超出了距離",
		selfhideui = "我隱藏了界面,交易窗口關閉",
		unknown = "未知原因",
	}
	TRADE_LOG_SUCCESS_NO_EXCHANGE = "與[%t]交易成功, 但是沒有做任何交換。";
	TRADE_LOG_SUCCESS = "與[%t]交易成功。";
	TRADE_LOG_DETAIL = "詳情";
	TRADE_LOG_CANCELLED = "與[%t]交易取消: %r。";
	TRADE_LOG_FAILED = "與[%t]交易失敗: %r。";
	TRADE_LOG_FAILED_NO_TARGET = "交易失敗: %r。";
	TRADE_LOG_HANDOUT = "交出";
	TRADE_LOG_RECEIVE = "收到";
	TRADE_LOG_ENCHANT = "附魔";
	TRADE_LOG_ITEM_NUMBER = "%d件物品";
else
	CANCEL_REASON_TEXT = {
		self = "I cancelled it",
		other = "target cancelled it",
		toofar = "we are too faraway",
		selfrunaway = "I moved away",
		selfhideui = "I hid ui",
		unknown = "unknown reason",
	}
	TRADE_LOG_SUCCESS_NO_EXCHANGE = "Trade with [%t] was COMPLETED, but no exchange made.";
	TRADE_LOG_SUCCESS = "Trade with [%t] was COMPLETED.";
	TRADE_LOG_DETAIL = "Detail";
	TRADE_LOG_CANCELLED = "Trade with [%t] was CANCELLED: %r.";
	TRADE_LOG_FAILED = "Trade with [%t] was FAILED: %r.";
	TRADE_LOG_FAILED_NO_TARGET = "Trade FAILED: %r.";
	TRADE_LOG_HANDOUT = "lost";
	TRADE_LOG_RECEIVE = "got";
	TRADE_LOG_ENCHANT = "enchant";
	TRADE_LOG_ITEM_NUMBER = "%d items";
end

local function CheckDBLoad()
	while table.getn(ODC_DB[playername]["tradelog"]) >= ODC_Config.Options.tradelog.maxmsg do
		table.remove(ODC_DB[playername]["tradelog"], 1)
	end
end

local function AddTradeLog(trade)
	CheckDBLoad()
	-- if trade.events then
		-- for k, v in pairs(trade.events) do
			-- trade.events[k] = nil
		-- end
		-- trade.events = nil
	-- end
	trade.events = nil
	tinsert(ODC_DB[playername]["tradelog"], trade)
end

local function GetClassColor(name, class)
	if class and RAID_CLASS_COLORS[class] then
		return "|c"..RAID_CLASS_COLORS[class].colorStr..name.."|r"
	else
		return name;
	end
end

local function TradeLog_GetTradeList(money, items, enchant, moneyText, countOnly)
	local list = {}
	if(money > 0) then
		table.insert( list, moneyText(money) );
	end
	local count = 0
	if items[1] then
		for i, v in ipairs(items[2]) do
			count = count + v
			local tmp = items[1][i];
			if(items[2][i]>1) then
				tmp = tmp.."x"..items[2][i];
			end
			if(not countOnly) then table.insert(list, tmp) end
		end
	end

	if(countOnly and count>0) then
		local text = string.gsub(TRADE_LOG_ITEM_NUMBER, "%%d", count)
		table.insert(list, text)
	end

	if(enchant) then
		table.insert(list, countOnly and TRADE_LOG_ENCHANT or enchant)
	end
	return list;
end

local function TradeLog_Output(trade, func, plain, isdate)
	local whoLink = plain and trade.target or "|Hplayer:"..trade.target.."|h"..GetClassColor((trade.level and trade.level..":" or "")..trade.target, trade.class).."|h";
	local msg = ""
	if isdate then
		msg = date("[%H:%M:%S]", trade[3])
	end
	if(trade.result == "complete") then
		local playerList = TradeLog_GetTradeList(trade.playerMoney, trade[1], trade[1].enchantment, GetCoinText)
		local targetList = TradeLog_GetTradeList(trade.targetMoney, trade[2], trade[2].enchantment, GetCoinText)

		if(#playerList==0 and #targetList==0) then
			func(msg..string.gsub(TRADE_LOG_SUCCESS_NO_EXCHANGE, "%%t", whoLink), 1, 1, 0);
		else
			if(plain) then
				local breaked = false
				local first = true
				msg = msg..string.gsub(TRADE_LOG_SUCCESS, "%%t", whoLink);
				if(#playerList > 0) then
					msg = msg.."("..TRADE_LOG_HANDOUT..")"
					for _, v in pairs(playerList) do
						if(strlen(msg..v) > 255) then
							breaked = true;
							func(msg)
							msg = msg.."("..TRADE_LOG_HANDOUT..")"..v
							first = false
						else
							if(not first) then msg = msg.."," end
							first = false
							msg = msg..v
						end
					end
					first = true
				end

				if(#targetList > 0) then
					if(breaked) then 
						func(msg)
						msg = msg .."("..TRADE_LOG_RECEIVE..")"
					else
						msg = msg.." ("..TRADE_LOG_RECEIVE..")"
					end
					for _, v in pairs(targetList) do
						if(strlen(msg..v) > 255) then
							func(msg)
							msg = msg.."("..TRADE_LOG_RECEIVE..")"..v
							first = false
						else
							if(not first) then msg = msg.."," end
							first = false
							msg = msg..v
						end
					end
				end

				func(msg)

			else
				func(msg .. string.gsub(TRADE_LOG_SUCCESS, "%%t", whoLink)..TRADE_LOG_DETAIL..":", 1, 1, 0);
				if(#playerList>0) then
					func("("..TRADE_LOG_HANDOUT..") "..table.concat(playerList, ","), 1, 0.8, 0.8);
				end
				if(#targetList>0) then
					func("("..TRADE_LOG_RECEIVE..") "..table.concat(targetList, ","), 0.8, 1, 0.8);
				end
			end
		end

	elseif(trade.result == "cancelled") then
		msg = msg..string.gsub(TRADE_LOG_CANCELLED, "%%t", whoLink);
		msg = string.gsub(msg, "%%r", CANCEL_REASON_TEXT[trade.reason]);
		func(msg, 1, 0.5, 0.5);
	else
		msg = msg..string.gsub(TRADE_LOG_FAILED, "%%t", whoLink);
		if trade.reason and type(trade.reason) == "string" then --by eui.cc
			msg = string.gsub(msg, "%%r", trade.reason);
		end
		func(msg, 1, 0.1, 0.1);
	end
end

local function InsertText(f, firstPage, trade, date)
	if date then
		f:AddMessage(trade);
	else
		TradeLog_Output(trade, function(m,r,g,b) f:AddMessage(m,r,g,b) end, false, ODC_SMF.TIMESTAMP)
	end
	
	if f:GetNumMessages() == f:GetNumLinesDisplayed() then
		firstPage = f:GetNumMessages()
	end

	return firstPage
end

local function searchKeyword(trade)
	local playerList = TradeLog_GetTradeList(trade.playerMoney, trade[1], trade[1].enchantment, GetCoinText)
	local targetList = TradeLog_GetTradeList(trade.targetMoney, trade[2], trade[2].enchantment, GetCoinText)
	return trade.target..table.concat(targetList, ",")..table.concat(playerList, ",")
end

Module.OutputFunc = function(f, thisDay, firstPage, searchText)
	for i, t in ipairs(ODC_DB[ODC.selectChar]["tradelog"]) do
		if not thisDay or date("%x", t[3]) ~= thisDay then
			thisDay = date("%x", t[3])
			if not searchText then
				firstPage = InsertText(f, firstPage, date("=== %Y-%m-%d ===", t[3]), true)
			end
		end
		if not searchText or string.find(searchKeyword(t), searchText) then
			firstPage = InsertText(f, firstPage, t)
		end
	end
	return firstPage
end

local OutputChannel = {
	whisper = "WHISPER",
	say = "SAY",
	yell = "YELL",
	party = "PARTY",
	raid = "RAID",
}

local function TradeLog_OutputLog()
	if(not GetTrade().target) then
		--never show the trade window
		if( GetTrade().reason =="selfhideui" ) then
			DEFAULT_CHAT_FRAME:AddMessage(string.gsub(TRADE_LOG_FAILED_NO_TARGET, "%%r", CANCEL_REASON_TEXT[GetTrade().reason]));
		end
		return;
	end
	
	AddTradeLog(GetTrade())

	if ODC.Frame:IsVisible() and ODC.selectChar == playername and ODC.selectTab == "tradelog" then
		ODC_SMF:CreateOrShowSubFrame("tradelog", Module.OutputFunc)
	end

	if(ODC_Config.Options.tradelog.autowhisper ~= "none") then
		TradeLog_Output(GetTrade(), function(m)
			if not alreadySend then
				SendChatMessage(m,OutputChannel[ODC_Config.Options.tradelog.autowhisper],nil,GetTrade().target)
				alreadySend = true
			end
		end, true);
	else
		TradeLog_Output(GetTrade(), function(m, r, g, b) DEFAULT_CHAT_FRAME:AddMessage(m, r, g, b) end);
	end
end

local function TradeLog_AnalyseCancelReason()
	local reason = "unknown"; --should be unknown only when no trade window opened.
	local e = GetTrade().events;
	local n = getn(e);
	if(n>=3 and e[n]=="TRADE_REQUEST_CANCEL" and e[n-1]=="TRADE_CLOSED" and e[n-2]=="TRADE_CLOSED") then
		reason = "self";
	elseif(n>=3 and e[n]=="TRADE_REQUEST_CANCEL" and e[n-1]=="TRADE_CLOSED" and e[n-2]=="TRADE_SHOW") then
		reason = "selfrunaway";
	elseif(n>=3 and e[n]=="TRADE_CLOSED" and e[n-1]=="TRADE_CLOSED" and e[n-2]=="TRADE_REQUEST_CANCEL") then
		if(GetTrade().toofar == "yes") then
			reason = "toofar";
		elseif(GetTrade().toofar == "no") then
			reason = "other";
		else
			reason = "wrong!!"; --this should not happen, if you see, contact me :p
		end
	elseif(n>=3 and e[n]=="TRADE_REQUEST_CANCEL" and e[n-1]=="TRADE_SHOW" and e[n-2]=="TRADE_CLOSED") then
		reason = "selfhideui";
	end

	GetTrade().events = nil; --reason analyzed, abandon it to release that tiny memory
	return reason;
end

local function TradeLog_LogTradeAndReset()
	GetTrade()[3] = time()
	GetTrade().location = GetRealZoneText();
	if( GetTrade().result == "cancelled" ) then
		GetTrade().reason = TradeLog_AnalyseCancelReason();
	elseif( GetTrade().result == "error" ) then
		GetTrade().reason = GetTrade().reason;
	end
	TradeLog_OutputLog();
	alreadySend = false
	currentTrade = nil;
end

--[[
ODC_DB[charName] structure:
					TradeID		content			slotID
["tradelog"]= {		[1]			[1]"player"	{	[1]	itemLink	{	[n]
					[2]			[2]"who"	{	[2]	count		{	[n]
					[n]			[3]"tick"		
								.playerMoney
								.targetMoney
								.failReason?	.enchant?
								.target
								.location
								/t = time([timeDesc]) tick second
Theoretically TradeID is sort by time.
]]
local function CheckTradeItems()
	GetTrade()[1] = {{},{}}
	GetTrade()[2] = {{},{}}
	for i = 1, MAX_TRADABLE_ITEMS do
		local _, _, numItems = GetTradePlayerItemInfo(i)
		local itemLink = GetTradePlayerItemLink(i)
		if itemLink then
			tinsert(GetTrade()[1][1] ,itemLink)
			tinsert(GetTrade()[1][2] ,numItems)
		end
	end
	local _, _, _, _, enchantment = GetTradePlayerItemInfo(TRADE_ENCHANT_SLOT)
	if enchantment then
		GetTrade()[2].enchantment = enchantment
	-- else
		-- GetTrade()[2].enchantment = nil
	end
	-- GetTrade()[2] = {{},{}}
	for i = 1, MAX_TRADABLE_ITEMS do
		local _, _, numItems = GetTradeTargetItemInfo(i)
		local itemLink = GetTradeTargetItemLink(i)
		if itemLink then
			tinsert(GetTrade()[2][1] ,itemLink)
			tinsert(GetTrade()[2][2] ,numItems)
		end
	end
	local _, _, _, _, _, enchantment = GetTradeTargetItemInfo(TRADE_ENCHANT_SLOT)
	if enchantment then
		GetTrade()[1].enchantment = enchantment
	-- else
		-- GetTrade()[1].enchantment = nil
	end
end

function Module:TRADE_ACCEPT_UPDATE(event, playerState, targetState)
	CheckTradeItems()
	GetTrade().playerMoney = GetPlayerTradeMoney()
	GetTrade().targetMoney = GetTargetTradeMoney()
end

function Module:TRADE_PLAYER_ITEM_CHANGED()
	CheckTradeItems(true)
end

function Module:TRADE_TARGET_ITEM_CHANGED()
	CheckTradeItems()
end

function Module:TRADE_MONEY_CHANGED()
	GetTrade().playerMoney = GetPlayerTradeMoney()
	GetTrade().targetMoney = GetTargetTradeMoney()
end

function Module:UI_ERROR_MESSAGE(event, arg1, arg2)
	if(arg2==ERR_TRADE_BAG_FULL or arg2==ERR_TRADE_MAX_COUNT_EXCEEDED or arg2==ERR_TRADE_TARGET_BAG_FULL or arg2==ERR_TRADE_TARGET_MAX_COUNT_EXCEEDED) then
		GetTrade().result = "error";
		GetTrade().reason=arg2;
		TradeLog_LogTradeAndReset();
	elseif (arg2==ERR_TRADE_TARGET_DEAD or arg2==ERR_TRADE_TOO_FAR) then
		DEFAULT_CHAT_FRAME:AddMessage(arg2, 1, 0.2, 0.2);
	end
end

function Module:UI_INFO_MESSAGE(event, arg1, arg2)
	if arg2==ERR_TRADE_CANCELLED then
		GetTrade().result = "cancelled"
	elseif arg2==ERR_TRADE_COMPLETE then
		GetTrade().result = "complete"
	end

	TradeLog_LogTradeAndReset();
end

function Module:TRADE_REQUEST_CANCEL(event)
	table.insert(GetTrade().events, event);
	if(UnitName("NPC")) then
		GetTrade().toofar = CheckInteractDistance("npc", 2) and "no" or "yes"
	end
end

function Module:TRADE_SHOW(event)
	local _, class = UnitClass("NPC")
	-- local name = GetUnitName("NPC", true):gsub(" %- ", "-")
	-- name = GetClassColor(name, class)
	-- UnitLevel("NPC")..":"..
	GetTrade().target = GetUnitName("NPC", true):gsub(" %- ", "-")
	GetTrade().class = class
	GetTrade().level = UnitLevel("NPC")
	table.insert(GetTrade().events, event);
end

function Module:TRADE_CLOSED(event)
	table.insert(GetTrade().events, event);
end

Module.selectTabCallbackFunc = function(selectedTab)
	selectTab = selectedTab
end

Module.selectCharCallbackFunc = function(selectedChar)
	selectChar = selectedChar
end

function Module:OnInitialize()
	if ODC_Config.toggle.tradelog == nil then ODC_Config.toggle.tradelog = true end
	ODC:SetDefaultConfig(self.tabs)
	ODC:AddAvaliableTab("tradelog", self)
end

function Module:OnEnable()
	if ODC_Config.toggle.tradelog then
		if not ODC_DB[playername]["tradelog"] then
			ODC_DB[playername]["tradelog"] = {}
		end
		ODC:AddTab("tradelog", self.tabs["tradelog"])
		ODC:AddModule(self)
		self:RegisterEvent("TRADE_ACCEPT_UPDATE")
		-- self:RegisterEvent("TRADE_MONEY_CHANGED")
		self:RegisterEvent("TRADE_SHOW")
		self:RegisterEvent("UI_ERROR_MESSAGE")
		self:RegisterEvent("UI_INFO_MESSAGE")
		self:RegisterEvent("TRADE_REQUEST_CANCEL")
		self:RegisterEvent("TRADE_CLOSED")
		
	end
end

function Module:OnDisable()
	if not ODC_Config.toggle.tradelog then
		ODC:RemoveTab("tradelog")
		ODC:RemoveModule(self)
		self:UnregisterEvent("TRADE_ACCEPT_UPDATE")
		-- self:UnregisterEvent("TRADE_MONEY_CHANGED")
		self:UnregisterEvent("TRADE_SHOW")
		self:UnregisterEvent("UI_ERROR_MESSAGE")
		self:UnregisterEvent("UI_INFO_MESSAGE")
		self:UnregisterEvent("TRADE_REQUEST_CANCEL")
		self:UnregisterEvent("TRADE_CLOSED")
	end
end