--Sin パラドクス・ドラゴン
--Malefic Paradox Dragon
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterSummonCode(74509280),1,1,Synchro.NonTunerEx(Card.IsSetCard,0x23),1,1)
	c:EnableReviveLimit()
	--only one can exist
	c:SetUniqueOnField(1,0,8310162)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.descon)
	c:RegisterEffect(e2)
	--Decrease ATK/DEF
--  local e3=Effect.CreateEffect(c)
--  e3:SetType(EFFECT_TYPE_FIELD)
--  e3:SetCode(EFFECT_UPDATE_ATTACK)
--  e3:SetRange(LOCATION_MZONE)
--  e3:SetCondition(s.atkcon)
--  e3:SetTargetRange(0,LOCATION_MZONE)
--  e3:SetValue(s.atkval)
--  c:RegisterEffect(e3)
--  local e4=e3:Clone()
--  e4:SetCode(EFFECT_UPDATE_DEFENSE)
--  c:RegisterEffect(e4)
end
s.material={74509280}
s.listed_names={74509280,27564031}
s.listed_series={0x23}
--If "Malefic World" is not in a Field Zone
function s.descon(e)
	return not Duel.IsEnvironment(27564031)
end
--lose ATK while other Synchro on the field
--function s.atkfilter(c)
--  return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
--end
--function s.atkcon(e,tp,ev,ep,eg,re,r,rp)
--	return Duel.IsExistingMatchingCard(s.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
--end
--function s.atkval(e,c)
--	local tatk=0
--	local g=Duel.GetMatchingGroup(s.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,e:GetHandler())
--	local tc=g:GetFirst()
--	while tc do
--		tatk=tatk+tc:GetAttack()
--		tc=g:GetNext()
--	end
--	return -tatk
--end
--sp on synchro summon
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end