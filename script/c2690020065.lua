--タイム・ボマー
--Jigen Bakudan
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(s.descon)
		e1:SetCost(s.descost)
		e1:SetTarget(s.destg)
		e1:SetOperation(s.desop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		c:RegisterEffect(e1)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function s.filter(c,tp)
	return not c:IsLocation(LOCATION_MZONE) and c:GetOwner()==tp
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if Duel.Destroy(sg,REASON_EFFECT)~=0 then
			local g1=sg:Filter(s.filter,nil,tp)
			local g2=sg:Filter(s.filter,nil,1-tp)
			local tc1=g1:GetFirst()
			local sum1=0
			local sum2=0
			while tc1 do
				sum1=sum1+tc1:GetBaseAttack()
				tc1=g1:GetNext()
			end
			local tc2=g2:GetFirst()
			while tc2 do
				sum2=sum2+tc2:GetBaseAttack()
				tc2=g2:GetNext()
			end
			Duel.Damage(tp,sum1,REASON_EFFECT,true)
			Duel.Damage(1-tp,sum2,REASON_EFFECT,true)
			Duel.RDComplete()
		end
	end
end
