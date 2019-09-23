--[[
    Copyright (c) 2014-2015 by Adam Hellberg.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
]]

local MAJOR = "LibBodyguard-1.0"
local MINOR = 7

local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

local band, bor = bit.band, bit.bor

local BODYGUARD_FLAGS = bor(COMBATLOG_OBJECT_TYPE_GUARDIAN,
                            COMBATLOG_OBJECT_CONTROL_PLAYER,
                            COMBATLOG_OBJECT_REACTION_FRIENDLY,
                            COMBATLOG_OBJECT_AFFILIATION_MINE)

local reputation_spells = {
    [174225] = true, [174699] = true, [174685] = true, [174673] = true, [174692] = true, [174697] = true, [174232] = true,
    [174674] = true, [174689] = true, [174642] = true, [174638] = true, [174651] = true, [174663] = true, [174238] = true,
    [174234] = true, [174659] = true, [174645] = true, [174649] = true, [174639] = true, [174695] = true, [174653] = true,
    [174683] = true, [174660] = true, [174235] = true, [174703] = true, [174700] = true, [174647] = true, [174657] = true,
    [174693] = true, [174658] = true, [174640] = true, [174666] = true, [174667] = true, [174670] = true, [174668] = true,
    [174675] = true, [174224] = true, [174677] = true, [174680] = true, [174180] = true, [174701] = true, [174681] = true,
    [174203] = true, [174228] = true, [174687] = true, [174236] = true, [174655] = true, [174676] = true, [174652] = true,
    [174656] = true, [174202] = true, [174230] = true, [174694] = true, [174698] = true, [174237] = true, [174679] = true,
    [174199] = true, [174688] = true, [174702] = true, [174646] = true, [174654] = true, [174229] = true, [174669] = true,
    [174671] = true, [174181] = true, [174182] = true, [174672] = true, [174696] = true, [174682] = true, [174200] = true,
    [174201] = true, [174231] = true, [174678] = true, [174686] = true, [174684] = true, [174233] = true, [174187] = true,
    [174661] = true, [174641] = true, [174648] = true, [174179] = true, [174227] = true
}

-- The various spells for maintaining bodyguards
local maintain_spells = {
    [173636] = true, -- Aeda Brightdawn
    [175950] = true, -- Aeda Brightdawn
    [173639] = true, -- Defender Illona
    [175945] = true, -- Defender Illona
    [173638] = true, -- Delvar Ironfist
    [175948] = true, -- Delvar Ironfist
    [173995] = true, -- Leorajh
    [173637] = true, -- Talonpriest Ishaal
    [173450] = true, -- Tormmok
    [173635] = true, -- Vivianne
    [175952] = true  -- Vivianne
}

-- The various spells for summoning bodyguards
local summon_spells = {
    [173631] = true, -- Aeda Brightdawn
    [175949] = true, -- Aeda Brightdawn
    [173634] = true, -- Defender Illona
    [175943] = true, -- Defender Illona
    [173633] = true, -- Delvar Ironfist
    [175947] = true, -- Delvar Ironfist
    [173993] = true, -- Leorajh
    [173632] = true, -- Talonpriest Ishaal
    [173449] = true, -- Tormmok
    [173630] = true, -- Vivianne
    [175951] = true  -- Vivianne
}

local defeated_spells = {
    [173663] = true, -- Aeda Brightdawn
    [173662] = true, -- Defender Illona
    [173664] = true, -- Delvar Ironfist
    [173977] = true, -- Leorajh
    [173665] = true, -- Talonpriest Ishaal
    [173656] = true, -- Tormmok
    [173666] = true  -- Vivianne
}

local defeated_debuffs = {
    [173660] = true, -- Aeda Brightdawn
    [173657] = true, -- Defender Illona
    [173658] = true, -- Delvar Ironfist
    [173976] = true, -- Leorajh
    [173659] = true, -- Talonpriest Ishaal
    [173649] = true, -- Tormmok
    [173661] = true  -- Vivianne
}

