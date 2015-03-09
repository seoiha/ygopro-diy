--风之妖精 琪露诺
function c116810927.initial_effect(c)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,116810927)
	e1:SetCost(c116810927.indcost)
	e1:SetTarget(c116810927.indtg)
	e1:SetOperation(c116810927.indop)
	c:RegisterEffect(e1)
	--To Grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c116810927.retcon)
	e2:SetTarget(c116810927.target)
	e2:SetOperation(c116810927.operation)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(116810927,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c116810927.atkcost)
	e3:SetOperation(c116810927.atkop)
	c:RegisterEffect(e3)
end
function c116810927.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3e6)
end
function c116810927.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c116810927.costfilter,1,e:GetHandler()) end
	local rg=Duel.SelectReleaseGroup(tp,c116810927.costfilter,1,1,e:GetHandler())
	e:SetLabel(rg:GetFirst():GetAttack())
	Duel.Release(rg,REASON_COST)
end
function c116810927.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c116810927.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c116810927.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3e6)
end
function c116810927.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c116810927.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c116810927.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c116810927.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c116810927.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e1=e1:Clone()
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e1)
	end
end
function c116810927.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c116810927.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3e6) and c:IsReleasableByEffect()
end
function c116810927.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x3e6) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c116810927.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x3e6)*200
	Duel.Damage(p,d,REASON_EFFECT)
end