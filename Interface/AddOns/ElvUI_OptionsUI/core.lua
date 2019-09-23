local E = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local AddOnName, Engine = ...

Engine[1] = {}
Engine[2] = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale or "enUS")

local C, L = Engine[1], Engine[2]

C.Values = {
	FontFlags = {
		["NONE"] = L["NONE"],
		["OUTLINE"] = "OUTLINE",
		["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
		["THICKOUTLINE"] = "THICKOUTLINE"
	}
}

local D = E:GetModule("Distributor")
local format = format
local sort, tinsert = sort, tinsert

local _G = _G
E.Libs.AceGUI = _G.LibStub("AceGUI-3.0")
E.Libs.AceConfig = _G.LibStub("AceConfig-3.0-ElvUI")
E.Libs.AceConfigDialog = _G.LibStub("AceConfigDialog-3.0-ElvUI")
E.Libs.AceConfigRegistry = _G.LibStub("AceConfigRegistry-3.0-ElvUI")
E.Libs.AceDBOptions = _G.LibStub("AceDBOptions-3.0")

local UnitName = UnitName
local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit
local UnitIsFriend = UnitIsFriend
local UnitIsPlayer = UnitIsPlayer
local GameTooltip_Hide = GameTooltip_Hide
local GameFontHighlightSmall = _G.GameFontHighlightSmall

--Function we can call on profile change to update GUI
function E:RefreshGUI()
	E:RefreshCustomTextsConfigs()
	E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
end

E.Libs.AceConfig:RegisterOptionsTable("ElvUI", E.Options)
E.Libs.AceConfigDialog:SetDefaultSize("ElvUI", E:GetConfigDefaultSize())

E.Options.args = {
	ElvUI_Header = {
		order = 1,
		type = "header",
		name = L["Version"] .. format(": |cff99ff33%s|r", E.version).. format(" Build: |cfffe7b2c%s|r", E.FullVersion),
		width = "full"
	},
	RepositionWindow = {
		order = 2,
		type = "execute",
		name = L["Reposition Window"],
		desc = L["Reset the size and position of this frame."],
		customWidth = 175,
		func = function()
			if E.GUIFrame then
				local status = E.GUIFrame.obj and E.GUIFrame.obj.status
				if status then
					E:ResetConfigSettings()

					status.top, status.left = E:GetConfigPosition()
					status.width, status.height = E:GetConfigDefaultSize()

					E.GUIFrame.obj:ApplyStatus()
				end
			end
		end
	},
	ToggleTutorial = {
		order = 3,
		type = "execute",
		name = L["Toggle Tutorials"],
		customWidth = 150,
		func = function()
			E:Tutorials(true)
			E:ToggleOptionsUI()
		end
	},
	Install = {
		order = 4,
		type = "execute",
		name = L["Install"],
		customWidth = 100,
		desc = L["Run the installation process."],
		func = function()
			E:Install()
			E:ToggleOptionsUI()
		end
	},
	ResetAllMovers = {
		order = 5,
		type = "execute",
		name = L["Reset Anchors"],
		customWidth = 150,
		desc = L["Reset all frames to their original positions."],
		func = function()
			E:ResetUI()
		end
	},
	ToggleAnchors = {
		order = 6,
		type = "execute",
		name = L["Toggle Anchors"],
		customWidth = 150,
		desc = L["Unlock various elements of the UI to be repositioned."],
		func = function()
			E:ToggleMoveMode()
		end
	},
	LoginMessage = {
		order = 7,
		type = "toggle",
		name = L["Login Message"],
		customWidth = 150,
		get = function(info)
			return E.db.general.loginmessage
		end,
		set = function(info, value)
			E.db.general.loginmessage = value
		end
	}
}


if GetLocale() == 'zhCN' then
	E.Options.args.ToggleTutorial = nil;
	E.Options.args.	ChangeLogToggle = {
		order = 3,
		type = "execute",
		name = L["ChangeLog"],
		desc = L["ChangeLog"],
		func = function() E:ToggleChangeLog(); E:ToggleOptionsUI() end,
	}
end
local DONATOR_STRING = ""
local CNDONATOR_STRING = ""
local CNDONATOR_STRING2 = ""
local CNDONATOR_STRING3 = ""
local DEVELOPER_STRING = ""
local TESTER_STRING = ""
local LINE_BREAK = "\n"
local DONATORS = {
	"Dandruff",
	"Tobur/Tarilya",
	"Netu",
	"Alluren",
	"Thorgnir",
	"Emalal",
	"Bendmeova",
	"Curl",
	"Zarac",
	"Emmo",
	"Oz",
	"Hawké",
	"Aynya",
	"Tahira",
	"Karsten Lumbye Thomsen",
	"Thomas B. aka Pitschiqüü",
	"Sea Garnet",
	"Paul Storry",
	"Azagar",
	"Archury",
	"Donhorn",
	"Woodson Harmon",
	"Phoenyx",
	"Feat",
	"Konungr",
	"Leyrin",
	"Dragonsys",
	"Tkalec",
	"Paavi",
	"Giorgio",
	"Bearscantank",
	"Eidolic",
	"Cosmo",
	"Adorno",
	"Domoaligato",
	"Smorg",
	"Pyrokee",
	"Portable",
	"Ithilyn"
}


local CNDONATORS = {
	"wxbbf",
	"sammyda",
	"zmmjoy1028",
	"lileimu0126",
	"happy_fly_pig",
	"lulu5205200701",
	"qq52776758",
	"lulu5205200701",
	"玩酷轨迹",
	"泉0510",
	"皮蛋oo",
	"雨季雷",
	"lmnno",
	"feliciagao",
	"炽天使zz",
	"忘归猪",
	"marger52",
	"maimang",
	"凌乱兰花",
	"不会吐泡的鱼",
	"gd2933",
	"realzhumen",
	"itachi_203",
	"wzadjl",
	"chaoyi3456",
	"shameless_pig",
	"chise1",
	"默默远去",
	"大只标",
	"波谲云诡1314",
	"大唐风羽",
	"叹息的足迹",
	"曦月刃语",
	"samwoody",
	"oinoon",
	"tb379270_2012",
	"被人踹下天",
	"风之路人11",
	"wargreymon1234",
	"chris6522",
	"情侣t恤",
	"lyq402631678",
	"silverhawx",
	"terrymu",
	"jianxinbang",
	"yydatou2",
	"liubin5381",
	"jh967354",
	"shome",
	"santon123",
	"chenyunlong00",
	"kaminakeita",
	"gypazyy",
	"belthil17",
	"deathduo",
	"吧嗒吧嗒大学生",
	"路过的羽毛",
	"open1648",
	"bigzmeng617",
	"geenar",
	"fxymike",
	"叶落心安",
	"duyu75526150",
	"jiangxuxing1985_",
	"上帝的知己",
	"atcc7212",
	"gugg594254843",
	"wawq919",
	"arler",
	"listzj",
	"xiaoxiao4433",
	"皮蛋仔sean",
	"路过的羽毛",
	"miaofu1982",
	"jedi_chen",
	"ryumiya",
	"孤独的饼子",
	"chenyn66",
	"醉恋琉璃",
	"ye2311",
	"cityrat",
	"zhaopeng0905",
	"hanuqq",
	"tb69493153",
	"亲亲丶亲爱的",
	"qcdz008",
	"来自淮安",
	"立派的变态",
	"快播小百合",
	"尤娜天使",
	"天国沙迦",
	"isyours",
	"xiaoshoushi",
	"chenguobao369",
	"刘晨曦1984",
	"许海飞xhf",
	"starryson",
	"lsy9202",
	"zpwbmw",
	"cz_lingling",
	"惋水语自然",
	"forpyp",
	"路过的羽毛",
	"66272089w",
	"wowmojovan",
	"huojey",
	"dlsdccdcc",
	"wuge19870501",
	"dongyizhi90",
	"奉天笑笑生",
	"fzh冯子豪",
	"玩酷轨迹",
	"wang730122wxk",
	"紫夜灬毒酒", --"卩灬丶丿王丶爷"
	"archer0808",
	"dark09",
	"ggl_axs",
	"宁夏红丶",
	"luxuxin530754137",
	"jyy402",
	"azur2e",
	"tb5187319_88",
	"豆子丶",
	"tb497346_2011",
	"橙子酱53105981",
	"foxsmely",
	"gorden_gan",
	"pjh79",
	"御剑乘风酒剑仙",
	"天若o有情_2009",
	"renchao15",
	"aierlanhai",
	"曾经丶烽",
	"linbin814619",
	"bysharrka",
	"ywj373303873",
	"aslick",
	"maling871128",
	"zhaokeith",
	"esc丶卟点",
	"shortland",
	"szc0635",
	"tatsuyahome",
	"aeon_sakura",
	"eddiegsp3",
	"血鹰幽灵",
	"levisli888",
	"jianshen3868",
	"elafor",
	"knight_5201314",	
	"咆哮的柴郡猫",
	"立派的变态",
	"yirong_sun",
	"永远的亚瑟",
	"孤星丶夜",
	"最帅的牛", --ianliuh
	"fht112233",
	"a503113120",
	"天王永存",
	"xiaoshoushi",
	"sasoricat",
	"巨烦人",
	"demodevil",
	"sandylester88",
	"临界冰封",
	"shxx_lee",
	"xiaxiaowei_516",
	"gongyong982715",
	"ivan90511",
	"kingyb26",
	"tb337033_99",
	"iverson21cn",
	"zoorre",
	"boatman13",
	"抢啊抢啊抢",
	"我是山猪2011",
	"Paramahamsa",  --shhope
	"bibi6",
	"肾不由己1989",
	"qyzod",
	"joydarken",
	"slovxy",
	"achongnrg",
	"leebv",
	"xj138154",
	"ley2008",
	"路过的羽毛",
	"wsyf8754210",
	"samsung_55",
	"q301076955",
	"宁静之神46566",
	"a13656506079",
	"hlcwin",
	"游离之魂",
	"sybasta",
	"orbneil",
	"好人fk",
	"sy04816leo",
	"heaven589",
	"zhouhao27",
	"feng9016",
	"kyuubifox",
	"tb425775_00",
	"kalrend",
	"lyqhzls14",
	"夭夭茶",
	"daftjoker",
	"我是山猪2011",
	"cfjie",
	"zuiairongx",
	"nomibuy",
	"小虎第一小虎第一",	
}
local CNDONATORS2 = {
	"买东西的jlu",
	"dizzy11",
	"baixf0703",
	"tb425775_00",
	"卷囡囡",
	"羽毛的标准",
	"fightingbug",
	"indigo0000",
	"tom60876",
	"mijiemijie198610",
	"akonwang1988 ",
	"tzlsj00",
	"杨柳岸残钺",
	"q489842856",
	"suancaihit",
	"dlsdccdcc",
	"我是山猪2011",
	"起床嘘嘘",
	"liudilin1992",
	"diyun0607",
	"yaibj",
	"雪线伊人",
	"k100992994",
	"小萨乐",
	"末日呈",
	"cesarmarui",
	"aihooo",
	"shadow477",
	"曲建行",
	"tessaex",
	"encili",
	"cutlass_sz",
	"c27346734",
	"computer0102",
	"jsjhgp1989",
	"caoshui_2008",
	"mingxiuyu",
	"123321awy",
	"藍幽魅兒",
	"hlf9527",
	"像雨一样忧伤",
	"hujintao8",
	"落雪无痕9371",
	"sunnying1218",
	"oenzoo",
	"一死谢天下",
	"shihaomrzhang",
	"jurane",
	"胖熊回家",
	"shajia221",
	"fzq5201",
	"sirius冲儿",
	"咆哮的柴郡猫",
	"sm00haha",
	"潘德威",
	"earldliu",
	"dubaoli060431",
	"醉爱无痕",
	"喜欢jing3",
	"蒋松儒",
	"sophie000088",
	"my58026",
	"ayoko",
	"狂暴之魂",
	"浮云丶寂凉",
	"clampjay12",
	"辛晓康",
	"ley2008",
	"awgy97",
	"longzi1439",
	"臭蛋小超人",
	"manstein623",
	"daivd_dai",
	"liangrouchang",
	"拉拉kop",
	"2wsx2005",
	"颓废的食神",
	"zhou_love_zhu",
	"makiyo0218",
	"ajijiawei1",
	"wjzh19940530",
	"林吴珂",
	"cjy530qs",
	"tb3182534_2011",
	"washhongname",
	"seven_夜",
	"豆子丶",
	"曹晨阳",
	"欧阳义煌",
	"sabarwow2",
	"qianjx8888",
	"ankang1666",
	"世界神殿",
	"dulluke",
	"xcx2200",
	"ss19880630",
	"a13946283",
	"tb425775_00",
	"木易念_张",
	"wangde649868",
	"tb843273_2011",
	"晨曦星",
	"cqing888",
	"wkw533038",
	"lxjdsmm",
	"口袋里的坦克",
	"tb95188807",
	"ghp1165",
	"remix熙",
	"马雁阳",
	"花已落下",
	"柒小7_7",
	"茶靡花事了",
	"riley1983",
	"shyzd",
	"與汝同思",
	"云蛋风轻kimi",
	"insov",
	"zp1989717",
	"ginraiy",
	"youdianfano",
	"东腿爸爸",
	"han30_0213",
	"asdf01989119",
	"gangerster",
	"msmicrosoft",
	"wenjianbin115",
	"wyang1027",
	"mdoexeryher",
	"堕落刺客.m",
	"polinell",
	"tb_ljx",
	"merkava3",
	"jaminjing",
	"雷亦歌",
	"vishnv",
	"布布的布",
	"摇不尽的风情", --max1032
	"zmy4528",
	"hlf9527",
	"枸杞子西洋参",
	"itoluthp",
	"lightbring",
	"thecrucifix",
	"a308253730",
	"chongchongok",
	"zerocraft",
	"上帝的知己",
	"月华无双",
	"马路西安",
	"龙骨平原-Drusus", --赵世康1
	"紫苑迷娈",
	"yoyo1943123",
	"爱的no1",
	"zytzx",
	"ajax1035",
	"一叫千门万户开",
	"b蜗牛",
	"wangziyueaacom",
	"x363170927",
	"青空的留白",
	"风蓝夕颜",
	"yxaml",
	"cumt001",
	"闫小幸0806",
	"wasky520",
	"快乐吖点",
	"冷芯琥珀",
	"tb267280_2013",
	"ouchukun",
	"wangzihyf",
	"mars89326",
	"mybackbone",
	"dubaoli060431",
	"markeloff95",
	"jxaa011975",
	"q87799",
	"68xing",
	"黄冬冬丶",
	"圣光一闪",--gaoqiyuan
	"乐taotao",
	"南宫之宇",
	"hotandcool",
	"cd86757",
	"薛云月11",
	"wsheng82",
	"买东西滴1982",
	"ph851112",
	"大藏乡",
	"wht3833",
	"传说有钱人",
	"sakrar",
	"飞火流枫",
	"小小woman",
	"bingheyizu",
	"x363170927",
	"且看风去风留d",
	"ephraimjj",
	"li729253213",
	"百羽百末",
	"li729253213",
	"guobenjing1992",
	"li729253213",
	"酃恋辰兮",
	"znxts",
	"li729253213",
	"默默远去",
	"laodiaozl",
	"soi一fong",
	"qwpmom",
	"丶丶丶夜冬 ",
	"起个b名想一周",
	"zhangqibei1993316",
	"春奈酱",--crazy9287
	"丨小小苏丨",
	"陨落的半神",--tb_2365641
	"ypy283217",
	"tb858705_22",
	"zkshahaha",
	"暧沐涕",
	"morrisduan",
	"大德无德",
	"lilolau",
	"王飞爱朦朦",
	"hisyf",
	"flynewhome",
	
}

local CNDONATORS3 = {
	"niwei831206",
	"霜月球",
	"ftx121416",
	"卫原明",
	"牛德华不牛",
	"jasonmaker",
	"insee884",
	"小新09180",
	"相思蓝枫叶",
	"q6890338",
	"kdiwang",
	"jqllove2",
	"ykp2008q",
	"tyadan",
	"52dulang",
	"国产金刚互撸娃",
	"antaxzj",
	"剧毒创伤",
	"我是山猪2011",
	"如风灬似水",
	"最爱回锅肉", --zhwfrank
	"zhpeng120",
	"psp星痕",
	"caatkl",
	"tb92330716",
	"gxy3223553",
	"lean28",
	"白403600533",
	"wwhdd96727",
	"波风皆人1314",
	"xlssce",
	"dwnokia",
	"aiken2132",
	"桔子的崩坏",
	"donkey_41",
	"a244988253",
	"跋扈的飞扬",
	"一筐包子",
	"miss采薇",
	"爱yy的蜗牛",
	"luanshun1",
	"诚意拍拍工作室",
	"a6322978",
	"mrxux",
	"nayazj",
	"ksanasetsuna",
	"cd122431897",
	"junny9985",
	"tb5370284_2011",
	"small871204",
	"yl50420031",
	"nj966",
	"zhao466807256",
	"丶丢雷劳模", --qq524991989  
	"牙牙xb",
	"zhouyx5",
	"testb35513",
	"爱购320",
	"freejansen",
	"ksanasetsuna",
	"何晓宇1993",
	"死亡之翼利维坦",--zhuyukai_kai
	"tb22004_34",
	"lxgxy520lx",
	"tb44963",
	"kiraxfree",
	"好名字全让取了",
	"天真的创伤",--myth家驹03
	"小小的皓轩",
	"影子_同学",
	"gangerster",
	"躺在七楼",
	"chaoren18ac",
	"salaleenom",
	"炫紫忧梦",
	"tb9769994",
	"口袋里的坦克",
	"罗凯健",
	"sagacityshen",
	"金大奇奇",
	"飘落的冰晶缘",
	"not_animals",
	"yszdlm2009",
	"wusi19821211",
	"丫丫的大唐",
	"铭记丶回忆",
	"a18627814951",
	"wuhao290",
	"春哥很疯狂",
	"王颛321",
	"春奈酱",--crazy9287
	"me丨白",
	"laolv198811",
	"zeratul44",
	"tonken2046",
	"kid_9463",
	"qiutiangoal",
	"jikai01c",
	"dcdb723",
	"dc910714dyz",
	"无名de信仰",
	"alicend",
	"th02689",
	"化作万风",
	"random_fly",
	"njjwl2005",
	"redgo111",
	"yerobin00",
	"渡_kitchen",
	"多多可爱多0408",
	"yumeng4442",
	"wendi_5",
	"yao19911019",
	"无缘之锋",
	"永恒的泡泡",
	"sookie",
	"gengye1860",
	"nan129588",
	"stalker11",
	"斐洛蒙",
	"exxx2014",
	"上帝的知己",
	"lovehein",
	"你买卖我卖买",
	"han30_0213",
	"sbh1941",
	"口袋里的坦克",
	"xjtufans",
	"风之小碧落",
	"cokar",
	"me2youdear",
	"cz78644915",
	"4q104q",
	"小刀木乃伊",
	"活火明月",
	"指間丄的旋律",--尚学箫
	"shengqing5655",
	"pokacc",
	"谢灿强21",
	"cpii266",
	"lesterfg",
	"admijie",
	"qq395004730",
	"环球保卫队",
	"clark810810",
	"岚亦悠然",
	"bibichuang0806",
	"lwsame",
	"mk_go",
	"jyhk201210",
	"王颛321",
	"萌萌恋-红云台地", --sallymm234
	"cty110cty",
	"j_n_z",
	"我是金华的",
	"张佳伦0411",
	"tb28817966",
	"qqtoffadsl",
	"yaohai1205",
	"detetivehaode",
	"zend_study",
	"zts6830849",
	"kchunquan",
	"古晨泽",
	"freewalker1985",
	"woaintbb",
	"akbryant",
	"迈克尔桥墩",
	"bunycn",
	"迷离李小贤",
	"祭落樱瞳",
	"zheng98jiao",
	"holesun",
	"能便宜点唛",
	"钱海生涯",
	"大道理我早懂",
	"teani小洛",
	"sqybi",
	"梦子龙",
	"zcdemx",
	"shuaizhi1987",
	"wangjinfang823279",
	"e30914038",
	"hopebbs",
	"1127tm",
	"lijin901128",
	"pausdk",
	"我酱了个油",
	"蔡晓阳520",
	"dengni10000",
	"lqlgoran",
	"蒲公英的约定1989",
	"namiyeiyi",
	"li317445938",
	"deja即视",
	"zmy4528",
	"taohui52098",
	"布袋青蛙",
	"意外访客1234",
	"freelement1",
	"lxlasx",
	"doya_kakyo",
	"填充味",
	"boydf117",
	"mlaht520",
	"tttwwwccc",
	"grayzen",
	"电波小子4",
	"clearies",
	"panck",
	"白水伊人", --lovequan1120
	"12白开水",
	"小贴纸",
	"jikai01c",
	"哈琵、alistar",
	"撒旦战车",
	"唐朝逃兵",
	"zero零度77",
	"IIaalamm",--想回到过去呀
	"我的名字叫乐乐",
	"好冷血",
	"超级兔子1007",
	"小叮当的多啦b梦",
	"xiawei198300",
	"mengfei376",
	"wang2018shuai",
	"scarlettt0709",
	"啊睿儿哥",
	"胡小帅789",
	"k107635",
	"lzhrcsp",
	"玥儿丶逗逗",
	"俟欤1409",
	"bensam1111888888",
	"野人布谷",
	"bk9998",
	"huarse",
	"梦中秋雨",
	"邪空大魔王",
	"百变衣橱_诺曼琦",
}

local DEVELOPERS = {
	"Tukz",
	"Haste",
	"Nightcracker",
	"Omega1970",
	"Hydrazine",
	"Blazeflack",
	"NihilisticPandemonium",
	"|cffff7d0aMerathilis|r",
	"|cFF8866ccSimpy|r",
	"|cFF0070DEAzilroka|r"
}

local TESTERS = {
	"Tukui Community",
	"|cffF76ADBSarah|r - For Sarahing",
	"Affinity",
	"Modarch",
	"Bladesdruid",
	"Tirain",
	"Phima",
	"Veiled",
	"Repooc",
	"Darth Predator",
	"Alex",
	"Nidra",
	"Kurhyus",
	"BuG",
	"Yachanay",
	"Catok"
}

local function SortList(a, b)
	return a < b
end

sort(DONATORS, SortList)
sort(DEVELOPERS, SortList)
sort(TESTERS, SortList)

for _, name in pairs(DONATORS) do
	tinsert(E.CreditsList, name)
	DONATOR_STRING = DONATOR_STRING .. LINE_BREAK .. name
end
for _, name in pairs(DEVELOPERS) do
	tinsert(E.CreditsList, name)
	DEVELOPER_STRING = DEVELOPER_STRING .. LINE_BREAK .. name
end
for _, name in pairs(TESTERS) do
	tinsert(E.CreditsList, name)
	TESTER_STRING = TESTER_STRING .. LINE_BREAK .. name
end

if not E.zhlocale then
	sort(DONATORS, function(a,b) return a < b end) --Alphabetize
	for _, donatorName in pairs(DONATORS) do
		tinsert(E.CreditsList, donatorName)
		DONATOR_STRING = DONATOR_STRING..LINE_BREAK..donatorName
	end

	sort(DEVELOPERS, function(a,b) return a < b end) --Alphabetize
	for _, devName in pairs(DEVELOPERS) do
		tinsert(E.CreditsList, devName)
		DEVELOPER_STRING = DEVELOPER_STRING..LINE_BREAK..devName
	end

	sort(TESTERS, function(a,b) return a < b end) --Alphabetize
	for _, testerName in pairs(TESTERS) do
		tinsert(E.CreditsList, testerName)
		TESTER_STRING = TESTER_STRING..LINE_BREAK..testerName
	end
else
	sort(CNDONATORS, function(a,b) return a < b end) --Alphabetize
	for _, testerName in pairs(CNDONATORS) do
		tinsert(E.CreditsList, testerName)
	end
end	

local cni = 0
for _, cndonatorName in pairs(CNDONATORS) do
	cni = cni + 1
	if mod(cni, 20) == 0 then
		CNDONATOR_STRING = CNDONATOR_STRING..LINE_BREAK..LINE_BREAK..cndonatorName
	else
		CNDONATOR_STRING = CNDONATOR_STRING.. (CNDONATOR_STRING ~= "" and ", " or "")..cndonatorName
	end
end
cni = 0
for _, cndonatorName in pairs(CNDONATORS2) do
	cni = cni + 1
	if mod(cni, 20) == 0 then
		CNDONATOR_STRING2 = CNDONATOR_STRING2..LINE_BREAK..LINE_BREAK..cndonatorName
	else
		CNDONATOR_STRING2 = CNDONATOR_STRING2.. (CNDONATOR_STRING2 ~= "" and ", " or "")..cndonatorName
	end
end
cni = 0
for _, cndonatorName in pairs(CNDONATORS3) do
	cni = cni + 1
	if mod(cni, 20) == 0 then
		CNDONATOR_STRING3 = CNDONATOR_STRING3..LINE_BREAK..LINE_BREAK..cndonatorName
	else
		CNDONATOR_STRING3 = CNDONATOR_STRING3.. (CNDONATOR_STRING3 ~= "" and ", " or "")..cndonatorName
	end
end

E.Options.args.credits = {
	type = "group",
	name = L["Credits"],
	order = -2,
	args = {
		text = {
			order = 1,
			type = "description",
			name =
				L["ELVUI_CREDITS"] .. "\n\n" ..
				L["Coding:"] .. DEVELOPER_STRING .. "\n\n" ..
				L["Testing:"] .. TESTER_STRING .. "\n\n" ..
				L["Donations:"] .. DONATOR_STRING
		}
	}
}

if E.zhlocale then
	E.Options.args.credits2 = {
		type = "group",
		name = L['Donations:']..'2',
		order = -1,
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = '',
			},
		},
	}
	E.Options.args.credits3 = {
		type = "group",
		name = L['Donations:']..'3',
		order = -1,
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = '',
			},
		},
	}	
	E.Options.args.credits.args.text.name = '|cffC495DD'.. L['EUI_DONATOR']..'|r\n\n\n'..CNDONATOR_STRING
	E.Options.args.credits2.args.text.name = '|cffC495DD'.. L['EUI_DONATOR']..'|r\n\n\n'..CNDONATOR_STRING2
	E.Options.args.credits3.args.text.name = '|cffC495DD'.. L['EUI_DONATOR']..'|r\n\n\n'..CNDONATOR_STRING3
	E.Options.args.credits.name = L['Donations:']
