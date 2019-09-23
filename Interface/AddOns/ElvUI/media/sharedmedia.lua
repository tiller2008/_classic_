local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
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
		ElvRainbow = M..[[ChatLogos\ElvRainbow.tga]],
		ElvMelon = M..[[ChatLogos\ElvMelon.tga]],
		ElvBlue = M..[[ChatLogos\ElvBlue.tga]],
		ElvGreen = M..[[ChatLogos\ElvGreen.tga]],
		ElvOrange = M..[[ChatLogos\ElvOrange.tga]],
		ElvPink = M..[[ChatLogos\ElvPink.tga]],
		ElvPurple = M..[[ChatLogos\ElvPurple.tga]],
		ElvYellow = M..[[ChatLogos\ElvYellow.tga]],
		ElvRed = M..[[ChatLogos\ElvRed.tga]],
		Bathrobe = M..[[ChatLogos\Bathrobe.tga]],
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
		BagNewItemGlow = M..[[Textures\BagNewItemGlow.tga]],
		BagQuestIcon = M..[[Textures\BagQuestIcon.tga]],
		Black8x8 = M..[[Textures\Black8x8.tga]],
		White8x8 = [[Interface\BUTTONS\WHITE8X8]], -- not elvui
		BagUpgradeIcon = M..[[Textures\BagUpgradeIcon.tga]],
		BubbleTex = M..[[Textures\BubbleTex.tga]],
		ChatEmojis = M..[[Textures\ChatEmojis]],
		ChatLogos = M..[[Textures\ChatLogos]],
		Close = M..[[Textures\Close.tga]],
		Combat = M..[[Textures\Combat.tga]],
		Copy = M..[[Textures\Copy.tga]],
		Cross = M..[[Textures\Cross.tga]],
		DPS = M..[[Textures\DPS.tga]],
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
		ExitVehicle = M..[[Textures\ExitVehicle.tga]]
	}
}

