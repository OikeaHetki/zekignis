--LL－アセンブリー・ナイチンゲール
--Assembled Nightingale
--zekpro version
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,id)
	Xyz.AddProcedure(c,nil,1,2,nil,nil,99)
	--ATK Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(s.raval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
  --  c:RegisterEffect(e3)
	--Cannot be destroyed by card effects while it has Xyz Material
  --  local e4=Effect.CreateEffect(c)
  --  e4:SetType(EFFECT_TYPE_SINGLE)
  --  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  --  e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  --  e4:SetRange(LOCATION_MZONE)
  --  e4:SetCondition(s.indcon)
  --  e4:SetValue(1)
  --  c:RegisterEffect(e4)
	--Cannot be destroyed by battle while it has Xyz Material
  --  local e5=Effect.CreateEffect(c)
  --  e5:SetType(EFFECT_TYPE_SINGLE)
  --  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  --  e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  --  e5:SetRange(LOCATION_MZONE)
  --  e5:SetCondition(s.indcon)
  --  e5:SetValue(1)
  --  c:RegisterEffect(e5)
	--remove material
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BATTLED)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetOperation(s.rmop)
	c:RegisterEffect(e6)
	--destroy equip
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,0))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_EQUIP)
	e7:SetTarget(s.destg)
	e7:SetOperation(s.desop)
	c:RegisterEffect(e7)
	--direct atk
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e8)
	--material check
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_MATERIAL_CHECK)
	e9:SetValue(s.valcheck)
	e9:SetLabelObject(e2)
	c:RegisterEffect(e9)
end
s.listed_series={0xf7}
function s.indcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function s.atkval(e,c)
	return c:GetOverlayCount()*200
end
function s.valcheck(e,c)
	local hc=e:GetHandler()
	local ct=hc:GetMaterial():GetCount(Card.GetCode,hc,SUMMON_TYPE_XYZ,hc:GetControler())
	e:GetLabelObject():SetLabel(ct)
end
function s.raval(e,c)
	local oc=e:GetHandler():GetLabel()
	return math.max(0,oc-1)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
function s.filter(c,ec)
	return c:GetEquipTarget()==ec
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter,1,nil,e:GetHandler()) end
	local dg=eg:Filter(s.filter,nil,e:GetHandler())
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	Duel.Destroy(tg,REASON_EFFECT)
end