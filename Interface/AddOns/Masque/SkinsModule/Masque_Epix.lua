local MSQ = LibStub("Masque", true)
if not MSQ then return end

local Resolution = GetCurrentResolution() > 0 and select(GetCurrentResolution(), GetScreenResolutions()) or nil
local Windowed = Display_DisplayModeDropDown:windowedmode()

Resolution = Resolution or (Windowed and GetCVar("gxWindowedResolution")) or GetCVar("gxFullscreenResolution")

local Mult = 768/string.match(Resolution, "%d+x(%d+)") / 0.9
local Scale = function(x) return Mult*math.floor(x/Mult+1.5) end

MSQ:AddSkin("Epix", {
	Icon = {
		Width = Scale(36),
		Height = Scale(36),
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Cooldown = {
		Width = 36,
		Height = 36,
	},
	ChargeCooldown = {
		Width = 36,
		Height = 36,
	},
	Name = {
		Width = 42,
		Height = 10,
		OffsetY = 2,
	},
	Count = {
		Width = 42,
		Height = 10,
		OffsetX = -3,
		OffsetY = 6,
	},
	HotKey = {
		Width = 42,
		Height = 10,
		OffsetX = -8,
		OffsetY = -5,
	},
	Duration = {
		Width = 42,
		Height = 10,
		OffsetY = -3,
	},
	Backdrop = {
		Width = Scale(42),
		Height = Scale(42),
		Texture = [[Interface\AddOns\Masque\SkinsModule\Masque_Epix\Backdrop]],
	},
	Normal = {
		Width = Scale(42),
		Height = Scale(42),
		Texture = [[Interface\AddOns\Masque\SkinsModule\Masque_Epix\Normal]],
		Color = { 0.125, 0.125, 0.125, 1 },
	},
	Pushed = {
		Width = Scale(36),
		Height = Scale(38),
		Texture = [[Interface\AddOns\Masque\SkinsModule\Masque_Epix\Overlay]],
		Color = { 1, 1, 1, 0.1 },
	},
	Highlight = {
		Width = Scale(36),
		Height = Scale(38),
		BlendMode = "ADD",
		Texture = [[Interface\AddOns\Masque\SkinsModule\Masque_Epix\Overlay]],
		Color = { 1, 1, 1, 0.1 },
	},
	Flash = {
		Width = Scale(36),
		Height = Scale(38),
		Color = { 1, 0, 0, 0.2 },
		Texture = [[Interface\AddOns\Masque\SkinsModule\Masque_Epix\Overlay]],
	},
	AutoCastable = {
		Width = 64,
		Height = 64,
		OffsetX = 0.5,
		OffsetY = -0.5,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	
}, true)