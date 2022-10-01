--黒蠍盗掘団
--Dark Scorpion Burglars
--link monster re-train
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure
	Link.AddProcedure(c,s.matfilter,1,1)
	--Upon link summoned, add "Dark Scorpion" Spell/Trap, or "Don Zaloog"
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.thcon)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetTarget(s.diratktg)
	e3:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e3)
end
s.listed_series={0x1a}
s.listed_names={76922029}
--one dark scorpion, except id
function s.matfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x1a,lc,sumtype,tp) and not c:IsType(lc,type,tp,TYPE_LINK)
end
--direct attack tg
function s.diratktg(c)
	return (c:IsSetCard(0x1a) or c:IsCode(76922029))
end
--Check for "Dark Scorpion" ST or "Don Zaloog"
function s.thfilter(c)
	return (c:IsSetCard(0x1a) and c:IsSpellTrap()) and c:IsAbleToHand()
end
--If link summoned
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
--verify the effect has not been used this turn
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
end
--Activation legality
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--Add 1 "Dark Scorpion" monster or "Don Zaloog" from deck to hand
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if Duel.GetFlagEffect(tp,id)~=0 then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetLabelObject(c)
	e1:SetCondition(s.sumcon2)
	e1:SetValue(s.sumval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsLocation(LOCATION_MZONE)
end
function s.sumval(e,c)
	local c=e:GetLabelObject()
	local sumzone=c:GetLinkedZone()
	local relzone=0x7f007f&~(1<<c:GetSequence())
	return 0,sumzone,relzone
end
--splimit from effect
function s.splimit(e,c)
	return not ((c:IsSetCard(0x1a) or c:IsCode(76922029)))
end
--reason player
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end