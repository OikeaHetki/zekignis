--闇晦ましの城
--Castle of Dark Illusion
--zekpro version (face-down attack position)
local s,id=GetID()
function s.initial_effect(c)
	--to defense
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.potg)
	e1:SetOperation(s.poop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Activate
	local e03=Effect.CreateEffect(c)
	e03:SetCategory(CATEGORY_POSITION)
	e03:SetType(EFFECT_TYPE_IGNITION)
	e03:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e03:SetCode(EVENT_FREE_CHAIN)
	e03:SetRange(LOCATION_MZONE)
	e03:SetCountLimit(1)
	e03:SetCondition(s.condition)
	e03:SetTarget(s.target)
	e03:SetOperation(s.activate)
	c:RegisterEffect(e03)
	--shuffle
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetTarget(s.postg)
	e4:SetOperation(s.posop)
	c:RegisterEffect(e4)
	--cannot be battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetCondition(s.cbbtcon)
	e5:SetValue(aux.imval1)
	c:RegisterEffect(e5)
	--cannot be target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(aux.tgoval)
	e6:SetCondition(s.cbbtcon)
	c:RegisterEffect(e6)
end
--change to def on summon
function s.potg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function s.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
--castle of dark illusions set
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.filter(c)
	return c:IsCanChangePosition() and c:IsFaceup() and not (c:IsCode(id) or c:IsOriginalCode(id)) and c:IsCanTurnSet()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MMZONE,0,1,nil)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MMZONE,0,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_ATTACK,0) 
end
--shuffle facedowns
function s.fffilter(c)
	return c:IsPosition(POS_FACEDOWN_ATTACK)
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.fffilter,tp,LOCATION_MMZONE,0,2,nil) end
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.fffilter,tp,LOCATION_MMZONE,0,nil)
	Duel.ShuffleSetCard(g)
end
--cannot attack
function s.ffilter(c)
	return c:IsFacedown()
end
function s.cbbtcon(e)
	return Duel.IsExistingMatchingCard(s.ffilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end