-- List of bodyguard spells in legion.
-- These are the "Combat Ally" ability listed for the follower,
-- and returned in the "zoneSupportSpellID" in the FollowerInfo.
local LEGION_SPELLS = {
    [219995] = true, -- Addie Fizzlebog
    [222820] = true, -- Akama
    [221713] = true, -- Arator the Redeemer
    [220125] = true, -- Archmage Modera
    [222964] = true, -- Belath Dawnblade
    [218603] = true, -- Broll Bearmantle
    [211945] = true, -- Chen Stormstout
    [222827] = true, -- Dvalen Ironrune
    [222365] = true, -- Koltira Deathweaver
    [220212] = true, -- Millhouse Manastorm
    [212145] = true, -- The Monkey King
    [217849] = true, -- Rehgar Earthfury
    [220814] = true, -- Rexxar
    [216090] = true, -- Ritssyn Flamescowl
    [222842] = true, -- Shade of Akama
    [222080] = true, -- Sol
    [218154] = true, -- Stormcaller Mylra
    [221496] = true, -- Vanessa VanCleef
    [221625] = true, -- Vindicator Boros
    [222070] = true  -- Zabra Hexx
}

local LEGION_BODYGUARDS = {
    [746] = true, -- Addie Fizzlebog
    [718] = true, -- Akama
    [758] = true, -- Arator the Redeemer
    [717] = true, -- Archmage Modera
    [594] = true, -- Belath Dawnblade
    [641] = true, -- Broll Bearmantle
    [596] = true, -- Chen Stormstout
    [714] = true, -- Dvalen Ironrune
    [599] = true, -- Koltira Deathweaver
    [723] = true, -- Millhouse Manastorm
    [602] = true, -- The Monkey King
    [612] = true, -- Rehgar Earthfury
    [743] = true, -- Rexxar
    [589] = true, -- Ritssyn Flamescowl
    [719] = true, -- Shade of Akama
    [872] = true, -- Sol
    [608] = true, -- Stormcaller Mylra
    [591] = true, -- Vanessa VanCleef
    [479] = true, -- Vindicator Boros
    [870] = true  -- Zabra Hexx
}

local DEFEATED_PATTERN = "^([%w%s]+) %w+"

-- Bodyguards in WoD and Legion have some differing behaviour,
-- so we need to do some things different depending on what kind of
-- bodyguard we're dealing with.
local MODE_WOD = 0
local MODE_LEGION = 1

local mode = nil

local CONTINENTS = {
    [572] = MODE_WOD,
    [619] = MODE_LEGION
}

local function GetCurrentMapContinent()
    local currentMapId = C_Map.GetBestMapForUnit("player")
    if currentMapId == nil then return 0 end
    local continent = MapUtil.GetMapParentInfo(currentMapId, Enum.UIMapType.Continent).mapID
    return continent
end

local function UpdateMode()
    mode = CONTINENTS[GetCurrentMapContinent()]
end

-- Get follower names for the defeated spells
for id, _ in pairs(defeated_spells) do
    local spellName = GetSpellInfo(id)
    local name = spellName:match(DEFEATED_PATTERN)
    if name then
        defeated_spells[id] = name
    end
end

-- Do the same for debuffs
for id, _ in pairs(defeated_debuffs) do
    local spellName = GetSpellInfo(id)
    local name = spellName:match(DEFEATED_PATTERN)
    if name then
        defeated_debuffs[id] = name
    end
end

-- Valid barracks IDs, 27 = lvl 2 barracks, 28 = lvl 3 barracks
local barracks_ids = {[27] = true, [28] = true}

--- Bodyguard status values.
-- @class table
-- @name lib.Status
-- @field Inactive Bodyguard is not with the player (stationed at barracks).
-- @field Active Bodyguard is with the player.
-- @field Unknown Status of bodyguard is unknown (this includes death).
lib.Status = {
    Inactive = 0,
    Active = 1,
    Unknown = 2
}

local bodyguard = {}

local function ResetBodyguard()
    bodyguard.name = nil
    bodyguard.level = 0
    bodyguard.health = 0
    bodyguard.max_health = 0
    bodyguard.npc_id = 0
    bodyguard.follower_id = 0
    bodyguard.last_known_guid = nil
    bodyguard.status = lib.Status.Unknown
    bodyguard.loaded_from_building = false
end

ResetBodyguard()

local callbacks = {
    guid = {},
    name = {},
    level = {},
    health = {},
    status = {},
    gossip_opened = {},
    gossip_closed = {}
}

