--軍神テュール
--Tyr, the Vanquishing Warlord
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.FilterBoolFunctionEx(Card.IsRace,RACE_FAIRY),aux.FilterBoolFunctionEx(Card.IsRace,RACE_WARRIOR))
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.sumsuc)
	c:RegisterEffect(e3)
	--Can attack all opponent monsters once each
	--local e4=Effect.CreateEffect(c)
	--e4:SetType(EFFECT_TYPE_SINGLE)
	--e4:SetCode(EFFECT_ATTACK_ALL)
	--e4:SetValue(1)
	--c:RegisterEffect(e4)
	--DAMAGE
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetCondition(s.condition)
	e5:SetOperation(s.operation)
	c:RegisterEffect(e5)   
end
function s.condition(e)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,0)
end
function s.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(s.chlimit1)
end
function s.chlimit1(re,rp,tp)
	return not re:GetHandler():IsTrap() or not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end