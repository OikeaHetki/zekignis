--砂塵の結界
--Dust Barrier
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.filter)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end
function s.efilter(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsCode(31476755)
end
function s.filter(c,e,tp)
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT) and c:IsType(TYPE_MONSTER)
end