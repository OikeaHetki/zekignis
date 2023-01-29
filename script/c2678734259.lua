--N・エア・ハミングバード
--Neo-Spacian Sky Hummingbird
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--must first properly special summon
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.adval)
	c:RegisterEffect(e2)
	--add code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_CODE)
	e3:SetValue(54959865)
	c:RegisterEffect(e3)
end
s.listed_names={54959865}
function s.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_HAND)*500
end