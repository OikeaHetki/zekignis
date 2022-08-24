--No.95 ギャラクシーアイズ・ダークマター・ドラゴン
--Number 95: Galaxy-Eyes Dark Matter Dragon
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,9,3,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)
	c:EnableReviveLimit()
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.rmcon)
	e2:SetCost(s.rmcost)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.atkcon)
	e3:SetCost(s.atkcost)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
end
s.xyz_number=95
--additional xyz procedure
function s.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x107b,xyzc,SUMMON_TYPE_XYZ,tp) and c:IsType(TYPE_XYZ,xyzc,SUMMON_TYPE_XYZ,tp)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	return true
end
--on summon
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.cfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToGraveAsCost()
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>1
		and not Duel.IsPlayerAffectedByEffect(1-tp,30459350) end
end
function s.rmfilter(c)
	return c:IsAbleToRemove()
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(1-tp,30459350) then return end
	local g=Duel.GetMatchingGroup(s.rmfilter,1-tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,3,3,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
---atk
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0
		and e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK_MONSTER)==0 end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
