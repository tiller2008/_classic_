local E, L = unpack(ElvUI) -- Import Functions/Constants, Config, Locales
local S = E:NewModule('NewFunc', 'AceEvent-3.0')

SPLASH_SCREENS['singleFunc'] = {
	id = 1,
	questID = nil,			
	leftTex = "splash-601-topleft",
	rightTex = "splash-601-right",
	bottomTex = "splash-601-botleft",
	header = 'EUI '..L['singleFunc'],
	label = '',
	feature1Title = L['singleFunc_desc'],
	feature1Desc = '',
	feature2Title = '',
	feature2Desc = '',
	rightTitle = '',
	rightDesc = '',
	cVar="singleFunc",
	features = {
		[1] = { EnterFunc = function() end,
				LeaveFunc = function() end,
				},
		[2] = { EnterFunc = function() end,
				LeaveFunc = function() end,
				},
	},
}

local function GetSplashFrameTag()
	local tag;
	local expansionLevel = GetExpansionLevel();
	if ( IsCharacterNewlyBoosted() ) then
		if ( expansionLevel >= SPLASH_SCREENS["BOOST2"].expansion ) then		
			tag = "BOOST2";
		else
			tag = "BOOST";
		end
	else
		if ( expansionLevel >= SPLASH_SCREENS["NEW"].expansion) then
			tag = "NEW";
		else
			local playerLevel = UnitLevel("player");
			tag = (playerLevel >= 90 and "BASE_90") or "BASE";
		end
	end
	return tag;
end

function S:Initialize()
	local tag = GetSplashFrameTag();
	local playerLevel = UnitLevel("player");
	-- check if they've seen this screen already
	local lastScreenID = tonumber(GetCVar(SPLASH_SCREENS[tag].cVar)) or 0;
	if( lastScreenID >= SPLASH_SCREENS[tag].id ) or (not tag) or ( playerLevel < 20 ) then
		if E.global.general.newFuncShown then
			SplashFrame_Open('singleFunc')
			SplashFrame.EuiTexture = SplashFrame:CreateTexture(nil, 'OVERLAY')
			SplashFrame.EuiTexture:SetSize(780, 500);
			SplashFrame.EuiTexture:SetPoint("TOP", SplashFrame.Header, "BOTTOM", 8, -15);
			SplashFrame.EuiTexture:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\singleFunc.blp')
		--	SplashFrame.LeftTexture	--371*434
		--	SplashFrame.RightTexture --510*584
		--	SplashFrame.BottomTexture --371*137
			
			E.global.general.newFuncShown = false;
		end
	end
end

E:RegisterModule(S:GetName())