--魔轟神ヴァルキュルス
--Fabled Asmodai
--zek
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x35),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.aclimit)
	e1:SetCondition(s.actcon)
	c:RegisterEffect(e1)
end
s.listed_series={0x35}
function s.aclimit(e,re,tp)
	return re:IsMonsterEffect() or (re:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsType(TYPE_SPELL))
end
function s.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end