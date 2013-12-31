StayFocusedPetCare = CreateFrame("Frame", "StayFocusedPetCare", UIParent)
local frame = StayFocusedPetCare

function frame:ApplyOptions()
	local o = frame.db

	frame.text:SetFont([=[Fonts\ARIALN.ttf]=], o.font_size, o.font_outline and "OUTLINE" or "")
	frame.text:SetTextColor(1, 1, 1)
end

frame:RegisterEvent("ADDON_LOADED")

local color = '909090'

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon:lower() ~= "stayfocused_petcare" then return end
		StayFocusedPetCareDB = StayFocusedPetCareDB or {
			style = 1,
			show_power = false,
			show_power = false,
			
			font_size = 12,
			font_outline = true,			
		}
		self.db = StayFocusedPetCareDB
		if not StayFocusedPetCareDB.show_power then StayFocusedPetCareDB.show_power = false end
		if not StayFocusedPetCareDB.show_timer then StayFocusedPetCareDB.show_timer = false end
		
		frame.text = frame:CreateFontString(nil, "OVERLAY")
		frame.text:SetPoint("RIGHT", StayFocusedMainFrame, "LEFT", -2, 0)
		frame.text:SetJustifyH("RIGHT")
		
		self:ApplyOptions()
		
		self:UnregisterEvent("ADDON_LOADED")
	end
end)

local mend_pet = GetSpellInfo(136)
local mend_icon = '|TInterface\\Icons\\ability_hunter_mendpet:24:24:0:0:64:64:4:60:4:60|t'

local function MendIcon()
	local name, _, _, _, _, _, expirationTime = UnitBuff('pet', mend_pet)
	return name and (StayFocusedPetCareDB.show_timer and format('%.1f ', expirationTime - GetTime()) or mend_icon..' ') or '';
end


local function getHpPercent(p, decimal, smart)
	local max_power = UnitHealthMax('pet')
	if smart and (p == max_power or p == 0) then return '' end
	local v = p / max_power * 100.0
	return smart and (decimal and format(' (%.1f%%)', v) or format(' (%.0f%%)', v)) or (decimal and format('%.1f%%', v) or format('%.0f%%', v))
end

local function getText(v)
	local style = StayFocusedPetCare.db.style
	local text = ""
	if style == 1 then
		return v..getHpPercent(v, true, true)
	end
	if style == 2 then
		return v..getHpPercent(v, false, true)
	end
	if style == 3 then
		return v
	end
	if style == 4 then
		return getHpPercent(v, true, false)
	end
	if style == 5 then
		return getHpPercent(v, false, false)
	end
end

local lastUpdate = 0
frame:SetScript("OnUpdate", function(self, elapsed)
	lastUpdate = lastUpdate + elapsed
	if color == '' then return end
	if lastUpdate > 0.1 then
		lastUpdate = 0

		local hp = UnitHealth('pet')
		local text = ''
		
		if hp ~= 0 then
			text = MendIcon() .. '|cff' .. color .. getText(hp)
			
			if StayFocusedPetCare.db.show_power == true then
				text = text..' '..UnitPower('pet')
			end
		end
		frame.text:SetText(text)
	end
end)
