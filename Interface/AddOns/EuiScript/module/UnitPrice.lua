local E, L = unpack(ElvUI) -- Import Functions/Constants, Config, Locales
--Title: UnitPrice
--Author: xbeeps
--Version: 1.20
--Modify by cadcamzy at 2015.04.27

local FauxScrollFrame_GetOffset = FauxScrollFrame_GetOffset
local GetAuctionItemInfo = GetAuctionItemInfo
local GetAuctionItemLink = GetAuctionItemLink
local GetItemInfo = GetItemInfo
local select = select
local getglobal = getglobal


local function truncateItemName(item)
    local itemName = item:GetText();
    local itemWidth = item:GetWidth();
    local stringWidth = item:GetStringWidth();
    if (itemName and stringWidth > itemWidth) then
        local stringLength = strlen(itemName);
        stringLength = floor(stringLength * itemWidth / stringWidth) - 3;
        item:SetText(strsub(itemName, 1, stringLength) .. "...");
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self,event,arg1)
	if arg1 == 'Blizzard_AuctionUI' then
		self:UnregisterAllEvents()
		
		local AuctionFrameBrowse_Update_Old = AuctionFrameBrowse_Update;

		local function AuctionFrameBrowse_Update_Hooked()
			AuctionFrameBrowse_Update_Old();

			local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame);

			for i = 1, NUM_BROWSE_TO_DISPLAY do
				local name, _, count, _, _, _, _, min, inc, buy, bid =  GetAuctionItemInfo("list", offset + i);

				if (name) then
					local _, _, id = strfind(GetAuctionItemLink("list", offset + i) or "", "item:(%d+):");

					if (id) then
						local stack = select(8, GetItemInfo(id));
						if (stack and stack > 1) then
							bid = (bid > 0 and (bid + inc) or min);
							local item = getglobal("BrowseButton" .. i .. "Name");
							truncateItemName(item);
							local text;
							if (E.db.euiscript.unitprice and count > 1) then
								text = E:FormatMoney(floor(bid / count), 'BLIZZARD');
								if (buy and buy > 0 and buy ~= bid) then
									text = E:FormatMoney(floor(bid / count), 'BLIZZARD');
									text = text .. "/".. E:FormatMoney(floor(buy / count), 'BLIZZARD');
								end
							end
							if (text) then
								item:SetFormattedText("%s\n(%s)", item:GetText() or "", text);
							end
						end
					end
				end
			end
		end

		AuctionFrameBrowse_Update = AuctionFrameBrowse_Update_Hooked;
	end
end)