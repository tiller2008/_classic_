local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local huanhuadata = LibStub("LibItemData-1.1")
local TT = E:GetModule('Tooltip')

local strmatch, ipairs, select, match = strmatch, ipairs, select, string.match
local GetItemCount = GetItemCount
local GetItemInfo = GetItemInfo
local IsAltKeyDown = IsAltKeyDown
local IsDressableItem = IsDressableItem

-------------------
-- 显示幻化套装信息
-------------------

function TT:GetSetItemCount(sets)
	local count = 0;
	for i, itemID in ipairs(sets) do
		local c = GetItemCount(itemID);
		if (c > 0) then
			count = count + 1;
		end
	end
	return count, #sets;
end

local function CreateHHInfo(tooltip, itemID)
	local iType, subType, setName, setsdata = huanhuadata:FindItem(itemID);		
	if (iType) then
		local curCount, totalCount = TT:GetSetItemCount(setsdata);
		local text = "\n["..L["Transmogrify"].."]";
		text = text .. setName .. ("  (%d/%d)"):format(curCount, totalCount);
		tooltip:AddLine(text, 0.97, 0.51, 0.97);
		for i, id in ipairs(setsdata) do
			local name = GetItemInfo(id);
			local c = GetItemCount(id);
			if (c > 0) then
				tooltip:AddLine(name, 1, 1, 1);
			else
				tooltip:AddLine(name, 0.62, 0.62, 0.62);
			end
		end
		tooltip:AddLine(L["Transmogrify sort"].."：" .. iType .. "-" .. subType, 0.9, 0.9, 0.9);
		tooltip:AddLine("\nCtrl + Alt + Left"..L["key to view Set effect"], 0, 0.6, 0.8);
	end
end

function TT:DressUpItemLink(link)
	if (E.db.tooltip.hh and IsAltKeyDown()) then
		local itemID = strmatch(link, "item:(%d+)");
		local iType, subType, setName, setsdata = huanhuadata:FindItem(itemID);
		if (not iType) then
			return;
		end

		local model = DressUpModel;
		if ( SideDressUpFrame.parentFrame and SideDressUpFrame.parentFrame:IsShown() ) then
			model = SideDressUpModel;
		end
		
		model:Undress();
		for _, id in ipairs(setsdata) do
			if (IsDressableItem(id)) then
				model:TryOn(id);
			end			
		end
	end	
end

TT:SecureHook("DressUpItemLink");

GameTooltip:HookScript("OnTooltipSetItem", function(tooltip, ...)
	if E.private["tooltip"].enable ~= true then return end
	if not E.db.tooltip.hh or E:IsPRType() then return end
	
	local item = select(2, tooltip:GetItem())
	if not item then return; end
	local itemID = match(item, "item:(%d+)")
	
	if itemID then
		CreateHHInfo(tooltip, itemID)
	end
end)