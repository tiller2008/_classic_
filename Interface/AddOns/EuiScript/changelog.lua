local E, L, V, P, G = unpack(ElvUI)
local ChangeLog = E:NewModule('ChangeLog', 'AceEvent-3.0')
local S = E:GetModule('Skins')

-- by eui.cc@20170625

-- Cache global variables
-- Lua functions
local gmatch, gsub, find, sub = string.gmatch, string.gsub, string.find, string.sub
local tinsert = table.insert
local pairs, tonumber = pairs, tonumber
-- WoW API / Variables
local CreateFrame = CreateFrame

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: MERData, PlaySound, UISpecialFrames

local ChangeLogWebData = [=[
<b>C20191106A</b>
<b>1. 更新任务追踪框.</b>
<b>2. 更新角色属性增强.</b>
<b>3. 更新内置库.</b>
<b>C20191030A</b>
<b>1. 修正中部冷却显示.</b>
<b>2. 重新启用交易密语.</b>
<b>3. 单位框体添加能量条方向设置.</b>
<b>4. 一些内置库更新.</b>
<b>5. DBM更新至20191029160018.</b>
<b>C20191029A</b>
<b>1. 整合ExRT团队管理插件,默认关闭,请在单体插件管理中开启.</b>
<b>2. 更新副本战利品查询.</b>
<b>3. 更新隐藏施法条文本功能,修正仇恨色问题,更新治疗预估库.</b>
<b>C20191028A</b>
<b>1. 动作条增加10号动作条.</b>
<b>2. 设置界面一些模块样式调整.</b>
<b>3. 增加faction:icon标签用来显示阵营图标.</b>
<b>4. 增益/减益图标褪色增加设置开关.</b>
<b>5. 恢复单位框体的仇恨色功能.</b>
<b>6. 增补其它类型的打断提示.</b>
<b>C20191025A</b>
<b>1. 修正漏改的大脚世界频道2.</b>
<b>2. 继续调整冷却计时模块等.</b>
<b>C20191024A</b>
<b>1. 更新治疗预估库.</b>
<b>2. 本地化离线死亡等状态标签.</b>
<b>C20191023A</b>
<b>1. 增加WeakAuras皮肤.</b>
<b>2. 更新NPC位置模块添加骑乘训练师等.</b>
<b>3. 更新治疗预估库.</b>
<b>4. 更新冷却模块添加更多的颜色设置选项.</b>
<b>5. 继续补充过滤器预设技能等.</b>
<b>C20191022A</b>
<b>1. 更新WebDKP增加击杀BOSS自动加分.</b>
<b>2. 拍卖助手由AuctionLite换回为AuctionFaster.</b>
<b>3. 更新角色属性增强修正QS显示问题.</b>
<b>4. 使用新的治疗预估库.</b>
<b>5. 修正光环条排序等问题.</b>
<b>6. 更新任务追踪框修正任务计数问题.</b>
<b>C20191021A</b>
<b>1. 恢复大脚世界频道名称.</b>
<b>2. 更新副本战利品查询.</b>
<b>3. 重做目标框体的精英龙标志.</b>
<b>4. 更新副本战利品查询.</b>
<b>5. 更新DBM至20191020191155.</b>
<b>6. 更新角色属性增强.</b>
<b>C20191020A</b>
<b>1. 更新大脚世界频道名称.</b>
<b>2. 更新副本战利品查询.</b>
<b>3. 一键宏更新.</b>
<b>4. 更新光环条模块和02增益和负面模块.</b>
<b>5. 删除原拍卖助手和拍卖增强,换成AuctionLite拍卖助手插件,不能自动删除的请手工删除AuctionFaster和BaudAuction目录.</b>
<b>6. 更新系统美化皮肤.</b>
<b>C20191015A</b>
<b>1. 换成精简版任务助手数据降低内存占用.</b>
<b>2. 集成WebDKP插件，默认禁用.</b>
<b>3. 更新采集助手数据库,可以重新导入数据.</b>
<b>4. 鼠标提示增加物品可用专业图标显示.</b>
<b>5. 更新DBM至20191013171649.</b>
<b>6. 更新内置库.</b>
<b>C20191014A</b>
<b>1. 临时禁用交易密语代码.</b>
<b>C20191012C</b>
<b>1. 兼容性问题临时修正目标框体出错的问题.</b>
<b>C20191012B</b>
<b>1. 大地图区域信息在单体插件地图增强里增加开关.</b>
<b>2. 修改交易密语默认频道到说话频道,修改重复发言的问题.</b>
<b>C20191012A</b>
<b>1. 集成SilverDragon稀有插件.</b>
<b>2. 更换右键菜单增强模块.</b>
<b>3. 大地图隐藏地图标记按钮增加右键隐藏采集助手图标功能.</b>
<b>4. 更新任务追踪框提高兼容性.</b>
<b>5. 内置库更新，添加一些技能监视时间.</b>
<b>6. 一键宏插件更新.</b>
<b>7. 更新已知配方图纸染色功能.</b>
<b>8. 补充一些过滤器内置技能数据.</b>
<b>9. 继续修正能量条层级问题.</b>
<b>C20191011A</b>
<b>1. 更新任务助手为网易有爱版.</b>
<b>2. 大地图增加区域信息显示.</b>
<b>3. 更新大地图增强修正偶发的战斗中打不开问题.</b>
<b>4. 修正5秒回蓝提示的显示,修正能量条层级问题.</b>
<b>5. 更新DBM至20191010225744.</b>
<b>C20191010A</b>
<b>1. 修正目标框体精英龙标志.</b>
<b>2. 修正采集助手数据库以适配怀旧服.</b>
<b>3. 调整V2姓名版非目标透明度预设值.</b>
<b>C20191009A</b>
<b>1. 拍卖增强和拍卖助手不能同时开启,默认关闭拍卖助手,可在单体插件管理中切换.</b>
<b>2. 修正聊天框不能重复发言的问题.</b>
<b>3. 更新NPC位置模块添加专业相关等.</b>
<b>4. 内置库更新等.</b>
<b>C20191007D</b>
<b>1. 紧急修正LUA报错.</b>
<b>C20191007C</b>
<b>1. 金币字段增加今日利润或亏损统计.</b>
<b>C20191007B</b>
<b>1. 整合BuadAuction拍卖增强插件可按一口价排序等.</b>
<b>2. 提高与第三方小地图插件的兼容性.</b>
<b>C20191007A</b>
<b>1. 任务追踪当任务目标完成时自动隐藏任务助手在地图上的目标点.</b>
<b>2. DBM更新至20191006024748.</b>
<b>3. 采集助手更新修正草药技能名等.</b>
<b>4. 更新仇恨光环计时等内置库.</b>
<b>5. 修正图腾条,玩家和目标框体添加复活指示器等.</b>
<b>C20191006A</b>
<b>1. 更换任务追踪框为Butter插件并进行了修改和汉化,左键可直接拖动位置,右键打开设置.</b>
<b>2. 任务等级,自动追踪任务功能默认禁用由Butter提供.</b>
<b>3. 自动交接任务开关在界面上隐藏可到增强功能中开启,也可用任务助手中的自动交接任务功能.</b>
<b>4. 修改SM的图腾职业条,内置库更新等.</b>
<b>C20191005A</b>
<b>1. 修正任务通报的错误.</b>
<b>2. 给V1姓名版增加施法条显示.</b>
<b>3. 修正任务助手与V1姓名版一处冲突.</b>
<b>C20191004A</b>
<b>1. 整合采集助手插件.</b>
<b>2. 更新副本战利品查询.</b>
<b>3. 目标框体增加职责图标显示.</b>
<b>4. 更新5秒回蓝库，更新一些系统皮肤美化等.</b>
<b>C20191002A</b>
<b>1. 修正治疗预估的错误.</b>
<b>2. 集成一键换装插件,可通过统一解锁移动.</b>
<b>3. 调整单体插件管理设置界面布局.</b>
<b>4. 重新集成图标美化包.</b>
<b>5. 系统皮肤更新.</b>
<b>C20191001A</b>
<b>1. 更新任务助手,查询任务增加显示任务ID.</b>
<b>2. 继续完善Buff/Debuff过滤器预设技能,若觉过滤器不好用可在姓名版或单位框体对应位置删掉过滤器的引用.</b>
<b>3. 单位框体增加助理和坦克框体.</b>
<b>4. 更新内置库增加能量恢复库等.</b>
<b>C20190930A</b>
<b>1. 更新任务助手,以减少刷新频繁等.</b>
<b>2. 大地图右上角增加隐藏地图标记的按键.</b>
<b>3. 重新启用姓名版和单位框体的过滤器.</b>
<b>C20190929A</b>
<b>1. 更新DBM以修正错误.</b>
<b>2. 修改任务追踪框，无任务时将自动隐藏,修正自动交接任务与任务助手自带的自动交接冲突问题.</b>
<b>3. 修正邮箱界面问题.</b>
<b>4. 更新内置库和系统皮肤等.</b>
<b>C20190927B</b>
<b>1. 修正一处配置导致队伍框体的问题.</b>
<b>2. 姓名版任务怪图标的开关在单体插件任务助手里.</b>
<b>3. 修正打断通告.</b>
<b>4. 修正自动修理判断的问题.</b>
<b>5. 修正中心冷却图标的问题.</b>
<b>6. 修正ALM模块的一处报错.</b>
<b>7. 修正禁用聊天框后AFK模块会报错的问题.</b>
<b>8. 尝试修复姓名版在副本内友方姓名版的问题.</b>
<b>9. 修正光环条时间过滤的问题.</b>
<b>10. 系统皮肤更新.</b>
<b>C20190927A</b>
<b>1. 引入了更多的状态条材质.</b>
<b>2. 修复因文件名限制导致DBM-NAXX文件不完整的问题.</b>
<b>3. 更新任务助手模块,有些任务会追踪所有地图可在这些任务详情中点隐藏追踪解决卡的问题.</b>
<b>4. 更新仇恨助手.</b>
<b>C20190925A</b>
<b>1. 修正某些场景下库加载的问题.</b>
<b>2. 更新内置光环过滤器数据.</b>
<b>3. 一些系统皮肤更新.</b>
<b>4. 内置库更新.</b>
<b>5. 修正DBM的错误.</b>
<b>C20190924C</b>
<b>1. 任务追踪框体改成EUI统一解锁移动.</b>
<b>C20190924B</b>
<b>1. 更换新任务追踪框体，现不受5个数量限制.</b>
<b>2. 更新宠物经验条,并只限猎人加载.</b>
<b>3. DBM更新至20190924043406.</b>
<b>C20190924A</b>
<b>1. 修正LUA错误导致 宠物队伍失效的问题.</b>
<b>C20190923B</b>
<b>1. 修正动作条技能高亮的错误.</b>
<b>2. 修正拍卖助手拍卖时间的错误,修正拍卖信息更新的问题,默认关闭新手教程.</b>
<b>2. 宠物欢乐度增加设置选项.</b>
<b>C20190923A</b>
<b>1. 集成仇恨助手,默认关闭(在单体插件管理中启用).</b>
<b>2. 更新任务助手.</b>
<b>3. 更新自动下马功能.</b>
<b>4. 更新NPC位置模块添加武器大师，弹药商人等.</b>
<b>5. 一些内置库和核心代码更新.</b>
<b>C20190922A</b>
<b>1. 技能高亮提示在增强功能里增加了开关.</b>
<b>2. 集成AuctionFaster拍卖助手.</b>
<b>3. DBM 更新至20190922013747.</b>
<b>4. 更新内置仇恨库.</b>
<b>5. 信息条增加宠物经验条.</b>
<b>6. 更新一键宏模块.</b>
<b>7. 更新任务等系统皮肤.</b>
<b>C20190920A</b>
<b>1. 重新添加任务通报功能.</b>
<b>2. 修复增强功能的漂亮仇恨条模块.</b>
<b>3. 增加动作条技能高亮功能.</b>
<b>4. 更换RaidCD内置监视技能.</b>
<b>C20190919D</b>
<b>1. 更新好友框职业染色等以修复混乱问题.</b>
<b>C20190919C</b>
<b>1. LUA错误修正.</b>
<b>C20190919B</b>
<b>1. LUA错误修正.</b>
<b>C20190919A</b>
<b>1. 增强功能增加自动下马功能.</b>
<b>2. 暂时禁用小地图对追踪图标的修改.</b>
<b>3. 修正数值缩写有些场景未生效的问题.</b>
<b>C20190918B</b>
<b>1. 暂时禁用斩杀提示待修正.</b>
<b>2. 更新美化皮肤模块.</b>
<b>C20190918A</b>
<b>1. 一些系统皮肤修正.</b>
<b>2. DBM更新至20190916010455.</b>
<b>3. 更新NPC位置地图标记模块,添加稀有怪位置默认关闭.</b>
<b>4. 更新地下城位置标记模块.</b>
<b>5. 更新Recount伤害统计插件.</b>
<b>6. 修正镜头距离设置.</b>
<b>7. 更新一键宏模块.</b>
<b>8. 重新启用团队Debuff模块和Debuff高亮模块.</b>
<b>9. 更新拾取和修理功能.</b>
<b>10. 更新信息文字中公会等模块.</b>
<b>11. 集成副本战利品查询和副本地图模块,设置在单体插件管理里.</b>
<b>12. 更新任务助手模块.</b>
<b>13. 集成角色属性增强,设置在增强功能UI分组里.</b>
<b>14. 移除失效的姓名版载入距离选项.</b>
<b>C20190914C</b>
<b>1. 修正邮箱，拾取等美化皮肤.</b>
<b>2. 美化大地图上一些插件功能按键.</b>
<b>3. 修改怀旧服EUI版本号以C开头以便于正式服区分.</b>
<b>C20190914B</b>
<b>1. 姓名版增加载入距离设置.</b>
<b>2. 单体插件管理中加入平砍计时条模块,以支持平砍，自动射击和猎人瞄准等计时条.</b>
<b>3. 任务追踪框折叠按键会正确的跟随追踪框隐藏.</b>
<b>C20190914A</b>
<b>1. 等级显示现影响任务日志框,并在增强功能里有了独立开关.</b>
<b>2. 修正偶发的鼠标提示物品售价引起的报错.</b>
<b>3. 内置库更新.</b>
<b>C20190913A</b>
<b>1. 继续修正任务助手.</b>
<b>2. 自建新的任务追踪框体,增强功能中加入开关.</b>
<b>3. 任务追踪框可自定义字体尺寸.</b>
<b>4. 修正自动任务物品模块的任务物品显示.</b>
<b>5. 修正DBM默认语音包设置.</b>
<b>6. 修复V1姓名版颜色和光环计时问题.</b>
<b>7. 更新仇恨库以支持怀旧服.</b>
<b>8. 任务追踪框可自定义字体尺寸.</b>
<b>9. 一些系统皮肤和内置库更新.</b>
<b>C20190912A</b>
<b>1. 整合ClassicCodex任务助手，并完成汉化.</b>
<b>2. 完善单体插件管理功能,大部份整合插件完成动态加载.</b>
<b>3. 更新系统美化皮肤.</b>
<b>4. 一些错误修正.</b>
<b>C20190911A</b>
<b>1. EUI核心更新，清除旧代码.</b>
<b>2. 内置库更新.</b>
<b>3. 重新添加下载具按键.</b>
<b>4. 更新DBM-PVP模块.</b>
<b>5. 更新真实血量库.</b>
<b>6. 添加NPC位置地图标记模块.</b>
<b>7. 添加地下城位置标记模块.</b>
<b>8. 添加飞行点位置标记模块.</b>
<b>9. 更新一键宏模块.</b>
<b>10. 更新系统皮肤,更新V2姓名版等.</b>
<b>C20190904A</b>
<b>1. 增加宠物快乐度显示(待测试).</b>
<b>C20190903A</b>
<b>1. 增加自动追踪任务功能.</b>
<b>2. 修正任务图标问题.</b>
<b>3. 更新DBM 20190831173730.</b>
<b>4. 内置ACE3等库更新.</b>
<b>5. 更新单位框体等模块.</b>
<b>C20190830A</b>
<b>1. 内置OUF等库更新修改.</b>
<b>1. 一些模块BUG修改.</b>
<b>C20190829C</b>
<b>1. 挂载外部库使目标光环计时可用,影响光环条和EUI内置技能监视模块.</b>
<b>2. 增加点击聊天框解锁图标时强制解锁任务追踪框.</b>
<b>C20190829B</b>
<b>1. 修复施法条错误,可显示目标施法条.</b>
<b>2. 屏蔽玩家属性统计框.</b>
<b>3. 启用自动交接任务模块.</b>
<b>4. 启用任务等级显示等增强模块.</b>
<b>C20190829A</b>
<b>1. 更换装备观察显示模块.</b>
<b>2. 增加真实血量库并修改核心以支持真实血量显示.</b>
<b>3. 修改核心以支持光标计时库和目标施法条库.</b>
<b>4. 一些核心代码修改.</b>
<b>C20190828A</b>
<b>1. 重新添加离线数据中心.</b>
<b>2. 增强功能添加任务增强.</b>
<b>3. 修复自动邀请的问题.</b>
<b>4. 美化皮肤模块更新.</b>
<b>5. 美化皮肤模块更新.</b>
<b>6. 因部份系统美此皮肤有问题先行禁用.</b>
<b>7. 删除Details伤害统计插件更换为Recount.</b>
<b>8. 禁用DEBUFF高亮等模块,待修复.</b>
<b>9. 重新添加按键保存插件.</b>
<b>C20190827B</b>
<b>1. 重新添加V1姓名版,部份功能屏蔽.</b>
<b>2. 修复观察装备列表功能.</b>
<b>3. 移除一些失效代码,修复一些LUA错误.</b>
<b>C20190827A</b>
<b>1. LUA错误修正.</b>
<b>C20190826C</b>
<b>1. 恢复系统皮肤美化.</b>
<b>2. 一些设置项错误修正.</b>
<b>C20190826B</b>
<b>1. 增加Details伤害统计插件.</b>
<b>2. 修正增加功能中一些模块的错误.</b>
<b>C20190826A</b>
<b>1. 初步更新支持怀旧服版.</b>
<b>2. 部份功能暂时屏蔽，待开服修正后开放;请不要与正式服插件混用！.</b>]=];	

