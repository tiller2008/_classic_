local E = unpack(ElvUI)
--Author: shenxian
--Version: 1.0.6
--原作者shenxian, eui.cc于2014.1.6重新改写
local _, class = UnitClass('player')
if class ~= 'MAGE' or not E.db.euiscript.shenxian.enable then return; end

local SPELLNAME1,_, TEXTURE1 = GetSpellInfo(30451)--奥术冲击
local SPELLNAME2,_, TEXTURE2 = GetSpellInfo(5143)--奥术飞弹
local SPELLNAME3,_, TEXTURE3 = GetSpellInfo(44425)--奥术弹幕

local ShenxianFrame = CreateFrame("Frame", "EUIShenxianFrame", E.UIParent)
ShenxianFrame:Size(E.db.euiscript.shenxian.size, E.db.euiscript.shenxian.size)


ShenxianFrame:Point("CENTER", E.UIParent, "CENTER", 0, 150)
ShenxianFrame:SetFrameStrata("LOW")

ShenxianFrame:SetTemplate()
E:CreateMover(ShenxianFrame, "ShenxianFrameMover", SPELLNAME1, nil, nil, nil, "ALL,EUI")
ShenxianFrame:Hide()


local ShenxianIcon = ShenxianFrame:CreateTexture(nil, "BACKGROUND")
ShenxianIcon:SetDrawLayer('BACKGROUND', 2)
ShenxianIcon:SetAllPoints()
ShenxianIcon:SetTexCoord(unpack(E.TexCoords))
ShenxianIcon:SetInside()
ShenxianIcon:SetTexture(TEXTURE1)

local function CheckUnitBuff(IsSpellId)
	for i = 1, 40, 1 do
		local name, icon, count, _, _, _, _, _, _, spellID = UnitBuff("player", i)
		if not name then break end
		if IsSpellId == spellID then
			return name, count
		end
	end
	return nil
end

local function PlayInfo()
	local mana = UnitMana("player")
	local _, manaregen = GetManaRegen()
	local nowtime = GetTime()*1000
	local spelledbuff1, spelledbuff2, spelledbuff3, buff1, buff2, buff3
	local buff1Name = GetSpellInfo(36032)
	local buff2Name = GetSpellInfo(79683)
	local buff3Name = GetSpellInfo(145252)
	
--	if UnitAura("player",buff1Name,nil, "HARMFUL") then
	if CheckUnitBuff(36032) then
		buff1 = select(2,CheckUnitBuff(36032)
	else
		buff1 = 0
	end

	if CheckUnitBuff(79683) then
--	if UnitAura("player",buff2Name,nil, "HELPFUL") then
		buff2 = select(2,CheckUnitBuff(79683)
	else
		buff2 = 0 
	end

	if CheckUnitBuff(145252) then
--	if UnitAura("player",buff3Name,nil, "HELPFUL") then
		buff3 = select(2,CheckUnitBuff(145252)
	else
		buff3 = 0 
	end

	spelledbuff1 = buff1
	spelledbuff2 = buff2
	spelledbuff3 = buff3
	local spellname = ""
	local spellcost = 0
	local endtime = 0
	if UnitCastingInfo("player") then
		spellcost = select(4,GetSpellInfo(select(1,UnitCastingInfo("player")))) or 0
		spellname = select(1,UnitCastingInfo("player"))
		endtime = select(5,UnitCastingInfo("player")) or 0
	elseif UnitChannelInfo("player") then
		spellcost = select(4,GetSpellInfo(select(1, UnitChannelInfo("player")))) or 0


		spellname = select(1,UnitChannelInfo("player"))
		endtime = select(5,UnitChannelInfo("player")) or 0
	else
		endtime = GetTime()*1000
		spellcost = 0
	end
	
	local spelledmana = (endtime-nowtime)/1000*manaregen+mana-spellcost
	if spelledmana > 300000 then
		spelledmana = 300000
	end
	local spelledmanapct = spelledmana/300000*100
	if spellname == SPELLNAME1  then
		spelledbuff3 = 0
		if buff1<4 then
		spelledbuff1 = buff1+1
		end
	elseif spellname == SPELLNAME2 and buff1<4 then
		spelledbuff1 = buff1+1
	end

	if E.db.euiscript.shenxian.selectmodel==1 then
		nextcast=0
		if spelledbuff1<2 then
			nextcast=1
		elseif spelledbuff1>=2 and spelledbuff2==2 then
			nextcast=2
		elseif (spelledbuff1==2 or spelledbuff1==3) and spelledbuff2<2 then
			nextcast=1
		elseif spelledbuff1==4 and spelledbuff2==1 then
			if spelledbuff3>2 then
				nextcast=1
			elseif spelledbuff3==2 and spelledmanapct>99 then
				nextcast=1
			else
				nextcast=2
			end
		elseif spelledbuff1==4 and spelledbuff2==0 then
			if spelledbuff3==0 then
				if spelledmanapct>96 then
					nextcast=1
				else
					nextcast=3
				end
			elseif spelledbuff3==1 then
				if spelledmanapct>92 then
					nextcast=1
				else
					nextcast=3
				end
			elseif spelledbuff3>1 then
				nextcast=1
			end
		end
	else
		if spelledbuff2 == 2 then
			nextcast = 2
		elseif spelledbuff1 == 4 and spelledmanapct > 93 and spelledbuff3 > 0 then
			nextcast = 1
		elseif spelledbuff1 == 4 and spelledbuff2 == 1 then
			nextcast = 2
		elseif spelledbuff1 == 4 and spelledmanapct < 96 then
			nextcast = 3
		else
			nextcast = 1
		end
	end
	if nextcast == 1 then
		ShenxianIcon:SetTexture(TEXTURE1)
	elseif nextcast == 2 then
		ShenxianIcon:SetTexture(TEXTURE2)
	elseif nextcast == 3 then
		ShenxianIcon:SetTexture(TEXTURE3)
	end
end

ShenxianFrame:RegisterEvent("CHARACTER_POINTS_CHANGED")
ShenxianFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ShenxianFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
ShenxianFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
ShenxianFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
ShenxianFrame:SetScript("OnEvent", function(self, event)
	if event == 'PLAYER_TARGET_CHANGED' then
		if not UnitName('target') then
			self:SetScript("OnUpdate", nil);
		elseif UnitCanAttack("player", 'target') then
			self:SetScript("OnUpdate", PlayInfo)
		end
	elseif event == 'PLAYER_REGEN_DISABLED' then
		if E.db.euiscript.shenxian.combat then
			self:SetAlpha(1)
			self:SetScript("OnUpdate", PlayInfo)
		end
	elseif event == 'PLAYER_REGEN_ENABLED' then
		if E.db.euiscript.shenxian.combat then
			self:SetAlpha(0)
			self:SetScript("OnUpdate", nil)
		end
	else
		if event == 'PLAYER_ENTERING_WORLD' then
			if E.db.euiscript.shenxian.combat and not InCombatLockdown() then
				self:SetAlpha(0)
			end
		end
		local currentSpec = GetSpecialization();
		if not currentSpec or (currentSpec and currentSpec > 1) then	-- no specs
			self:Hide()
			self:SetScript("OnUpdate", nil)
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
			self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		end
		if currentSpec == 1 then
			self:Show()
			self:RegisterEvent("PLAYER_TARGET_CHANGED")
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
end)