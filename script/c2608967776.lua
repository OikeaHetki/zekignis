--究極時械神セフィロン
--Sephylon, the Ultimate Timelord
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(s.distg)
	c:RegisterEffect(e4)
	--0 damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCondition(s.damcon)
	e5:SetOperation(s.damop)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.damcon2)
	e6:SetOperation(s.damop)
	c:RegisterEffect(e6)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,10,nil,TYPE_MONSTER)
end
function s.filter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:GetLevel()>=8
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(4000)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	tc:RegisterEffect(e3)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function s.distg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc or c:GetEffectCount(EFFECT_INDESTRUCTABLE_BATTLE)>0 then return false end
	if bc==Duel.GetAttackTarget() and bc:IsDefensePos() then return false end
	if c:IsAttackPos() and bc:IsDefensePos() and bc:GetEffectCount(EFFECT_DEFENSE_ATTACK)==1 
		and c:GetAttack()<=bc:GetDefense() then return true end
	if c:IsAttackPos() and (bc:IsAttackPos() or bc:IsHasEffect(EFFECT_DEFENSE_ATTACK)) 
		and c:GetAttack()<=bc:GetAttack() then return true end
	if c:IsDefensePos() and bc:IsDefensePos() and bc:GetEffectCount(EFFECT_DEFENSE_ATTACK)==1 
		and c:GetDefense()<bc:GetDefense() then return true end
	if c:IsDefensePos() and (bc:IsAttackPos() or bc:IsHasEffect(EFFECT_DEFENSE_ATTACK)) 
		and c:GetDefense()<bc:GetAttack() then return true end
	return false
end
function s.repfilter(c)
	return c:IsSetCard(0x4a) and c:IsFaceup() and c:IsAbleToRemove()
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (e:GetCode()~=EVENT_PRE_DAMAGE_CALCULATE or c:IsRelateToBattle()) and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_MZONE,0,1,c) and Duel.SelectYesNo(tp,aux.Stringid(40945356,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_MZONE,0,1,1,c)
		Duel.Remove(g,POS_FACEUP,REASON_REPLACE+REASON_EFFECT)
		if e:GetCode()==EVENT_PRE_DAMAGE_CALCULATE then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
			e1:SetOperation(s.damopx)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetValue(1)
			e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
			c:RegisterEffect(e2)
		else
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e3:SetValue(1)
			e3:SetReset(RESET_CHAIN)
			c:RegisterEffect(e3)
		end
	end
end
function s.damopx(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
function s.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if tg==nil then return false end
	return ex and tg:IsContains(e:GetHandler()) and tc+1-#tg==1
end
