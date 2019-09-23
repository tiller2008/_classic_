local L = LibStub("AceLocale-3.0"):NewLocale("OfflineDataCenter", "zhTW")
if L then
	L["Because the upgrade versions of all ADDON need to be reset ODC data, click OK to reload UI!"] = "因版本升級, 需要重置'離線數據中心'所有數據, 確定後將重載界面？";
	L["Select a character to wipe"] = '選擇一個角色清空數據'
	L["|cffff2222Wipe Data|r"] = "|cffff2222數據清空|r"
	L["Open config"] = "打開設置"
	L["Maximum messages"] = "最大信息數"
	L["Auto report"] = '自動報告'
	L["Offline Data Center"] = "離線數據中心"
	L["Deposit Reagents"] = "材料背包"
	L["UNKNOWN SENDER"] = "\[未知發件人\]"
	L["Stack items"] = "堆疊物品"
	L["No sorting"] = "不排序"
	L["AH"] = "拍賣行"
	L["sender"] = "發件人"
	--L["quality"] = "品質"
	L["quality"] = QUALITY
	L["left day"] = "剩餘時間"
	--L["C.O.D."] = "付費取件"
	L["C.O.D."] = COD
	L["money"] = MONEY
	L["has money"] = "擁有錢"
	L["is C.O.D."] = "付費取件"
	L["not C.O.D."] = "非付費取件"
	L["Collect gold"] = "收取金幣"
	L["Sender: "]  = "發件人: "
	L["+ Left time: "] = "+ 剩餘 "
	L["more than "] = "大於"
	--L["C.O.D. item"] = "付費取件物品"
	L["C.O.D. item"] = COD.." "..ITEMS
	L["pay for: "] = "需付費: "
	L[" days"] = "天"
	L[" hours"] = "小時"
	L[" minutes"] = "分鐘"
	L["was returned"] = "已被退回"
	L["Mailbox gold: "] = "郵箱金幣: "
	L["Character gold: "] = "角色金幣: "
	L["Quality summary: "] = "品質統計: "
	L[": |cff00aabbYou have mails soon expire: |r"] = ": |cffaa0000您的郵箱有快到期的附件: |r"
	--L[""] = ""
	
	L['Offline MailBox'] = '離線郵箱';
	L['Offline Bag'] = '離線背包';
	L['Offline Bank'] = '離線銀行';	
	L['Offline Character'] = '離線角色';
	L["Offline Void Storage"] = "離線虛空銀行";
	L['Offline Frame'] = '離線窗口';
	
	L['Hold down the ALT key'] = '按住Alt鍵';
	L['Show the number of items for all Character'] = '顯示所有角色的物品數量';
	
	L["Offline Data Center toggle button can not be created in Combating, please leave the combat before retry!"] = '戰鬥時, 離線背包按鈕不能被創建, 請離開戰鬥後重試';
	
	L[" is |cff33ff33enabled|r"] = " 已|cff33ff33"..ENABLE.."|r";
	L[" is |cffff3333disabled|r"] = " 已|cffff3333"..DISABLE.."|r";
	L["Tab name does not exist!"] = "標籤名字不存在!";
	L["COMMANDHELPER"] = "|cffffff33未知ODC命令! ODC命令小精靈:|r\n"..
	"|cff33ff33/ODC toggle|r: 開啟/關閉ODC視窗\n"..
	"|cff33ff33/ODC enable [標籤名]|r: 啟用|cffffff33[標籤名]|r\n"..
	"|cff33ff33/ODC disable [標籤名]|r: 禁用|cffffff33[標籤名]|r\n"..
	"|cff33ff33/ODC wipe disabled|r: 清除未使用標籤的離線數據\n"..
	"|cff33ff33/ODC wipe all|r: 清除所有離線數據!\n"..
	"|cff33ff33/ODC icon|r: 切換小地圖圖標顯狀態!\n"..
	"|cff33ff33/ODC state|r: 顯示標籤狀態\n";
	L["Do you want to wipe ALL offline data?"] = "你真的要清空所有數據嗎？";
	L["'s data wiped."] = "的數據已清空";
	L["All data wiped!"] = "所有數據已清空";
	L["Disabled data wiped!"] = "未使用標籤數據已清空";
	----settings tab
	L["settings"] = SETTINGS;
	L["wipe selected character data"] = "清空當前選擇角色之數據";
	L["wipe disabled tab data"] = "清空未使用標籤數據";
	L["wipe |cffff2222ALL|r data"] = "清空|cffff2222所有|r標籤數據";
	L["Please choose a setting"] = "請選擇一項設定";
	L[" version: "] = " "..GAME_VERSION_LABEL..": ";
	----
	L["Offline Whisper Log"] = "離線密語日誌";
	----
	L["Offline Trade Log"] = "離線交易日誌";
	L["|cffff2222OfflineDataCenterOpts\nhas been disabled in addons list.\nPlease enable it to open config window\nor use command line|r |cff22ff22/ODC|r |cffff2222to config|r"] = "|cffff2222OfflineDataCenterOpts\n在插件列表中被禁用或不存在.\n請啟用此插件以便打開設置窗口\n或使用命令行|r |cff22ff22/ODC|r |cffff2222來設置|r"
end