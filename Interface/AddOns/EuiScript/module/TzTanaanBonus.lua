local E, L = unpack(ElvUI) -- Import Functions/Constants, Config, Locales
local TzTB = CreateFrame("Frame")
if not E.db.euiscript.tztb then return; end
-- Title: TzTanaanBonus
-- Version: 6.2.2.6
-- Author: Tomaz
-- 汉化修改成单文件 by eui.cc at 20150920
-- name, mapAreaID, x, y, questID, questID, ...
if GetLocale() == 'zhCN' or GetLocale() == 'zhTW' then
TzTB.db = {
	[ "BonusObjectives" ] = {
		-- Tanaan Jungle
		[  1 ] = { "铁城港",				945,	38.57,	35.03,	37865, 37866, 37891, 37940, 39451, 39452 },
		[  2 ] = { "卡纳克废墟",				945,	23.45,	37.92,	37938, 38009, 38250, 38252, 39447, 39448 },
		[  3 ] = { "沙纳尔神殿",			945,	29.35,	70.86,	37966, 37968, 38020, 38449, 39449, 39450 },
		[  4 ] = { "邪能熔炉",					945,	47.97,	40.42,	37970, 38439, 38440, 38441, 39445, 39446 },
		[  5 ] = { "钢铁前线",				945,	11.15,	54.90,	38046, 38047, 38051, 38054, 39443, 39444 },
		[  6 ] = { "基尔加丹王座",			945,	55.37,	25.74,	38585, 38586, 38587, 38588, 39453, 39454 },
		[  7 ] = { "泽斯高",						945,	22.08,	51.63,	38040, 38043, 38044, 38045, 39441, 39442 },

	},

	[ "WorldBosses" ] = {
		[  1 ] = { "霸主卡扎克",			945,	47.00,	21.63,	94015 },
	},

	[ "EliteRares" ] = {
		[  1 ] = { "死爪",					945,	23.11,	40.50,	39287 },
		[  2 ] = { "末日之轮",					945,	46.93,	52.96,	39289 },
		[  3 ] = { "泰罗菲斯特",					945,	15.32,	63.78,	39288 },
		[  4 ] = { "维金斯",						945,	32.31,	74.23,	39290 },
	},

	[ "ToyRares" ] = {
		[  1 ] = { "达库姆",						945,	83.69,	43.71,	40105 },
		[  2 ] = { "邪能监工玛德拉普",			945,	40.68,	56.48,	40107 },
		[  3 ] = { "贡达",						945,	80.42,	56.88,	40106 },
		[  4 ] = { "萨姆逊·强掠",					945,	88.11,	55.85,	40104 },
	},

	[ "PetRares" ] = {
		[  1 ] = { "古克",							950,	23.79,	38.70,	40074 },
		[  2 ] = { "巴格",							950,	28.14,	29.62,	40073 },
		[  3 ] = { "鲁多格",						950,	25.89,	34.78,	40075 },
	},

	[ "TinyTerrors" ] = {
		[  1 ] = { "荒爪",						945,	16.0,	44.8,	39168 },
		[  2 ] = { "混沌狼崽",						945,	25.1,	76.2,	39161 },
		[  3 ] = { "腐化的雷尾淡水兽",			945,	53.1,	65.2,	39160 },
		[  4 ] = { "诅咒之魂",					945,	31.4,	38.1,	39162 },
		[  5 ] = { "黑暗魔眼",					945,	54.0,	29.9,	39167 },
		[  6 ] = { "亵渎之土",					945,	75.4,	37.4,	39173 },
		[  7 ] = { "灾火",						945,	57.7,	37.4,	39165 },
		[  8 ] = { "恐惧行者",					945,	46.4,	53.0,	39170 },
		[  9 ] = { "邪火虫",						945,	55.9,	80.8,	39163 },
		[ 10 ] = { "魔誓哨兵",				945,	26.1,	31.6,	39157 },
		[ 11 ] = { "泥蛙",						945,	42.3,	71.8,	39166 },
		[ 12 ] = { "灵拳",					945,	48.4,	35.6,	39171 },
		[ 13 ] = { "斯格里克斯",						945,	48.5,	31.3,	39172 },
		[ 14 ] = { "污秽巨鳌蟹",				945,	43.2,	84.5,	39164 },
		[ 15 ] = { "德拉诺污血怪",			945,	44.0,	45.7,	39169 },
	},
	
	["Ctrl-Click to set a TomTom waypoint"] = "Ctrl + 点击将设置 TomTom 路径点",
	["Bonus Objective: %s"] = "奖励目标: %s",
	["WorldBoss: %s"] = "世界BOSS: %s",
	["Elite Rare: %s"] = "稀有精英: %s",
	["Toy Rare: %s"] = "稀有玩具: %s",
	["Pet Rare: %s"] = "稀有宠物: %s",
}
else
TzTB.db = {
	[ "BonusObjectives" ] = {
		-- Tanaan Jungle
		[  1 ] = { "Ironhold Harbor",				945,	38.57,	35.03,	37865, 37866, 37891, 37940, 39451, 39452 },
		[  2 ] = { "Ruins of Kra'nak",				945,	23.45,	37.92,	37938, 38009, 38250, 38252, 39447, 39448 },
		[  3 ] = { "Temple of Sha'naar",			945,	29.35,	70.86,	37966, 37968, 38020, 38449, 39449, 39450 },
		[  4 ] = { "The Fel Forge",					945,	47.97,	40.42,	37970, 38439, 38440, 38441, 39445, 39446 },
		[  5 ] = { "The Iron Front",				945,	11.15,	54.90,	38046, 38047, 38051, 38054, 39443, 39444 },
		[  6 ] = { "Throne of Kil'jaeden",			945,	55.37,	25.74,	38585, 38586, 38587, 38588, 39453, 39454 },
		[  7 ] = { "Zeth'Gol",						945,	22.08,	51.63,	38040, 38043, 38044, 38045, 39441, 39442 },

	},

	[ "WorldBosses" ] = {
		[  1 ] = { "Supreme Lord Kazzak",			945,	47.00,	21.63,	94015 },
	},

	[ "EliteRares" ] = {
		[  1 ] = { "Deathtalon",					945,	23.11,	40.50,	39287 },
		[  2 ] = { "Doomroller",					945,	46.93,	52.96,	39289 },
		[  3 ] = { "Terrorfist",					945,	15.32,	63.78,	39288 },
		[  4 ] = { "Vengeance",						945,	32.31,	74.23,	39290 },
	},

	[ "ToyRares" ] = {
		[  1 ] = { "Drakum",						945,	83.69,	43.71,	40105 },
		[  2 ] = { "Fel Overseer Mudlump",			945,	40.68,	56.48,	40107 },
		[  3 ] = { "Gondar",						945,	80.42,	56.88,	40106 },
		[  4 ] = { "Smashum Grabb",					945,	88.11,	55.85,	40104 },
	},

	[ "PetRares" ] = {
		[  1 ] = { "Guk",							950,	23.79,	38.70,	40074 },
		[  2 ] = { "Pugg",							950,	28.14,	29.62,	40073 },
		[  3 ] = { "Rukdug",						950,	25.89,	34.78,	40075 },
	},

	[ "TinyTerrors" ] = {
		[  1 ] = { "Bleakclaw",						945,	16.0,	44.8,	39168 },
		[  2 ] = { "Chaos Pup",						945,	25.1,	76.2,	39161 },
		[  3 ] = { "Corrupted Thundertail",			945,	53.1,	65.2,	39160 },
		[  4 ] = { "Cursed Spirit",					945,	31.4,	38.1,	39162 },
		[  5 ] = { "Dark Gazer",					945,	54.0,	29.9,	39167 },
		[  6 ] = { "Defiled Earth",					945,	75.4,	37.4,	39173 },
		[  7 ] = { "Direflame",						945,	57.7,	37.4,	39165 },
		[  8 ] = { "Dreadwalker",					945,	46.4,	53.0,	39170 },
		[  9 ] = { "Felfly",						945,	55.9,	80.8,	39163 },
		[ 10 ] = { "Felsworn Sentry",				945,	26.1,	31.6,	39157 },
		[ 11 ] = { "Mirecroak",						945,	42.3,	71.8,	39166 },
		[ 12 ] = { "Netherfist",					945,	48.4,	35.6,	39171 },
		[ 13 ] = { "Skrillix",						945,	48.5,	31.3,	39172 },
		[ 14 ] = { "Tainted Maulclaw",				945,	43.2,	84.5,	39164 },
		[ 15 ] = { "Vile Blood of Draenor",			945,	44.0,	45.7,	39169 },
	},
	
	["Ctrl-Click to set a TomTom waypoint"] = "Ctrl-Click to set a TomTom waypoint",
	["Bonus Objective: %s"] = "Bonus Objective: %s",
	["WorldBoss: %s"] = "WorldBoss: %s",
	["Elite Rare: %s"] = "Elite Rare: %s",
	["Toy Rare: %s"] = "Toy Rare: %s",
	["Pet Rare: %s"] = "Pet Rare: %s",
}
end

