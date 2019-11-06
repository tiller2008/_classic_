local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Config", "AceConsole-3.0")
local loc = GetLocale()

local db
local Locale = {
	['zhCN'] = {
		["SilverDragon"] = "稀有检测SilverDragon",
		['About'] = '关于',
		['Scanning'] = '扫描',
		['Scan interval'] = '扫描间隔',
		["How often to scan for nearby rares, in seconds (0 disables scanning)"] = "扫描附近稀有的频率,以秒为单位(0 则禁用扫描)",
		["Recording delay"] = "记录延迟",
		["How long to wait before recording the same rare again"] = "再次记录同个稀有的间隔时间",
		["Scan in instances"] = "在地下城扫描",
		["Scan on taxis"] = "飞行时扫描",
		["Outputs"] = "输出",
		["Icon settings"] = "图标设置",
		["Icon Scale"] = "图标比例",
		["The scale of the icons"] = "图标的缩放比例",
		["Icon Alpha"] = "图标透明度",
		["The alpha transparency of the icons"] = "图标的透明度",
		["What to display"] = "显示什么",
		["Reset hidden mobs"] = "复位隐藏的",
		["Show all nodes that you manually hid by right-clicking on them and choosing \"hide\"."] = "显示所有标志你可以手工右键点击来隐藏它"
		
	},
	['zhTW'] = {
		["SilverDragon"] = "稀有檢測SilverDragon",
		['About'] = '關於',
		['Scanning'] = '掃描',
		['Scan interval'] = '掃描間隔',
		["How often to scan for nearby rares, in seconds (0 disables scanning)"] = "掃描附近稀有的頻率,以秒為單位(0 則禁用掃描)",
		["Recording delay"] = "記錄延遲",
		["How long to wait before recording the same rare again"] = "再次記錄同個稀有的間隔時間",
		["Scan in instances"] = "在地下城掃描",
		["Scan on taxis"] = "飛行時掃描",
		["Outputs"] = "輸出",
	}
}

local function GetLocaleText(tag)
	if Locale[loc] and Locale[loc][tag] then
		return Locale[loc][tag]
	else
		return tag
	end
end
module.GetLocaleText = GetLocaleText

local function toggle(name, desc, order, inline)
	return {
		type = "toggle",
		name = GetLocaleText(name),
		desc = desc,
		order = order,
		descStyle = (inline or (inline == nil)) and "inline" or nil,
		width = (inline or (inline == nil)) and "full" or nil,
	}
end
module.toggle = toggle

local function desc(text, order)
	return {
		type = "description",
		name = GetLocaleText(text),
		order = order,
		fontSize = "medium",
	}
end
module.desc = desc

local options = {
	type = "group",
	name = GetLocaleText("SilverDragon"),
	get = function(info) return db[info[#info]] end,
	set = function(info, v) db[info[#info]] = v end,
	args = {
		about = {
			type = "group",
			name = GetLocaleText("About"),
			args = {
				about = desc("SilverDragon keeps an eye out for rare mobs for you.\n\n"..
						"If you want to change how it does that, go to the \"Scanning\" section "..
						"of the config. You can enable or disable the different methods used, and "..
						"adjust how some of them behave.\n\n"..
						"If you want to adjust the way the targeting popup appears, go to the \"ClickTarget\" "..
						"section.\n\n"..
						"If you want to change how you're told about seeing a rare, check out the "..
						"\"Outputs\" section.\n\n"..
						"If you want to add a custom mob to scan for, look at \"Custom\" in the \"Mobs\" "..
						"section.\n\n"..
						"If you want SilverDragon to please, please stop telling you about a certain "..
						"mob, look at \"Ignore\" in the \"Mobs\" section."),
			},
			order = 0,
		},
		scanning = {
			type = "group",
			name = GetLocaleText("Scanning"),
			order = 10,
			args = {
				about = desc("SilverDragon is all about scanning for rare mobs. The options you see in this tab apply generally to all the scanning methods used. For more specific controls, check out the sub-sections.", 0),
				scan = {
					type = "range",
					name = GetLocaleText("Scan interval"),
					desc = GetLocaleText("How often to scan for nearby rares, in seconds (0 disables scanning)"),
					min = 0, max = 10, step = 0.1,
					order = 10,
				},
				delay = {
					type = "range",
					name = GetLocaleText("Recording delay"),
					desc = GetLocaleText("How long to wait before recording the same rare again"),
					min = 30, max = (60 * 60), step = 10,
					order = 20,
				},
				instances = toggle("Scan in instances", "There aren't that many actual rares in instances, and scanning might slow things down at a time when you'd like the most performance possible.", 50),
				taxi = toggle("Scan on taxis", "Keep scanning for rares while flying on a taxi. Just hope that it'll still be there after you land and make your way back...", 55),
			},
			plugins = {},
		},
		outputs = {
			type = "group",
			name = GetLocaleText("Outputs"),
			order = 20,
			args = {
				about = desc("SilverDragon wants to tell you things. Check out the sub-sections here to adjust how it does that.", 0),
			},
			plugins = {},
		},
	},
	plugins = {
	},
}
module.options = options

function module:OnInitialize()
	db = core.db.profile

	options.plugins["profiles"] = {
		profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(core.db)
	}
	options.plugins.profiles.profiles.order = -1 -- last!

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SilverDragon", options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SilverDragon", "SilverDragon")
	self:RegisterChatCommand("silverdragon", "OnChatCommand")
end

function module:OnChatCommand(input)
	local command, args = self:GetArgs(input, 2)
	if command then
		command = command:lower()
		if command == 'debug' then
			core:ShowDebugWindow()
		end
	else
		self:ShowConfig()
	end
end

function module:ShowConfig()
	LibStub("AceConfigDialog-3.0"):Open("SilverDragon")
end
