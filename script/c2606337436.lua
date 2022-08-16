--DRC
--Dragon's Rage Channeler
--zek
local s,id=GetID()
function s.initial_effect(c)
	--surveil
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(s.survop)
	c:RegisterEffect(e1)
	--Original ATK becomes 2000
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetCondition(s.drccon)
	e2:SetValue(2000)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e3)
	--Direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(s.drccon)
	c:RegisterEffect(e4)
	--Reduce damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetCondition(s.rdcon)
	e5:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	c:RegisterEffect(e5)
	--must attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCondition(s.drccon)
	e6:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e6)
end
--dragon's rage condition
function s.drccon(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsType,TYPE_SPELL),0,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsType,TYPE_TRAP),0,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsType,TYPE_MONSTER),0,LOCATION_GRAVE,0,1,nil)
end
--surveil operation
function s.survop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetActiveType()==0x4+0x2
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp then
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.ConfirmCards(tp,g)
	local tc=g:GetFirst()
	local opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	if opt==1 then
		Duel.DiscardDeck(tp,1,REASON_COST)
		end
	end
end
---dirattack
function s.rdcon(e)
	local c,tp=e:GetHandler(),e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end