local E, L, V, P, G = unpack(ElvUI)
local framelist, self, aura, classCat
local select = select
local UnitGUID, GetSpellInfo, GetTime, pairs, print = UnitGUID, GetSpellInfo, GetTime, pairs, print
local class = select(2, UnitClass('player'))
local CooldownFrame_Set = CooldownFrame_Set
local GetSpellTexture = GetSpellTexture

-- DRtime controls how long it takes for the icons to reset. Several factors can affect how DR resets.
-- If you are experiencing constant problems with DR reset accuracy, you can change this value
local DRtime = 18

framelist = {
	--[FRAME NAME]	= {UNITID,SIZE,ANCHOR,ANCHORFRAME,X,Y,"ANCHORNEXT","ANCHORPREVIOUS",nextx,nexty},
	-- My settings
	["ElvUF_Arena1"]	= {"arena1",29,"TOPRIGHT","BOTTOMLEFT",-2,-2,"RIGHT","LEFT",-2,0},
	["ElvUF_Arena2"]	= {"arena2",29,"TOPRIGHT","BOTTOMLEFT",-2,-2,"RIGHT","LEFT",-2,0},
	["ElvUF_Arena3"]	= {"arena3",29,"TOPRIGHT","BOTTOMLEFT",-2,-2,"RIGHT","LEFT",-2,0},
	["ElvUF_Arena4"]	= {"arena4",29,"TOPRIGHT","BOTTOMLEFT",-2,-2,"RIGHT","LEFT",-2,0},
	["ElvUF_Arena5"]	= {"arena5",29,"TOPRIGHT","BOTTOMLEFT",-2,-2,"RIGHT","LEFT",-2,0},
}

if GetLocale() == 'enUS' then
	L["Roots"]              = "Roots"
	L["Stuns"]              = "Stuns"
	L["Silences"]           = "Silences"
	L["Taunts"]             = "Taunts"
	L["Knockbacks"]         = "Knockbacks"
	L["Incapacitates"]      = "Incapacitates"
	L["Disorients"]         = "Disorients"
elseif GetLocale() == 'zhCN' then
	L["Knockbacks"] = "击退"
	L["Roots"] = "定身"
	L["Silences"] = "沉默"
	L["Stuns"] = "昏迷"
	L["Taunts"] = "嘲讽"
	L["Disorients"] = "迷惑"
	L["Incapacitates"] = "瘫痪"
elseif locale == "zhTW" then
	L["Knockbacks"] = "擊退"
	L["Roots"] = "定身"
	L["Silences"] = "沉默"
	L["Stuns"] = "昏迷"
	L["Taunts"] = "嘲諷"
	L["Disorients"] = "迷惑"
	L["Incapacitates"] = "癱瘓"
end

-- This is the config section for what DR categories to show for each class
if class == 'DEATHKNIGHT' then
	classCat = {
		["silence"] = true,
		["ctrlstun"] = true,
		["ctrlroot"] = true,
		}
elseif class == 'DRUID' then
	classCat = {
		["incapacitate"] = true,
		["silence"] = true,
		["disorient"] = true,
		["ctrlstun"] = true,
		["ctrlroot"] = true,
		}
elseif class == 'HUNTER' then
	classCat = {
		["incapacitate"] = true,
		["silence"] = false,
		["disorient"] = false,
		["ctrlstun"] = true,
		["ctrlroot"] = true,
		}
elseif class == 'MAGE' then
	classCat = {
		["incapacitate"] = true,
		["silence"] = false,
		["ctrlstun"] = false,
		["ctrlroot"] = true,
		}
elseif class == 'MONK' then
	classCat = {
		["incapacitate"] = true,
		["silence"] = false,
		["ctrlstun"] = true,
		["ctrlroot"] = true,
		}
elseif class == 'PALADIN' then
	classCat = {
		["incapacitate"] = true,
		["silence"] = true,
		["disorient"] = true,
		["ctrlstun"] = true,
		}
