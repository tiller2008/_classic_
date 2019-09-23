-- Engines
local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

E.Options.args.Watch = {
	type = "group",
	childGroups = "tree",
	name = '20.'..E.ValColor..L['SpellFilters']..'|r',
	args = {
		intro = {
			order = 0,
			type = 'description',
			name = L['SpellFilters Intro'],
			width = 'full',
		},
	}
}