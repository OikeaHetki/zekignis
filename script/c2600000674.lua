--レオナルドの銀色のスカイシップ
--Leonardo's Silver Skyship
--zek
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	c:RegisterEffect(e1)
	--winner winner chicken dinner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsType(TYPE_NORMAL) and (sumtype&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function s.cfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and (not e or c:IsCanBeEffectTarget(e)) 
		and (not tp or Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,3,c))
end
function s.nmfilter(c)
	return not c:IsType(TYPE_NORMAL)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local pentg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil,e,tp)
	local pct=#pentg
	if chk==0 then return pct>0 end
	local sg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local g
	if pct==1 then
		sg:Sub(pentg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=sg:Select(tp,3,3,nil)
	elseif pentg:FilterCount(s.nmfilter,nil)>0 or pct>=4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=sg:Select(tp,3,3,nil)
	elseif pct==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=sg:FilterSelect(tp,Card.IsFacedown,2,2,nil)
		sg:Sub(g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g2=sg:Select(tp,1,1,nil)
		g:Merge(g2)
	elseif pct==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=sg:FilterSelect(tp,Card.IsFacedown,1,1,nil)
		sg:Sub(g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g2=sg:Select(tp,2,2,nil)
		g:Merge(g2)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		--Negate its effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		--ATK/DEF becomes 100
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(5000)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e4)
		--Unaffected by opponent's card effects
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(3110)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EFFECT_IMMUNE_EFFECT)
		e5:SetValue(s.efilter)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e5)
	end
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end