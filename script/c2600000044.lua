--銀河系のファーストフードの王者、デラックス バーガー
--Cosmos-Devouring Burger
--zek
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon this card from your hand by tributing a kahoona burger
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Ritual Summon 1 "Hungry Burger"
	local e2=Ritual.CreateProc(c,RITPROC_GREATER,aux.FilterBoolFunction(Card.IsCode,30243636),nil,aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCondition(function(e,tp) return Duel.IsTurnPlayer(1-tp) end)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(s.valcon)
	c:RegisterEffect(e3)
end
s.listed_names={30243636}
--indes
function s.valcon(e,re,r,rp)
	return (r&REASON_EFFECT)~=0 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
--special summon from the hand
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	if tp==ep or not Duel.IsChainDisablable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-#tg>0
end
function s.spcfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.spcfilter,1,false,nil,nil,tp) end
	local sg=Duel.SelectReleaseGroupCost(tp,s.spcfilter,1,1,false,nil,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
--negate and protect