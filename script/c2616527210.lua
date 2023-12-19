--ミストバレーのアマツ
--Amatsu of Mist Valley
--zekpro version
local s,id=GetID()
function c2616527210.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()  
end
