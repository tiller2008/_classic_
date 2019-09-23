local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
EuiALM = E:NewModule("ALM", "AceEvent-3.0", "AceTimer-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local LibClassicDurations = LibStub("LibClassicDurations")

--Cache global variables
local _G = _G
local GetTime, C_TimerAfter = GetTime, C_Timer.After
local pairs, select, unpack = pairs, select, unpack
local tremove,tinsert = tremove, tinsert
local GetInventoryItemID = GetInventoryItemID
local CooldownFrame_SetTimer = CooldownFrame_Set
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local GetInventoryItemCooldown = GetInventoryItemCooldown
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecialization = GetSpecialization
local GetSpellCooldown = GetSpellCooldown

local Index = {
	["playerBuff"] = 1,
	["playerDebuff"] = 1,
	["targetBuff"] = 1,
	["targetDebuff"] = 1,
	["spellCD"] = 1,
}

local Module = EuiALM
Module.Aura = {}
local unusedOverlays = {}

local function createOverlay(btn)
	local isize = Module.db.spellCD.iconSize
	local overlay = tremove(unusedOverlays)
	if not overlay then
		overlay = CreateFrame("Frame", nil, btn, "EuiALMSpellActivationAlert")
	end
	overlay:ClearAllPoints()
	overlay:SetParent(btn)
	overlay:SetAlpha(0.7)
	overlay:SetPoint("TOPLEFT", btn, "TOPLEFT", -isize * 0.4, isize * 0.4)
	overlay:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", isize * 0.4, -isize * 0.4);
	btn.overlay = overlay
	overlay.animIn:Play()
end

function Module:OverlayGlowAnimOutFinished(animGroup)
    local overlay = animGroup:GetParent()
    overlay:Hide()
    tinsert(unusedOverlays, overlay)
end

local UpdateTooltip = function(self)
	if not self.key then return; end
	
	local unit, filter = 'player', 'HELPFUL'
	if self.key:find('target') then unit = 'target' end
	if self.key:find('Debuff') then filter = 'HARMFUL' end
	if self.key:find('spellCD') then
		if self.spellid == GetInventoryItemID("player", 10) then
			GameTooltip:ClearLines()
			GameTooltip:AddLine(GetItemSpell(self.spellid))
			GameTooltip:Show()
		else
			GameTooltip:SetSpellByID(self.spellid)
		end
		return;
	end
	
	GameTooltip:SetUnitAura(unit, self:GetID(), filter)
end

local OnEnter = function(self)
	if(not self:IsVisible()) or (not Module.db.tooltip) then return end
	
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	self:UpdateTooltip()
end

local OnLeave = function()
	GameTooltip:Hide()
end

local UF = E:GetModule('UnitFrames');
-- BuildICON
local function BuildICON(IconSize, i)
	local Frame = CreateFrame("Frame", nil, E.UIParent)
	Frame:SetSize(IconSize, IconSize)

	local offset = UF.thinBorders and E.mult or E.Border
	Frame:SetTemplate('Default', nil, nil, UF.thinBorders, true)


	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
	Frame.Icon:SetInside(Frame, offset, offset)
	Frame.Icon:SetTexCoord(unpack(E.TexCoords))
	Frame.Icon:SetDrawLayer('ARTWORK')
	
	Frame.Count = Frame:CreateFontString(nil, 'OVERLAY')
	Frame.Count:FontTemplate(LSM:Fetch("font", Module.db.font), Module.db.fontSize, Module.db.fontOutline)
	Frame.Count:SetPoint("BOTTOMRIGHT", offset, -offset)

	Frame.Cooldown = CreateFrame("Cooldown", nil, Frame, 'CooldownFrameTemplate') 
	Frame.Cooldown:SetReverse(true)
	Frame.Cooldown:SetInside(Frame, offset, offset)

	Frame.Cooldown.CooldownOverride = 'watch'

	E:RegisterCooldown(Frame.Cooldown)
	Frame:Hide()
	
	if Module.db.tooltip then
		Frame.UpdateTooltip = UpdateTooltip
		Frame:SetScript("OnEnter", OnEnter)
		Frame:SetScript("OnLeave", OnLeave)
		Frame:EnableMouse(true)
	else
		Frame:EnableMouse(false)
	end
	
	return Frame
end

function Module:BuildAura()
	self.Aura.playerBuff = {}
	for i = 1, self.db.playerBuff.maxNum do
		local Frame = BuildICON(self.db.playerBuff.iconSize, i)
		tinsert(self.Aura.playerBuff, Frame)
	end
	self.Aura.playerDebuff = {}
	for i = 1, self.db.playerDebuff.maxNum do
		local Frame = BuildICON(self.db.playerDebuff.iconSize, i)
		tinsert(self.Aura.playerDebuff, Frame)
	end
	self.Aura.targetBuff = {}
	for i = 1, self.db.targetBuff.maxNum do
		local Frame = BuildICON(self.db.targetBuff.iconSize, i)
		tinsert(self.Aura.targetBuff, Frame)
	end
	self.Aura.targetDebuff = {}
	for i = 1, self.db.targetDebuff.maxNum do
		local Frame = BuildICON(self.db.targetDebuff.iconSize, i)
		tinsert(self.Aura.targetDebuff, Frame)
	end
	self.Aura.spellCD = {}
	for i = 1, self.db.spellCD.maxNum do
		local Frame = BuildICON(self.db.spellCD.iconSize, i)
		tinsert(self.Aura.spellCD , Frame)
	end	
end

function Module:UpdatePos()
	for key, value in pairs(Module.Aura) do
		local xDirection, yDirection = self.db[key].x_direction, self.db[key].y_direction
		local perRow, interval = self.db[key].perRow, self.db[key].interval
		local maxNum = self.db[key].maxNum
		local lastButton, lastColumnButton;
		for i = 1, maxNum do
			local f = value[i]
			lastButton = value[i-1];
			lastColumnButton = value[i-perRow];
			
			if maxNum < perRow then
				perRow = maxNum;
			end		
			
			local p1, p2, p3, p4 = "TOP", "BOTTOM", "LEFT", "RIGHT"
			x_interval, y_interval = self.db[key].interval, -(self.db[key].interval)
			if xDirection == "LEFT" then
				p3 = "RIGHT";
				p4 = "LEFT";
				x_interval = -(self.db[key].interval)
			else
				x_interval = self.db[key].interval
			end
			if yDirection == "UP" then
				p1 = "BOTTOM";
				p2 = "TOP";
				y_interval = -(self.db[key].interval)
			else
				y_interval = self.db[key].interval
			end
			
			if i == 1 then
				f:Point(p1..p3, key.."Anchor", p1..p3, 0, 0)
			elseif (i-1) % perRow == 0 then
				f:ClearAllPoints()
				f:Point(p1, lastColumnButton, p2, 0, -y_interval)
			else
				f:ClearAllPoints()
				f:Point(p3, lastButton, p4, x_interval, 0)
			end
		end
	end
end

local function CleanUp()
	for K, VALUE in pairs(Module.Aura) do
		if K == 'spellCD' and Module.db.spellCD.alwaysShow then break; end --不重置技能CD
		for _, value in pairs(VALUE) do
			if value then
				value:Hide()
			--	value:SetScript("OnUpdate", nil)
			end
			if value.Icon then value.Icon:SetTexture(nil) end
			if value.Count then value.Count:SetText(nil) end
			if valueSpellname then value.Spellname:SetText(nil) end
		end
	end
end

function Module:DeleteAllFrame()
	for _, VALUE in pairs(self.Aura) do
		for _, value in pairs(VALUE) do
			if value.Icon then value.Icon:SetTexture(nil); value.Icon = nil; end
			if value.Count then value.Count:SetText(nil); value.Count = nil; end
			if valueSpellname then value.Spellname:SetText(nil); value.Spellname = nil; end
			if value then
				value:Hide()
			--	value:SetScript("OnUpdate", nil)
				value = nil
			end
		end
		wipe(VALUE)
	end
	wipe(self.Aura)
end

local function UpdateAuraFrame(KEY, name, icon, count, duration, expires, caster, id)
	local Frame = Module.Aura[KEY][Index[KEY]]
	if not Frame then return; end
	if Frame then Frame:Show() end
	if Frame.Icon then Frame.Icon:SetTexture(icon) end
	if Frame.Count then Frame.Count:SetText(count > 1 and count or nil) end
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(true)
		CooldownFrame_SetTimer(Frame.Cooldown, expires-duration, duration, 1)
	end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if id then Frame:SetID(id) end
	if KEY then Frame.key = KEY end
	Index[KEY] = Index[KEY] + 1
end

local function UpdateCDFrame(KEY, name, icon, start, duration, spellID)
	local Frame
	if Module.db.spellCD.alwaysShow then
		for i = 1, Module.db.spellCD.maxNum do
			local f = Module.Aura[KEY][i]
			if not f.SpellID then f.SpellID = spellID end
			if f.SpellID == spellID then
				Frame = f
				break;
			end
		end
	else
		Frame = Module.Aura[KEY][Index[KEY]]
	end
	
	if Frame then Frame:Show() else return; end
	if Frame.Icon then Frame.Icon:SetTexture(icon) end
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(false)
		CooldownFrame_SetTimer(Frame.Cooldown, start, duration, 1)
	end
	if Frame.Count then Frame.Count:SetText(nil) end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if KEY then Frame.key = KEY end
	if spellID then Frame.spellid = spellID end
	if not Module.db.spellCD.alwaysShow then Index[KEY] = Index[KEY] + 1 end
end

local SpecialSpellCD={
	[126734] = true,
	[109076] = true,
	[108788] = true,
	[82179] = true,
}

local function UpdateFrame()
	Index["playerBuff"] = 1
	Index["playerDebuff"] = 1
	Index["targetBuff"] = 1
	Index["targetDebuff"] = 1
--	Index["spellCD"] = 1
	if not Module.db.spellCD.alwaysShow then Index["spellCD"] = 1 end
	
	local spec = Module:GetSpecID()
	
	if not Module.db.playerBuff.useList[spec] then Module.db.playerBuff.useList[spec] = {} end
	if not Module.db.playerDebuff.useList[spec] then Module.db.playerDebuff.useList[spec] = {} end
	if not Module.db.targetBuff.useList[spec] then Module.db.targetBuff.useList[spec] = {} end
	if not Module.db.targetDebuff.useList[spec] then Module.db.targetDebuff.useList[spec] = {} end
	if not Module.db.spellCD.useList[spec] then Module.db.spellCD.useList[spec] = {} end
	
	if not Module.db.playerBuff.whiteList then Module.db.playerBuff.whiteList = {} end
	if not Module.db.playerDebuff.whiteList then Module.db.playerDebuff.whiteList = {} end
	if not Module.db.targetBuff.whiteList then Module.db.targetBuff.whiteList = {} end
	if not Module.db.targetDebuff.whiteList then Module.db.targetDebuff.whiteList = {} end	

	if Module.db.playerBuff.enable then
		local name, icon, count, duration, expires, caster, spellID, _
		local i = 1
		local db = Module.db.playerBuff.useList[spec]
		local db2 = Module.db.playerBuff.whiteList
		repeat
			name, icon, count, _, duration, expires, caster, _, _, spellID = UnitBuff('player', i)
			if (db[spellID] and db[spellID].enable and (not duration or (duration and duration <= 600)) and count >= db[spellID].count and (db[spellID].caster == caster or db[spellID].caster == 'any')) or db2[spellID] then	
				UpdateAuraFrame('playerBuff', name, icon, count, duration, expires, caster, i)	
			end
			i = i + 1
		until not name
	end
	
	if Module.db.playerDebuff.enable then
		local name, icon, count, duration, expires, caster, spellID, _
		local i = 1
		local db = Module.db.playerDebuff.useList[spec]
		local db2 = Module.db.playerDebuff.whiteList
		repeat
			name, icon, count, _, duration, expires, caster, _, _, spellID = UnitDebuff('player', i)
			if (db[spellID] and db[spellID].enable and count >= db[spellID].count and (db[spellID].caster == caster or db[spellID].caster == 'any')) or db2[spellID] then	
				UpdateAuraFrame('playerDebuff', name, icon, count, duration, expires, caster, i)	
			end
			i = i + 1
		until not name
	end	
	
	if Module.db.targetBuff.enable then
		local name, icon, count, duration, expires, caster, spellID, _
		local i = 1
		local db = Module.db.targetBuff.useList[spec]
		local db2 = Module.db.targetBuff.whiteList
		repeat
			name, icon, count, _, duration, expires, caster, _, _, spellID = UnitBuff('target', i)
			if LibClassicDurations then
				local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit('target', spellID, caster, name)

				if durationNew and durationNew > 0 then
					duration = durationNew
					expires = expirationTimeNew
				end
			end
			if (db[spellID] and db[spellID].enable and (not duration or (duration and duration <= 600)) and count >= db[spellID].count and (db[spellID].caster == caster or db[spellID].caster == 'any')) or db2[spellID] then	
				UpdateAuraFrame('targetBuff', name, icon, count, duration, expires, caster, i)	
			end
			i = i + 1
		until not name
	end	
	
	if Module.db.targetDebuff.enable then
		local name, icon, count, duration, expires, caster, spellID, _
		local i = 1
		local db = Module.db.targetDebuff.useList[spec]
		local db2 = Module.db.targetDebuff.whiteList
		repeat
			name, icon, count, _, duration, expires, caster, _, _, spellID = UnitDebuff('target', i)
			if LibClassicDurations then
				local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit('target', spellID, caster, name)

				if durationNew and durationNew > 0 then
					duration = durationNew
					expires = expirationTimeNew
				end
			end
			if (db[spellID] and db[spellID].enable and count >= db[spellID].count and (db[spellID].caster == caster or db[spellID].caster == 'any')) or db2[spellID] then	
				UpdateAuraFrame('targetDebuff', name, icon, count, duration, expires, caster, i)	
			end
			i = i + 1
		until not name
	end
	
	if Module.db.spellCD.enable then
		for k, v in pairs(Module.db.spellCD.useList[spec]) do
			if (GetInventoryItemID("player", 10)==k or GetSpellInfo(k)) and v and Module.db.spellCD.useList[spec][k] and not SpecialSpellCD[k] then
				if k == GetInventoryItemID("player", 10) and select(2, GetInventoryItemCooldown('player', 10)) > 1.5 then
					local start, duration = GetInventoryItemCooldown('player', 10)
					local icon = GetInventoryItemTexture('player', 10)
					local name = GetItemSpell(k)
					UpdateCDFrame('spellCD', name, icon, start, duration, k)
				elseif GetSpellCooldown(k) and select(2, GetSpellCooldown(k)) > 1.5 then
					local name,_, icon = GetSpellInfo(k)
					local start, duration = GetSpellCooldown(k)
					UpdateCDFrame('spellCD', name, icon, start, duration, k)
				end
					
				if Module.db.spellCD.alwaysShow then 

					for i = 1, Module.db.spellCD.maxNum do
						local Frame = Module.Aura['spellCD'][i]
						if Frame.SpellID == k then
							local cd
							if k == GetInventoryItemID("player", 10) then
								cd = select(2, GetInventoryItemCooldown('player', 10));
							else
								cd = select(2, GetSpellCooldown(k))
							end
							if cd > 1.5 then
								if Frame.overlay then
									if Frame.overlay.animIn:IsPlaying() then
										Frame.overlay.animIn:Stop()
									end
									Frame.overlay.animOut:Play()
									Frame.overlay = nil
								end
							elseif cd == 0 then
								if not Frame.overlay then createOverlay(Frame) end
								break;
							end
						end
					end
				end
			end
		end
		
	end
end

local function OnUpdate()
	CleanUp()
	UpdateFrame()
end

function Module:NoSpell(unitType, spellID)
	local spec = self:GetSpecID()
	if not self.db[unitType].whiteList then self.db[unitType].whiteList = {} end
	
	if self.db[unitType].useList[spec][spellID] == nil and self.db[unitType].whiteList[spellID] == nil then
		return true;
	else
		return false;
	end
end

local function calcCacheListNum(tableName, maxNum)
	local cacheNum = 0;
	for k, v in pairs(tableName) do
		cacheNum = cacheNum + 1;
	end
	if cacheNum > maxNum then wipe(tableName); end
end

local runNum = 0;--防止频繁调用占用CPU,调用100次后再运算
function Module:CacheAura(event, unit)
	if unit ~= 'player' and unit ~= 'target' then return; end
	if not unit then return; end
	local spec = self:GetSpecID();
	if not self.db[unit..'Buff'] then self.db[unit..'Buff'] = {}; end
	if not self.db[unit..'Debuff'] then self.db[unit..'Debuff'] = {}; end
	
	--缓存玩家,目标光环，并添加到可用列表中
	if not self.db[unit..'Buff'].useList[spec] then self.db[unit..'Buff'].useList[spec] = {} end
	if not self.db[unit..'Debuff'].useList[spec] then self.db[unit..'Debuff'].useList[spec] = {} end

	for i = 1, 40 do
		local name, icon, count, _, duration, expires, caster, _, _, spellID = UnitBuff(unit, i)
		if self:NoSpell(unit.. 'Buff', spellID) then
			if not spellID then break; end
			if caster == 'player' then
				self.db[unit..'Buff'].useList[spec][spellID] = {
					['enable'] = true,
					['count'] = 0,
					['caster'] = caster,
				}
			else
				runNum = runNum + 1
				if runNum > 100 then
					calcCacheListNum(self.db[unit..'Buff'].cacheList, self.db.maxCacheNum)
				end;
				self.db[unit..'Buff'].cacheList[spellID] = true;				
			end
		end
	end
	for i = 1, 40 do
		local name, icon, count, _, duration, expires, caster, _, _, spellID = UnitDebuff(unit, i)
		if self:NoSpell(unit.. 'Debuff', spellID) then
			if not spellID then break; end
			if caster == 'player' then
				self.db[unit..'Debuff'].useList[spec][spellID] = {
					['enable'] = true,
					['count'] = 0,
					['caster'] = caster,
				}
			else
				if unit == 'player' then
					if UnitClassification(caster) ~= 'normal' then caster = 'any' end --BOSS施加的DEBUFF,更改施法者为all
					self.db[unit..'Debuff'].useList[spec][spellID] = {
						['enable'] = true,
						['count'] = 0,
						['caster'] = caster,
					}
				else
					runNum = runNum + 1
					if runNum > 100 then
						runNum = 0;
						calcCacheListNum(self.db[unit..'Debuff'].cacheList, self.db.maxCacheNum)
					end
					self.db[unit..'Debuff'].cacheList[spellID] = true;
				end
			end
		end
	end	
end	

local function cacheSpellCD(spellID, isSlot)
	local spec = Module:GetSpecID()
	if not Module.db.spellCD.useList[spec] then Module.db.spellCD.useList[spec] = {} end
	
	if isSlot then
		local start, duration = GetInventoryItemCooldown('player', 10)
		if start and duration > 3 and duration < 900 and Module.db.spellCD.useList[spec][spellID] == nil then
			Module.db.spellCD.useList[spec][spellID] = true;
		end
		return;
	end
	
	if spellID then
		local start, duration = GetSpellCooldown(spellID);

		if start and duration > 3 and duration < 900 and Module.db.spellCD.useList[spec][spellID] == nil then
			Module.db.spellCD.useList[spec][spellID] = true;
		end
	end
end

function Module:CacheSpellCD(event, ...)
	local unit, spellname, rank, counter, spellID = ...
	if unit ~= 'player' then return; end
	--缓存玩家技能CD，并添加到可用列表中
	
	if SpecialSpellCD[spellID] then
		local slotID = GetInventoryItemID("player", 10)
		self:ScheduleTimer(cacheSpellCD, 0.5, slotID, true)
		return;
	end				
				
	if spellID then
		self:ScheduleTimer(cacheSpellCD, 0.5, spellID)
	end
end

function Module:UpdateOption()
	if not IsAddOnLoaded('ElvUI_Config') then return; end
	
	self:GenerateOptions()
end

function Module:GetSpecID()
	local spec = GetSpecialization()
	if not spec then
		spec = 0
	else
		spec = GetSpecializationInfo(GetSpecialization())
	end;
	return spec
end

function Module:SpellCD_Combat(event)
	if event == 'PLAYER_REGEN_ENABLED' then
		if self.db.spellCD.combat then
			for _, value in pairs(self.Aura['spellCD']) do
				if value then
					value:Hide()
				end
				if value.Icon then value.Icon:SetTexture(nil) end
				if value.Count then value.Count:SetText(nil) end
				if valueSpellname then value.Spellname:SetText(nil) end
			end
		end
		
		self:UpdateOption()
	else
		
		
	end
end

function Module:Toggle()
	if self.db.enable then 
		self:ScheduleRepeatingTimer(OnUpdate, 0.3)
		if self.db.learning then
			self:RegisterEvent("UNIT_AURA", "CacheAura")
			self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "CacheSpellCD")
		else
			self:UnregisterEvent("UNIT_AURA")
			self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")			
		end
		if self.db.spellCD.combat then
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED", "SpellCD_Combat")
			self:RegisterEvent("PLAYER_REGEN_ENABLED", "SpellCD_Combat")
		else
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
			self:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateOption")
		end
	--	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "UpdateOption");
	else
		self:CancelAllTimers()
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	--	self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED");	
	end
