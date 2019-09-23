local E, L = unpack(ElvUI)
local T = E:NewModule('EuiThreat', 'AceEvent-3.0')
local ThreatLib =LibStub:GetLibrary("ThreatClassic-1.0")

local _G = _G
local Media = "Interface\\AddOns\\EuiScript\\textures\\media\\"
local Statusbar = Media.."statusbar"
local GlowTex = Media.."solid"
local Solid = Media.."dM2"
local ArrowLarge = Media.."ArrowLarge"
local ArrowSmall = Media.."ArrowSmall"
local UNKNOWN = UNKNOWN
local UnitName = UnitName
local UnitIsVisible = UnitIsVisible
local UnitDetailedThreatSituation = UnitDetailedThreatSituation
local ipairs, select = ipairs, select
local tinsert, tsort, wipe = table.insert, table.sort, wipe
local tremove = tremove
local UnitExists = UnitExists
local GetNumSubgroupMembers = GetNumSubgroupMembers
local GetNumGroupMembers = GetNumGroupMembers
local CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local UnitIsDead = UnitIsDead
local UnitIsPlayer = UnitIsPlayer
local UnitCanAttack = UnitCanAttack
local UnitGUID = UnitGUID
local UnitAffectingCombat = UnitAffectingCombat

-- 构建仇恨列表
local ThreatList, ThreatFlag, ThreatGuid = {}, {}, ""
local function GetThreat(unit, pet)
	if UnitName(pet or unit) == UNKNOWN or not UnitIsVisible(pet or unit) then
		return
	end

	local isTanking, _, _, rawPercent, _  = UnitDetailedThreatSituation(pet or unit, E.db.euiscript.threat.ThreatUnit)
	local name = pet and UnitName(pet) or UnitName(unit)
	
	for index, value in ipairs(ThreatList) do
		if value.name == name then
			tremove(ThreatList, index)
			break
		end
	end

	tinsert(ThreatList, {
		name = name,
		class = select(2, UnitClass(unit)),
		rawPercent = rawPercent or 0,
		isTanking = isTanking or nil,
	})
end

local function AddThreat(unit, pet)
	if UnitExists(pet) then
		GetThreat(unit)
		GetThreat(unit, pet)
	else
		if GetNumSubgroupMembers() > 1 or GetNumGroupMembers() > 1 then
			GetThreat(unit)
		end
	end
end

-- 仇恨排序	
local function SortThreat(a,b)
	return a.rawPercent > b.rawPercent
end

local function UpdateThreatFlag()
	local Flag, FlagT
	
	for key, value in ipairs(ThreatFlag) do
		value:Hide()
	end
	if _G["ThreatFlagTank"] then
	   _G["ThreatFlagTank"]:Hide()
	end
	
	for key, value in ipairs(ThreatList) do
		if ThreatList[key].isTanking then
			FlagT = _G["ThreatFlagTank"]
			if not FlagT then
				
				FlagT = CreateFrame("Frame","ThreatFlagTank",T.Frame)
				FlagT:Width(2)
				FlagT:Height(T.Frame:GetHeight())
				FlagT:SetBackdrop({ bgFile = Solid })
				FlagT:SetBackdropColor(0,0,0)
				FlagT:SetFrameLevel(2)
				
				FlagT.Name = FlagT:CreateTexture(nil,"OVERLAY")
				FlagT.Name:Height(12)
				FlagT.Name:Width(12)
				FlagT.Name:SetTexture(ArrowLarge)
				FlagT.Name:Point("BOTTOM", FlagT, "TOP", 0, 2)
				
				FlagT.Text = FlagT:CreateFontString(nil,"OVERLAY")
				FlagT.Text:FontTemplate(nil,12,"THINOUTLINE")
				FlagT.Text:Point("BOTTOM", FlagT.Name, "TOP", 1, -5)
				
			end
		
			if not value.class then value.class = 'PRIEST' end
			local Color = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[value.class] or RAID_CLASS_COLORS[value.class])
			FlagT.Name:SetVertexColor(Color.r, Color.g, Color.b)
						
			FlagT.Text:SetText(E:ShortenString(value.name, E.db.euiscript.threat.NameTextL))
			FlagT.Text:SetTextColor(Color.r, Color.g, Color.b)

			FlagT:Point("LEFT", T.Frame, "LEFT", 210*100/130+3, 0)
			FlagT:Show()
			
			tremove(ThreatList, key)
			
		end
	end
	tsort(ThreatList, SortThreat)
	for key, value in ipairs(ThreatList) do
		if key > E.db.euiscript.threat.ThreatLimited then return end
		
		Flag = ThreatFlag[key]
		if not Flag then
			Flag = CreateFrame("Frame","ThreatFlag"..key,T.Frame)
			Flag:Width(2)
			Flag:Height(T.Frame:GetHeight())
			Flag:SetBackdrop({ bgFile = Solid })
			Flag:SetBackdropColor(0,0,0)
			Flag:SetFrameLevel(2)
			
			Flag.Name = Flag:CreateTexture(nil,"OVERLAY")
			Flag.Name:Height(E.db.euiscript.threat.font_size)
			Flag.Name:Width(E.db.euiscript.threat.font_size)
			Flag.Name:SetTexture(ArrowSmall)
			Flag.Name:Point("TOP", Flag, "BOTTOM", 0, -2)
			
			Flag.Text = Flag:CreateFontString(nil,"OVERLAY")
			Flag.Text:FontTemplate(nil,E.db.euiscript.threat.font_size,"OUTLINE")
			Flag.Text:Point("TOP", Flag.Name, "BOTTOM", 1, 0)
			
			tinsert(ThreatFlag, Flag)
		end

		if not value.class then value.class = 'PRIEST' end
		local Color = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[value.class] or RAID_CLASS_COLORS[value.class])
		
		local rawPercent = value.rawPercent
		
		Flag.Name:SetVertexColor( Color.r, Color.g, Color.b)
		
		Flag.Text:SetText(E:ShortenString(value.name, E.db.euiscript.threat.NameTextL))
		Flag.Text:SetTextColor(Color.r, Color.g, Color.b)
		
		Flag:Point("LEFT", T.Frame, "LEFT", 210*rawPercent/130+3, 0)
		Flag:Show()
	end
