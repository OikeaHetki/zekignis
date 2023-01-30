--グレート・モス
--Great Moth
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Limit battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(s.tg)
	c:RegisterEffect(e2)
		--corrosive scales
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_SUMMON_SUCCESS)
		e3:SetCondition(s.ctcon1)
		e3:SetOperation(s.ctop)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAINING)
		e5:SetRange(LOCATION_MZONE)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetOperation(s.regop)
		c:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_CHAIN_SOLVED)
		e6:SetRange(LOCATION_MZONE)
		e6:SetOperation(s.ctop)
		c:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(EFFECT_UPDATE_ATTACK)
		e7:SetRange(LOCATION_MZONE)
		e7:SetTargetRange(0,LOCATION_MZONE)
		e7:SetValue(s.atkval)
		c:RegisterEffect(e7)
		local e8=e7:Clone()
		e8:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e8)
end
s.listed_names={40240595,87756343}
--limit attack
function s.tg(e,c)
	return c:IsFaceup() and c:GetCode()~=id and c:IsRace(RACE_INSECT)
end
--sumcon
function s.eqfilter(c)
	return c:IsCode(40240595) and c:GetTurnCounter()>=3
end
function s.rfilter(c,ft,tp)
	return c:IsCode(87756343) and c:GetEquipGroup():IsExists(s.eqfilter,1,nil)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),s.rfilter,1,false,1,true,c,c:GetControler(),nil,false,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,s.rfilter,1,1,false,true,true,c,nil,nil,false,nil)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
--corrosive scales
function s.atkval(e,c)
	return c:GetCounter(0x1045)*-100
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function s.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		tc:AddCounter(0x1045,1)
	end
end