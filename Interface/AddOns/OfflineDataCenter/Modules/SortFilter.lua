local ODC = LibStub("AceAddon-3.0"):GetAddon("OfflineDataCenter")
local Module = ODC:NewModule("SortFilter", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("OfflineDataCenter")
--Module.description =
Module.type = "subFrame"
Module.name = "SortFilter"

local len, sub, find, format, match = string.len, string.sub, string.find, string.format, string.match
local playername, selectChar, selectTab = ODC.playername, ODC.selectChar, ODC.selectTab
local G_DB, slotDB, subIdxTb, sumQuality
local selectSortChanged, isStacked
local codMoney, codMailIndex, codAttachmentIndex
local FRAMENAME = "ODCFrameSortFilterSubFrame"
local SameItem_dbs = {"bag", "bank", "reagent", "mail", "inventory", "voidstorage"}
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink

--ODC.config_const
local Config = {
	daysLeftYellow = 7,
	daysLeftRed = 3,
	buttonSize = 36,
	buttonSpacing = 4,
	numItemsPerRow = 8,
	numItemsRows = 10,
	itemsSlotDisplay = 80,
}

local function CalcLeftDay(player, mailIndex)
	return floor(difftime(floor(ODC_DB[player]["mail"][mailIndex].daysLeft * 86400) + ODC_DB[player]["mail"].checkMailTick,time()) / 86400)
end

local function GetItemID(itemLink)
	return GetItemInfoFromHyperlink(itemLink) or 0
end

local function InsertToIndexTable(keyword, x, y, method)
	if not keyword or not x then return end
	if not subIdxTb then subIdxTb = {} end
	if not subIdxTb[keyword] then
		subIdxTb[keyword] = {}
	end
	
	if method == "no-sorting" then
		local itemIdxTb = {[1]={x = x,y = y}}
		tinsert(subIdxTb[keyword], itemIdxTb)
		return
	elseif method == "money" then
		if keyword then
			tinsert(subIdxTb[keyword], x)
		end
		return
	end
	
	if not y then return end
	local itemID = GetItemID(G_DB[x][y])
	local itemIdxTb = {x = x, y = y}
	if not itemID then return end
	
	if not subIdxTb[keyword][itemID] then
		subIdxTb[keyword][itemID] = {}
		tinsert(subIdxTb[keyword][itemID], itemIdxTb)
		return
	end
	
	for i, item in ipairs(subIdxTb[keyword][itemID]) do
		local count1 = ODC:GetItemCount(G_DB[item.x][item.y])
		local count = ODC:GetItemCount(G_DB[x][y])
		if count1 and count and (count1 > count) then --can insert before this count
			tinsert(subIdxTb[keyword][itemID], i, itemIdxTb)
			return
		elseif i == getn(subIdxTb[keyword][itemID]) then --insert to end of this itemID
			tinsert(subIdxTb[keyword][itemID], itemIdxTb)
			return
		end
	end
end

--[[ subIdxTb structure
			subType			itemsID			sameID items	slot?
							(sort by ID)	(sort by count)
subIdxTb{	[keyword1]	{ 	[itemID1]	{	[1]		=		{ [x, y](.itemCount)
			[keyword2]		[itemID2]		[2]
			...				...				...
			[keywordn]		[itemIDn]		[n]
			/.method	/.keyword		/.itemID
						/.itemslotCount
]]
--insert and return position (c)!
--先排序，再看过滤器，最后看堆叠
--排序已经完成，过滤器就是从排序当中得到子表。
--堆叠就是把同itemID的当做一个表插入到sortDB
--build filter menu base on subType!

local SelectSortMethod = {
	["No sorting"] = function(method, x, y)
		local keyword = L["No sorting"]
		InsertToIndexTable(keyword, x, y, method)	
	end,
	["AH"] = function(method, x, y)
		local itemID = GetItemID(G_DB[x][y])
		if itemID then
			local _, _, itemRarity, _, _, itemType, _, _, _, _, _ = GetItemInfo(itemID)
			InsertToIndexTable(itemType, x, y, method)
		end
	end,
	["quality"] = function(method, x, y)
		local itemID = GetItemID(G_DB[x][y])
		if itemID then
			local _, _, quality, _, _, _, _, _, _, _ = GetItemInfo(itemID)
			InsertToIndexTable(quality, x, y, method)
		end
	end,
	["sender"] = function(method, x, y)
		local sender = G_DB[x].sender
		InsertToIndexTable(sender, x, y)--?
	end,--mailbox only
	["left day"] = function(method, x, y)
		local leftday = CalcLeftDay(ODC.selectChar, x)
		InsertToIndexTable(leftday, x, y, method)
	end,--mailbox only
	["C.O.D."] = function(method, x, y)
		local isCOD
		if G_DB[x].CODAmount then
			isCOD = L["is C.O.D."]
		else
			isCOD = L["not C.O.D."]
		end
		InsertToIndexTable(isCOD, x, y)--?
	end,--mailbox only
	["money"] = function(method, x)
		local hasMoney
		if G_DB[x].money then
			hasMoney = L["has money"]
			InsertToIndexTable(hasMoney, x, nil, method)
		end
	end,--mailbox only
}

local function Filter_OnClick(self)
	UIDropDownMenu_SetSelectedValue(ODCFrameSortFilterSubFrameFilterDropDown, self.value);
	Module:Update("filter")
end
---finished
local function FilterMenuInitialize(self, level)
	if not subIdxTb then
		return
	end
	
	local info = UIDropDownMenu_CreateInfo();
	info.text = ALL
	info.value = "__all"
	info.func = Filter_OnClick;
	UIDropDownMenu_AddButton(info, level)

	for keyword, t in pairs(subIdxTb) do
		info = UIDropDownMenu_CreateInfo()
		local t
		local method = UIDropDownMenu_GetSelectedValue(ODCFrameSortFilterSubFrameSortDropDown)
		if method == "quality" then
			t = _G["ITEM_QUALITY"..keyword.."_DESC"]
		elseif method == "left day" then
			t = format("%d "..DAYS, keyword)
		else
			t = keyword
		end
		info.text = t
		info.value = keyword
		info.func = Filter_OnClick;
		UIDropDownMenu_AddButton(info, level)
	end
	
	if UIDropDownMenu_GetSelectedValue(ODCFrameSortFilterSubFrameFilterDropDown) == nil or selectSortChanged == true then
		UIDropDownMenu_SetSelectedValue(ODCFrameSortFilterSubFrameFilterDropDown, "__all");
		selectSortChanged = nil
	end
end

local function SortMethod_OnClick(self)
	UIDropDownMenu_SetSelectedValue(ODCFrameSortFilterSubFrameSortDropDown, self.value);
	selectSortChanged = true
	Module:Update("sort")
	--local text = OfflineDataCenterFrameSortDropDownText;
	--local width = text:GetStringWidth();
	--UIDropDownMenu_SetWidth(OfflineDataCenterFrameSortDropDown, width+40);
	--OfflineDataCenterFrameSortDropDown:SetWidth(width+60)	
end

local function SortMenuInitialize(self, level)
	local info = UIDropDownMenu_CreateInfo();
	for k, v in pairs(SelectSortMethod) do
		if ODC.selectTab == "mail" and (k == "sender" or k == "left day" or k == "C.O.D." or k == "money")
		or (k == "No sorting" or k == "AH" or k == "quality") then
			info = UIDropDownMenu_CreateInfo()
			info.text = L[k]
			info.value = k
			info.func = SortMethod_OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end
	UIDropDownMenu_SetSelectedValue(ODCFrameSortFilterSubFrameSortDropDown, "No sorting");
	--local text = OfflineDataCenterFrameSortDropDownText;
	--local width = text:GetStringWidth();
	--UIDropDownMenu_SetWidth(OfflineDataCenterFrameSortDropDown, width+40);
	--OfflineDataCenterFrameSortDropDown:SetWidth(width+60)
end

StaticPopupDialogs["ODC_ACCEPT_COD_MAIL"] = {
    text = COD_CONFIRMATION,
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept = function(self)
        TakeInboxItem(codMailIndex, codAttachmentIndex);
    end,
    OnShow = function(self)
        MoneyFrame_Update(self.moneyFrame, codMoney);
    end,
    hasMoneyFrame = 1,
    timeout = 0,
    hideOnEscape = 1
};

local function MailSlotClick(slot)
	if ODC_DB[ODC.selectChar]["mail"][slot.x[1]].CODAmount then
		if ODC_DB[ODC.selectChar]["mail"][slot.x[1]].CODAmount > GetMoney() then
			SetMoneyFrameColor("GameTooltipMoneyFrame1", "red");
			StaticPopup_Show("COD_ALERT");
		else
			codMoney = ODC_DB[ODC.selectChar]["mail"][slot.x[1]].CODAmount
			codMailIndex, codAttachmentIndex = slot.x[1], slot.y[1]
			SetMoneyFrameColor("GameTooltipMoneyFrame1", "white");
			StaticPopup_Show("ODC_ACCEPT_COD_MAIL")
		end
	else
		if slot.x[1] and slot.y[1] then
			--for i = getn(slot.x), 1, -1 do
				TakeInboxItem(slot.x[1], slot.y[1])
			--end
			Module:Update("sort")
		end
	end
end

local function SlotClick(slot,button)
	local msg = slot.link
	if not msg then return; end
	if IsShiftKeyDown() and button == 'LeftButton' then
		if AuctionFrame and AuctionFrame:IsVisible() then
			BrowseName:SetText(GetItemInfo(msg))
			return;
		end
		if ChatFrame1EditBox:IsShown() then
			ChatFrame1EditBox:Insert(msg);
		else
			local ExistMSG = ChatFrame1EditBox:GetText() or "";
			ChatFrame1EditBox:SetText(ExistMSG..msg);
			ChatEdit_SendText(ChatFrame1EditBox);
			ChatFrame1EditBox:SetText("");
			ChatFrame1EditBox:Hide();
		end
	elseif button == 'LeftButton' and not isStacked then
		if ODC.selectTab == "mail" then
			MailSlotClick(slot)
		end
	end
end

local function GetLeftTimeText(mailIndex)
	local lefttext = L["+ Left time: "]
	local dayLeftTick = difftime(floor(ODC_DB[ODC.selectChar]["mail"][mailIndex].daysLeft * 86400) + ODC_DB[ODC.selectChar]["mail"].checkMailTick,time())
	local leftday = floor(dayLeftTick / 86400)
	if leftday > 0 then
		lefttext = lefttext..format("> %d "..DAYS,leftday)
	else
		local lefthour = floor((dayLeftTick-leftday*86400) / 3600) 
		local leftminute = floor((dayLeftTick-leftday*86400-lefthour*3600) / 60)
		lefttext = lefttext..format( lefthour > 0 and "%d"..HOURS or "" ,lefthour)..format( leftminute > 0 and "%d"..MINUTES or "",leftminute)
	end
	return lefttext, leftday
end

local function SetTooltipAnchor(slot)
	local x = slot:GetRight();
	if ( x >= ( GetScreenWidth() / 2 ) ) then
		GameTooltip:SetOwner(slot, "ANCHOR_LEFT");
	else
		GameTooltip:SetOwner(slot, "ANCHOR_RIGHT");
	end
end
--[[
Tool-tip format
Left				Right
sender1				count
+lefttime1			count
 -was returned
+lefttime2			count
(is cod)			amount
sender2				count
+lefttime1			count
]]
local function MailTooltipShow(slot)
	local mIdx, aIdx = slot.x, slot.y
	local method = UIDropDownMenu_GetSelectedValue(ODCFrameSortFilterSubFrameSortDropDown)
	local selectChar = ODC.selectChar
	--local sender, wasReturned
	if method =="money" then
		SetTooltipAnchor(slot)
		local money = ODC_DB[selectChar]["mail"][mIdx].money
		local lefttext = L["Sender: "] ..ODC_DB[selectChar]["mail"][mIdx].sender
		local rL, gL, bL = 1, 1, 1
		GameTooltip:AddDoubleLine(lefttext, GetCoinTextureString(money),rL, gL, bL)
		local lefttext = GetLeftTimeText(mIdx)
		GameTooltip:AddDoubleLine(lefttext, "", rL, gL, bL)
		GameTooltip:Show()
		return
	else
		if slot and slot.link then
			SetTooltipAnchor(slot)
			GameTooltip:SetHyperlink(slot.link)
		end
	end
	
	local formatList = {}
	for i = 1 , getn(mIdx) do
		if formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender] == nil then
			formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender] = {}
			local row = {}
			row.lefttext = L["Sender: "] ..ODC_DB[selectChar]["mail"][mIdx[i]].sender
			row.righttext = 0 ---summary count
			tinsert(formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender], row)
		end
		
		local lefttext, leftday = GetLeftTimeText(mIdx[i])
		local count = ODC:GetItemCount(ODC_DB[selectChar]["mail"][mIdx[i]][aIdx[i]])
		
		local foundSameLefttime = false
		for j = 1, getn(formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender]) do
			if formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender][j].lefttext == lefttext and not ODC_DB[selectChar]["mail"][mIdx[i]][aIdx[i]].CODAmount and not ODC_DB[selectChar]["mail"][mIdx[i]][aIdx[i]].wasReturned then----!!should add cod and was returned
				formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender][j].righttext = formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender][j].righttext + count
				formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender][1].righttext = formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender][1].righttext + count
				foundSameLefttime = true
			end
		end
		
		if foundSameLefttime == false then
			local row = {}
			row.lefttext = lefttext
			row.righttext = count
			row.leftday = leftday
			formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender][1].righttext = formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender][1].righttext + count
			tinsert(formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender], row)
			
			if ODC_DB[selectChar]["mail"][mIdx[i]].CODAmount then
				row = {}
				row.lefttext = "└-"..COD.." "..ITEMS
				row.righttext = L["pay for: "]..GetCoinTextureString(ODC_DB[selectChar]["mail"][mIdx[i]].CODAmount)
				row.cod = true
				tinsert(formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender], row)
			end
			
			if ODC_DB[selectChar]["mail"][mIdx[i]].wasReturned then
				row = {}
				row.lefttext = "└-"..L["was returned"]
				row.righttext = ""
				row.wasreturned = true
				tinsert(formatList[ODC_DB[selectChar]["mail"][mIdx[i]].sender], row)
			end
		end
	end
	
	for k in pairs(formatList) do
		for i = 1, getn(formatList[k]) do
			local rL, gL, bL = 1, 1, 1
			if i > 1 then
				if formatList[k][i].leftday then
					local leftday = formatList[k][i].leftday
					if leftday < Config.daysLeftRed then
						rL, gL, bL = 1, 0, 0
					elseif leftday < Config.daysLeftYellow then
						rL, gL, bL = 1, 1, 0
					else
						rL, gL, bL = 0, 1, 0
					end
				elseif formatList[k][i].cod then
					rL, gL, bL = 1, 0, 0.5
				elseif formatList[k][i].wasreturned then
					rL, gL, bL = 1, 1, 1
				end
			end
			GameTooltip:AddDoubleLine(formatList[k][i].lefttext, formatList[k][i].righttext, rL, gL, bL)
		end
	end
	GameTooltip:Show()
