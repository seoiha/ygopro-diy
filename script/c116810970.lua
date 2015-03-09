--莉莉白
function c116810970.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3e6),aux.NonTuner(Card.IsSetCard,0x3e6),1)
	c:EnableReviveLimit()
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c116810970.descon)
	e2:SetTarget(c116810970.destg)
	e2:SetOperation(c116810970.desop)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetTarget(c116810970.bttg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--cannot be target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetTarget(c116810970.tgtg)
	e6:SetValue(c116810970.tgval)
	c:RegisterEffect(e6)
end
function c116810970.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP)
end
function c116810970.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c116810970.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c116810970.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c116810970.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c116810970.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c116810970.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c116810970.tgtg(e,c)
	return c:IsSetCard(0x3e6) and c~=e:GetHandler()
end
function c116810970.tgval(e,re,tp)
	return e:GetHandlerPlayer()~=tp
end
function c116810970.bttg(e,c)
	return c:IsSetCard(0x3e6) and c~=e:GetHandler()
end