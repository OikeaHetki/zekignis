--デスピア クリボー
--Kuridespian Tragoedian
--zek
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,40640057,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK))
end