local function RunCallback(cb_type, ...)
    for func, enabled in pairs(callbacks[cb_type]) do
        if enabled then pcall(func, lib, ...) end
    end
end

local frame = CreateFrame("Frame")

local events = {
    player = {}
}

local function UpdateFromGarrison()
    local buildings = C_Garrison.GetBuildings(LE_GARRISON_TYPE_6_0)
    for i = 1, #buildings do
        local building = buildings[i]
        local building_id = building.buildingID
        local plot_id = building.plotID
        if barracks_ids[building_id] then
            local name, level, quality, displayID, followerID, garrFollowerID, status, portraitIconID = C_Garrison.GetFollowerInfoForBuilding(plot_id)
            if not name then
                bodyguard.status = lib.Status.Inactive
                RunCallback("status", bodyguard.status)
                return
            end
            bodyguard.name = name
            bodyguard.level = level
            bodyguard.follower_id = garrFollowerID
            RunCallback("name", bodyguard.name)
            RunCallback("level", bodyguard.level)
            break
        end
    end
end

local function UpdateFromClassHall()
    local followers = C_Garrison.GetFollowers(LE_FOLLOWER_TYPE_GARRISON_7_0)

    local follower

    if followers then
        for _, f in pairs(followers) do
            if LEGION_BODYGUARDS[f.garrFollowerID] or LEGION_SPELLS[f.zoneSupportSpellID] then
                local status = C_Garrison.GetFollowerStatus(f.followerID)
                -- Check if status is "Combat Ally"
                -- ORDER_HALL_ZONE_SUPPORT
                -- GARRISON_FOLLOWER_COMBAT_ALLY
                if status == ORDER_HALL_ZONE_SUPPORT then
                    follower = f
                    break
                end
            end
        end
    end

    if not follower then
        bodyguard.status = lib.Status.Inactive
        RunCallback("status", bodyguard.status)
        return
    end

    bodyguard.name = follower.name
    bodyguard.level = follower.level
    bodyguard.follower_id = follower.followerID
    bodyguard.status = lib.Status.Active
    RunCallback("name", bodyguard.name)
    RunCallback("level", bodyguard.level)
    RunCallback("status", bodyguard.status)
end

local function UpdateFromBuildings()
    ResetBodyguard()
    bodyguard.loaded_from_building = true

    if mode == MODE_WOD then
        UpdateFromGarrison()
    elseif mode == MODE_LEGION then
        UpdateFromClassHall()
    end
end

local function UpdateFromUnit(unit)
    local name = UnitName(unit)
    if name ~= bodyguard.name then return end
    bodyguard.last_known_guid = UnitGUID(unit)
    bodyguard.health = UnitHealth(unit)
    bodyguard.max_health = UnitHealthMax(unit)
    RunCallback("guid", bodyguard.last_known_guid)
    RunCallback("health", bodyguard.health, bodyguard.max_health)
end

function events.GARRISON_BUILDING_ACTIVATED()
    UpdateFromBuildings()
end

function events.GARRISON_BUILDING_UPDATE(buildingID)
    if barracks_ids[buildingID] then UpdateFromBuildings() end
end

function events.GARRISON_FOLLOWER_REMOVED()
    UpdateFromBuildings()
end

function events.GARRISON_UPDATE()
    UpdateFromBuildings()
end

function events.PLAYER_TARGET_CHANGED(cause)
    if not bodyguard.name then return end
    if cause ~= "LeftButton" and cause ~= "up" then return end
    UpdateFromUnit("target")
end

function events.UPDATE_MOUSEOVER_UNIT()
    if not bodyguard.name then return end
    UpdateFromUnit("mouseover")
end

function events.UNIT_HEALTH(unit)
    if not unit or not bodyguard.name then return end
    UpdateFromUnit(unit)
end

function events.player.UNIT_SPELLCAST_SUCCEEDED(unit, name, id)
    if not summon_spells[id] then return end
    bodyguard.status = lib.Status.Active
    RunCallback("status", bodyguard.status)