--TzTanaanBonusIcons.lua begin--
TzTB.icons = {}

--------------------------------
-- TzTanaanBonusIcons_OnEnter --
--------------------------------
local function TzTanaanBonusIcons_OnEnter( _self )
	if _self.text then
		WorldMapPOIFrame.allowBlobTooltip = false
		GameTooltip:SetOwner( _self, "ANCHOR_BOTTOMLEFT" )
		GameTooltip:ClearLines()
		GameTooltip:AddLine( _self.text )

		if TomTom then
			GameTooltip:AddLine( TzTB.db["Ctrl-Click to set a TomTom waypoint"], 1, 1, 1, true )
		end

		GameTooltip:Show()
	end

----------------------------------------------------------------

	_self.magic.frame.texture:SetVertexColor( 0.5, 0.5, 1.0, 1.0 )
end

--------------------------------
-- TzTanaanBonusIcons_OnLeave --
--------------------------------
local function TzTanaanBonusIcons_OnLeave( _self )
	WorldMapPOIFrame.allowBlobTooltip = true
	GameTooltip:Hide()

----------------------------------------------------------------

	_self.magic.frame.texture:SetVertexColor( 1.0, 1.0, 1.0, 1.0 )
end

----------------------------------
-- TzTanaanBonusIcons_OnMouseUp --
----------------------------------
local function TzTanaanBonusIcons_OnMouseUp( _self )
	if TomTom and IsControlKeyDown() then	
		local mapID, mapFloor = C_Map.GetBestMapForUnit("player")
		local _, _, _, x, y = _self:GetPoint()

		x =  x / WorldMapDetailFrame:GetWidth()		-- 1002
		y = -y / WorldMapDetailFrame:GetHeight()	--  668

		TomTom:AddMFWaypoint( mapID, mapFloor, x, y, { title = _self.text, persistent = false, } )
	end
