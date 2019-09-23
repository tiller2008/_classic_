local E, L, DF = unpack(ElvUI); --Engine
if not E.db["euiscript"].hovertip then return; end
local IsControlKeyDown = IsControlKeyDown
local GetMouseFocus = GetMouseFocus
local strfind, unpack, ipairs = strfind, unpack, ipairs
local GetScreenWidth = GetScreenWidth
local GetCursorPosition = GetCursorPosition
local getglobal = getglobal
local CURRENTLY_EQUIPPED = CURRENTLY_EQUIPPED

local QuickCompare = LibStub("AceAddon-3.0"):NewAddon("QuickCompare", "AceHook-3.0");
-------------------
-- 比系统的更棒的装备比较
-- from DW
-------------------
local useAttribute = true;

function QuickCompare:GameTooltip_ShowCompareItem(this)	
	local this = this or GameTooltip;
	local item, link = this:GetItem();
	if (IsControlKeyDown() or not link) then
		return;
	end
	local OffsetX = -2
	
	-- 以下Frame时忽略
	local frame = GetMouseFocus() and GetMouseFocus():GetName() or "";	
	if strfind(frame,"^Character.*Slot$")		-- 装备栏忽略
		or strfind(frame,"^TempEnchant%d+$")	-- 临时魔法忽略
		or strfind(frame, "^TM_Button")			-- 饰品栏忽略
		or strfind(frame, "^TrinketMenu")		-- 饰品栏忽略
	then return end

	--correct anchor if this is in right half of screen
	local anchor, align="TOPLEFT", "TOPRIGHT";
	local scale = this:GetScale();
	local escale = this:GetEffectiveScale();
	
	local shoptip1, shoptip2 = unpack(this.shoppingTooltips);
	local itemshown = {shoptip1:SetCompareItem(shoptip2, this)};

	-- find correct side
	local rightDist = 0;
	local leftPos = this:GetLeft();
	local rightPos = this:GetRight();
	if ( not rightPos ) then
		rightPos = 0;
	end
	if ( not leftPos ) then
		leftPos = 0;
	end

	rightDist = GetScreenWidth() - rightPos;
	leftDist = leftPos;

	if (leftPos and (rightDist < leftPos)) then		
		anchor, align = "TOPRIGHT", "TOPLEFT";
	end

	local totalWidth = 0;
	if ( itemshown[1]  ) then
		totalWidth = totalWidth + shoptip1:GetWidth();
	end
	if ( itemshown[2]  ) then
		totalWidth = totalWidth + shoptip2:GetWidth();
	end

	local offsetx, offsety = GetCursorPosition();
	local realRightPos = rightPos * escale;
	local realLeftPos = leftPos * escale;

	if (anchor == "TOPLEFT" and offsetx > realRightPos) then
		anchor, align = "TOPRIGHT", "TOPLEFT";
	elseif (anchor == "TOPRIGHT" and offsetx < realLeftPos) then
		anchor, align = "TOPLEFT", "TOPRIGHT";
	end

	if (anchor == "TOPRIGHT" and totalWidth > leftPos * escale) then
		anchor, align = "TOPLEFT", "TOPRIGHT";
	elseif (anchor == "TOPLEFT" and (rightPos * escale + totalWidth) >  GetScreenWidth() * escale) then
		anchor, align = "TOPRIGHT", "TOPLEFT";
	end
	
	-- see if we should slide the this
	if ( this:GetAnchorType() ) then
		if ( (anchor == "TOPRIGHT") and (totalWidth > leftPos) ) then
			this:SetAnchorType(this:GetAnchorType(), (totalWidth - leftPos), 0);
		elseif ( (anchor == "TOPLEFT") and (rightPos + totalWidth) >  GetScreenWidth() ) then
			this:SetAnchorType(this:GetAnchorType(), -((rightPos + totalWidth) - GetScreenWidth()), 0);
		end
	end
	
	local anchorframe = this;
	local dy = 0;

	for i, shoptip in ipairs(this.shoppingTooltips) do
		if (itemshown[i]) then
			shoptip:SetOwner(this, "ANCHOR_NONE");
			shoptip:ClearAllPoints();

			local shoptiptext = getglobal(shoptip:GetName().."TextLeft1");			
			local newtext = "|cffE0E0E0["..CURRENTLY_EQUIPPED.. "]|r";
			shoptiptext:SetText("|cffE0E0E0["..CURRENTLY_EQUIPPED.. "]|r");			

			local bottom, top=shoptip:GetBottom(), shoptip:GetTop();
			local uibottom, uitop=E.UIParent:GetBottom(),E.UIParent:GetTop();
			if (bottom and bottom*scale-10<=uibottom) then				
				dy = uibottom-bottom+(10*scale);			
			end
	
			if align:find('RIGHT') then OffsetX = 2 else OffsetX = -2 end
			shoptip:Point(anchor, anchorframe, align, OffsetX, dy);
			shoptip:SetScale(scale);
			
			--last comparison this becomes anchorframe for next comparison this
			anchorframe = shoptip;
			dy = 0;
		end
	end

	local item1, item2 = shoptip1:SetCompareItem(shoptip2, this);
	shoptip1:Show();
end

function QuickCompare:Toggle(switch)	
	if (switch) then
		self:SecureHook("GameTooltip_ShowCompareItem");	
		self:SecureHookScript(GameTooltip, "OnTooltipSetItem", "GameTooltip_ShowCompareItem");
	
		getglobal("ShoppingTooltip1"):SetBackdropColor(0.3,0.3,0.0);
		getglobal("ShoppingTooltip2"):SetBackdropColor(0.3,0.3,0.0);	
	else		
		self:Unhook(GameTooltip, "OnTooltipSetItem");
		self:Unhook("GameTooltip_ShowCompareItem");
	end	
end


function QuickCompare:ToggleAttri(switch)
	if (switch) then
		useAttribute = true;
	else
		useAttribute = false;
	end
end

QuickCompare:Toggle(true)