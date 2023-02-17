--きせいちゅうのぼうそう
--Reckless Parasite
--zek
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,2600000033)
	--Activate
	local e1a=Effect.CreateEffect(c)
	e1a:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e1a:SetType(EFFECT_TYPE_ACTIVATE)
	e1a:SetCode(EVENT_FREE_CHAIN)
	e1a:SetOperation(s.activate)
	c:RegisterEffect(e1a)
	--Cannot be target
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD)
	e1b:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1b:SetRange(LOCATION_SZONE)
	e1b:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1b:SetCondition(s.inworcon)
	e1b:SetTarget(s.papar)
	e1b:SetValue(1)
	c:RegisterEffect(e1b)
	local e1c=e1b:Clone()
	e1c:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1c:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e1c)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_INSECT)
	e2:SetCondition(s.inworcon)
	e2:SetTarget(s.tg)
	c:RegisterEffect(e2)
	--summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCondition(s.inworcon)
	e3:SetTarget(s.sumlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e4)
	--id chk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(id)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetValue(s.val)
	c:RegisterEffect(e5)
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
function s.thfilter(c)
	return c:IsMonster() and c:IsAbleToHand() and c:IsRace(RACE_INSECT)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,0,LOCATION_DECK,1,1,nil,e,tp)
	if #g>0 and
		Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE) then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
--insect world!
function s.ffilter(c)
	return c:IsFaceup() and c:IsCode(27911549)
end
function s.inworcon(e)
	return Duel.IsExistingMatchingCard(s.ffilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function s.tg(e,c)
	if c:GetFlagEffect(1)==0 then
		c:RegisterFlagEffect(1,0,0,0)
		local eff
		if c:IsLocation(LOCATION_MZONE) then
			eff={Duel.GetPlayerEffect(c:GetControler(),EFFECT_NECRO_VALLEY)}
		else
			eff={c:GetCardEffect(EFFECT_NECRO_VALLEY)}
		end
		c:ResetFlagEffect(1)
		for _,te in ipairs(eff) do
			local op=te:GetOperation()
			if not op or op(e,c) then return false end
		end
	end
	return true
end
function s.val(e,c,re,chk)
	if chk==0 then return true end
	return RACE_INSECT
end
function s.sumlimit(e,c,tp,sumtp)
	return sumtp&SUMMON_TYPE_TRIBUTE==SUMMON_TYPE_TRIBUTE and not c:IsRace(RACE_INSECT)
end