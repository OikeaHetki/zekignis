--シャイン＆ダークのマスク
--Mask of Shine & Dark
--zek
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(s.eqcon)
	e5:SetTarget(s.eqtg)
	e5:SetOperation(s.eqop)
	c:RegisterEffect(e5)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(s.atkcon)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--defup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(s.atkcon)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--Add DARK attribute
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_ADD_ATTRIBUTE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e4)
end
s.listed_names={2600000014}
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousLocation()==LOCATION_MZONE
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,c,tc)
		--atk
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_UPDATE_ATTACK)
		e5:SetCondition(s.condtion)
		e5:SetValue(500)
		c:RegisterEffect(e5)
		--def
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_UPDATE_ATTACK)
		e6:SetCondition(s.condtion)
		e6:SetValue(500)
		c:RegisterEffect(e6)
		--equip limit
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_EQUIP_LIMIT)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e7:SetValue(s.eqlimit)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e7)
	end
end
function s.eqlimit(e,c)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(tp)
end
function s.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local ec=e:GetHandler():GetEquipTarget()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return ((a==e:GetHandler() and d and d:IsFaceup() and (d:IsAttribute(ATTRIBUTE_LIGHT) or d:IsAttribute(ATTRIBUTE_DARK)))
		or (d==e:GetHandler() and (a:IsAttribute(ATTRIBUTE_LIGHT) or a:IsAttribute(ATTRIBUTE_DARK)))) and ec and (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and ec:IsRelateToBattle()
end
function s.condtion(e)
	local ph=Duel.GetCurrentPhase()
	if not (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a==e:GetHandler() and d and d:IsFaceup() and (d:IsAttribute(ATTRIBUTE_LIGHT) or d:IsAttribute(ATTRIBUTE_DARK)))
		or (d==e:GetHandler() and (a:IsAttribute(ATTRIBUTE_LIGHT) or a:IsAttribute(ATTRIBUTE_DARK)))
end