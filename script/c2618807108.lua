--六芒星の呪縛
--Spellbinding Circle
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	aux.AddPersistentProcedure(c,1,aux.FilterBoolFunction(Card.IsFaceup),CATEGORY_POSITION,EFFECT_FLAG_DAMAGE_STEP,TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP,s.condition)
	--eff
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.PersistentTargetFilter)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	--local e3=e1:Clone()
	--e3:SetCode(EFFECT_UPDATE_ATTACK)
	--e3:SetValue(-700)
	--c:RegisterEffect(e3)
	--local e4=e1:Clone()
	--e4:SetCode(EFFECT_UPDATE_DEFENSE)
	--e4:SetValue(-700)
	--c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=e1:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	local e9=e1:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	local e10=e1:Clone()
	e10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	--Destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetCondition(s.descon)
	e7:SetOperation(s.desop)
	c:RegisterEffect(e7)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_DESTROY_CONFIRMED) then return false end
	local tc=c:GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end