elseif class == 'PRIEST' then
	classCat = {
		["silence"] = true,
		["disorient"] = true,
		["ctrlroot"] = true,
		["incapacitate"] = true,
		}
elseif class == 'ROGUE' then
	classCat = {
		["incapacitate"] = true,
		["silence"] = true,
		["disorient"] = true,
		["ctrlstun"] = true,
		["ctrlroot"] = false,
		}
elseif class == 'SHAMAN' then
	classCat = {
	    ["silence"] = false,
		["incapacitate"] = true,
		["ctrlstun"] = true,
		["ctrlroot"] = true,
		}
elseif class == 'WARLOCK' then
	classCat = {
		["silence"] = false,
		["disorient"] = true,
		["ctrlstun"] = true,
		["incapacitate"] = true,
		}
elseif class == 'WARRIOR' then
	classCat = {
	    ["silence"] = false,
		["disorient"] = true,
		["ctrlstun"] = true,
		["ctrlroot"] = true,
		}
elseif class == 'DEMONHUNTER' then
	classCat = {
	    ["silence"] = true,
		["disorient"] = true,
		["ctrlstun"] = true,
		["ctrlroot"] = false,
		}
end

local function GetDrIcons() 
	if class == 'DEATHKNIGHT' then
		return {
		["ctrlstun"] = GetSpellTexture(108194), --Aspyxiate
		["ctrlroot"] = GetSpellTexture(96294), -- Chains of Ice (Chilblains Root)
		["silence"] = GetSpellTexture(47476), -- Strangulate
		}
	elseif class == 'DRUID' then
		return {
		["ctrlstun"] = GetSpellTexture(5211), -- Mighty Bash
		["disorient"] = GetSpellTexture(33786), -- Intimidating Roar
		["ctrlroot"] = GetSpellTexture(339), -- Entangling Roots
		["silence"] = GetSpellTexture(78675), -- Solar Beam
		["incapacitate"] = GetSpellTexture(99), -- Freezing Trap
		}
	elseif class == 'HUNTER' then
		return {
		["ctrlstun"] = GetSpellTexture(24394), -- Intimidation
		["incapacitate"] = GetSpellTexture(3355), -- Freezing Trap
		["ctrlroot"] = GetSpellTexture(128405), -- Narrow Escape
		}
	elseif class == 'MAGE' then
		return {
	--	["ctrlstun"] = GetSpellTexture(44572),
		["incapacitate"] = GetSpellTexture(118),
		["ctrlroot"] = GetSpellTexture(122),
		}
	elseif class == 'MONK' then
		return {
		["ctrlstun"] = GetSpellTexture(119381), -- Leg Sweep 
		["incapacitate"] = GetSpellTexture(115078), -- Paralysis
		["ctrlroot"] = GetSpellTexture(116706), -- Disable
		}
	elseif class == 'PALADIN' then
		return {
		["ctrlstun"] = GetSpellTexture(853), -- Hammer of Justice
		["incapacitate"] = GetSpellTexture(20066), -- Repentance
		["disorient"] = GetSpellTexture(105421), -- Turn Evil
		["silence"] = GetSpellTexture(31935), -- Avenger's Shield
		}
	elseif class == 'PRIEST' then
		return {
	--	["incapacitate"] = GetSpellTexture(9484), -- Shackle Undead
		["incapacitate"] = GetSpellTexture(64044), -- Psyhcic Horror
		["ctrlroot"] = GetSpellTexture(114404), -- Void Tendrils
		["silence"] = GetSpellTexture(15487), -- Silence
		["disorient"] = GetSpellTexture(8122),
		}
	elseif class == 'ROGUE' then
		return {
		["ctrlstun"] = GetSpellTexture(408),-- Kidney Shot
		["incapacitate"] = GetSpellTexture(6770), -- Sap
		["disorient"] = GetSpellTexture(2094), -- Blind
		["silence"] = GetSpellTexture(1330), -- Garrote
		}
	elseif class == 'SHAMAN' then
		return {
		["ctrlstun"] = GetSpellTexture(118905), -- Static Charge (Capacitor Totem)
		["incapacitate"] = GetSpellTexture(51514), -- Hex
		["ctrlroot"] = GetSpellTexture(64695), -- Earthgrab
		}
	elseif class == 'WARLOCK' then
		return {
		["ctrlstun"] = GetSpellTexture(89766), -- Axe Toss (Felguard)
		["disorient"] = GetSpellTexture(118699), -- Fear
		["incapacitate"] = GetSpellTexture(6789), -- Mortal Coil
		}
	elseif class == 'WARRIOR' then
		return {
		["ctrlstun"] = GetSpellTexture(132168), -- Shockwave
		["disorient"] = GetSpellTexture(5246), -- Intimidating Shout
		["ctrlroot"] = GetSpellTexture(107566), -- Staggering Shout 
		}
	elseif class == 'DEMONHUNTER' then
		return {
		["ctrlstun"] = GetSpellTexture(179057), -- Shockwave
		["disorient"] = GetSpellTexture(207685), -- Intimidating Shout
		["silence"] = GetSpellTexture(204490), -- Staggering Shout 
		}		
	end
		--["test"] = GetSpellTexture(80353)),
