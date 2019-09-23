-------------------------------------
-- 右鍵菜單增強
-- Title: TinyUntitled
-- Notes: untitled
-- Author: M
-- Version: 8.0.0
-- 2018.09.05 修改，并添加EUI黑名单菜单 by eui.cc
-------------------------------------
local locale = GetLocale()


local UnitPopupButtonsExtra = {
    ["ARMORY"] = { enUS ="Armory",          zhCN = "英雄榜",   zhTW = "英雄榜" },
    ["SEND_WHO"] = { enUS ="Query Detail",  zhCN = "查询玩家", zhTW = "查詢玩家" },
    ["NAME_COPY"] = { enUS ="Get Name",     zhCN = "获取名字", zhTW = "獲取名字" },
    ["GUILD_ADD"] = { enUS ="Guild Invite", zhCN = "公会邀请", zhTW = "公會邀請" },
    ["FRIEND_ADD"] = { enUS ="Add Friend",  zhCN = "添加好友", zhTW = "添加好友" },
	["EUI_BLACK_NAME"] = { enUS ="Eui blackName",  zhCN = "EUI: 屏蔽发言", zhTW = "EUI: 遮罩發言" },
}

local CHAT_BLACKLIST_INTRO = ''
if locale == 'zhCN' then
	CHAT_BLACKLIST_INTRO = ' 已被加入EUI信息过滤黑名单!'
elseif locale == 'zhTW' then
	CHAT_BLACKLIST_INTRO = ' 已被加入EUI資訊過濾黑名單!'
else
	CHAT_BLACKLIST_INTRO = ' Has been added to the EUI information filtering blacklist!'
end

for k, v in pairs(UnitPopupButtonsExtra) do
    v.text = v[locale] or k
    UnitPopupButtons[k] = v
end

tinsert(UnitPopupMenus["FRIEND"], 1, "ARMORY")
tinsert(UnitPopupMenus["FRIEND"], 1, "NAME_COPY")
tinsert(UnitPopupMenus["FRIEND"], 1, "SEND_WHO")
tinsert(UnitPopupMenus["FRIEND"], 1, "FRIEND_ADD")
tinsert(UnitPopupMenus["FRIEND"], 1, "GUILD_ADD")
tinsert(UnitPopupMenus["FRIEND"], 1, "EUI_BLACK_NAME")

tinsert(UnitPopupMenus["CHAT_ROSTER"], 1, "NAME_COPY")
tinsert(UnitPopupMenus["CHAT_ROSTER"], 1, "SEND_WHO")
tinsert(UnitPopupMenus["CHAT_ROSTER"], 1, "FRIEND_ADD")
tinsert(UnitPopupMenus["CHAT_ROSTER"], 1, "INVITE")
tinsert(UnitPopupMenus["CHAT_ROSTER"], 1, "EUI_BLACK_NAME")

tinsert(UnitPopupMenus["GUILD"], 1, "ARMORY")
tinsert(UnitPopupMenus["GUILD"], 1, "NAME_COPY")
tinsert(UnitPopupMenus["GUILD"], 1, "FRIEND_ADD")

local function urlencode(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c)
            return format("%%%02X", string.byte(c))
        end)
    return string.gsub(s, " ", "+")
end

local function gethost()
    local host = "http://us.battle.net/wow/en/character/"
    if (locale == "zhTW") then
        host = "http://tw.battle.net/wow/zh/character/"
    elseif (locale == "zhCN") then
        host = "http://www.battlenet.com.cn/wow/zh/character/"
    end
    return host
end

local function popupClick(self, info)
    local editBox
    local name, server = UnitName(info.unit)
    if (info.value == "ARMORY") then
        local armory = gethost() .. urlencode(server or GetRealmName()) .. "/" .. urlencode(name) .. "/advanced"
        editBox = ChatEdit_ChooseBoxForSend()
        ChatEdit_ActivateChat(editBox)
        editBox:SetText(armory)
        editBox:HighlightText()
    elseif (info.value == "NAME_COPY") then
        editBox = ChatEdit_ChooseBoxForSend()
        local hasText = (editBox:GetText() ~= "")
        ChatEdit_ActivateChat(editBox)
		if not name:find('-') then
			name = name..'-'..server
		end
        editBox:Insert(name)
        if (not hasText) then editBox:HighlightText() end
    elseif (info.value == "EUI_BLACK_NAME") then
        if not ElvUI then 
			DEFAULT_CHAT_FRAME:AddMessage('Not find EUI!',1,1,0);
			return;
		end
		if not name:find('-') then
			name = name..'-'..server
		end
		ElvUI[1].global.InfoFilter.blackName[name] = true
		DEFAULT_CHAT_FRAME:AddMessage(name.. CHAT_BLACKLIST_INTRO,1,1,0);
		if IsAddOnLoaded('ElvUI_OptionsUI') then
			for k, v in pairs(ElvUI[1].global.InfoFilter.blackName) do
				ElvUI[1].Options.args.InfoFilter.args.blackName.args.List.values[k] = k
			end
		end
    end