end

local profileTypeItems = {
	["profile"] = L["Profile"],
	["private"] = L["Private (Character Settings)"],
	["global"] = L["Global (Account Settings)"],
	["filters"] = L["Aura Filters"],
	["styleFilters"] = L["NamePlate Style Filters"]
}
local profileTypeListOrder = {
	"profile",
	"private",
	"global",
	"filters",
	"styleFilters"
}
local exportTypeItems = {
	["text"] = L["Text"],
	["luaTable"] = L["Table"],
	["luaPlugin"] = L["Plugin"]
}
local exportTypeListOrder = {
	"text",
	"luaTable",
	"luaPlugin"
}

local exportString = ""
local function ExportImport_Open(mode)
	local Frame = E.Libs.AceGUI:Create("Frame")
	Frame:SetTitle("")
	Frame:EnableResize(false)
	Frame:SetWidth(800)
	Frame:SetHeight(600)
	Frame.frame:SetFrameStrata("FULLSCREEN_DIALOG")
	Frame:SetLayout("flow")

	local Box = E.Libs.AceGUI:Create("MultiLineEditBox")
	Box:SetNumLines(30)
	Box:DisableButton(true)
	Box:SetWidth(800)
	Box:SetLabel("")
	Frame:AddChild(Box)
	--Save original script so we can restore it later
	Box.editBox.OnTextChangedOrig = Box.editBox:GetScript("OnTextChanged")
	Box.editBox.OnCursorChangedOrig = Box.editBox:GetScript("OnCursorChanged")
	--Remove OnCursorChanged script as it causes weird behaviour with long text
	Box.editBox:SetScript("OnCursorChanged", nil)

	local Label1 = E.Libs.AceGUI:Create("Label")
	local font = GameFontHighlightSmall:GetFont()
	Label1:SetFont(font, 14)
	Label1:SetText(".") --Set temporary text so height is set correctly
	Label1:SetWidth(800)
	Frame:AddChild(Label1)

	local Label2 = E.Libs.AceGUI:Create("Label")
	font = GameFontHighlightSmall:GetFont()
	Label2:SetFont(font, 14)
	Label2:SetText(".\n.")
	Label2:SetWidth(800)
	Frame:AddChild(Label2)

	if mode == "export" then
		Frame:SetTitle('EUI'..L["Export Profile"])

		local ProfileTypeDropdown = E.Libs.AceGUI:Create("Dropdown")
		ProfileTypeDropdown:SetMultiselect(false)
		ProfileTypeDropdown:SetLabel(L["Choose What To Export"])
		ProfileTypeDropdown:SetList(profileTypeItems, profileTypeListOrder)
		ProfileTypeDropdown:SetValue("profile") --Default export
		Frame:AddChild(ProfileTypeDropdown)

		local ExportFormatDropdown = E.Libs.AceGUI:Create("Dropdown")
		ExportFormatDropdown:SetMultiselect(false)
		ExportFormatDropdown:SetLabel(L["Choose Export Format"])
		ExportFormatDropdown:SetList(exportTypeItems, exportTypeListOrder)
		ExportFormatDropdown:SetValue("text") --Default format
		ExportFormatDropdown:SetWidth(150)
		Frame:AddChild(ExportFormatDropdown)

		local exportButton = E.Libs.AceGUI:Create("Button")
		exportButton:SetText(L["Export Now"])
		exportButton:SetAutoWidth(true)
		local function OnClick(self)
			--Clear labels
			Label1:SetText("")
			Label2:SetText("")

			local profileType, exportFormat = ProfileTypeDropdown:GetValue(), ExportFormatDropdown:GetValue()
			local profileKey, profileExport = D:ExportProfile(profileType, exportFormat)
			if not profileKey or not profileExport then
				Label1:SetText(L["Error exporting profile!"])
			else
				Label1:SetText(
					format("%s: %s%s|r", L["Exported"], E.media.hexvaluecolor, profileTypeItems[profileType])
				)
				if profileType == "profile" then
					Label2:SetText(format("%s: %s%s|r", L["Profile Name"], E.media.hexvaluecolor, profileKey))
				end
			end
			Box:SetText(profileExport)
			Box.editBox:HighlightText()
			Box:SetFocus()
			exportString = profileExport
		end
		exportButton:SetCallback("OnClick", OnClick)
		Frame:AddChild(exportButton)

		--Set scripts
		Box.editBox:SetScript(
			"OnChar",
			function()
				Box:SetText(exportString)
				Box.editBox:HighlightText()
			end
		)
		Box.editBox:SetScript(
			"OnTextChanged",
			function(self, userInput)
				if userInput then
					--Prevent user from changing export string
					Box:SetText(exportString)
					Box.editBox:HighlightText()
				end
			end
		)
	elseif mode == "import" then
		Frame:SetTitle(L["Import Profile"])
		local importButton = E.Libs.AceGUI:Create("Button-ElvUI") --This version changes text color on SetDisabled
		importButton:SetDisabled(true)
		importButton:SetText(L["Import Now"])
		importButton:SetAutoWidth(true)
		importButton:SetCallback(
			"OnClick",
			function()
				--Clear labels
				Label1:SetText("")
				Label2:SetText("")

				local text
				local success = D:ImportProfile(Box:GetText())
				if success then
					text = L["Profile imported successfully!"]
				else
					text = L["Error decoding data. Import string may be corrupted!"]
				end
				Label1:SetText(text)
			end
		)
		Frame:AddChild(importButton)

		local decodeButton = E.Libs.AceGUI:Create("Button-ElvUI")
		decodeButton:SetDisabled(true)
		decodeButton:SetText(L["Decode Text"])
		decodeButton:SetAutoWidth(true)
		decodeButton:SetCallback(
			"OnClick",
			function()
				--Clear labels
				Label1:SetText("")
				Label2:SetText("")
				local decodedText
				local profileType, profileKey, profileData = D:Decode(Box:GetText())
				if profileData then
					decodedText = E:TableToLuaString(profileData)
				end
				local importText = D:CreateProfileExport(decodedText, profileType, profileKey)
				Box:SetText(importText)
			end
		)
		Frame:AddChild(decodeButton)

		local oldText = ""
		local function OnTextChanged()
			local text = Box:GetText()
			if text == "" then
				Label1:SetText("")
				Label2:SetText("")
				importButton:SetDisabled(true)
				decodeButton:SetDisabled(true)
			elseif oldText ~= text then
				local stringType = D:GetImportStringType(text)
				if stringType == "Base64" then
					decodeButton:SetDisabled(false)
				else
					decodeButton:SetDisabled(true)
				end

				local profileType, profileKey = D:Decode(text)
				if not profileType or (profileType and profileType == "profile" and not profileKey) then
					Label1:SetText(L["Error decoding data. Import string may be corrupted!"])
					Label2:SetText("")
					importButton:SetDisabled(true)
					decodeButton:SetDisabled(true)
				else
					Label1:SetText(
						format("%s: %s%s|r", L["Importing"], E.media.hexvaluecolor, profileTypeItems[profileType] or "")
					)
					if profileType == "profile" then
						Label2:SetText(format("%s: %s%s|r", L["Profile Name"], E.media.hexvaluecolor, profileKey))
					end
					importButton:SetDisabled(false)
				end

				--Scroll frame doesn't scroll to the bottom by itself, so let's do that now
				Box.scrollFrame:UpdateScrollChildRect()
				Box.scrollFrame:SetVerticalScroll(Box.scrollFrame:GetVerticalScrollRange())

				oldText = text
			end
		end

		Box.editBox:SetFocus()
		--Set scripts
		Box.editBox:SetScript("OnChar", nil)
		Box.editBox:SetScript("OnTextChanged", OnTextChanged)
	end

	Frame:SetCallback(
		"OnClose",
		function(widget)
			--Restore changed scripts
			Box.editBox:SetScript("OnChar", nil)
			Box.editBox:SetScript("OnTextChanged", Box.editBox.OnTextChangedOrig)
			Box.editBox:SetScript("OnCursorChanged", Box.editBox.OnCursorChangedOrig)
			Box.editBox.OnTextChangedOrig = nil
			Box.editBox.OnCursorChangedOrig = nil

			--Clear stored export string
			exportString = ""

			E.Libs.AceGUI:Release(widget)
			E.Libs.AceConfigDialog:Open("ElvUI")
		end
	)

	--Clear default text
	Label1:SetText("")
	Label2:SetText("")

	--Close ElvUI OptionsUI
	E.Libs.AceConfigDialog:Close("ElvUI")

	GameTooltip_Hide() --The tooltip from the Export/Import button stays on screen, so hide it
