local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');

--Lua functions
local random = random
--WoW API / Variables
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local _, ns = ...
local ElvUF = ns.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

function UF:Construct_PowerBar(frame, bg, text, textPos)
	local power = CreateFrame('StatusBar', nil, frame)
	UF.statusbars[power] = true

	hooksecurefunc(power, 'SetStatusBarColor', function(_, r, g, b)
		if frame and frame.PowerPrediction and frame.PowerPrediction.mainBar then
			if UF and UF.db and UF.db.colors and UF.db.colors.powerPrediction and UF.db.colors.powerPrediction.enable then
				local color = UF.db.colors.powerPrediction.color
				frame.PowerPrediction.mainBar:SetStatusBarColor(color.r, color.g, color.b, color.a)
			else
				frame.PowerPrediction.mainBar:SetStatusBarColor(r * 1.25, g * 1.25, b * 1.25)
			end
		end
	end)

	power.RaisedElementParent = CreateFrame('Frame', nil, power)
	power.RaisedElementParent:SetFrameLevel(power:GetFrameLevel() + 100)
	power.RaisedElementParent:SetAllPoints()

	power.PostUpdate = self.PostUpdatePower
	power.PostUpdateColor = self.PostUpdatePowerColor

	if bg then
		if E.db.unitframe.transparent and E.db.unitframe.powertrans and E.db.general.transparentStyle == 2 then
			local pbg = CreateFrame("Frame", nil, power)
			pbg:SetFrameLevel(power:GetFrameLevel()-2)
			pbg:SetAllPoints(power)
			pbg:SetAlpha(0)
			local b = pbg:CreateTexture(nil, "BACKGROUND")
			b:SetTexture(E["media"].normTex)
			b:SetAllPoints(power)
			power.BG = b
			power.pbg = pbg
		else
			power.BG = power:CreateTexture(nil, 'BORDER')
			power.BG:SetAllPoints()
			power.BG:SetTexture(E["media"].blankTex)
		end
	end

	if text then
		power.value = frame.RaisedElementParent:CreateFontString(nil, 'OVERLAY')
		UF:Configure_FontString(power.value)

		local x = -2
		if textPos == 'LEFT' then
			x = 2
		end

		power.value:Point(textPos, frame.Health, textPos, x, 0)
	end

	local clipFrame = CreateFrame('Frame', nil, power)
	clipFrame:SetClipsChildren(true)
	clipFrame:SetAllPoints()
	clipFrame:EnableMouse(false)
	clipFrame.__frame = frame
	power.ClipFrame = clipFrame

	power.useAtlas = false
	power.colorDisconnected = false
	power.colorTapping = false
	power:CreateBackdrop(nil, nil, nil, self.thinBorders, true)

	return power
end

