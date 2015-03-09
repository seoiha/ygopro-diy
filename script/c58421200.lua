--东洋的西洋魔术师 雾雨魔理沙
function c58421200.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(58421200,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c58421200.spcon)
	e1:SetTarget(c58421200.sptg)
	e1:SetOperation(c58421200.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetOperation(c58421200.regop)
	c:RegisterEffect(e2)
	--addown
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(58421200,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,58421200)
	e3:SetCondition(c58421200.thcon)
	e3:SetTarget(c58421200.adtg)
	e3:SetOperation(c58421200.adop)
	c:RegisterEffect(e3)
	if not c58421200.global_check then
		c58421200.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c58421200.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c58421200.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(58421200,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c58421200.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(58421200)>0
end
function c58421200.spfilter(c,e,tp)
	return c:IsSetCard(0x3d8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c58421200.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c58421200.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c58421200.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c58421200.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c58421200.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(58421201,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c58421200.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(58421201)>0 and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c58421200.filter(c)
	return c:IsFaceup()
end
function c58421200.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c58421200.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c58421200.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c58421200.filter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-600)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end