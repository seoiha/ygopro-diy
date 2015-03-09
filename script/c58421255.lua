--ヴァイロン・フィラメント
function c58421255.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c58421255.target)
	e1:SetOperation(c58421255.operation)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--destroy sub
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e4:SetCondition(c58421255.descon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c58421255.discon)
	e5:SetOperation(c58421255.disop)
	c:RegisterEffect(e5)
	--destroy
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(58421255,0))
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(1)
	e8:SetCost(c58421255.descost)
	e8:SetTarget(c58421255.destg)
	e8:SetOperation(c58421255.desop)
	c:RegisterEffect(e8)
	--Equip limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_EQUIP_LIMIT)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetValue(c58421255.eqlimit)
	c:RegisterEffect(e9)
end
function c58421255.eqlimit(e,c)
	return c:IsSetCard(0x3d8)
end
function c58421255.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3d8)
end
function c58421255.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c58421255.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c58421255.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c58421255.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c58421255.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c58421255.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c58421255.dfilter(c,pos)
	return c:IsPosition(pos) and c:IsDestructable()
end
function c58421255.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c58421255.dfilter,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP)
		and Duel.IsExistingTarget(c58421255.dfilter,tp,0,LOCATION_SZONE,1,nil,POS_FACEDOWN) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c58421255.dfilter,tp,0,LOCATION_MZONE,1,1,nil,POS_FACEUP)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c58421255.dfilter,tp,0,LOCATION_SZONE,1,1,nil,POS_FACEDOWN)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c58421255.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c58421255.val)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
function c58421255.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return dam/2
	else return dam end
end
function c58421255.descon(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetEquipTarget()
	return tg and tg:IsAttribute(ATTRIBUTE_DARK) 
end
function c58421255.discon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsAttribute(ATTRIBUTE_LIGHT) and ec:GetControler()==tp and (ec==Duel.GetAttacker() or ec==Duel.GetAttackTarget()) and ec:GetBattleTarget()
end
function c58421255.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget():GetBattleTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e2)
end