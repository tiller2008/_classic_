local E = unpack(ElvUI) -- Import Functions/Constants, Config, Locales
if E.db.euiscript.autobuy ~= true then return end
local find = string.find
local min = math.min
local max = math.max
local format = string.format
local floor = math.floor
local strmatch = strmatch
local GOLD_AMOUNT_SYMBOL, SILVER_AMOUNT_SYMBOL, COPPER_AMOUNT_SYMBOL = GOLD_AMOUNT_SYMBOL, SILVER_AMOUNT_SYMBOL, COPPER_AMOUNT_SYMBOL
local NUM_BAG_FRAMES, ERR_NOT_ENOUGH_MONEY = NUM_BAG_FRAMES, ERR_NOT_ENOUGH_MONEY
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemLink = GetContainerItemLink
local GetContainerItemInfo = GetContainerItemInfo
local tonumber, select, tostring, print = tonumber, select, tostring, print
local GetMerchantNumItems = GetMerchantNumItems
local GetMerchantItemLink = GetMerchantItemLink
local GetMerchantItemInfo = GetMerchantItemInfo
local GetItemInfo = GetItemInfo
local BuyMerchantItem = BuyMerchantItem
local UnitLevel = UnitLevel
local IsAltKeyDown = IsAltKeyDown
local IsShiftKeyDown = IsShiftKeyDown

local buyed = false
----------------------------------------------------------------------------------------
--	Auto buy reagents by (ShestakUI)
----------------------------------------------------------------------------------------
local ItemIDPattern = "item:(%d+):%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+:%d+:%d+:%d+"

local function FormatGold(amount)
	local gold, silver, copper = floor(amount * 0.0001), floor(mod(amount * 0.01, 100)), floor(mod(amount, 100))

	return (gold > 0 and format("%s|cffffd700%s|r ", gold, GOLD_AMOUNT_SYMBOL) or "")
	.. (silver > 0 and format("%s|cffc7c7cf%s|r ", silver, SILVER_AMOUNT_SYMBOL) or "")
	.. ((copper > 0 or (gold == 0 and silver == 0)) and format("%s|cffeda55f%s|r", copper, COPPER_AMOUNT_SYMBOL) or "")
end

local function CheckReagents(CheckID, RequiredAmount)
	local total = 0
	local ItemLink, stack = nil, 0
	
	for bag = 0, NUM_BAG_FRAMES do
		for slot = 1, GetContainerNumSlots(bag) do
			ItemLink = GetContainerItemLink(bag, slot)
			if ItemLink then
				local Find, _, ID = find(ItemLink, ItemIDPattern)
				if Find and CheckID == tonumber(ID) then
					stack = select(2, GetContainerItemInfo(bag, slot))
					total = total + stack
				end
			end
		end
	end

	return max(0, (RequiredAmount - total))
end

local function BuyReagents()
	if buyed then return end
	local ItemLink, ItemID, stock, price, stack, quantity, fullstack
	
	for i = 1, GetMerchantNumItems() do
		ItemLink = GetMerchantItemLink(i)

		if ItemLink then
			ItemID = strmatch(ItemLink, "item:(%d+)")
		--	ItemID = select(3, find(ItemLink, ItemIDPattern))
			if ItemID then
				ItemID = tostring(ItemID)
			end
		end
		
		if ItemID and E.db.euiscript.autobuylist[ItemID] and E.db.euiscript.autobuylist[ItemID] > 0 then
			price, stack, stock = select(3, GetMerchantItemInfo(i))
			if E.db.euiscript.autobuylist[ItemID] then
				quantity = CheckReagents(tonumber(ItemID), E.db.euiscript.autobuylist[ItemID])
			end

			if quantity > 0 then
				if stock ~= -1 then
					quantity = min(quantity, stock)
				end

				subtotal = price * (quantity / stack)

				if subtotal > GetMoney() then
					print("|cffffff00"..ERR_NOT_ENOUGH_MONEY.."|r")
					return
				end

				fullstack = select(8, GetItemInfo(ItemID))

				while quantity > fullstack do
					BuyMerchantItem(i, fullstack)
					quantity = quantity - fullstack
				end

				if quantity > 0 then
					BuyMerchantItem(i, quantity)
					if ItemLink then
						print("|cff66C6FF"..ITEM_PURCHASED_COLON.." "..ItemLink.." - "..FormatGold(subtotal)..".")
					end
				end
			end
		end

		quantity = 0
	end
	
	buyed = true
end

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:RegisterEvent("MERCHANT_CLOSED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	if UnitLevel('player') < E.db.euiscript.autobuy_maxlevel then return; end
	
	if event == "MERCHANT_SHOW" and not (IsAltKeyDown() or IsShiftKeyDown()) then
		E:ScheduleTimer(BuyReagents, 1)
	end
	if event == "MERCHANT_CLOSED" or event == "PLAYER_ENTERING_WORLD" then
		buyed = false
	end
end)