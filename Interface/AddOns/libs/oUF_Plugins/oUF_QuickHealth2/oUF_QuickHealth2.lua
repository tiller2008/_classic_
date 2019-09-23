--[[ oUF_QuickHealth2 by Rubin
based on Grid_QuickHealth by cncfanatics
]]

if not oUF then return end

local QuickHealth = LibStub("LibQuickHealth-2.0");


-- env changement code taken from interruptus
local proxyEnv = setmetatable(
	{
		UnitHealth = QuickHealth.UnitHealth,
	}, 
	{
		__index    = _G,
		__newindex = function (t, k, v) _G[k] = v end,
	}
)

local function UnitHealthUpdated(event, unitID, newHealth)
	for i, frame in ipairs(oUF.objects) do
		if frame.unit == unitID then
			frame:UpdateElement("Health")
			break
		end
	end
end

local function hook(frame)
	if frame.ignoreQuickHealth then return end
	for i, update in ipairs(frame.__elements) do
		setfenv(update, proxyEnv)
	end
	local health = frame.Health
	if(health) then
		if(health:GetScript'OnUpdate') then
			health:SetScript('OnUpdate', nil)
		else
			frame:UnregisterEvent('UNIT_HEALTH', Update)
		end
		frame:UnregisterEvent('UNIT_MAXHEALTH', Update)
	end
end
for i, frame in ipairs(oUF.objects) do hook(frame) end
oUF:RegisterInitCallback(hook)

QuickHealth.RegisterCallback("oUF_QuickHealth2", "UnitHealthUpdated", UnitHealthUpdated)