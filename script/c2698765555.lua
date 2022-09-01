--Ｓｉｎ Ｐａｒａｄｉｇｍ Ｓｈｉｆｔ
--Zekpro card
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
s.listed_series={0x23}
---summon truth
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x23) and c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function s.filter(c,e,tp)
	return c:IsCode(37115575) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0x13)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,0x13,0,1,1,nil,e,tp)
	local tc=g
	if tc:GetCount()>0 and Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP) and tc:IsFaceup() and tc:IsControler(tp) then
		--Unaffected by opponent's card effects
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3110)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
---ondes search
function s.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(27564031)
end