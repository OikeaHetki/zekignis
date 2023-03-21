--アンノウン・シンクロン
--Unknown Synchron
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	--Banish it if it leaves the field
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(3300)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	e:GetHandler():RegisterEffect(e1,true)
end