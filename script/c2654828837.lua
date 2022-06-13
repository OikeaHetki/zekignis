--失楽の霹靂
--Cerulean Sky Fire
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--Add to Hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--immune effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.etarget)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--Negate effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.negcon)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
	aux.DoubleSnareValidity(c,LOCATION_SZONE)
end
s.listed_names={32491822}
--hamon
function s.filter(c,e,tp)
	return c:IsCode(32491822) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp) -- Add to hand
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--immune
function s.etarget(e,c)
	return c:IsCode(32491822)
end
function s.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL)
end
--cerulean skyfire
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(32491822) and c:IsAttackPos()
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev) 
		and e:GetHandler():GetFlagEffect(id)==0
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		if Duel.NegateEffect(ev) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		end
	end
end