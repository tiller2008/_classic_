local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local R = E:NewModule('RLBox', 'AceEvent-3.0', 'AceTimer-3.0')
RLBox = R

local LibGroupInspect = LibStub("LibGroupInSpecT-1.1")
if not LibGroupInspect then return; end

local WPCache = {}
local WHISPERMSG = "EUI:".. L["Group %s has been casted and ending in %d seconds, Prepare!"];
local SPELLID_SOULSTONERESURRECTION = 20707
local SPELLID_SOULSTONERESURRECTION_WHENDEAD = 95750
local castMsg = "EUI:%s ".. L['Casted'].." \124cff71d5ff\124Hspell:%d\124h[%s]\124h\124r!"..L['Duration']..":%ss";
local readyMsg = "EUI:%s 's \124cff71d5ff\124Hspell:%d\124h[%s]\124h\124r ".. READY..'!';
local OFFLINETEXTURE = 137007;

local len, gmatch, tsort, ceil, format, floor = string.len, string.gmatch, table.sort, math.ceil, string.format, math.floor
local pairs, tostring, unpack, tonumber, select = pairs, tostring, unpack, tonumber, select
local IsInInstance = IsInInstance
local GetInstanceInfo = GetInstanceInfo
local GetNumGroupMembers = GetNumGroupMembers
local GetNumSubgroupMembers = GetNumSubgroupMembers
local UnitGUID = UnitGUID
local UnitFactionGroup = UnitFactionGroup
local UnitName = UnitName
local UnitLevel = UnitLevel
local UnitRace = UnitRace
local IsPartyLFG = IsPartyLFG
local GetSpellInfo = GetSpellInfo
local CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS
local SendChatMessage = SendChatMessage
local collectgarbage = collectgarbage

local PLAYER_IS_WARLOCK
local unusedOverlays = {}
local RCOLOR = {
	{.31,.31,.31},
	{234/255,18/255,0},
	{234/255,134/255,0},
	{233/255,220/255,0},
	{146/255,232/255,2/255},
	{0,233/255,24/255},
	{2/255,233/255,174/255},
	{2/255,146/255,232/255},
	{226/255,2/255,232/255},
	{1,1,1}
}
local REQUIREMENT_KEYS = {
	--note that class isn't a requirement because it's specified by the spell
	PLAYER_LEVEL	= 10,
	PLAYER_NAMES	= 15,
	PLAYER_RACE		= 20,
	TALENT_NAME		= 25,
	TALENT_SPEC		= 30,
}
local ADJUSTMENT_KEYS = {
	PLAYER_NAME		= 5,
	PLAYER_LEVEL	= 10,
	TALENT_NAME		= 25,
	TALENT_SPEC		= 30,
}

local function FormatTime(time)
	if time >= 60 then
		return format("%.2d:%.2d", floor(time / 60), time % 60)
	else
		return format("%.2d", time)
	end
end

local function BuildPlayerList(guid, info, unit)
	if not R.Players[guid] then
		R.Players[guid] = {}
	end

	local player = R.Players[guid]
	player.info = info
	player.guid = guid
	player.name = info.name
	player.realm = info.realm
	player.class = info.class
	player.unit = unit
	
	return player
end

local function GetKVTableLength(tab)
	if not tab then return; end
	local num = 0
	for k, v in pairs(tab) do
		num = num + 1
	end
	
	return num
end

local function GetSpellDuration(spellID)
	if spellID and E.global.RLBox.SPELL_MONITOR_SCHEMA.spellmetadata[spellID] and E.global.RLBox.SPELL_MONITOR_SCHEMA.spellmetadata[spellID].duration then
		return tonumber(E.global.RLBox.SPELL_MONITOR_SCHEMA.spellmetadata[spellID].duration)
	end
	return -1
end

local function CheckUnitIsOut(unit)
	if not unit then return true; end
	
	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
	local raidNum = GetNumGroupMembers()
	if inInstance and instanceType == "raid" then raidNum = maxPlayers end	
	
	if unit and unit:find('raid') and tonumber(string.sub(unit, 5))>raidNum then return true; end
	
	return false;
end

local function ConvertSpellIdIfSoulstone(spellID)
	if spellID == SPELLID_SOULSTONERESURRECTION or spellID == SPELLID_SOULSTONERESURRECTION_WHENDEAD then
		return SPELLID_SOULSTONERESURRECTION
	else
		return spellID
	end
end

local function GetUnitFromName(name, guid) --改为GUID判断识别玩家
	if IsInRaid() then
		local numRaidMembers = GetNumGroupMembers()
		for i = 1, numRaidMembers do
			local unit = "raid"..i
			if UnitGUID(unit) == guid then
				return unit
			end
		end
	elseif UnitInParty("player") then
		local numPartyMembers = GetNumSubgroupMembers()

		for i = 1, numPartyMembers do
			local unit = "party"..i
			if UnitGUID(unit) == guid then
				return unit
			end
		end
	else
		if UnitGUID('player') == guid then
			return 'player'
		end
		--error("this function wasn't supposed to be called while not in a group. Please report to author")
	end
	
	return nil
end

local function CheckAlliance(unit, alliance)
	local playerAlliance = select(1, UnitFactionGroup('player'))
	if not alliance or playerAlliance == alliance or alliance == 'NONE' then
		return true
	else
		return false
	end
end

local function CheckName(unit, name)
	return UnitName(unit) == name
end

local function CheckNames(unit, names)
	if not names then return true end
	if len(names) == 0 then return true end
	
	for v in gmatch(names, "[^ ]+") do
		if CheckName(unit, v) == true then
			return true
		end
	end
	
	return false
end

local function CheckLevel(unit, level)
	return UnitLevel(unit) >= level
end

local function CheckRace(unit, race)
	return UnitRace(unit) == race
end

