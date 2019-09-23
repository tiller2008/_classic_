local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');

--Cache global variables
--Lua functions

--WoW API / Variables
local CreateFrame = CreateFrame
local CAN_HAVE_TANKSHIELD = (E.myclass == "PALADIN" or E.myclass == "DRUID" or E.myclass == "DEATHKNIGHT" or E.myclass == "WARRIOR" or E.myclass == "MONK")

function UF:Configure_TankShield(frame)
	--TankShield
	if CAN_HAVE_TANKSHIELD then
		local TankShield = frame.TankShield
		local db = frame.db

		if db.tankshield.enable then
			if not frame:IsElementEnabled('TankShield') then
				frame:EnableElement('TankShield')
			end
			local pOffset = 0
			if frame.USE_POWERBAR_OFFSET then pOffset = db.power.offset end

			TankShield:ClearAllPoints()
			TankShield.sb:ClearAllPoints()
			if db.tankshield.sizeOverride == 0 then
				TankShield:Point("TOPLEFT", frame.Health.backdrop, "TOPRIGHT", frame.SPACING + pOffset + db.tankshield.xOffset, db.tankshield.yOffset)
				if frame.USE_INSET_POWERBAR or USE_MINI_POWERBAR then
					TankShield:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", frame.SPACING + frame.UNIT_HEIGHT - frame.POWERBAR_HEIGHT + db.tankshield.xOffset,  db.tankshield.yOffset)
				elseif frame.USE_POWERBAR_OFFSET then
					TankShield:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", frame.SPACING + frame.UNIT_HEIGHT + pOffset + db.tankshield.xOffset, -pOffset + db.tankshield.yOffset)
				elseif frame.POWERBAR_DETACHED then
					TankShield:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", frame.SPACING + frame.UNIT_HEIGHT + db.tankshield.xOffset, db.tankshield.yOffset)
				else
					TankShield:Point("BOTTOMRIGHT", frame.Power.backdrop, "BOTTOMRIGHT", frame.SPACING + frame.UNIT_HEIGHT - pOffset + db.tankshield.xOffset, db.tankshield.yOffset)
				end
			else
				TankShield:Point("TOPLEFT", frame.Health.backdrop, "TOPRIGHT", frame.SPACING + pOffset + db.tankshield.xOffset, db.tankshield.yOffset)
				TankShield:Size(db.tankshield.sizeOverride)
			end
			TankShield.sb:Point("TOPLEFT", TankShield, "TOPRIGHT", (frame.BORDER + frame.SPACING), -frame.BORDER)
			TankShield.sb:Point("BOTTOMRIGHT", TankShield, "BOTTOMRIGHT", 12, frame.BORDER)
		else
			if TankShield then
				TankShield:ClearAllPoints()
				TankShield.sb:ClearAllPoints()
				TankShield:Size(0.001)
			end
			if frame:IsElementEnabled('TankShield') then
				frame:DisableElement('TankShield')
			end
		end	
	end
end

function UF:Construct_TankShield(frame)
	if not CAN_HAVE_TANKSHIELD then return; end

	local bs = CreateFrame("Button", nil, frame, "SecureActionButtonTemplate")
	bs:RegisterForClicks('AnyUp')
	bs:SetTemplate()
	bs:StyleButton()
	bs:SetFrameStrata('LOW')
	bs:SetFrameLevel(frame:GetFrameLevel() + 2)
	bs:SetAlpha(0)
	
	bs.Icon = bs:CreateTexture(nil, 'ARTWORK')
	bs.Icon:Point("TOPLEFT", 2, -2)
	bs.Icon:Point("BOTTOMRIGHT", -2, 2)
	bs.Icon:SetTexCoord(.08, .92, .08, .92)

	bs.time = bs:CreateFontString(nil, 'OVERLAY')
	bs.time:FontTemplate(UF.LSM:Fetch("font", E.db.unitframe.font), E.db.unitframe.units.player.height * 0.6, 'OUTLINE')
	bs.time:SetPoint("CENTER")
	bs.time:SetTextColor(1,1,0)

	bs.text = bs:CreateFontString(nil, 'OVERLAY')
	bs.text:FontTemplate(UF.LSM:Fetch("font", E.db.unitframe.font), E.db.unitframe.fontSize + 2, 'OUTLINE')
	bs.text:Point("BOTTOMRIGHT", bs, "BOTTOMRIGHT", 0, -1)

	bs.text2 = bs:CreateFontString(nil, 'OVERLAY')
	bs.text2:FontTemplate(UF.LSM:Fetch("font", E.db.unitframe.font), E.db.unitframe.fontSize + 2, 'OUTLINE')
	bs.text2:Point("TOPLEFT", bs, "TOPLEFT", 0, 1)
	
	bs.sb = CreateFrame("StatusBar", nil, bs)
	bs.sb:SetOrientation("VERTICAL")
	bs.sb:SetStatusBarTexture(E["media"].normTex)
	bs.sb:SetStatusBarColor(0.8, 0.1, 0.1)
	bs.sb:CreateBackdrop()	
	bs.sb:SetAlpha(0)
	
	return bs
end