end

local function GetSpellDR() 
	return {
		--[[ INCAPACITATES ]]--
		-- Druid
		[    99] = {"incapacitate"}, -- Incapacitating Roar (talent)
		[236025] = {"incapacitate"}, -- Incapacitating Roar (talent)
		-- Demon Hunter
		[221527] = {"incapacitate"}, -- Imprisonment
		[217832] = {"incapacitate"}, -- Imprisonment
		-- Hunter
		[  3355] = {"incapacitate"}, -- Freezing Trap
		[203337] = {"incapacitate"}, -- Freezing Trap
		[ 19386] = {"incapacitate"}, -- Wyvern Sting
		[209790] = {"incapacitate"}, -- Freezing Arrow
		-- Mage
		[   118] = {"incapacitate"}, -- Polymorph
		[ 28272] = {"incapacitate"}, -- Polymorph (pig)
		[ 28271] = {"incapacitate"}, -- Polymorph (turtle)
		[ 61305] = {"incapacitate"}, -- Polymorph (black cat)
		[ 61721] = {"incapacitate"}, -- Polymorph (rabbit)
		[ 61780] = {"incapacitate"}, -- Polymorph (turkey)
		[126819] = {"incapacitate"}, -- Polymorph (procupine)
		[161353] = {"incapacitate"}, -- Polymorph (bear cub)
		[161354] = {"incapacitate"}, -- Polymorph (monkey)
		[161355] = {"incapacitate"}, -- Polymorph (penguin)
		[161372] = {"incapacitate"}, -- Polymorph (peacock)
		[ 82691] = {"incapacitate"}, -- Ring of Frost
		-- Monk
		[115078] = {"incapacitate"}, -- Paralysis
		-- Paladin
		[ 20066] = {"incapacitate"}, -- Repentance
		-- Priest
		[  9484] = {"incapacitate"}, -- Shackle Undead
		[ 64044] = {"incapacitate"}, -- Psychic Horror (Horror effect)
		[ 200196] = {"incapacitate"}, -- Holy Word: Chastise
		-- Rogue
		[  1776] = {"incapacitate"}, -- Gouge
		[  6770] = {"incapacitate"}, -- Sap
		-- Shaman
		[ 51514] = {"incapacitate"}, -- Hex
		[211004] = {"incapacitate"}, -- Hex (spider)
		[210873] = {"incapacitate"}, -- Hex (raptor)
		[211015] = {"incapacitate"}, -- Hex (cockroach)
		[211010] = {"incapacitate"}, -- Hex (snake)
		[196942] = {"incapacitate"}, -- Hex (snake)
		-- Warlock
		[   710] = {"incapacitate"}, -- Banish
		[  6789] = {"incapacitate"}, -- Mortal Coil
		-- Pandaren
		[107079] = {"incapacitate"},

		--[[ SILENCES ]]--
		-- Death Knight
		[ 47476] = {"silence"}, -- Strangulate
		-- Demon Hunter
		[204490] = {"silence"}, -- Sigil of Silence
		-- Druid
		-- Hunter
		[202933] = {"silence"}, -- Spider Sting (pvp talent)
		-- Mage
		-- Paladin
		[ 31935] = {"silence"}, -- Avenger's Shield
		-- Priest
		[ 15487] = {"silence"}, -- Silence
		[199683] = {"silence"}, -- Last Word (SW: Death silence)
		-- Rogue
		[  1330] = {"silence"}, -- Garrote
		-- Blood Elf
		[ 25046] = {"silence"}, -- Arcane Torrent (Energy version)
		[ 28730] = {"silence"}, -- Arcane Torrent (Priest/Mage/Lock version)
		[ 50613] = {"silence"}, -- Arcane Torrent (Runic power version)
		[ 69179] = {"silence"}, -- Arcane Torrent (Rage version)
		[ 80483] = {"silence"}, -- Arcane Torrent (Focus version)
		[129597] = {"silence"}, -- Arcane Torrent (Monk version)
		[155145] = {"silence"}, -- Arcane Torrent (Paladin version)
		[202719] = {"silence"}, -- Arcane Torrent (DH version)

		--[[ DISORIENTS ]]--
		-- Death Knight
		[207167] = {"disorient"}, -- Blinding Sleet (talent) -- FIXME: is this the right category?
		-- Demon Hunter
		[207685] = {"disorient"}, -- Sigil of Misery
		-- Druid
		[ 33786] = {"disorient"}, -- Cyclone
		[209753] = {"disorient"}, -- Cyclone
		-- Hunter
		[213691] = {"disorient"}, -- Scatter Shot
		[186387] = {"disorient"}, -- Bursting Shot
		-- Mage
		[ 31661] = {"disorient"}, -- Dragon's Breath
		-- Monk
		[198909] = {"disorient"}, -- Song of Chi-ji -- FIXME: is this the right category( tooltip specifically says disorient, so I guessed here)
		[202274] = {"disorient"}, -- Incendiary Brew -- FIXME: is this the right category( tooltip specifically says disorient, so I guessed here)
		-- Paladin
		[105421] = {"disorient"}, -- Blinding Light -- FIXME: is this the right category? Its missing from blizzard's list
		-- Priest
		[  8122] = {"disorient"}, -- Psychic Scream
		[   605] = {"disorient"}, -- Dominate Mind
		-- Rogue
		[  2094] = {"disorient"}, -- Blind
		-- Warlock
		[118699] = {"disorient"}, -- Fear -- probably unused
		[5782] = 118699, -- Fear -- new debuff ID since MoP
		[130616] = 118699, -- Fear (with Glyph of Fear)
		[  5484] = {"disorient"}, -- Howl of Terror (talent)
		[115268] = {"disorient"}, -- Mesmerize (Shivarra)
		[  6358] = {"disorient"}, -- Seduction (Succubus)
		-- Warrior
		[  5246] = {"disorient"}, -- Intimidating Shout (main target)

		--[[ CONTROL STUNS ]]--
		[108194] = {"ctrlstun"}, -- Asphyxiate (talent for unholy)
		[221562] = {"ctrlstun"}, -- Asphyxiate (baseline for blood)
		[ 91800] = {"ctrlstun"}, -- Gnaw (Ghoul)
		[ 91797] = {"ctrlstun"}, -- Monstrous Blow (Dark Transformation Ghoul)
		[207171] = {"ctrlstun"}, -- Winter is Coming (Remorseless winter stun)
		-- Demon Hunter
		[179057] = {"ctrlstun"}, -- Chaos Nova
		[200166] = {"ctrlstun"}, -- Metamorphosis
		[205630] = {"ctrlstun"}, -- Illidan's Grasp, primary effect
		[208618] = {"ctrlstun"}, -- Illidan's Grasp, secondary effect
		[211881] = {"ctrlstun"}, -- Fel Eruption
		-- Druid
		[203123] = {"ctrlstun"}, -- Maim
		[203126] = {"ctrlstun"}, -- Maim (with blood trauma pvp talent)
		[  5211] = {"ctrlstun"}, -- Mighty Bash
		[163505] = {"ctrlstun"}, -- Rake (Stun from Prowl)
		-- Hunter
		[117526] = {"ctrlstun"}, -- Binding Shot
		[ 24394] = {"ctrlstun"}, -- Intimidation
		-- Mage

		-- Monk
		[119381] =   {"ctrlstun"}, -- Leg Sweep
		-- Paladin
		[   853] = {"ctrlstun"}, -- Hammer of Justice
		-- Priest
		[200200] = {"ctrlstun"}, -- Holy word: Chastise
		[226943] = {"ctrlstun"}, -- Mind Bomb
		-- Rogue
		-- Shadowstrike note: 196958 is the stun, but it never applies to players,
		-- so I haven't included it.
		[  1833] = {"ctrlstun"}, -- Cheap Shot
		[   408] = {"ctrlstun"}, -- Kidney Shot
		[199804] = {"ctrlstun"}, -- Between the Eyes
		-- Shaman
		[118345] = {"ctrlstun"}, -- Pulverize (Primal Earth Elemental)
		[118905] = {"ctrlstun"}, -- Static Charge (Capacitor Totem)
		-- Warlock
		[ 89766] = {"ctrlstun"}, -- Axe Toss (Felguard)
		[ 30283] = {"ctrlstun"}, -- Shadowfury
		[171017] = {"ctrlstun"}, -- Shadowfury
		-- Warrior
		[132168] = {"ctrlstun"}, -- Shockwave
		[132169] = {"ctrlstun"}, -- Storm Bolt
		-- Tauren
		[ 20549] = {"ctrlstun"}, -- War Stomp

		--[[ ROOTS ]]--
		-- Death Knight
		[ 96294] = {"ctrlroot"}, -- Chains of Ice (Chilblains Root)
		[204085] = {"ctrlroot"}, -- Deathchill (pvp talent)
		-- Druid
		[   339] = {"ctrlroot"}, -- Entangling Roots
		[102359] = {"ctrlroot"}, -- Mass Entanglement (talent)
		[ 45334] = {"ctrlroot"}, -- Immobilized (wild charge, bear form)
		-- Hunter
		[ 53148] = {"ctrlroot"}, -- Charge (Tenacity pet)
		[162480] = {"ctrlroot"}, -- Steel Trap
		[190927] = {"ctrlroot"}, -- Harpoon
		[200108] = {"ctrlroot"}, -- Ranger's Net
		[212638] = {"ctrlroot"}, -- tracker's net
		[201158] = {"ctrlroot"}, -- Super Sticky Tar (Expert Trapper, Hunter talent, Tar Trap effect)
		-- Mage
		[   122] = {"ctrlroot"}, -- Frost Nova
		[ 33395] = {"ctrlroot"}, -- Freeze (Water Elemental)
		-- [157997] = {"ctrlroot"}, -- Ice Nova -- since 6.1, ice nova doesn't DR with anything
		[228600] = {"ctrlroot"}, -- Glacial spike (talent)
		-- Monk
		[116706] = {"ctrlroot"}, -- Disable
		-- Priest
		-- Shaman
		[ 64695] = {"ctrlroot"}, -- Earthgrab Totem

		[116706] = {"test"},		-- Testing purpose (Intel Mage)
		[   130] = {"test","disorient"},	-- Testing purpose (Slow Fall)
	}
