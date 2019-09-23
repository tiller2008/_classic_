local addon_name, addon_data = ...
addon_data.localization_table = {}
local L = addon_data.localization_table

if GetLocale() == "enUS" then
	L["Thank you for installing WeaponSwingTimer Version"] = "Thank you for installing WeaponSwingTimer Version"
	L["by LeftHandedGlove! Use |cFFFFC300/wst|r for more options."] = "by LeftHandedGlove! Use |cFFFFC300/wst|r for more options."

	L["Global Bar Settings"] = "Global Bar Settings"
	L[" Lock All Bars"] = " Lock All Bars"
	L["Locks all of the swing bar frames, preventing them from being dragged."] = "Locks all of the swing bar frames, preventing them from being dragged."
	L["<- Click the '+' on the left\nfor more options"] = "<- Click the '+' on the left\nfor more options"
	L['Melee Settings'] = 'Melee Settings'
	L['Hunter & Wand Settings'] = 'Hunter & Wand Settings'

	--Player && Target bar
	L["Player Swing Bar Settings"] = "Player Swing Bar Settings"
	L["Target Swing Bar Settings"] = "Target Swing Bar Settings"
	L["Main-Hand"] = "Main-Hand"
	L["Off-Hand"] = "Off-Hand"

	L[" Enable"] = " Enable"
	L["Enables the player's swing bars."] = "Enables the player's swing bars."
	L[" Show Off-Hand"] = " Show Off-Hand"
	L["Enables the player's off-hand swing bar."] = "Enables the player's off-hand swing bar."
	L[" Show border"] = " Show border"
	L["Enables the player bar's border."] = "Enables the player bar's border."
	L[" Classic bars"] = " Classic bars"
	L["Enables the classic texture for the player's bars."] = "Enables the classic texture for the player's bars."
	L[" Fill / Empty"] = " Fill / Empty"
	L["Determines if the bar is full or empty when a swing is ready."] = "Determines if the bar is full or empty when a swing is ready."
	L[" Show Left Text"] = " Show Left Text"
	L["Enables the player's left side text."] = "Enables the player's left side text."
	L[" Show Right Text"] = " Show Right Text"
	L["Enables the player's right side text."] = "Enables the player's right side text."
	L["Bar Width"] = "Bar Width"
	L["Bar Height"] = "Bar Height"
	L["X Offset"] = "X Offset"
	L["Y Offset"] = "Y Offset"
	L['Main-hand Bar Color'] = 'Main-hand Bar Color'
	L['Main-hand Bar Text Color'] = 'Main-hand Bar Text Color'
	L['Off-hand Bar Color'] = 'Off-hand Bar Color'
	L['Off-hand Bar Text Color'] = 'Off-hand Bar Text Color'
	L["In Combat Alpha"] = "In Combat Alpha"
	L["Out of Combat Alpha"] = "Out of Combat Alpha"
	L["Backplane Alpha"] = "Backplane Alpha"
	
	--Hunter && Wand Shot
	L["Hunter & Wand Shot Bar Settings"] = "Hunter & Wand Shot Bar Settings"
	L["General Settings"] = "General Settings"
	L[" YaHT / One bar"] = " YaHT / One bar"
	L["Changes the Auto Shot bar to a single bar that fills from left to right"] = "Changes the Auto Shot bar to a single bar that fills from left to right"
	L['Auto Shot Cooldown Color'] = 'Auto Shot Cooldown Color'
	L['Auto Shot Cast Color'] = 'Auto Shot Cast Color'
	L[" Show Text"] = " Show Text"
	L["Enables the shot bar text."] = "Enables the shot bar text."
	L["Hunter Specific Settings"] = "Hunter Specific Settings"
	L[" Aimed Shot cast bar"] = " Aimed Shot cast bar"
	L["Allows the cast bar to show Aimed Shot casts."] = "Allows the cast bar to show Aimed Shot casts."
	L[" Multi-Shot cast bar"] = " Multi-Shot cast bar"
	L["Allows the cast bar to show Multi-Shot casts."] = "Allows the cast bar to show Multi-Shot casts."
	L[" Latency bar"] = " Latency bar"
	L["Shows a bar that represents latency on cast bar."] = "Shows a bar that represents latency on cast bar."
	L[" Multi-Shot clip bar"] = " Multi-Shot clip bar"
	L["Shows a bar that represents when a Multi-Shot would clip an Auto Shot."] = "Shows a bar that represents when a Multi-Shot would clip an Auto Shot."
	L['Multi-Shot Clip Color'] = 'Multi-Shot Clip Color'
	L["Bar Explanation"] = "Bar Explanation"
	