local function IsTalentAvailable(guid, talent_id)
	local info = LibGroupInspect:GetCachedInfo(guid)
	if not info then return false end -- We're still waiting to get this data
	local available = false

	for key, spellInfo in pairs(info.talents) do
		if (spellInfo.talent_id == talent_id) then
			available = true
			break
		end
	end

	return available;
end

local function GetPrimarySpecializationForGuid(guid)
	local info = LibGroupInspect:GetCachedInfo(guid);
	if not info then return nil end -- We're still waiting to get this data
	
	return info.global_spec_id;
end

local function CheckTalentName(guid, talent_id)
	if not talent_id or talent_id == 0 then return; end
	local available = IsTalentAvailable(guid, talent_id);
	return available;
end

local function CheckTalentSpec(guid, specializationId, specializationId2)
	if not specializationId or specializationId == 0 then return true; end
	local specId = GetPrimarySpecializationForGuid(guid) --returns the name of the primary talent tree

	return ((specId == specializationId) or (specId == specializationId2))
end

local function CheckRequirement(guid, unit, requirement)
	if requirement.k == REQUIREMENT_KEYS.PLAYER_LEVEL then
		return CheckLevel(unit, requirement.level)
		
	elseif requirement.k == REQUIREMENT_KEYS.PLAYER_RACE then
		return CheckRace(unit, requirement.race)
	
	elseif requirement.k == REQUIREMENT_KEYS.PLAYER_NAMES then
		return CheckNames(unit, requirement.names)
		
	elseif requirement.k == REQUIREMENT_KEYS.TALENT_NAME then
		if (requirement.talent_id ~= nil) then
			return CheckTalentName(guid, requirement.talent_id)
		end
		
	elseif requirement.k == REQUIREMENT_KEYS.TALENT_SPEC then
		return CheckTalentSpec(guid, requirement.specialization, requirement.specialization2)		
	end
end

local function CheckSpellRequirements(guid, unit, spellid, specid, specidx)
	--if we make it through all of the requirements without one returning nil, then return success
	if specid then
		if not CheckTalentSpec(guid, specid) then
			return nil
		end
	end
	if specidx then
		if (not CheckTalentName(guid, specidx)) then
			return nil
		end
	end
	for reqSpellId, reqs in pairs(E.global.RLBox.SPELL_MONITOR_SCHEMA.requirements) do
		if reqSpellId == spellid then
			for reqindex, req in pairs(reqs) do
				if not CheckRequirement(guid, unit, req) then
					return nil
				end
			end
		end
	end
	
	return 1
end

local function GetAdjustmentOffset(unit, guid, adjustment)

	if adjustment.k == ADJUSTMENT_KEYS.PLAYER_NAME then
		if CheckName(unit, adjustment.name) == true then
			return adjustment.o
		end
		
	elseif adjustment.k == ADJUSTMENT_KEYS.PLAYER_LEVEL then
		if CheckLevel(unit, adjustment.level) == true then
			return adjustment.o
		end
		
	elseif adjustment.k == ADJUSTMENT_KEYS.TALENT_NAME then
		if CheckTalentName(unit, adjustment.talentIndex) == true then
			return adjustment.o
		end
		
	elseif adjustment.k == ADJUSTMENT_KEYS.TALENT_SPEC then
		if CheckTalentSpec(guid, adjustment.specialization) == true then
			return adjustment.offset
		end
	end
	
	return nil --no offset
end

local function GetAdjustedDuration(unit, guid, spellid, duration)
	local adjusted = duration
	--if we make it through all of the requirements without one returning nil, then return success
	for adjSpellId, adjs in pairs(E.global.RLBox.SPELL_MONITOR_SCHEMA.adjustments) do
		if adjSpellId == spellid then
			--loop through the adjustments of this spell
			for adjindex, adj in pairs(adjs) do
				local offset = GetAdjustmentOffset(unit, guid, adj)
				
				if offset then
					adjusted = adjusted + offset
				end
			end
		end
	end

	return adjusted
end

local function createOverlay(btn)
	local isize = btn:GetWidth()
	local overlay = tremove(unusedOverlays)
	if not overlay then
		overlay = CreateFrame("Frame", nil, btn, "RLBoxSpellActivationAlert")
	end
	overlay:ClearAllPoints()
	overlay:SetParent(btn)
	overlay:SetAlpha(0.7)
	overlay:SetPoint("TOPLEFT", btn, "TOPLEFT", -isize * 0.4, isize * 0.4)
	overlay:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", isize * 0.4, -isize * 0.4);
	btn.overlay = overlay
	overlay.animIn:Play()
end

function R:OverlayGlowAnimOutFinished(animGroup)
    local overlay = animGroup:GetParent()
    overlay:Hide()
    tinsert(unusedOverlays, overlay)
end

function R:BuildPlayerSpellCache(player, guid)
	if player.spellcache then wipe(player.spellcache) end player.spellcache = {}
	local unit = GetUnitFromName(player.name, guid)
	
	if not unit then
		--error("GetUnitFromName returned nil")
		return nil --something wrong happened, just return as though they didn't meet requirement. I've seen this before after reloading UI while in a raid
	end 

	for i = 1, 3 do
		local anchor = _G['EUIRaidToolBox'..i]
		local tmptable
		if anchor then
			if anchor.ID == 1 then
				tmptable = E.global.RLBox.DEFAULT_SPELLS
			end
			if anchor.ID == 2 then
				tmptable = E.global.RLBox.OTHER_SPELLS
			end
			if anchor.ID == 3 then
				tmptable = E.global.RLBox.MISC_SPELLS
			end
			for _, spell in pairs(tmptable) do
				local class = spell[1]
				local spellid = spell[2]
				local enabled = spell[3]
				local alliance = spell[4]
				local cooldown = spell[5]
				local specid = spell[6]
				local specidx = spell[7]

				if enabled and (class == "ANY" or class == player.class) and CheckSpellRequirements(guid, unit, spellid, specid, specidx) and CheckAlliance(unit, alliance) then
					-- local name, rank, icon, cost, funnel, powerType, castTime, minRange, maxRange = GetSpellInfo(spell.id);
					--spells without a base duration are NOT followed through with
					local cds = cooldown or E.global.RLBox.SPELL_MONITOR_SCHEMA.cooldowns[spellid]
					if cds then --dbg.classes[player.class] then
						local duration = GetAdjustedDuration(unit, guid, spellid, cds)
						player.spellcache[spellid] = duration
					end
				end
			end
		end
	end
