local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF not loaded')

local IsInInstance = IsInInstance
local UnitCanAttack = UnitCanAttack

local UpdateTarget = function(self)
	local _, instanceType = IsInInstance();
	local targetIcon = self.ArenaTargetIcon

	if instanceType == 'arena' then
		local ID = self.unit:match('arena(%d)') or self:GetID() or 0
		local unit = 'arena'..tostring(ID)..'target'
		local _, targetClass = UnitClass(unit)
		if targetIcon.showEnemy then
			if targetClass and (not UnitCanAttack("player", unit)) then
				targetIcon.Icon:SetTexture("Interface\\TARGETINGFRAME\\UI-CLASSES-CIRCLES.BLP")
				targetIcon.Icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[targetClass]))
				targetIcon.Name:SetText(UnitName(unit))
				targetIcon:Show()
			else
				targetIcon:Hide()
			end
		else
			if targetClass then
				targetIcon.Icon:SetTexture("Interface\\TARGETINGFRAME\\UI-CLASSES-CIRCLES.BLP")
				targetIcon.Icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[targetClass]))
				targetIcon.Name:SetText(UnitName(unit))
				targetIcon:Show()
			else
				targetIcon:Hide()
			end
		end
	else
		targetIcon:Hide()
	end
end

local Update = function(self, event, unit)
	if event == 'ARENA_OPPONENT_UPDATE' and unit ~= self.unit then return; end
	local targetIcon = self.ArenaTargetIcon
	
	local _, instanceType = IsInInstance();
	targetIcon.instanceType = instanceType
	
	if(targetIcon.PreUpdate) then targetIcon:PreUpdate(event) end

	if instanceType == 'arena' then
		UpdateTarget(self)
	end

	if(targetIcon.PostUpdate) then targetIcon:PostUpdate(event) end
end


local Enable = function(self)
	local targetIcon = self.ArenaTargetIcon
	if targetIcon then
		self:RegisterEvent("ARENA_OPPONENT_UPDATE", Update, true)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", Update, true)
		self:SetScript('OnUpdate', UpdateTarget)
		
		if not targetIcon.Icon then
			targetIcon.Icon = targetIcon:CreateTexture(nil, "OVERLAY")
			targetIcon.Icon:SetAllPoints(targetIcon)
			targetIcon.Icon:SetTexture("Interface\\TARGETINGFRAME\\UI-CLASSES-CIRCLES.BLP")
		end
		targetIcon:Show()
		return true
	end
end
 
local Disable = function(self)
	local targetIcon = self.ArenaTargetIcon
	if targetIcon then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", Update)
		self:UnregisterEvent("ARENA_OPPONENT_UPDATE", Update)
		self:SetScript('OnUpdate', nil)		
		targetIcon:Hide()
	end
end
 
oUF:AddElement('ArenaTargetIcon', Update, Enable, Disable)