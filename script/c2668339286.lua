--メタル・ガーディアン
--Metal Guardian
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	-- summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.esfilter)
	c:RegisterEffect(e2)
end
s.listed_names={59197169}
function s.esfilter(c)
	return c:IsType(TYPE_MONSTER) and (aux.ListsCode(c,59197169) or c:IsCode(62121))
end