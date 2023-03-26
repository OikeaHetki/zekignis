--陰謀団式療法
--Cabal Therapy
--zek
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--act in gy
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.gycon)
	e2:SetCost(s.gycost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--verify the starting deck possesses 50 cards
	aux.GlobalCheck(s,function()
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_STARTUP)
	ge1:SetOperation(s.checkop)
	Duel.RegisterEffect(ge1,0) end)
end
--deckcheck
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(0,LOCATION_DECK,0)
	Duel.RegisterFlagEffect(0,id,0,0,1,ct1)
	local ct2=Duel.GetFieldGroupCount(1,LOCATION_DECK,0)
	Duel.RegisterFlagEffect(1,id,0,0,1,ct2)
end
--therapy
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	s.announce_filter={TYPE_EXTRA,OPCODE_ISTYPE,TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_AND,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(s.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
end
function s.cfilter(c,ft,tp)
	return ft>0 or (c:IsControler(tp) or c:GetSequence()<5)
end
function s.gycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffectLabel(tp,id)>=55
end
function s.gycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk) 
		and Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,nil,ft,tp) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end