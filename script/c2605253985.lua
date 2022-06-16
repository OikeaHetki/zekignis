--Power of the Sky Dragon
--ZekPro
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_HAND_LIMIT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(100)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.drcon1)
	e3:SetOperation(s.drop1)
	c.RegisterEffect(e3)
end
s.listed_names={10000020}
---condition
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(10000020) and c:IsOriginalAttribute(ATTRIBUTE_DIVINE)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
---each time, draw
function s.cfilter1(c)
	return c:IsFaceup() and c:IsCode(10000020)
end
function s.filter(c,sp)
	return c:GetSummonPlayer()==sp
end
function s.drcon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return eg:IsExists(s.filter,1,nil,1-tp) 
	and Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_ONFIELD,0,
end
function s.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end