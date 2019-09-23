local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');

--Cache global variables
--Lua functions

--WoW API / Variables
local CreateFrame = CreateFrame

function UF:Configure_SwingBar(frame)
	local swing = frame.Swing
	local db = frame.db

	if db.Swing.enable then
		if not frame:IsElementEnabled('Swing') then
			frame:EnableElement('Swing')
		end
		swing:Width(db.Swing.width - (E.PixelMode and 2 or (frame.BORDER * 2)))
		swing:Height(db.Swing.height)
		
		
		swing.Holder:Width(db.Swing.width + (E.PixelMode and 0 or (frame.BORDER * 2)))
		swing.Holder:Height(db.Swing.height + (E.PixelMode and 2 or (frame.BORDER * 2)))
		
		swing.Holder:GetScript('OnSizeChanged')(swing.Holder)
		swing.Text:ClearAllPoints()
		if db.Swing.text then
			swing.Text:Point("LEFT", swing, "LEFT", 4, 0)
		end
		swing:SetStatusBarColor(db.Swing.color.r, db.Swing.color.g, db.Swing.color.b)
	else
		if frame:IsElementEnabled('Swing') then
			frame:DisableElement('Swing')
		end
	end

	--GCD Bar
	local gcd = frame.GCD
	if db.gcd then
		if not frame:IsElementEnabled('GCD') then
			frame:EnableElement('GCD')
		end
		gcd:ClearAllPoints()
		gcd:Point("BOTTOMLEFT", frame, "TOPLEFT", 0, 0)
		gcd.Color = {db.Swing.color.r, db.Swing.color.g, db.Swing.color.b}
		gcd:Width(db.width)
		gcd:Height(3)
		gcd.height = 3
		gcd.width = 4
	else
		if frame:IsElementEnabled('GCD') then
			frame:DisableElement('GCD')
		end
	end	
end

function UF:Construct_SwingBar(frame)
	local sbar = CreateFrame("Statusbar", frame:GetName()..'SwingBar', frame)
	
	UF['statusbars'][sbar] = true
	sbar:SetClampedToScreen(true)
	sbar:CreateBackdrop()
	sbar:SetStatusBarTexture(E["media"].normTex)

	sbar.bg = sbar:CreateTexture(nil, 'BORDER')
	sbar.bg:SetAllPoints(sbar)
	sbar.bg:SetVertexColor(RAID_CLASS_COLORS[E.myclass].r,RAID_CLASS_COLORS[E.myclass].g,RAID_CLASS_COLORS[E.myclass].b, 0.2)
	sbar.bg:Hide()
	
	sbar.Text = sbar:CreateFontString(nil, 'OVERLAY')
	UF:Configure_FontString(sbar.Text)
	sbar.Text:SetTextColor(0.84, 0.75, 0.65)
	sbar.Text:SetPoint("CENTER", 0, 0)
	
	local holder = CreateFrame('Frame', nil, frame)
	holder:Point("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -(frame.BORDER * 3))
	sbar:Point('BOTTOMRIGHT', holder, 'BOTTOMRIGHT', -frame.BORDER, frame.BORDER)
	
	sbar.Holder = holder
	
	E:CreateMover(sbar.Holder, frame:GetName()..'SwingBarMover', L['Swing'], nil, -6, nil, 'ALL,SOLO')
	
	return sbar
end

function UF:Construct_GCDBar(frame)
	local bar = CreateFrame("Frame", frame:GetName().."GcdBar", frame)
	bar:SetFrameStrata("HIGH")
	bar.Color = {1,1,1}
	bar.height = 3
	bar.width = 4

	return bar
end