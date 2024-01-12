--左京、シークレット・シックス・サムライ・ソードマスター
--Sakyo, Secret Six Samurai Swordmaster
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
end