end

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local function ParseCleuArgs(timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
    return timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, {...}
end

-- We listen to CLEU to find out when the bodyguard is damaged or healed
function events.COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, additional = ParseCleuArgs(CombatLogGetCurrentEventInfo())
    -- First find out if the destination (damaged or healed) is the player's bodyguard
    if not bodyguard.name or (not sourceName and not destName) then return end
    if sourceName == bodyguard.name then
        local isBodyguard = band(sourceFlags, BODYGUARD_FLAGS) == BODYGUARD_FLAGS
        if not isBodyguard then return end
        bodyguard.status = lib.Status.Active
        bodyguard.last_known_guid = sourceGUID
        RunCallback("guid", bodyguard.last_known_guid)
        RunCallback("status", bodyguard.status)
    elseif destName == bodyguard.name and bodyguard.status ~= lib.Status.Inactive then
        local isBodyguard = band(destFlags, BODYGUARD_FLAGS) == BODYGUARD_FLAGS
        if not isBodyguard then return end
        local prefix, suffix = event:match("^([A-Z_]+)_([A-Z]+)$")

        local amount_idx = 1

        if prefix:match("^SPELL") then
            amount_idx = 4
        elseif prefix == "ENVIRONMENTAL" then
            amount_idx = 2
        end

        local amount = additional[amount_idx]

        local changed = false

        if suffix == "DAMAGE" then
            bodyguard.health = bodyguard.health - amount
            changed = true
        elseif suffix == "HEAL" then
            bodyguard.health = bodyguard.health + amount
            if bodyguard.health >= bodyguard.max_health then
                bodyguard.health = bodyguard.max_health
            end
            changed = true
        elseif suffix == "INSTAKILL" then
            bodyguard.health = 0
            changed = true
        end

        if changed then
            if bodyguard.health <= 0 then
                bodyguard.health = 0
                -- We have only predicted death, we can't be sure
                bodyguard.status = lib.Status.Unknown
            else
                bodyguard.status = lib.Status.Active
            end
            RunCallback("health", bodyguard.health, bodyguard.max_health)
            RunCallback("status", bodyguard.status)
        end
    end
end

function events.PLAYER_REGEN_ENABLED()
    -- If player goes out of combat, the bodyguard does too (presumably)
    -- And if bodyguard goes OOC, they instantly heal to full
    -- Return if the bodyguard is dead though, since a dead bodyguard doesn't
    -- heal back.
    -- ---
    -- In Legion, bodyguards do not heal up instantly, they behave like
    -- players and will slowly regen their health normally.
    if bodyguard.health <= 0 or mode == MODE_LEGION then return end
    bodyguard.health = bodyguard.max_health
    RunCallback("health", bodyguard.health, bodyguard.max_health)
end

function events.PLAYER_ENTERING_WORLD()
    UpdateMode()
end

function events.ZONE_CHANGED_NEW_AREA()
    UpdateMode()
end

local bodyguard_gossip_open = false
local bodyguard_confirm_showing = false

function events.GOSSIP_SHOW()
    if not lib:Exists() or UnitName("target") ~= bodyguard.name then return end
    bodyguard_gossip_open = true
    RunCallback("gossip_opened")
end

function events.GOSSIP_CLOSED()
    if bodyguard_gossip_open then RunCallback("gossip_closed") end
    bodyguard_gossip_open = false
    bodyguard_confirm_showing = false
end

function events.GOSSIP_CONFIRM(index, message, cost)
    if not bodyguard_gossip_open or cost ~= 0 then return end
    bodyguard_confirm_showing = true
end

function events.player.UNIT_AURA()
    for i = 1, 40 do
        local _, _, _, _, _, duration, expireTime, _, _, _, id = UnitDebuff("player", i)
        if not defeated_debuffs[id] then return end
        local name = defeated_debuffs[id]
        if name == bodyguard.name then
            -- The debuff means we can be certain the bodyguard is not with the player anymore
            bodyguard.status = lib.Status.Inactive
            bodyguard.health = 0
            RunCallback("status", bodyguard.status)
            RunCallback("health", bodyguard.health, bodyguard.max_health)
            return
        end
    end
end

frame:SetScript("OnEvent", function(f, e, ...)
    if events[e] then events[e](...) return end

    for key, val in pairs(events) do
        if type(val) == "table" then
            if val[e] then val[e](...) return end
        end
    end
end)

for key, val in pairs(events) do
    if type(val) == "function" then
        frame:RegisterEvent(key)
    elseif type(val) == "table" then
        for event, _ in pairs(val) do
            frame:RegisterUnitEvent(event, key)
        end
    end
end

-- Function hooks

function lib:GOSSIP_CONFIRM_Hook(s, data)
    if not bodyguard_confirm_showing then return end

    bodyguard.status = lib.Status.Inactive
    bodyguard.health = bodyguard.max_health
    RunCallback("status", bodyguard.status)
    RunCallback("health", bodyguard.health, bodyguard.max_health)
end

if not lib.GOSSIP_CONFIRM_Hooked then
    hooksecurefunc(StaticPopupDialogs.GOSSIP_CONFIRM, "OnAccept", function(self, data)
        lib:GOSSIP_CONFIRM_Hook(self, data)
    end)

    lib.GOSSIP_CONFIRM_Hooked = true
end

-- Public API

--- Gets a value indicating whether or not a bodyguard exists (is assigned to barracks).
-- @return Boolean indicating whether a bodyguard is assigned to the barracks.
function lib:Exists()
    return bodyguard.name and bodyguard.loaded_from_building
end

--- Updates bodyguard data from garrison building API.
-- This is reliable and will always populate the bodyguard table with accurate information.
-- Information available from garrison API is bodyguard name and level.
function lib:UpdateFromBuilding()
    UpdateFromBuildings()
end

--- Gets a read-only copy of the bodyguard table.
-- @return A read-only table that maps its index to the bodyguard table in the library.
function lib:GetInfo()
    return setmetatable({}, {__index = function(t, k) return bodyguard[k] end, __metatable = 'Forbidden'})
end

--- Gets the last known GUID of the bodyguard.
-- NOTE: This is not 100% reliable, GUID may change.
-- @return The last known GUID string of the bodyguard.
function lib:GetGUID()
    return bodyguard.last_known_guid
end

--- Gets the last known status of the bodyguard.
-- This can be any of the values defined in the lib.Status table
-- Inactive: Bodyguard is not currently with the player.
-- Active: Bodyguard is with the player.
-- Unknown: Bodyguard status is not known or uncertain (this includes death).
-- As with the GUID method, the bodyguard status is quite unreliable at this time.
-- @return The last known status of the bodyguard.
function lib:GetStatus()
    return bodyguard.status
end

--- Gets the name of the bodyguard.
-- @return The bodyguard's name (follower name).
function lib:GetName()
    return bodyguard.name
end

--- Gets the level of the bodyguard.
-- @return The bodyguard's level (follower level).
function lib:GetLevel()
    return bodyguard.level
end

--- Gets the bodyguard's health.
-- The value returned should be fairly accurate.
-- @return Current (predicted) health of the player's bodyguard.
function lib:GetHealth()
    return bodyguard.health
end

--- Gets the maximum health of the bodyguard.
-- @return The bodyguard's maximum health.
function lib:GetMaxHealth()
    return bodyguard.max_health
end

--- Gets a value indicating whether the bodyguard is alive.
-- @return A boolean value indicating whether the bodyguard is currently alive.
function lib:IsAlive()
    return self:GetHealth() > 0
end

--- Registers a function for a specific callback type.
-- This can be used to listen for certain events like health updates from the library.
-- Currently, the following callbacks are available: guid, name, health, level, status.
-- <ul>
-- <li>guid args: guid</li>
-- <li>name args: name</li>
-- <li>health args: health, max health</li>
-- <li>level args: level</li>
-- <li>status args: status</li>
-- </ul>
-- The first argument will always be a reference to the library table.
-- @param cb_type Callback type to listen for.
-- @param cb_func Function to call.
function lib:RegisterCallback(cb_type, cb_func)
    if not callbacks[cb_type] then error("Invalid callback type: " .. tostring(cb_type)) end
    if callbacks[cb_type][cb_func] then return end -- Silent fail if that callback func is already registered
    callbacks[cb_type][cb_func] = true
end

--- Unregisters a function from a specific callback type.
-- @param cb_type Callback type to unregister from.
-- @param cb_func The function to unregister (has to be the exact same function that was passed to the Register method).
function lib:UnregisterCallback(cb_type, cb_func)
    if not callbacks[cb_type] then error("Invalid callback type: " .. tostring(cb_type)) end
    callbacks[cb_type][cb_func] = nil
end
