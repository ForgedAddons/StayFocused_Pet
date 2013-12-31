local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = "Pet Care (plugin)"
frame.parent = "Stay Focused!"
frame:Hide()

local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "|cffa0a0f0Stay Focused!|r Per Care", "Options for pet info text.")

local ICONSIZE, ICONGAP, GAP, EDGEGAP, BIGGAP = 32, 3, 8, 16, 16
local tekcheck = LibStub("tekKonfig-Checkbox")
local tekslide = LibStub("tekKonfig-Slider")

local styledropdown, styletext, stylecontainer, stylelabel = LibStub("tekKonfig-Dropdown").new(frame, "Style", "TOPLEFT", subtitle, "BOTTOMLEFT", 0, -GAP)
stylecontainer:SetHeight(28)
styledropdown:ClearAllPoints()
styledropdown:SetPoint("LEFT", stylelabel, "RIGHT", -8, -2)
styledropdown.tiptext = "How text should be displayed"

local function OnClick(self)
	local text = "9999 (100.0%)"
	if self.value == 2 then text = "9999 (100%)" end
	if self.value == 3 then text = "9999" end
	if self.value == 4 then text = "100.0%" end
	if self.value == 5 then text = "100%" end
	styletext:SetText(text)
	StayFocusedPetCare.db.style = self.value
end


local show_power = tekcheck.new(frame, nil, "Show pet's power value", "TOPLEFT", stylecontainer, "BOTTOMLEFT", 0, -BIGGAP)
local checksound = show_power:GetScript("OnClick")
show_power:SetScript("OnClick", function(self)
	checksound(self);
	StayFocusedPetCare.db.show_power = not StayFocusedPetCare.db.show_power
	StayFocusedPetCare:ApplyOptions()
end)

local show_timer = tekcheck.new(frame, nil, "Show Mend Pet's timer (hunters only) instead of icon", "TOPLEFT", show_power, "BOTTOMLEFT", 0, -BIGGAP)
show_timer:SetScript("OnClick", function(self)
	checksound(self);
	StayFocusedPetCare.db.show_timer = not StayFocusedPetCare.db.show_timer
	StayFocusedPetCare:ApplyOptions()
end)

local font_size, font_size_l, font_size_c = tekslide.new(frame, "Font size", 6, 32, "TOPLEFT", show_timer, "BOTTOMLEFT", 0, -BIGGAP)
font_size:SetValueStep(1)
font_size:SetScript("OnValueChanged", function(self, newvalue)
	font_size_l:SetText(string.format("Font size: %d", newvalue))
	StayFocusedPetCare.db.font_size = newvalue
	StayFocusedPetCare:ApplyOptions()
end)
local font_outline = tekcheck.new(frame, nil, "Font Outline", "TOPLEFT", font_size_c, "TOPRIGHT", 4*GAP, 0)
font_outline:SetScript("OnClick", function(self)
	checksound(self);
	StayFocusedPetCare.db.font_outline = not StayFocusedPetCare.db.font_outline
	StayFocusedPetCare:ApplyOptions()
end)


frame:SetScript("OnShow", function(frame)

	local text = "9999 (100.0%)"
	if StayFocusedPetCare.db.style == 2 then text = "9999 (100%)" end
	if StayFocusedPetCare.db.style == 3 then text = "9999" end
	if StayFocusedPetCare.db.style == 4 then text = "100.0%" end
	if StayFocusedPetCare.db.style == 5 then text = "100%" end
	styletext:SetText(text)
	
	UIDropDownMenu_Initialize(styledropdown, function()
		local selected, info = StayFocusedPetCare.db.style, UIDropDownMenu_CreateInfo()
	
		info.func = OnClick
	
		info.text = "value (percent [1 decimal place])"
		info.value = 1
		info.checked = 1 == selected
		UIDropDownMenu_AddButton(info)
	
		info.text = "value (percent [no decimal places])"
		info.value = 2
		info.checked = 2 == selected
		UIDropDownMenu_AddButton(info)
		
		info.text = "value"
		info.value = 3
		info.checked = 3 == selected
		UIDropDownMenu_AddButton(info)
	
		info.text = "percent [1 decimal place]"
		info.value = 4
		info.checked = 4 == selected
		UIDropDownMenu_AddButton(info)
		
		info.text = "percent [no decimal places]"
		info.value = 5
		info.checked = 5 == selected
		UIDropDownMenu_AddButton(info)
	end)

	show_power:SetChecked(StayFocusedPetCare.db.show_power)
	show_timer:SetChecked(StayFocusedPetCare.db.show_timer)
	
	font_size:SetValue(StayFocusedPetCare.db.font_size)
	font_outline:SetChecked(StayFocusedPetCare.db.font_outline)
end)

StayFocusedPetCare.configframe = frame
InterfaceOptions_AddCategory(frame)