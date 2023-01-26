--E・HERO バブルマン・ネオ
--Elemental HERO Neo Avian
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--change code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(21844576)
	c:RegisterEffect(e2)
	--battle dam 0
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Unaffected by Opponent Card Effects
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(s.unval)
	c:RegisterEffect(e5)
end
s.listed_names={21844576}
function s.spfilter(c,...)
	return c:IsCode(...) and c:IsAbleToGraveAsCost() and (c:IsFaceup or c:IsLocation(LOCATION_HAND))
end
function s.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(s.chk,1,nil,sg)
end
function s.chk(c,sg)
	return c:IsCode(21844576) and sg:IsExists(Card.IsCode,1,c,46411259)
end
function s.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE,0,nil,21844576)
	local g2=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,46411259)
	local g=g1:Clone()
	g:Merge(g2)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and #g1>0 and #g2>0 
		and aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE,0,nil,21844576)
	sg:Merge(Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,46411259))
	local g=aux.SelectUnselectGroup(sg,e,tp,2,2,s.rescon,1,tp,HINTMSG_TOGRAVE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
function s.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end