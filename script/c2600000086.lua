--フュージョニスト#2
--Fusionist #2
--zek
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,95841282,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK))
end