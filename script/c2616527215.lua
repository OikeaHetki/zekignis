--ゲートブリッジ・ザ・ウォーターフロント・ウォービースト
--Gatebridgeo the Waterfront Warbeast
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit() 
end
