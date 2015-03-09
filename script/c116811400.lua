--クリフォート・ツール
function c116811400.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_ACTIVATE)
	e7:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e7)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3e2))
	e2:SetValue(0x1)
	c:RegisterEffect(e2)
	--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c116811400.splimcon)
	e4:SetTarget(c116811400.splimit)
	c:RegisterEffect(e4)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(116811400,1))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c116811400.condition)
	e1:SetTarget(c116811400.target)
	e1:SetOperation(c116811400.operation)
	c:RegisterEffect(e1)
	--send replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCost(c116811400.cost)
	e3:SetCondition(c116811400.condition1)
	e3:SetOperation(c116811400.repop)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e6)
	--summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(116811400,0))
	e5:SetCategory(CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetTarget(c116811400.sumtg)
	e5:SetOperation(c116811400.sumop)
	c:RegisterEffect(e5)
end
function c116811400.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c116811400.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE+LOCATION_DECK)
end
function c116811400.repop(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c116811400.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c116811400.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x3e2)
end
function c116811400.filter(c)
	return c:IsSetCard(0x3e2) and not c:IsCode(116811400) and c:IsSummonable(true,nil)
end
function c116811400.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c116811400.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c116811400.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c116811400.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function c116811400.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c116811400.filter1(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c116811400.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c116811400.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(CHAININFO_TARGET_PLAYER,0)
	local d=Duel.GetMatchingGroupCount(c116811400.filter1,tp,LOCATION_ONFIELD,0,nil)*200
	Duel.Recover(p,d,REASON_EFFECT)
end
