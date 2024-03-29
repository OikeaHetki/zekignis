--進化の繭
--Cocoon of Evolution
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(s.checkcon)
	e2:SetOperation(s.checkop)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(s.checkcon2)
	e3:SetOperation(s.checkop2)
	c:RegisterEffect(e3)
	--self-destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetCondition(s.descon)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
	--spsummon moths
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(s.spcon)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
end
s.listed_names={87756343,40240595,id}
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	return g and g:IsExists(Card.IsCode,1,nil,87756343) --Duel.GetTurnPlayer()==tp and 
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()+1
	c:SetTurnCounter(ct)
end
function s.checkcon2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	local g2=e:GetLabelObject() or Group.CreateGroup()
	return #g>0 and not g:Equal(g2)
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetCardTarget()
	local g2=e:GetLabelObject()
	if not g:IsExists(Card.IsCode,1,g:Filter(aux.TRUE,g2),58192742) then
		c:SetTurnCounter(0)
	end
	g:KeepAlive()
	e:SetLabelObject(g)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(87756343)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsControler(1-tp) or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetValue(s.eqlimit)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	--equip effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(0)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	e3:SetValue(2000)
	c:RegisterEffect(e3)
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98649372,1))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.postg)
	e4:SetOperation(s.posop)
	c:RegisterEffect(e4)
	--indestructable/immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
--POS
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local eq=e:GetHandler():GetEquipTarget()
	if chk==0 then return eq end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eq,1,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local eq=e:GetHandler():GetEquipTarget()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if eq then
		Duel.ChangePosition(eq,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
--equip limitation
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
--selfdes
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetEquipTarget()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler():GetEquipTarget(),REASON_EFFECT)
end
--sp the moths
function s.spcon(e,tp,eg,ev,ep,re,r,rp)
	local ec=e:GetHandler():GetPreviousEquipTarget()
	return e:GetHandler():IsReason(REASON_LOST_TARGET) and ec:IsReason(REASON_DESTROY) and ec:IsOriginalCodeRule(87756343)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spfilter(c,e,tp)
	local ct=e:GetHandler():GetTurnCounter()
	return c:IsCode(14141448) and ct>=4
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end