end

hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)
    if (UIDROPDOWNMENU_MENU_LEVEL > 1) then return end
    if (unit and (unit == "target" or string.find(unit, "party"))) then
        local info
        if (UnitIsPlayer(unit)) then
            info = UIDropDownMenu_CreateInfo()
            info.text = UnitPopupButtonsExtra["ARMORY"].text
            info.arg1 = {value="ARMORY",unit=unit}
            info.func = popupClick
            info.notCheckable = true
            UIDropDownMenu_AddButton(info)
        end
        info = UIDropDownMenu_CreateInfo()
        info.text = UnitPopupButtonsExtra["NAME_COPY"].text
        info.arg1 = {value="NAME_COPY",unit=unit}
        info.func = popupClick
        info.notCheckable = true
        UIDropDownMenu_AddButton(info)
    end
	if unit and UnitIsPlayer(unit) then
		info = UIDropDownMenu_CreateInfo()
        info.text = UnitPopupButtonsExtra["EUI_BLACK_NAME"].text
        info.arg1 = {value="EUI_BLACK_NAME",unit=unit}
        info.func = popupClick
        info.notCheckable = true
        UIDropDownMenu_AddButton(info)
	end
end)

hooksecurefunc("UnitPopup_OnClick", function(self)
	local unit = UIDROPDOWNMENU_INIT_MENU.unit
	local name = UIDROPDOWNMENU_INIT_MENU.name
	local server = UIDROPDOWNMENU_INIT_MENU.server
	local fullname = name
    local editBox
	if ( server and ((not unit and GetNormalizedRealmName() ~= server) or (unit and UnitRealmRelationship(unit) ~= LE_REALM_RELATION_SAME)) ) then
		fullname = name.."-"..server;
	end
    if (self.value == "ARMORY") then
        local armory = gethost() .. urlencode(server or GetRealmName()) .. "/" .. urlencode(name) .. "/advanced"
        editBox = ChatEdit_ChooseBoxForSend()
        ChatEdit_ActivateChat(editBox)
        editBox:SetText(armory)
        editBox:HighlightText()
    elseif (self.value == "NAME_COPY") then
        editBox = ChatEdit_ChooseBoxForSend()
        local hasText = (editBox:GetText() ~= "")
        ChatEdit_ActivateChat(editBox)
        editBox:Insert(fullname)
        if (not hasText) then editBox:HighlightText() end
    elseif (self.value == "FRIEND_ADD") then
        AddFriend(fullname)
    elseif (self.value == "SEND_WHO") then
        SendWho("n-"..name)
    elseif (self.value == "GUILD_ADD") then
        GuildInvite(fullname)
	elseif ( self.value == "INVITE" or self.value == "SUGGEST_INVITE" ) then
		InviteToGroup(fullname);
    elseif (self.value == "EUI_BLACK_NAME") then
        if not ElvUI then 
			DEFAULT_CHAT_FRAME:AddMessage('Not find EUI!',1,1,0);
			return;
		end
		if not fullname:find('-') then
			fullname = fullname..'-'..(server or GetRealmName())
		end
		ElvUI[1].global.InfoFilter.blackName[fullname] = true
		DEFAULT_CHAT_FRAME:AddMessage(fullname.. CHAT_BLACKLIST_INTRO,1,1,0);
		if IsAddOnLoaded('ElvUI_OptionsUI') then
			for k, v in pairs(ElvUI[1].global.InfoFilter.blackName) do
				ElvUI[1].Options.args.InfoFilter.args.blackName.args.List.values[k] = k
			end
		end
	end
end)
