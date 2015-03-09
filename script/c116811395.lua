--クリフォート・ツール
function c116811395.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--send replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCost(c116811395.cost)
	e3:SetCondition(c116811395.condition)
	e3:SetOperation(c116811395.repop)
	c:RegisterEffect(e3)
	local e9=e3:Clone()
	e9:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e9)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(116811395,0))
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetCondition(c116811395.damcon)
	e6:SetTarget(c116811395.damtg)
	e6:SetOperation(c116811395.damop)
	c:RegisterEffect(e6)
	--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c116811395.splimcon)
	e4:SetTarget(c116811395.splimit)
	c:RegisterEffect(e4)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(116811395,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,116811395)
	e2:SetCondition(c116811395.thcon)
	e2:SetTarget(c116811395.thtg)
	e2:SetOperation(c116811395.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(116811395,2))
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCountLimit(1)
	e8:SetCost(c116811395.spcost)
	e8:SetTarget(c116811395.sptg)
	e8:SetOperation(c116811395.spop)
	c:RegisterEffect(e8)
end
function c116811395.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c116811395.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE+LOCATION_DECK)
end
function c116811395.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end
function c116811395.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c116811395.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x3e2)
end
function c116811395.cfilter(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and not c:IsCode(116811395) and c:IsAbleToGraveAsCost()
end
function c116811395.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c116811395.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c116811395.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c116811395.spfilter(c,e,tp)
	return c:IsSetCard(0x3e2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c116811395.spfilter1(c)
	return c:IsSetCard(0x3e2) and c:IsType(TYPE_MONSTER) 
end
function c116811395.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c116811395.spfilter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c116811395.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c116811395.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
function c116811395.damcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c116811395.filter1(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS 
end
function c116811395.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c116811395.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c116811395.filter1,tp,LOCATION_ONFIELD,0,nil)*200
	Duel.Damage(p,d,REASON_EFFECT)
end
function c116811395.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function c116811395.filter(c)
	return c:IsSetCard(0x3e2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c116811395.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c116811395.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c116811395.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end