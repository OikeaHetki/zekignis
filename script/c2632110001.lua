--Attribute Mastery
--zek
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
function s.costfilter(c,e,tp)
	return c:IsType(TYPE_EFFECT) and c:GetAttack()==1800 and c:GetDefense()==200 and not c:IsPublic()
		and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),e,tp,c)
end
function s.thfilter2(c,att)
	return c:IsType(TYPE_NORMAL) and c:IsAttribute(att) and c:IsAbleToHand() and c:IsLevelAbove(7)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetFirst():GetAttribute())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsType(TYPE_EFFECT) and c:GetAttack()==1800 and c:GetDefense()==200
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			Duel.Summon(tp,sc,true,nil) 
	end
end