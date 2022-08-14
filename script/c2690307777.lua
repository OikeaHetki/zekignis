--影霊衣の術士 シュリット
--Shurit, Strategist of the Nekroz
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--Change position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.postg)
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)
	--tohand from deck when banished
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,{id,2})
	e3:SetTarget(s.gtg)
	e3:SetOperation(s.gop)
	c:RegisterEffect(e3)
end
s.listed_series={0xb4}
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_EFFECT)~=0
end
function s.thfilter(c)
	return c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.filter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
end
function s.gfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb4) and c:IsAbleToHand()
end
function s.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ct=#hg
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(s.gfilter,tp,LOCATION_GRAVE,0,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,hg,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_GRAVE)
end
function s.gop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ct=Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.gfilter),tp,LOCATION_GRAVE,0,ct,ct,nil)
	if #g>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end