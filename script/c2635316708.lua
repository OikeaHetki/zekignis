--刻の封印
--Time Seal
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_M1)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==1-tp then
		e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_OPPO_TURN)
	end
	Duel.RegisterEffect(e1,tp)
end
