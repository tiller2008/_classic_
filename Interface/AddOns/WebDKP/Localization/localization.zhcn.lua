---
--- 由60addons创建并汉化(https://60addons.com)

if (GetLocale() ~= "zhCN") then
    return
end

local L = WebDKP.translations

--中文职业简称
L.CLASS_ALIAS_TO_ENG_MAP["LR"] = "hunter"
L.CLASS_ALIAS_TO_ENG_MAP["QS"] = "paladin"
L.CLASS_ALIAS_TO_ENG_MAP["ZS"] = "warrior"
L.CLASS_ALIAS_TO_ENG_MAP["FS"] = "mage"
L.CLASS_ALIAS_TO_ENG_MAP["SS"] = "warlock"
L.CLASS_ALIAS_TO_ENG_MAP["SM"] = "shaman"
L.CLASS_ALIAS_TO_ENG_MAP["DZ"] = "rogue"
L.CLASS_ALIAS_TO_ENG_MAP["MS"] = "priest"
L.CLASS_ALIAS_TO_ENG_MAP["XD"] = "druid"

--MinimapDropDown
L.WEBDKP_MINIMAPDROPDOWN_DKPTABLE = "DKP表"
L.WEBDKP_MINIMAPDROPDOWN_BIDDING = "竞拍"
L.WEBDKP_MINIMAPDROPDOWN_TIMEDAWARDS = "时间分奖励"
L.WEBDKP_MINIMAPDROPDOWN_OPTIONS = "选项"
L.WEBDKP_MINIMAPDROPDOWN_HELP = "帮助"
L.WEBDKP_MINIMAPDROPDOWN_SYNCHSETTINGS = "游戏内同步设置"
L.WEBDKP_MINIMAPDROPDOWN_VIEWLOG = "奖惩日志"
L.WEBDKP_MINIMAPDROPDOWN_RAIDLOG = "Raid事件日志"
L.WEBDKP_MINIMAPDROPDOWN_CHARRAIDLOG = "团队出勤日志"

--Table
L.WEBDKP_HEADER = "DKP 表:"
L.WEBDKP_FRAME_NAME_COLUMN = "名字"
L.WEBDKP_FRAME_CLASS_COLUMN = "职业"
L.WEBDKP_FRAME_DKP_COLUMN = "DKP"
L.WEBDKP_FRAME_GUILDRANK_COLUMN = "会阶"

--TABS
L.TAB_FILTER = "过滤"
L.TAB_AWARD_DKP = "奖惩DKP"
L.TAB_AWARD_ITEM = "奖惩物品"
L.TAB_STANDBY = "替补"

--TAB FOR FILTER
L.FILTER_HEADER = "过滤:"
L.FILTER_CLASS_WARLOCK = "|cff9482C9术士|r"
L.FILTER_CLASS_WARRIOR = "|cffC79C6E战士|r"
L.FILTER_CLASS_HUNTER = "|cffABD473猎人|r"
L.FILTER_CLASS_MAGE = "|cff69CCF0法师|r"
L.FILTER_CLASS_PRIEST = "|cffFFFFFF牧师|r"
L.FILTER_CLASS_DRUID = "|cffFF7D0A德鲁伊|r"
L.FILTER_CLASS_PALADIN = "|cffF58CBA圣骑士|r"
L.FILTER_CLASS_SHAMAN = "|cff0099FF萨满祭司|r"
L.FILTER_CLASS_ROGUE = "|cffFFF569潜行者|r"
L.FILTER_CLASS_DEATH_KNIGHT = "|cffC41F3B死亡骑士|r(忽略)"

L.FILTER_CLASS_CASTERS = "远程法术(|cff69CCF0法|r,|cff9482C9术|r,|cffFFFFFF牧|r,|cff0099FF萨|r,|cffF58CBA骑|r)"
L.FILTER_CLASS_MELEE = "物理近战(|cffC79C6E战|r,|cffFFF569贼|r,|cffFF7D0A德|r,|cffABD473猎|r,|cffF58CBA骑|r,|cff0099FF萨|r)"
L.FILTER_CLASS_HEALER = "治疗(|cffFFFFFF牧|r,|cffF58CBA骑|r,|cff0099FF萨|r,|cffFF7D0A德|r)"
L.FILTER_CLASS_CHAIN = "锁甲(|cffABD473猎|r,|cff0099FF萨|r)"
L.FILTER_CLASS_CLOTH = "布甲(|cff69CCF0法|r,|cff9482C9术|r,|cffFFFFFF牧|r)"
L.FILTER_CLASS_LEATHER = "皮甲(|cffFFF569贼|r,|cffFF7D0A德|r)"
L.FILTER_CLASS_PLATE = "板甲(|cffC79C6E战|r,|cffF58CBA骑|r)"

L.FILTER_CHECK_ALL = "选取所有"
L.FILTER_UNCHECK_ALL = "取消所有"
L.FILTER_ONLY_SHOW_PLAYERS_IN_CURRENT_GROUP = "只显示当前团队玩家"
L.FILTER_ONLY_SHOW_PLAYERS_IN_YOUR_GUILD = "只显示公会成员"
L.FILTER_ONLY_ONLINE_GUILD_MEMBERS = "只显示在线的公会成员"
L.FILTER_EXCLUDE_ALL_ALTS = "排除所有小号"
L.FILTER_EXCLUDE_ALTS_NOT_IN_PARTY = "排除不在队伍的小号"
L.FILTER_INCLUDE_STANDBY_PLAYERS = "包括替补玩家"
L.FILTER_LIMIT_TO_STANDBY_PLAYERS = "只显示替补玩家"

L.DKP_TABLE_SELECT_ALL = "选取所有"
L.DKP_TABLE_DESELECT_ALL = "取消所有"
L.DKP_TABLE_SAVE_LOG = "|cFF0dea38>保存数据文档<|r"
L.DKP_TABLE_Refresh = "刷新"

--TAB FOR AWARD DKP
L.AWARD_DKP_HEADER = "奖惩DKP:"
L.AWARD_DKP_INFO1 = "先选取左侧的玩家\n然后输入DKP奖惩"
L.AWARD_DKP_DECAY_HEADER = "DKP衰减:(仅适用于实施了DKP衰减制度的公会)"
L.AWARD_DKP_INFO3 = "选取左侧的玩家"
L.AWARD_DKP_REASON_LABEL = "原因:"
L.AWARD_DKP_POINTS_LABEL = "点数: (使用负数为扣分)"
L.AWARD_DKP_AWARD_POINTS = "奖惩DKP"
L.AWARD_DKP_DECAY_LABEL = "衰减值:如(.4),(-.4)"
L.AWARD_DKP_DECAY_BUTTON = "衰减"

--TAB FOR AWARD ITEM
L.AWARD_ITEM_HEADER = "奖惩物品:"
L.AWARD_ITEM_INFO1 = "左边选取要奖惩的玩家\n 下放输入DKP信息"
L.AWARD_ITEM_ITEM_NAME_LABEL = "物品名:"
L.AWARD_ITEM_ITEM_COST_LABEL = "物品DKP: (只允许正数)"
L.AWARD_ITEM_ITEM_COST_LABEL2 = ""
L.AWARD_ITEM_AWARD_ITEM = "奖惩！"

--TAB FOR STANDBY
L.STANDBY_HEADER = "替补玩家:"
L.STANDBY_INFO1 = "也可以让替补人员M你输入命令:|cFF0dea38我要替补|r\n退出替补M你输入命令:|cFF0dea38退出替补|r"
L.STANDBY_ADD_STANDBY_LABEL = "玩家名:"
L.STANDBY_ADD_TO_STANDBY = "添加"
L.STANDBY_DEL_STANDBY = "删除"
L.STANDBY_RESET_STANDBY = "重置"
L.STANDBY_ENABLE_STANDBY_ZEROSUM = "为替补玩家启用零和规则"
L.STANDBY_ENABLE_STANDBY_TIMED = "为替补玩家启用时间分奖励"

--BID
L.BID_TITLE = "WebDKP 竞拍"
L.BID_ITEM_LABEL = "物品:"
L.BID_STARTING_BID_LABEL = "起始DKP:"
L.BID_TIME_LABEL = "竞拍/Roll时间:"
L.BID_TIME_HINT = "(秒 - 0为无限制)"
L.BID_BID_BUTTON = "开始竞拍!"
L.BID_ROLL_BUTTON = "开始Roll!"
L.BID_TOP3_BUTTON = "通知竞拍前3名"
L.BID_TABLE_HEADER = "收到的竞拍/Rolls:"
L.BID_TABLE_COLUMN_NAME_LABEL = "名字"
L.BID_TABLE_COLUMN_BID_LABEL = "竞拍"
L.BID_TABLE_COLUMN_DKP_LABEL = "DKP"
L.BID_TABLE_COLUMN_POST_LABEL = "DKP - 竞拍"
L.BID_TABLE_COLUMN_ROLL_LABEL = "Rolls"
L.BID_TABLE_COLUMN_SPEC_LABEL = "主/副"
L.BID_TABLE_COLUMN_GUILD_RANK_LABEL = "公会会阶"
L.BID_AWARD = "奖励物品给玩家"
L.FORMAT_MSG_ROLLING_PATTERN = "(.+)掷出(%d+)%（(%d+)%-(%d+)%）"

--Timed Award
L.WEBDKP_TIMEDAWARDFRAME_TITLE = "时间分奖励"
L.WEBDKP_TIMEDAWARDFRAME_TEXT = "时间分奖励允许你为 DKP/EP 设置一个时间自动奖励分"
L.WEBDKP_TIMEDAWARDFRAME_DKP_LABEL = "DKP:"
L.WEBDKP_TIMEDAWARDFRAME_TIME_LABEL = "时间:"
L.WEBDKP_TIMEDAWARDFRAME_TIME_HINT = "(分钟)"
L.WEBDKP_TIMEDAWARDFRAME_LOOPTIMER_LABEL = "重复奖励:"
L.WEBDKP_TIMEDAWARDFRAME_RESETBUTTON = "重置"
L.STANDBY_RESET_STANDBY_LABEL = "重置所有替补玩家:"
L.WEBDKP_TIMEDAWARDFRAME_STARTSTOPBUTTON = "开始"
L.WEBDKP_TIMEDAWARDFRAME_MINIBUTTON = "迷你计时器"

--Options
L.WEBDKP_OPTIONSFRAME_TITLE = "WebDKP 设置"
--WebDKP_GeneralOptions_Frame
L.WEBDKP_GENERALOPTIONS_FRAME_TITLE = "一般设置:"
L.WEBDKP_GENERALOPTIONS_FRAME_INFO1 = "自动填充物品设置:"
L.WEBDKP_GENERALOPTIONS_FRAME_INFO2 = "零和DKP:"
L.WEBDKP_GENERALOPTIONS_FRAME_INFO3 = "自动Boss击杀奖励:"
L.WEBDKP_GENERALOPTIONS_FRAME_INFO4 = "启用/禁用WebDKP"
L.WEBDKP_GENERALOPTIONS_FRAME_INFO5 = "启用或禁用Alt+左键，弹出竞价窗口"
L.WEBDKP_GENERALOPTIONS_FRAME_INFO6 = "非队伍/团队玩家屏蔽私聊"
L.WEBDKP_GENERALOPTIONS_FRAME_INFO7 = "指定一个DKP封顶"
L.WEBDKP_GENERALOPTIONS_FRAME_INFO8 = "EP / GP:"
L.WEBDKP_GENERALOPTIONS_FRAME_TOGGLEAUTOFILLENABLED_LABEL = "自动填充物品名"
L.WEBDKP_GENERALOPTIONS_FRAME_TOGGLEAUTOAWARDENABLED_LABEL = "自动弹框启用"
L.WEBDKP_GENERALOPTIONS_FRAME_TOGGLEZEROSUMENABLED_LABEL = "零和模式启用"
L.WEBDKP_GENERALOPTIONS_FRAME_TOGGLEAWARDBOSSDKP_LABEL = "启用/禁用"
L.WEBDKP_GENERALOPTIONS_FRAME_TOGGLEALTCLICK_LABEL = "Alt+左键 启用"
L.WEBDKP_GENERALOPTIONS_FRAME_TOGGLEIGNWHISPERS_LABEL = "屏蔽 启用"
L.WEBDKP_GENERALOPTIONS_FRAME_TOGGLEDKPCAP_LABEL = "DKP封顶 启用"
L.WEBDKP_GENERALOPTIONS_FRAME_DKPCAPLIMIT_LABEL = "封顶限制:"
L.WEBDKP_GENERALOPTIONS_FRAME_BOSSDKP_LABEL = "DKP 数:"
L.WEBDKP_GENERALOPTIONS_FRAME_TOGGLEENABLED_LABEL = "WebDKP 启用"
L.WEBDKP_GENERALOPTIONS_FRAME_TOGGLEENABLED_LABEL = "WebDKP 启用"
--WebDKP_BiddingOptions_Frame
L.WEBDKP_BIDDINGOPTIONS_FRAME_INFO1 = "竞拍选项:"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEBIDANNOUNCERAID_LABEL = "通告在团队警报"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEBIDCONFIRMPOPUP_LABEL = "配置竞拍奖惩弹出"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEBIDALLOWNEGATIVEBIDS_LABEL1 = "允许负DKP竞拍"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEBIDALLOWNEGATIVEBIDS_LABEL2 = "(允许人们负数竞拍)"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEBIDFIXEDBIDDING_LABEL1 = "使用固定DKP分数竞拍"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEBIDFIXEDBIDDING_LABEL2 = "(从固定DKP列表中决定DKP分数)"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEBIDNOTIFYLOWBIDS_LABEL1 = "当DKP低了通知竞拍者"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEBIDNOTIFYLOWBIDS_LABEL2 = "(告诉他们现在你不是最高竞拍者了)"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEAUTOGIVE_LABEL1 = "自动给予装备"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEAUTOGIVE_LABEL2 = "(谨慎使用！自动给予装备)"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLETURNBASE_LABEL1 = "all in(梭哈)DKP"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLETURNBASE_LABEL2 = "同时启用在固定竞拍上"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLESILENTBIDDING_LABEL1 = "静默"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLESILENTBIDDING_LABEL2 = "不会宣布谁赢了"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEBIDANDROLL_LABEL1 = "竞拍中监视Roll"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEBIDANDROLL_LABEL2 = "专为副天赋装备检查"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEALLNEED_LABEL1 = "启用需求百分比"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEALLNEED_LABEL2 = "为'需求'启用用户定义的百分比"
L.WEBDKP_BIDDINGOPTIONS_FRAME_NEEDDKP_LABEL = "'需求' DKP %:"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEFIFTYGREED_LABEL1 = "启用贪婪百分比"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEFIFTYGREED_LABEL2 = "为'贪婪'启用用户定义的百分比"
L.WEBDKP_BIDDINGOPTIONS_FRAME_GREEDDKP_LABEL = "'贪婪' DKP %:"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEDISABLEBID_LABEL1 = "禁用'出价'命令"
L.WEBDKP_BIDDINGOPTIONS_FRAME_TOGGLEDISABLEBID_LABEL2 = "用户禁用'出价', 强制使用'主天赋''副天赋'命令"
--WebDKP_BiddingOptions2_Frame
L.WEBDKP_BIDDINGOPTIONS2_FRAME_INFO1 = "竞拍选项:"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_INFO2 = "单击图标设置倍增:"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_TOGGLEITEMLEVELEQUATION_LABEL = "启用物品等级倍增器"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_ITEMLEVELMULT_LABEL = "值 (例如.01):"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_TOGGLESLOTLOCMULT_LABEL = "启用槽位置倍增器"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_HELMBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_NECKBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_SHOULDERSBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_BACKBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_CHESTBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_WRISTBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_HANDSBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_WAISTBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_LEGSBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_FEETBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_FINGERBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_TRINKETBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_MAINHANDBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_OFFHANDBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_RANGEDBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_RELICBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_TWOHANDBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_ONEHANDBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_OFFHANDWEAPONBUTTON = "测试"
L.WEBDKP_BIDDINGOPTIONS2_FRAME_HELDOFFHANDBUTTON = "测试"
--WebDKP_AnnouncementsOptions_Frame
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_INFO12 = "通告选项:"
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_INFO13 = "自定义信息 - 开始竞拍"
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_INFO14 = "自定义信息 - 竞拍期间"
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_INFO15 = "自定义信息 - 结束竞拍"
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_INFO16 = "自定义信息 - 开始Roll"
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_INFO17 = "自定义信息 - Roll期间"
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_INFO18 = "自定义信息 - 结束Roll"
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_TOGGLEANNOUNCEMENTS_LABEL = "禁用所有公告"
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_EDITSTARTANNOUNCE_LABEL = "$item = 物品, $time = 时间, $bid = 起始DKP"
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_EDITDURINGANNOUNCE_LABEL = "$item = 物品, $time = 时间, $name = 名字, $dkp = DKP"
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_EDITENDANNOUNCE_LABEL = "$item = 物品, $name = 名字, $dkp = DKP, $totbid = Tot. Bids"
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_EDITSROLLANNOUNCE_LABEL = "$item = 物品, $time = 时间"
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_EDITROLLANNOUNCE_LABEL = "$item = 物品, $time = 时间, $name = 名字, $roll = Roll"
L.WEBDKP_ANNOUNCEMENTSOPTIONS_FRAME_EDITEROLLANNOUNCE_LABEL = "$item = 物品, $name = 名字, $roll = Roll, $roltot = Tot. Rolls"
--WebDKP_ItemSlotFrame
L.WEBDKP_ITEMSLOTFRAME_TITLE = "此处为主文本"
L.WEBDKP_ITEMSLOTFRAME_COST = "倍增值:"
L.WEBDKP_ITEMSLOTFRAME_YES = "接受"
L.WEBDKP_ITEMSLOTFRAME_NO = "取消"
--tab
L.WEBDKP_OPTIONSFRAME_TAB1 = "一般"
L.WEBDKP_OPTIONSFRAME_TAB2 = "竞拍1"
L.WEBDKP_OPTIONSFRAME_TAB4 = "竞拍2"
L.WEBDKP_OPTIONSFRAME_TAB3 = "公告"

--Announcments.lua
L.FORMAT_WEBDKP_ITEMAWARD = "WebDKP: $player 给予装备: $item ,被扣了: $cost DKP"
L.FORMAT_WEBDKP_ITEMAWARDZEROSUM = "WebDKP: $dkp 点DKP被奖惩给所有玩家, 零和规则: $item"
L.FORMAT_WEBDKP_DKPAWARDALL = "WebDKP: $dkp 点DKP给予了所有玩家, 原因: $reason."
L.FORMAT_WEBDKP_DKPAWARDSOME = "WebDKP: $dkp 点DKP给予了所有被选择的玩家, 原因: $reason. \n接收到的玩家都被密语了."
L.FORMAT_WEBDKP_BIDSTART = "WebDKP: 竞拍已开始 $item! $time "
L.FORMAT_WEBDKP_BIDEND = "WebDKP: $item 竞拍已结束, 胜利者为 $name , $dkp dkp"
L.FORMAT_WEBDKP_BIDENDSILENT = "WebDKP: 竞拍已结束 $item"
L.FORMAT_WEBDKP_ROLLEND = "WebDKP: Roll点已结束 $item , $name 是最高点, 为 $roll"
L.FORMAT_WEBDKP_TIMEDAWARD = "WebDKP: $minutes 分钟奖励分, 已给予 $dkp dkp"
L.FORMAT_WEBDKP_BOSSAWARDNUM = "WebDKP: 干得漂亮! Boss奖励分: $dkp 已自动给予"
L.FORMAT_WEBDKP_SENDWHISPER = "你被奖惩了 "

--AutoFill.lua
L.FORMAT_FIND_OTHER_ITEM_LOOT = "([^%s]+)获得了物品：(.+)%。"
L.FORMAT_FIND_PLAYER_SELF = "你"




-- ================================
-- Boss kill list used when UNIT_DIED is detected
-- This is in the format of [Parameter recieved by wow] = name you would like to show on dkp
-- e.g. on the spine of deathing fight, the paramter passed is "Deathwing" but the fight is actually spine of deathing
-- ================================
L.BOSS_KILL_LIST = {
    ["鲁西弗隆"] = "鲁西弗隆", --MC
    ["基赫纳斯"] = "基赫纳斯", --MC
    ["玛格曼达"] = "玛格曼达", --MC
    ["加尔"] = "加尔", --MC
    ["沙斯拉尔"] = "沙斯拉尔", --MC
    ["迦顿男爵"] = "迦顿男爵", --MC
    ["焚化者古雷曼格"] = "焚化者古雷曼格", --MC
    ["萨弗隆先驱者"] = "萨弗隆先驱者", --MC
    ["拉格纳罗斯"] = "拉格纳罗斯", --MC
    ["管理者埃克索图斯"] = "管理者埃克索图斯", --MC
    ["奥妮克希亚"] = "奥妮克希亚", --Onyxia's Lair
};

L.BOSS_YELL_LIST = {
    ["管理者埃克索图斯"] = {
        ["不……不可能！等一下……我投降！我投降！"] = "管理者埃克索图斯" },
}

L.BOSS_MAP = {
    ["熔火之心"] = "BossDKPMCAndOLValue",
    ["奥妮克希亚的巢穴"] = "BossDKPMCAndOLValue",
    ["黑翼之巢"] = "BossDKPBWLValue",
    ["安其拉"] = "BossDKPTAQValue",
    ["纳克萨玛斯"] = "BossDKPNAXXValue",
}