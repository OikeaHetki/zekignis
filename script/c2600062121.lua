--闇晦ましの城
--Castle of Dark Illusion
--zekpro version with face-down attack position
local s,id=GetID()
function s.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_LIMIT_SET_PROC)
	e1:SetCondition(s.ttcon)
	e1:SetTarget(s.tttg)
	e1:SetOperation(s.ttop)
	e1:SetTargetRange(POS_FACEDOWN,0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TRUE)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--to defense
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(s.potg)
	e3:SetOperation(s.poop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetTarget(s.target)
	e5:SetOperation(s.activate)
	c:RegisterEffect(e5)
	--shuffle
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCountLimit(1)
	e6:SetTarget(s.postg)
	e6:SetOperation(s.posop)
	c:RegisterEffect(e6)
end
function s.ttcon(e,c)
	if c==nil then return true end
	min,max=c:GetTributeRequirement()
	return Duel.CheckTribute(c,min,max)
end
function s.tttg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	min,max=c:GetTributeRequirement()
	local g=Duel.SelectTribute(tp,c,min,max,nil,nil,nil,true)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	g:DeleteGroup()
end
function s.potg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function s.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK,0,POS_FACEDOWN_DEFENSE,0)
	end
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MMZONE,0,2,nil) end
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MMZONE,0,nil)
	Duel.ShuffleSetCard(g)
end
