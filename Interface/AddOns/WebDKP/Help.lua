------------------------------------------------------------------------
-- HELP	
------------------------------------------------------------------------
-- Contains methods related to displaying help and the help frame to the
-- user. 
------------------------------------------------------------------------

-- The actual help content
local WebDKP_Help = {
    [1] = {
        ["Name"] = "欢迎",
        ["Text"] = "|cFFFF0000欢迎使用 WebDKP|r" ..
                "|n|n" ..
                "此插件旨在通过自动化许多管理任务，使管理dkp的任务更容易。 这个插件使得查看和修改公会的dkp变得很容易. 然后，可以使用附带的同步工具或从网站控制中心上载日志文件，将游戏中所做的更改与http://webdkp.wowcat.net网站同步" ..
                "|n|n" ..
                "此帮助文档是为了指导你完成插件的基本和更高级的使用方法. 如果这是你第一次使用插件, 你可以在插件内找到Tutorial文件夹,那里有详细的使用方法,也可以参考本帮助页获得帮助.. " ..
                "|n|n" ..
                "Thanks,|n" ..
                "Quartal, Xenosian, Agard, and Zevious"
    },
    [2] = {
        ["Name"] = "一般使用",
        ["Text"] = "|cFFFF0000一般使用|r" ..
                "|n|n" ..
                "通过从小地图的金币图标,左键它,可以选择和实现插件的大多数功能。" ..
                "|n|n" ..
                "单击'DKP表'选项，会出现一个DKP表窗口.这是我们查看和操作DKP的地方. 如果这是你第一次使用插件，那么插件的DKP表里可能是空的。这是因为列表默认只显示当前组中的人。你要参加一个队伍或团队，那你就会看到名单上开始有很多人。当表中填充了人时，可以通过单击表标题对其进行排序." ..
                "|n|n" ..
                "右边的选项是插件的所有功能所在的位置. 此区域有4个主要选项卡供您使用：过滤、奖惩dkp,奖惩物品,替补 " ..
                "|n|n" ..
                "|cFFFF0000过滤|r 允许您筛选要在DKP表中显示的内容. 你可以将表限制为指定的职业，从而更容易找到所需人员. 在这里，你还可以通过取消选中“仅显示当前组中的玩家”来显示表中的所有人员，包括不在当前组中的人员. " ..
                "|n|n" ..
                "|cFFFF0000奖惩DKP|r 允许你从所选人员中奖励或减去dkp. 注意，这仅用于DKP,千万不用于记录奖励物品. 要奖励dkp，你只需从左侧选择要奖励的人员, 输入奖励的理由和分数, 然后点击'奖惩DKP'. 为了便于从列表中选择玩家，你可以在底部找到两个名为“选择所有”和“取消所有”的按钮。" ..
                "|n|n" ..
                "|cFFFF0000奖惩物品|r 允许你将物品授予单个玩家. 请从左侧选择一个接收玩家、一个物品成本（正数），输入物品名称，然后点击奖惩!. 如果你启用了“自动填充”或“自动奖励”（默认情况下为启用），则会自动为你输入和记录此信息。如果你禁用了这些功能，你还可以在聊天框中按住shift键并单击物品名称来填写物品名称. " ..
                "|n|n" ..
                "在团队结束后,你必须保存文档,并上传到DKP网站 |cFFFF0000http://webdkp.wowcat.net|r ,建议使用我们的Webdkp同步工具哦! 操作更加方便" ..
                "|n|n" ..
                "|cFFFF0000关于衰减DKP功能|r 允许你输入一个值衰减全团的dkp。如果值为0.5，则会减去所有为正数dkp的团员的DKP总数的50%. 只有当玩家的dkp为负时，输入-0.5的值才能增加50%的dkp."

    },
    [3] = {
        ["Name"] = "选项",
        ["Text"] = "|cFFFF0000选项|r" ..
                "|n|n" ..
                "WebDKP有多种选项，允许你根据你的公会需要对其进行调整。通过单击“小地图”下拉列表中的“选项”选项，可以找到“选项”窗口。" ..
                "|n|n" ..
                "|cFFFF0000自动填充|r 启用后，WebDKP将监视你的聊天窗口，以查看是否有人接收到物品 (如: Qcat获得了: [一件紫装]). 当插件检测到它们时，它将自动选择dkp表中的接收玩家，并自动在“奖惩物品”选项卡上填写“物品名称”。如果你使用的是战利品表，系统还将尝试在战利品表中查找物品的价格，并将其填写在物品价格框中。 " ..
                "|n|n" ..
                "|cFFFF0000自动填充物品阈值|r 设置自动填充将拾取的物品的品质级别" ..
                "|n|n" ..
                "|cFFFF0000自动奖惩|r 更进一步的自动填充. 当启用后,当插件检测到一个物品被谁捡取后,WebDKP将显示一个弹出框架. 此弹出框将允许你输入物品的DKP成本，并自动将此信息记录在DKP表中。就像自动填充一样，它和你的战利品表单是绑在一起的,同样可以和战利品表单一起使用 " ..
                "|n|n" ..
                "|cFFFF0000零和DKP|r 零位DKP是一个DKP分数处理系统，当物品DKP处理完毕时才会被触发。如果你启用了零和DKP模式,那么无论是谁因为获取了装备而被扣的DKP分数都会平均分配给全团参与玩家,例如:你们是一个40人的团队,A获得了一件装备,被扣了40DKP,那么全团都会被奖励到1点DKP,在严格竞争下，一方的收益必然意味着另一方的损失，博弈各方的收益和损失相加总和永远为“零”，双方不存在合作的可能。所以,零和DKP系统是一个相对比较好的科学DKP模式" ..
                "|n|n" ..
                "|cFFFF0000自动BOSS击杀奖励|r 允许你指定每次杀死SOBB自动获得多少DKP。其他两个复选框允许你为20人或40人启用或禁用此功能." ..
                "|n|n" ..
                "|cFFFF0000all in(梭哈)DKP|r all in(梭哈)DKP是为了装备一个玩家出价所有的dkp和失去所有的dkp."


    },
    [4] = {
        ["Name"] = "私聊DKP",
        ["Text"] = "|cFFFF0000私聊DKP|r" ..
                "|n|n" ..
                "私聊DKP是一个功能，允许团原们发送给你私聊，以查看他们当前的DKP以及DKP表。这项功能的好处在于，私聊dkp相关的传入和传出的私聊对你是隐藏 ，因此你的聊天框不会被私聊刷屏。" ..
                "|n|n" ..
                "要使用此功能，任何人都只需向你私聊发出以下命令：" ..
                "|n|n" ..
                "|cFFFF0000'mydkp'|r - 告诉他当前的DKP|n" ..
                "|cFFFF0000'查询'|r - 列出当前组中每个人的dkp|n" ..
                "|n|n" ..
                "'查询' 和 '查询所有' 可以在末尾添加职业名以筛选它们. 例如:" ..
                "|n|n" ..
                "|cFFFF0000查询 LR|r - 列出当前组中所有猎人的dkp|n" ..
                "|cFFFF0000查询 LR QS|r - 列出当前组中所有猎人和圣骑士的DKP"
    },
    [5] = {
        ["Name"] = "竞拍",
        ["Text"] = "|cFFFF0000竞拍|r" ..
                "|n|n" ..
                "一个自动竞拍功能,可供使用竞拍价来决定谁应该收到物品的公会使用. 首先使用竞价窗口或聊天命令进行竞拍. 你的raid中的玩家可以在私聊/团队/队伍聊天频道中发出消息说他们想出价多少，这个竞拍模块会将获取这些信息并显示在屏幕上. 竞拍结束后，你可以选择获奖用户并单击奖励。这将自动将此信息记录在DKP表中。" ..
                "|n|n" ..
                "若要使用竞拍表格开始投标，可以从下拉菜单中选择“竞拍”. 然后，你可以输入要竞拍的物品名称以及竞拍持续时间的可选时间（秒）. (在此处输入0表示没有时间限制). 单击“开始竞拍”,你也可以按住shift键并单击聊天框中的物品，方便在“物品名称”框中自动填写物品名称 " ..
                "|n|n" ..
                "玩家可以使用聊天信息或私聊出价:|n" ..
                "|cFFFF0000出价 #|r   (例如: 出价 20)" ..
                "|n|n" ..
                "要使用聊天命令开始出价，你可以在聊天中说:|n" ..
                "|cFFFF0000开拍 物品名|r|n" ..
                "|cFFFF0000开拍 物品名, 时间(秒)|r" ..
                "|n|n" ..
                "物品名称可以手动输入，也可以通过按住shift键并单击物品来输入. |n" ..
                "然后可以使用命令停止竞拍|n" ..
                "|cFFFF0000停拍|r" ..
                "|n|n" ..
                "你如果正在使用固定DKP系统,玩家也可以选择私聊|cFFFF0000需求|r 和 |cFFFF0000贪婪|r 而不是出价."

    },
    [5] = {
        ["Name"] = "战利品表集成系统",
        ["Text"] = "|cFFFF0000战利品表集成系统|r" ..
                "|n|n" ..
                "插件的一个方便的特性是让它与你在http://webdkp.wowcat.net上创建的战利品表集成在一起。在站点上创建战利品表（手动或通过选择一个模板）时，此信息将在下次同步时同步到插件内." ..
                " 然后，webdkp插件可以以不同的方式查找这些信息，以使你的DKP管理生活更轻松。" ..
                "|n|n" ..
                "在一些地方你会看到使用的战利品表信息:" ..
                "|n|n" ..
                "|cFFFF0000奖惩物品|r|n如果你在“奖惩物品”选项卡中输入一个名称，将自动查找并填写DKP价格" ..
                "|n|n" ..
                "|cFFFF0000自动奖惩|r|n如果你开启了自动奖惩功能，弹出窗口将自动在“物品成本”字段中为你填写物品DKP成本." ..
                "|n|n" ..
                "|cFFFF0000固定竞拍|r|n如果你使用的是固定竞拍选项，当你奖励玩家时，物品成本将从战利品表中填写。（有关固定竞价的详细信息，请参见选项）"
    },
    [6] = {
        ["Name"] = "可用命令",
        ["Text"] = "|cFFFF0000可用命令|r" ..
                "|n|n" ..
                "下面是可以在游戏中使用的斜杠命令:" ..
                " 1.) /webdkp show table - 显示dkp表 " ..
                "|n|n" ..
                " 2.) /webdkp show bidding - 显示竞拍窗口." ..
                "|n|n" ..
                " 3.) /webdkp show synch - 显示游戏内同步设置" ..
                "|n|n" ..
                " 4.) /webdkp show options - 显示设置窗口" ..
                "|n|n" ..
                " 5.) /webdkp show timed - 显示时间分奖励窗口" ..
                "|n|n" ..
                " 6.) /webdkp show help - 显示帮助窗口" ..
                "|n|n" ..
                " 7.) /webdkp show log - 显示奖惩日志窗口" ..
                "|n|n" ..
                " 8.) /webdkp show raidlog - 显示团队日志窗口" ..
                "|n|n" ..
                " 9.) /webdkp show charlog - 显示角色团队日志窗口" ..
                "|n|n" ..
                "10.) /webdkp start raid - 团队日志内开始一个Raid" ..
                "|n|n" ..
                "11.) /webdkp end raid - 团队日志内结束一个Raid" ..
                "|n|n" ..
                "12.) /webdkp ignore list - 列出所有忽略的物品" ..
                "|n|n" ..
                "13.) /webdkp ignore add - 将物品添加到忽略列表" ..
                "|n|n" ..
                "14.) /webdkp ignore del - 从忽略列表中删除物品 (不能删除默认的)"
    },
    [7] = {
        ["Name"] = "忽略物品列表",
        ["Text"] = "|cFFFF0000忽略物品|r" ..
                "|n|n" ..
                "WebDKP允许你将物品添加到默认忽略列表. 默认忽略列表包含在WTF中的webdkp.lua中，无法从游戏中编辑。 以下是允许你在wow中列出、添加和删除忽略物品的命令" ..
                "|n|n" ..
                " 1.) 下面是一个如何列出已添加的所有物品的示例 " ..
                "     /webdkp ignore list" ..
                "|n|n" ..
                " 2.) 下面是如何将物品添加到忽略列表的示例" ..
                "     /webdkp ignore add 物品名, 如: /webdkp ignore add 亚麻布" ..
                "|n|n" ..
                " 3.) 下面是如何从忽略列表中删除物品的示例" ..
                "     /webdkp ignore del 物品名, 如: /webdkp ignore add 亚麻布"
    },
}

