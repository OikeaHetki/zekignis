--Sin シューティング・クェーサー・ドラゴン
--Malefic Shooting Quasar Dragon
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterSummonCode(74509280),1,1,Synchro.NonTunerEx(Card.IsSetCard,0x23),1,1)
	c:EnableReviveLimit()
	--only one can exist
	c:SetUniqueOnField(1,0,id)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.descon)
	c:RegisterEffect(e1)
	--cannot disable sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.target)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.sucop)
	c:RegisterEffect(e3)
	--summon cannot be negated
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(s.sumcon)
	e5:SetTarget(s.sumtg)
	e5:SetOperation(s.sumop)
	c:RegisterEffect(e5)
end
s.material={74509280}
s.listed_names={74509280,27564031}
s.listed_series={0x23}
--If "Malefic World" is not in a Field Zone
function s.descon(e)
	return not Duel.IsEnvironment(27564031)
end
--personal effect
function s.target(e,c)
	return and c:IsSetCard(0x23)
end
--succ filter
function s.sucfilter(c,tp)
	return c:IsSetCard(0x23) and c:IsControler(tp)
end
function s.sucop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.sucfilter,1,nil,tp) then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	end
end
function s.chainlm(e,rp,tp)
	return tp==rp or (e:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not e:IsHasType(EFFECT_TYPE_ACTIVATE))
end
--on remove
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x23) and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and not c:IsType(TYPE_SYNCHRO)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(s.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if tg then
		Duel.SpecialSummon(tg,0,tp,tp,false,true,POS_FACEUP)
	end
end
