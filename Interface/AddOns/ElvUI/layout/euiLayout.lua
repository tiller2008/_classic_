local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LO = E:GetModule('Layout');

local function CreateInfobar(name)
	if not name then return end
	
	local f = CreateFrame('Frame', name, E.UIParent)
	f:SetTemplate("Default", true)
--	f:CreateShadow()
	f:SetFrameLevel(200)
	f:SetFrameStrata('BACKGROUND')

	return f
end

function LO:ChangeSize(f, step)
	local num = 1
	
	if step then num = step end

	f:Size(E.db.infobar.width * num, E.db.infobar.height)
end

function LO:ChangePositon()
	TopDataTextsBar4:Point("TOP", E.UIParent, "TOP", 0, -2)
	TopDataTextsBar1:Point("RIGHT", TopDataTextsBar4, "LEFT", -2, 0)
	TopDataTextsBar3:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -2)
	TopDataTextsBar2:Point("LEFT", TopDataTextsBar4, "RIGHT", 2, 0)
	
	--Reposition/Resize and Reuse the World Marker Button
	if E.db['datatexts']['panels']['TopDataTextsBar3'].left ~= '' and E.db['datatexts']['panels']['TopDataTextsBar3'].right ~= '' and E.db['datatexts']['panels']['TopDataTextsBar3'].middle ~= '' then
		if not CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton then return; end
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:ClearAllPoints()
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetFrameLevel(2)	
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetPoint("LEFT", TopDataTextsBar3, "RIGHT", 2, 0)
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetParent(TopDataTextsBar3)
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetSize(E.db.infobar.height, E.db.infobar.height)
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetTemplate("Defautl", true)
	end	
end

function LO:InfoBar()
	local f1 = CreateInfobar('TopDataTextsBar1')
	local f2 = CreateInfobar('TopDataTextsBar2')
	local f3 = CreateInfobar('TopDataTextsBar3')
	local f4 = CreateInfobar('TopDataTextsBar4')
	
	self:ChangeSize(f1)
	self:ChangeSize(f2)
	self:ChangeSize(f3, 3)
	self:ChangeSize(f4, 2)
	
	E:GetModule('DataTexts'):RegisterPanel(f1, 1, 'ANCHOR_TOPLEFT', -17, 4)
	E:GetModule('DataTexts'):RegisterPanel(f2, 1, 'ANCHOR_TOPLEFT', -17, 4)
	E:GetModule('DataTexts'):RegisterPanel(f3, 3, 'ANCHOR_TOPLEFT', -17, 4)
	E:GetModule('DataTexts'):RegisterPanel(f4, 1, 'ANCHOR_TOPLEFT', -17, 4)
	
	self:ChangePositon()

	E:CreateMover(f1, 'EuiInfoBar1Mover', L['EuiInfoBar']..'1', nil, nil, nil, 'ALL,EUI', nil, 'datatexts')
	E:CreateMover(f2, 'EuiInfoBar2Mover', L['EuiInfoBar']..'2', nil, nil, nil, 'ALL,EUI', nil, 'datatexts')
	E:CreateMover(f3, 'EuiInfoBar3Mover', L['EuiInfoBar']..'3', nil, nil, nil, 'ALL,EUI', nil, 'datatexts')
	E:CreateMover(f4, 'EuiInfoBar4Mover', L['EuiInfoBar']..'4', nil, nil, nil, 'ALL,EUI', nil, 'datatexts')
	
	E.FrameLocks['TopDataTextsBar1'] = true;
	E.FrameLocks['TopDataTextsBar2'] = true;
	E.FrameLocks['TopDataTextsBar3'] = true;
	E.FrameLocks['TopDataTextsBar4'] = true;
end