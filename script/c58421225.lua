--スピード・ウォリアー
function c58421225.initial_effect(c)
	--attack twice
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(58421225,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,58421227)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c58421225.atcon)
	e1:SetTarget(c58421225.attg)
	e1:SetOperation(c58421225.atop)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,58421225)
	e3:SetCondition(c58421225.spcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_TO_HAND)
	e5:SetCondition(c58421225.regcon)
	e5:SetOperation(c58421225.regop)
	c:RegisterEffect(e5)
	if not c58421225.global_check then
		c58421225.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c58421225.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c58421225.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(58421225,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c58421225.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=1 and Duel.GetCurrentPhase()==PHASE_MAIN1 and e:GetHandler():GetFlagEffect(58421225)>0
		and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_BP)
end
function c58421225.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3d8) and c:GetEffectCount(EFFECT_EXTRA_ATTACK)==0
end
function c58421225.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c58421225.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c58421225.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c58421225.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c58421225.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e1)
	end
end
function c58421225.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c58421225.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and e:GetHandler():IsPreviousLocation(LOCATION_DECK) --eg:IsExists(c584212255.cfilter,1,nil,tp)
end
function c58421225.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(58421225,1)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(58421226,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c58421225.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():GetFlagEffect(58421226)>0
end