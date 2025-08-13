--呪われたトライホーン・ドラゴン
--Cursed Tri-Horn Dragon
--zek
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Decrease ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(function(e,c) return c~=e:GetHandler() end)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	--Decrease DEF
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(function(e,c) return c~=e:GetHandler() end)
	e2:SetValue(-500)
	c:RegisterEffect(e1)
end
s.listed_names={2600000545}