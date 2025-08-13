--復活した仙人
--Revived Sengenjin
--zek
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
end
s.listed_names={2600000555}