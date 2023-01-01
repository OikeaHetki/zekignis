--地砕き
--Smashing Ground
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsDefenseAbove(0) and c:IsOnField() and c:IsCanBeEffectTarget(e)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e):GetMaxGroup(Card.GetDefense)
    if chkc then return g:IsContains(chkc) end
    if chk==0 then return chkc==g end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local tc=g:Select(tp,1,1,nil)
    Duel.SetTargetCard(tc)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end