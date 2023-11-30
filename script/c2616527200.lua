--Khimaera the King of Beasts (ZekPro)
local s,id=GetID()
function c2616527200.initial_effect(c)
	 --synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
end
