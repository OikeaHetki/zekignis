--Cyber Harpie Lady
--Zekpro Version
local s,id=GetID()
function s.initial_effect(c)
	--attack cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetCost(s.atcost)
	e1:SetOperation(s.atop)
	c:RegisterEffect(e1)
	--change code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(CARD_HARPIE_LADY)
	c:RegisterEffect(e2)
end
function s.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsAttackCostPaid()~=2 and e:GetHandler():IsLocation(LOCATION_MZONE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tc=Duel.GetMatchingGroup(Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,e:GetHandler()):SelectUnselect(Group.CreateGroup(),tp,Duel.IsAttackCostPaid()==0, Duel.IsAttackCostPaid()==0)
		if tc then
			Duel.SendtoHand(tc,nil,REASON_COST)
			Duel.AttackCostPaid()
		else
			Duel.AttackCostPaid(2)
		end
	end
end
