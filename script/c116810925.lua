--叶之妖精 琪露诺
function c116810925.initial_effect(c)
	c:EnableReviveLimit()
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c116810925.thcost)
	e1:SetTarget(c116810925.thtg)
	e1:SetOperation(c116810925.thop)
	c:RegisterEffect(e1)
	--To Grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c116810925.retcon)
	e2:SetTarget(c116810925.target)
	e2:SetOperation(c116810925.operation)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(116810925,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,116800925)
	e3:SetCondition(c116810925.negcon)
	e3:SetCost(c116810925.negcost)
	e3:SetTarget(c116810925.negtg)
	e3:SetOperation(c116810925.negop)
	c:RegisterEffect(e3)
end
function c116810925.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x3e6)
end
function c116810925.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c116810925.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c116810925.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c116810925.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c116810925.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c116810925.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c116810925.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3e6) and c:IsReleasableByEffect()
end
function c116810925.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.CheckReleaseGroupEx(tp,c116810925.filter1,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c116810925.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>3 then ct=3 end
	local g=Duel.SelectReleaseGroupEx(tp,c116810925.filter1,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local rct=Duel.Release(g,REASON_EFFECT)
		Duel.Draw(tp,rct,REASON_EFFECT)
	end
end
function c116810925.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c116810925.filter(c)
	return c:IsSetCard(0x3e6) and c:IsAbleToHand()
end
function c116810925.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c116810925.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c116810925.filter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c116810925.filter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c116810925.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end