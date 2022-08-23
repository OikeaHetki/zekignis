--Shelga, the Atlantean Warprince (ZekPro)
function c2616527215.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit() 
end
