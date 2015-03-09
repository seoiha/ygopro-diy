--斯塔
function c116810985.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c116810985.splimit)
	c:RegisterEffect(e1)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(116810985,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,116810985)
	e5:SetCondition(c116810985.eqcon2)
	e5:SetCost(c116810985.spcost2)
	e5:SetTarget(c116810985.sptg2)
	e5:SetOperation(c116810985.spop2)
	c:RegisterEffect(e5)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c116810985.eqcon2)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e3)
	--Attribute Dark
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_SINGLE)
	ed:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ed:SetCode(EFFECT_CHANGE_TYPE)
	ed:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE)
	ed:SetCondition(c116810985.eqcon1)
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
	eb:SetTarget(c116810985.tgtg)
	eb:SetValue(c116810985.tgval)
	c:RegisterEffect(eb)
end
function c116810985.splimit(e,c)
	return not c:IsSetCard(0x3e6)
end
function c116810985.eqcon1(e)
	local eg=e:GetHandler():GetEquipGroup()
	return not eg or not eg:IsExists(Card.IsSetCard,1,nil,0x3e6)
end
function c116810985.eqcon2(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg and eg:IsExists(Card.IsSetCard,1,nil,0x3e6)
end
function c116810985.tgtg(e,c)
	return c:IsSetCard(0x3e6) and c:IsType(TYPE_SYNCHRO)
end
function c116810985.tgval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c116810985.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=c:GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c116810985.spfilter(c,e,tp)
	return c:IsSetCard(0x3e6) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c116810985.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c116810985.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c116810985.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c116810985.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end