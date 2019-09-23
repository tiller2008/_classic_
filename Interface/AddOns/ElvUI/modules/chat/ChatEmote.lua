local E, L, DF = unpack(select(2, ...)); --Engine
local CH = E:GetModule('Chat')

local CreateFrame = CreateFrame
local ChatEdit_ChooseBoxForSend = ChatEdit_ChooseBoxForSend

local ChatEmote = {}
E.ChatEmote = ChatEmote
ChatEmote.Config = {
	iconSize = 24,
	enableEmoteInput = true,
}
-- enUS by 黑白熊猫
if (GetLocale() == "zhCN") then
	ChatEmote.tipstr = "点击打开聊天表情框" --Click to open emoticon frame
elseif (GetLocale() == "zhTW") then
	ChatEmote.tipstr = "點擊打開聊天表情框"
else
	ChatEmote.tipstr = "Click to open emoticon frame"
end
local customEmoteStartIndex = 9

local emotes = {
	{"{rt1}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_1]=]},
	{"{rt2}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_2]=]},
	{"{rt3}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_3]=]},
	{"{rt4}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_4]=]},
	{"{rt5}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_5]=]},
	{"{rt6}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_6]=]},
	{"{rt7}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_7]=]},
	{"{rt8}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_8]=]},
	{"{天使}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Angel]=]},
	{"{生气}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Angry]=]},

	{"{大笑}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Biglaugh]=]},
	{"{鼓掌}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Clap]=]},
	{"{酷}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Cool]=]},
	{"{哭}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Cry]=]},
	{"{可爱}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Cutie]=]},
	{"{鄙视}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Despise]=]},
	{"{美梦}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Dreamsmile]=]},
	{"{尴尬}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Embarrass]=]},
	{"{邪恶}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Evil]=]},
	{"{兴奋}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Excited]=]},

	{"{晕}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Faint]=]},
	{"{打架}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Fight]=]},
	{"{流感}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Flu]=]},
	{"{呆}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Freeze]=]},
	{"{皱眉}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Frown]=]},
	{"{致敬}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Greet]=]},
	{"{鬼脸}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Grimace]=]},
	{"{龇牙}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Growl]=]},
	{"{开心}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Happy]=]},
	{"{心}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Heart]=]},

	{"{恐惧}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Horror]=]},
	{"{生病}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Ill]=]},
	{"{无辜}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Innocent]=]},
	{"{功夫}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Kongfu]=]},
	{"{花痴}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Love]=]},
	{"{邮件}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Mail]=]},
	{"{化妆}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Makeup]=]},
	{"{马里奥}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Mario]=]},
	{"{沉思}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Meditate]=]},
	{"{可怜}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Miserable]=]},

	{"{好}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Okay]=]},
	{"{漂亮}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Pretty]=]},
	{"{吐}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Puke]=]},
	{"{握手}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Shake]=]},
	{"{喊}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Shout]=]},
	{"{闭嘴}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Shuuuu]=]},
	{"{害羞}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Shy]=]},
	{"{睡觉}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Sleep]=]},
	{"{微笑}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Smile]=]},
	{"{吃惊}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Suprise]=]},

	{"{失败}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Surrender]=]},
	{"{流汗}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Sweat]=]},
	{"{流泪}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Tear]=]},
	{"{悲剧}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Tears]=]},
	{"{想}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Think]=]},
	{"{偷笑}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Titter]=]},
	{"{猥琐}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Ugly]=]},
	{"{胜利}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Victory]=]},
	{"{雷锋}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Volunteer]=]},
	{"{委屈}",	[=[Interface\Addons\ElvUI\modules\chat\icon\Wronged]=]},
}

CH.emotes = emotes

local ShowEmoteTableButton
local EmoteTableFrame, EmoteClubTableFrame

local function CreateEmoteClubTableFrame()
	EmoteClubTableFrame = CreateFrame("Frame", "EmoteClubTableFrame", CommunitiesFrame)
	EmoteClubTableFrame:SetTemplate()
	EmoteClubTableFrame:SetWidth((ChatEmote.Config.iconSize+2) * 12+4)
	EmoteClubTableFrame:SetHeight((ChatEmote.Config.iconSize+2) * 5+4)
	EmoteClubTableFrame:SetPoint("BOTTOMLEFT", CommunitiesFrame, "BOTTOMRIGHT", E:Scale(2), 0)
	EmoteClubTableFrame:Hide()
	EmoteClubTableFrame:SetFrameStrata("DIALOG")

	local icon, row, col
	row = 1
	col = 1
	for i=1,#emotes do 
		text = emotes[i][1]
		texture = emotes[i][2]
		icon = CreateFrame("Frame", format("IconButton%d",i), EmoteClubTableFrame)
		icon:SetWidth(ChatEmote.Config.iconSize)
		icon:SetHeight(ChatEmote.Config.iconSize)
		icon.text = text
		icon.texture = icon:CreateTexture(nil,"ARTWORK")
		icon.texture:SetTexture(texture)
		icon.texture:SetAllPoints(icon)
		icon:Show()
		icon:SetPoint("TOPLEFT", (col-1)*(ChatEmote.Config.iconSize+2)+2, -(row-1)*(ChatEmote.Config.iconSize+2)-2)
		icon:SetScript("OnMouseUp", ChatEmote.EmoteClubIconMouseUp)
		icon:EnableMouse(true)
		col = col + 1 
		if (col>12) then
			row = row + 1
			col = 1
		end
	end
end

local function CreateEmoteTableFrame()
	EmoteTableFrame = CreateFrame("Frame", "EmoteTableFrame", E.UIParent)
	EmoteTableFrame:SetTemplate()
	EmoteTableFrame:SetWidth((ChatEmote.Config.iconSize+2) * 12+4)
	EmoteTableFrame:SetHeight((ChatEmote.Config.iconSize+2) * 5+4)
	EmoteTableFrame:SetPoint("BOTTOMLEFT", LeftChatPanel, "TOPLEFT", 0, E:Scale(2))
	EmoteTableFrame:Hide()
	EmoteTableFrame:SetFrameStrata("DIALOG")

	local icon, row, col
	row = 1
	col = 1
	for i=1,#emotes do 
		text = emotes[i][1]
		texture = emotes[i][2]
		icon = CreateFrame("Frame", format("IconButton%d",i), EmoteTableFrame)
		icon:SetWidth(ChatEmote.Config.iconSize)
		icon:SetHeight(ChatEmote.Config.iconSize)
		icon.text = text
		icon.texture = icon:CreateTexture(nil,"ARTWORK")
		icon.texture:SetTexture(texture)
		icon.texture:SetAllPoints(icon)
		icon:Show()
		icon:SetPoint("TOPLEFT", (col-1)*(ChatEmote.Config.iconSize+2)+2, -(row-1)*(ChatEmote.Config.iconSize+2)-2)
		icon:SetScript("OnMouseUp", ChatEmote.EmoteIconMouseUp)
		icon:EnableMouse(true)
		col = col + 1 
		if (col>12) then
			row = row + 1
			col = 1
		end
	end
end

function ChatEmote.ToggleEmoteTable()
	if (not EmoteTableFrame) then CreateEmoteTableFrame() end
	if (EmoteTableFrame:IsShown()) then
		EmoteTableFrame:Hide()
	else
		EmoteTableFrame:Show()
	end
end

function ChatEmote.ToggleClubEmoteTable()
	if (not EmoteClubTableFrame) then CreateEmoteClubTableFrame() end
	if (EmoteClubTableFrame:IsShown()) then
		EmoteClubTableFrame:Hide()
	else
		EmoteClubTableFrame:Show()
	end
end

function ChatEmote.EmoteClubIconMouseUp(frame, button)
	if (button == "LeftButton") then
		CommunitiesFrame.ChatEditBox:Insert(frame.text)
	end
	ChatEmote.ToggleClubEmoteTable()
end

function ChatEmote.EmoteIconMouseUp(frame, button)
	if (button == "LeftButton") then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(frame.text)
	end

	ChatEmote.ToggleEmoteTable()
end

local C_Club_GetMessageInfo = C_Club.GetMessageInfo
function C_Club.GetMessageInfo(clubId, streamId, messageId)
	local message = C_Club_GetMessageInfo(clubId, streamId, messageId);
	message.content = CH:GetSmileyReplacementText(message.content)
	
	return message
end

local C_Club_GetMessagesBefore = C_Club.GetMessagesBefore
function C_Club.GetMessagesBefore(clubId, streamId, messageRangeOldest, maxCount)
	local messages = C_Club_GetMessagesBefore(clubId, streamId, messageRangeOldest, maxCount);
	if #messages == 0 then
		return;
	end

	for index = 1, #messages do
		messages[index].content = CH:GetSmileyReplacementText(messages[index].content)
	end

	return messages
end

local function CreateEmoteClubTableButton()
	if ShowEmoteClubTableButton then return end

	local button2 = CreateFrame("Button", format("ShowEmoteClubTableButton"), CommunitiesFrame.AddToChatButton)
	button2:SetPoint("LEFT", CommunitiesFrame.AddToChatButton, "RIGHT", 6, 0)
	button2:Size(16)
--	button:SetTemplate("Transparent",true)

	button2:SetNormalTexture("Interface\\AddOns\\ElvUI\\modules\\chat\\icon\\Smile")
	button2:SetHighlightTexture("Interface\\AddOns\\ElvUI\\modules\\chat\\icon\\Smile-Highlight")

	button2:SetScript("OnMouseUp", function(self, btn)
		CH.ChatEmote.ToggleClubEmoteTable()
	end)

	button2:SetScript("OnEnter", function(self)
	--	self:SetTemplate("ClassColor", E["media"].glowTex)
		GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 6)
		GameTooltip:AddLine(CH.ChatEmote.tipstr)
		GameTooltip:Show()
	end)
	button2:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	--	self:SetTemplate("Transparent")
	end)
	
	ShowEmoteClubTableButton = button2
end

function CH:LoadChatEmote()
	if not E.db.chat.emotionIcons then return end
	CH.ChatEmote = ChatEmote

	if not E.zhlocale then return; end

	CreateEmoteTableFrame()
	local cf = _G["ChatFrame1"]
	if E.db["euiscript"].chatbar ~= true then
		local button = CreateFrame("Button", format("ShowEmoteTableButton"), LeftChatPanel)
		button:SetPoint("RIGHT", LeftChatTab, "RIGHT", E.db["euiscript"].statreport and -26 or -6, 0)
		button:Size(16)
	--	button:SetTemplate("Transparent",true)

		button:SetNormalTexture("Interface\\AddOns\\ElvUI\\modules\\chat\\icon\\Smile")
		button:SetHighlightTexture("Interface\\AddOns\\ElvUI\\modules\\chat\\icon\\Smile-Highlight")

		button:SetScript("OnMouseUp", function(self, btn)
			CH.ChatEmote.ToggleEmoteTable()
		end)

		button:SetScript("OnEnter", function(self)
		--	self:SetTemplate("ClassColor", E["media"].glowTex)
			GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 6)
			GameTooltip:AddLine(CH.ChatEmote.tipstr)
			GameTooltip:Show()
		end)
		button:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		--	self:SetTemplate("Transparent")
		end)	
		
		ShowEmoteTableButton = button
	end

	local S = E:GetModule('Skins')
	S:AddCallbackForAddon("Blizzard_Communities", "Communities2", CreateEmoteClubTableButton)
end

