local E, L, V, P, G = unpack(select(2, ...)) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LSM = E.Libs.LSM
local M = [[Interface\AddOns\ElvUI\Media\]]

function E:TextureString(texString, dataString)
	return '|T'..texString..(dataString or '')..'|t'
end

E.Media = {
	Fonts = {
		ActionMan = M..[[Fonts\ActionMan.ttf]],
		ContinuumMedium = M..[[Fonts\ContinuumMedium.ttf]],
		DieDieDie = M..[[Fonts\DieDieDie.ttf]],
		Expressway = M..[[Fonts\Expressway.ttf]],
		Homespun = M..[[Fonts\Homespun.ttf]],
		Invisible = M..[[Fonts\Invisible.ttf]],
		PTSansNarrow = M..[[Fonts\PTSansNarrow.ttf]]
	},
	Sounds = {
		AwwCrap = M..[[Sounds\AwwCrap.ogg]],
		BbqAss = M..[[Sounds\BbqAss.ogg]],
		DumbShit = M..[[Sounds\DumbShit.ogg]],
		HarlemShake = M..[[Sounds\HarlemShake.ogg]],
		HelloKitty = M..[[Sounds\HelloKitty.ogg]],
		MamaWeekends = M..[[Sounds\MamaWeekends.ogg]],
		RunFast = M..[[Sounds\RunFast.ogg]],
		StopRunningSlimeBall = M..[[Sounds\StopRunningSlimeBall.ogg]],
		Warning = M..[[Sounds\Warning.ogg]],
		Whisper = M..[[Sounds\Whisper.ogg]],
		YankieBangBang = M..[[Sounds\YankieBangBang.ogg]]
	},
	ChatEmojis = {
		Angry = M..[[ChatEmojis\Angry.tga]],
		Blush = M..[[ChatEmojis\Blush.tga]],
		BrokenHeart = M..[[ChatEmojis\BrokenHeart.tga]],
		CallMe = M..[[ChatEmojis\CallMe.tga]],
		Cry = M..[[ChatEmojis\Cry.tga]],
		Facepalm = M..[[ChatEmojis\Facepalm.tga]],
		Grin = M..[[ChatEmojis\Grin.tga]],
		Heart = M..[[ChatEmojis\Heart.tga]],
		HeartEyes = M..[[ChatEmojis\HeartEyes.tga]],
		Joy = M..[[ChatEmojis\Joy.tga]],
		Kappa = M..[[ChatEmojis\Kappa.tga]],
		Meaw = M..[[ChatEmojis\Meaw.tga]],
		MiddleFinger = M..[[ChatEmojis\MiddleFinger.tga]],
		Murloc = M..[[ChatEmojis\Murloc.tga]],
		OkHand = M..[[ChatEmojis\OkHand.tga]],
		OpenMouth = M..[[ChatEmojis\OpenMouth.tga]],
		Poop = M..[[ChatEmojis\Poop.tga]],
		Rage = M..[[ChatEmojis\Rage.tga]],
		SadKitty = M..[[ChatEmojis\SadKitty.tga]],
		Scream = M..[[ChatEmojis\Scream.tga]],
		ScreamCat = M..[[ChatEmojis\ScreamCat.tga]],
		SemiColon = M..[[ChatEmojis\SemiColon.tga]],
		SlightFrown = M..[[ChatEmojis\SlightFrown.tga]],
		Smile = M..[[ChatEmojis\Smile.tga]],
		Smirk = M..[[ChatEmojis\Smirk.tga]],
		Sob = M..[[ChatEmojis\Sob.tga]],
		StuckOutTongue = M..[[ChatEmojis\StuckOutTongue.tga]],
		StuckOutTongueClosedEyes = M..[[ChatEmojis\StuckOutTongueClosedEyes.tga]],
		Sunglasses = M..[[ChatEmojis\Sunglasses.tga]],
		Thinking = M..[[ChatEmojis\Thinking.tga]],
		ThumbsUp = M..[[ChatEmojis\ThumbsUp.tga]],
		Wink = M..[[ChatEmojis\Wink.tga]],
		ZZZ = M..[[ChatEmojis\ZZZ.tga]]
	},
	ChatLogos = {
		Bathrobe = M..[[ChatLogos\Bathrobe.tga]],
		ElvBlue = M..[[ChatLogos\ElvBlue.tga]],
		ElvGreen = M..[[ChatLogos\ElvGreen.tga]],
		ElvMelon = M..[[ChatLogos\ElvMelon.tga]],
		ElvOrange = M..[[ChatLogos\ElvOrange.tga]],
		ElvPink = M..[[ChatLogos\ElvPink.tga]],
		ElvPurple = M..[[ChatLogos\ElvPurple.tga]],
		ElvRainbow = M..[[ChatLogos\ElvRainbow.tga]],
		ElvRed = M..[[ChatLogos\ElvRed.tga]],
		ElvYellow = M..[[ChatLogos\ElvYellow.tga]],
		HelloKitty = M..[[ChatLogos\HelloKitty.tga]],
		Illuminati = M..[[ChatLogos\Illuminati.tga]],
		MrHankey = M..[[ChatLogos\MrHankey.tga]],
		Rainbow = M..[[ChatLogos\Rainbow.tga]],
		TyroneBiggums = M..[[ChatLogos\TyroneBiggums.tga]]
	},
	Textures = {
		Arrow = M..[[Textures\Arrow.tga]],
		ArrowRight = M..[[Textures\ArrowRight.tga]],
		ArrowUp = M..[[Textures\ArrowUp.tga]],
		BagJunkIcon = M..[[Textures\BagJunkIcon.blp]],
		BagNewItemGlow = M..[[Textures\BagNewItemGlow.tga]],
		BagQuestIcon = M..[[Textures\BagQuestIcon.tga]],
		BagUpgradeIcon = M..[[Textures\BagUpgradeIcon.tga]],
		Black8x8 = M..[[Textures\Black8x8.tga]],
		BubbleTex = M..[[Textures\BubbleTex.tga]],
		ChatEmojis = M..[[Textures\ChatEmojis]],
		ChatLogos = M..[[Textures\ChatLogos]],
		Close = M..[[Textures\Close.tga]],
		Combat = M..[[Textures\Combat.tga]],
		Copy = M..[[Textures\Copy.tga]],
		Cross = M..[[Textures\Cross.tga]],
		DPS = M..[[Textures\DPS.tga]],
		ExitVehicle = M..[[Textures\ExitVehicle.tga]],
		GlowTex = M..[[Textures\GlowTex.tga]],
		Healer = M..[[Textures\Healer.tga]],
		HelloKitty = M..[[Textures\HelloKitty.tga]],
		HelloKittyChat = M..[[Textures\HelloKittyChat.tga]],
		Highlight = M..[[Textures\Highlight.tga]],
		Leader = M..[[Textures\Leader.tga]],
		Logo = M..[[Textures\Logo.tga]],
		Mail = M..[[Textures\Mail.tga]],
		Melli = M..[[Textures\Melli.tga]],
		Minimalist = M..[[Textures\Minimalist.tga]],
		Minus = M..[[Textures\Minus.tga]],
		MinusButton = M..[[Textures\MinusButton.tga]],
		NormTex = M..[[Textures\NormTex.tga]],
		NormTex2 = M..[[Textures\NormTex2.tga]],
		Pause = M..[[Textures\Pause.tga]],
		PhaseIcons = M..[[Textures\PhaseIcons.tga]],
		Play = M..[[Textures\Play.tga]],
		Plus = M..[[Textures\Plus.tga]],
		PlusButton = M..[[Textures\PlusButton.tga]],
		Reset = M..[[Textures\Reset.tga]],
		Resting = M..[[Textures\Resting.tga]],
		Resting1 = M..[[Textures\Resting1.tga]],
		RoleIcons = M..[[Textures\RoleIcons.tga]],
		SkullIcon = M..[[Textures\SkullIcon.tga]],
		Smooth = M..[[Textures\Smooth.tga]],
		Spark = M..[[Textures\Spark.tga]],
		Tank = M..[[Textures\Tank.tga]],
		TukuiLogo = M..[[Textures\TukuiLogo.tga]],
		White8x8 = [[Interface\BUTTONS\WHITE8X8]] -- not elvui
	}
}