end

local function TooltipShow(slot)
	if ODC.selectTab ~= "mail" then 
		if slot and slot.link then
			SetTooltipAnchor(slot)
			GameTooltip:SetHyperlink(slot.link)
		end
	else
		MailTooltipShow(slot)
	end
end

local function SummingForQuality(slotdb)
	local x, y = slotdb.x, slotdb.y
	if not x or not y or not ODC.selectChar then return end
	if not GetItemID(G_DB[x][y]) then return end
	local _, _, quality, _, _, _, _, _, _, _ = GetItemInfo(GetItemID(G_DB[x][y]))
	if not quality then return end
	if not sumQuality[quality] then sumQuality[quality] = 0 end
	local count = ODC:GetItemCount(G_DB[x][y])--G_DB[x][y][2] or 1 ----count
	sumQuality[quality] = sumQuality[quality] + count
end
--[[
structure of slotDB:
case1: isStack
slotDB{		[1]		{	[1].x .y
			[2]			[2].x .y
case2: not stack
slotDB{		[1]		{	[1].x .y
			[2]		{	[1].x .y
case3: money only
slotDB{		[1]		.x
			[2]		
]]
local function SortKeys(t)
	local sort_table = {}
	--取出所有的键
	for k, _ in pairs(t) do
		table.insert(sort_table, k)
	end
	--对所有键进行排序
	table.sort(sort_table)
	return sort_table
end

local function SubFilter(k, c)
	if not slotDB then slotDB = {} end
	if not subIdxTb[k] then return end
	local sort_itemID = SortKeys(subIdxTb[k])
	for _, itemID in ipairs(sort_itemID) do
		if not isStacked then
			for i = 1, getn(subIdxTb[k][itemID]) do
				c = c + 1
				slotDB[c] = {}
				slotDB[c][1] = subIdxTb[k][itemID][i]--??
				SummingForQuality(slotDB[c][1])
			end
		else
			c = c + 1
			slotDB[c] = subIdxTb[k][itemID]
			for i = 1, getn(subIdxTb[k][itemID]) do
				SummingForQuality(subIdxTb[k][itemID][i])
			end
		end
	end
	return c
end

local function Filter()
	if not subIdxTb then return end
	slotDB = nil
	sumQuality = {}
	local filter = UIDropDownMenu_GetSelectedValue(ODCFrameSortFilterSubFrameFilterDropDown)
	if not filter then filter = "__all" end
	local c = 0
	if filter == "__all" then
		local sort_subIdxTb = SortKeys(subIdxTb)
		for _, k in ipairs(sort_subIdxTb) do
			c = SubFilter(k, c)
		end
	else
		c = SubFilter(filter, c)
	end
end

local function SortDB()
	local method = UIDropDownMenu_GetSelectedValue(ODCFrameSortFilterSubFrameSortDropDown)
	if not method then return end
	subIdxTb = nil
	slotDB = nil
	if not G_DB then return end --by eui.cc

	for x, t1 in pairs(G_DB) do
		if type(t1) == "table" then
			--if not G_DB[x] then return end
			if method == "money" then
				if G_DB[x].money then
					SelectSortMethod[method](method, x)
				end
			elseif ODC.selectTab == "mail" then
				-- for y, t in pairs(G_DB[x]) do
				for y = 1, ATTACHMENTS_MAX_RECEIVE do
					-- if type(t) == "table" then
					if G_DB[x][y] then
						SelectSortMethod[method](method, x, y)
					end
				end
			else
				for y, t in ipairs(G_DB[x]) do
					-- if type(t) == "table" then
						SelectSortMethod[method](method, x, y)
					-- end
				end
			end
		end
	end
	selectSortChanged = true
	UIDropDownMenu_Initialize(ODCFrameSortFilterSubFrameFilterDropDown, FilterMenuInitialize)
	if not subIdxTb then return end
	Filter()
end

local function UpdateContainer()
	if not ODC.Frame or not Module.Frame then return end
	local f = Module.Frame
	f.mailboxGoldText:SetText("")
	for i = 1, Config.itemsSlotDisplay do
		if f.Container[i] then
			f.Container[i]:Hide()
		end
	end
	if not slotDB or getn(slotDB) == 0 then
		f.scrollBar:Hide()
		return
	end

	local sumQ = ""
	for i = 1, 7 do
		if sumQuality[i] then
			local _,_,_,colorCode = GetItemQualityColor(i)
			if sumQ ~= "" then sumQ = sumQ.." / " end
			sumQ = sumQ.."|c"..colorCode..sumQuality[i].."|r "
		end
	end
	if sumQ ~= "" then
		sumQ = "\r\n"..L["Quality summary: "]..sumQ
	end
	local former = ""
	if G_DB.money then
		if ODC.selectTab == "mail" then
			former = L["Mailbox gold: "]
		elseif ODC.selectTab == "bag" or ODC.selectTab == "bank" then
			former = L["Character gold: "]
		end
		former = former .. GetCoinTextureString(G_DB.money)
	end
	
	f.mailboxGoldText:SetText(former..sumQ)
	--ODC.mailboxTime:SetText(floor(difftime(time(),sorted_db[ODC.selectChar].checkMailTick)/60).." 分鐘前掃描" or "");
	
	FauxScrollFrame_Update(f.scrollBar, ceil(getn(slotDB) / Config.numItemsPerRow) , Config.numItemsRows, Config.buttonSize + Config.buttonSpacing );
	local offset = FauxScrollFrame_GetOffset(f.scrollBar)
	
	local iconDisplayCount
	if (getn(slotDB) - offset * 8) > Config.itemsSlotDisplay then
		iconDisplayCount = Config.itemsSlotDisplay
	else
		iconDisplayCount = getn(slotDB) - offset * 8
	end
	
	for i = 1, iconDisplayCount do
		local itemDispIndex = i + offset * 8
		local slot = f.Container[i]
		
		local method = UIDropDownMenu_GetSelectedValue(ODCFrameSortFilterSubFrameSortDropDown)
		----to clear this slot!
		slot.count:SetText("")
		slot.tex:SetTexture()
		slot.tex:SetVertexColor(1, 1, 1)
		slot.count:SetTextColor(1, 1, 1)
		slot.cod:Hide()
		slot.x, slot.y = nil, nil
		----ending
		if method == "money" then
			local mailIndex = slotDB[itemDispIndex]
			slot.x = mailIndex

			local money = G_DB[mailIndex].money
			slot.tex:SetTexture(GetCoinIcon(money))
			slot.count:SetText(money/10000)
		else
			slot.x = {}
			slot.y = {}
			for j = 1, getn(slotDB[itemDispIndex]) do
				tinsert(slot.x, slotDB[itemDispIndex][j].x)
				tinsert(slot.y, slotDB[itemDispIndex][j].y)
			end
			slot.link = ODC:SplitItem(G_DB[slot.x[1]][slot.y[1]]) --G_DB[slot.x[1]][slot.y[1]][1]
			if slot.link then
				slot.name, _, slot.rarity, _, _, _, _, _, _, slot.texture = GetItemInfo(slot.link);
				if slot.rarity and slot.rarity > 1 then
					local r, g, b = GetItemQualityColor(slot.rarity);
					slot:SetBackdropBorderColor(r, g, b);
				else
					slot:SetBackdropBorderColor(0.3, 0.3, 0.3)
				end
				slot.tex:SetTexture(slot.texture)
			else
				slot:SetBackdropBorderColor(0.3, 0.3, 0.3)
			end
			
			----For slot item count
			local countnum = 0
			for j = 1 , getn(slot.x) do
				countnum = countnum + (ODC:GetItemCount(G_DB[slot.x[j]][slot.y[j]]))--G_DB[slot.x[j]][slot.y[j]][2] or 1) ----count
				if G_DB[slot.x[j]].CODAmount then
					slot.tex:SetDesaturated(1)
					slot.cod:Show()
				end
			end
			slot.count:SetText(countnum > 1 and countnum or '');
			
			----For searching
			if f.searchingBar:HasFocus() then
				if not slot.name then break end
				local searchingStr = f.searchingBar:GetText();
				if not find(slot.name, searchingStr) then
					slot.tex:SetVertexColor(0.25, 0.25, 0.25)
					slot:SetBackdropBorderColor(0.3, 0.3, 0.3)
					slot.count:SetTextColor(0.3, 0.3, 0.3)
				end
			end
		end
		
		slot:Show()
	end
end

function Module:GameTooltip_OnTooltipCleared(TT)
	if ( not TT ) then
		TT = GameTooltip;
	end
	TT.ItemCleared = nil
end

local function AddItemTooltip(characterName, count, FoundDB)
	if not FoundDB[characterName] then
		FoundDB[characterName] = 0
	end
	FoundDB[characterName] = FoundDB[characterName] + (count or 1)
end

local function LookupSameItem(itemID)
	local FoundDB = {}
	for charName, db in pairs(ODC_DB) do
		for k, tabName in pairs(SameItem_dbs) do
			if ODC_DB[charName][tabName] then
				for i, box in pairs(ODC_DB[charName][tabName]) do
					if type(box) == "table" then
						for j, item in pairs(box) do
							if item and type(item) == "string" then
								if GetItemID(item) == itemID then
									AddItemTooltip(charName, ODC:GetItemCount(item), FoundDB)
								end
							end
							-- if item and type(item) == "table" then
								-- if GetItemID(item[1]) == itemID then
									-- AddItemTooltip(charName, item[2], FoundDB)
								-- end
							-- end
						end
					end
				end
			end
		end
	end
	return FoundDB
end

function Module:GameTooltip_OnTooltipSetItem(TT)
	if ( not TT ) then
		TT = GameTooltip;
	end
	if not TT.ItemCleared then
		TT:AddLine(" ")
		local item, link = TT:GetItem()
		if IsAltKeyDown() and link ~= nil then
			local itemID = GetItemID(link)
			local FoundDB = LookupSameItem(itemID)
			for k, v in pairs(FoundDB) do
				TT:AddDoubleLine('|cFFCA3C3C'..k..'|r', v)
			end
		else
			TT:AddDoubleLine('|cFFCA3C3C'..L['Hold down the ALT key']..'|r', L['Show the number of items for all Character'])
		end		
		
		TT.ItemCleared = true;
	end		
end

local function SearchBarResetAndClear(self)
	if not self then self = Module.Frame.searchingBar end
	self:SetText("");
	self:ClearFocus();
	SearchBoxTemplate_OnEditFocusLost(self)
end

local function UpdateSearch()
	local MIN_REPEAT_CHARACTERS = 3;
	local searchString = Module.Frame.searchingBar:GetText();
	if (len(searchString) > MIN_REPEAT_CHARACTERS) then
		local repeatChar = true;
		for i=1, MIN_REPEAT_CHARACTERS, 1 do 
			if ( sub(searchString,(0-i), (0-i)) ~= sub(searchString,(-1-i),(-1-i)) ) then
				repeatChar = false;
				break;
			end
		end
		if ( repeatChar ) then
			SearchBarResetAndClear();
			-- EditBox_ClearFocus()
			Module:Update();
			return;
		end
	end
	Module:Update();
end

local function CreateSubFrame()
	local p = ODC.Frame
	local f = CreateFrame('Frame',FRAMENAME, p);
	f:SetPoint('TOPLEFT', 0, -40);
	f:SetPoint('BOTTOMRIGHT', 0, 0);
	Module.Frame = f
	f:Hide()
	
	----Search
	f.searchingBar = CreateFrame('EditBox', FRAMENAME..'SearchBox', f, "SearchBoxTemplate");
	if ElvUI then
		ODCFrameSortFilterSubFrameSearchBox.Left:Hide()
		ODCFrameSortFilterSubFrameSearchBox.Middle:Hide()
		ODCFrameSortFilterSubFrameSearchBox.Right:Hide()
	end
	f.searchingBar:SetFrameLevel(f:GetFrameLevel() + 2);
	f.searchingBar:SetHeight(15);
	f.searchingBar:SetWidth(180);
	f.searchingBar:SetPoint('TOPLEFT', f, 'TOPLEFT', 12, 0);
	f.searchingBar:SetScript("OnEscapePressed", function(self)
		SearchBarResetAndClear(self)
		Module:Update()
	end);
	f.searchingBar:SetScript("OnEnterPressed", function(self)
		SearchBarResetAndClear(self)
		Module:Update()
	end);
	f.searchingBar:SetScript("OnTextChanged", UpdateSearch);
	f.searchingBar:SetScript('OnChar', UpdateSearch);
	
	----Create stack up button
	f.stackUpCheckButton = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate");
	f.stackUpCheckButton:SetPoint("LEFT",f.searchingBar, 200, 0)
	f.stackUpCheckButton.text:SetText(L["Stack items"])
	f.stackUpCheckButton:SetChecked(false)--ODC_Config.UI.isStacked or false)
	f.stackUpCheckButton:SetScript("OnClick", function(self)
		--ODC_Config.UI.isStacked = self:GetChecked()
		isStacked = self:GetChecked()
		Module:Update("filter")
	end)

	----Create sort dropdown menu
	tinsert(UISpecialFrames, f)
	f.sortmethod = CreateFrame('Frame', FRAMENAME..'SortDropDown', f, 'UIDropDownMenuTemplate')
	f.sortmethod:SetPoint("BOTTOMLEFT", f.searchingBar, 0, -36)
	
	----Create filter dropdown menu
	f.filter = CreateFrame('Frame', FRAMENAME..'FilterDropDown', f, 'UIDropDownMenuTemplate')
	f.filter:SetPoint("LEFT", f.sortmethod, 150, 0)
	
	----Create mailbox gold text
	f.mailboxGoldText = f:CreateFontString(nil, 'OVERLAY');
	if ElvUI then
		f.mailboxGoldText:FontTemplate(nil, 14, 'OUTLINE')
	else
		f.mailboxGoldText:SetFont(STANDARD_TEXT_FONT, 14);
	end
	f.mailboxGoldText:SetPoint("BOTTOMLEFT", 10, 5);
	f.mailboxGoldText:SetJustifyH("LEFT");
	
	----Create scroll frame
	f.scrollBar = CreateFrame("ScrollFrame", FRAMENAME.."ScrollBar", f, "FauxScrollFrameTemplate")
	f.scrollBar:SetPoint("TOPLEFT", 0, -50)
	f.scrollBar:SetPoint("BOTTOMRIGHT", -28, 45)
	f.scrollBar:Hide()
	f.scrollBar:SetScript("OnVerticalScroll",  function(self, offset)
		if floor((offset / (Config.buttonSize + Config.buttonSpacing)) + 0.5) ~= self.offset then
			FauxScrollFrame_OnVerticalScroll(self, offset, Config.buttonSize + Config.buttonSpacing, UpdateContainer);
		end
		FauxScrollFrame_OnVerticalScroll(self, offset, Config.buttonSize + Config.buttonSpacing);
		-- Module:Update()
	end)
	
	if ElvUI then
		local S = ElvUI[1]:GetModule("Skins")
		if S then
			S:HandleEditBox(f.searchingBar)
			S:HandleCheckBox(f.stackUpCheckButton);
			f.stackUpCheckButton:Size(20)
			S:HandleDropDownBox(f.sortmethod)
			S:HandleDropDownBox(f.filter)
			S:HandleScrollBar(_G[FRAMENAME.."ScrollBarScrollBar"])
		end
	end
	
	----Create Container
	f.Container = CreateFrame('Frame', nil, f);
	f.Container:SetPoint('TOPLEFT', f, 'TOPLEFT', 12, -50);-- -90);
	f.Container:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 8);
	f.Container:SetFrameLevel(f:GetFrameLevel() + 2);
	f.Container:Show()
	
	local numContainerRows = 0;
	local lastButton;
	local lastRowButton;
	for i = 1, Config.itemsSlotDisplay do
		local slot
		if ElvUI then
			slot = CreateFrame('Button', nil, f.Container);
			slot:SetTemplate('Default');
			slot:StyleButton();
			slot:Size(Config.buttonSize);
		else
			slot = CreateFrame('Button', nil, f.Container, "ItemButtonTemplate");
			slot:SetSize(Config.buttonSize, Config.buttonSize);
		end
		slot:SetFrameLevel(f:GetFrameLevel() + 4);
		slot:Hide()
		
		slot.count = slot:CreateFontString(nil, 'OVERLAY');
		slot.cod = slot:CreateFontString(nil, 'OVERLAY');
		if ElvUI then
			slot.count:FontTemplate(nil, 12, 'OUTLINE')
			slot.cod:FontTemplate(nil, 12, 'OUTLINE')
		else
			slot.count:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE');
			slot.cod:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE');
		end
		slot.count:SetPoint('BOTTOMRIGHT', 0, 2);
		slot.cod:SetPoint('TOPLEFT', 0, 2);
		slot.cod:SetText("C.O.D.")
		slot.cod:Hide()
		
		slot.tex = slot:CreateTexture(nil, "OVERLAY", nil)
		slot.tex:SetPoint("TOPLEFT", slot, "TOPLEFT", 2, -2)
		slot.tex:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", -2, 2)
		slot.tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		slot:SetScript("OnEnter", TooltipShow)
		slot:HookScript("OnClick", SlotClick)
		slot:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		
		f.Container[i] = slot
		
		if lastButton then
			if (i - 1) % Config.numItemsPerRow == 0 then
				slot:SetPoint('TOP', lastRowButton, 'BOTTOM', 0, -Config.buttonSpacing);
				lastRowButton = f.Container[i];
				numContainerRows = numContainerRows + 1;
			else
				slot:SetPoint('LEFT', lastButton, 'RIGHT', Config.buttonSpacing, 0);
			end
		else
			slot:SetPoint('TOPLEFT', f.Container, 'TOPLEFT',0, 0)
			lastRowButton = f.Container[i];
			numContainerRows = numContainerRows + 1;
		end
		lastButton = f.Container[i];
	end
end

local function UpdateSortMenu()
	UIDropDownMenu_Initialize(Module.Frame.sortmethod, SortMenuInitialize)
end

function Module:CreateOrShowSubFrame(tabName)
	if not self.Frame then
		CreateSubFrame()
	end

	UpdateSortMenu()
	ODC:ShowSubFrame(tabName, Module.Frame)
end

function Module:Update(method)
	if not ODC.Frame:IsVisible() then return end
	if not ODC.selectChar then return end
	G_DB = ODC_DB[ODC.selectChar][ODC.selectTab]

	if not G_DB then
		self.Frame:Hide()
		return
	end

	if method == "sort" then
		SearchBarResetAndClear()
		SortDB()
	elseif method == "filter" then
		Filter()
	end
	UpdateContainer()
end

Module.selectTabCallbackFunc = function(selectedTab)
	-- selectTab = selectedTab
end

Module.selectCharCallbackFunc = function(selectedChar)
	-- selectChar = selectedChar
end

-- function Module:OnInitialize()
	-- CreateSubFrame()
-- end

function Module:OnEnable()
	ODC:AddModule(self)
	self:HookScript(GameTooltip, 'OnTooltipSetItem', 'GameTooltip_OnTooltipSetItem')
	self:HookScript(GameTooltip, 'OnTooltipCleared', 'GameTooltip_OnTooltipCleared')
end

function Module:OnDisable()
	-- self:UnhookAll()
	ODC:RemoveModule(self)
end