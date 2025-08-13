--ジュラシックワールド
--Jurassic World
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DINOSAUR))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(s.indtg)
	e4:SetValue(s.indesval)
	c:RegisterEffect(e4)
	--change battle target
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(42256406,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(s.cbcon)
	e5:SetOperation(s.cbop)
	c:RegisterEffect(e5)
end
function s.indtg(e,c)
	return c:IsRace(RACE_DINOSAUR) and c:IsFaceup()
end
function s.indesval(e,re)
	return re:GetHandler():IsMonster() and not re:GetHandler():IsRace(RACE_DINOSAUR)
end
function s.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local bt=eg:GetFirst()
	return r~=REASON_REPLACE and bt:IsFaceup() and bt:IsControler(tp) and bt:IsRace(RACE_DINOSAUR) 
		and bt:IsAttackPos()
end
function s.cbop(e,tp,eg,ep,ev,re,r,rp)
	local at=eg:GetFirst()
	if at:IsAttackPos() and at:IsRelateToBattle() then
		Duel.ChangePosition(at,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,0,0)
	end
end