end

local function CreateThreatFrame()
	if _G["EuiThreatFrame"] then
		_G["EuiThreatFrame"]:Width(E.db.euiscript.threat.width)
		_G["EuiThreatFrame"]:Height(E.db.euiscript.threat.height)
		return _G["EuiThreatFrame"]
	end
	
	local ThreatFrame = CreateFrame("Frame", "EuiThreatFrame", E.UIParent)
	ThreatFrame:Width(E.db.euiscript.threat.width)
	ThreatFrame:Height(E.db.euiscript.threat.height)
	ThreatFrame:SetAlpha(0)
	ThreatFrame:Point('CENTER', E.UIParent, 'CENTER', -413, -95)
	E:CreateMover(ThreatFrame, 'EuiThreatFrameMover', L['Nice threat bar'], nil, nil, nil, 'ALL,EUI',nil,"euiscript,euiscript_general","db,euiscript,threat,enable")


	ThreatFrame.threatUnit = ThreatFrame:CreateFontString(nil, 'OVERLAY')
	ThreatFrame.threatUnit:FontTemplate(nil,E.db.euiscript.threat.font_size,"OUTLINE")

	ThreatFrame.threatUnit:Point("LEFT", ThreatFrame, "RIGHT", 4, 0)
	ThreatFrame.threatUnit:SetTextColor(0.6, 0.6, 0.6)
	ThreatFrame.threatUnit:SetText(L[E.db.euiscript.threat.ThreatUnit])
	ThreatFrame.threatUnit:SetAlpha(0)
	ThreatFrame:SetScript("OnEnter", function(self)
		self.threatUnit:SetAlpha(1)
	end)
	ThreatFrame:SetScript("OnLeave", function(self)
		self.threatUnit:SetAlpha(0)
	end)
	
	ThreatFrame.Overlay = CreateFrame("Frame", nil, ThreatFrame)
	ThreatFrame.Overlay:Point("TOPLEFT",-1,1)
	ThreatFrame.Overlay:Point("BOTTOMRIGHT",1,-1)
	ThreatFrame.Overlay:SetBackdrop({ 
		edgeFile = GlowTex , edgeSize = 1,
	})
	ThreatFrame.Overlay:SetBackdropBorderColor(0,0,0,0.7)

	local Texture = ThreatFrame:CreateTexture(nil, "BACKGROUND",ThreatFrame)
	Texture:Height(ThreatFrame:GetHeight())
	Texture:Width(ThreatFrame:GetWidth())	
	Texture:SetTexture(Statusbar)
	Texture:Point("LEFT", 0, 0)
	Texture:SetGradient("HORIZONTAL", 0.4, 0.4, 0.4, 1, 1, 1)	
	
	return ThreatFrame
