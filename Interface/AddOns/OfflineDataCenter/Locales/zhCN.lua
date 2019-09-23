local L = LibStub("AceLocale-3.0"):NewLocale("OfflineDataCenter", "zhCN")
if L then
	L["Because the upgrade versions of all ADDON need to be reset ODC data, click OK to reload UI!"] = "因版本升级,需要重置'离线数据中心'数据,确定后将重载界面!";
	L["Select a character to wipe"] = '选择一个角色清空数据'
	L["|cffff2222Wipe Data|r"] = "|cffff2222数据清空|r"
	L["Open config"] = "打开设置"
	L["Maximum messages"] = '最大信息数'
	L["Auto report"] = '自动报告'
	L["Offline Data Center"] = "离线数据中心"
	L["Deposit Reagents"] = '材料背包'
	L["UNKNOWN SENDER"] = "\[未知发件人\]"
	L["Stack items"] = "堆叠物品"
	L["No sorting"] = "不排序"
	L["AH"] = "拍卖行"
	L["sender"] = "发件人"
	--L["quality"] = "品质"
	L["quality"] = QUALITY
	L["left day"] = "剩余时间"
	--L["C.O.D."] = "付费取件"
	L["C.O.D."] = COD
	L["money"] = MONEY
	L["has money"] = "拥有钱"
	L["is C.O.D."] = "付费取件"
	L["not C.O.D."] = "非付费取件"
	L["Collect gold"] = "收取金币"
	L["Sender: "]  = "发件人: "
	L["+ Left time: "] = "+ 剩余 "
	L["more than "] = "大于"
	--L["C.O.D. item"] = "付费取件物品"
	L["C.O.D. item"] = COD.." "..ITEMS
	L["pay for: "] = "需付費: "
	L[" days"] = "天"
	L[" hours"] = "小时"
	L[" minutes"] = "分钟"
	L["was returned"] = "已被退回"
	L["Mailbox gold: "] = "邮箱金币: "
	L["Character gold: "] = "角色金币: "
	L["Quality summary: "] = "品质统计: "
	L[": |cff00aabbYou have mails soon expire: |r"] = ": |cffaa0000您的邮箱有快到期的附件: |r"
	--L[""] = ""
	
	L['Offline MailBox'] = '离线邮箱';
	L['Offline Bag'] = '离线背包';
	L['Offline Bank'] = '离线银行';
	L['Offline Character'] = '离线角色';
	L["Offline Void Storage"] = "离线虚空银行";
	L['Offline Frame'] = '离线窗口';
	
	L['Hold down the ALT key'] = '按住Alt键';
	L['Show the number of items for all Character'] = '显示所有角色的物品数量';
	
	L["Offline Data Center toggle button can not be created in Combating, please leave the combat before retry!"] = '战斗时, 离线背包开关按钮不能被创建, 请脱战后重试.';
	
	L[" is |cff33ff33enabled|r"] = " 已|cff33ff33"..ENABLE.."|r";
	L[" is |cffff3333disabled|r"] = " 已|cffff3333"..DISABLE.."|r";
	L["Tab name does not exist!"] = "标签名字不存在!";
	L["COMMANDHELPER"] = "|cffffff33未知ODC命令! ODC命令助手:|r\n"..
	"|cff33ff33/ODC toggle|r: 开启/关闭ODC窗口\n"..
	"|cff33ff33/ODC enable [标签名]|r: 启用|cffffff33[标签名]|r\n"..
	"|cff33ff33/ODC disable [标签名]|r: 禁用|cffffff33[标签名]|r\n"..
	"|cff33ff33/ODC wipe disabled|r: 清除未使用标签的离线数据\n"..
	"|cff33ff33/ODC wipe all|r: 清除所有离线数据!\n"..
	"|cff33ff33/ODC icon|r: 切换小地图图标显示状态!\n"..
	"|cff33ff33/ODC state|r: 显示标签状态\n";
	L["Do you want to wipe ALL offline data?"] = "你真的要清空所有数据嗎？";
	L["'s data wiped."] = "的数据已清空";
	L["All data wiped!"] = "所有数据已清空";
	L["Disabled data wiped!"] = "未使用标签数据已清空";
	----settings tab
	L["settings"] = SETTINGS;
	L["wipe selected character data"] = "清空当前选择角色的数据";
	L["wipe disabled tab data"] = "清空未使用标签数据";
	L["wipe |cffff2222ALL|r data"] = "清空|cffff2222所有|r标签数据";
	L["Please choose a setting"] = "请选择一项设置";
	L[" version: "] = " "..GAME_VERSION_LABEL..": ";
	----
	L["Offline Whisper Log"] = "离线密语记录";
	----
	L["Offline Trade Log"] = "离线交易记录";
	L["|cffff2222OfflineDataCenterOpts\nhas been disabled in addons list.\nPlease enable it to open config window\nor use command line|r |cff22ff22/ODC|r |cffff2222to config|r"] = "|cffff2222OfflineDataCenterOpts\n在插件列表中被禁用或不存在.\n请启用此插件以便打开设置窗口\n或使用命令行|r |cff22ff22/ODC|r |cffff2222来设置|r"
end