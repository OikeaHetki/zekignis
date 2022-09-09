--苦渋の選択
--Painful Choice
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,LOCATION_DECK,0,nil)
			return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,3,nil) 
			and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2
			and g:GetClassCount(Card.GetCode)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<3 then return false end
	local sg=aux.SelectUnselectGroup(g,e,tp,3,3,aux.dncheck,1,tp,HINTMSG_CONFIRM)
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,1))
	local sg=g:Select(1-tp,1,1,nil)
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(sg,0)
			Duel.ConfirmDecktop(tp,1)
	g:Sub(sg)
	Duel.SendtoGrave(g,REASON_RULE)
	-- halve battle damage
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,2),nil)
end
function s.damval(e,re,val,r,rp,rc)
	return math.floor(val/2)
end