--略奪猿ラガヴァン
--Ragavan, Nimble Pilferer
--zek
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--special summon [Dash 1R]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(1)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Effect on combat damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(s.ddcon)
	e2:SetTarget(s.ddtg)
	e2:SetOperation(s.ddop)
	c:RegisterEffect(e2)
	--pilfer
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.pilcost)
	e3:SetTarget(s.piltg)
	e3:SetOperation(s.pilop)
	c:RegisterEffect(e3)
end
--Dash 1R
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(s.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	c:RegisterEffect(e1)
	--res
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e3=e3:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
---Combat Damage
function s.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetDecktopGroup(1-tp,1)
		local tc=g:GetFirst()
		return tc and tc:IsAbleToRemove()
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function s.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,1)
	Duel.DisableShuffleCheck()
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,0,2000,4,RACE_ROCK,ATTRIBUTE_LIGHT) then		
	local token=Duel.CreateToken(tp,id+1)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
--pilfer
function s.costfilter(c)
	return c:IsCode(2690006557) and c:GetCode()~=id
end
function s.pilcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.costfilter,1,false,nil,nil) end
	local sg=Duel.SelectReleaseGroupCost(tp,s.costfilter,1,1,false,nil,nil)
	Duel.Release(sg,REASON_COST)
end
function s.pilfil(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function s.piltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and s.pilfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.pilfil,tp,0,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.pilfil,tp,0,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.pilop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end