end

function UpdateDRTracker(self)
	local time = self.start + DRtime - GetTime()

	if time < 0 then
		local frame = self:GetParent()
		frame.actives[self.cat] = nil
		self:SetScript("OnUpdate", nil)
		DisplayDrActives(frame)
	end
end

function DisplayDrActives(self)
--	print("mem DrTracker = "..GetAddOnMemoryUsage("Tukui_DrTracker"))
	if not self.actives then return end
	if not self.auras then self.auras = {} end
	local index
	local previous = nil
	index = 1
	
	for _, _ in pairs(self.actives) do
		local aura = self.auras[index]
		if not aura then
			aura = CreateFrame("Frame", "IldyUI"..self.target.."DrFrame"..index, self)
			aura:Width(self.size) -- default value
			aura:Height(self.size) -- default value
			aura:SetScale(1)
			aura:SetTemplate()
			if index == 1 then
				aura:Point("BOTTOMRIGHT", self.mover, "BOTTOMRIGHT", 0, 0)
			elseif index == 1 then
				aura:Point(self.anchor, self:GetParent().Health, self.anchorframe, self.x, self.y)
			else
				aura:Point(self.nextanchor, previous, self.nextanchorframe, self.nextx, self.nexty)
			end
			aura.icon = aura:CreateTexture("$parenticon", "ARTWORK")
			aura.icon:Point("TOPLEFT", 2, -2)
			aura.icon:Point("BOTTOMRIGHT", -2, 2)
			aura.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			aura.cooldown = CreateFrame("Cooldown", "$parentCD", aura, "CooldownFrameTemplate")
			aura.cooldown:SetAllPoints(aura.icon)
			aura.cooldown:SetReverse()
			E:RegisterCooldown(aura.cooldown)

			aura.cat = "cat"
			aura.start = 0
			
			-- insert aura
			self.auras[index] = aura
		end
		-- save previous
		previous = aura
		-- next
		index = index + 1
	end

	index = 1
	for cat, value in pairs(self.actives) do
		aura = self.auras[index]
		aura.icon:SetTexture(value.icon)
		if(value.dr == 1) then
			aura:SetBackdropBorderColor(1,1,0,1)
		elseif(value.dr == 2) then
			aura:SetBackdropBorderColor(1,.5,0,1)
		else
			aura:SetBackdropBorderColor(1,0,0,1)
		end
		CooldownFrame_Set(aura.cooldown, value.start, DRtime, 1)
		aura.start = value.start
		aura.cat = cat
		aura:SetScript("OnUpdate", UpdateDRTracker)
		aura.cooldown:Show()

		aura:Show()
		index = index + 1
	end
	
	-- Hide remaining
	for i = index, #self.auras, 1 do
		local aura = self.auras[i]
		aura:SetScript("OnUpdate", nil)
		aura:Hide()
	end
