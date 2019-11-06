--[[
Name: ZoneInfoClassic
Revision: $Rev: 103 $
Author: Odica; based on the ZoneInfo module of Cartographer 2 by ckknight
SVN: svn://svn.wowace.com/wow/libtourist-3-0/mainline/trunk
Description: Addon that will show levels and other information about the zone being displayed on the World Map.
License: MIT
]]
local E = unpack(ElvUI)

local function trace(msg)
--	DEFAULT_CHAT_FRAME:AddMessage("ZoneInfo: "..msg)
end


if not ZoneInfo then
	ZoneInfo = LibStub("AceAddon-3.0"):NewAddon("ZoneInfoClassic", "AceHook-3.0")
	local ZoneInfo, self = ZoneInfo, ZoneInfo
end

local ZoneInfoDataProviderMixin = CreateFromMixins(MapCanvasDataProviderMixin)
local Tourist = LibStub("LibTouristClassic-1.0")

-- Content switches
local showFishing = true
local showTransports = true
local showRoadConnections = true
local showInstances = true
local showFlightnodes = true

local t = {}

local GAME_LOCALE = GetLocale()

local translations = {
	zhTW = {
		["ZoneInfo"] = "地區資訊",
		["Transports"] = "運輸工具",
		["Road connections"] = "道路連接",
		["Instances"] = "副本",
		["Flight nodes"] = "飛行節點",
		["Fishing"] = "釣魚",
		["BG"] = "戰場",
		["Raid"] = "地下城",
		["man"] = "人",
	},
	zhCN = {
		["ZoneInfo"] = "区域信息",
		["Transports"] = "运输",
		["Road connections"] = "道路连接",
		["Instances"] = "地下城",
		["Flight nodes"] = "飞行鸟点",
		["Fishing"] = "钓鱼",
		["BG"] = "战场",
		["Raid"] = "副本",
		["man"] = "人",
	},
}

local function L(tag)
	if translations[GAME_LOCALE] then
		return translations[GAME_LOCALE][tag] or tag
	else
		return tag
	end
end

function ZoneInfo:OnInitialize()
	self.name = L("ZoneInfo")
	self.title = L("ZoneInfo")
end

function ZoneInfo:OnEnable()
	if not E.db.euiscript.ZoneInfo then return end

    WorldMapFrame:AddDataProvider(ZoneInfoDataProviderMixin)
end

function ZoneInfo:OnDisable()
   WorldMapFrame:RemoveDataProvider(ZoneInfoDataProviderMixin)
end

function ZoneInfoDataProviderMixin:OnAdded(mapCanvas)

    MapCanvasDataProviderMixin.OnAdded(self, mapCanvas)

	if not self.frame then

		self.frame = CreateFrame(
			"Frame",
			nil,
			self:GetMap():GetCanvasContainer()
		)
		self.frame:SetSize(600, 200)
		self.frame:SetFrameStrata("TOOLTIP")
		self.frame.dataProvider = self
		self.frame:SetPoint(
			"TOPLEFT",
			self:GetMap():GetCanvasContainer(),
			10,
			-30
		)

		local font, size = WorldMapTextFont:GetFont()

		self.headerText = self.frame:CreateFontString(nil, "OVERLAY", "WorldMapTextFont")
		self.headerText:SetFont(font, size, "OUTLINE")
		self.headerText:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -25)
		self.headerText:SetWidth(1024)
		self.headerText:SetScale(0.7)
        self.headerText:SetJustifyH("LEFT")
	
		self.detailsText = self.frame:CreateFontString(nil, "OVERLAY", "WorldMapTextFont")
		self.detailsText:SetFont(font, size, "OUTLINE")
		self.detailsText:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -200)
		self.detailsText:SetWidth(1024)
		self.detailsText:SetScale(0.35)
        self.detailsText:SetJustifyH("LEFT")
	else
		self.frame:SetParent(self:GetMap():GetCanvasContainer())
	end
	
	self.headerText:SetText("ZoneInfo Classic")
	self.detailsText:SetText("")
	
	self.frame:Show()
	self.headerText:Show()
	self.detailsText:Show()
	DEFAULT_CHAT_FRAME:AddMessage("ZoneInfo Classic loaded")
end

function ZoneInfoDataProviderMixin:RemoveAllData()
    self.frame:Hide()
end

-- Used by GetFishingSkill
local function FindSpellIDByTexture(texture)
	local id = 1
	local spellTexture = GetSpellTexture(id)
	while (spellTexture) do
		if (spellTexture and spellTexture == texture) then
			return id
		end
		id = id + 1
		spellTexture = GetSpellTexture(id)
	end
	return nil;
