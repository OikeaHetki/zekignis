--星の君主セドリック
--Sedrek the Telestial Monarch
--zek
local s,id=GetID()
function s.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
		if tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_LIGHT) then
			Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1500)
		end
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT)
	if (tc:IsLocation(LOCATION_REMOVED) or tc:IsLocation(LOCATION_GRAVE)) and tc:IsMonster() and tc:IsAttribute(ATTRIBUTE_LIGHT) then Duel.Recover(tp,1500,REASON_EFFECT)
		end
	end
end