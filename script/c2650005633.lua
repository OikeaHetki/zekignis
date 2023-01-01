--復ふく讐しゅうのソード・ストーカー
--Swordstalker
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.atkcon)
	e1:SetValue(800)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsMonster()
end
function s.atkcon(e)
	local g=Duel.GetMatchingGroup(s.cfilter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