end

function R:GroupInSpecT_Update(event, guid, unit, info)	
	if info and info.name and info.class_id then
		local player = BuildPlayerList(guid, info, unit)
		R:BuildPlayerSpellCache(player, guid)
		R:CalcBarsNum()
	end
end

function R:GroupInSpecT_Remove(guid)
	if R.Players[guid] and R.Players[guid].name then
		R.Players[guid] = nil
	end
end

local function StopTimer(icon)
	icon.right:SetText(' ')
	icon.bar:SetValue(0)
	icon.bar:SetScript("OnUpdate", nil)
	WPCache['p'..icon.partyno] = false
	icon:GetNormalTexture():SetDesaturated(false);	
	if icon.overlay then
		if icon.overlay.animIn:IsPlaying() then
			icon.overlay.animIn:Stop()
		end
		icon.overlay.animOut:Play()
		icon.overlay = nil
	end
end

local function OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddDoubleLine(self.partytext:GetText()..self.left:GetText()..'-'..self.spellname, self.right:GetText())
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local function OnLeave(self)
	GameTooltip:Hide()
end

local function OnMouseDown(self, button)
	if button == "LeftButton" then
		local channel = self.StartChannel
		if not channel or channel == 'NONE' then return; end
		if channel == 'RAID' and IsPartyLFG() then channel = 'INSTANCE_CHAT' end
		SendChatMessage(format("EUI:%s: %s", (self.partytext:GetText() or ' ')..(self.left:GetText() or ' ')..'-'..(self.spellname or ' '), self.right:GetText() or ' '), channel)
	elseif button == "RightButton" then
		StopTimer(self)
	end
end

local function PostionBar(anchor, DB)
	if anchor and anchor.Bars and #anchor.Bars > 0 then
		if R.db.party then
			tsort(anchor.Bars, function(a, b)
				return a.partyno < b.partyno
			end)
		else
			tsort(anchor.Bars, function(a, b)
				return a.spellid < b.spellid
			end)
		end
		
		local perrow = ceil(1 + #anchor.Bars /2)
		if perrow < DB.minperrow then perrow = DB.minperrow end
		
		
		if R.db.UIType == 'bar' then
			for i = 1, #anchor.Bars do
				local Icon = anchor.Bars[i]
				Icon:ClearAllPoints()
				if i == 1 then
					Icon:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 2, -6)
				elseif (i % perrow) == 0 then
					Icon:SetPoint("LEFT", anchor.Bars[1].bar, "RIGHT", 6, DB.BarHeight + 2)
				else
					Icon:SetPoint("TOP", anchor.Bars[i-1], "BOTTOM", 0, -6)
				end
			end
		else
			for i = 1, #anchor.Bars do
				local Icon = anchor.Bars[i]
				Icon:ClearAllPoints()
				local lastColumnButton = anchor.Bars[i-DB.rownums]
				
				if i == 1 then
					Icon:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 2, -6)
				elseif (i-1) % DB.rownums == 0 then
					Icon:SetPoint("TOP", lastColumnButton, "BOTTOM", 0, -(DB.FontSize + 6))
				else
					Icon:SetPoint("LEFT", anchor.Bars[i-1], "RIGHT", DB.IconSize/3, 0)
				end
			end
		end
	end
end

local function CalcMaxPartyNO()--查询现有减伤条中最大的分组号
	local no = 1
	local anchor = _G['EUIRaidToolBox1']
	if anchor.Bars and #anchor.Bars > 0 then
		for k = 1, #anchor.Bars -1 do
			local icon = anchor.Bars[k]
			no = icon.partyno > no and icon.partyno or no
		end
	end

	return no
end

local function SendCooldownInfo(partyno, wpTime)--向下一组分组的成员发送密语信息，如果已是最大组则向第一组发送
	local anchor = _G['EUIRaidToolBox1']
	if anchor.Bars and #anchor.Bars > 0 then
		for i = 1, #anchor.Bars -1 do
			local icon = anchor.Bars[i]
			local target = icon.playername
			local realm = icon.realm
			if realm and realm ~= GetRealmName() then
				target = target..'-'..realm
			end
			local msg = format(WHISPERMSG, partyno, wpTime)
			if (icon.partyno == partyno + 1) or (partyno > 1 and partyno == CalcMaxPartyNO() and icon.partyno == 1) then
				if icon.curtex ~= OFFLINETEXTURE then
					SendChatMessage(msg, "WHISPER", nil, target)
				end
			end
		end
	end
end

