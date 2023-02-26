--グレート・モス
--Great Moth
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Limit battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(s.tg)
	c:RegisterEffect(e1)
		--corrosive scales
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetCondition(s.ctcon1)
		e2:SetOperation(s.ctop)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAINING)
		e4:SetRange(LOCATION_MZONE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetOperation(s.regop)
		c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAIN_SOLVED)
		e5:SetRange(LOCATION_MZONE)
		e5:SetOperation(s.ctop)
		c:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_UPDATE_ATTACK)
		e6:SetRange(LOCATION_MZONE)
		e6:SetTargetRange(0,LOCATION_MZONE)
		e6:SetValue(s.atkval)
		c:RegisterEffect(e6)
		local e7=e6:Clone()
		e7:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e7)
end
s.listed_names={40240595}
s.counter_list={0x1045}
--limit attack
function s.tg(e,c)
	return c:IsFaceup() and c:GetCode()~=14141448 and not c:IsRace(RACE_INSECT)
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