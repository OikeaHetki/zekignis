--サイコ・ソード
--Psychic Sword
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,92346415)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsOriginalRace,RACE_PSYCHIC))
	--extra attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	--Pierce
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_EQUIP)
	--e3:SetCode(EFFECT_PIERCE)
	--c:RegisterEffect(e3)
end
function s.atkval(e,c)
	local dif=Duel.GetLP(1-e:GetHandlerPlayer())-Duel.GetLP(e:GetHandlerPlayer())
	if dif>0 then
		return dif>2000 and 2000 or dif
	else return 0 end
end
