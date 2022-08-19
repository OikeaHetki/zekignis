--竜絶蘭
--Agave Dragon
--Scripted by Eerie Code
--fixed and improved and totally reworked by zek
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.NOT(aux.FilterBoolFunctionEx(Card.IsType,TYPE_TOKEN)),2)
	--apply effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND+ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
	if chk==0 then return #g>0 and (g:FilterCount(Card.IsAttribute,nil,RACE_SEASERPENT)<#g or Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)*200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)*600)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND+ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
	if #g==0 then return end
	local c=e:GetHandler()
	local ct1=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)
	local ct2=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)
	local ct3=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)
	local ct4=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WIND)
	local ct5=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)
	local ct6=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)
	if ct1>0 then
		Duel.DiscardDeck(1-tp,ct1,REASON_EFFECT)
	end
	local og1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if ct2>0 and #og1>0 then
		for tc in aux.Next(og) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct3*-200)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(ct3*-200)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
	if ct3>0 then
		Duel.Damage(1-tp,ct3*200,REASON_EFFECT)
	end
	local og2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if ct4>0 and #og2>0 then
		for tc in aux.Next(og) do
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetValue(ct3*400)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
	local og3=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if ct5>0 and #og3>0 then
		for tc in aux.Next(og) do
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_UPDATE_DEFENSE)
			e4:SetValue(ct3*500)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
		end
	end
	if ct6>0 then
		Duel.Recover(tp,ct6*600,REASON_EFFECT)
	end
end

