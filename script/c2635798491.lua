--ダークビショップデーモン
--Darkbishop Archfiend
--zekpro remastered version
local s,id=GetID()
function s.initial_effect(c)
	--500 LP Maintenance Cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(function(_,tp) return Duel.IsTurnPlayer(tp) end)
	e1:SetOperation(s.mtop)
	c:RegisterEffect(e1)
	--roll a d6 (shared)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.atklm)
	e3:SetValue(aux.imval2)
	c:RegisterEffect(e3)
end
s.listed_series={0x45}
s.roll_dice=true
--maintain
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.PayLPCost(tp,500)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
--roll to negate (shared)
function s.filter(c,tp,re)
	return c:IsSetCard(SET_ARCHFIEND) and c:IsRelateToEffect(re) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsFaceup()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and ep==1-tp) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsExists(s.filter,1,nil,tp,re) or not Duel.IsChainDisablable(ev) then return false end
	local rc=re:GetHandler()
	Duel.Hint(HINT_CARD,1-tp,id)
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==3 or dc==6 then
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end
--personal effects
function s.atklm(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_FIEND),c:GetControler(),LOCATION_MZONE,0,1,c)
end