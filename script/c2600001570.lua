--ゼプトロン
--Zeptron
--zek
local s,id=GetID()
function s.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE))
	--Atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(700)
	c:RegisterEffect(e1)
	--double tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e2:SetValue(s.condition)
	c:RegisterEffect(e2)
end
function s.condition(e,c)
	return c:IsRace(RACE_CYBERSE)
end