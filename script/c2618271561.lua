--ヘル・ブラスト
--Chthnonian Blast
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.dfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsPreviousControler(tp) and c:IsReason(REASON_DESTROY)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.dfilter,1,nil,tp)
end
function s.filter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil,e)
	if chk==0 then return #g>0 end
	local tg=g:GetMinGroup(Card.GetAttack)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=tg:Select(tp,1,1,nil)
	local dg=g:GetMinGroup(Card.GetAttack)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetFirst():GetAttack()/2
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT) then
		Duel.Damage(tp,atk,REASON_EFFECT,true)
		Duel.Damage(1-tp,atk,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end