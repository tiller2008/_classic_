local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF not loaded')
--by eui.cc at 20150323

local Update = function(self, event, unit)
	if unit ~= self.unit then return; end
	local factionIcon = self.FactionIcon

	if(factionIcon.PreUpdate) then factionIcon:PreUpdate(event) end

	local unitFactionGroup = UnitFactionGroup(self.unit)
	if unitFactionGroup == "Horde" then
		factionIcon:SetTexture([[Interface\Icons\INV_BannerPVP_01]])
	elseif unitFactionGroup == 'Alliance' then
		factionIcon:SetTexture([[Interface\Icons\INV_BannerPVP_02]])
	else
		factionIcon:SetTexture()
	end

	if(factionIcon.PostUpdate) then factionIcon:PostUpdate(event) end
end

local Enable = function(self)
	local factionIcon = self.FactionIcon
	if factionIcon then
		self:RegisterEvent("UNIT_NAME_UPDATE", Update, true)
		
		factionIcon:Show()
		return true
	end
end
 
local Disable = function(self)
	local factionIcon = self.FactionIcon
	if factionIcon then
		self:UnregisterEvent("UNIT_NAME_UPDATE", Update)
		factionIcon:Hide()
	end
end
 
oUF:AddElement('FactionIcon', Update, Enable, Disable)