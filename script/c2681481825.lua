--オジャマ・ゴールド
--Ojama Gold
--zek
local s,id=GetID()
function s.initial_effect(c)
	--name change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.nametg)
	e1:SetOperation(s.nameop)
	c:RegisterEffect(e1)
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(s.subval)
	c:RegisterEffect(e2)
end
s.listed_series={0xf}
function s.nametg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local code=e:GetHandler():GetCode()
	--"Gadget" monster, except this card's current name
	s.announce_filter={0xf,OPCODE_ISSETCARD,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(s.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function s.nameop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function s.subval(e,c)
	return c:IsSetCard(0xf)
end
