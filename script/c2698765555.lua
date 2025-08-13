--Ｓｉｎ Ｐａｒａｄｉｇｍ Ｓｈｉｆｔ
--Zekpro card
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x23}
s.listed_names={37115575,27564031}
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x23)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) 
		then return false end
	if tp==ep or not Duel.IsChainNegatable(ev) then return false end
	local (ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY) or ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_REMOVE))
	return ex and tg~=nil and tc>0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0x13)
	end
end
function s.spfilter(c,e,tp)
	return c:IsCode(37115575) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and
		Duel.Destroy(eg,REASON_EFFECT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=0 and Duel.IsEnvironment(27564031) 
	and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,0x13,0,1,1,nil,e,tp)
	local tc=g
	if tc:GetCount()>0 then
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		end
	end
end