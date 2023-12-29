--D - 次元融合
--D.D. Fusion
--zek
local s,id=GetID()
function s.initial_effect(c)
	local e1=Fusion.CreateSummonEff(c,nil,Fusion.OnFieldMat(Card.IsAbleToDeck),s.fextra,Fusion.ShuffleMaterial,nil,s.stage2)
	--e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3000) end
	Duel.PayLPCost(tp,3000)
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(aux.AND(Card.IsAbleToDeck,Card.IsFaceup)),tp,LOCATION_REMOVED,0,nil)
end
function s.stage2(e,tc,tp,sg,chk)
	if chk==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetLabel(tc:GetFieldID())
		e1:SetTarget(s.atktg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.atktg(e,c)
	return e:GetLabel()~=c:GetFieldID()
end