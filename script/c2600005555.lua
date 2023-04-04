--Delver of Secrets
--zek
local s,id=GetID()
function s.initial_effect(c)
	--insectile aberration
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--cannot be battle destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(s.incon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function s.incon(e)
	return e:GetHandler():IsAttackPos()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,2100,1600,5,RACE_INSECT,ATTRIBUTE_WIND) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		local token=Duel.CreateToken(tp,id+1)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	--Direct attack
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	token:RegisterEffect(e4,true)
	--Reduce damage
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetCondition(s.rdcon)
	e5:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	token:RegisterEffect(e5,true)
	else
	local opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	if opt==0 then
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
		end
	end
end
---dirattack
function s.rdcon(e)
	local c,tp=e:GetHandler(),e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end