--闇の呪縛
--Shadow Spell
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--eff
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(-700)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e4)
end