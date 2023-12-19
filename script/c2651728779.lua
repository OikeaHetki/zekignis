--オジャマ・インディゴ
--Ojama Indigo
--zek
local s,id=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--spsummon
--  local e2=Effect.CreateEffect(c)
--  e2:SetDescription(aux.Stringid(id,1))
--  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
--  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
--  e2:SetCode(EVENT_DESTROYED)
--  e2:SetRange(LOCATION_GRAVE)
--  e2:SetCountLimit(1,id)
--  e2:SetCondition(s.spcon)
--  e2:SetTarget(s.sptg)
--  e2:SetOperation(s.spop)
--  c:RegisterEffect(e2)
end
s.listed_series={0xf}
function s.cfilter(c)
	return (c:IsSetCard(0xf) or c:IsRace(RACE_BEAST)) and c:IsDiscardable()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function s.thfilter(c)
	return (c:IsSetCard(0xf) or c:IsRace(RACE_BEAST)) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--  function s.spfilter(c)
--	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and (c:GetPreviousRaceOnField()&RACE_BEAST)~=0
--  end
--  function s.spcon(e,tp,eg,ep,ev,re,r,rp)
--	return not eg:IsContains(e:GetHandler()) and eg:IsExists(s.spfilter,1,nil)
--  end
--  function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
--	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
--		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
--	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
--  end
--  function s.spop(e,tp,eg,ep,ev,re,r,rp)
--  
--	if c:IsRelateToEffect(e) then
--	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
--	end
--  end