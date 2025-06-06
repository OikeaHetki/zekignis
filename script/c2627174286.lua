--異次元からの帰還
--Return from the Different Dimension
--zekpro version (summons up to opponent's monsters)
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function(_,tp) return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if ft<=0 then return false end
	Duel.BreakEffect()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local ct=ft
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		if ft>1 then
			local selct = {}
			for i=1,ft do selct[i]=i end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
			ct=Duel.AnnounceNumber(tp,table.unpack(selct))
		end
		for i=1,ct do
			local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_REMOVED,0,ft,ft,nil,e,tp)
	if #g>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
		Duel.SpecialSummonComplete()
		g:KeepAlive()
		--remove at end phase
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(s.rmcon)
		e1:SetOperation(s.rmop)
		Duel.RegisterEffect(e1,tp)
		end
	end
end
--resolve remove at end phase
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
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end