end

-----------------------------
-- TzTanaanBonusIcons_Hide --
-----------------------------
local function TzTanaanBonusIcons_Hide()
	for iconIndex, icon in ipairs( TzTB.icons ) do
		icon.frame:Hide()
		icon.image:Hide()
	end

end

----------------------------
-- TzTanaanBonusIcons_Get --
----------------------------
local function TzTanaanBonusIcons_Get( _textureName, _blipID, _size, _red, _green, _blue, _alpha )
	local icon = nil

	for iconIndex, icon2 in ipairs( TzTB.icons ) do
		if not icon2.image:IsShown() then
			icon = icon2
			break
		end
	end

	if icon == nil then
		icon = {}
		icon.frame = CreateFrame( "Frame", nil, WorldMapButton )

		icon.frame:SetFrameLevel( 5 )

		icon.frame.texture = icon.frame:CreateTexture()
		icon.frame.texture:SetAllPoints()
		icon.frame.texture:SetTexture( "interface/minimap/objecticons" )
		icon.frame.texture:SetTexCoord( GetObjectIconTextureCoords( 29 ) )

		icon.frame.magic = icon

----------------------------------------------------------------

		icon.image = CreateFrame( "Frame", nil, WorldMapButton )

		icon.frame:SetFrameLevel( 4 )

		icon.image.texture = icon.image:CreateTexture()
		icon.image.texture:SetAllPoints()

		icon.image:SetScript( "OnEnter", TzTanaanBonusIcons_OnEnter )
		icon.image:SetScript( "OnLeave", TzTanaanBonusIcons_OnLeave )
		icon.image:SetScript( "OnMouseUp", TzTanaanBonusIcons_OnMouseUp )

		icon.image:EnableMouse( true )

		icon.image.magic = icon

		tinsert( TzTB.icons, icon )
	end

	icon.frame.texture:SetVertexColor( sqrt( sqrt( _red ) ), sqrt( sqrt( _green ) ), sqrt( sqrt( _blue ) ) )

	icon.image.texture:SetTexture( _textureName )
	icon.image.texture:SetTexCoord( 0, 1, 0, 1 )
	icon.image.texture:SetVertexColor( _red, _green, _blue )

	if _blipID then
		icon.image.texture:SetTexCoord( GetObjectIconTextureCoords( _blipID ) )
	end

	icon.frame:SetSize( _size, _size )
	icon.frame:SetAlpha( _alpha )

	icon.image:SetSize( _size * 0.75, _size * 0.75 )
	icon.image:SetAlpha( _alpha )

	return icon
end
--TzTanaanBonusIcons.lua end--

--TzTanaanBonus.lua begin--
-----------
-- Round --
-----------
local function Round( _value )
	return floor( _value + 0.5 )
end

