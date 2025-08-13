--No. S95 - ギャラクシーアイズ・アビス 暗黒反物質の竜
--Number S95: Galaxy-Eyes Void Lightning Dragon
--zek
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),10,4,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
	---indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(s.ind1)
	c:RegisterEffect(e1)
	--Can attack all monsters
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetCondition(s.matcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e4)
end
s.xyz_number=95
s.listed_names={88177324}
function s.ovfilter(c)
	return c:IsFaceup() and (c:GetRank()==9 or c:GetRank()==8) and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,88177324)
end
function s.ind1(e,re,rp,c)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end