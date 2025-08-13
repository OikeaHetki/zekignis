--Sin スターダスト・ドラゴン
--Malefic Stardust Dragon
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--only one can exist
	c:SetUniqueOnField(1,0,36521459)
	aux.AddMaleficSummonProcedure(c,CARD_STARDUST_DRAGON,LOCATION_EXTRA)
	--spson
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--selfdes
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ea:SetRange(LOCATION_MZONE)
	ea:SetCode(EFFECT_SELF_DESTROY)
	ea:SetCondition(s.descon)
	c:RegisterEffect(ea)
	--non-"Malefic" cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.mlfatk)
	c:RegisterEffect(e1)
	--Indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.indescon)
	e2:SetTarget(s.indestg)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_STARDUST_DRAGON}
s.listed_series={0x23}
--self-destroy
function s.descon(e)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
--non-"Malefic" cannot attack
function s.mlfatk(e,c)
	return not c:IsSetCard(0x23)
end
--personal effects
function s.indescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(27564031)
end
function s.indestg(e,c)
	return c:IsSetCard(0x23) --and c~=e:GetHandler()
end
