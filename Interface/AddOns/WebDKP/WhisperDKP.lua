------------------------------------------------------------------------
-- WHISPER DKP
------------------------------------------------------------------------
-- This file contains methods related to WhisperDKP functionality. 
------------------------------------------------------------------------

-- A reference to the original chat frame event hook (the one that we will replace)
-- Used to disguise our whisper messages
local WebDKP_ChatFrame_OnEvent_Original = nil;

-- ================================
-- Places a hook on incoming whispers to the chat message box. 
-- We can use this to disguise our whisper messages
-- ================================
function WebDKP_Register_WhisperHook()
    --hooksecurefunc("ChatFrame_OnEvent",WebDKP_ChatFrame_OnEvent_Hook);
    if (ChatFrame_OnEvent ~= WebDKP_ChatFrame_OnEvent_Hook) then
        -- hook the chatframe onevent to allow us to hide the queue requrests if we want
        WebDKP_ChatFrame_OnEvent_Original = ChatFrame_OnEvent;
        ChatFrame_OnEvent = WebDKP_ChatFrame_OnEvent_Hook;
    end
end


-- ================================
-- Event handler for regular chat whisper messages
-- Responds to the players whisper with a whisper telling
-- them their current dkp. 
-- ================================
function WebDKP_WhisperDKP_Event(arg1, arg2)
    local tableid = WebDKP_GetTableid();
    local name = arg2;
    local trigger = arg1;
--    WebDKP_Print(string.format("WebDKP_WhisperDKP_Event %s %s",arg1,arg2))
    if (WebDKP_IsWebDKPWhisper(name, trigger)) then
        -- its a valid whisper for us. Now to determine what type of whisper
        if (string.find(string.lower(trigger), "mydkp") == 1) then
            -- THEY WANT THEIR DKP
            -- look up this player in our dkp table and see if we can find their information
            local main = WebDKP_GetMain(name, true);
            if (WebDKP_DkpTable[main] == nil) then
                -- not in our system, send them message
                WebDKP_SendWhisper(name, "你没有DKP,查不到你的DKP历史记录");
            else
                -- they are in the table, get them their dkp
                local dkp = WebDKP_GetDKP(main, tableid);
                local tier = floor((dkp - 1) / WebDKP_TierInterval);
                if (dkp == 0) then
                    tier = 0;
                end
                WebDKP_SendWhisper(name, "当前DKP: " .. dkp);
                --WebDKP_SendWhisper(name, "Tier : " .. tier);
            end
        elseif (string.find(string.lower(trigger), "查询") == 1) then
            -- THEY WANT THE DKP OF PEOPLE IN THE CURRENT GROUP
            local filter = WebDKP_GetWhisperFiltersFromMessage(trigger);
            --WebDKP_SendWhisper(name, "DKP 列表");
            WebDKP_SendWhisper(name, "DKP :(职业) ");
            WebDKP_SendWhisper(name, "==============================");
            WebDKP_WhisperSortedList(name, true, filter);
        elseif (trigger == "!help") then
            -- THEY WANT HELP / LIST OF COMMANDS
            WebDKP_SendWhisper(name, "可用命令:");
            WebDKP_SendWhisper(name, "mydkp - 获取你的当前dkp");
            WebDKP_SendWhisper(name, "查询 - 组中的dkp列表");
            --DLL Removed WebDKP_SendWhisper(name,"!listall - List dkp of guild (BIG)");
            WebDKP_SendWhisper(name, "!help - This menu");
            WebDKP_SendWhisper(name, "通过在‘查询’后面附加职业名来限制列表");
            WebDKP_SendWhisper(name, "如: '查询 LR' 只列出猎人的DKP");
            WebDKP_SendWhisper(name, "如: '查询 LR QS' 只列出LR和QS的DKP");
        elseif (trigger == "我要替补") then
            -- They want to be added as standby
            WebDKP_Standby_GUIToggle("add", name)
        elseif (trigger == "退出替补") then
            -- THEY WANT HELP / LIST OF COMMANDS
            WebDKP_Standby_GUIToggle("remove", name)
        elseif (trigger == "出勤") then
            -- They want their attendance info
            if WebDKP_CharRaidInfo[name] ~= nil then
                local total_raids = WebDKP_CharRaidInfo[name]["total_raids"];
                local attended_raids = WebDKP_CharRaidInfo[name]["raids_attended"];
                local percent = WebDKP_CharRaidInfo[name]["percent"];
                WebDKP_SendWhisper(name, "你出勤过 : " .. attended_raids .. "次团本,总计: " .. total_raids .. " 次团本. 你的出勤百分比是 " .. percent .. " %");
            else
                WebDKP_SendWhisper(name, "你当前没有参与过团队/团本");
            end

        end
    end
end

-- ================================
-- Our special event hook that picks up on all whispers 
-- Before they are displayed on the screen or trigger the 
-- regular whisper. Here we can hide any whispers that our
-- ours. 
-- ================================
function WebDKP_ChatFrame_OnEvent_Hook(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13)
    -- if ( arg1 and arg2 ) then
    -- whisper too me
    if (event == "CHAT_MSG_WHISPER") then
        if (WebDKP_IsWebDKPWhisper(arg2, arg1)) then
            -- don't display whispercast whisper
            return
        end
    end
    -- whisper I am sending
    if (event == "CHAT_MSG_WHISPER_INFORM") then
        if (string.find(arg1, "^WebDKP: ") or
                string.find(arg1, "!Sending")
        ) then
            -- hide whispers that I am sending
            return
        end
    end
    if (event == "CHAT_MSG_WHISPER_INFORM") then
        if (string.find(arg1, "^WebDKP: ") or
                string.find(arg1, "!SendingAuto")
        ) then
            -- hide whispers that I am sending
            return
        end
    end
    -- end 
    WebDKP_ChatFrame_OnEvent_Original(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13)

