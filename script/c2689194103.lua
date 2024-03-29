--魔轟神獣クダベ
--The Fabled Kudabbi 
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,89194103)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x35),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--Indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.indescon)
	e1:SetTarget(s.indestg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--scrying effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.cfcon)
	e3:SetOperation(s.cfop)
	c:RegisterEffect(e3)
end
s.listed_series={0x35}
function s.indescon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0
end
function s.indestg(e,c)
	return c:IsSetCard(0x35) and c~=e:GetHandler()
end
function s.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=2 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and tp==Duel.GetTurnPlayer()
end
function s.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.ConfirmCards(tp,g)
	local tc=g:GetFirst()
	local opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	if opt==1 then
		Duel.MoveSequence(tc,opt)
	end
end