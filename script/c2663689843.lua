--白兵戦
--Attack and Receive
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--Damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(s.reccon)
	e1:SetTarget(s.rectg)
	e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
	--damage 2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_DAMAGE)
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
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(700)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,700)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local gc=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,63689843)
	if gc>0 then
		Duel.Damage(p,300*gc,REASON_EFFECT)
	end
end
function s.rfilter(c)
	return c:IsCode(63689843) and c:IsAbleToRemoveAsCost()
end
function s.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function s.rectg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.recop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end