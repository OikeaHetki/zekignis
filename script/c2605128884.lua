--E・HERO トゥインクルネオス
--E・HERO Twinkle Neos
--zek
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCode2(c,CARD_NEOS,2613857930,false,false)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
end
s.listed_names={CARD_NEOS}
s.material_setcode={0x8,0x3008,0x9,0x1f}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() or e:GetHandler()==Duel.GetAttackTarget()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,2,REASON_EFFECT)
	if c:IsFaceup() and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end