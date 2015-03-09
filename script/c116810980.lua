--莉莉布莱克
function c116810980.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3e6),3,3)
	c:EnableReviveLimit()
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c116810980.rmcon)
	e2:SetCost(c116810980.rmcost)
	e2:SetTarget(c116810980.rmtg)
	e2:SetOperation(c116810980.rmop)
	c:RegisterEffect(e2)
	--cannot trigger
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_CANNOT_TRIGGER)
	ea:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	ea:SetRange(LOCATION_MZONE)
	ea:SetTargetRange(0xa,0xa)
	ea:SetTarget(c116810980.distg)
	c:RegisterEffect(ea)
	--disable
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetCode(EFFECT_DISABLE)
	eb:SetRange(LOCATION_MZONE)
	eb:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	eb:SetTarget(c116810980.distg)
	c:RegisterEffect(eb)
	--disable effect
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ec:SetCode(EVENT_CHAIN_SOLVING)
	ec:SetRange(LOCATION_MZONE)
	ec:SetOperation(c116810980.disop)
	c:RegisterEffect(ec)
	--disable trap monster
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_FIELD)
	ed:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	ed:SetRange(LOCATION_MZONE)
	ed:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ed:SetTarget(c116810980.distg)
	c:RegisterEffect(ed)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetDescription(aux.Stringid(116810980,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,116810980)
	e1:SetCost(c116810980.cost)
	e1:SetTarget(c116810980.target)
	e1:SetOperation(c116810980.operation)
	c:RegisterEffect(e1)
end
function c116810980.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c116810980.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c116810980.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c116810980.cfilter(c)
	return (c:IsRace(RACE_DRAGON) or c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
	or c:IsRace(RACE_ALL)) and c:IsSetCard(0x3e6) and c:IsAbleToGraveAsCost()
end
function c116810980.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c116810980.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c116810980.cfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>2 end
	local tg=Group.CreateGroup()
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
		tg:Merge(sg)
	end
	Duel.SendtoGrave(tg,REASON_COST)
end
function c116810980.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,3)
end
function c116810980.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
end
function c116810980.distg(e,c)
	return c:IsType(TYPE_TRAP)
end
function c116810980.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end