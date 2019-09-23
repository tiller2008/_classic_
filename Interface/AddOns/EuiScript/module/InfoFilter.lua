local E, L, V, P, G, _ = unpack(ElvUI);
local IFSSymbols={"`"," ","~","@","#","^","*","＝"," ","，","。","、","？","！","：","’","‘","“","”","【","】",
				 "{","}","『","』","《","》","<",">","（","）","丨","（","）","＃","——","－","＆","×","＠","～","!",
				 "＼","％","　","│","☆","★","○","●","◎","◇","◆","◆","■","△","▲","※",'▇','▓','∑',
} 
local InvaildNum = {
	['１'] = '1',['２'] = '2',['３'] = '3',['４'] = '4',['５'] = '5',['６'] = '6',['７'] = '7',['８'] = '8',['９'] = '9',['０'] = '0',
	['①'] = '1',['②'] = '2',['③'] = '3',['④'] = '4',['⑤'] = '5',['⑥'] = '6',['⑦'] = '7',['⑧'] = '8',['⑨'] = '9',
	['㈠'] = '1',['㈡'] = '2',['㈢'] = '3',['㈣'] = '4',['㈤'] = '5',['㈥'] = '6',['㈦'] = '7',['㈧'] = '8',['㈨'] = '9',
	['⑴'] = '1',['⑵'] = '2',['⑶'] = '3',['⑷'] = '4',['⑸'] = '5',['⑹'] = '6',['⑺'] = '7',['⑻'] = '8',['⑼'] = '9',
}
--2015.04.05 补充自动过滤特殊符号,自动替换不正常的数字为正常数字,方便过滤
--2015.03.09 尝试修有时有发言人黑名单无效的问题
--2015.01.28 加入禁用系统的语言过滤器，加入禁止密语粘滞开关
--2014.12.28 加入关键词匹配临时黑名单,以降低CPU消耗,缓冲好友列表避免卡顿感
--2014.12.28 特殊符号中加入空格
--2014.12.27 初版,部份代码参考NoGoldSeller,Badboy
local cacheBlackName = {}
local twipe = table.wipe
local find, type, pairs, gsub = string.find, type, pairs, string.gsub
local FriendList = {}
local runOnce = false
local IFSid2 = 0

local SetCVar = SetCVar
local GetNumFriends = C_FriendList.GetNumFriends
local ShowFriends = ShowFriends
local BNGetNumFriends = BNGetNumFriends
local BNGetFriendToonInfo = BNGetFriendToonInfo
local UnitIsInMyGuild = UnitIsInMyGuild
local UnitIsUnit = UnitIsUnit
local UnitInRaid = UnitInRaid
local UnitInParty = UnitInParty
local Ambiguate = Ambiguate

local fr = CreateFrame("Frame")
fr:RegisterEvent("FRIENDLIST_UPDATE")
fr:RegisterEvent("PLAYER_ENTERING_WORLD")
fr:SetScript("OnEvent", function(self,event)
	if event == 'PLAYER_ENTERING_WORLD' then
		self:UnregisterEvent('PLAYER_ENTERING_WORLD')
		if E.global.profanityFilter then SetCVar("profanityFilter", "0") end
		if E.global.nowhisperSticky then
			ChatTypeInfo.WHISPER.sticky = 0
			ChatTypeInfo.BN_WHISPER.sticky = 0
		end
	else
		local num = GetNumFriends()
		for i = 1, num do
			local info = C_FriendList.GetFriendInfoByIndex(i)
			local n = info.name
			--add friends to safe list
			if n then
				FriendList[n] = true
			else
				if not runOnce then
					ShowFriends();
					runOnce = true;
				end
			end
		end
		local _, oon = BNGetNumFriends()
		for i = 1, oon do
			local toon = BNGetFriendInfo(i)
			for j = 1, toon do
				local _, rName, rGame = BNGetGameAccountInfo(i, j)
				if (rGame == "WoW") then
					FriendList[rName] = true;
				end
			end
		end
	end
end)

local sameUser = {
	['name'] = {
		['time'] = GetTime(),
		['memo1'] = '',
		['memo2'] = '',
		['id'] = 1,
	}
}

local function FilterChinaChar(s)
	if not s then return; end
	if type(s) ~= 'string' then return s; end 
	s = s:gsub('%w', '')
	s = s:gsub('%p', '')

	return s
end