function UF:Configure_Power(frame)
	if not frame.VARIABLES_SET then return end
	local db = frame.db
	local power = frame.Power
	power.origParent = frame

	if frame.USE_POWERBAR then
		if not frame:IsElementEnabled('Power') then
			frame:EnableElement('Power')
			power:Show()
		end

		E:SetSmoothing(power, self.db.smoothbars)

		--Text
		local attachPoint = self:GetObjectAnchorPoint(frame, db.power.attachTextTo)
		power.value:ClearAllPoints()
		power.value:Point(db.power.position, attachPoint, db.power.position, db.power.xOffset, db.power.yOffset)
		frame:Tag(power.value, db.power.text_format)

		if db.power.attachTextTo == "Power" then
			power.value:SetParent(power.RaisedElementParent)
		else
			power.value:SetParent(frame.RaisedElementParent)
		end

		if db.power.reverseFill then
			power:SetReverseFill(true)
		else
			power:SetReverseFill(false)
		end

		--Party/Raid Frames allow to change statusbar orientation
		if db.power.orientation then
			power:SetOrientation(db.power.orientation)
		end

		--Colors
		power.colorClass = nil
		power.colorReaction = nil
		power.colorPower = nil

		if self.db.colors.powerclass then
			power.colorClass = true
			power.colorReaction = true
		else
			power.colorPower = true
		end

		--Fix height in case it is lower than the theme allows
		local heightChanged = false
		if (not self.thinBorders and not E.PixelMode) and frame.POWERBAR_HEIGHT < 7 then --A height of 7 means 6px for borders and just 1px for the actual power statusbar
			frame.POWERBAR_HEIGHT = 7
			if db.power then db.power.height = 7 end
			heightChanged = true
		elseif (self.thinBorders or E.PixelMode) and frame.POWERBAR_HEIGHT < 3 then --A height of 3 means 2px for borders and just 1px for the actual power statusbar
			frame.POWERBAR_HEIGHT = 3
			if db.power then db.power.height = 3 end
			heightChanged = true
		end
		if heightChanged then
			--Update health size
			frame.BOTTOM_OFFSET = UF:GetHealthBottomOffset(frame)
			UF:Configure_HealthBar(frame)
		end

		--Position
		power:ClearAllPoints()
		if frame.POWERBAR_DETACHED then
			power:Width(frame.POWERBAR_WIDTH - ((frame.BORDER + frame.SPACING)*2))
			power:Height(frame.POWERBAR_HEIGHT - ((frame.BORDER + frame.SPACING)*2))

			if frame.unitframeType and (frame.unitframeType == "player" or frame.unitframeType == "target") and not power.Holder then
				power.Holder = CreateFrame("Frame", nil, power)
				power.Holder:Size(frame.POWERBAR_WIDTH, frame.POWERBAR_HEIGHT)
				power.Holder:Point("BOTTOM", frame, "BOTTOM", 0, -20)
				power:ClearAllPoints()
				power:Point("BOTTOMLEFT", power.Holder, "BOTTOMLEFT", frame.BORDER+frame.SPACING, frame.BORDER+frame.SPACING)
				--Currently only Player and Target can detach power bars, so doing it this way is okay for now
				if frame.unitframeType == "player" then
					E:CreateMover(power.Holder, 'PlayerPowerBarMover', L["Player Powerbar"], nil, nil, nil, 'ALL,SOLO', nil, 'unitframe,player,power')
				elseif frame.unitframeType == "target" then
					E:CreateMover(power.Holder, 'TargetPowerBarMover', L["Target Powerbar"], nil, nil, nil, 'ALL,SOLO', nil, 'unitframe,target,power')
				end
			end

			if power.Holder then
				E:EnableMover(power.Holder.mover:GetName())
				power.Holder:Size(frame.POWERBAR_WIDTH, frame.POWERBAR_HEIGHT)
				power:Point("BOTTOMLEFT", power.Holder, "BOTTOMLEFT", frame.BORDER+frame.SPACING, frame.BORDER+frame.SPACING)
			end

			power:SetFrameLevel(50) --RaisedElementParent uses 100, we want lower value to allow certain icons and texts to appear above power
		elseif frame.USE_POWERBAR_OFFSET then
			if frame.ORIENTATION == "LEFT" then
				power:Point("TOPRIGHT", frame.Health, "TOPRIGHT", frame.POWERBAR_OFFSET, -frame.POWERBAR_OFFSET)
				power:Point("BOTTOMLEFT", frame.Health, "BOTTOMLEFT", frame.POWERBAR_OFFSET, -frame.POWERBAR_OFFSET)
			elseif frame.ORIENTATION == "MIDDLE" then
				power:Point("TOPLEFT", frame, "TOPLEFT", frame.BORDER + frame.SPACING, -frame.POWERBAR_OFFSET -frame.CLASSBAR_YOFFSET)
				power:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -frame.BORDER - frame.SPACING, frame.BORDER)
			else
				power:Point("TOPLEFT", frame.Health, "TOPLEFT", -frame.POWERBAR_OFFSET, -frame.POWERBAR_OFFSET)
				power:Point("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT", -frame.POWERBAR_OFFSET, -frame.POWERBAR_OFFSET)
			end
			power:SetFrameLevel(frame.Health:GetFrameLevel() - 5) --Health uses 10
		elseif frame.USE_INSET_POWERBAR then
			power:Height(frame.POWERBAR_HEIGHT  - ((frame.BORDER + frame.SPACING)*2))
			power:Point("BOTTOMLEFT", frame.Health, "BOTTOMLEFT", frame.BORDER + (frame.BORDER*2), frame.BORDER + (frame.BORDER*2))
			power:Point("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT", -(frame.BORDER + (frame.BORDER*2)), frame.BORDER + (frame.BORDER*2))
			power:SetFrameLevel(50)
		elseif frame.USE_MINI_POWERBAR then
			power:Height(frame.POWERBAR_HEIGHT  - ((frame.BORDER + frame.SPACING)*2))

			if frame.ORIENTATION == "LEFT" then
				power:Width(frame.POWERBAR_WIDTH - frame.BORDER*2)
				power:Point("RIGHT", frame, "BOTTOMRIGHT", -(frame.BORDER*2 + 4), ((frame.POWERBAR_HEIGHT-frame.BORDER)/2))
			elseif frame.ORIENTATION == "RIGHT" then
				power:Width(frame.POWERBAR_WIDTH - frame.BORDER*2)
				power:Point("LEFT", frame, "BOTTOMLEFT", (frame.BORDER*2 + 4), ((frame.POWERBAR_HEIGHT-frame.BORDER)/2))
			else
				power:Point("LEFT", frame, "BOTTOMLEFT", (frame.BORDER*2 + 4), ((frame.POWERBAR_HEIGHT-frame.BORDER)/2))
				power:Point("RIGHT", frame, "BOTTOMRIGHT", -(frame.BORDER*2 + 4 + (frame.PVPINFO_WIDTH or 0)), ((frame.POWERBAR_HEIGHT-frame.BORDER)/2))
			end

			power:SetFrameLevel(50)
		else
			power:Point("TOPRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", -frame.BORDER,  -frame.SPACING*3)
			power:Point("TOPLEFT", frame.Health.backdrop, "BOTTOMLEFT", frame.BORDER, -frame.SPACING*3)
			power:Height(frame.POWERBAR_HEIGHT  - ((frame.BORDER + frame.SPACING)*2))

			power:SetFrameLevel(frame.Health:GetFrameLevel() + 5)
		end

		if not frame.POWERBAR_DETACHED and power.Holder then
			E:DisableMover(power.Holder.mover:GetName())
		end

		if db.power.strataAndLevel and db.power.strataAndLevel.useCustomStrata then
			power:SetFrameStrata(db.power.strataAndLevel.frameStrata)
		else
			power:SetFrameStrata(frame:GetFrameStrata())
		end

		if db.power.strataAndLevel and db.power.strataAndLevel.useCustomLevel then
			power:SetFrameLevel(db.power.strataAndLevel.frameLevel)
		end

		power.backdrop:SetFrameLevel(power:GetFrameLevel() - 1)


		if frame.POWERBAR_DETACHED and db.power.parent == "UIPARENT" then
			E.FrameLocks[power] = true
			power:SetParent(E.UIParent)
		else
			E.FrameLocks[power] = nil
			power:SetParent(frame)
		end
	elseif frame:IsElementEnabled('Power') then
		frame:DisableElement('Power')
		power:Hide()
		frame:Tag(power.value, "")
	end

	frame.Power.custom_backdrop = UF.db.colors.custompowerbackdrop and UF.db.colors.power_backdrop

	--Transparency Settings
	UF:ToggleTransparentStatusBar(UF.db.colors.transparentPower, frame.Power, frame.Power.BG, nil, UF.db.colors.invertPower)

	--Prediction Texture; keep under ToggleTransparentStatusBar
	UF:UpdatePredictionStatusBar(frame.PowerPrediction, frame.Power, "Power")
end

local tokens = {[0]="MANA","RAGE","FOCUS","ENERGY","RUNIC_POWER"}
function UF:PostUpdatePowerColor()
	local parent = self.origParent or self:GetParent()
	if parent.isForced then
		local color = ElvUF.colors.power[tokens[random(0,4)]]
		self:SetValue(random(1, self.max))

		if not self.colorClass then
			self:SetStatusBarColor(color[1], color[2], color[3])

			if self.BG then
				UF:UpdateBackdropTextureColor(self.BG, color[1], color[2], color[3])
			end
		end
	end
end

function UF:PostUpdatePower(unit, cur, _, max)
	local parent = self.origParent or self:GetParent()
	if parent.isForced then
		self:SetValue(random(1, max))
	end

	if parent.db and parent.db.power then
		if unit == 'player' and parent.db.power.autoHide and parent.POWERBAR_DETACHED then
			if (cur == 0) then
				self:Hide()
			else
				self:Show()
			end
		elseif not self:IsShown() then
			self:Show()
		end

		if parent.db.power.hideonnpc then
			UF:PostNamePosition(parent, unit)
		end
	end
end