local TzTanaanBonus = CreateFrame("Frame", nil, WorldMapFrame)
--------------------------
-- TzTanaanBonus_OnLoad --
--------------------------
--function TzTanaanBonus_OnLoad( _self )
--	TzTB.frame = _self
--end
TzTB.frame = TzTanaanBonus

--------------------------
-- WorldMapFrame_Update --
--------------------------
for pin in WorldMapFrame:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
	hooksecurefunc(pin, "RefreshOverlays", function()
	TzTanaanBonusIcons_Hide()

----------------------------------------------------------------
-- Bonus Objectives

	if E.db.euiscript.tztb then
		db = TzTB.db[ "BonusObjectives" ]

		for _, info in ipairs( db ) do
			if C_Map.GetBestMapForUnit("player") == info[ 2 ] then
				local questCompleted = false

				for dbID = 5, #info, 1 do
					local questID = info[ dbID ]

					if IsQuestFlaggedCompleted( questID ) then
						questCompleted = true
					end
				end

				if not questCompleted then
					local icon = TzTanaanBonusIcons_Get( "interface/minimap/objecticons", 47, E.db.euiscript.tztb_icon, 1.0, 1.0, 1.0, 1.0 )
					local name = info[ 1 ]
					local x = Round( ( info[ 3 ] / 100 ) * WorldMapDetailFrame:GetWidth() )		-- Convert from TomTom
					local y = Round( ( info[ 4 ] / 100 ) * WorldMapDetailFrame:GetHeight() )	-- Convert from TomTom
					local offset = E.db.euiscript.tztb_icon / 32.0

					icon.frame:Point( "CENTER", WorldMapDetailFrame, "TOPLEFT", x - offset, -y - offset )
					icon.frame:Show()

					icon.image.text = format( TzTB.db["Bonus Objective: %s"], name )
					icon.image:Point( "CENTER", WorldMapDetailFrame, "TOPLEFT", x, -y )
					icon.image:Show()
				end
			end
		end
	end

----------------------------------------------------------------
-- World Bosses

	if E.db.euiscript.tztb then
		db = TzTB.db[ "WorldBosses" ]

		for _, info in ipairs( db ) do
			if C_Map.GetBestMapForUnit("player") == info[ 2 ] then
				local questCompleted = false

				for dbID = 5, #info, 1 do
					local questID = info[ dbID ]

					if IsQuestFlaggedCompleted( questID ) then
						questCompleted = true
					end
				end

				if not questCompleted then
					local icon = TzTanaanBonusIcons_Get( "interface/minimap/objecticons", 45, E.db.euiscript.tztb_icon, 1.0, 1.0, 1.0, 1.0 )
					local name = info[ 1 ]
					local x = Round( ( info[ 3 ] / 100 ) * WorldMapDetailFrame:GetWidth() )		-- Convert from TomTom
					local y = Round( ( info[ 4 ] / 100 ) * WorldMapDetailFrame:GetHeight() )	-- Convert from TomTom
					local offset = E.db.euiscript.tztb_icon / 32.0

					icon.frame:SetPoint( "CENTER", WorldMapDetailFrame, "TOPLEFT", x - offset, -y - offset )
					icon.frame:Show()

					icon.image.text = format( TzTB.db["WorldBoss: %s"], name )
					icon.image:SetPoint( "CENTER", WorldMapDetailFrame, "TOPLEFT", x, -y )
					icon.image:Show()
				end
			end
		end
	end

----------------------------------------------------------------
-- Elite Rares

	if E.db.euiscript.tztb then
		db = TzTB.db[ "EliteRares" ]

		for _, info in ipairs( db ) do
			if C_Map.GetBestMapForUnit("player") == info[ 2 ] then
				local questCompleted = false

				for dbID = 5, #info, 1 do
					local questID = info[ dbID ]

					if IsQuestFlaggedCompleted( questID ) then
						questCompleted = true
					end
				end

				if not questCompleted then
					local icon = TzTanaanBonusIcons_Get( "interface/minimap/objecticons", 41, E.db.euiscript.tztb_icon, 1.0, 0.25, 0.25, 1.0 )
					local name = info[ 1 ]
					local x = Round( ( info[ 3 ] / 100 ) * WorldMapDetailFrame:GetWidth() )		-- Convert from TomTom
					local y = Round( ( info[ 4 ] / 100 ) * WorldMapDetailFrame:GetHeight() )	-- Convert from TomTom
					local offset = E.db.euiscript.tztb_icon / 32.0

					icon.frame:SetPoint( "CENTER", WorldMapDetailFrame, "TOPLEFT", x - offset, -y - offset )
					icon.frame:Show()

					icon.image.text = format( TzTB.db["Elite Rare: %s"], name )
					icon.image:SetPoint( "CENTER", WorldMapDetailFrame, "TOPLEFT", x, -y )
					icon.image:Show()
				end
			end
		end
	end

----------------------------------------------------------------
-- Toy Rares

	if E.db.euiscript.tztb then
		db = TzTB.db[ "ToyRares" ]

		for _, info in ipairs( db ) do
			if C_Map.GetBestMapForUnit("player") == info[ 2 ] then
				local questCompleted = false

				for dbID = 5, #info, 1 do
					local questID = info[ dbID ]

					if IsQuestFlaggedCompleted( questID ) then
						questCompleted = true
					end
				end

				if not questCompleted then
					local icon = TzTanaanBonusIcons_Get( "interface/minimap/objecticons", 41, E.db.euiscript.tztb_icon, 0.25, 0.25, 1.0, 1.0 )
					local name = info[ 1 ]
					local x = Round( ( info[ 3 ] / 100 ) * WorldMapDetailFrame:GetWidth() )		-- Convert from TomTom
					local y = Round( ( info[ 4 ] / 100 ) * WorldMapDetailFrame:GetHeight() )	-- Convert from TomTom
					local offset = E.db.euiscript.tztb_icon / 32.0

					icon.frame:SetPoint( "CENTER", WorldMapDetailFrame, "TOPLEFT", x - offset, -y - offset )
					icon.frame:Show()

					icon.image.text = format( TzTB.db["Toy Rare: %s"], name )
					icon.image:SetPoint( "CENTER", WorldMapDetailFrame, "TOPLEFT", x, -y )
					icon.image:Show()
				end
			end
		end
	end

----------------------------------------------------------------
-- Pet Rares

	if E.db.euiscript.tztb then
		db = TzTB.db[ "PetRares" ]

		for _, info in ipairs( db ) do
			if C_Map.GetBestMapForUnit("player") == info[ 2 ] then
				local questCompleted = false

				for dbID = 5, #info, 1 do
					local questID = info[ dbID ]

					if IsQuestFlaggedCompleted( questID ) then
						questCompleted = true
					end
				end

				if not questCompleted then
					local icon = TzTanaanBonusIcons_Get( "interface/minimap/objecticons", 41, E.db.euiscript.tztb_icon, 0.25, 1.0, 0.25, 1.0 )
					local name = info[ 1 ]
					local x = Round( ( info[ 3 ] / 100 ) * WorldMapDetailFrame:GetWidth() )		-- Convert from TomTom
					local y = Round( ( info[ 4 ] / 100 ) * WorldMapDetailFrame:GetHeight() )	-- Convert from TomTom
					local offset = E.db.euiscript.tztb_icon / 32.0

					icon.frame:SetPoint( "CENTER", WorldMapDetailFrame, "TOPLEFT", x - offset, -y - offset )
					icon.frame:Show()

					icon.image.text = format( TzTB.db["Pet Rare: %s"], name )
					icon.image:SetPoint( "CENTER", WorldMapDetailFrame, "TOPLEFT", x, -y )
					icon.image:Show()
				end
			end
		end
	end

----------------------------------------------------------------
-- Tiny Terrors

	if E.db.euiscript.tztb then
		db = TzTB.db[ "TinyTerrors" ]

		for _, info in ipairs( db ) do
			if C_Map.GetBestMapForUnit("player") == info[ 2 ] then
				local questCompleted = false

				for dbID = 5, #info, 1 do
					local questID = info[ dbID ]

					if IsQuestFlaggedCompleted( questID ) then
						questCompleted = true
					end
				end

				if not questCompleted then
					local icon = TzTanaanBonusIcons_Get( "interface/minimap/objecticons", 34, E.db.euiscript.tztb_icon, 1.0, 1.0, 0.25, 1.0 )
					local name = info[ 1 ]
					local x = Round( ( info[ 3 ] / 100 ) * WorldMapDetailFrame:GetWidth() )		-- Convert from TomTom
					local y = Round( ( info[ 4 ] / 100 ) * WorldMapDetailFrame:GetHeight() )	-- Convert from TomTom
					local offset = E.db.euiscript.tztb_icon / 32.0

					icon.frame:SetPoint( "CENTER", WorldMapDetailFrame, "TOPLEFT", x - offset, -y - offset )
					icon.frame:Show()

					icon.image.text = format( TzTB.db["Pet Rare: %s"], name )
					icon.image:SetPoint( "CENTER", WorldMapDetailFrame, "TOPLEFT", x, -y )
					icon.image:Show()
				end
			end
		end
	end
end )
end
--TzTanaanBonus.lua end--
