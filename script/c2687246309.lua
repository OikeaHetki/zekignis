--ファーニマル・オクト
--Fluffal Octopus
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,{id,1})
	e3:SetCondition(s.disdc)
	e3:SetTarget(s.disdtg)
	e3:SetOperation(s.disdop)
	c:RegisterEffect(e3)
end
s.listed_series={0xa9,0xc3,0xad}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function s.filter(c)
	return ((c:IsSetCard(0xa9) or c:IsSetCard(0xc3)) and not c:IsCode(id) and not c:IsOriginalCode(id)) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function s.disdc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_FUSION and c:GetReasonCard():IsOriginalSetCard(0xad)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xad)
end
function s.disdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function s.ctfilter2(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0xa9)
end
function s.disdop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if ct1>0 then
		if Duel.DiscardDeck(tp,ct1,REASON_EFFECT)~=0 then
			local og=Duel.GetOperatedGroup()
			local ct2=og:FilterCount(s.ctfilter2,nil)
			if ct2>0 then
				Duel.Recover(tp,ct2*500,REASON_EFFECT)
			end
		end
	end
end
