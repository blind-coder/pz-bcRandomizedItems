require 'TimedActions/ISInventoryTransferAction'

if not BCGT then BCGT = {} end

BCGT.ISITAperform = ISInventoryTransferAction.perform;
-- Combine Drainable items on transfer
ISInventoryTransferAction.perform = function(self)--{{{
	local retVal = BCGT.ISITAperform(self);

	if self.item == nil then return retVal end;
	if not (instanceof(self.item, "Drainable") or instanceof(self.item, "DrainableComboItem")) then return retVal end
	if self.item:getReplaceOnDeplete() ~= nil then return retVal end; -- usually water bottles etc.

	local fullType = self.item:getFullType();
	local inv = self.destContainer;
	local fillstate = 0;
	local allItems = inv:FindAndReturn(fullType, 99999);
	for i=0,allItems:size()-1 do
		fillstate = fillstate + allItems:get(i):getUsedDelta()*100;
	end
	while inv:FindAndReturn(fullType) ~= nil do
		local it = inv:FindAndReturn(fullType);
		inv:Remove(it);
	end

	while fillstate > 0 do
		local it = inv:AddItem(fullType);
		if fillstate < 100 then
			it:setUsedDelta(fillstate / 100);
			fillstate = 0;
		else
			fillstate = fillstate - 100;
		end
	end

	return retVal;
end
--}}}
