--きせいちゅうのぼうそう
--Reckless Parasite
--zek
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1a=Effect.CreateEffect(c)
	e1a:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1a:SetType(EFFECT_TYPE_ACTIVATE)
	e1a:SetCode(EVENT_FREE_CHAIN)
	e1a:SetTarget(s.target)
	e1a:SetOperation(s.activate)
	c:RegisterEffect(e1a)
	--Cannot be target
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD)
	e1b:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1b:SetRange(LOCATION_SZONE)
	e1b:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1b:SetTarget(s.papar)
	e1b:SetValue(1)
	c:RegisterEffect(e1b)
	local e1c=e1b:Clone()
	e1c:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1c:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e1c)
end
s.listed_names={27911549,id}
--parasite paracide filter
function s.papar(e,c)
	return c:IsCode(27911549)
end
--spsum parasite paracide on activation
function s.spfilter(c,e,tp)
	return c:IsCode(27911549) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,0,LOCATION_DECK,1,1,nil,e,tp)
	if #g>0 and
		Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE) then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetCode(EFFECT_CHANGE_RACE)
			e0:SetRange(LOCATION_MZONE)
			e0:SetTargetRange(LOCATION_MZONE,0)
			e0:SetValue(RACE_INSECT)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e0)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			c:RegisterEffect(e4)
			local e5=e3:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			c:RegisterEffect(e5)
			local e6=e3:Clone()
			e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			c:RegisterEffect(e6) 
	end
end
--