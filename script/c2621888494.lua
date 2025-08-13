--選ばれし者
--Chosen One
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSummonableCard()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,2,e:GetHandler(),TYPE_SPELL+TYPE_TRAP)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g1=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_SPELL+TYPE_TRAP)
	if #g1==0 or #g2<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local sg1=g1:Select(tp,1,1,nil)
	local sc=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local sg2=g2:Select(tp,2,2,nil)
	sg1:Merge(sg2)
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ShuffleHand(tp)
	local rg=sg1:Select(1-tp,1,1,nil)
	local tc=rg:GetFirst()
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.Remove(sg2,POS_FACEDOWN,REASON_EFFECT)
	else
		Duel.Remove(sg1,POS_FACEDOWN,REASON_EFFECT)
	end
end
