--Pot of Cupidity
--zekpro
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.chainfilter(re,tp,cid)
	if Duel.GetFlagEffect(tp,id)==0 then return true end
	return not re:IsActiveType(TYPE_SPELL)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.SetLP(p-1,Duel.GetLP(p-1)+2000)
	Duel.Draw(p,d,REASON_EFFECT)
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetDescription(aux.Stringid(id,0))
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_CANNOT_ACTIVATE)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e0:SetTargetRange(1,0)
		e0:SetCondition(s.accon)
		e0:SetValue(s.aclimit)
		e0:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e0,tp)
		Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,2)
		--Opponent takes no further damage this turn
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,p-1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,p-1)
end
function s.accon(e)
	return Duel.GetCustomActivityCount(id,e:GetHandlerPlayer(),ACTIVITY_CHAIN)>0
end
function s.aclimit(e,re,tp)
	return not re:IsActiveType(TYPE_SPELL)
end
