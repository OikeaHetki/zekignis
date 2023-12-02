--Attribute Mastery
--zek, corrections by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.costfilter(c,tp)
	return c:IsType(TYPE_EFFECT) and c:GetAttack()==1800 and c:GetDefense()==200 and not c:IsPublic()
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function s.thfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToHand() and c:GetLevel()==7 and (c:IsType(TYPE_TUNER) or c:IsType(TYPE_NORMAL))
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetFirst():GetAttribute())
	-- Cannot special summon more than once
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOwnerPlayer(tp)
	e1:SetCondition(s.spcon)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsType(TYPE_EFFECT) and c:GetAttack()==1800 and c:GetDefense()==200
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 --if there is a card in the group
		and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 --if the card was added to the hand
		and Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil) --and there is a card in the hand that can be normal summoned
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then --and the player says yes
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sc=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND,0,1,1,tp):GetFirst()
			Duel.Summon(tp,sc,true,nil) 
	end
end
function s.spcon(e)
	return Duel.GetFlagEffect(e:GetOwnerPlayer(),id)>0
end