--おジャマ・エンペラー
--Ojaminstrel
--zek
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_LIGHT),1,1,Synchro.NonTunerEx(Card.IsRace,RACE_BEAST),1,99)
	c:EnableReviveLimit()
	--disable field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end
s.listed_series={0xf}
s.listed_names={90011152}
function s.disop(e,tp)
	local c=Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)
	if c==0 then return end
	local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_SZONE,0)
	if c>1 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local dis2=Duel.SelectDisableField(tp,1,0,LOCATION_SZONE,dis1)
		dis1=(dis1|dis2)
	end
	return dis1
end