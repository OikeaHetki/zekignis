--黒魔術のカーテン
--Dark Magic Curtain
--zekpro version (is generic, affects opponent, has no restricitons)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	local p=tp
	if Duel.IsExistingMatchingCard(s.spfilter,1-tp,LOCATION_DECK,0,1,nil,e,1-tp) 
		and Duel.SelectYesNo(1-tp,aux.Stringid(102380,0)) then
		Duel.PayLPCost(1-tp,math.floor(Duel.GetLP(1-tp)/2))
		p=tp+1
	end
	e:SetLabel(p)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(1-tp) end
	local p=e:GetLabel()
	if p~=tp then
		p=PLAYER_ALL
	end
	Duel.SetTargetPlayer(p)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,p==PLAYER_ALL and 2 or 1,p,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 and
			Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP) then		
			--Cannot activate its effects
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(3302)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			g:RegisterEffect(e1)
		end
	end
	if p==PLAYER_ALL and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(1-tp,s.spfilter,1-tp,LOCATION_DECK,0,1,1,nil,e,1-tp)
		if #g>0 then
			Duel.SpecialSummonStep(g:GetFirst(),0,1-tp,1-tp,false,false,POS_FACEUP)
			--Cannot activate its effects
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(3302)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			g:RegisterEffect(e1)
		end
	end
	Duel.SpecialSummonComplete()
end