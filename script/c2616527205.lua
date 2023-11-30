--Grizzly the Red Star Beast (ZekPro)
local s,id=GetID()
function c2616527205.initial_effect(c)
	 --synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()	
end
