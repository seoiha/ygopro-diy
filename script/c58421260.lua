--デルタ・クロウ－アンチ・リバース
function c58421260.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c58421260.condition)
	e1:SetTarget(c58421260.target)
	e1:SetOperation(c58421260.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c58421260.handcon)
	c:RegisterEffect(e2)
end
function c58421260.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x3d8)
end
function c58421260.handcon(e)
	return Duel.IsExistingMatchingCard(c58421260.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)
end
function c58421260.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3d8) and c:IsType(TYPE_MONSTER)
end
function c58421260.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c58421260.cfilter,tp,LOCATION_GRAVE,0,1,nil)
	   and Duel.IsExistingMatchingCard(c58421260.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c58421260.filter(c)
	return c:IsDestructable()
end
function c58421260.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c58421260.filter,tp,0,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c58421260.filter,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SelectOption(1-tp,aux.Stringid(58421260,1))
	Duel.SelectOption(tp,aux.Stringid(58421260,1))
end
function c58421260.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c58421260.filter,tp,0,LOCATION_SZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
