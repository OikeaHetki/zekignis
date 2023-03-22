--地底街の密告人
--[Undercity Informer]
--zek
local s,id=GetID()
function s.initial_effect(c)
	--Mill cards until the player sends a land card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,nil,1,false,nil,nil) end
	local sg=Duel.SelectReleaseGroupCost(tp,nil,1,1,false,nil,nil)
	Duel.Release(sg,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,1) or Duel.IsPlayerCanDiscardDeck(tp,1) end
	local opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	local p=(opt==0 and tp or 1-tp)
	Duel.SetTargetPlayer(p)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,p,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(Card.IsType,p,0,LOCATION_DECK,nil,TYPE_MONSTER)
	local dcount=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
	if dcount==0 then return end
	if #g==0 then
		Duel.ConfirmDecktop(p,dcount)
		Duel.DiscardDeck(p,dcount,REASON_EFFECT+REASON_REVEAL)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	for tc in aux.Next(g) do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			spcard=tc
		end
	end
	Duel.ConfirmDecktop(p,dcount-seq)
	if spcard:IsAbleToGrave() then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(spcard,REASON_EFFECT)
		Duel.DiscardDeck(p,dcount-seq-1,REASON_EFFECT+REASON_REVEAL)
	else Duel.DiscardDeck(p,dcount-seq,REASON_EFFECT+REASON_REVEAL) end
end