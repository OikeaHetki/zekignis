--ファイバーポッド
--Fiber Jar
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.hfilter(c,tp)
	return tp~=c:GetOwner()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_GRAVE,0)>0 
	and not Duel.IsExistingMatchingCard(s.hfilter,tp,LOCATION_HAND,0,1,nil,tp) 
	and Duel.IsPlayerCanDraw(tp) end
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,#g1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local ct=#g1
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.ShuffleDeck(tp)
	Duel.Draw(tp,ct,REASON_EFFECT)
	Duel.Recover(tp,ct*400,REASON_EFFECT)
end