end

if GetLocale() == "zhCN" then
	L["Thank you for installing WeaponSwingTimer Version"] = "感谢您安装WeaponSwingTimer版本"
	L["by LeftHandedGlove! Use |cFFFFC300/wst|r for more options."] = "by LeftHandedGlove！使用|cFFFFC300/wst|r获取更多选项。"

	L["Global Bar Settings"] = "全局设置"
	L[" Lock All Bars"] = " 锁定所有平砍条"
	L["Locks all of the swing bar frames, preventing them from being dragged."] = "锁定所有平砍条，防止被拖动."
	L["<- Click the '+' on the left\nfor more options"] = "<- 点击左边的 '+' \n显示更多设置"
	L['Melee Settings'] = '近战设置'
	L['Hunter & Wand Settings'] = '猎人和魔杖设置'

	--Player && Target bar
	L["Player Swing Bar Settings"] = "玩家平砍条设置"
	L["Target Swing Bar Settings"] = "目标平砍条设置"
	L["Main-Hand"] = "主手"
	L["Off-Hand"] = "副手"
	L[" Enable"] = " 启用"
	L["Enables the player's swing bars."] = "启用玩家平砍条."
	L[" Show Off-Hand"] = " 显示副手"
	L["Enables the player's off-hand swing bar."] = "启用玩家副手平砍条."
	L[" Show border"] = " 显示边框"
	L["Enables the player bar's border."] = "启用玩家平砍条边框."
	L[" Classic bars"] = " 经典平砍条"
	L["Enables the classic texture for the player's bars."] = "玩家平砍条启用经典材质."
	L[" Fill / Empty"] = " 充满 / 空的"
	L["Determines if the bar is full or empty when a swing is ready."] = "确定就绪时平砍条是空的还是充满的."
	L[" Show Left Text"] = " 显示左边文本"
	L["Enables the player's left side text."] = "启用玩家的左边文本."
	L[" Show Right Text"] = " 显示右边文本"
	L["Enables the player's right side text."] = "启用玩家的右边文本."
	L["Bar Width"] = "条宽度"
	L["Bar Height"] = "条高度"
	L["X Offset"] = "水平偏移"
	L["Y Offset"] = "垂直偏移"
	L['Main-hand Bar Color'] = '主手条颜色'
	L['Main-hand Bar Text Color'] = '主手条文本颜色'
	L['Off-hand Bar Color'] = '副手条颜色'
	L['Off-hand Bar Text Color'] = '副手条文本颜色'
	L["In Combat Alpha"] = "进战透明度"
	L["Out of Combat Alpha"] = "脱战透明度"
	L["Backplane Alpha"] = "背板透明度"

	--Hunter && Wand Shot
	L["Hunter & Wand Shot Bar Settings"] = "猎人和魔杖射击条设置"
	L["General Settings"] = "一般设置"
	L[" YaHT / One bar"] = " 多条/单条"
	L["Changes the Auto Shot bar to a single bar that fills from left to right"] = "更改射击条为从左向右填充的单条"
	L['Auto Shot Cooldown Color'] = '自动射击冷却颜色'
	L['Auto Shot Cast Color'] = '自动射击施法颜色'
	L[" Show Text"] = " 显示文本"
	L["Enables the shot bar text."] = "启用自动射击条文本."

	L["Hunter Specific Settings"] = "猎人专用设置"
	L[" Aimed Shot cast bar"] = " 瞄准射击施法条"
	L["Allows the cast bar to show Aimed Shot casts."] = "允许施法条显示瞄准射击."
	L[" Multi-Shot cast bar"] = " 多重射击施法条"
	L["Allows the cast bar to show Multi-Shot casts."] = "允许施法条显示多重射击."
	L[" Latency bar"] = " 延迟条"
	L["Shows a bar that represents latency on cast bar."] = "在施法条上显示延迟."
	L[" Multi-Shot clip bar"] = " 多重射击修剪条"
	L["Shows a bar that represents when a Multi-Shot would clip an Auto Shot."] = "在自动射击上显示一个表示多重射击条."
	L['Multi-Shot Clip Color'] = '多重射击修剪颜色'
	L["Bar Explanation"] = "射击条示例"
