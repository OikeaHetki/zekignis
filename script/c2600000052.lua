--獣剣タイガーサーベル
--Beast Swords - Tiger Sabre
--scripted by YoshiDuels
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--equip
	aux.AddEquipProcedure(c,0,s.eqfilter,s.eqlimit)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(900)
	c:RegisterEffect(e1)
	--def up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(900)
	c:RegisterEffect(e1)
	--can be double tribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(s.eftg2)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--extra attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function s.eqfilter(c)
	return c:IsFaceup() and c:IsAttackBelow(1400) and not c:IsType(TYPE_EFFECT)
end
function s.eqlimit(e,c)
	return c:IsFaceup()
end
function s.otfilter(c,tp)
	local eg=c:GetEquipGroup()
	return c:IsDoubleTribute(FLAG_DOUBLE_TRIB) and #eg>0 and eg:IsExists(Card.IsCode,1,nil,id) and (c:IsControler(tp) or c:IsFaceup())
end
function s.eftg(e,c)
	return c:IsLevelAbove(7) and c:IsSummonableCard()
end
function s.eftg2(e,c)
	if e:GetHandler():GetEquipTarget()==c and c:GetFlagEffect(id)==0 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
		c:AddDoubleTribute(id,s.otfilter,s.eftg,RESET_EVENT+RESETS_STANDARD,FLAG_DOUBLE_TRIB)
		return true
	end
	return false
end