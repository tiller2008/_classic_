-- Handynotes Worldmap Button by fuba
local L = LibStub("AceLocale-3.0"):GetLocale("HandyNotes", false)

  local FOLDER_NAME = ...
  local Frame = CreateFrame("Frame");

  local iconDefault = [[Interface\AddOns\]] .. FOLDER_NAME .. [[\Buttons\Default]];
  local iconDisabled = [[Interface\AddOns\]] .. FOLDER_NAME .. [[\Buttons\Disabled]];

  local btn = CreateFrame("Button", "HandyNotesWorldMapButton", WorldMapFrame, "UIPanelButtonTemplate");

  function SetIconTexture()
    if HandyNotes:IsEnabled() then
      btn:SetNormalTexture(iconDefault);
    else
      btn:SetNormalTexture(iconDisabled);
    end
  end

  function SetIconTooltip(IsRev)
		if not WorldMapTooltip then return end
    WorldMapTooltip:Hide();
    WorldMapTooltip:SetOwner(btn, "ANCHOR_BOTTOMLEFT");
    if HandyNotes:IsEnabled() then
      WorldMapTooltip:AddLine(L["TEXT_TOOLTIP_HIDE_ICONS"], nil, nil, nil, nil, 1 );
    else
      WorldMapTooltip:AddLine(L["TEXT_TOOLTIP_SHOW_ICONS"], nil, nil, nil, nil, 1 );
    end
	if IsAddOnLoaded('GatherMate2') then
		WorldMapTooltip:AddLine(GatherMate2.db.profile["showWorldMap"] and L["RIGHTBUTTON_TEXT_TOOLTIP_HIDE_GATHERMATEICONS"] or L["RIGHTBUTTON_TEXT_TOOLTIP_SHOW_GATHERMATEICONS"], nil, nil, nil, nil, 1 );
	end
    WorldMapTooltip:Show();
  end

  btn:ClearAllPoints();
  btn:SetPoint("TOPRIGHT", WorldMapFrame.BorderFrame, "TOPRIGHT", -48, -3);
  btn:EnableMouse(true)
  btn:RegisterForClicks("AnyUp");
  btn:SetSize(16, 16);
  btn:SetText("");
  SetIconTexture();
  btn:Hide();

  local function btnOnEnter(self, motion)
    SetIconTexture();
    SetIconTooltip(false);
  end

  local function btnOnLeave(self, motion)
    SetIconTexture();
		if WorldMapTooltip then
			WorldMapTooltip:Hide();
		end
  end

  local function btnOnClick(self, btn)
	if btn == 'RightButton' and IsAddOnLoaded('GatherMate2') then
		GatherMate2.db.profile["showWorldMap"] = not GatherMate2.db.profile["showWorldMap"]
		GatherMate2:GetModule("Config"):UpdateConfig()
	else
		local db = LibStub("AceDB-3.0"):New("HandyNotesDB", defaults).profile;

		if HandyNotes:IsEnabled() then
		  db.enabled = false
		  HandyNotes:Disable();
		else
		  db.enabled = true
		  HandyNotes:Enable();
		end
		SetIconTexture();
		SetIconTooltip(false);
	end
  end

  btn:SetScript("OnClick", btnOnClick);
  btn:SetScript("OnEnter", btnOnEnter);
  btn:SetScript("OnLeave", btnOnLeave);

  local function OnEvent(self, event, ...)
    if (event == "PLAYER_ENTERING_WORLD") then
    --  if IsAddOnLoaded('HandyNotes') then
        if btn then
          SetIconTexture();
          btn:Show();
        end;
    --  else
    --    if btn then btn:Hide(); end
    --  end
    end

    -- Move the MapsterOptionsButton by the Width of HandyNotesWorldMapButton to prevent overlap
    if event == "ADDON_LOADED" then
      if (MapsterOptionsButton) and (not MapsterOptionsButton.MovedByHandyNotesWorldMapButton) then
        point, relativeTo, relativePoint, xOfs, yOfs = MapsterOptionsButton:GetPoint()
        MapsterOptionsButton:ClearAllPoints();
        MapsterOptionsButton:SetPoint(point, relativeTo, relativePoint, xOfs - btn:GetWidth() - 5, yOfs);
        Frame:UnregisterEvent("ADDON_LOADED");
        MapsterOptionsButton.MovedByHandyNotesWorldMapButton = true;
      end
    end
  end

  Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
  Frame:RegisterEvent("ADDON_LOADED")
  Frame:SetScript("OnEvent", OnEvent)