end

if GetLocale() == "zhTW" then
	L["Thank you for installing WeaponSwingTimer Version"] = "感謝您安裝WeaponSwingTimer版本"
	L["by LeftHandedGlove! Use |cFFFFC300/wst|r for more options."] = "by LeftHandedGlove！使用|cFFFFC300/wst|r獲取更多選項。"

	L["Global Bar Settings"] = "全局設置"
	L[" Lock All Bars"] = " 鎖定所有平砍條"
	L["Locks all of the swing bar frames, preventing them from being dragged."] = "鎖定所有平砍條，防止被拖動."
	L["<- Click the '+' on the left\nfor more options"] = "<- 點擊左邊的 '+' \n顯示更多設置"
	L['Melee Settings'] = '近戰設置'
	L['Hunter & Wand Settings'] = '獵人和魔杖設置'
	L["Main-Hand"] = "主手"
	L["Off-Hand"] = "副手"
	
	--Player && Target bar
	L["Player Swing Bar Settings"] = "玩家平砍條設置"
	L["Target Swing Bar Settings"] = "目標平砍條設置"
	L[" Enable"] = " 啟用"
	L["Enables the player's swing bars."] = "啟用玩家平砍條."
	L[" Show Off-Hand"] = " 顯示副手"
	L["Enables the player's off-hand swing bar."] = "啟用玩家副手平砍條."
	L[" Show border"] = " 顯示邊框"
	L["Enables the player bar's border."] = "啟用玩家平砍條邊框."
	L[" Classic bars"] = " 經典平砍條"
	L["Enables the classic texture for the player's bars."] = "玩家平砍條啟用經典材質."
	L[" Fill / Empty"] = " 充滿 / 空的"
	L["Determines if the bar is full or empty when a swing is ready."] = "確定就緒時平砍條是空的還是充滿的."
	L[" Show Left Text"] = " 顯示左邊文本"
	L["Enables the player's left side text."] = "啟用玩家的左邊文本."
	L[" Show Right Text"] = " 顯示右邊文本"
	L["Enables the player's right side text."] = "啟用玩家的右邊文本."
	L["Bar Width"] = "條寬度"
	L["Bar Height"] = "條高度"
	L["X Offset"] = "水準偏移"
	L["Y Offset"] = "垂直偏移"
	L['Main-hand Bar Color'] = '主手條顏色'
	L['Main-hand Bar Text Color'] = '主手條文本顏色'
	L['Off-hand Bar Color'] = '副手條顏色'
	L['Off-hand Bar Text Color'] = '副手條文本顏色'
	L["In Combat Alpha"] = "進戰透明度"
	L["Out of Combat Alpha"] = "脫戰透明度"
	L["Backplane Alpha"] = "背板透明度"

	--Hunter && Wand Shot
	L["Hunter & Wand Shot Bar Settings"] = "獵人和魔杖射擊條設置"
	L["General Settings"] = "一般設置"
	L[" YaHT / One bar"] = " 多條/單條"
	L["Changes the Auto Shot bar to a single bar that fills from left to right"] = "更改射擊條為從左向右填充的單條"
	L['Auto Shot Cooldown Color'] = '自動射擊冷卻顏色'
	L['Auto Shot Cast Color'] = '自動射擊施法顏色'
	L[" Show Text"] = " 顯示文本"
	L["Enables the shot bar text."] = "啟用自動射擊條文本."

	L["Hunter Specific Settings"] = "獵人專用設置"
	L[" Aimed Shot cast bar"] = " 瞄準射擊施法條"
	L["Allows the cast bar to show Aimed Shot casts."] = "允許施法條顯示瞄準射擊."
	L[" Multi-Shot cast bar"] = " 多重射擊施法條"
	L["Allows the cast bar to show Multi-Shot casts."] = "允許施法條顯示多重射擊."
	L[" Latency bar"] = " 延遲條"
	L["Shows a bar that represents latency on cast bar."] = "在施法條上顯示延遲."
	L[" Multi-Shot clip bar"] = " 多重射擊修剪條"
	L["Shows a bar that represents when a Multi-Shot would clip an Auto Shot."] = "在自動射擊上顯示一個表示多重射擊條."
	L['Multi-Shot Clip Color'] = '多重射擊修剪顏色'
	L["Bar Explanation"] = "射擊條示例"
end