end

local spell = GetSpellDR()

local icon = GetDrIcons()

local eventRegistered = {
		["SPELL_AURA_APPLIED"] = true,
		["SPELL_AURA_REFRESH"] = true,
		["SPELL_AURA_REMOVED"] = true
		}

local function CombatLogCheck(self, ...)																-- Combat event handler
	local _, eventType, _, _, _, _, _, destGUID, _, _, _, spellID, spellName, _, auraType = CombatLogGetCurrentEventInfo()

	if( not eventRegistered[eventType] ) then
		return
	end

	if(destGUID ~= UnitGUID(self.target)) then
		return
	end

	-- Enemy gained a debuff
	local needupdate = false
	if( eventType == "SPELL_AURA_APPLIED" ) then
		if( auraType == "DEBUFF" and spell[spellID] ) then
		-- if( auraType == "BUFF" and spell[spellID]) then
			if not self.actives then self.actives = {} end
			for _,cat in pairs(spell[spellID]) do
				if classCat[cat] then
					if self.actives[cat] then
						if(self.actives[cat].start + DRtime < GetTime()) then
							self.actives[cat].start = GetTime()
							self.actives[cat].dr = 1
							self.actives[cat].icon = icon[cat]
						else
							self.actives[cat].start = GetTime()
							self.actives[cat].dr = 2*self.actives[cat].dr
							self.actives[cat].icon = icon[cat]
						end
					else
						self.actives[cat] = {}
						self.actives[cat].start = GetTime()
						self.actives[cat].dr = 1
						self.actives[cat].icon = icon[cat]
					end
				end
			end
			needupdate = true
		end

	-- Enemy had a debuff refreshed before it faded, so fade + gain it quickly
	elseif( eventType == "SPELL_AURA_REFRESH" ) then
		if( auraType == "DEBUFF" and spell[spellID] ) then
		-- if( auraType == "BUFF" and spell[spellID]) then
			if not self.actives then self.actives = {} end
			for _,cat in pairs(spell[spellID]) do
				if classCat[cat] then
					if(not self.actives[cat]) then
						self.actives[cat] = {}
						self.actives[cat].dr = 1
					end
					self.actives[cat].start = GetTime()
					self.actives[cat].dr = 2*self.actives[cat].dr
					self.actives[cat].icon = icon[cat]
				end
			end
			needupdate = true
		end

	-- Buff or debuff faded from an enemy
	elseif( eventType == "SPELL_AURA_REMOVED" ) then
		if( auraType == "DEBUFF" and spell[spellID] ) then
		-- if( auraType == "BUFF" and spell[spellID]) then
			if not self.actives then self.actives = {} end
			for _,cat in pairs(spell[spellID]) do
				if classCat[cat] then
					if self.actives[cat] then
						if(self.actives[cat].start + DRtime < GetTime()) then
							self.actives[cat].start = GetTime()
							self.actives[cat].dr = 1
							self.actives[cat].icon = icon[cat]
						else
							self.actives[cat].start = GetTime()
							self.actives[cat].dr = self.actives[cat].dr
							self.actives[cat].icon = icon[cat]
						end
					else
						self.actives[cat] = {}
						self.actives[cat].start = GetTime()
						self.actives[cat].dr = 1
						self.actives[cat].icon = icon[cat]
					end
				end
			end
			needupdate = true
		end
	end
	if (needupdate) then DisplayDrActives(self) end
