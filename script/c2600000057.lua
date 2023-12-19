--  Ｄ－ＨＥＲＯ 恐ろしい敵
--Destiny HERO - Dreadversary
--zek
local s,id=GetID()
function s.initial_effect(c)
	--Change battle position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--activate CTP
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,id)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.actg)
	e3:SetOperation(s.acop)
	c:RegisterEffect(e3)
	--base attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e5)
end
s.counter_place_list={0x1b}
s.listed_names={75041269,35787450}
function s.filter(c,tp)
	return c:IsCode(75041269) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
	if tc and tc:IsFaceup() and tc:IsCode(75041269) then
		tc:AddCounter(0x1b,1) --place the CTB counter
	end
end
function s.setfilter(c)
	return c:IsCode(35787450) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE+LOCATION_DECK,LOCATION_GRAVE,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE+LOCATION_DECK,LOCATION_GRAVE,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
		--Can be activated this turn
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		g:GetFirst():RegisterEffect(e1)
	end
end
function s.atkval(e,c)
	return c:GetLevel()*300
end