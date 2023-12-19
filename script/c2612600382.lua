--エクゾディア・ネクロス
--Exodia Necross
--zekpro version (Ritual Monster, better effect)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--cannot destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.neccon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.neccon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.neccon)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end
s.listed_series={0x40,0xde}
--necross gy condition
function s.necfilter(c)
	return (c:IsSetCard(0x40) or c:IsSetCard(0xde)) and c:IsMonster()
end
function s.neccon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.necfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,nil,0)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>4
end
--necross atkup
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
end