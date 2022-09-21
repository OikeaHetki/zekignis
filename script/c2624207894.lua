--センサー万別
--Rivalry of Wizards
--zek
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.adjustop)
	c:RegisterEffect(e2)
	--cannot summon,spsummon,flipsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_FORCE_SPSUMMON_POSITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(s.sumlimit)
	e4:SetValue(POS_FACEDOWN)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e6)
end
s[0]={}
s[1]={}
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	local tp=sump
	if targetp then tp=targetp end
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsAttribute,c:GetAttribute()),tp,LOCATION_MZONE,0,1,c)
end
function s.fidfilter(c,fid)
	return c:GetFieldID()~=fid
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local sg=Group.CreateGroup()
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		local Attribute=1
		while (Attribute_ALL&Attribute)~=0 do
			local rg=g:Filter(Card.IsAttribute,nil,Attribute)
			local rc=#rg
			if rc>1 then
				local dg
				if s[p][Attribute] then
					dg=rg:Filter(s.fidfilter,nil,s[p][Attribute])
				else
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
					dg=rg:Select(p,rc-1,rc-1,nil)
				end
				sg:Merge(dg)
			end
			if rc==1 then
				s[p][Attribute]=rg:GetFirst():GetFieldID()
			end
			if rc==0 then
				s[p][Attribute]=nil
			end
			Attribute=Attribute*2
		end
	end
	if #sg>0 then
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Readjust()
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local rg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(rg,REASON_COST)
end