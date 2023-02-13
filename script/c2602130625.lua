--白衣の天使
--Numinous Healer
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(s.reccon)
	e1:SetTarget(s.rectg)
	e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
	--recover 2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.reccon)
	e2:SetCost(s.reccost)
	e2:SetTarget(s.rectg2)
	e2:SetOperation(s.recop2)
	c:RegisterEffect(e2)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1200)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	local gc=Duel.GetMatchingGroupCount(Card.IsCode,p,LOCATION_GRAVE,0,nil,02130625)
	if gc>0 then
		Duel.Recover(p,800*gc,REASON_EFFECT)
	end
end
function s.rfilter(c)
	return c:IsCode(02130625) and c:IsAbleToRemoveAsCost()
end
function s.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function s.rectg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function s.recop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end