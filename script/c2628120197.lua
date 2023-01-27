--断層地帯
--Canyon
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Double Damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(s.dcon1)
	e2:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTargetRange(0,1)
	e3:SetCondition(s.dcon2)
	c:RegisterEffect(e3)
	--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WINGEDBEAST))
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(200)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--level
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_LEVEL)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_ROCK))
	e6:SetValue(-1)
	c:RegisterEffect(e6)
end
function s.dcon1(e)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	return a:GetControler()==e:GetHandlerPlayer() and d and d:IsDefensePos() and d:IsRace(RACE_ROCK)
end
function s.dcon2(e)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	return a:GetControler()==1-e:GetHandlerPlayer() and d and d:IsDefensePos() and d:IsRace(RACE_ROCK)
end