end

function Module:CreateAnchor()
	for k, v in pairs(self.db) do
		if type(v) == 'table' then
			local perRow, interval = v.perRow, v.interval
			local maxNum = v.maxNum
			local iconsize = v.iconSize
			if maxNum < perRow then
				perRow = maxNum;
			end
			
			if _G[k..'Anchor'] then _G[k..'Anchor'] = nil end
			local f = CreateFrame("Frame", k..'Anchor', E.UIParent)
			f:SetSize((iconsize * perRow + (perRow - 1) * interval), (math.ceil(maxNum / perRow) * iconsize + (math.ceil(maxNum / perRow) - 1) * interval));
			local p1, p2, p3, p4, p5 = unpack(v.pos)
			f:SetPoint(p1, _G[p2], p3, p4, p5)
			E:CreateMover(f, k..'AnchorMover', L['ALM'..k..'Monitor'], nil, nil, nil, 'ALL, EUI', nil, 'Watch,ALM', "db,ALM,enable")
		end
	end
end	

function Module:Initialize()
	if self.initialized then return end -- In case this gets called twice as can sometimes happen with ElvUI
	self.db = E.db["ALM"]
	
	self:Toggle();
	self:CreateAnchor()
	self:BuildAura()
	self:UpdatePos()
	
	calcCacheListNum(self.db['playerBuff'].cacheList, self.db.maxCacheNum)
	calcCacheListNum(self.db['targetBuff'].cacheList, self.db.maxCacheNum)
	calcCacheListNum(self.db['playerDebuff'].cacheList, self.db.maxCacheNum)
	calcCacheListNum(self.db['targetDebuff'].cacheList, self.db.maxCacheNum)	
end

E:RegisterModule(Module:GetName())