LSM:Register('border','ElvUI GlowBorder',E.Media.Textures.GlowTex)
LSM:Register('font','Continuum Medium',E.Media.Fonts.ContinuumMedium)
LSM:Register('font','Die Die Die!',E.Media.Fonts.DieDieDie)
LSM:Register('font','Action Man',E.Media.Fonts.ActionMan)
LSM:Register('font','Expressway',E.Media.Fonts.Expressway,LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
LSM:Register('font','PT Sans Narrow',E.Media.Fonts.PTSansNarrow,LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
LSM:Register('font','Homespun',E.Media.Fonts.Homespun,LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
LSM:Register('sound','Awww Crap',E.Media.Sounds.AwwCrap)
LSM:Register('sound','BBQ Ass',E.Media.Sounds.BbqAss)
LSM:Register('sound','Big Yankie Devil',E.Media.Sounds.YankieBangBang)
LSM:Register('sound','Dumb Shit',E.Media.Sounds.DumbShit)
LSM:Register('sound','Mama Weekends',E.Media.Sounds.MamaWeekends)
LSM:Register('sound','Runaway Fast',E.Media.Sounds.RunFast)
LSM:Register('sound','Stop Running',E.Media.Sounds.StopRunningSlimeBall)
LSM:Register('sound','Warning',E.Media.Sounds.Warning)
LSM:Register('sound','Whisper Alert',E.Media.Sounds.Whisper)
LSM:Register('statusbar','Melli',E.Media.Textures.Melli)
LSM:Register('statusbar','ElvUI Gloss',E.Media.Textures.NormTex)
LSM:Register('statusbar','ElvUI Norm',E.Media.Textures.NormTex2)
LSM:Register('statusbar','Minimalist',E.Media.Textures.Minimalist)
LSM:Register('statusbar','ElvUI Blank',E.Media.Textures.White8x8)
LSM:Register('background','ElvUI Blank',E.Media.Textures.White8x8)

LSM:Register("statusbar","Eui_0", [[Interface\AddOns\ElvUI\media\textures\statusbar\0]])
LSM:Register("statusbar","Eui_1", [[Interface\AddOns\ElvUI\media\textures\statusbar\1]])
LSM:Register("statusbar","Eui_2", [[Interface\AddOns\ElvUI\media\textures\statusbar\2]])
LSM:Register("statusbar","Eui_3", [[Interface\AddOns\ElvUI\media\textures\statusbar\3]])
LSM:Register("statusbar","Eui_4", [[Interface\AddOns\ElvUI\media\textures\statusbar\4]])
LSM:Register("statusbar","Eui_5", [[Interface\AddOns\ElvUI\media\textures\statusbar\5]])
LSM:Register("statusbar","Eui_6", [[Interface\AddOns\ElvUI\media\textures\statusbar\6]])
LSM:Register("statusbar","Eui_7", [[Interface\AddOns\ElvUI\media\textures\statusbar\7]])
LSM:Register("statusbar","Eui_8", [[Interface\AddOns\ElvUI\media\textures\statusbar\8]])
LSM:Register("statusbar","Eui_9", [[Interface\AddOns\ElvUI\media\textures\statusbar\9]])
LSM:Register("statusbar","Eui_10", [[Interface\AddOns\ElvUI\media\textures\statusbar\10]])
LSM:Register("statusbar","Eui_11", [[Interface\AddOns\ElvUI\media\textures\statusbar\11]])
LSM:Register("statusbar","Line", [[Interface\AddOns\ElvUI\media\textures\statusbar\line]])
LSM:Register("statusbar","Glaze", [[Interface\AddOns\ElvUI\media\textures\statusbar\glaze]])


-- Statusbar Textures 
LSM:Register("statusbar", "KMT01", [[Interface\Addons\ElvUI\media\KMediaTags\KMT01.tga]]) 
LSM:Register("statusbar", "KMT02", [[Interface\Addons\ElvUI\media\KMediaTags\KMT02.tga]]) 
LSM:Register("statusbar", "KMT03", [[Interface\Addons\ElvUI\media\KMediaTags\KMT03.tga]]) 
LSM:Register("statusbar", "KMT04", [[Interface\Addons\ElvUI\media\KMediaTags\KMT04.tga]]) 
LSM:Register("statusbar", "KMT05", [[Interface\Addons\ElvUI\media\KMediaTags\KMT05.tga]]) 
LSM:Register("statusbar", "KMT06", [[Interface\Addons\ElvUI\media\KMediaTags\KMT06.tga]]) 
LSM:Register("statusbar", "KMT07", [[Interface\Addons\ElvUI\media\KMediaTags\KMT07.tga]]) 
LSM:Register("statusbar", "KMT08", [[Interface\Addons\ElvUI\media\KMediaTags\KMT08.tga]]) 
LSM:Register("statusbar", "KMT09", [[Interface\Addons\ElvUI\media\KMediaTags\KMT09.tga]]) 
LSM:Register("statusbar", "KMT10", [[Interface\Addons\ElvUI\media\KMediaTags\KMT10.tga]]) 
LSM:Register("statusbar", "KMT11", [[Interface\Addons\ElvUI\media\KMediaTags\KMT11.tga]]) 
LSM:Register("statusbar", "KMT12", [[Interface\Addons\ElvUI\media\KMediaTags\KMT12.tga]]) 
LSM:Register("statusbar", "KMT13", [[Interface\Addons\ElvUI\media\KMediaTags\KMT13.tga]]) 
LSM:Register("statusbar", "KMT14", [[Interface\Addons\ElvUI\media\KMediaTags\KMT14.tga]]) 
LSM:Register("statusbar", "KMT15", [[Interface\Addons\ElvUI\media\KMediaTags\KMT15.tga]]) 
LSM:Register("statusbar", "KMT16", [[Interface\Addons\ElvUI\media\KMediaTags\KMT16.tga]]) 
LSM:Register("statusbar", "KMT17", [[Interface\Addons\ElvUI\media\KMediaTags\KMT17.tga]]) 
LSM:Register("statusbar", "KMT18", [[Interface\Addons\ElvUI\media\KMediaTags\KMT18.tga]]) 
LSM:Register("statusbar", "KMT19", [[Interface\Addons\ElvUI\media\KMediaTags\KMT19.tga]]) 
LSM:Register("statusbar", "KMT20", [[Interface\Addons\ElvUI\media\KMediaTags\KMT20.tga]]) 
LSM:Register("statusbar", "KMT21", [[Interface\Addons\ElvUI\media\KMediaTags\KMT21.tga]]) 
LSM:Register("statusbar", "KMT22", [[Interface\Addons\ElvUI\media\KMediaTags\KMT22.tga]]) 
LSM:Register("statusbar", "KMT23", [[Interface\Addons\ElvUI\media\KMediaTags\KMT23.tga]]) 
LSM:Register("statusbar", "KMT24", [[Interface\Addons\ElvUI\media\KMediaTags\KMT24.tga]]) 
LSM:Register("statusbar", "KMT25", [[Interface\Addons\ElvUI\media\KMediaTags\KMT25.tga]]) 
LSM:Register("statusbar", "KMT26", [[Interface\Addons\ElvUI\media\KMediaTags\KMT26.tga]]) 
LSM:Register("statusbar", "KMT27", [[Interface\Addons\ElvUI\media\KMediaTags\KMT27.tga]]) 
LSM:Register("statusbar", "KMT28", [[Interface\Addons\ElvUI\media\KMediaTags\KMT28.tga]]) 
LSM:Register("statusbar", "KMT29", [[Interface\Addons\ElvUI\media\KMediaTags\KMT29.tga]]) 
LSM:Register("statusbar", "KMT30", [[Interface\Addons\ElvUI\media\KMediaTags\KMT30.tga]]) 
LSM:Register("statusbar", "KMT31", [[Interface\Addons\ElvUI\media\KMediaTags\KMT31.tga]]) 
