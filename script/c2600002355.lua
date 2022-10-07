--夢の洞窟のルールス
--Lurrus, of the Dream Den
--zek
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,s.matfilter,3,2,s.ovfilter,aux.Stringid(id,0),99,s.xyzop)
	c:EnableReviveLimit()
	--act from gy then banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
end
--
function s.matfilter(c,xyz,sumtype,tp)
	return c:IsRace(RACE_PSYCHIC,xyz,sumtype,tp) and (c:IsAttribute(ATTRIBUTE_LIGHT,xyz,sumtype,tp) or c:IsAttribute(ATTRIBUTE_DARK,xyz,sumtype,tp))
end
--
function s.cfilter(c)
	return c:IsSpellTrap() and c:IsDiscardable()
end
function s.gyrfilter(c)
	return not (c:IsRankBelow(2) or c:IsLevelBelow(2) or c:IsLinkBelow(2)) 
end
function s.ovfilter(c,tp,lc)
	local g=Duel.GetMatchingGroup(Card.IsMonster,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	return #g>0 and not g:IsExists(s.gyrfilter,1,nil)
	and c:IsFaceup() and (c:IsRankBelow(2) or c:IsLevelBelow(2) or c:IsLinkBelow(2)) 
end
function s.xyzop(e,tp,chk,mc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND,0,nil):SelectUnselect(Group.CreateGroup(),tp,false,Xyz.ProcCancellable)
	if tc then
		Duel.SendtoGrave(tc,REASON_DISCARD+REASON_COST)
		return true
	else return false end
end
--
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,nil,aux.Stringid(id,2))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(s.operation)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.filter(c)
	return c:IsSpellTrap() and c:GetFlagEffect(id)==0
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
	for tc in aux.Next(g) do
		local te=tc:GetActivateEffect()
		if te then
			local e1=te:Clone()
			e1:SetRange(LOCATION_GRAVE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
