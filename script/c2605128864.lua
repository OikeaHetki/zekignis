--E・HERO Inferno Neos
--zek
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCode2(c,CARD_NEOS,2613857940,false,false)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
end
s.listed_names={CARD_NEOS}
s.material_setcode={0x8,0x3008,0x9,0x1f}
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE+LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)*400
end