end

function ZoneInfoDataProviderMixin:GetFishingSkill()
	local fishingSkill = 0

	-- Get the name of the Fishing skill
	local fishingSkillName = L("Fishing")
	local spellID = FindSpellIDByTexture("Interface\\Icons\\Trade_Fishing")
	if spellID then
		fishingSkillName = GetSpellInfo(spellID);
	end
	
	-- Loop through all lines on the Skills tab of the Character window
	for i = 1, GetNumSkillLines() do
		local name, _, _, skill = GetSkillLineInfo(i)
		if ( name == fishingSkillName ) then
			-- Found Fishing -> exit the loop
			fishingSkill = skill
			break
		end
	end

	trace(tostring(fishingSkillName).." skill = "..tostring(fishingSkill))
	return fishingSkillName, fishingSkill or 0 
end

function ZoneInfoDataProviderMixin:RefreshAllData(fromOnShow)
	if not self.frame then
		return
	end

	local currentUiMapID = WorldMapFrame:GetMapID()
	local zoneText = Tourist:GetMapNameByIDAlt(currentUiMapID)
	local playerLevel = UnitLevel("player")

	trace("RefreshAllData: currentUiMapID: "..tostring(currentUiMapID).." = "..tostring(zoneText))

	if currentUiMapID and (Tourist:IsZoneOrInstance(currentUiMapID) or Tourist:DoesZoneHaveInstances(currentUiMapID)) and not Tourist:IsContinent(currentUiMapID) then
		-- HEADER
		self.headerText:SetTextColor(Tourist:GetFactionColor(currentUiMapID))
		
		local low, high = Tourist:GetLevel(currentUiMapID)	
		local levelText = ""
		if low > 0 and high > 0 then
			levelText = Tourist:GetLevelString(currentUiMapID)
			local r, g, b = Tourist:GetLevelColor(currentUiMapID)
			levelText = string.format("|cff%02x%02x%02x[%s] (%s)|r", r * 255, g * 255, b * 255, levelText, playerLevel)

			local groupSizeString = Tourist:GetInstanceGroupSizeString(currentUiMapID, true)
			if groupSizeString ~= "" then
				levelText = levelText.." "..groupSizeString.." "..L("man")
			end
		end
			
		if levelText == "" then
			self.headerText:SetText(zoneText)
		else
			table.insert(t,zoneText)
			table.insert(t,levelText)
			self.headerText:SetText(table.concat(t, "\n"))
			for k in pairs(t) do
				t[k] = nil
			end
		end

		-- DETAILS
		self.detailsText:SetText("")
		
		-- Determine Fishing level
		local minFish, maxFish
		local fishing_skill_text
		if showFishing then
			minFish, maxFish = Tourist:GetFishingLevel(currentUiMapID)
			if minFish == 0 or not minFish then 
				-- no fishing in this zone
				minFish = nil
			end
			if minFish then
				local fishingSpell, fishingSkill = ZoneInfoDataProviderMixin:GetFishingSkill()
				local r,g,b = 1,1,0
				local r1,g1,b1 = Tourist:CalculateLevelColor(minFish, maxFish, fishingSkill) 
				local levelString = Tourist:GetFishingLevelString(currentUiMapID)					

				fishing_skill_text = string.format("|cff%02x%02x%02x%s|r |cff%02x%02x%02x[%s] (%d)|r",r * 255, g * 255, b * 255,fishingSpell, r1 * 255, g1 * 255, b1 * 255, levelString, fishingSkill)

				if not fishing_skill_text then
					minFish = nil
				end
			end
		end
		
		-- Determine transport connections
		local transports = {}
		local hasTransports
		local roadConnections = {}
		local hasRoadConnections
		if showTransports or showRoadConnections then
			for path in Tourist:IterateBorderZones(currentUiMapID, false) do
				if not Tourist:IsZoneOrInstance(path) then
					transports[path] = true
					hasTransports = true
				else 
					if Tourist:IsZone(path) then
						roadConnections[path] = true
						hasRoadConnections = true
					end
				end
			end
		end
		local hasFlightnodes = Tourist:DoesZoneHaveFlightnodes(currentUiMapID) and showFlightnodes
		local hasInstances = Tourist:DoesZoneHaveInstances(currentUiMapID) and showInstances
		local noTable = false
		
		-- Add fishing level
		if minFish and fishing_skill_text then
			if hasTransports or hasRoadConnections or hasInstances or hasFlightnodes then 
				table.insert(t,fishing_skill_text)
				table.insert(t,"")
			else
				-- Fishing only: show one line (no table)
				self.detailsText:SetText(fishing_skill_text)
				noTable = true
			end
		end
		
		-- Add transport connections
		if hasTransports and showTransports then
			local r, g, b
			table.insert(t, string.format("|cffffffff%s:|r", L("Transports")))
			for k, v in pairs(transports) do
				r, g, b = Tourist:GetFactionColor(k)
				table.insert(t, string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, "- "..k))
			end
			if hasRoadConnections or hasInstances or hasFlightnodes then
				table.insert(t,"")
			end
		end

		-- Add road connections
		if hasRoadConnections and showRoadConnections then
			local r, g, b
			table.insert(t, string.format("|cffffffff%s:|r", L("Road connections")))
			for k, v in pairs(roadConnections) do
				r, g, b = Tourist:GetFactionColor(k)
				table.insert(t, string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, "- "..k))
			end
			if hasInstances or hasFlightnodes then
				table.insert(t,"")
			end
		end

		
		-- Add instances
		if hasInstances then
			table.insert(t, string.format("|cffffffff%s:|r", L("Instances")))
			for instance in Tourist:IterateZoneInstances(currentUiMapID) do
				local complex = nil
				if not Tourist:IsComplex(currentUiMapID) then
					complex = Tourist:GetComplex(instance)
				end
				local low, high = Tourist:GetLevel(instance)
				local r1, g1, b1 = Tourist:GetFactionColor(instance)
				local r2, g2, b2 = Tourist:GetLevelColor(instance)
				local groupSize = Tourist:GetInstanceGroupSize(instance)
				local groupSizeString = Tourist:GetInstanceGroupSizeString(instance, true)
				local name = instance
				if complex then
					name = complex .. " - " .. instance
				end
				if Tourist:IsBattleground(instance) then
					name = L("BG")..": " .. name
				elseif groupSize > 5 then
					name = L("Raid")..": " .. name
				end						
				if low == high then
					if groupSize > 0 then
						table.insert(t, "- "..string.format("|cff%02x%02x%02x%s|r |cff%02x%02x%02x[%d]|r " .. groupSizeString.." "..L("man"), r1 * 255, g1 * 255, b1 * 255, name, r2 * 255, g2 * 255, b2 * 255, high))
					else
						table.insert(t, "- "..string.format("|cff%02x%02x%02x%s|r |cff%02x%02x%02x[%d]|r", r1 * 255, g1 * 255, b1 * 255, name, r2 * 255, g2 * 255, b2 * 255, high))
					end
				else
					if groupSize > 0 then
						table.insert(t, "- "..string.format("|cff%02x%02x%02x%s|r |cff%02x%02x%02x[%d-%d]|r " .. groupSizeString.." "..L("man"), r1 * 255, g1 * 255, b1 * 255, name, r2 * 255, g2 * 255, b2 * 255, low, high))
					else
						table.insert(t, "- "..string.format("|cff%02x%02x%02x%s|r |cff%02x%02x%02x[%d-%d]|r", r1 * 255, g1 * 255, b1 * 255, name, r2 * 255, g2 * 255, b2 * 255, low, high))
					end
				end
			end
			
			if hasFlightnodes then
				table.insert(t,"")
			end		
		end
		
		-- Add flight nodes
		if hasFlightnodes then
			local r, g, b
			table.insert(t, string.format("|cffffffff%s:|r", L("Flight nodes")))
			for node in Tourist:IterateZoneFlightnodes(currentUiMapID) do
				r, g, b = Tourist:GetFlightnodeFactionColor(node.faction)
				table.insert(t, string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, "- "..node.name)) --.." ("..tostring(node.factionName)..")"))
			end
		end
		
		
		
		-- Show result (if table)
		if noTable == false then
			self.detailsText:SetText(table.concat(t, "\n"))
			for k in pairs(t) do
				t[k] = nil
			end
		end				

	elseif not currentUiMapID then
		-- No map ID
		self.headerText:SetTextColor(1,1,1)
		self.headerText:SetText("??")
		self.detailsText:SetText("")
	else
		-- Continent, World map, Cosmic map
		self.headerText:SetTextColor(Tourist:GetFactionColor(currentUiMapID))
		self.headerText:SetText(zoneText)
		self.detailsText:SetText("")		
	end
end