local function ReplaceB(str,toggle)
	local tmp
	if toggle then
		tmp = str:gsub("<b>","    "):gsub("</b>","\n")
	else
		tmp = str:gsub("<b>",""):gsub("</b>","\n")
	end
	return tmp
end

local function ModifiedString(str)
	local tmp = gsub(str, "<b>%d%d%d%d%d%d%d%d%u</b>", function(s)
		local st = ReplaceB(s)
		local s1 = tonumber(st:gsub("\n",""):sub(1,8)) or 0
		local s2 = tonumber((E.global.Ver):sub(1,8)) or 0 --判断更新前的版本
		if s1 > s2 then
			return "|cffff7d0a" .. st .. "|r"
		else
			return "|cFFFFFF00" .. st .. "|r"
		end
	end)
	return ReplaceB(tmp, true)
end

local function GetChangeLogInfo(i)
	for line, info in pairs(ChangeLogData) do
		if line == i then return info end
	end
end

function ChangeLog:CreateLogFrame()
	local title = CreateFrame("Frame", "EUIChangeLogFrame", E.UIParent)
	title:SetPoint("CENTER",  E.UIParent, 'CENTER', 0, 200)
	tinsert(UISpecialFrames, "EUIChangeLogFrame")
	title:SetSize(578, 30)
	title:SetTemplate("Transparent")
	title.text = title:CreateFontString(nil, "OVERLAY")
	title.text:SetPoint("CENTER", title, 0, -1)
	title.text:SetFont(E["media"].normFont, 16)
	title.text:SetText("|cffff7d0aEUI|r - " .. L["ChangeLog"])
	title:SetMovable(true)
	title:EnableMouse(true)
	title:Hide()
	title:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" and not self.isMoving then
			self:StartMoving();
			self.isMoving = true;
		elseif button == "RightButton" and not self.isSizing then
			self:StartSizing();
			self.isSizing = true;
		end
	end)
	title:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and self.isMoving then
			self:StopMovingOrSizing();
			self.isMoving = false;
		elseif button == "RightButton" and self.isSizing then
			self:StopMovingOrSizing();
			self.isSizing = false;
		end
	end)
	title:SetScript("OnHide", function(self)
		if ( self.isMoving or self.isSizing) then
			self:StopMovingOrSizing();
			self.isMoving = false;
			self.isSizing = false;
		end
	end)

	local frame = CreateFrame("Frame", nil, title)
	frame:SetTemplate('Transparent')
	frame:Size(600, 200)
	frame:Point('TOPRIGHT', title, 'BOTTOMRIGHT', 0, -2)
	frame:SetResizable(true)
	frame:SetMinResize(350, 100)
	frame:SetFrameStrata("DIALOG")
	
	local icon = CreateFrame("Frame", nil, frame)
	icon:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", -20, 2)
	icon:SetSize(40, 40)
	icon:SetTemplate("Transparent")
	icon.bg = icon:CreateTexture(nil, "ARTWORK")
	icon.bg:Point("TOPLEFT", 2, -2)
	icon.bg:Point("BOTTOMRIGHT", -2, 2)
	icon.bg:SetTexture([[Interface\AddOns\ElvUI\media\textures\eui_logo.tga]])

	local scrollArea = CreateFrame("ScrollFrame", "EUIChangeLogScrollFrame", frame, "UIPanelScrollFrameTemplate")
	scrollArea:Point("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)
	S:HandleScrollBar(EUIChangeLogScrollFrameScrollBar)

	scrollArea:SetScript("OnSizeChanged", function(self)
		EUIChangeLogFrameEditBox:Width(self:GetWidth())
		EUIChangeLogFrameEditBox:Height(self:GetHeight())
	end)
	scrollArea:HookScript("OnVerticalScroll", function(self, offset)
		EUIChangeLogFrameEditBox:SetHitRectInsets(0, 0, offset, (EUIChangeLogFrameEditBox:GetHeight() - offset - self:GetHeight()))
	end)

	local editBox = CreateFrame("EditBox", "EUIChangeLogFrameEditBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:Width(scrollArea:GetWidth())
	editBox:Height(200)
	editBox:SetScript("OnEscapePressed", function() EUIChangeLogFrame:Hide() end)
	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "EUIChangeLogFrameCloseButton", title, "UIPanelCloseButton")
	close:Point("TOPRIGHT")
	close:SetFrameLevel(close:GetFrameLevel() + 1)
	close:EnableMouse(true)

	S:HandleCloseButton(close)
end

function E:ToggleChangeLog()
	local frame = EUIChangeLogFrame or ChangeLog:CreateLogFrame()

	EUIChangeLogFrameEditBox:SetText(ModifiedString(ChangeLogWebData));
	PlaySound(88)

	if not E.global.Ver then ChangeLog:CheckVersion() end
	
	if not EUIChangeLogFrame:IsShown() then
		EUIChangeLogFrame:Show()
	else
		EUIChangeLogFrame:Hide()
	end
end

function ChangeLog:CheckVersion()
	if GetLocale() == 'zhCN' then
		if not E.global.Ver or (E.global.Ver and E.global.Ver ~= E.Ver) then
			E:ToggleChangeLog()
			E.global.Ver = E.Ver
			E:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end
end

function ChangeLog:Initialize()
	if E.private.install_complete == nil then return; end

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckVersion")
	
end

E:RegisterModule(ChangeLog:GetName())