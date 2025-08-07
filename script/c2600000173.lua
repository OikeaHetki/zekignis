--メテオフレア・フュージョン
--Meteor Flare Fusion
--zek
local s,id=GetID()
function s.initial_effect(c)
	Fusion.RegisterSummonEff{handler=c,matfilter=s.matfilter,extrafil=s.fextra,mincount=2,maxcount=2,stage2=s.stage2}
end
s.listed_names={CARD_REDEYES_B_DRAGON,CARD_SUMMONED_SKULL,64271667}
function s.matfilter(c)
	return c:IsLocation(LOCATION_HAND|LOCATION_MZONE) and c:IsAbleToGrave()
end
function s.checkmat(tp,sg,fc)
	return sg:IsExists(Card.IsSummonCode,1,nil,fc,SUMMON_TYPE_FUSION,tp,CARD_REDEYES_B_DRAGON,CARD_SUMMONED_SKULL,64271667)
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(nil,tp,LOCATION_HAND|LOCATION_MZONE,0,nil),s.checkmat
end
function s.stage2(e,tc,tp,sg,chk)
	if chk==0 and not tc:IsType(TYPE_EFFECT) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,e:GetHandler())
	Duel.BreakEffect()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(CARD_REDEYES_B_DRAGON)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end