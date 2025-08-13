--羅ら阿あ邪じゃ神しん将しょうアギバ
--Aggiba, the Malevolent Sh'nn S'yo
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	 --synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
end