--７カード
--7 completed
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),nil,nil,nil,s.operation)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.reccon)
	e3:SetTarget(s.rectg)
	e3:SetOperation(s.recop)
	c:RegisterEffect(e3)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local opt=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		if opt==0 then 
			e1:SetCode(EFFECT_UPDATE_ATTACK)
		else 
			e1:SetCode(EFFECT_UPDATE_DEFENSE) 
		end
		e1:SetValue(700)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(700)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,700)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
