--遠心分離フィールド
--Centrifugal Field
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_EVENT_PLAYER)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.check1)
		Duel.RegisterEffect(ge1,0)
	end)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FUSION))
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--Def down
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(500)
	c:RegisterEffect(e4)
end
function s.check1(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsType(TYPE_FUSION) and tc:IsReason(REASON_DESTROY) and (tc:IsReason(REASON_EFFECT) or tc:IsReason(REASON_BATTLE)) then
			Duel.RaiseEvent(tc,EVENT_CUSTOM+id,re,r,rp,tc:GetOwner(),ev)
		end
	end
end
function s.spfilter(c,e,tp,fc)
	return fc:ListsCodeAsMaterial(c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local fc=eg:GetFirst()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp,fc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,fc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,fc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end