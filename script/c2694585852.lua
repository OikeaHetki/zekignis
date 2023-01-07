--万魔殿－悪魔の巣窟－
--Pandemonium
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Alter LP cost for "Archfiend" monsters during the Standby Phase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_LPCOST_REPLACE)
	e2:SetCondition(s.lrcon)
	c:RegisterEffect(e2)
	--Search an "Archfiend" monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	aux.GlobalCheck(s,function()
		--Global effect since either player can use this effect
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(s.desreptg)
	e4:SetOperation(s.desrepop)
	c:RegisterEffect(e4)
end
s.listed_series={0x45}
function s.regfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsSetCard(0x45) and c:HasLevel()
		and (c:IsPreviousLocation(LOCATION_MZONE) or (not c:IsPreviousLocation(LOCATION_MZONE) and c:IsMonster()))
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local lv1=0
	local lv2=0
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	for tc in aux.Next(eg) do
		if s.regfilter(tc) then
			local tlv=tc:GetLevel()
			if tc:IsControler(0) then
				if tlv>lv1 then lv1=tlv end
			else
				if tlv>lv2 then lv2=tlv end
			end
		end
	end
	if lv1>0 then Duel.RaiseEvent(g1,EVENT_CUSTOM+id,re,r,rp,0,lv1) end
	if lv2>0 then Duel.RaiseEvent(g1,EVENT_CUSTOM+id,re,r,rp,1,lv2) end
end
function s.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return Duel.GetCurrentPhase()==PHASE_STANDBY and rc:IsSetCard(0x45) and rc:IsMonster()
end
function s.filter(c,lv)
	return c:GetLevel()<lv and c:IsSetCard(0x45) and c:IsMonster() and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,ev) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,ev)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE+REASON_RULE)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,nil,0x45) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,2))
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,Card.IsSetCard,1,1,REASON_EFFECT+REASON_DISCARD,nil,0x45)
end
