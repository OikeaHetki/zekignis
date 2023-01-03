--デストーイ・シザー・ウルフ
--Frightfur Wolf
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0xc3),aux.FilterBoolFunctionEx(Card.IsSetCard,0xa9))
	--multi
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end
s.listed_series={0xa9}
s.material_setcode={0xa9,0xc3}
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c:GetMaterialCount()-1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	c:RegisterEffect(e1)
end
