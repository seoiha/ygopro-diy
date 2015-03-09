--露娜
function c116810990.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c116810990.splimit)
	c:RegisterEffect(e1)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(116810990,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,116810990)
	e4:SetCondition(c116810990.eqcon2)
	e4:SetCost(c116810990.spcost2)
	e4:SetTarget(c116810990.thtg)
	e4:SetOperation(c116810990.thop)
	c:RegisterEffect(e4)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c116810990.eqcon2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--Attribute Dark
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_SINGLE)
	ed:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ed:SetCode(EFFECT_CHANGE_TYPE)
	ed:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE)
	ed:SetCondition(c116810990.eqcon1)
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
	eb:SetTarget(c116810990.tgtg)
	eb:SetValue(c116810990.tgval)
	c:RegisterEffect(eb)
end
function c116810990.splimit(e,c)
	return not c:IsSetCard(0x3e6)
end
function c116810990.eqcon1(e)
	local eg=e:GetHandler():GetEquipGroup()
	return not eg or not eg:IsExists(Card.IsSetCard,1,nil,0x3e6)
end
function c116810990.eqcon2(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg and eg:IsExists(Card.IsSetCard,1,nil,0x3e6)
end
function c116810990.tgtg(e,c)
	return c:IsSetCard(0x3e6) and c:IsType(TYPE_XYZ)
end
function c116810990.tgval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c116810990.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=c:GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c116810990.thfilter(c)
	return c:IsSetCard(0x43e6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c116810990.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c116810990.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c116810990.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c116810990.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end