end

--Create Profiles Table
E.Options.args.profiles = E.Libs.AceDBOptions:GetOptionsTable(E.data)
E.Libs.AceConfig:RegisterOptionsTable("ElvProfiles", E.Options.args.profiles)
E.Options.args.profiles.order = -10

if not E.Options.args.profiles.plugins then
	E.Options.args.profiles.plugins = {}
end

E.Options.args.profiles.plugins.ElvUI = {
	spacer = {
		order = 89,
		type = "description",
		name = "\n\n"
	},
	desc = {
		name = L["This feature will allow you to transfer settings to other characters."],
		type = "description",
		order = 90
	},
	distributeProfile = {
		name = L["Share Current Profile"],
		desc = L["Sends your current profile to your target."],
		type = "execute",
		order = 91,
		func = function()
			if not UnitExists("target") or not UnitIsPlayer("target")
			or not UnitIsFriend("player", "target") or UnitIsUnit("player", "target") then
				E:Print(L["You must be targeting a player."])
				return
			end

			local name, server = UnitName("target")
			if name and (not server or server == "") then
				D:Distribute(name)
			elseif server then
				D:Distribute(name, true)
			end
		end
	},
	distributeGlobal = {
		name = L["Share Filters"],
		desc = L["Sends your filter settings to your target."],
		type = "execute",
		order = 92,
		func = function()
			if not UnitExists("target") or not UnitIsPlayer("target")
			or not UnitIsFriend("player", "target") or UnitIsUnit("player", "target") then
				E:Print(L["You must be targeting a player."])
				return
			end

			local name, server = UnitName("target")
			if name and (not server or server == "") then
				D:Distribute(name, false, true)
			elseif server then
				D:Distribute(name, true, true)
			end
		end
	},
	spacer2 = {
		order = 93,
		type = "description",
		name = ""
	},
	exportProfile = {
		name = L["Export Profile"],
		type = "execute",
		order = 94,
		func = function()
			ExportImport_Open("export")
		end
	},
	importProfile = {
		name = L["Import Profile"],
		type = "execute",
		order = 95,
		func = function()
			ExportImport_Open("import")
		end
	}
}

if GetAddOnEnableState(nil, "ElvUI_Config") ~= 0 then
	E:StaticPopup_Show("ELVUI_CONFIG_FOUND")
end