end

-- ================================
-- Returns true if the passed whisper is a whisper directed
-- towards web dkp
-- ================================
function WebDKP_IsWebDKPWhisper(name, trigger)
    -- if it has webdkp in it, its an outgoing message. ignore it

    if (string.find(string.lower(trigger), "WebDKP:")) then
        return false;
    end
    if (string.find(string.lower(trigger), "mydkp") == 1 or
            string.find(string.lower(trigger), "出勤") == 1 or
            string.find(string.lower(trigger), "!help") == 1 or
            string.find(string.lower(trigger), "查询") == 1 or
            string.find(string.lower(trigger), "我要替补") == 1 or
            string.find(string.lower(trigger), "退出替补") == 1 or
            string.find(trigger, "!Sending") == 1 or
            string.find(trigger, "!SendingAuto") == 1
    ) then
        return true
    end

    return false
end




-- ================================
-- Helper method for the whisper features. 
-- Sends the player a list of dkp for people either in the current
-- group or in the guild
-- ================================
function WebDKP_WhisperSortedList(toPlayer, limitToGroup, classFilter)
    local tableid = WebDKP_GetTableid();
    if (classFilter == nil) then
        classFilter = {};
    end
    -- increment through the dkp table and move data over
    local tableToWhisper = {};
    for k, v in pairs(WebDKP_DkpTable) do
        if (type(v) == "table") then
            local playerName = k;
            local playerClass = v["class"];
            local playerDkp = WebDKP_GetDKP(playerName, tableid);
            if (playerDkp ~= nil) then
                local playerTier = floor((playerDkp - 1) / WebDKP_TierInterval);
                if (playerDkp == 0) then
                    playerTier = 0;
                end
                -- if it should be displayed (passes filter) add it to the table
                if (WebDKP_PassesWhisperFilter(playerName, playerClass, playerDkp, playerTier, limitToGroup, classFilter)) then
                    tinsert(tableToWhisper, { playerName, playerClass, playerDkp, playerTier });
                end
            end
        end
    end
    -- we now have our table to whisper
    -- sort it
    table.sort(
            tableToWhisper,
            function(a1, a2)
                if (a1 and a2) then
                    if (a1[3] == a2[3]) then
                        return a1[1] >= a2[1];
                    else
                        return a1[3] <= a2[3];
                    end
                end
            end
    );

    -- display it
    for k, v in pairs(tableToWhisper) do
        if (type(v) == "table") then
            if (v[1] ~= nil and v[2] ~= nil and v[3] ~= nil) then
                WebDKP_SendWhisper(toPlayer, v[3] .. " : Tier " .. v[4] .. " " .. v[1] .. " ( " .. v[2] .. " ) ");
            end
        end
    end
end

-- ================================
-- Checks to see if a given entry passes a set of whisper filters
-- ================================
function WebDKP_PassesWhisperFilter(name, class, dkp, tier, limitToGroup, filter)
    class = WebDKP.translations.CLASS_LOCALIZED_TO_ENG_MAP[class]
    -- check the limit to group
    if (limitToGroup) then
        if (not WebDKP_PlayerInGroup(name)) then
            return false;
        end
    end
    -- now check the filters
    if (filter["showall"]) then
        return true;
    else
        -- return true if the class entry is not equal to nil, meaning it should be displayed
        if (class == nil) then
            return false;
        end
        return (not (filter[string.lower(class)] == nil));
    end


end

-- ================================
-- Scans a whisper message to determine what filters are being used. 
-- Returns a filter object that can be passed to WebDKP_WhisperSortedList
-- ================================
function WebDKP_GetWhisperFiltersFromMessage(message)
    local filter = {};
    filter["druid"] = string.find(string.lower(message), "druid");
    filter["hunter"] = string.find(string.lower(message), "hunter");
    filter["mage"] = string.find(string.lower(message), "mage");
    filter["rogue"] = string.find(string.lower(message), "rogue");
    filter["shaman"] = string.find(string.lower(message), "shaman");
    filter["paladin"] = string.find(string.lower(message), "paladin");
    filter["priest"] = string.find(string.lower(message), "priest");
    filter["warrior"] = string.find(string.lower(message), "warrior");
    filter["warlock"] = string.find(string.lower(message), "warlock");
    filter["death knight"] = string.find(string.lower(message), "death knight");

--localized alias check
    if table.getn(filter) == 0 then
        local findAliasKeyWord
        for k, v in pairs(WebDKP.translations.CLASS_ALIAS_TO_ENG_MAP) do
            findAliasKeyWord = string.find(string.upper(message) , " "..k)
            if findAliasKeyWord ~= nil then
                filter[v] = findAliasKeyWord
            end
        end
    end

--localized name check
    if table.getn(filter) == 0 then
        local findLocalizedWord
        for k, v in pairs(WebDKP.translations.CLASS_LOCALIZED_TO_ENG_MAP) do
            findLocalizedWord = string.find(string.upper(message) , " "..k)
            if findLocalizedWord ~= nil then
                filter[string.lower(v)] = findLocalizedWord
            end
        end
    end


--    for k, v in pairs(filter) do
--        WebDKP_Print(string.format("filter %s %d",k,v))
--    end


    -- If no filters were passed, everything should be nill. In that case
    -- just display everyone
    if (filter["druid"] == nil and filter["hunter"] == nil and filter["mage"] == nil and
            filter["rogue"] == nil and filter["shaman"] == nil and filter["paladin"] == nil and
            filter["priest"] == nil and filter["warrior"] == nil and filter["warlock"] == nil and filter["death knight"] == nil) then
        filter["showall"] = true;
    else
        filter["showall"] = false;
    end
    return filter;
end