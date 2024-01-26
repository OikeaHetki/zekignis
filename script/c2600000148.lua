--Gorgon of Dark Magic
--zek
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,511018031,511018032,511018033)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit,aux.TRUE,1)
	--extra attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetCondition(s.atkcon)
	e1:SetValue(2)
	c:RegisterEffect(e1)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.atkcon(e)
	return e:GetHandler():GetSummonLocation()&LOCATION_EXTRA==LOCATION_EXTRA
end