-- ================================
-- Initializes the help menu to show the 
-- currently selected topic
-- ================================
function WebDKP_Help_Init()
    WebDKP_Help_DropDown_Init();
    WebDKP_Help_Frame_Text:SetText(WebDKP_Help[WebDKP_HelpFrame.helpChoice]["Text"]);
end

-- ================================
-- Toggles the help frame on and off.
-- ================================
function WebDKP_Help_ToggleGUI()
    if (WebDKP_HelpFrame:IsShown()) then
        WebDKP_HelpFrame:Hide();
    else
        WebDKP_Help_Init();
        WebDKP_HelpFrame:Show();
    end
end


-- ================================
-- Invoked when the gui is down. Loads up the contents
-- of the help topic drop down. 
-- ================================
function WebDKP_Help_DropDown_OnLoad()
    UIDropDownMenu_Initialize(WebDKP_Help_DropDown, WebDKP_Help_DropDown_Init);
end

-- ================================
-- Invoked when the help menu drop down list is invoked. 
-- Runs through the help topics data structure and adds
-- a list of items. 
-- ================================
function WebDKP_Help_DropDown_Init()

    if (WebDKP_HelpFrame.helpChoice == nil) then
        WebDKP_HelpFrame.helpChoice = 1;
    end

    --WebDKP_Print(WebDKP_Help[WebDKP_HelpFrame.helpChoice]["Name"]);
    local numHelpTopics = WebDKP_GetTableSize(WebDKP_Help);
    for i = 1, numHelpTopics do
        if (type(WebDKP_Help[i]) == "table") then
            local checked = (WebDKP_Help[i]["Name"] == WebDKP_Help[WebDKP_HelpFrame.helpChoice]["Name"]);
            WebDKP_Add_HelpDropDownItem(self, WebDKP_Help[i]["Name"], i, checked);
        end
    end
    UIDropDownMenu_SetSelectedName(WebDKP_Help_DropDown, WebDKP_Help[WebDKP_HelpFrame.helpChoice]["Name"]);
    UIDropDownMenu_SetWidth(WebDKP_Help_DropDown, 150, 10);
end

-- ================================
-- Helper method that adds individual entries into the help menu drop down
-- ================================
function WebDKP_Add_HelpDropDownItem(self, text, value, checked)
    local this = self;
    local info = { };
    info.text = text;
    info.value = value;
    info.owner = this;
    info.checked = checked;
    info.func = WebDKP_Help_DropDown_OnClick;
    UIDropDownMenu_AddButton(info);
end

-- ================================
-- Called when the user switches between
-- a different dkp table.
-- ================================
function WebDKP_Help_DropDown_OnClick(self)
    local this = self;
    WebDKP_HelpFrame.helpChoice = this.value;
    WebDKP_Help_DropDown_Init();
    WebDKP_Help_Frame_Text:SetText(WebDKP_Help[WebDKP_HelpFrame.helpChoice]["Text"]);
end

