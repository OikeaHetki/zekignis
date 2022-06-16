--交差する魂
--Soul Crossing
--zekpro version
--by Rundas, with tweaks from zek
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1,g2,g3,g4=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil),Duel.GetMatchingGroup(Card.IsReleasable,tp,0,LOCATION_MZONE,nil),Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler()),
	Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_HAND,0,nil,RACE_DIVINE)
	if chk==0 then
		if #g4==1 then
			return #g4>0 and (aux.SelectUnselectGroup(g1+g2,e,tp,3,3,s.rescon(g1,g2,g3-g4,g4),0) or #g1>=3)
		else
			return #g4>0 and (aux.SelectUnselectGroup(g1+g2,e,tp,3,3,s.rescon(g1,g2,g3,g4),0) or #g1>=3)
		end
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1,g2,g3,g4=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil),Duel.GetMatchingGroup(Card.IsReleasable,tp,0,LOCATION_MZONE,nil),Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler()),
	Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_HAND,0,nil,RACE_DIVINE)
	if not (Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_HAND,0,1,nil,RACE_DIVINE) and (aux.SelectUnselectGroup(g1+g2,e,tp,3,3,s.rescon(g1,g2,g3,g4),0) or #g1>=3)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_HAND,0,1,1,nil,RACE_DIVINE):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	local choice=aux.SelectEffect(tp,{aux.SelectUnselectGroup(g1+g2,e,tp,3,3,s.rescon(g1,g2,g3,g4),0),aux.Stringid(id,1)},{#g1>=3,aux.Stringid(id,2)})
	if choice==2 then
		Duel.Summon(tp,tc,false,nil)
	else
		local g=aux.SelectUnselectGroup(g1+g2,e,tp,3,3,s.rescon(g1,g2,g3,g4),1,tp,HINTMSG_RELEASE,nil,nil)
		Duel.HintSelection(g)
		local g5=aux.SelectUnselectGroup(g3-g-Group.FromCards(tc),e,tp,#(g&g2),#(g&g2),aux.ChkfMMZ(1),1,tp,HINTMSG_TOGRAVE,nil,nil)
		Duel.Release(g,REASON_EFFECT)
		Duel.SendtoGrave(g5,REASON_EFFECT)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
	end
end
function s.rescon(g1,g2,g3,g4)
	return function(sg,e,tp,mg)
		if #g4>1 then
			return #(sg&g2)<=#g3
		else
			return #(sg&g2)<=#g3-1
		end
	end
end