local function iconOnUpdate(self)
	if self.endTime and self.duration then
		local time = GetTime();
		if (time > self.endTime) then
			self.endTime = nil
			self.duration = nil
			self.durationtext:SetText(' ')
			if R.db.UIType == 'icon' and self.overlay then
				if self.overlay.animIn:IsPlaying() then
					self.overlay.animIn:Stop()
				end
				self.overlay.animOut:Play()
				self.overlay = nil
			end
		else
			local remaining = format('%d', self.endTime - time)
			self.durationtext:SetText(remaining)
			if not WPCache['p'..self.partyno] and E.db.RLBox.wpTime > 0 and tonumber(remaining) == E.db.RLBox.wpTime then
				SendCooldownInfo(self.partyno, E.db.RLBox.wpTime)
				WPCache['p'..self.partyno] = true
			end
			if R.db.UIType == 'icon' and not self.overlay then self:CreateOverlay(); end
		end
	end
	
	local unit = GetUnitFromName(self.playername, self.guid)
	if unit and (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
		if self.curtex ~= OFFLINETEXTURE then
			self:SetNormalTexture(OFFLINETEXTURE)
			self:GetNormalTexture():SetTexCoord(0.5, 0.75, 0.25, 0.5)
			self.curtex = OFFLINETEXTURE
		end
	else
		if self.curtex ~= self.oldicon then
			self:SetNormalTexture(self.oldicon)
			self:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
			self.curtex = self.oldicon
		end
	end
	
	if self.curtex == OFFLINETEXTURE then
	--	E:StopFlash(self)
		E:Flash(self, 1.2)
	else
		E:StopFlash(self)
	end
end

function R:UpdateBoxUI(anchor, toggle)
	if not anchor then return; end
	
	if InCombatLockdown() then
		E:Print(L["ATTENTION_TIP4"]);
		return;
	end
	
	if #anchor.Bars > 0 then
		for n = 1, #anchor.Bars do
			if anchor.Bars[n] then
				anchor.Bars[n]:Hide()
				if toggle then StopTimer(anchor.Bars[n]) end
			--	anchor.Bars[n] = nil
			end
		end
		wipe(anchor.Bars)
	end
	
	local tmptable, DB
	if anchor.ID == 1 then
		tmptable = E.global.RLBox.DEFAULT_SPELLS
		DB = R.db.DEFAULT
	end
	if anchor.ID == 2 then
		tmptable = E.global.RLBox.OTHER_SPELLS
		DB = R.db.OTHER
	end
	if anchor.ID == 3 then
		tmptable = E.global.RLBox.MISC_SPELLS
		DB = R.db.MISC
	end
	
	local barid = 0
	for i, default in pairs(tmptable) do
		local class = default[1]
		local spellid = default[2]
		local enabled = default[3]
		local alliance = default[4]
		local cooldown = default[5]
		local title,_, icon = GetSpellInfo(spellid)
		if not class then class = "PRIEST" end
		
		local color = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class])
		
		if enabled then


			for playerGuid, player in pairs(R.Players) do
				local unit = GetUnitFromName(player.name, playerGuid)
			--	local cds = cooldown or player.spellcache[spellid]
				local cds = player.spellcache[spellid]
				if cds and CheckAlliance(alliance) and not CheckUnitIsOut(unit) and class == player.class then
					barid = barid + 1
					local Icon
					if R.db.UIType == 'bar' then
						Icon = R:CreateIconBar(anchor, barid, DB);
					else
						Icon = R:CreateIconModule(anchor, barid, DB);
					end
					Icon.left:SetText(E:ShortenString(player.name, R.db.UIType == 'bar' and 4 or 2))
					Icon.left:SetTextColor(color.r, color.g, color.b)
					Icon:SetNormalTexture(icon)
					Icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
					Icon.cds = cds
					Icon.oldicon = icon
					Icon.curtex = icon
					Icon.spellname = title
					Icon.spellid = spellid
					Icon.guid = playerGuid
					Icon.playername = player.name
					Icon.realm = player.realm
					Icon.StartChannel = DB.sendStartMsg
					Icon.EndChannel = DB.sendEndMsg					
					Icon:SetScript("OnUpdate", iconOnUpdate)

					Icon.bar:SetMinMaxValues(0, cds)
					Icon.bar:SetValue(0)					
					Icon.bar:SetStatusBarColor(color.r, color.g, color.b)
					Icon.bar.bg:SetVertexColor(color.r, color.g, color.b, 0.25)
					Icon:Show()

					tinsert(anchor.Bars, Icon)
				end
			end
		end
	end

	anchor.title:SetText(L['EUIRaidToolBox'..anchor.ID]..': '..#anchor.Bars..'/'..#anchor.Bars)
	PostionBar(anchor, DB)
end

function R:CreateIconBar(parent, id, DB)
	if _G["EUIRLBox"..parent:GetName().."Icon"..id] then
		local icon = _G["EUIRLBox"..parent:GetName().."Icon"..id]
		
		icon:Size(DB.IconSize)
		icon.durationtext:FontTemplate(nil, DB.IconSize -6 , 'OUTLINE')
		icon.bar:Size(DB.BarWidth, DB.BarHeight)
		icon.right:FontTemplate(nil, DB.FontSize, 'OUTLINE')
		icon.left:FontTemplate(nil, DB.FontSize, 'OUTLINE')
		if icon.add then icon.add:Size(floor(DB.IconSize/2)) end
		if icon.sut then icon.sut:Size(floor(DB.IconSize/2)) end
		icon.partytext:FontTemplate(nil, DB.FontSize-2, 'OUTLINE')
		
		return _G["EUIRLBox"..parent:GetName().."Icon"..id];
	end

	local icon = CreateFrame("Button", "EUIRLBox"..parent:GetName().."Icon"..id, parent)
	icon:Size(DB.IconSize)
	icon.id = id
	icon.spellname = ' '
	
	icon.backdrop = CreateFrame("Frame", nil, icon)
	icon.backdrop:Point("TOPLEFT", -2, 2)
	icon.backdrop:Point("BOTTOMRIGHT", 2, -2)
	icon.backdrop:SetTemplate()
	icon.backdrop:SetFrameStrata("BACKGROUND")
	
	icon.partyno = 1
	
	icon.durationtext = icon:CreateFontString(nil, 'OVERLAY')
	icon.durationtext:FontTemplate(nil, DB.IconSize -6 , 'OUTLINE')
	icon.durationtext:SetText('')
	icon.durationtext:SetPoint('CENTER')
	icon.durationtext:SetJustifyH('CENTER')
	icon.durationtext:SetTextColor(1, 0.5, 0)
	
	icon.bar = CreateFrame("Statusbar", nil, icon)
	icon.bar:SetFrameStrata("LOW")
	icon.bar:Size(DB.BarWidth, DB.BarHeight)
	icon.bar:SetStatusBarTexture(E["media"].normTex)
	icon.bar:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", 6, 0)
	icon.bar:SetOrientation("HORIZONTAL")
	
	icon.bar.backdrop = CreateFrame("Frame", nil, icon.bar)
	icon.bar.backdrop:Point("TOPLEFT", -2, 2)
	icon.bar.backdrop:Point("BOTTOMRIGHT", 2, -2)
	icon.bar.backdrop:SetTemplate()
	icon.bar.backdrop:SetFrameStrata("BACKGROUND")

	icon.bar.bg = icon.bar:CreateTexture(nil, "BACKGROUND")
	icon.bar.bg:SetAllPoints(icon.bar)
	icon.bar.bg:SetTexture(E["media"].glossTex)

	if R.db.party then
		icon.add = CreateFrame("Button", nil, icon)
		icon.add:Size(floor(DB.IconSize/2))
		icon.add:Point('BOTTOMRIGHT', icon.bar, 'TOPRIGHT', -floor(DB.IconSize/2), 4)	
		icon.add:SetTemplate('Transparent')
		icon.add:StyleButton()
		icon.add:SetFrameLevel(icon:GetFrameLevel() + 2)
		icon.add.text = icon.add:CreateFontString(nil, 'OVERLAY')
		icon.add.text:FontTemplate()
		icon.add.text:SetText('+')
		icon.add.text:SetPoint('CENTER')
		icon.add.text:SetJustifyH('CENTER')
		icon.add:SetScript('OnClick', function(self) 
			local icon = self:GetParent()
			icon.partyno = icon.partyno +1;
			if icon.partyno > 10 then icon.partyno = 10 end
			
			icon.partytext:SetText(tostring(icon.partyno)..'-')
			icon.partytext:SetTextColor(unpack(RCOLOR[icon.partyno]))
			icon.backdrop:SetBackdropBorderColor(unpack(RCOLOR[icon.partyno]))
		end)
		icon.add:SetAlpha(0)
		icon.add:SetScript("OnEnter", function(self)
			E:UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
			E:UIFrameFadeIn(self:GetParent().sut, 0.2, self:GetParent().sut:GetAlpha(), 1)
		end)
		icon.add:SetScript("OnLeave", function(self)
			E:UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
			E:UIFrameFadeOut(self:GetParent().sut, 0.2, self:GetParent().sut:GetAlpha(), 0)
		end)
		
		icon.sut = CreateFrame("Button", nil, icon)
		icon.sut:Size(floor(DB.IconSize/2))
		icon.sut:Point('BOTTOMRIGHT', icon.bar, 'TOPRIGHT', 2, 4)	
		icon.sut:SetTemplate('Transparent')
		icon.sut:StyleButton()
		icon.sut:SetFrameLevel(icon:GetFrameLevel() + 2)
		icon.sut.text = icon.sut:CreateFontString(nil, 'OVERLAY')
		icon.sut.text:FontTemplate()
		icon.sut.text:SetText('-')
		icon.sut.text:SetPoint('CENTER')
		icon.sut.text:SetJustifyH('CENTER')
		icon.sut:SetScript('OnClick', function(self) 
			local icon = self:GetParent()
			icon.partyno = icon.partyno -1;
			if icon.partyno < 1 then icon.partyno = 1 end	
			
			icon.partytext:SetText(tostring(icon.partyno)..'-')
			icon.partytext:SetTextColor(unpack(RCOLOR[icon.partyno])) 
			icon.backdrop:SetBackdropBorderColor(unpack(RCOLOR[icon.partyno]))

		end)
		icon.sut:SetAlpha(0)
		icon.sut:SetScript("OnEnter", function(self)
			E:UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
			E:UIFrameFadeIn(self:GetParent().add, 0.2, self:GetParent().add:GetAlpha(), 1)
		end)
		icon.sut:SetScript("OnLeave", function(self)
			E:UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
			E:UIFrameFadeOut(self:GetParent().add, 0.2, self:GetParent().add:GetAlpha(), 0)
		end)
	end
	
	icon.right = icon.bar:CreateFontString(nil, "OVERLAY")
	icon.right:FontTemplate(nil, DB.FontSize, 'OUTLINE')
	icon.right:Point("BOTTOMRIGHT", icon.bar, "TOPRIGHT", 1, 3)
	icon.right:SetJustifyH("RIGHT")
	icon.right:SetText(' ')
	
	icon.left = icon.bar:CreateFontString(nil, "OVERLAY")
	icon.left:FontTemplate(nil, DB.FontSize, 'OUTLINE')
	icon.left:Point("BOTTOMLEFT", icon.bar, "TOPLEFT", 8, 3)
	icon.left:SetJustifyH("CENTER")	
	icon.left:SetText(' ')

	icon.partytext = icon.bar:CreateFontString(nil, "OVERLAY")
	icon.partytext:FontTemplate(nil, DB.FontSize-2, 'OUTLINE')
	icon.partytext:SetPoint("BOTTOMLEFT", icon.bar, "TOPLEFT", -2, 3)
	icon.partytext:SetJustifyH('LEFT')
	icon.partytext:SetText('1-')
	icon.partytext:SetTextColor(unpack(RCOLOR[1]))
	icon.backdrop:SetBackdropBorderColor(unpack(RCOLOR[1]))
		
	icon:SetScript("OnEnter", OnEnter)
	icon:SetScript("OnLeave", OnLeave)
	icon:SetScript("OnMouseDown", OnMouseDown)
	
	return icon
end

function R:CreateIconModule(parent, id, DB)
	if _G["EUIRLBox"..parent:GetName().."IconModule"..id] then
		local icon = _G["EUIRLBox"..parent:GetName().."IconModule"..id]
		
		icon:Size(DB.IconSize)
		icon.durationtext:FontTemplate(nil, DB.IconSize -6 , 'OUTLINE')
		icon.bar:Size(6, DB.IconSize)
		if icon.add then icon.add:Size(floor(DB.IconSize/2)) end
		if icon.sut then icon.sut:Size(floor(DB.IconSize/2)) end
		icon.right:FontTemplate(nil, DB.FontSize, 'OUTLINE')
		icon.left:FontTemplate(nil, DB.FontSize, 'OUTLINE')
		icon.partytext:FontTemplate(nil, DB.FontSize, 'OUTLINE')
		
		return _G["EUIRLBox"..parent:GetName().."IconModule"..id];
	end

	local icon = CreateFrame("Button", "EUIRLBox"..parent:GetName().."IconModule"..id, parent)
	icon:Size(DB.IconSize)
	icon.id = id
	icon.spellname = ' '
	icon.CreateOverlay = createOverlay
	
	icon.backdrop = CreateFrame("Frame", nil, icon)
	icon.backdrop:Point("TOPLEFT", -2, 2)
	icon.backdrop:Point("BOTTOMRIGHT", 2, -2)
	icon.backdrop:SetTemplate()
	icon.backdrop:SetFrameStrata("BACKGROUND")
	
	icon.partyno = 1
	
	icon.durationtext = icon:CreateFontString(nil, 'OVERLAY')
	icon.durationtext:FontTemplate(nil, DB.IconSize -6 , 'OUTLINE')
	icon.durationtext:SetText('')
	icon.durationtext:SetPoint('CENTER')
	icon.durationtext:SetJustifyH('CENTER')
	icon.durationtext:SetTextColor(1, 0.5, 0)
	
	icon.bar = CreateFrame("Statusbar", nil, icon) --图标模式下不显示计时条
	icon.bar:SetFrameStrata("LOW")
	icon.bar:Size(6, DB.IconSize)
	icon.bar:SetStatusBarTexture(E["media"].normTex)
--	icon.bar:SetPoint("LEFT", icon, "RIGHT", 2, 0)
	icon.bar:SetOrientation("VERTICAL")--HORIZONTAL

	icon.bar.backdrop = CreateFrame("Frame", nil, icon.bar)
	icon.bar.backdrop:Point("TOPLEFT", -2, 2)
	icon.bar.backdrop:Point("BOTTOMRIGHT", 2, -2)
	icon.bar.backdrop:SetTemplate()
	icon.bar.backdrop:SetFrameStrata("BACKGROUND")

	icon.bar.bg = icon.bar:CreateTexture(nil, "BACKGROUND")
	icon.bar.bg:SetAllPoints(icon.bar)
	icon.bar.bg:SetTexture(E["media"].glossTex)

	if R.db.party then
		icon.add = CreateFrame("Button", nil, icon)
		icon.add:Size(floor(DB.IconSize/2))
		icon.add:Point('TOPLEFT', icon, 'TOPLEFT', 1, -1)	
		icon.add:SetTemplate('Transparent')
		icon.add:StyleButton()
		icon.add:SetFrameLevel(icon:GetFrameLevel() + 2)
		icon.add.text = icon.add:CreateFontString(nil, 'OVERLAY')
		icon.add.text:FontTemplate()
		icon.add.text:SetText('+')
		icon.add.text:SetPoint('CENTER')
		icon.add.text:SetJustifyH('CENTER')
		icon.add:SetScript('OnClick', function(self) 
			local icon = self:GetParent()
			icon.partyno = icon.partyno +1;
			if icon.partyno > 10 then icon.partyno = 10 end
			
			icon.partytext:SetText(tostring(icon.partyno)..'-')
			icon.partytext:SetTextColor(unpack(RCOLOR[icon.partyno]))
			icon.backdrop:SetBackdropBorderColor(unpack(RCOLOR[icon.partyno]))
		end)
		icon.add:SetAlpha(0)
		icon.add:SetScript("OnEnter", function(self)
			E:UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
			E:UIFrameFadeIn(self:GetParent().sut, 0.2, self:GetParent().sut:GetAlpha(), 1)
		end)
		icon.add:SetScript("OnLeave", function(self)
			E:UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
			E:UIFrameFadeOut(self:GetParent().sut, 0.2, self:GetParent().sut:GetAlpha(), 0)
		end)
		
		icon.sut = CreateFrame("Button", nil, icon)
		icon.sut:Size(floor(DB.IconSize/2))
		icon.sut:Point('BOTTOMLEFT', icon, 'BOTTOMLEFT', 1, 1)	
		icon.sut:SetTemplate('Transparent')
		icon.sut:StyleButton()
		icon.sut:SetFrameLevel(icon:GetFrameLevel() + 2)
		icon.sut.text = icon.sut:CreateFontString(nil, 'OVERLAY')
		icon.sut.text:FontTemplate()
		icon.sut.text:SetText('-')
		icon.sut.text:SetPoint('CENTER')
		icon.sut.text:SetJustifyH('CENTER')
		icon.sut:SetScript('OnClick', function(self) 
			local icon = self:GetParent()
			icon.partyno = icon.partyno -1;
			if icon.partyno < 1 then icon.partyno = 1 end	
			
			icon.partytext:SetText(tostring(icon.partyno)..'-')
			icon.partytext:SetTextColor(unpack(RCOLOR[icon.partyno])) 
			icon.backdrop:SetBackdropBorderColor(unpack(RCOLOR[icon.partyno]))

		end)
		icon.sut:SetAlpha(0)
		icon.sut:SetScript("OnEnter", function(self)
			E:UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
			E:UIFrameFadeIn(self:GetParent().add, 0.2, self:GetParent().add:GetAlpha(), 1)
		end)
		icon.sut:SetScript("OnLeave", function(self)
			E:UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
			E:UIFrameFadeOut(self:GetParent().add, 0.2, self:GetParent().add:GetAlpha(), 0)
		end)
	end
	
	icon.right = icon:CreateFontString(nil, "OVERLAY")
	icon.right:FontTemplate(nil, DB.FontSize, 'OUTLINE')
	icon.right:Point("CENTER", icon, "CENTER", 0, 0)
	icon.right:SetJustifyH("CENTER")
	icon.right:SetText(' ')
	icon.right:SetTextColor(1, 0.1, 0)
	
	icon.left = icon:CreateFontString(nil, "OVERLAY")
	icon.left:FontTemplate(nil, DB.FontSize, 'OUTLINE')
	icon.left:Point("TOP", icon, "BOTTOM", 0, -3)
	icon.left:SetJustifyH("CENTER")	
	icon.left:SetText(' ')

	icon.partytext = icon:CreateFontString(nil, "OVERLAY")
	icon.partytext:FontTemplate(nil, DB.FontSize, 'OUTLINE')
	if R.db.party then
		icon.partytext:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT", 0, 0)
	end
	icon.partytext:SetJustifyH('LEFT')
	icon.partytext:SetText('1-')
	icon.partytext:SetTextColor(unpack(RCOLOR[1]))
	icon.backdrop:SetBackdropBorderColor(unpack(RCOLOR[1]))

	icon:SetScript("OnEnter", OnEnter)
	icon:SetScript("OnLeave", OnLeave)
	icon:SetScript("OnMouseDown", OnMouseDown)
	
	return icon
end

local function barOnUpdate(self)
	local time = GetTime();
	local icon = self:GetParent()
	if (time > self.endTime) then
		self.endTime = 0
		icon.right:SetText('')
		self:SetValue(0)
		self:SetScript("OnUpdate", nil)
		icon:GetNormalTexture():SetDesaturated(false);
		if not icon.sendready then
			if icon.EndChannel and icon.EndChannel ~= 'NONE' then
				if icon.EndChannel == 'RAID' and IsPartyLFG() then icon.EndChannel = 'INSTANCE_CHAT' end
				SendChatMessage(format(readyMsg, icon.partytext:GetText()..icon.playername, icon.spellid, icon.spellname), icon.EndChannel)
			end
			icon.sendready = true
			icon.sendcast = false
		end
		WPCache['p'..icon.partyno] = false
	--	E:StopFlash(icon)
		E:Flash(icon, 1)		
	else
		local remaining = self.endTime - time
		if R.db.UIType == 'icon' then
			if (not icon.duration) or (icon.duration and icon.duration < 0) then --无持续时间显示时才显示CD计时
				icon.right:SetText(FormatTime(self.endTime - time))
			end
		else
			icon.right:SetText(FormatTime(self.endTime - time))
		end
		self:SetValue(math.floor(remaining))
		icon:GetNormalTexture():SetDesaturated(true);
	end
end

function R:COMBAT_LOG_EVENT_UNFILTERED(...)
	local _, event, _, sourceGUID, sourceName, _, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()

	if event ~= "SPELL_RESURRECT" and event ~= "SPELL_CAST_SUCCESS" and event ~= "SPELL_AURA_APPLIED" then return end

	if not sourceName or not spellID or not sourceGUID then return end

	spellID = ConvertSpellIdIfSoulstone(spellID)
	if spellID == 61391 then spellID = 132469 end --转换台风技能
	
	if not GetSpellInfo(spellID) then return; end	

	for k=1, 3 do
		local f = _G["EUIRaidToolBox"..k]		
		if f and f.Bars and #f.Bars > 0 then
			for i=1, #f.Bars do
				if f.Bars[i].spellid == spellID and f.Bars[i].guid == sourceGUID then
					local icon = f.Bars[i]
					if icon.cds and icon.cds > 0 then
						icon.duration = GetSpellDuration(spellID)
						if not icon.sendcast then
							local channel = icon.StartChannel
							if channel and channel ~= 'NONE' then
								if channel == 'RAID' and IsPartyLFG() then channel = 'INSTANCE_CHAT' end							
								SendChatMessage(format(castMsg, icon.partytext:GetText()..icon.playername, spellID, icon.spellname, icon.duration or NONE), channel)
							end
							icon.sendcast = true;
							icon.sendready = false
						end
						if icon.duration and icon.duration > 0 then
							icon.startTime = GetTime()
							icon.endTime = GetTime() + icon.duration
						--	icon:SetScript('OnUpdate', iconDurationOnUpdate)
						end
						icon.bar.startTime = GetTime();
						icon.bar.endTime = GetTime() + icon.cds;
						icon.bar:SetMinMaxValues(0, icon.cds);
						icon.bar:SetScript('OnUpdate', barOnUpdate)
					end
					break;
				end
			end
		end
	end
end

local function resetbars(f)
	if f and f.Bars and #f.Bars > 0 then
		for i=1, #f.Bars do
			f.Bars[i]:Hide()
			f.Bars[i] = nil
		end
		f.Bars = nil
		f.Bars = {}
		f.title:SetText(L['EUIRaidToolBox'..f.ID])
	end
end

function R:ResetBars(f, all)
	if not f or all then
		for i = 1, 3 do
			resetbars(_G['EUIRaidToolBox'..i])
		end
	else
		resetbars(f)
	end
	
	if all and R.Players then
		for k, v in pairs(R.Players) do
			if v.spellcache then wipe(v.spellcache) end
		end
		wipe(R.Players)
		R.Players = nil
		R.Players = {}
	end
	collectgarbage("collect");
end

local function createAnchor(i)
	local frame = CreateFrame("Button", "EUIRaidToolBox"..i, E.UIParent)
	frame:StyleButton()
	frame:SetTemplate("Transparent")
	frame:RegisterForClicks('AnyUp', 'AnyDown')
	frame:SetScript("OnClick", function(self, btn)
		if btn == 'RightButton' then

			R:ResetBars(self, IsShiftKeyDown());
		else
			R:UpdateBoxUI(self, true);
		end
	end)
	frame:SetSize(18, 18)
	frame:SetNormalTexture("Interface\\AddOns\\ElvUI\\media\\textures\\reload.tga")
	frame:SetPushedTexture("Interface\\AddOns\\ElvUI\\media\\textures\\reload.tga")
	frame:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddDoubleLine(L["Left button:"], REFRESH, .6, .6, .6, 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Right button:"], RESET, .6, .6, .6, 1, 1, 1)
		GameTooltip:AddDoubleLine(L["shiftztype2"], RESET..ALL, .6, .6, .6, 1, 1, 1)
		GameTooltip:SetClampedToScreen(true)
		GameTooltip:Show()
	end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetClampedToScreen(true)
	if i == 1 then
		frame:Point("TOPLEFT", 4, -28)
	elseif i == 2 then
		frame:Point("TOPLEFT", 328, -28)
	else
		frame:Point("TOPLEFT", 488, -28)
	end
	frame.ID = i
	frame.Bars = {}
	E:CreateMover(frame, "EUIRaidToolBox"..i.."Mover", L['EUIRaidToolBox'..i], nil, nil, nil, "ALL,EUI", nil, "euiscript,RLBox", "db,RLBox,enable")
	
	frame.title = frame:CreateFontString(nil, 'OVERLAY')
	frame.title:FontTemplate(nil, R.db.TitleFontSize, 'OUTLINE')
	frame.title:Point("LEFT", frame, "RIGHT", 2, 0)
	frame.title:SetJustifyH("LEFT")
	frame.title:SetText(L['EUIRaidToolBox'..i])
	frame.title:SetTextColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
end

function R:CreateAnchor(toggle)
	if not toggle then
		for i=1, 3 do
			local f = _G["EUIRaidToolBox"..i]
			if f then
				f:Hide();
				R:ResetBars(f)
			end
		end
		return;
	end
	
	for i=1, 3 do
		if i == 1 and self.db.DEFAULT.enable then createAnchor(i); end
		if i == 2 and self.db.OTHER.enable then createAnchor(i); end
		if i == 3 and self.db.MISC.enable then createAnchor(i); end
	end
end

function R:CalcBarsNum()
	if R.Players then
		for i = 1, 3 do
			local num = 0
			local anchor = _G['EUIRaidToolBox'..i]
			if anchor then
				local tmptable
				if anchor.ID == 1 then
					tmptable = E.global.RLBox.DEFAULT_SPELLS
				end
				if anchor.ID == 2 then
					tmptable = E.global.RLBox.OTHER_SPELLS
				end
				if anchor.ID == 3 then
					tmptable = E.global.RLBox.MISC_SPELLS
				end
				for i, default in pairs(tmptable) do
					local class = default[1]
					local spellid = default[2]
					for playerGuid, player in pairs(R.Players) do
						local cds = player.spellcache[spellid]
						if cds then
							num = num + 1
						end
					end
				end
				if num ~= #anchor.Bars then
					if not InCombatLockdown() then
						R:UpdateBoxUI(anchor)
					else
						num = E.ValColor..num..'|r'
						R:RegisterEvent('PLAYER_REGEN_ENABLED')
					end
				end
				anchor.title:SetText(L['EUIRaidToolBox'..i]..': '..num..'/'..#anchor.Bars)
			end
		end
	end
end

function R:PLAYER_REGEN_ENABLED()
	if InCombatLockdown() then return; end
	
	for i = 1, 3 do
		local num = 0
		local anchor = _G['EUIRaidToolBox'..i]
		if anchor then
			R:UpdateBoxUI(anchor)
		end
	end
	R:UnregisterEvent('PLAYER_REGEN_ENABLED')
end

function R:GROUP_ROSTER_UPDATE()
	if not R.Players then return; end
	
	if not IsInRaid() then
		R:ResetBars();
		return
	end
	
	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
	local raidNum = GetNumGroupMembers()
	if inInstance and instanceType == "raid" then raidNum = maxPlayers end	

	for i = 1, raidNum do
		local unit = "raid"..i
		local guid = UnitGUID(unit)
		local info = LibGroupInspect:GetCachedInfo(guid)
		if info and info.name and info.class_id then
			local player = BuildPlayerList(guid, info, unit)
			R:BuildPlayerSpellCache(player, guid)
		end
	end	
	
	for guid, player in pairs(R.Players) do
		local unit = GetUnitFromName(player.name, guid)
		if CheckUnitIsOut(unit) then

			if player.spellcache then
				wipe(player.spellcache)
				player.spellcache = nil
			end
			R.Players[guid] = nil;
		end
	end

	R:CalcBarsNum()
end

function R:ZONE_CHANGED()
	if not IsInInstance() then
		R:ResetBars();
	end
end

function R:Toggle()
	if E.db.RLBox.enable then
		wipe(R.Players)
		self:CreateAnchor(true)
		LibGroupInspect.RegisterCallback(R, "GroupInSpecT_Update");
		LibGroupInspect.RegisterCallback(R, "GroupInSpecT_Remove");
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("GROUP_ROSTER_UPDATE")
		self:RegisterEvent("ZONE_CHANGED")
	else
		self:CreateAnchor(false)
		LibGroupInspect.UnregisterCallback(R, "GroupInSpecT_Update");
		LibGroupInspect.UnregisterCallback(R, "GroupInSpecT_Remove");
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:UnregisterEvent("GROUP_ROSTER_UPDATE")	
		self:UnregisterEvent("ZONE_CHANGED")	
	end
end

function R:Initialize()
	self.db = E.db.RLBox
	if not self.db then return; end
	R.Players = {}
	
	self:Toggle()
end

E:RegisterModule(R:GetName())