end

local function ThreatEvent(event)
	local unit = E.db.euiscript.threat.ThreatUnit
	
	if event == "PLAYER_REGEN_DISABLED" then
		if not E.db.euiscript.threat.solo and not IsInGroup() and not IsInRaid() then
			return
		else	
			if UnitExists(unit) and not UnitIsDead(unit) and not UnitIsPlayer(unit) and UnitCanAttack("player", unit) then
				E:UIFrameFadeIn(T.Frame, 0.7, 0, 0.8)
			end
		end
		ThreatLib.RegisterCallback(T, "ThreatUpdated", CheckStatus)
		CheckStatus()
	elseif event == "PLAYER_REGEN_ENABLED" then
		E:UIFrameFadeOut(T.Frame, 0, 0, 0)
		ThreatLib.UnregisterCallback(T, "ThreatUpdated", CheckStatus)
		CheckStatus()
	elseif event == "UNIT_THREAT_LIST_UPDATE" then
		if unit and UnitExists(unit) and UnitCanAttack("player", unit) then
			wipe(ThreatList)
			if IsInRaid() then
				for i = 1, GetNumGroupMembers() do
					AddThreat("raid"..i, "raid"..i.."pet")
				end
			elseif IsInGroup() then
				AddThreat("player", "pet")
				for i = 1, GetNumSubgroupMembers() do
					AddThreat("party"..i, "party"..i.."pet")
				end
			else
				AddThreat("player", "pet")
			end
			UpdateThreatFlag()
		end
	elseif event == "PLAYER_TARGET_CHANGED" and unit == 'target' then
			if not E.db.euiscript.threat.solo and not IsInGroup() and not IsInRaid() then
				return
			else
				if UnitExists("target") and not UnitIsDead("target") and not UnitIsPlayer("target") and UnitCanAttack("player", "target") then
				ThreatGuid = UnitGUID("target")
				local TargetSwitch = function()
					if UnitAffectingCombat("player") then
						E:UIFrameFadeIn(T.Frame, 0.7, 0, 0.8)
					end
				end
				TargetSwitch()
				wipe(ThreatList)
				if IsInRaid() then
					for i = 1, GetNumGroupMembers() do
						AddThreat("raid"..i, "raid"..i.."pet")
					end
				elseif IsInGroup() then
					AddThreat("player", "pet")
					for i = 1, GetNumSubgroupMembers() do
						AddThreat("party"..i, "party"..i.."pet")
					end
				else
					AddThreat("player", "pet")
				end
			else
				ThreatGuid = ""
				wipe(ThreatList)
				E:UIFrameFadeOut(T.Frame, 0, 0, 0)
			end
			UpdateThreatFlag()
		end
	end
end

local function CheckStatus()
	if unit and UnitExists(unit) and UnitCanAttack("player", unit) then
		wipe(ThreatList)
		if IsInRaid() then
			for i = 1, GetNumGroupMembers() do
				AddThreat("raid"..i, "raid"..i.."pet")
			end
		elseif IsInGroup() then
			AddThreat("player", "pet")
			for i = 1, GetNumSubgroupMembers() do
				AddThreat("party"..i, "party"..i.."pet")
			end
		else
			AddThreat("player", "pet")
		end
		UpdateThreatFlag()
	end
end

function T:ChangeThreatUnit()
	if not _G["EuiThreatFrame"] then return; end
	
	EuiThreatFrame.threatUnit:SetText(L[E.db.euiscript.threat.ThreatUnit])
end

function T:Initialize()
	if E.db.euiscript.threat.enable then
		T.Frame = CreateThreatFrame()

		ThreatLib.RegisterCallback(self, "Activate", CheckStatus)
		ThreatLib.RegisterCallback(self, "Deactivate", CheckStatus)
		ThreatLib.RegisterCallback(self, "ThreatUpdated", CheckStatus)
		ThreatLib:RequestActiveOnSolo(true)

	--	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", ThreatEvent)
		self:RegisterEvent("PLAYER_TARGET_CHANGED", ThreatEvent)
		self:RegisterEvent("PLAYER_REGEN_DISABLED", ThreatEvent)
		self:RegisterEvent("PLAYER_REGEN_ENABLED", ThreatEvent)
	end
end

E:RegisterModule(T:GetName())