local function InfoFilter(IFSself, IFSevent, IFSmsg, IFSauthor, _, _, _, IFSflag, _, _, IFSchannel, _, IFSid, guid)
	--非中文系统或禁用则直接返回
	if(not E.zhlocale) or (not E.global.InfoFilter.enable) then
		return false;
	end
	
	if IFSauthor == E.myfullname then return false; end --不过滤玩家自身。
	
	local ChatFrameName = IFSself:GetName()
	
	--不过滤GM的密语
	if ((IFSevent == "CHAT_MSG_WHISPER" and (IFSflag == "GM" or IFSflag == 'DEV')) or UnitIsInMyGuild(IFSauthor) or UnitIsUnit(IFSauthor,"player") or UnitInRaid(IFSauthor) or UnitInParty(IFSauthor)) then 
		return false; 
	end
	--不过滤集合石的信息
	if IFSchannel == '集合石' then
		return false
	end
	--不过滤好友或战网好友的信息
	local trimmedPlayer = Ambiguate(IFSauthor, "none")
	if E.global.InfoFilter.filterFriend and (FriendList[IFSauthor] or FriendList[trimmedPlayer]) then
		return false
	end

	--过滤低等级玩家密语
	--由badboy处理
	
	--过滤黑名单中的玩家信息
	if E.global.InfoFilter.blackName[IFSauthor] then
		if (E.global.InfoFilter.Debug) then --debug
			DEFAULT_CHAT_FRAME:AddMessage(IFSauthor)
			DEFAULT_CHAT_FRAME:AddMessage(IFSmsg)
		end
		return true;
	end
	
	--防止缓存库过大,达到200人就清空一次
	local cacheNum, cacheNum2 = 0, 0
	for k, v in pairs(cacheBlackName) do
		cacheNum = cacheNum + 1
	end
	for k, v in pairs(sameUser) do
		cacheNum2 = cacheNum2 + 1
	end
	if cacheNum > 200 then
		twipe(cacheBlackName)
	end
	if cacheNum2 > 200 then
		twipe(sameUser)
	end
	
	--如果玩家发言连续被屏蔽10次,就加到临时黑名单中直接过滤
	if cacheBlackName[IFSauthor] and cacheBlackName[IFSauthor] > 10 then
		if (E.global.InfoFilter.Debug) then --debug
			DEFAULT_CHAT_FRAME:AddMessage(IFSauthor)
			DEFAULT_CHAT_FRAME:AddMessage(IFSmsg)
		end	
		return true;
	end

	--查找大饼，星星等符号,只作于大脚世界频道
	local a = nil
	IFSmsg, a = gsub(IFSmsg, '{rt%d}', '')
	if (E.global.InfoFilter.rtNum > 0) and (a >= E.global.InfoFilter.rtNum) and IFSchannel == L["BigFootChannel"] then
		if (E.global.InfoFilter.Debug) then --debug
			DEFAULT_CHAT_FRAME:AddMessage(IFSauthor)
			DEFAULT_CHAT_FRAME:AddMessage(IFSmsg)
		end	
		return true;
	end
	
	--替换掉*.【等特殊符号
	for i = 1, #IFSSymbols do
		IFSmsg, a = gsub(IFSmsg, IFSSymbols[i], "")
	end
	
	--替换不正常的数字
	for k, v in pairs(InvaildNum) do
		IFSmsg, a = gsub(IFSmsg, k, v)
	end

	if E.global.InfoFilter.blackList['1-100'] then
		E.global.InfoFilter.blackList['1-100'] = nil;
	end
	
	local IFSmatch = 0;
	--匹配IFSwords的关键词
	for IFSword, wordEnable in pairs(E.global.InfoFilter.blackList) do
		if wordEnable then
			local IFSnewString, IFSresult = gsub(IFSmsg, IFSword, "");
			if (IFSresult > 0) then
				IFSmatch = IFSmatch +1;
			end
		end
	end	

	if (IFSmatch >= E.global.InfoFilter.matchNum) then		
		if (E.global.InfoFilter.Debug) then --debug
			DEFAULT_CHAT_FRAME:AddMessage(IFSauthor)
			DEFAULT_CHAT_FRAME:AddMessage(IFSmsg)
		end
		if not(IFSid == IFSid2) then
			IFSid2 = IFSid
			--被命中的玩家加到临时黑名单中，并计次
			if not cacheBlackName[IFSauthor] then
				cacheBlackName[IFSauthor] = 1;
			elseif cacheBlackName[IFSauthor] < 15 then --防止无限叠加溢出
				cacheBlackName[IFSauthor] = cacheBlackName[IFSauthor] + 1;
			end
		end
		return true; --达到匹配个数则屏蔽
	else
		if ChatFrameName == 'ChatFrame1' then
			local noEnChar = FilterChinaChar(IFSmsg)
			if sameUser[IFSauthor] then
				local findIt = false;
				if sameUser[IFSauthor].memo1:find(noEnChar) or sameUser[IFSauthor].memo2:find(noEnChar) then
					findIt = true;
				end
			
				if findIt and ((GetTime() - sameUser[IFSauthor].time) < E.global.InfoFilter.repeatTime) then
					if not cacheBlackName[IFSauthor] then
						cacheBlackName[IFSauthor] = 1;
					elseif cacheBlackName[IFSauthor] < 15 then --防止无限叠加溢出
						cacheBlackName[IFSauthor] = cacheBlackName[IFSauthor] + 1;
					end
					if (E.global.InfoFilter.Debug) then --debug
						DEFAULT_CHAT_FRAME:AddMessage(IFSauthor)
						DEFAULT_CHAT_FRAME:AddMessage(IFSmsg)
					end
					sameUser[IFSauthor].time = GetTime();
					return true;
				elseif sameUser[IFSauthor].id == 1 then
					sameUser[IFSauthor].memo2 = noEnChar;
					sameUser[IFSauthor].id = 2;
					sameUser[IFSauthor].time = GetTime();
				elseif sameUser[IFSauthor].id == 2 then
					sameUser[IFSauthor].memo1 = noEnChar;
					sameUser[IFSauthor].id = 1;
					sameUser[IFSauthor].time = GetTime();
				end
			else
				sameUser[IFSauthor] = {['time'] = GetTime(),['memo1'] = noEnChar, ['memo2'] = noEnChar, ['id'] = 1,};
			end
		end
		return false;
	end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",InfoFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", InfoFilter) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", InfoFilter) 
--ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", InfoFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_ADDON", InfoFilter) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", InfoFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", InfoFilter)