LSM:Register('background','ElvUI Blank',E.Media.Textures.White8x8)
LSM:Register('border','ElvUI GlowBorder',E.Media.Textures.GlowTex)
LSM:Register('font','Action Man',E.Media.Fonts.ActionMan)
LSM:Register('font','Continuum Medium',E.Media.Fonts.ContinuumMedium)
LSM:Register('font','Die Die Die!',E.Media.Fonts.DieDieDie)
LSM:Register('font','Expressway',E.Media.Fonts.Expressway,LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
LSM:Register('font','Homespun',E.Media.Fonts.Homespun,LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
LSM:Register('font','PT Sans Narrow',E.Media.Fonts.PTSansNarrow,LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
LSM:Register('sound','Awww Crap',E.Media.Sounds.AwwCrap)
LSM:Register('sound','BBQ Ass',E.Media.Sounds.BbqAss)
LSM:Register('sound','Big Yankie Devil',E.Media.Sounds.YankieBangBang)
LSM:Register('sound','Dumb Shit',E.Media.Sounds.DumbShit)
LSM:Register('sound','Mama Weekends',E.Media.Sounds.MamaWeekends)
LSM:Register('sound','Runaway Fast',E.Media.Sounds.RunFast)
LSM:Register('sound','Stop Running',E.Media.Sounds.StopRunningSlimeBall)
LSM:Register('sound','Warning',E.Media.Sounds.Warning)
LSM:Register('sound','Whisper Alert',E.Media.Sounds.Whisper)
LSM:Register('statusbar','ElvUI Blank',E.Media.Textures.White8x8)
LSM:Register('statusbar','ElvUI Gloss',E.Media.Textures.NormTex)
LSM:Register('statusbar','ElvUI Norm',E.Media.Textures.NormTex2)
LSM:Register('statusbar','Melli',E.Media.Textures.Melli)
LSM:Register('statusbar','Minimalist',E.Media.Textures.Minimalist)

LSM:Register("statusbar","Eui_0", [[Interface\AddOns\ElvUI\media\textures\statusbar\0.tga]])
LSM:Register("statusbar","Eui_1", [[Interface\AddOns\ElvUI\media\textures\statusbar\1.tga]])
LSM:Register("statusbar","Eui_2", [[Interface\AddOns\ElvUI\media\textures\statusbar\2.tga]])
LSM:Register("statusbar","Eui_3", [[Interface\AddOns\ElvUI\media\textures\statusbar\3.tga]])
LSM:Register("statusbar","Eui_4", [[Interface\AddOns\ElvUI\media\textures\statusbar\4.tga]])
LSM:Register("statusbar","Eui_5", [[Interface\AddOns\ElvUI\media\textures\statusbar\5.tga]])
LSM:Register("statusbar","Eui_6", [[Interface\AddOns\ElvUI\media\textures\statusbar\6.tga]])
LSM:Register("statusbar","Eui_7", [[Interface\AddOns\ElvUI\media\textures\statusbar\7.tga]])
LSM:Register("statusbar","Eui_8", [[Interface\AddOns\ElvUI\media\textures\statusbar\8.tga]])
LSM:Register("statusbar","Eui_9", [[Interface\AddOns\ElvUI\media\textures\statusbar\9.tga]])
LSM:Register("statusbar","Eui_10", [[Interface\AddOns\ElvUI\media\textures\statusbar\10.tga]])
LSM:Register("statusbar","Eui_11", [[Interface\AddOns\ElvUI\media\textures\statusbar\11.tga]])
LSM:Register("statusbar","Line", [[Interface\AddOns\ElvUI\media\textures\statusbar\line.tga]])
LSM:Register("statusbar","Glaze", [[Interface\AddOns\ElvUI\media\textures\statusbar\glaze.tga]])

LSM:Register("statusbar","MaUI 1", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI1.tga]])
LSM:Register("statusbar","MaUI 2", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI2.tga]])
LSM:Register("statusbar","MaUI 3", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI3.tga]])
LSM:Register("statusbar","MaUI 4", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI4.tga]])
LSM:Register("statusbar","MaUI 5", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI5.tga]])
LSM:Register("statusbar","MaUI 6", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI6.tga]])
LSM:Register("statusbar","MaUI 7", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI7.tga]])
LSM:Register("statusbar","MaUI 8", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI8.tga]])
LSM:Register("statusbar","MaUI 9", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI9.tga]])
LSM:Register("statusbar","MaUI 10", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI10.tga]])
LSM:Register("statusbar","MaUI 11", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI11.tga]])
LSM:Register("statusbar","MaUI 12", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI12.tga]])
LSM:Register("statusbar","MaUI 13", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI13.tga]])
LSM:Register("statusbar","MaUI 14", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI14.tga]])
LSM:Register("statusbar","MaUI 15", [[Interface\AddOns\ElvUI\media\textures\newstatusbar\MaUI15.tga]])

LSM:Register("statusbar", "MaoRSkada", [[Interface\Addons\ElvUI\media\textures\newstatusbar\MaoRSkada]])
LSM:Register("statusbar", "AtlzSkada", [[Interface\Addons\ElvUI\media\textures\newstatusbar\AtlzSkada]])
LSM:Register("statusbar", "YaSkada", [[Interface\Addons\ElvUI\media\textures\newstatusbar\Yaskada]])
LSM:Register("statusbar", "YaSkada02", [[Interface\Addons\ElvUI\media\textures\newstatusbar\Yaskada02]])
LSM:Register("statusbar", "YaSkada03", [[Interface\Addons\ElvUI\media\textures\newstatusbar\Yaskada03]])
LSM:Register("statusbar", "YaSkada04", [[Interface\Addons\ElvUI\media\textures\newstatusbar\Yaskada04]])
LSM:Register("statusbar", "YaSkada05", [[Interface\Addons\ElvUI\media\textures\newstatusbar\Yaskada05]])
LSM:Register("statusbar", "elvskada", [[Interface\Addons\ElvUI\media\textures\newstatusbar\elvskada]])
LSM:Register("statusbar", "elvskada2", [[Interface\Addons\ElvUI\media\textures\newstatusbar\elvskada2]])