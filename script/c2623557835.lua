--次元融合
--Dimension Fusion
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA)
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) ---and c:IsSummonableCard()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0
	and Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
	--Cannot Special Summon from the Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(_,c) return c:IsLocation(LOCATION_EXTRA) end)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp)) or
		(Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_REMOVED,1,nil,e,1-tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,2,LOCATION_REMOVED)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft1>0 then
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft1=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_REMOVED,0,ft1,ft1,nil,e,tp)
		if #g>0 then
			local tc=g:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				--Prevent the activation of the effects
				--local e1=Effect.CreateEffect(e:GetHandler())
				--e1:SetType(EFFECT_TYPE_SINGLE)
				--e1:SetCode(EFFECT_CANNOT_TRIGGER)
				--e1:SetRange(LOCATION_MZONE)
				--e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				--tc:RegisterEffect(e1)
				tc=g:GetNext()
				count=count+1
			end
		end
	end
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft2>0 then
		if Duel.IsPlayerAffectedByEffect(1-tp,CARD_BLUEEYES_SPIRIT) then ft2=1 end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(1-tp,s.filter,tp,0,LOCATION_REMOVED,ft2,ft2,nil,e,1-tp)
		if #g>0 then
			local tc=g:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
				 --local e1=Effect.CreateEffect(c)
				--e1:SetType(EFFECT_TYPE_SINGLE)
				--e1:SetCode(EFFECT_DISABLE)
				--e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				--tc:RegisterEffect(e1)
				--local e2=Effect.CreateEffect(c)
				--e2:SetType(EFFECT_TYPE_SINGLE)
				--e2:SetCode(EFFECT_DISABLE_EFFECT)
				--e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				--tc:RegisterEffect(e2)
				--local e3=Effect.CreateEffect(e:GetHandler())
				--e3:SetType(EFFECT_TYPE_SINGLE)
				--e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				--e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				--e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
				--e3:SetValue(LOCATION_DECKBOT)
				--tc:RegisterEffect(e3)
				tc=g:GetNext()
				count=count+1
			end
		end
	end
	if count>0 then Duel.SpecialSummonComplete() end
end