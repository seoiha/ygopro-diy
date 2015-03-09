--炎之妖精 琪露诺
function c116810910.initial_effect(c)
	c:EnableReviveLimit()
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(116810910,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,116810841)
	e1:SetCondition(c116810910.setcon)
	e1:SetCost(c116810910.thcost)
	e1:SetTarget(c116810910.thtg)
	e1:SetOperation(c116810910.thop)
	c:RegisterEffect(e1)
	--To Grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c116810910.retcon)
	e2:SetTarget(c116810910.target)
	e2:SetOperation(c116810910.operation)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(116810910,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCountLimit(1,116800910)
	e3:SetCost(c116810910.atkcost)
	e3:SetCondition(c116810910.atkcond)
	e3:SetTarget(c116810910.atktg)
	e3:SetOperation(c116810910.atkop)
	c:RegisterEffect(e3)
end
function c116810910.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c116810910.rmfilter1,tp,LOCATION_GRAVE,0,2,nil) 
end
function c116810910.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c116810910.cfilter(c)
	return c:IsAbleToGrave()
end
function c116810910.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c116810910.cfilter,tp,0,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c116810910.cfilter,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c116810910.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c116810910.cfilter,tp,0,LOCATION_SZONE,nil)
	local ct=Duel.SendtoGrave(g,REASON_EFFECT)
	if ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*300)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c116810910.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3e6) 
end
function c116810910.atkcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c116810910.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c116810910.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c116810910.filter(chkc) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c116810910.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c116810910.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c116810910.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		e4:SetValue(900)
		tc:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_UPDATE_DEFENCE)
		tc:RegisterEffect(e5)
	end
end
function c116810910.rmfilter1(c)
	return c:IsSetCard(0x3e6) and c:IsType(TYPE_MONSTER) 
end
function c116810910.rmfilter(c)
	return c:IsSetCard(0x3e6) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c116810910.spfilter(c,e,tp)
	return c:IsSetCard(0x3e6) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c116810910.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c116810910.rmfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c116810910.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c116810910.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c116810909.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c116810909.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c116810909.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c116810910.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
