--Chaos Emperor Dragon - Envoy of the Morning Dawn
--zek
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Special summon limitat
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--Add Dark attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--Special summon procedure
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(s.spcon)
	e3:SetOperation(s.spop)
	e3:SetLabel(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetLabel(ATTRIBUTE_DARK)
	c:RegisterEffect(e4)
	--Banish a remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(s.rmtg)
	e5:SetOperation(s.rmop)
	c:RegisterEffect(e5)
	e3:SetLabelObject(e5)
	e4:SetLabelObject(e5)
end
function s.spfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and ct>0 and ct==Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,ct,nil,e:GetLabel())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e:GetLabel())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetLabelObject():SetLabel(e:GetLabel())
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then
		if e:GetLabel()==ATTRIBUTE_LIGHT then
			return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		else
			return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil,tp,POS_FACEDOWN)
		end
	end
	if e:GetLabel()==ATTRIBUTE_LIGHT then
		local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
		e:SetProperty(0)
	end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==ATTRIBUTE_LIGHT then
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.Recover(tp,g*300,REASON_EFFECT)
		end
	else
		local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.Damage(1-tp,g*200,REASON_EFFECT)
		end
	end
end