--聖域の歌声
--Chorus of Sanctuary
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetTarget(s.efilter)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(s.efilter)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(s.reptg)
	e4:SetValue(s.repval)
	c:RegisterEffect(e4)
end
--lprec
function s.refilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rec1=Duel.GetMatchingGroupCount(s.refilter,tp,LOCATION_ONFIELD,0,nil)*300
	local rec2=Duel.GetMatchingGroupCount(s.refilter,1-tp,0,LOCATION_ONFIELD,nil)*300
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,rec2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local rec1=Duel.GetMatchingGroupCount(s.refilter,tp,LOCATION_ONFIELD,0,nil)*300
	local rec2=Duel.GetMatchingGroupCount(s.refilter,1-tp,0,LOCATION_ONFIELD,nil)*300
	Duel.Recover(tp,rec1,REASON_EFFECT)
	Duel.Recover(1-tp,rec2,REASON_EFFECT)
end
--atkdef filter
function s.efilter(e,c)
	return c:IsType(TYPE_NORMAL)
end
--desrep
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.tgfilter(c)
	return c:IsAbleToGrave()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) and #eg==1
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.Hint(HINT_CARD,0,id)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
