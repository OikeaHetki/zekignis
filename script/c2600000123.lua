--マゴシン・ネヘモス
--Fabled Nehemoth
--zek
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x35),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Destroy
	--local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(id,1))
	--e2:SetCategory(CATEGORY_HANDES+CATEGORY_DESTROY)
	--e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e2:SetCode(EVENT_BATTLE_START)
	--e2:SetCost(s.descost)
	--e2:SetTarget(s.destg)
	--e2:SetOperation(s.desop)
	--c:RegisterEffect(e2)
	--register banish effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.rmcost)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
s.listed_series={0x35}
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x35) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--function s.costfilter(c)
--	return c:IsSetCard(0x35) and not c:IsPublic()
--end
--function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
--	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
--	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
--	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil)
--	Duel.ConfirmCards(1-tp,g)
--	Duel.ShuffleHand(tp)
--end
--function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
--	local c=e:GetHandler()
--	local tc=Duel.GetAttacker()
--	if tc==c then tc=Duel.GetAttackTarget() end
--	if chk==0 then return tc and tc:IsControler(1-tp)
--		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) end
--	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
--	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
--end
--function s.desop(e,tp,eg,ep,ev,re,r,rp)
--	local c=e:GetHandler()
--	local tc=Duel.GetAttacker()
--	if tc==c then tc=Duel.GetAttackTarget() end
--	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)>0
--		and tc:IsRelateToBattle() and tc:IsControler(1-tp) then
--		Duel.Destroy(tc,REASON_EFFECT)
--	end
--end
function s.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,s.costfilter,1,1,REASON_DISCARD+REASON_COST)
end
function s.filter(c)
	return c:IsFaceup() and c:IsMonster() and c:IsType(TYPE_EFFECT)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		-- banish it if it leaves the field
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3300)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT+RESET_PHASE+PHASE_END)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	end
end