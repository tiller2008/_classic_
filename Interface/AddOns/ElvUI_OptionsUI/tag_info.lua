local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');


-- Create a container frame
local f = E.Libs.AceGUI:Create("Frame")
f:SetTitle("ElvUI Unitframe Tags")
f:SetStatusText("")
f:SetLayout("Fill")
f:Hide()

local text = E.Libs.AceGUI:Create("MultiLineEditBox")
text:SetText([[
	testtesttesttesttesttesttesttesttesttesttesttesttesttest testtesttesttesttesttesttesttesttesttesttesttesttesttest
	testtesttesttesttesttesttesttesttesttesttesttesttesttestesttesttesttesttesttesttesttesttesttesttesttesttesttestesttesttesttesttesttesttesttesttesttesttesttesttesttes
	testtesttesttesttesttesttesttesttesttesttesttesttesttes
	testtesttesttesttesttesttesttesttesttesttesttesttesttes
	testtesttesttesttesttesttesttesttesttesttesttesttesttes
	testtesttesttesttesttesttesttesttesttesttesttesttesttestesttesttesttesttesttesttesttesttesttesttesttesttesttestesttesttesttesttesttesttesttesttesttesttesttesttesttes
	testtesttesttesttesttesttesttesttesttesttesttesttesttes testtesttesttesttesttesttesttesttesttesttesttesttesttes
	testtesttesttesttesttesttesttesttesttesttesttesttesttes
	]])
text:SetLabel("")
text:DisableButton(true)
text:SetNumLines(28)
text:SetMaxLetters(0)
text:SetRelativeWidth(1)
text:SetFullWidth(true)
f:AddChild(text)

UF.TagInfoFrame = f
