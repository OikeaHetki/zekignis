--氷結界の龍 グングニール
--Gungnir, Dragon of the Ice Barrier
--zekpro version (is generic, is a winged beast, can target any card on the field, hard opt)
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsTurnPlayer(tp) and Duel.IsMainPhase()) or
		   (not Duel.IsTurnPlayer(tp) and Duel.IsBattlePhase())
end
function s.costfilter(c)
	return c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rt=math.min(2,Duel.GetTargetCount(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil))
	if chk==0 then return aux.IceBarrierDiscardCost(s.costfilter,true,1,rt)(e,tp,eg,ep,ev,re,r,rp,0) end
	e:SetLabel(aux.IceBarrierDiscardCost(s.costfilter,true,1,rt)(e,tp,eg,ep,ev,re,r,rp,1))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local eg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,ct,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetTargetCards(e)
	if #rg>0 then 
		Duel.Destroy(rg,REASON_EFFECT)
	end
end