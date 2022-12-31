--荒野
--Wasteland
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
--atkdef
function s.val(e,c)
	local r=c:GetRace()
	if (r&RACE_DINOSAUR+RACE_MACHINE+RACE_ROCK)>0 then return 300
	elseif (r&RACE_AQUA+RACE_FISH+RACE_PLANT+RACE_SEASERPENT+RACE_REPTILE)>0 then return -300
	else return 0 end
end