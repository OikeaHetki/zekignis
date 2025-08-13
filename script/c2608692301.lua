--ジェムナイト・ジルコニア
--Gem-Knight Zirconia
--zekpro version (re-statted)
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0x1047),aux.FilterBoolFunctionEx(Card.IsType,TYPE_NORMAL))
end
s.material_setcode={0x47,0x1047}
