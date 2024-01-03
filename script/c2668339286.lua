--メタル・ガーディアン
--Metal Guardian
--zekpro version
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
	--summon with no tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(s.ntcon)
	c:RegisterEffect(e3)
	--extra summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e4:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.esfilter)
	c:RegisterEffect(e4)
end
s.listed_names={59197169}
--nt
function s.ffilter(c)
	return c:IsFaceup() and c:IsCode(59197169)
end
function s.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.ffilter,e:GetHandlerPlayer(),LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function s.esfilter(e,c)
	return c:IsType(TYPE_MONSTER) and (c:ListsCode(59197169) or c:IsCode(62121))
end