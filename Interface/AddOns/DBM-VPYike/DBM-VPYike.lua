﻿local frame= CreateFrame("Frame")frame:SetScript("OnEvent", function(f, e, ...)if DBM == nil  then return endDBM.Options.ChosenVoicePack = "Yike"			--DBM语音包选择end)frame:RegisterEvent("PLAYER_ENTERING_WORLD")