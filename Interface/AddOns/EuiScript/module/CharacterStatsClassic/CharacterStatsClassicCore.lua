-- Access the namespace
local _, core = ...;
local E = unpack(ElvUI)

local characterStatsClassicEventFrame = CreateFrame("Frame");
characterStatsClassicEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
characterStatsClassicEventFrame:RegisterEvent("UNIT_MODEL_CHANGED");
characterStatsClassicEventFrame:RegisterEvent("UNIT_LEVEL");
characterStatsClassicEventFrame:RegisterEvent("UNIT_RESISTANCES");
characterStatsClassicEventFrame:RegisterEvent("UNIT_STATS");
characterStatsClassicEventFrame:RegisterEvent("UNIT_DAMAGE");
characterStatsClassicEventFrame:RegisterEvent("UNIT_RANGEDDAMAGE");
characterStatsClassicEventFrame:RegisterEvent("PLAYER_DAMAGE_DONE_MODS");
characterStatsClassicEventFrame:RegisterEvent("UNIT_ATTACK_SPEED");
characterStatsClassicEventFrame:RegisterEvent("UNIT_ATTACK_POWER");
characterStatsClassicEventFrame:RegisterEvent("UNIT_RANGED_ATTACK_POWER");
characterStatsClassicEventFrame:RegisterEvent("UNIT_ATTACK");
characterStatsClassicEventFrame:RegisterEvent("PLAYER_GUILD_UPDATE");
characterStatsClassicEventFrame:RegisterEvent("SKILL_LINES_CHANGED");

characterStatsClassicEventFrame:SetScript("OnEvent",
    function(self, event, ...)
		if not E.db.euiscript.csc then return end

        core.UIConfig:UpdateStats();
    end)

--locale
CSC_DEFENSE = DEFENSE;

local locale = GetLocale()

if locale == 'zhCN' or locale == 'zhTW' then
	CSC_WEAPON_SKILLS_HEADER    = "武器技能";
else
	CSC_WEAPON_SKILLS_HEADER    = "Weapon Skills";
end
	