--暗之妖精 琪露诺
function c116810938.initial_effect(c)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(116810938,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c116810938.rmcost)
	e1:SetTarget(c116810938.rmtg)
	e1:SetOperation(c116810938.rmop)
	c:RegisterEffect(e1)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3e6))
	c:RegisterEffect(e4)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(116810938,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c116810938.descon)
	e2:SetTarget(c116810938.destg)
	e2:SetOperation(c116810938.desop)
	c:RegisterEffect(e2)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(116810938,4))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c116810938.descon1)
	e6:SetTarget(c116810938.destg1)
	e6:SetOperation(c116810938.desop1)
	c:RegisterEffect(e6)
end
function c116810938.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c116810938.desfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c116810938.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local rc=Duel.AnnounceAttribute(tp,1,0xff)
	Duel.SetTargetParam(rc)
	e:GetHandler():SetHint(CHINT_ATTRIBUTE,rc)
	local g=Duel.GetMatchingGroup(c116810938.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c116810938.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(c116810938.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,rc)
	Duel.Destroy(g,REASON_EFFECT)
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetTarget(c116810938.sumlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetLabel(rc)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		c:RegisterEffect(e2)
	end
end
function c116810938.sumlimit(e,c)
	return c:IsAttribute(e:GetLabel())
end
function c116810938.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c116810938.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3e6) and c:IsAbleToRemove()
end
function c116810938.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c116810938.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c116810938.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c116810938.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c116810938.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetCondition(c116810938.retcon)
		e1:SetOperation(c116810938.retop)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
			e1:SetLabel(0)
		else
			e1:SetLabel(Duel.GetTurnCount())
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c116810938.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel()
end
function c116810938.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
	e:Reset()
end
function c116810938.desfilter1(c)
	return not c:IsSetCard(0x3e6)
end
function c116810938.descon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
	    and Duel.IsExistingMatchingCard(c116810938.desfilter1,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function c116810938.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c116810938.desop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end