--霊糸の幻
--Gossamer Phantasm
--zek
local s,id=GetID()
function s.initial_effect(c)
	--Direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--Reduce damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetCondition(s.rdcon)
	e2:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	c:RegisterEffect(e2)
	--self des
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(s.sdcon)
	c:RegisterEffect(e3)
	--be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetOperation(s.desop1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_BATTLED)
	e5:SetOperation(s.desop2)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EVENT_BECOME_TARGET)
	e6:SetOperation(s.register)
	c:RegisterEffect(e6)
end
--dirattk
function s.rdcon(e)
	local c,tp=e:GetHandler(),e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
--selfdes
function s.sdcon(e)
	return e:GetHandler():GetOwnerTargetCount()>0
end
function s.register(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id+1,RESET_CHAIN,0,1,ev)
end
function s.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	for _,ch in ipairs({c:GetFlagEffectLabel(id+1)}) do
		if ch==ev then
			if (Duel.GetCurrentPhase()&(PHASE_DAMAGE|PHASE_DAMAGE_CAL))~=0 and not Duel.IsDamageCalculated() then
				c:RegisterFlagEffect(id,RESET_PHASE|PHASE_DAMAGE|RESETS_STANDARD,0,1)
			elseif not c:IsHasEffect(EFFECT_DISABLE) and not c:IsDisabled() then
				Duel.Destroy(c,REASON_EFFECT)
			end
			return
		end
	end
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)>0 and not c:IsHasEffect(EFFECT_DISABLE) and not c:IsDisabled() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end