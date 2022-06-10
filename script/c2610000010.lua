--ラーの翼神竜
--The Winged Dragon of Ra
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--summon with 3 tribute
	local e1=aux.AddNormalSummonProcedure(c,true,false,3,3)
	local e2=aux.AddNormalSetProcedure(c)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(s.sumsuc)
	c:RegisterEffect(e4)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--to grave
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCondition(s.tgcon)
	e6:SetTarget(s.tgtg)
	e6:SetOperation(s.tgop)
	c:RegisterEffect(e6)
	--cannot release
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_RELEASE)
	e7:SetTargetRange(0,1)
	e7:SetTarget(s.relval)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e8)
	--cannot control
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e9)
	--Also treated as another race
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_ADD_RACE)
	e10:SetValue(RACE_DRAGON)
	c:RegisterEffect(e10)
	--One Turn Kill
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,1))
	e11:SetCategory(CATEGORY_ATKCHANGE)
	e11:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetOperation(s.atkop)
	c:RegisterEffect(e11)
	--destroy
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(id,2))
	e12:SetCategory(CATEGORY_DESTROY)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCost(s.descost)
	e12:SetTarget(s.destg)
	e12:SetOperation(s.desop)
	c:RegisterEffect(e12)
end
function s.relval(e,c)
	return c==e:GetHandler()
end
function s.genchainlm(c)
	return function (e,rp,tp)
				return e:GetHandler()==c
			end
end
function s.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(s.genchainlm(e:GetHandler()))
end
function s.spval(e,se,sp,st)
	return st==SUMMON_TYPE_SPECIAL+SUMMON_WITH_MONSTER_REBORN and Duel.IsPlayerAffectedByEffect(sp,41044418)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp=Duel.GetLP(tp)
	local maxc=lp-100
	maxc=math.floor(maxc/100)*100
	local t={}
	for i=1,maxc/100 do
		t[i]=i*100
	end
	local val=Duel.AnnounceNumber(tp,table.unpack(t))
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