end

--Drtracker Frame
for frame, target in pairs(framelist) do
	self = _G[frame]
	if self and E.db.euiscript.DRTracker then
		local DrTracker = CreateFrame("Frame", nil, self)
		DrTracker:SetFrameLevel(self.RaisedElementParent:GetFrameLevel() + 10) --set frame level
		DrTracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		DrTracker:SetScript("OnEvent",CombatLogCheck)
		DrTracker.target = target[1]
		DrTracker.size = E.db.euiscript.DRTrackerSize or target[2]
		DrTracker.anchor = target[3]
		DrTracker.anchorframe = target[4]
		DrTracker.x = target[5]
		DrTracker.y = target[6]
		DrTracker.nextanchor = target[7]
		DrTracker.nextanchorframe = target[8]
		DrTracker.nextx = target[9]
		DrTracker.nexty = target[10]	
		DrTracker:SetSize(target[2]*3+4, target[2]+2)
		DrTracker:SetPoint(target[3], self, target[4], target[5], target[6])
		E:CreateMover(DrTracker, self:GetName().."DRMover", L[self:GetName()]..L["DRTracker"], nil, nil, nil, 'ALL,ARENA')

		self.DrTracker = DrTracker
	end
end

local function tdr()
	-- don't allow moving while in combat
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	
	local testlist = {"disorient","incapacitate","ctrlroot"}
	
	for frame, target in pairs(framelist) do
		self = _G[frame].DrTracker
		if not self.actives then self.actives = {} end
		local dr = 1
		for _,cat in pairs(testlist) do
			if(not self.actives[cat]) then self.actives[cat] = {} end
			self.actives[cat].dr = dr
			self.actives[cat].start = GetTime()
			self.actives[cat].icon = icon[cat]
			dr = dr*2
		end
		DisplayDrActives(self)
	end
end

function E:changeClassCat()
	for k, v in pairs(E.db.euiscript.DRTrackerCatList) do
		classCat[k] = v
	end
end

SLASH_MOVINGDRTRACKER1 = "/tdr"
SlashCmdList["MOVINGDRTRACKER"] = tdr