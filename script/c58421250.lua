--炎王炎環
function c58421250.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,58421250+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c58421250.target)
	e1:SetOperation(c58421250.activate)
	c:RegisterEffect(e1)
end
function c58421250.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3d8) and c:IsDestructable()
end
function c58421250.spfilter(c,e,tp)
	return c:IsSetCard(0x3d8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c58421250.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c58421250.desfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c58421250.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c58421250.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c58421250.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	e:SetLabelObject(g1:GetFirst())
end
function c58421250.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
	if tc1:IsControler(tp) and tc1:IsRelateToEffect(e) and Duel.Destroy(tc1,REASON_EFFECT)>0 and tc2:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end