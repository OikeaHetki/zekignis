--Ojamachine King
--zek
local s,id=GetID()
function s.initial_effect(c)
	aux.AddUnionProcedure(c,s.unfilter)
	--Atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1500)
	c:RegisterEffect(e1)
	--Def up
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,2623265560,2623265561,2623265599)
	--disable field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DISABLE_FIELD)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
end
s.material_setcode=0xf
function s.unfilter(c)
	return (c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)) or c:IsSetCard(0xf) or cIsSetCard(0x111)
end
function s.disop(e,tp)
	local c=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	if c==0 then return end
	local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	if c>1 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local dis2=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,dis1)
		dis1=(dis1|dis2)
		if c>2 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local dis3=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,dis1)
			dis1=(dis1|dis3)
		end
	end
	return dis1
end
