--frog resurrection
--zekpro
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,(id,EFFECT_COUNT_CODE_OATH})
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.filter(c,e,tp)
	return c:IsLevelBelow(2) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local g=nil
	if #tg>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=tg:Select(tp,ft,ft,nil)
	else
		g=tg
	end
	if #g>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
		Duel.SpecialSummonComplete()
		g:KeepAlive()
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_PHASE+PHASE_END)
		e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetCountLimit(1)
		e0:SetLabel(fid)
		e0:SetLabelObject(g)
		e0:SetCondition(s.rmcon)
		e0:SetOperation(s.rmop)
		Duel.RegisterEffect(e0,tp)
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetOperation(s.aclimit1)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetOperation(s.aclimit2)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetCondition(s.econ)
	e4:SetValue(1)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetReset(RESET_PHASE+PHASE_END)
	e5:SetTargetRange(1,0)
	Duel.RegisterEffect(e5,tp)
end
function s.rmfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(s.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(s.rmfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
function s.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	Duel.ResetFlagEffect(tp,id)
end
function s.econ(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)~=0
end