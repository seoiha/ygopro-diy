--桑妮
function c116810995.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(116810995,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,116810995)
	e1:SetCondition(c116810995.eqcon2)
	e1:SetCost(c116810995.spcost2)
	e1:SetTarget(c116810995.thtg)
	e1:SetOperation(c116810995.thop)
	c:RegisterEffect(e1)
	--splimit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetRange(LOCATION_PZONE)
	e9:SetTargetRange(1,0)
	e9:SetTarget(c116810995.splimit)
	c:RegisterEffect(e9)
	--scale change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(116810995,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c116810995.sccon)
	e2:SetOperation(c116810995.scop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c116810995.eqcon2)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	--Attribute Dark
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_SINGLE)
	ed:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ed:SetCode(EFFECT_CHANGE_TYPE)
	ed:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE)
	ed:SetCondition(c116810995.eqcon1)
	ed:SetValue(TYPE_NORMAL+TYPE_MONSTER)
	c:RegisterEffect(ed)
	--atk up
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_FIELD)
	ec:SetRange(LOCATION_PZONE)
	ec:SetCode(EFFECT_UPDATE_ATTACK)
	ec:SetTargetRange(LOCATION_MZONE,0)
	ec:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3e6))
	ec:SetValue(400)
	c:RegisterEffect(ec)
	--Activate
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_ACTIVATE)
	ea:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(ea)
	--cannot be target
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	eb:SetRange(LOCATION_PZONE)
	eb:SetTargetRange(LOCATION_ONFIELD,0)
	eb:SetTarget(c116810995.tgtg)
	eb:SetValue(c116810995.tgval)
	c:RegisterEffect(eb)
end
function c116810995.splimit(e,c)
	return not c:IsSetCard(0x3e6)
end
function c116810995.eqcon1(e)
	local eg=e:GetHandler():GetEquipGroup()
	return not eg or not eg:IsExists(Card.IsSetCard,1,nil,0x3e6)
end
function c116810995.eqcon2(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg and eg:IsExists(Card.IsSetCard,1,nil,0x3e6)
end
function c116810995.tgtg(e,c)
	return c:IsSetCard(0x3e6) and c:IsType(TYPE_XYZ)
end
function c116810995.tgval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c116810995.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=c:GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c116810995.sccon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0x3e6)
end
function c116810995.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CHANGE_LSCALE)
	e9:SetValue(8)
	e9:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e9)
	local e2=e9:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c116810995.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c116810995.filter(c)
	return c:IsSetCard(0x43e6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c116810995.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c116810995.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c116810995.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c116810995.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end