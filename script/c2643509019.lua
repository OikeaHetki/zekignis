--トゥーン・ディフェンス
--Toon Defense
--zekpro
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
	--toonbd
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOON))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--damage conversion
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	--self destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(aux.NOT(s.condition))
	c:RegisterEffect(e4)
end
s.listed_names={15259703}
--twcheck
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.twcheck,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.twcheck()
	return c:IsFaceup() and c:IsCode(15259703)
end
--gybanish
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.valcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.valcon(e,re,r,rp,rc)
	if (r&REASON_BATTLE)~=0 then
		local tp=e:GetHandlerPlayer()
		local bc=rc:GetBattleTarget()
		if bc and bc:IsSetCard(0xd2) and bc:IsControler(tp)
			and Duel.GetFlagEffect(tp,id)==0 then
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
			return true
		end
	end
	return false
end
