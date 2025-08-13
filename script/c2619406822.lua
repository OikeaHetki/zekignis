--コトダマ
--Kotodama
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--to defense
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.potg)
	e1:SetOperation(s.poop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--adjust
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(s.adjustop)
	c:RegisterEffect(e3)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e3:SetLabelObject(g)
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
function s.filter(c,g,pg)
	if pg:IsContains(c) then return false end
	local code=c:GetCode()
	return g:IsExists(Card.IsCode,1,c,code) or pg:IsExists(Card.IsCode,1,c,code)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	local pg=e:GetLabelObject()
	if c:GetFlagEffect(id)==0 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD_DISABLE,0,1)
		pg:Clear()
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local dg=g:Filter(s.filter,nil,g,e:GetLabelObject())
	if #dg==0 or Duel.Destroy(dg,REASON_EFFECT)==0 then
		pg:Clear()
		pg:Merge(g)
		pg:Sub(dg)
	else
		g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		pg:Clear()
		pg:Merge(g)
		pg:Sub(dg)
		Duel.Readjust()
	end
end
