--衰弱の霧
--Enervating Mists
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_HAND_LIMIT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Cannot set "Graceful Charity"
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_SSET)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(function(_,c)return c:IsCode(79571449)end)
	c:RegisterEffect(e3)
	--Cannot activate "Graceful Charity"
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(0,1)
	e4:SetValue(function(_,re)return re:GetHandler():IsCode(79571449)end)
	c:RegisterEffect(e4)
end
s.listed_names={79571449}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end