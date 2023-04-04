--ネオスペーシア・ロード
--Neo Space Road
--ZekPro Version
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_names={CARD_NEOS}
function s.cfilter(c,tp)
	return c and c:IsReason(REASON_DESTROY) and c:IsLocation(LOCATION_GRAVE) 
	and c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp) and c:IsCode(CARD_NEOS)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	Duel.BreakEffect()
	Duel.Draw(tp,2,REASON_EFFECT)
end