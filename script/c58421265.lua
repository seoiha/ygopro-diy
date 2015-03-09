--魔炮「究极火花」
function c58421265.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c58421265.sgcon)
	e1:SetCost(c58421265.sgcost)
	e1:SetTarget(c58421265.sgtg)
	e1:SetOperation(c58421265.sgop)
	c:RegisterEffect(e1)
end
function c58421265.confilter1(c)
	return c:IsFaceup() and c:IsCode(58421255) 
end
function c58421265.confilter2(c)
	return c:IsFaceup() and  c:IsSetCard(0x3d8)
end
function c58421265.sgcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c58421265.confilter1,tp,LOCATION_SZONE,0,1,nil) and
	Duel.IsExistingMatchingCard(c58421265.confilter2,tp,LOCATION_ONFIELD,0,1,nil) 
end
function c58421265.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0  and Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BP)
	Duel.RegisterEffect(e2,tp)
end
function c58421265.filter1(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c58421265.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c58421265.filter1,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SelectOption(1-tp,aux.Stringid(58421265,1))
	Duel.SelectOption(tp,aux.Stringid(58421265,1))
end
function c58421265.sgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c58421265.filter1,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

