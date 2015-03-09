--水之妖精 琪露诺
function c116810909.initial_effect(c)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetDescription(aux.Stringid(116810909,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c116810909.condition)
	e1:SetTarget(c116810909.target)
	e1:SetOperation(c116810909.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(116810909,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,116810909)
	e2:SetCost(c116810909.spcost)
	e2:SetTarget(c116810909.sptg)
	e2:SetOperation(c116810909.spop)
	c:RegisterEffect(e2)
	--Disable1
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLED)
	e4:SetOperation(c116810909.disop)
	c:RegisterEffect(e4)
	--Disable
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(116810909,2))
	ea:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	ea:SetCode(EVENT_BATTLED)
	ea:SetCondition(c116810909.condition1)
	ea:SetOperation(c116810909.operation1)
	c:RegisterEffect(ea)
	--[[indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(116810909,1))
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c116810909.con)
	e2:SetCost(c116810909.cost)
	e2:SetOperation(c116810909.op)
	c:RegisterEffect(e2)]]
end
--[[
function c116810909.con(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	return (a:GetControler()==tp and a:IsSetCard(0x3e6))
		or (d:GetControler()==tp and d:IsSetCard(0x3e6))
end
function c116810909.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c116810909.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
	if not a:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(1)
	a:RegisterEffect(e1)
end]]
function c116810909.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	local c=e:GetHandler()
	if c==tc then tc=Duel.GetAttacker() end
	if tc and tc:IsType(TYPE_EFFECT) and tc:IsStatus(STATUS_BATTLE_DESTROYED) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x17a0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x17a0000)
		tc:RegisterEffect(e2)
	end
end
function c116810909.condition1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	if a==c then a=Duel.GetAttackTarget() end
	e:SetLabelObject(a)
	return a and a:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND+ATTRIBUTE_DARK+ATTRIBUTE_DEVINE) and a:IsRelateToBattle()
end
function c116810909.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() or not tc:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x57a0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x57a0000)
	tc:RegisterEffect(e2)
end
function c116810909.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c116810909.filter(c,def)
	return c:IsFaceup() and c:GetDefence()<=def and c:IsDestructable()
end
function c116810909.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c116810909.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetDefence())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c116810909.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c116810909.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetDefence())
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
	  Duel.Recover(tp,ct*1000,REASON_EFFECT)
	end
end
function c116810909.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c116810909.spfilter(c,e,tp)
	return c:IsSetCard(0x3e6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c116810909.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c116810909.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c116810909.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c116810909.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c116810909.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end