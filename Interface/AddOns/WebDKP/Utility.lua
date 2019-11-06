﻿function WebDKP_GetTableid()local a=WebDKP_Frame.selectedTableid;if a==nil then a=1 end;return a end;function WebDKP_PlayerInGroup(name)for b,c in pairs(WebDKP_PlayersInGroup)do if type(c)=="table"then if c["name"]==name then return true end end end;return false end;function WebDKP_GetGuildName(d)local e=GetNumGroupMembers()local name,f;for g=1,e do name,_,_,_,_,_,_,_,_=GetRaidRosterInfo(g)if name==d then guild,_,_=GetGuildInfo("raid"..g)return guild end end;local h=GetNumSubgroupMembers()for g=1,h do playerHandle="party"..g;name=UnitName(playerHandle)if name==d then guild,_,_=GetGuildInfo("raid"..g)return guild end end;if d==UnitName("player")then guild,_,_=GetGuildInfo("player")return guild end;return"Unknown"end;function WebDKP_GetFirstSelectedPlayer()for i,j in pairs(WebDKP_DkpTable)do if type(j)=="table"then if j["Selected"]then name=i;return name end end end;return"NONE"end;function WebDKP_GetTableSize(k)local l=0;if k==nil then return l end;for b,c in pairs(k)do l=l+1 end;return l end;function WebDKP_Print(m)DEFAULT_CHAT_FRAME:AddMessage(m,1,1,0)end;function WebDKP_GetItemInfo(n)local o,p,q,r,s,t,u,v,w,x=GetItemInfo(n)if q and o and p then return q,o,p,r,w else return 0,n,n end end;function WebDKP_ShouldIgnoreItem(o)for b,value in pairs(WebDKP_IgnoreItems)do if o==value then return true end end;return false end;function WebDKP_SelectPlayerOnly(y)for i,j in pairs(WebDKP_DkpTable)do if type(j)=="table"then local d=i;if d==y then WebDKP_DkpTable[d]["Selected"]=true else WebDKP_DkpTable[d]["Selected"]=false end end end;if WebDKP_PlayerIsShown(y)==0 then WebDKP_ShowPlayer(y)end;WebDKP_UpdateTable()end;function WebDKP_PlayerIsShown(d)for i,j in pairs(WebDKP_DkpTableToShow)do if type(j)=="table"then local z=j[1]if z==d then return 1 end end end;return 0 end;function WebDKP_ShowPlayer(d)if WebDKP_DkpTable[d]==nil then return end;local a=WebDKP_GetTableid()local A=WebDKP_DkpTable[d]["class"]local B=WebDKP_DkpTable[d]["dkp_"..a]if B==nil then B=0 end;local C=floor((B-1)/WebDKP_TierInterval)if B==0 then C=0 end;tinsert(WebDKP_DkpTableToShow,{d,A,B,C})end;function WebDKP_ROUND(D,E)return tonumber(string.format("%."..E.."f",D))end;function WebDKP_PlayerHasDKP(d)local F,a;if WebDKP_Tables~=nil and next(WebDKP_Tables)~=nil then for b,c in pairs(WebDKP_Tables)do if type(c)=="table"then a=c["id"]F=WebDKP_GetDKP(d,a)if F~=0 then return true end end end else F=WebDKP_GetDKP(d)if F~=0 then return true end end;return false end;function WebDKP_GetDKP(d,a,G,f)if d==nil then return 0 end;if a==nil then a=WebDKP_GetTableid()end;local H;local I;if WebDKP_Alts[d]~=nil and WebDKP_WebOptions["CombineAlts"]==1 then I=d;H=WebDKP_Alts[d]if G~=nil then WebDKP_MakeSureInTable(I,a,f)WebDKP_MakeSureInTable(H,a)end else H=d;if G~=nil then WebDKP_MakeSureInTable(H,a,f)end end;local J;if WebDKP_DkpTable[H]==nil then J=0 elseif WebDKP_DkpTable[H]["dkp_"..a]==nil then J=0 else J=WebDKP_DkpTable[H]["dkp_"..a]end;return J end;function WebDKP_MakeSureInTable(d,a,f,F)if d==nil then return end;if F==nil then F=0 end;if WebDKP_DkpTable[d]==nil then if f==nil then f="Unknown"end;WebDKP_DkpTable[d]={["dkp_"..a]=F,["class"]=f,["cantrim"]=true}end;if WebDKP_DkpTable[d]["dkp_"..a]==nil then WebDKP_DkpTable[d]["dkp_"..a]=0 end end;function WebDKP_GetMain(d,K)local H;if WebDKP_Alts[d]~=nil then H=WebDKP_Alts[d]if K~=nil and WebDKP_WebOptions["CombineAlts"]==0 then H=d end else H=d end;return H end;function WebDKP_GetPlayerClass(d)local A=WebDKP_DkpTable[d]["class"]if WebDKP_DkpTable[d]==nil then A="Druid"end;return A end;function WebDKP_GetCmd(L)if L then local M,N,O=strfind(L,"(%S+)")if M then return O,strsub(L,N+2)else return""end end end;function WebDKP_GetCommaCmd(L)if L then local M=strfind(L,",")if M then local P=strtrim(strsub(L,0,M-1))local Q=strtrim(strsub(L,M+1))return P,Q else return L end end end;function WebDKP_SendWhisper(R,S)SendChatMessage("WebDKP: "..S,"WHISPER",nil,R)end;function WebDKP_GetLootTableCost(T)local J=nil;local U,o,T,r,w=WebDKP_GetItemInfo(T)local value=WebDKP_GetItemID(T)if WebDKP_Loot~=nil then J=WebDKP_Loot[o]if WebDKP_Loot[o]==nil then J=WebDKP_Loot[value]end end;if J==nil or J==""then r=tostring(r)J=WebDKP_Loot[r]end;if J==nil or J==""then J=nil end;return J end;function WebDKP_GetItemID(T)local J=nil;if T~=nil and T~=""then local V="%|(.+)%|(%a+):(%d+):(.+)"_,_,hexvalue,itemtype,value,holder,_,test2=string.find(T,V)end;if value~=""and value~=nil then J=value end;return J end;function WebDKP_GetOptionValue(W,X)local value;if WebDKP_Options[W]~=nil then value=WebDKP_Options[W]elseif WebDKP_WebOptions[W]~=nil then value=WebDKP_WebOptions[W]else value=X;WebDKP_Options[W]=X end;return value end
