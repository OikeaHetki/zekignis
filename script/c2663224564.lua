--サイバー・ボンテージ
--Cyber Bondage
--zekpro version (also gives DEF)
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,CARD_HARPIE_LADY,CARD_HARPIE_LADY_SISTERS))
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(500)
	c:RegisterEffect(e3)
end
s.listed_names={CARD_HARPIE_LADY,CARD_HARPIE_LADY_SISTERS}