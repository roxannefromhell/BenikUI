local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

local ceil, format, print = ceil, format, print
local _G = _G

local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local PlaySoundFile = PlaySoundFile
local ReloadUI = ReloadUI
local UIFrameFadeOut = UIFrameFadeOut
local FCF_SetLocked = FCF_SetLocked
local FCF_DockFrame, FCF_UnDockFrame = FCF_DockFrame, FCF_UnDockFrame
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_StopDragging = FCF_StopDragging
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local CONTINUE, PREVIOUS, ADDONS = CONTINUE, PREVIOUS, ADDONS
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local LOOT, TRADE = LOOT, TRADE
local TANK, HEALER = TANK, HEALER

local CreateAnimationGroup = CreateAnimationGroup

-- GLOBALS: BUIInstallFrame, BUITitleFrame, InstallStepComplete, InstallStatus, InstallNextButton, InstallPrevButton
-- GLOBALS: InstallOption1Button, InstallOption2Button, InstallOption3Button, InstallOption4Button, LeftChatToggleButton
-- GLOBALS: RecountDB, SkadaDB, DBM, DBM_AllSavedOptions, DBT_AllPersistentOptions, MSBTProfiles_SavedVars, MikSBT

local CURRENT_PAGE = 0
local MAX_PAGE = 9

local titleText = {}

local function SetupBuiLayout()
	
	-- General
	E.db["general"]["backdropcolor"]["b"] = 0.025
	E.db["general"]["backdropcolor"]["g"] = 0.025
	E.db["general"]["backdropcolor"]["r"] = 0.025
	E.db["general"]["backdropfadecolor"]["b"] = 0.054
	E.db["general"]["backdropfadecolor"]["g"] = 0.054
	E.db["general"]["backdropfadecolor"]["r"] = 0.054
	E.db["general"]["bottomPanel"] = false
	E.db["general"]["font"] = "Bui Prototype"
	E.db["general"]["fontSize"] = 10
	E.db["hideTutorial"] = true
	E.db["currentTutorial"] = 1
	E.db["general"]["minimap"]["locationText"] = "HIDE"
	E.db["general"]["minimap"]["size"] = 150
	
	E.db["databars"]["experience"]["enable"] = true
	E.db["databars"]["experience"]["height"] = 150
	E.db["databars"]["experience"]["textFormat"] = 'NONE'
	E.db["databars"]["experience"]["textSize"] = 9
	E.db["databars"]["experience"]["width"] = 8	
	E.db["databars"]["reputation"]["enable"] = true
	E.db["databars"]["reputation"]["height"] = 150
	E.db["databars"]["reputation"]["orientation"] = 'VERTICAL'
	E.db["databars"]["reputation"]["textFormat"] = 'NONE'
	E.db["databars"]["reputation"]["textSize"] = 9
	E.db["databars"]["reputation"]["width"] = 8
	E.db["databars"]["artifact"]["enable"] = true
	E.db["databars"]["artifact"]["orientation"] = 'VERTICAL'
	E.db["databars"]["artifact"]["textFormat"] = 'NONE'
	E.db["databars"]["artifact"]["textSize"] = 9
	E.db["databars"]["artifact"]["height"] = 152
	E.db["databars"]["artifact"]["width"] = 8
	E.db["databars"]["honor"]["enable"] = true
	E.db["databars"]["honor"]["height"] = 150
	E.db["databars"]["honor"]["textFormat"] = 'NONE'
	E.db["databars"]["honor"]["textSize"] = 9
	E.db["databars"]["honor"]["width"] = 8	

	E.db["general"]["topPanel"] = false
	E.db["general"]["valuecolor"]["a"] = 1
	E.db["general"]["valuecolor"]["b"] = 0
	E.db["general"]["valuecolor"]["g"] = 0.5
	E.db["general"]["valuecolor"]["r"] = 1
	E.db["general"]["stickyFrames"] = true
	
	E.private["general"]["normTex"] = "BuiFlat"
	E.private["general"]["dmgfont"] = "Bui Prototype"
	E.private["general"]["chatBubbleFont"] = "Bui Prototype"
	E.private["general"]["chatBubbleFontSize"] = 14
	E.private["general"]["chatBubbles"] = 'backdrop'
	E.private["general"]["namefont"] = "Bui Prototype"
	E.private["general"]["glossTex"] = "BuiFlat"
	E.private["skins"]["blizzard"]["alertframes"] = true
	E.private["skins"]["blizzard"]["questChoice"] = true

	E.db["datatexts"]["leftChatPanel"] = false
	E.db["datatexts"]["rightChatPanel"] = false
	E.db["datatexts"]["panelTransparency"] = true
	E.db["datatexts"]["font"] = "Bui Visitor1"
	E.db["datatexts"]["fontSize"] = 10
	E.db["datatexts"]["fontOutline"] = "MONOCROMEOUTLINE"
	
	E.db["bags"]["itemLevelFont"] = "Bui Prototype"
	E.db["bags"]["itemLevelFontSize"] = 10
	E.db["bags"]["itemLevelFontOutline"] = "OUTLINE"
	E.db["bags"]["countFont"] = "Bui Prototype"
	E.db["bags"]["countFontSize"] = 10
	E.db["bags"]["countFontOutline"] = "OUTLINE"
	E.db["chat"]["panelBackdrop"] = 'SHOWBOTH'
	
	-- Tooltip
	E.db["tooltip"]["healthBar"]["font"] = "Bui Prototype"
	E.db["tooltip"]["healthBar"]["fontSize"] = 9
	E.db["tooltip"]["healthBar"]["fontOutline"] = "OUTLINE"
	E.db["tooltip"]["font"] = "Bui Prototype"
	E.db["tooltip"]["fontOutline"] = 'NONE'
	E.db["tooltip"]["headerFontSize"] = 10
	E.db["tooltip"]["textFontSize"] = 10
	E.db["tooltip"]["smallTextFontSize"] = 10
	
	-- Nameplates
	E.db["nameplates"]["font"] = "Bui Visitor1"
	E.db["nameplates"]["fontSize"] = 10
	E.db["nameplates"]["fontOutline"] = 'MONOCHROMEOUTLINE'
	E.db["nameplates"]["statusbar"] = "BuiFlat"

	-- Movers
	E.db["movers"]["AlertFrameMover"] = "TOP,ElvUIParent,TOP,0,-140"
	E.db["movers"]["BNETMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-182"
	E.db["movers"]["BuiDashboardMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-8"
	E.db["movers"]["DigSiteProgressBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,315"
	E.db["movers"]["ExperienceBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,415,22"
	E.db["movers"]["GMMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,158,-38"
	E.db["movers"]["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,22"
	E.db["movers"]["MicrobarMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,158,-5"
	E.db["movers"]["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-6"
	E.db["movers"]["ProfessionsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-5,-184"
	E.db["movers"]["ReputationBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-415,22"
	E.db["movers"]["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-2,22"
	E.db["movers"]["VehicleSeatMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,155,-81"
	E.db["movers"]["WatchFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-122,-292"
	E.db["movers"]["tokenHolderMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-123"
	E.db["movers"]["ArtifactBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-157,-6"
	E.db["movers"]["HonorBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,415,22"
	E.db["movers"]["ObjectiveFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-207,-260"

	-- LocationPlus
	if E.db.locplus == nil then E.db.locplus = {} end
	E.db["locplus"]["both"] = false
	E.db["locplus"]["displayOther"] = "NONE"
	E.db["locplus"]["dtheight"] = 16
	E.db["locplus"]["dtwidth"] = 120
	E.db["locplus"]["hidecoords"] = false
	E.db["locplus"]["lpauto"] = false
	E.db["locplus"]["lpfont"] = "Bui Visitor1"
	E.db["locplus"]["lpfontflags"] = "MONOCROMEOUTLINE"
	E.db["locplus"]["lpfontsize"] = 10
	E.db["locplus"]["lpwidth"] = 220
	E.db["locplus"]["trunc"] = true
	E.db["movers"]["LocationMover"] = "TOP,ElvUIParent,TOP,0,-7"

	-- LocationLite
	if E.db.loclite == nil then E.db.loclite = {} end
	E.db["loclite"]["dtheight"] = 16
	E.db["loclite"]["lpfontsize"] = 10
	E.db["loclite"]["trunc"] = true
	E.db["loclite"]["lpwidth"] = 220
	E.db["loclite"]["lpfontflags"] = "MONOCROMEOUTLINE"
	E.db["loclite"]["lpauto"] = false
	E.db["loclite"]["lpfont"] = "Bui Visitor1"
	E.db["movers"]["LocationLiteMover"] = "TOP,ElvUIParent,TOP,0,-7"

	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['Layout Set']
		InstallStepComplete:Show()
		titleText[2].check:Show()
	end
	E:UpdateAll(true)
end

function BUI:BuiColorThemes(color)
	-- Colors
	if color == 'Diablo' then
		E.db.general.backdropfadecolor.a = 0.75
		E.db.general.backdropfadecolor.r = 0.125
		E.db.general.backdropfadecolor.g = 0.054
		E.db.general.backdropfadecolor.b = 0.050
		E.db.benikui.colors.colorTheme = 'Diablo'
	elseif color == 'Hearthstone' then
		E.db.general.backdropfadecolor.a = 0.75
		E.db.general.backdropfadecolor.r = 0.086
		E.db.general.backdropfadecolor.g = 0.109
		E.db.general.backdropfadecolor.b = 0.149
		E.db.benikui.colors.colorTheme = 'Hearthstone'
	elseif color == 'Mists' then
		E.db.general.backdropfadecolor.a = 0.75
		E.db.general.backdropfadecolor.r = 0.043
		E.db.general.backdropfadecolor.g = 0.101
		E.db.general.backdropfadecolor.b = 0.101
		E.db.benikui.colors.colorTheme = 'Mists'
	elseif color == 'Elv' then
		E.db.general.backdropfadecolor.a = 0.75
		E.db.general.backdropfadecolor.r = 0.054
		E.db.general.backdropfadecolor.g = 0.054
		E.db.general.backdropfadecolor.b = 0.054
		E.db.benikui.colors.colorTheme = 'Elv'
	end
	E.db.general.backdropcolor.r = 0.025
	E.db.general.backdropcolor.g = 0.025
	E.db.general.backdropcolor.b = 0.025

	E:UpdateAll(true)
end

function BUI:SetupBuiColors()
	self:BuiColorThemes()
	
	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['Color Theme Set']
		InstallStepComplete:Show()
		titleText[3].check:Show()		
	end
end

local function SetupBuiChat()

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format('ChatFrame%s', i)]
		local chatFrameId = frame:GetID()
		local chatName = FCF_GetChatWindowInfo(chatFrameId)
		
		FCF_SetChatWindowFontSize(nil, frame, 10)
		
		-- move ElvUI default loot frame to the left chat, so that Recount/Skada can go to the right chat.
		if i == 3 and chatName == LOOT..' / '..TRADE then
			FCF_UnDockFrame(frame)
			frame:ClearAllPoints()
			frame:Point('BOTTOMLEFT', LeftChatToggleButton, 'TOPLEFT', 1, 3)
			FCF_DockFrame(frame)
			FCF_SetLocked(frame, 1)
			frame:Show()
		end
		FCF_SavePositionAndDimensions(frame)
		FCF_StopDragging(frame)
	end

	E.db["chat"]["tabFont"] = "Bui Visitor1"
	E.db["chat"]["tabFontSize"] = 10
	E.db["chat"]["tabFontOutline"] = "MONOCROMEOUTLINE"
	E.db["chat"]["font"] = "Bui Prototype"
	E.db["chat"]["panelHeight"] = 150
	E.db["chat"]["panelWidth"] = 412
	
	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['Chat Set']
		InstallStepComplete:Show()
		titleText[4].check:Show()		
	end
	E:UpdateAll(true)
end

local function SetupActionbars(layout)
	-- Actionbars
	E.db["actionbar"]["lockActionBars"] = true

	E.db["benikui"]["datatexts"]["middle"]["styled"] = false
	E.db["benikui"]["datatexts"]["middle"]["width"] = 412
	E:GetModule('BuiLayout'):MiddleDatatextDimensions()
	E.db["benikui"]["datatexts"]["middle"]["backdrop"] = true
	E:GetModule('BuiLayout'):MiddleDatatextLayout()
	E.db["benikui"]["actionbars"]["toggleButtons"]["enable"] = true

	if layout == 'big' then
		E.db["actionbar"]["font"] = "Bui Visitor1"
		E.db["actionbar"]["fontOutline"] = "MONOCROMEOUTLINE"
		E.db["actionbar"]["fontSize"] = 10
		
		E.db["actionbar"]["bar1"]["backdrop"] = false
		E.db["actionbar"]["bar1"]["buttons"] = 12
		E.db["actionbar"]["bar1"]["buttonsize"] = 30
		E.db["actionbar"]["bar1"]["buttonspacing"] = 4
		E.db["actionbar"]["bar1"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["backdrop"] = true
		E.db["actionbar"]["bar2"]["buttons"] = 12
		E.db["actionbar"]["bar2"]["buttonspacing"] = 4
		E.db["actionbar"]["bar2"]["heightMult"] = 2
		E.db["actionbar"]["bar2"]["buttonsize"] = 30
		E.db["actionbar"]["bar2"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar3"]["backdrop"] = true
		E.db["actionbar"]["bar3"]["buttons"] = 10
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 5
		E.db["actionbar"]["bar3"]["buttonsize"] = 30
		E.db["actionbar"]["bar3"]["buttonspacing"] = 4
		E.db["actionbar"]["bar3"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar4"]["backdrop"] = true
		E.db["actionbar"]["bar4"]["buttons"] = 12
		E.db["actionbar"]["bar4"]["buttonsize"] = 26
		E.db["actionbar"]["bar4"]["buttonspacing"] = 4
		E.db["actionbar"]["bar4"]["mouseover"] = true
		E.db["actionbar"]["bar4"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar5"]["backdrop"] = true
		E.db["actionbar"]["bar5"]["buttons"] = 10
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 5
		E.db["actionbar"]["bar5"]["buttonsize"] = 30
		E.db["actionbar"]["bar5"]["buttonspacing"] = 4
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 4
		E.db["actionbar"]["barPet"]["backdrop"] = false
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 10
		E.db["actionbar"]["barPet"]["buttonsize"] = 22
		E.db["actionbar"]["barPet"]["buttonspacing"] = 4
		E.db["actionbar"]["stanceBar"]["buttonspacing"] = 2
		E.db["actionbar"]["stanceBar"]["backdrop"] = false
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 24	

		-- movers
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,97"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,58"
		E.db["movers"]["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,296,58"
		E.db["movers"]["ElvAB_5"] = "BOTTOM,ElvUIParent,BOTTOM,-296,58"
		E.db["movers"]["PetAB"] = "BOTTOM,ElvUIParent,BOTTOM,0,22"
		E.db["movers"]["ShiftAB"] = "BOTTOM,ElvUIParent,BOTTOM,0,136"
		E.db["movers"]["BuiMiddleDtMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,2"
		E.db["movers"]["ArenaHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-56,346"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,283"
		E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-56,-397"
		E.db["movers"]["BuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-3"
		E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-128"
		
	elseif layout == 'small' then	
		E.db["actionbar"]["font"] = "Bui Visitor1"
		E.db["actionbar"]["fontOutline"] = "MONOCROMEOUTLINE"
		E.db["actionbar"]["fontSize"] = 10;
		
		E.db["actionbar"]["bar1"]["backdrop"] = false
		E.db["actionbar"]["bar1"]["buttons"] = 12
		E.db["actionbar"]["bar1"]["buttonsize"] = 30
		E.db["actionbar"]["bar1"]["buttonspacing"] = 4
		E.db["actionbar"]["bar1"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar2"]["buttons"] = 12
		E.db["actionbar"]["bar2"]["backdrop"] = true
		E.db["actionbar"]["bar2"]["buttonsize"] = 30
		E.db["actionbar"]["bar2"]["buttonspacing"] = 4
		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["heightMult"] = 2
		E.db["actionbar"]["bar2"]["backdropSpacing"] = 3
		E.db["actionbar"]["bar3"]["backdrop"] = false
		E.db["actionbar"]["bar3"]["buttons"] = 5
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 5
		E.db["actionbar"]["bar3"]["buttonsize"] = 19
		E.db["actionbar"]["bar3"]["buttonspacing"] = 1
		E.db["actionbar"]["bar3"]["backdropSpacing"] = 1
		E.db["actionbar"]["bar4"]["backdrop"] = true
		E.db["actionbar"]["bar4"]["buttons"] = 12
		E.db["actionbar"]["bar4"]["buttonsize"] = 26
		E.db["actionbar"]["bar4"]["buttonspacing"] = 4
		E.db["actionbar"]["bar4"]["mouseover"] = true
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar5"]["backdrop"] = false
		E.db["actionbar"]["bar5"]["buttons"] = 5
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 5
		E.db["actionbar"]["bar5"]["buttonsize"] = 19
		E.db["actionbar"]["bar5"]["buttonspacing"] = 1
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 1

		E.db["actionbar"]["barPet"]["buttonspacing"] = 4
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 10
		E.db["actionbar"]["barPet"]["backdrop"] = false
		E.db["actionbar"]["barPet"]["buttonsize"] = 22
				
		E.db["actionbar"]["stanceBar"]["buttonspacing"] = 2
		E.db["actionbar"]["stanceBar"]["backdrop"] = false
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 24	
		
		-- movers
		E.db["movers"]["ArenaHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-56,346"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,290"
		E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-56,-397"
		E.db["movers"]["BuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-3"
		E.db["movers"]["BuiMiddleDtMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,2"
		E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-128"
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,60"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,22"
		E.db["movers"]["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,257,2"
		E.db["movers"]["ElvAB_5"] = "BOTTOM,ElvUIParent,BOTTOM,-256,2"
		E.db["movers"]["PetAB"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-150,177"
		E.db["movers"]["ShiftAB"] = "BOTTOM,ElvUIParent,BOTTOM,0,100"
	end

	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['Actionbars Set']
		InstallStepComplete:Show()
		titleText[6].check:Show()
	end
	E:UpdateAll(true)
end

local function SetupUnitframes(layout)
	
	if layout == 'normal' then
		E.db["benikui"]["unitframes"]["player"]["detachPortrait"] = false
		E.db["benikui"]["unitframes"]["player"]["portraitStyle"] = false
		E.db["benikui"]["unitframes"]["target"]["portraitStyle"] = false
		E.db["benikui"]["unitframes"]["target"]["getPlayerPortraitSize"] = false
		E.db["benikui"]["unitframes"]["target"]["detachPortrait"] = false
		E.db["benikui"]["unitframes"]["castbar"]["text"]["yOffset"] = -16

		-- Auras
		E.db["auras"]["timeXOffset"] = -1
		E.db["auras"]["font"] = "Bui Visitor1"
		E.db["auras"]["fontSize"] = 10
		E.db["auras"]["fontOutline"] = "MONOCROMEOUTLINE"
		E.db["auras"]["fadeThreshold"] = 10
		E.db["auras"]["buffs"]["horizontalSpacing"] = 3
		E.db["auras"]["buffs"]["size"] = 30
		E.db["auras"]["debuffs"]["size"] = 30
		
		-- Units
		-- general
		E.db["unitframe"]["font"] = "Bui Visitor1"
		E.db["unitframe"]["fontSize"] = 10
		E.db["unitframe"]["fontOutline"] = "MONOCROMEOUTLINE"
		E.db["unitframe"]["colors"]["transparentAurabars"] = true
		E.db["unitframe"]["colors"]["transparentCastbar"] = true
		E.db["unitframe"]["colors"]["castClassColor"] = true
		E.db["unitframe"]["colors"]["transparentPower"] = false
		E.db["unitframe"]["colors"]["transparentHealth"] = true
		E.db["unitframe"]["smoothbars"] = true
		E.db["unitframe"]["colors"]["health"]["b"] = 0.1
		E.db["unitframe"]["colors"]["health"]["g"] = 0.1
		E.db["unitframe"]["colors"]["health"]["r"] = 0.1
		E.db["unitframe"]["colors"]["castClassColor"] = true
		E.db["unitframe"]["colors"]["healthclass"] = false
		E.db["unitframe"]["colors"]["auraBarBuff"]["r"] = 0.1
		E.db["unitframe"]["colors"]["auraBarBuff"]["g"] = 0.1
		E.db["unitframe"]["colors"]["auraBarBuff"]["b"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["r"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["g"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["b"] = 0.1
		E.db["unitframe"]["statusbar"] = "BuiFlat"
		
		-- player
		E.db["unitframe"]["units"]["player"]["debuffs"]["attachTo"] = "BUFFS"
		E.db["unitframe"]["units"]["player"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["player"]["debuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["player"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["player"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["player"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 300
		E.db["unitframe"]["units"]["player"]["castbar"]["insideInfoPanel"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 140
		E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "spaced"
		E.db["unitframe"]["units"]["player"]["width"] = 300
		E.db["unitframe"]["units"]["player"]["health"]["xOffset"] = 4
		E.db["unitframe"]["units"]["player"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["health"]["text_format"] = '[healthcolor][health:current-percent]'
		E.db["unitframe"]["units"]["player"]["health"]["attachTextTo"] = 'InfoPanel'
		E.db["unitframe"]["units"]["player"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["infoPanel"]["height"] = 16
		E.db["unitframe"]["units"]["player"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["player"]["height"] = 37
		E.db["unitframe"]["units"]["player"]["buffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["player"]["buffs"]["sizeOverride"] = 30
		E.db["unitframe"]["units"]["player"]["buffs"]["noDuration"] = false
		E.db["unitframe"]["units"]["player"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["buffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["player"]["buffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["player"]["smartAuraPosition"] = "DEBUFFS_ON_BUFFS"
		E.db["unitframe"]["units"]["player"]["threatStyle"] = 'GLOW'
		E.db["unitframe"]["units"]["player"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["player"]["power"]["width"] = 'fill'
		E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 300
		E.db["unitframe"]["units"]["player"]["power"]["detachFromFrame"] = false
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[powercolor][power:current-percent]"
		E.db["unitframe"]["units"]["player"]["power"]["hideonnpc"] = true
		E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = 'InfoPanel'
		E.db["unitframe"]["units"]["player"]["aurabar"]["enable"] = false

		if not E.db.unitframe.units.player.customTexts then E.db.unitframe.units.player.customTexts = {} end
		if E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"] then E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"] = nil end
		if E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"] then E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"] = nil end
		
		-- target
		E.db["unitframe"]["units"]["target"]["buffs"]["anchorPoint"] = 'TOPRIGHT'
		E.db["unitframe"]["units"]["target"]["buffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 30
		E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["target"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 300
		E.db["unitframe"]["units"]["target"]["castbar"]["insideInfoPanel"] = true
		E.db["unitframe"]["units"]["target"]["orientation"] = "LEFT"		
		E.db["unitframe"]["units"]["target"]["debuffs"]["anchorPoint"] = 'TOPRIGHT'
		E.db["unitframe"]["units"]["target"]["debuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["target"]["debuffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["target"]["health"]["text_format"] = '[healthcolor][health:current-percent]'
		E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = -2
		E.db["unitframe"]["units"]["target"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["health"]["attachTextTo"] = 'InfoPanel'
		E.db["unitframe"]["units"]["target"]["height"] = 37
		E.db["unitframe"]["units"]["target"]["name"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["name"]["text_format"] = '[namecolor][name:medium] [difficultycolor][smartlevel] [shortclassification]'
		E.db["unitframe"]["units"]["target"]["name"]["xOffset"] = 8
		E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["name"]["attachTextTo"] = 'Health'
		E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["target"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["target"]["power"]["detachFromFrame"] = false
		E.db["unitframe"]["units"]["target"]["power"]["detachedWidth"] = 300
		E.db["unitframe"]["units"]["target"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = false
		E.db["unitframe"]["units"]["target"]["power"]["text_format"] = "[powercolor][power:current-percent]"
		E.db["unitframe"]["units"]["target"]["power"]["width"] = 'fill'
		E.db["unitframe"]["units"]["target"]["power"]["xOffset"] = 4
		E.db["unitframe"]["units"]["target"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["power"]["threatStyle"] = 'GLOW'
		E.db["unitframe"]["units"]["target"]["power"]["attachTextTo"] = 'InfoPanel'
		E.db["unitframe"]["units"]["target"]["width"] = 300
		E.db["unitframe"]["units"]["target"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["infoPanel"]["height"] = 16
		E.db["unitframe"]["units"]["target"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["target"]["smartAuraDisplay"] = "DISABLED"
		E.db["unitframe"]["units"]["target"]["aurabar"]["enable"] = false
		E.db["unitframe"]["units"]["target"]["aurabar"]["maxDuration"] = 120
		E.db["unitframe"]["units"]["target"]["smartAuraPosition"] = "DEBUFFS_ON_BUFFS"
		
		if not E.db.unitframe.units.target.customTexts then E.db.unitframe.units.target.customTexts = {} end
		if E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"] then E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"] = nil end
		if E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"] then E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"] = nil end
		
		-- pet
		E.db["unitframe"]["units"]["pet"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["pet"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["pet"]["castbar"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["height"] = 24
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["pet"]["power"]["width"] = 'fill'
		
		-- focus
		E.db["unitframe"]["units"]["focus"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["focus"]["power"]["width"] = 'fill'
		E.db["unitframe"]["units"]["focus"]["width"] = 130
		E.db["unitframe"]["units"]["focus"]["height"] = 30
		E.db["unitframe"]["units"]["focus"]["castbar"]["height"] = 14
		E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 130
		E.db["unitframe"]["units"]["focus"]["debuffs"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["focus"]["debuffs"]["enable"] = false
		E.db["unitframe"]["units"]["focus"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["focus"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["focus"]["castbar"]["iconSize"] = 26
		E.db["unitframe"]["units"]["focus"]["castbar"]["enable"] = false
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["height"] = 12
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["enable"] = false

		-- targettarget	
		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["targettarget"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["targettarget"]["power"]["width"] = 'fill'
		E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["height"] = 12
		E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["threatStyle"] = "GLOW"
		E.db["unitframe"]["units"]["targettarget"]["width"] = 130
		E.db["unitframe"]["units"]["targettarget"]["height"] = 24
		
		-- party
		E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 18
		E.db["unitframe"]["units"]["party"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["party"]["debuffs"]["countFontSize"] = 10
		E.db["unitframe"]["units"]["party"]["debuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 19
		E.db["unitframe"]["units"]["party"]["debuffs"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 25
		E.db["unitframe"]["units"]["party"]["health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[health:current-percent]"
		E.db["unitframe"]["units"]["party"]["health"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["party"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["party"]["height"] = 45
		E.db["unitframe"]["units"]["party"]["name"]["xOffset"] = 4
		E.db["unitframe"]["units"]["party"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["party"]["petsGroup"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["petsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["petsGroup"]["width"] = 60
		E.db["unitframe"]["units"]["party"]["petsGroup"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["petsGroup"]["yOffset"] = -1
		E.db["unitframe"]["units"]["party"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["party"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["party"]["portrait"]["rotation"] = 0
		E.db["unitframe"]["units"]["party"]["portrait"]["style"] = '3D'
		E.db["unitframe"]["units"]["party"]["portrait"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["portrait"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["portrait"]["width"] = 45
		E.db["unitframe"]["units"]["party"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["party"]["power"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["power"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["party"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["power"]["yOffset"] = 2
		E.db["unitframe"]["units"]["party"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["damager"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["healer"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["tank"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["attachTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 12
		E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["width"] = 70
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["xOffset"] = 1
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["yOffset"] = -14
		E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 4
		E.db["unitframe"]["units"]["party"]["width"] = 120
		E.db["unitframe"]["units"]["party"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["party"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["infoPanel"]["transparent"] = true

		-- raid
		E.db["unitframe"]["units"]["raid"]["height"] = 40
		E.db["unitframe"]["units"]["raid"]["verticalSpacing"] = 3
		E.db["unitframe"]["units"]["raid"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["raid"]["name"]["xOffset"] = 4
		E.db["unitframe"]["units"]["raid"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["raid"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["raid"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["damager"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["healer"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["tank"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["attachTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 12
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["font"] = "Bui Visitor1"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["yOffset"] = 12
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["height"] = 16
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["transparent"] = true

		-- raid 40
		E.db["unitframe"]["units"]["raid40"]["height"] = 27
		E.db["unitframe"]["units"]["raid40"]["width"] = 80
		E.db["unitframe"]["units"]["raid40"]["name"]["position"] = "TOP"
		E.db["unitframe"]["units"]["raid40"]["name"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["name"]["yOffset"] = -1
		E.db["unitframe"]["units"]["raid40"]["name"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid40"]["health"]["position"] = "BOTTOM"
		E.db["unitframe"]["units"]["raid40"]["health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid40"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["health"]["yOffset"] = 1
		E.db["unitframe"]["units"]["raid40"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["size"] = 10
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["damager"] = false
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["healer"] = true
		E.db["unitframe"]["units"]["raid40"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["font"] = "Bui Visitor1"
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["yOffset"] = 4
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		
		-- Boss
		E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 24
		E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = 12
		E.db["unitframe"]["units"]["boss"]["debuffs"]["xOffset"] = -1
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconAttached"] = false
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconXOffset"] = 2
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconPosition"] = "RIGHT"
		E.db["unitframe"]["units"]["boss"]["width"] = 210
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 14
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["boss"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["boss"]["name"]["yOffset"] = 1
		E.db["unitframe"]["units"]["boss"]["name"]["xOffset"] = 4
		E.db["unitframe"]["units"]["boss"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["boss"]["height"] = 50
		E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["buffs"]["anchorPoint"] = "CENTER"
		E.db["unitframe"]["units"]["boss"]["buffs"]["xOffset"] = 16
		E.db["unitframe"]["units"]["boss"]["buffs"]["attachTo"] = "HEALTH"
		E.db["unitframe"]["units"]["boss"]["power"]["height"] = 5
		
		-- Movers
		E.db["movers"]["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,0,-66"
		E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,349"
		E.db["movers"]["ElvUF_AssistMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-392"
		E.db["movers"]["ElvUF_BodyGuardMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,444"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-442,205"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,202"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,169"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,184"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-231,147"
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-232,182"
		E.db["movers"]["ElvUF_Raid40Mover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,2,415"
		E.db["movers"]["ElvUF_RaidMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,2,480"
		E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,636"
		E.db["movers"]["ElvUF_TankMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-300"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,231,147"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,232,182"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,211"
		E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-231,215"
		E.db["movers"]["TargetPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,231,215"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-442,190"

	elseif layout == 'detached' then
		E.db["benikui"]["unitframes"]["player"]["detachPortrait"] = true
		E.db["benikui"]["unitframes"]["player"]["portraitHeight"] = 47
		E.db["benikui"]["unitframes"]["player"]["portraitStyle"] = true
		E.db["benikui"]["unitframes"]["player"]["portraitStyleHeight"] = 6
		E.db["benikui"]["unitframes"]["player"]["portraitWidth"] = 110
		E.db["benikui"]["unitframes"]["target"]["detachPortrait"] = true
		E.db["benikui"]["unitframes"]["target"]["portraitHeight"] = 47
		E.db["benikui"]["unitframes"]["target"]["portraitStyle"] = true
		E.db["benikui"]["unitframes"]["target"]["portraitStyleHeight"] = 6
		E.db["benikui"]["unitframes"]["target"]["portraitWidth"] = 110
		E.db["benikui"]["unitframes"]["target"]["getPlayerPortraitSize"] = false
		E.db["benikui"]["unitframes"]["castbar"]["text"]["yOffset"] = -18

		-- Auras
		E.db["auras"]["buffs"]["horizontalSpacing"] = 3
		E.db["auras"]["buffs"]["size"] = 30
		E.db["auras"]["debuffs"]["size"] = 30
		E.db["auras"]["fadeThreshold"] = 10
		E.db["auras"]["font"] = "Bui Visitor1"
		E.db["auras"]["fontOutline"] = "MONOCROMEOUTLINE"
		E.db["auras"]["fontSize"] = 10
		E.db["auras"]["timeXOffset"] = -1
		
		-- Units
		-- general
		E.db["unitframe"]["font"] = "Bui Tukui"
		E.db["unitframe"]["fontSize"] = 15
		E.db["unitframe"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["colors"]["auraBarBuff"]["r"] = 0.1
		E.db["unitframe"]["colors"]["auraBarBuff"]["g"] = 0.1
		E.db["unitframe"]["colors"]["auraBarBuff"]["b"] = 0.1
		E.db["unitframe"]["colors"]["castClassColor"] = true
		E.db["unitframe"]["colors"]["castReactionColor"] = true
		E.db["unitframe"]["colors"]["powerclass"] = true
		E.db["unitframe"]["colors"]["power"]["MANA"]["r"] = 1
		E.db["unitframe"]["colors"]["power"]["MANA"]["g"] = 0.5
		E.db["unitframe"]["colors"]["power"]["MANA"]["b"] = 0
		E.db["unitframe"]["colors"]["castColor"]["r"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["g"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["b"] = 0.1
		E.db["unitframe"]["colors"]["transparentCastbar"] = true
		E.db["unitframe"]["colors"]["health"]["r"] = 0.1
		E.db["unitframe"]["colors"]["health"]["g"] = 0.1
		E.db["unitframe"]["colors"]["health"]["b"] = 0.1
		E.db["unitframe"]["colors"]["transparentHealth"] = true
		E.db["unitframe"]["colors"]["transparentAurabars"] = true
		E.db["unitframe"]["smoothbars"] = true
		E.db["unitframe"]["statusbar"] = "BuiFlat"
		
		-- player
		E.db["unitframe"]["units"]["player"]["aurabar"]["enable"] = false
		E.db["unitframe"]["units"]["player"]["buffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["player"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["buffs"]["fontSize"] = 14
		E.db["unitframe"]["units"]["player"]["buffs"]["noDuration"] = false
		E.db["unitframe"]["units"]["player"]["buffs"]["sizeOverride"] = 26
		E.db["unitframe"]["units"]["player"]["buffs"]["yOffset"] = 1
		E.db["unitframe"]["units"]["player"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["player"]["castbar"]["insideInfoPanel"] = true
		E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 240
		E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 140
		E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "spaced"
		if not E.db.unitframe.units.player.customTexts then E.db.unitframe.units.player.customTexts = {} end
		if E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"] == nil then E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"] = {} end
		if E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"] == nil then E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"] = {} end
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"]["font"] = "Bui Tukui"
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"]["justifyH"] = "RIGHT"
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"]["size"] = 20
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"]["text_format"] = "[health:current-percent]"
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"]["yOffset"] = -2
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"]["font"] = "Bui Tukui"
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"]["justifyH"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"]["size"] = 20
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"]["text_format"] = "[name]"
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"]["xOffset"] = 2
		E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"]["yOffset"] = -2
		E.db["unitframe"]["units"]["player"]["debuffs"]["attachTo"] = "BUFFS"
		E.db["unitframe"]["units"]["player"]["debuffs"]["fontSize"] = 14
		E.db["unitframe"]["units"]["player"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["player"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["player"]["health"]["xOffset"] = 2
		E.db["unitframe"]["units"]["player"]["health"]["yOffset"] = -25
		E.db["unitframe"]["units"]["player"]["height"] = 34
		E.db["unitframe"]["units"]["player"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["player"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["player"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["overlay"] = false
		E.db["unitframe"]["units"]["player"]["power"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 240
		E.db["unitframe"]["units"]["player"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["player"]["power"]["hideonnpc"] = true
		E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[powercolor][power:current-percent]"
		E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = 'InfoPanel'
		E.db["unitframe"]["units"]["player"]["width"] = 'fill'
		E.db["unitframe"]["units"]["player"]["power"]["xOffset"] = 2
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["smartAuraPosition"] = "DEBUFFS_ON_BUFFS"
		E.db["unitframe"]["units"]["player"]["threatStyle"] = 'GLOW'
		E.db["unitframe"]["units"]["player"]["width"] = 240
	
		-- target
		E.db["unitframe"]["units"]["target"]["aurabar"]["enable"] = false
		E.db["unitframe"]["units"]["target"]["buffs"]["fontSize"] = 14
		E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 26
		E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 1
		E.db["unitframe"]["units"]["target"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["target"]["castbar"]["insideInfoPanel"] = true
		E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 240
		if not E.db.unitframe.units.target.customTexts then E.db.unitframe.units.target.customTexts = {} end
		if E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"] == nil then E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"] = {} end
		if E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"] == nil then E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"] = {} end
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"]["font"] = "Bui Tukui"
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"]["justifyH"] = "LEFT"
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"]["size"] = 20
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"]["text_format"] = "[health:current-percent]"
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"]["xOffset"] = 2
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"]["yOffset"] = -2
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"]["font"] = "Bui Tukui"
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"]["justifyH"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"]["size"] = 20
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"]["text_format"] = "[namecolor][name:medium] [difficultycolor][smartlevel] [shortclassification]"
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"]["yOffset"] = -2
		E.db["unitframe"]["units"]["target"]["debuffs"]["anchorPoint"] = 'TOPRIGHT'
		E.db["unitframe"]["units"]["target"]["debuffs"]["fontSize"] = 14
		E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["target"]["debuffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["target"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = -40
		E.db["unitframe"]["units"]["target"]["health"]["yOffset"] = -25
		E.db["unitframe"]["units"]["target"]["height"] = 34
		E.db["unitframe"]["units"]["target"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["target"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["target"]["name"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["target"]["name"]["xOffset"] = 8
		E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = -25
		E.db["unitframe"]["units"]["target"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["overlay"] = false
		E.db["unitframe"]["units"]["target"]["power"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["target"]["power"]["detachedWidth"] = 240
		E.db["unitframe"]["units"]["target"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = false
		E.db["unitframe"]["units"]["target"]["power"]["text_format"] = "[powercolor][power:current-percent]"
		E.db["unitframe"]["units"]["target"]["power"]["xOffset"] = 4
		E.db["unitframe"]["units"]["target"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["smartAuraDisplay"] = "DISABLED"
		E.db["unitframe"]["units"]["target"]["smartAuraPosition"] = "DEBUFFS_ON_BUFFS"
		E.db["unitframe"]["units"]["target"]["width"] = 240
		E.db["unitframe"]["units"]["target"]["threatStyle"] = 'GLOW'

		-- pet
		E.db["unitframe"]["units"]["pet"]["castbar"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["castbar"]["height"] = 10
		E.db["unitframe"]["units"]["pet"]["height"] = 24
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["pet"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["pet"]["power"]["width"] = 'fill'
		
		-- focus
		E.db["unitframe"]["units"]["focus"]["castbar"]["height"] = 16
		E.db["unitframe"]["units"]["focus"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 110
		E.db["unitframe"]["units"]["focus"]["height"] = 36
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["focus"]["name"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["focus"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["focus"]["width"] = 110
		
		-- targettarget
		E.db["unitframe"]["units"]["targettarget"]["height"] = 30
		E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["targettarget"]["width"] = 130
		
		-- Party
		E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 18
		E.db["unitframe"]["units"]["party"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["party"]["debuffs"]["countFontSize"] = 14
		E.db["unitframe"]["units"]["party"]["debuffs"]["fontSize"] = 14
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 23
		E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = 1
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 8
		E.db["unitframe"]["units"]["party"]["health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["health"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[health:current-percent]"
		E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["party"]["health"]["xOffset"] = 0		
		E.db["unitframe"]["units"]["party"]["height"] = 40
		E.db["unitframe"]["units"]["party"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["party"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["party"]["name"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["party"]["name"]["yOffset"] = 16
		E.db["unitframe"]["units"]["party"]["name"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["petsGroup"]["height"] = 18
		E.db["unitframe"]["units"]["party"]["petsGroup"]["width"] = 60
		E.db["unitframe"]["units"]["party"]["petsGroup"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["petsGroup"]["yOffset"] = -1
		E.db["unitframe"]["units"]["party"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["party"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["portrait"]["height"] = 15
		E.db["unitframe"]["units"]["party"]["portrait"]["overlay"] = false
		E.db["unitframe"]["units"]["party"]["portrait"]["style"] = '3D'
		E.db["unitframe"]["units"]["party"]["portrait"]["transparent"] = true
		E.db["unitframe"]["units"]["party"]["portrait"]["width"] = 60
		E.db["unitframe"]["units"]["party"]["power"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["power"]["height"] = 8
		E.db["unitframe"]["units"]["party"]["power"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["power"]["yOffset"] = -2
		E.db["unitframe"]["units"]["party"]["power"]["xOffset"] = 2	
		E.db["unitframe"]["units"]["party"]["roleIcon"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 12
		E.db["unitframe"]["units"]["party"]["roleIcon"]["damager"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["healer"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["tank"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 15
		E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["width"] = 70
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["xOffset"] = 1
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["yOffset"] = -12
		E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 30
		E.db["unitframe"]["units"]["party"]["width"] = 220

		-- raid
		E.db["unitframe"]["units"]["raid"]["height"] = 40
		E.db["unitframe"]["units"]["raid"]["width"] = 78
		E.db["unitframe"]["units"]["raid"]["verticalSpacing"] = 5
		E.db["unitframe"]["units"]["raid"]["horizontalSpacing"] = 5
		E.db["unitframe"]["units"]["raid"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["raid"]["name"]["xOffset"] = 2
		E.db["unitframe"]["units"]["raid"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["raid"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["health"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["raid"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["damager"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["healer"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["tank"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["attachTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 12
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["font"] = "Bui Visitor1"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["yOffset"] = 12
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["transparent"] = true

		-- raid 40
		E.db["unitframe"]["units"]["raid40"]["height"] = 35
		E.db["unitframe"]["units"]["raid40"]["width"] = 78
		E.db["unitframe"]["units"]["raid40"]["verticalSpacing"] = 5
		E.db["unitframe"]["units"]["raid40"]["horizontalSpacing"] = 5
		E.db["unitframe"]["units"]["raid40"]["name"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["raid40"]["name"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["name"]["yOffset"] = -1
		E.db["unitframe"]["units"]["raid40"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid40"]["health"]["position"] = "BOTTOM"
		E.db["unitframe"]["units"]["raid40"]["health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid40"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["health"]["yOffset"] = 1
		E.db["unitframe"]["units"]["raid40"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["size"] = 10
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["damager"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["healer"] = true
		E.db["unitframe"]["units"]["raid40"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["font"] = "Bui Visitor1"
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["yOffset"] = 4
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["transparent"] = true
		
		-- Boss
		E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 24
		E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = 12
		E.db["unitframe"]["units"]["boss"]["debuffs"]["xOffset"] = -1
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconAttached"] = false
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconXOffset"] = 2
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconPosition"] = "RIGHT"
		E.db["unitframe"]["units"]["boss"]["width"] = 210
		E.db["unitframe"]["units"]["boss"]["height"] = 58
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["boss"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["boss"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["name"]["xOffset"] = 2
		E.db["unitframe"]["units"]["boss"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["buffs"]["anchorPoint"] = "CENTER"
		E.db["unitframe"]["units"]["boss"]["buffs"]["xOffset"] = 16
		E.db["unitframe"]["units"]["boss"]["buffs"]["attachTo"] = "HEALTH"
		E.db["unitframe"]["units"]["boss"]["power"]["height"] = 5
		
		-- Movers
		E.db["movers"]["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,0,-66"
		E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,349"
		E.db["movers"]["ElvUF_AssistMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,722"
		E.db["movers"]["ElvUF_BodyGuardMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-526"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,226"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,242"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,200"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,148"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,159"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-217,140"
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-189,163"
		E.db["movers"]["ElvUF_Raid40Mover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,3,638"
		E.db["movers"]["ElvUF_RaidMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,3,490"
		E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,664"
		E.db["movers"]["ElvUF_TankMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-300"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,217,140"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,189,163"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,185"
		E.db["movers"]["PlayerPortraitMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,540,163"
		E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-189,209"
		E.db["movers"]["TargetPortraitMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-540,163"
		E.db["movers"]["TargetPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,189,209"
	end
	
	if E.db.benikui.unitframes.player.detachPortrait == true then
		E.db.unitframe.units.player.portrait.width = 0
	else
		E.db.unitframe.units.player.portrait.width = 45
	end

	if E.db.benikui.unitframes.target.detachPortrait == true then
		E.db.unitframe.units.target.portrait.width = 0
	else
		E.db.unitframe.units.target.portrait.width = 45
	end

	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['Unitframes Set']
		InstallStepComplete:Show()
		titleText[5].check:Show()
	end
	E:UpdateAll(true)
end

local function SetupAddOnSkins()
	if IsAddOnLoaded('AddOnSkins') then
		-- reset the embeds in case of Skada/Recount swap
		E.private['addonskins']['EmbedSystem'] = nil
		E.private['addonskins']['EmbedSystemDual'] = nil
		E.private['addonskins']['EmbedBelowTop'] = nil
		E.private['addonskins']['TransparentEmbed'] = nil
		E.private['addonskins']['RecountBackdrop'] = false
		E.private['addonskins']['EmbedMain'] = nil
		E.private['addonskins']['EmbedLeft'] = nil
		E.private['addonskins']['EmbedRight'] = nil
		
		if IsAddOnLoaded('Recount') then
			E.private['addonskins']['EmbedMain'] = 'Recount'
			E.private['addonskins']['EmbedSystem'] = true
			E.private['addonskins']['EmbedSystemDual'] = false
			E.private['addonskins']['RecountBackdrop'] = false
			E.private['addonskins']['EmbedBelowTop'] = false
			E.private['addonskins']['TransparentEmbed'] = true
		end
		
		if IsAddOnLoaded('Skada') then
			E.private['addonskins']['EmbedSystem'] = false
			E.private['addonskins']['EmbedSystemDual'] = true
			E.private['addonskins']['EmbedBelowTop'] = false
			E.private['addonskins']['TransparentEmbed'] = true
			E.private['addonskins']['SkadaBackdrop'] = false
			E.private['addonskins']['EmbedMain'] = 'Skada'
			E.private['addonskins']['EmbedLeft'] = 'Skada'
			E.private['addonskins']['EmbedRight'] = 'Skada'
		end
		
		if IsAddOnLoaded('Details') then
			E.private['addonskins']['EmbedSystem'] = false
			E.private['addonskins']['EmbedSystemDual'] = true
			E.private['addonskins']['EmbedBelowTop'] = false
			E.private['addonskins']['TransparentEmbed'] = true
			E.private['addonskins']['DetailsBackdrop'] = false
			E.private['addonskins']['EmbedMain'] = 'Details'
			E.private['addonskins']['EmbedLeft'] = 'Details'
			E.private['addonskins']['EmbedRight'] = 'Details'
		end
		
		if IsAddOnLoaded('DBM-Core') then
			E.private['addonskins']['DBMFont'] = 'Bui Prototype'
			E.private['addonskins']['DBMFontSize'] = 10
			E.private['addonskins']['DBMFontFlag'] = 'OUTLINE'
		end
	end
end

local recountName = GetAddOnMetadata('Recount', 'Title')
local skadaName = GetAddOnMetadata('Skada', 'Title')
local dbmName = GetAddOnMetadata('DBM-Core', 'Title')
local mikName = GetAddOnMetadata('MikScrollingBattleText', 'Title')
local detailsName = GetAddOnMetadata('Details', 'Title')

local function SetupBuiAddons()
	-- Recount Profile
	if IsAddOnLoaded('Recount') then
		print(BUI.Title..format(L['- %s profile successfully created!'], recountName))
		RecountDB['profiles']['BenikUI'] = {
			['Colors'] = {
				['Other Windows'] = {
					['Title Text'] = {
						['g'] = 0.5,
						['b'] = 0,
					},
				},
				['Window'] = {
					['Title Text'] = {
						['g'] = 0.5,
						['b'] = 0,
					},
				},
				['Bar'] = {
					['Bar Text'] = {
						['a'] = 1,
					},
					['Total Bar'] = {
						['a'] = 1,
					},
				},
			},
			['DetailWindowY'] = 0,
			['DetailWindowX'] = 0,
			['GraphWindowX'] = 0,
			['Locked'] = true,
			['FrameStrata'] = '2-LOW',
			['BarTextColorSwap'] = true,
			['BarTexture'] = 'BuiEmpty',
			['CurDataSet'] = 'OverallData',
			['ClampToScreen'] = true,
			['Font'] = 'Bui Visitor1',
		}
	end

	-- Skada Profile
	if IsAddOnLoaded('Skada') then
		print(BUI.Title..format(L['- %s profile successfully created!'], skadaName))
		SkadaDB['profiles']['BenikUI'] = {
			["windows"] = {
				{
					["barheight"] = 14,
					["classicons"] = false,
					["barslocked"] = true,
					["barfont"] = "Bui Prototype",
					["title"] = {
						["font"] = "Bui Visitor1",
						["fontsize"] = 10,
						["height"] = 18,
					},
					["classcolortext"] = true,
					["barcolor"] = {
						["r"] = 1,
						["g"] = 0.5,
						["b"] = 0,
					},
					["mode"] = "Damage",
					["spark"] = false,
					["barwidth"] = 196.000061035156,
					["barfontsize"] = 10,
					["background"] = {
						["height"] = 122,
					},
					["classcolorbars"] = false,
					["bartexture"] = "BuiOnePixel",
					["point"] = "TOPRIGHT",
				}, -- [1]
				{
					["titleset"] = true,
					["barheight"] = 14,
					["classicons"] = false,
					["barslocked"] = true,
					["enabletitle"] = true,
					["wipemode"] = "",
					["set"] = "current",
					["hidden"] = false,
					["barfont"] = "Bui Prototype",
					["name"] = "Skada 2",
					["display"] = "bar",
					["barfontflags"] = "",
					["classcolortext"] = true,
					["scale"] = 1,
					["reversegrowth"] = false,
					["returnaftercombat"] = false,
					["roleicons"] = false,
					["barorientation"] = 1,
					["snapto"] = true,
					["version"] = 1,
					["modeincombat"] = "",
					["clickthrough"] = false,
					["spark"] = false,
					["bartexture"] = "BuiOnePixel",
					["barwidth"] = 201.000091552734,
					["barspacing"] = 0,
					["barfontsize"] = 10,
					["title"] = {
						["color"] = {
							["a"] = 0.8,
							["b"] = 0.3,
							["g"] = 0.1,
							["r"] = 0.1,
						},
						["bordertexture"] = "None",
						["font"] = "Bui Visitor1",
						["borderthickness"] = 2,
						["fontsize"] = 10,
						["fontflags"] = "",
						["height"] = 18,
						["margin"] = 0,
						["texture"] = "Aluminium",
					},
					["background"] = {
						["borderthickness"] = 0,
						["height"] = 122,
						["color"] = {
							["a"] = 0.2,
							["b"] = 0.5,
							["g"] = 0,
							["r"] = 0,
						},
						["bordertexture"] = "None",
						["margin"] = 0,
						["texture"] = "Solid",
					},
					["barcolor"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 0.5,
						["b"] = 0,
					},
					["barbgcolor"] = {
						["a"] = 0.6,
						["b"] = 0.3,
						["g"] = 0.3,
						["r"] = 0.3,
					},
					["classcolorbars"] = false,
					["buttons"] = {
						["segment"] = true,
						["menu"] = true,
						["mode"] = true,
						["report"] = true,
						["reset"] = true,
					},
					["point"] = "TOPRIGHT",
					["mode"] = "Healing",
				}, -- [2]
			},
		}
		Skada.db:SetProfile("BenikUI") -- set automatically the profile
	end

	-- DBM Profile
	if IsAddOnLoaded('DBM-Core') then
		print(BUI.Title..format(L['- %s profile successfully created!'], dbmName))
		DBM:CreateProfile('BenikUI')
		
		-- Warnings
		DBM_AllSavedOptions["BenikUI"]["WarningFont"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"
		DBM_AllSavedOptions["BenikUI"]["SpecialWarningFont"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"
		DBM_AllSavedOptions["BenikUI"]["SpecialWarningFontShadow"] = true
		DBM_AllSavedOptions["BenikUI"]["SpecialWarningFontStyle"] = "NONE"
		
		-- Bars
		DBT_AllPersistentOptions["BenikUI"]["DBM"]["Texture"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\Flat.tga"
		DBT_AllPersistentOptions["BenikUI"]["DBM"]["Font"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"
		DBT_AllPersistentOptions["BenikUI"]["DBM"]["Scale"] = 1
		DBT_AllPersistentOptions["BenikUI"]["DBM"]["FontSize"] = 12
		DBT_AllPersistentOptions["BenikUI"]["DBM"]["HugeScale"] = 1
		
		DBM:ApplyProfile('BenikUI')
	end
	
	-- MikScrollingBattleText
	if IsAddOnLoaded('MikScrollingBattleText') then
		print(BUI.Title..format(L['- %s profile successfully created!'], mikName))
		
		MSBTProfiles_SavedVars['profiles']['BenikUI'] = {
			["scrollAreas"] = {
				["Incoming"] = {
					["behavior"] = "MSBT_NORMAL",
					["offsetY"] = -161,
					["offsetX"] = -330,
					["animationStyle"] = "Straight",
				},
				["Outgoing"] = {
					["direction"] = "Up",
					["offsetX"] = 287,
					["behavior"] = "MSBT_NORMAL",
					["offsetY"] = -161,
					["animationStyle"] = "Straight",
				},
				["Static"] = {
					["offsetX"] = -21,
					["offsetY"] = -231,
				},
			},
			["normalFontName"] = "Bui Prototype",
			["critFontName"] = "Bui Prototype",
			["creationVersion"] = MikSBT.VERSION.."."..MikSBT.SVN_REVISION,
		}
		MikSBT.Profiles.SelectProfile('BenikUI')
	end
	
	-- Details
	if IsAddOnLoaded('Details') then
		print(BUI.Title..format(L['- %s profile successfully created!'], detailsName))
		
		_detalhes_global["__profiles"]['BenikUI'] = {
			["capture_real"] = {
				["heal"] = true,
				["spellcast"] = true,
				["miscdata"] = true,
				["aura"] = true,
				["energy"] = true,
				["damage"] = true,
			},
			["row_fade_in"] = {
				"in", -- [1]
				0.2, -- [2]
			},
			["player_details_window"] = {
				["scale"] = 1,
				["bar_texture"] = "Skyline",
				["skin"] = "ElvUI",
			},
			["numerical_system"] = 1,
			["use_row_animations"] = false,
			["report_heal_links"] = false,
			["remove_realm_from_name"] = true,
			["class_icons_small"] = "Interface\\AddOns\\Details\\images\\classes_small",
			["report_to_who"] = "",
			["overall_flag"] = 13,
			["profile_save_pos"] = true,
			["tooltip"] = {
				["header_statusbar"] = {
					0.3, -- [1]
					0.3, -- [2]
					0.3, -- [3]
					0.8, -- [4]
					false, -- [5]
					false, -- [6]
					"WorldState Score", -- [7]
				},
				["fontcolor_right"] = {
					1, -- [1]
					0.7, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["tooltip_max_targets"] = 2,
				["icon_size"] = {
					["W"] = 13,
					["H"] = 13,
				},
				["tooltip_max_pets"] = 2,
				["anchor_relative"] = "top",
				["abbreviation"] = 2,
				["anchored_to"] = 1,
				["show_amount"] = false,
				["header_text_color"] = {
					1, -- [1]
					0.9176, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["fontsize"] = 10,
				["background"] = {
					0.196, -- [1]
					0.196, -- [2]
					0.196, -- [3]
					0.8697, -- [4]
				},
				["submenu_wallpaper"] = true,
				["fontsize_title"] = 10,
				["icon_border_texcoord"] = {
					["B"] = 0.921875,
					["L"] = 0.078125,
					["T"] = 0.078125,
					["R"] = 0.921875,
				},
				["commands"] = {
				},
				["tooltip_max_abilities"] = 5,
				["fontface"] = "Friz Quadrata TT",
				["border_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					0, -- [4]
				},
				["border_texture"] = "Blizzard Tooltip",
				["anchor_offset"] = {
					0, -- [1]
					0, -- [2]
				},
				["menus_bg_texture"] = "Interface\\SPELLBOOK\\Spellbook-Page-1",
				["maximize_method"] = 1,
				["border_size"] = 16,
				["fontshadow"] = false,
				["anchor_screen_pos"] = {
					507.7, -- [1]
					-350.5, -- [2]
				},
				["anchor_point"] = "bottom",
				["menus_bg_coords"] = {
					0.309777336120606, -- [1]
					0.924000015258789, -- [2]
					0.213000011444092, -- [3]
					0.279000015258789, -- [4]
				},
				["fontcolor"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["menus_bg_color"] = {
					0.8, -- [1]
					0.8, -- [2]
					0.8, -- [3]
					0.2, -- [4]
				},
			},
			["ps_abbreviation"] = 3,
			["world_combat_is_trash"] = false,
			["update_speed"] = 0.300000011920929,
			["track_item_level"] = true,
			["windows_fade_in"] = {
				"in", -- [1]
				0.2, -- [2]
			},
			["instances_menu_click_to_open"] = false,
			["overall_clear_newchallenge"] = true,
			["time_type"] = 2,
			["instances_disable_bar_highlight"] = false,
			["trash_concatenate"] = false,
			["disable_stretch_from_toolbar"] = false,
			["disable_lock_ungroup_buttons"] = false,
			["memory_ram"] = 64,
			["disable_window_groups"] = false,
			["instances_suppress_trash"] = 0,
			["font_faces"] = {
				["menus"] = "Bui Prototype",
			},
			["segments_amount"] = 12,
			["report_lines"] = 5,
			["skin"] = "WoW Interface",
			["override_spellids"] = true,
			["use_battleground_server_parser"] = true,
			["default_bg_alpha"] = 0.5,
			["clear_ungrouped"] = true,
			["chat_tab_embed"] = {
				["enabled"] = false,
				["tab_name"] = "",
				["single_window"] = false,
			},
			["minimum_combat_time"] = 5,
			["animate_scroll"] = false,
			["cloud_capture"] = true,
			["damage_taken_everything"] = false,
			["scroll_speed"] = 2,
			["new_window_size"] = {
				["height"] = 130,
				["width"] = 320,
			},
			["memory_threshold"] = 3,
			["deadlog_events"] = 32,
			["class_specs_coords"] = {
				[62] = {
					0.251953125, -- [1]
					0.375, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[63] = {
					0.375, -- [1]
					0.5, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[250] = {
					0, -- [1]
					0.125, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[251] = {
					0.125, -- [1]
					0.25, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[252] = {
					0.25, -- [1]
					0.375, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[253] = {
					0.875, -- [1]
					1, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[254] = {
					0, -- [1]
					0.125, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[255] = {
					0.125, -- [1]
					0.25, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[66] = {
					0.125, -- [1]
					0.25, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[257] = {
					0.5, -- [1]
					0.625, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[258] = {
					0.6328125, -- [1]
					0.75, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[259] = {
					0.75, -- [1]
					0.875, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[260] = {
					0.875, -- [1]
					1, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[577] = {
					0.25, -- [1]
					0.375, -- [2]
					0.5, -- [3]
					0.625, -- [4]
				},
				[262] = {
					0.125, -- [1]
					0.25, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[581] = {
					0.375, -- [1]
					0.5, -- [2]
					0.5, -- [3]
					0.625, -- [4]
				},
				[264] = {
					0.375, -- [1]
					0.5, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[265] = {
					0.5, -- [1]
					0.625, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[266] = {
					0.625, -- [1]
					0.75, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[267] = {
					0.75, -- [1]
					0.875, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[268] = {
					0.625, -- [1]
					0.75, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[269] = {
					0.875, -- [1]
					1, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[270] = {
					0.75, -- [1]
					0.875, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[70] = {
					0.251953125, -- [1]
					0.375, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[102] = {
					0.375, -- [1]
					0.5, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[71] = {
					0.875, -- [1]
					1, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[103] = {
					0.5, -- [1]
					0.625, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[72] = {
					0, -- [1]
					0.125, -- [2]
					0.5, -- [3]
					0.625, -- [4]
				},
				[104] = {
					0.625, -- [1]
					0.75, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[73] = {
					0.125, -- [1]
					0.25, -- [2]
					0.5, -- [3]
					0.625, -- [4]
				},
				[64] = {
					0.5, -- [1]
					0.625, -- [2]
					0.125, -- [3]
					0.25, -- [4]
				},
				[105] = {
					0.75, -- [1]
					0.875, -- [2]
					0, -- [3]
					0.125, -- [4]
				},
				[65] = {
					0, -- [1]
					0.125, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[256] = {
					0.375, -- [1]
					0.5, -- [2]
					0.25, -- [3]
					0.375, -- [4]
				},
				[261] = {
					0, -- [1]
					0.125, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
				[263] = {
					0.25, -- [1]
					0.375, -- [2]
					0.375, -- [3]
					0.5, -- [4]
				},
			},
			["close_shields"] = false,
			["class_coords"] = {
				["HUNTER"] = {
					0, -- [1]
					0.25, -- [2]
					0.25, -- [3]
					0.5, -- [4]
				},
				["WARRIOR"] = {
					0, -- [1]
					0.25, -- [2]
					0, -- [3]
					0.25, -- [4]
				},
				["ROGUE"] = {
					0.49609375, -- [1]
					0.7421875, -- [2]
					0, -- [3]
					0.25, -- [4]
				},
				["MAGE"] = {
					0.25, -- [1]
					0.49609375, -- [2]
					0, -- [3]
					0.25, -- [4]
				},
				["PET"] = {
					0.25, -- [1]
					0.49609375, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["DRUID"] = {
					0.7421875, -- [1]
					0.98828125, -- [2]
					0, -- [3]
					0.25, -- [4]
				},
				["MONK"] = {
					0.5, -- [1]
					0.73828125, -- [2]
					0.5, -- [3]
					0.75, -- [4]
				},
				["DEATHKNIGHT"] = {
					0.25, -- [1]
					0.5, -- [2]
					0.5, -- [3]
					0.75, -- [4]
				},
				["MONSTER"] = {
					0, -- [1]
					0.25, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["UNKNOW"] = {
					0.5, -- [1]
					0.75, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["PRIEST"] = {
					0.49609375, -- [1]
					0.7421875, -- [2]
					0.25, -- [3]
					0.5, -- [4]
				},
				["SHAMAN"] = {
					0.25, -- [1]
					0.49609375, -- [2]
					0.25, -- [3]
					0.5, -- [4]
				},
				["Alliance"] = {
					0.49609375, -- [1]
					0.7421875, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["ENEMY"] = {
					0, -- [1]
					0.25, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["DEMONHUNTER"] = {
					0.73828126, -- [1]
					1, -- [2]
					0.5, -- [3]
					0.75, -- [4]
				},
				["Horde"] = {
					0.7421875, -- [1]
					0.98828125, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["PALADIN"] = {
					0, -- [1]
					0.25, -- [2]
					0.5, -- [3]
					0.75, -- [4]
				},
				["UNGROUPPLAYER"] = {
					0.5, -- [1]
					0.75, -- [2]
					0.75, -- [3]
					1, -- [4]
				},
				["WARLOCK"] = {
					0.7421875, -- [1]
					0.98828125, -- [2]
					0.25, -- [3]
					0.5, -- [4]
				},
			},
			["overall_clear_logout"] = false,
			["disable_alldisplays_window"] = false,
			["pvp_as_group"] = true,
			["force_activity_time_pvp"] = true,
			["windows_fade_out"] = {
				"out", -- [1]
				0.2, -- [2]
			},
			["death_tooltip_width"] = 300,
			["clear_graphic"] = true,
			["hotcorner_topleft"] = {
				["hide"] = false,
			},
			["segments_auto_erase"] = 1,
			["options_group_edit"] = true,
			["segments_amount_to_save"] = 5,
			["minimap"] = {
				["onclick_what_todo"] = 1,
				["radius"] = 160,
				["text_type"] = 1,
				["minimapPos"] = 220,
				["text_format"] = 3,
				["hide"] = false,
			},
			["instances_amount"] = 5,
			["max_window_size"] = {
				["height"] = 450,
				["width"] = 480,
			},
			["trash_auto_remove"] = true,
			["only_pvp_frags"] = false,
			["disable_stretch_button"] = false,
			["time_type_original"] = 2,
			["default_bg_color"] = 0.0941,
			["numerical_system_symbols"] = "auto",
			["segments_panic_mode"] = false,
			["window_clamp"] = {
				-8, -- [1]
				0, -- [2]
				21, -- [3]
				-14, -- [4]
			},
			["standard_skin"] = {
				["show_statusbar"] = false,
				["backdrop_texture"] = "Details Ground",
				["color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["menu_anchor"] = {
					16, -- [1]
					2, -- [2]
					["side"] = 2,
				},
				["bg_r"] = 0.3294,
				["skin"] = "ElvUI Frame Style",
				["following"] = {
					["bar_color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
					},
					["enabled"] = false,
					["text_color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
					},
				},
				["color_buttons"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["switch_healer"] = false,
				["micro_displays_locked"] = true,
				["bg_b"] = 0.3294,
				["tooltip"] = {
					["n_abilities"] = 3,
					["n_enemies"] = 3,
				},
				["desaturated_menu"] = false,
				["switch_tank_in_combat"] = false,
				["switch_all_roles_in_combat"] = false,
				["instance_button_anchor"] = {
					-27, -- [1]
					1, -- [2]
				},
				["bg_alpha"] = 0.51,
				["attribute_text"] = {
					["enabled"] = true,
					["shadow"] = true,
					["side"] = 1,
					["text_color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						0.7, -- [4]
					},
					["custom_text"] = "{name}",
					["text_face"] = "FORCED SQUARE",
					["anchor"] = {
						-19, -- [1]
						5, -- [2]
					},
					["show_timer"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
					},
					["enable_custom_text"] = false,
					["text_size"] = 12,
				},
				["libwindow"] = {
				},
				["menu_alpha"] = {
					["enabled"] = false,
					["onleave"] = 1,
					["ignorebars"] = false,
					["iconstoo"] = true,
					["onenter"] = 1,
				},
				["stretch_button_side"] = 1,
				["micro_displays_side"] = 2,
				["switch_healer_in_combat"] = false,
				["strata"] = "LOW",
				["hide_in_combat_type"] = 1,
				["statusbar_info"] = {
					["alpha"] = 1,
					["overlay"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
					},
				},
				["switch_tank"] = false,
				["hide_in_combat_alpha"] = 0,
				["switch_all_roles_after_wipe"] = false,
				["menu_icons"] = {
					true, -- [1]
					true, -- [2]
					true, -- [3]
					true, -- [4]
					true, -- [5]
					false, -- [6]
					["space"] = -2,
					["shadow"] = false,
				},
				["switch_damager"] = false,
				["show_sidebars"] = true,
				["window_scale"] = 1,
				["bars_grow_direction"] = 1,
				["row_info"] = {
					["textR_outline"] = false,
					["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
					["textL_outline"] = false,
					["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
					["textL_outline_small"] = true,
					["textL_enable_custom_text"] = false,
					["fixed_text_color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
					},
					["space"] = {
						["right"] = -2,
						["left"] = 1,
						["between"] = 1,
					},
					["texture_background_class_color"] = false,
					["textL_outline_small_color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
					["font_face_file"] = "Interface\\Addons\\Details\\fonts\\FORCED SQUARE.ttf",
					["textL_custom_text"] = "{data1}. {data3}{data2}",
					["font_size"] = 10,
					["height"] = 14,
					["texture_file"] = "Interface\\AddOns\\Details\\images\\bar_skyline",
					["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small_alpha",
					["texture_custom_file"] = "Interface\\",
					["texture_background_file"] = "Interface\\AddOns\\Details\\images\\bar_background",
					["use_spec_icons"] = true,
					["textR_enable_custom_text"] = false,
					["models"] = {
						["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
						["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
						["upper_alpha"] = 0.5,
						["lower_enabled"] = false,
						["lower_alpha"] = 0.1,
						["upper_enabled"] = false,
					},
					["fixed_texture_color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
					},
					["textL_show_number"] = true,
					["fixed_texture_background_color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						0.339636147022247, -- [4]
					},
					["backdrop"] = {
						["enabled"] = false,
						["texture"] = "Details BarBorder 2",
						["color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["size"] = 4,
					},
					["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
					["texture"] = "Skyline",
					["textR_outline_small"] = true,
					["percent_type"] = 1,
					["textR_show_data"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
					},
					["texture_background"] = "DGround",
					["alpha"] = 0.8,
					["textR_class_colors"] = false,
					["textR_outline_small_color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
					["no_icon"] = false,
					["textL_class_colors"] = false,
					["texture_custom"] = "",
					["font_face"] = "FORCED SQUARE",
					["texture_class_colors"] = true,
					["start_after_icon"] = false,
					["fast_ps_update"] = false,
					["textR_separator"] = ",",
					["textR_bracket"] = "(",
				},
				["grab_on_top"] = false,
				["hide_icon"] = true,
				["switch_damager_in_combat"] = false,
				["row_show_animation"] = {
					["anim"] = "Fade",
					["options"] = {
					},
				},
				["bars_sort_direction"] = 1,
				["auto_current"] = true,
				["toolbar_side"] = 1,
				["bg_g"] = 0.3294,
				["menu_anchor_down"] = {
					16, -- [1]
					-2, -- [2]
				},
				["hide_in_combat"] = false,
				["auto_hide_menu"] = {
					["left"] = false,
					["right"] = false,
				},
				["menu_icons_size"] = 0.899999976158142,
				["plugins_grow_direction"] = 1,
				["wallpaper"] = {
					["overlay"] = {
						0.999997794628143, -- [1]
						0.999997794628143, -- [2]
						0.999997794628143, -- [3]
						0.799998223781586, -- [4]
					},
					["width"] = 266.000061035156,
					["texcoord"] = {
						0.0480000019073486, -- [1]
						0.298000011444092, -- [2]
						0.630999984741211, -- [3]
						0.755999984741211, -- [4]
					},
					["enabled"] = true,
					["anchor"] = "all",
					["height"] = 225.999984741211,
					["alpha"] = 0.800000071525574,
					["texture"] = "Interface\\AddOns\\Details\\images\\skins\\elvui",
				},
				["total_bar"] = {
					["enabled"] = false,
					["only_in_group"] = true,
					["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
					["color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
					},
				},
				["hide_out_of_combat"] = false,
				["skin_custom"] = "",
				["ignore_mass_showhide"] = false,
				["bars_inverted"] = false,
			},
			["row_fade_out"] = {
				"out", -- [1]
				0.2, -- [2]
			},
			["use_scroll"] = false,
			["class_colors"] = {
				["HUNTER"] = {
					0.67, -- [1]
					0.83, -- [2]
					0.45, -- [3]
				},
				["WARRIOR"] = {
					0.78, -- [1]
					0.61, -- [2]
					0.43, -- [3]
				},
				["PALADIN"] = {
					0.96, -- [1]
					0.55, -- [2]
					0.73, -- [3]
				},
				["MAGE"] = {
					0.41, -- [1]
					0.8, -- [2]
					0.94, -- [3]
				},
				["ARENA_YELLOW"] = {
					0.9, -- [1]
					0.9, -- [2]
					0, -- [3]
				},
				["UNGROUPPLAYER"] = {
					0.4, -- [1]
					0.4, -- [2]
					0.4, -- [3]
				},
				["DRUID"] = {
					1, -- [1]
					0.49, -- [2]
					0.04, -- [3]
				},
				["MONK"] = {
					0, -- [1]
					1, -- [2]
					0.59, -- [3]
				},
				["DEATHKNIGHT"] = {
					0.77, -- [1]
					0.12, -- [2]
					0.23, -- [3]
				},
				["ENEMY"] = {
					0.94117, -- [1]
					0, -- [2]
					0.0196, -- [3]
					1, -- [4]
				},
				["UNKNOW"] = {
					0.2, -- [1]
					0.2, -- [2]
					0.2, -- [3]
				},
				["PRIEST"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["SHAMAN"] = {
					0, -- [1]
					0.44, -- [2]
					0.87, -- [3]
				},
				["ARENA_GREEN"] = {
					0.1, -- [1]
					0.85, -- [2]
					0.1, -- [3]
				},
				["WARLOCK"] = {
					0.58, -- [1]
					0.51, -- [2]
					0.79, -- [3]
				},
				["DEMONHUNTER"] = {
					0.64, -- [1]
					0.19, -- [2]
					0.79, -- [3]
				},
				["version"] = 1,
				["NEUTRAL"] = {
					1, -- [1]
					1, -- [2]
					0, -- [3]
				},
				["ROGUE"] = {
					1, -- [1]
					0.96, -- [2]
					0.41, -- [3]
				},
				["PET"] = {
					0.3, -- [1]
					0.4, -- [2]
					0.5, -- [3]
				},
			},
			["total_abbreviation"] = 2,
			["report_schema"] = 1,
			["overall_clear_newboss"] = true,
			["font_sizes"] = {
				["menus"] = 10,
			},
			["disable_reset_button"] = false,
			["data_broker_text"] = "",
			["instances_no_libwindow"] = false,
			["instances_segments_locked"] = false,
			["deadlog_limit"] = 16,
			["instances"] = {
				{
					["__pos"] = {
						["normal"] = {
							["y"] = -452.999885559082,
							["x"] = 650.000244140625,
							["w"] = 200.000061035156,
							["h"] = 123.999969482422,
						},
						["solo"] = {
							["y"] = 2,
							["x"] = 1,
							["w"] = 300,
							["h"] = 200,
						},
					},
					["hide_in_combat_type"] = 1,
					["backdrop_texture"] = "Details Ground",
					["color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["menu_anchor"] = {
						16, -- [1]
						2, -- [2]
						["side"] = 2,
					},
					["__snapV"] = false,
					["__snapH"] = false,
					["bg_r"] = 0.3294,
					["row_show_animation"] = {
						["anim"] = "Fade",
						["options"] = {
						},
					},
					["plugins_grow_direction"] = 1,
					["hide_out_of_combat"] = false,
					["__was_opened"] = true,
					["following"] = {
						["enabled"] = false,
						["bar_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
					},
					["color_buttons"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["switch_healer"] = false,
					["skin_custom"] = "",
					["bars_sort_direction"] = 1,
					["show_statusbar"] = false,
					["bars_grow_direction"] = 1,
					["menu_anchor_down"] = {
						16, -- [1]
						-2, -- [2]
					},
					["tooltip"] = {
						["n_abilities"] = 3,
						["n_enemies"] = 3,
					},
					["StatusBarSaved"] = {
						["center"] = "DETAILS_STATUSBAR_PLUGIN_CLOCK",
						["right"] = "DETAILS_STATUSBAR_PLUGIN_PDPS",
						["options"] = {
							["DETAILS_STATUSBAR_PLUGIN_PDPS"] = {
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									1, -- [4]
								},
								["textXMod"] = 0,
								["textFace"] = "Accidental Presidency",
								["textStyle"] = 2,
								["textAlign"] = 0,
								["textSize"] = 10,
								["textYMod"] = 1,
							},
							["DETAILS_STATUSBAR_PLUGIN_PSEGMENT"] = {
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									1, -- [4]
								},
								["segmentType"] = 2,
								["textXMod"] = 0,
								["textFace"] = "Accidental Presidency",
								["textAlign"] = 0,
								["textStyle"] = 2,
								["textSize"] = 10,
								["textYMod"] = 1,
							},
							["DETAILS_STATUSBAR_PLUGIN_CLOCK"] = {
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									1, -- [4]
								},
								["textStyle"] = 2,
								["textFace"] = "Accidental Presidency",
								["textAlign"] = 0,
								["textXMod"] = 6,
								["timeType"] = 1,
								["textSize"] = 10,
								["textYMod"] = 1,
							},
						},
						["left"] = "DETAILS_STATUSBAR_PLUGIN_PSEGMENT",
					},
					["total_bar"] = {
						["enabled"] = false,
						["only_in_group"] = true,
						["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
						["color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
					},
					["switch_all_roles_in_combat"] = false,
					["instance_button_anchor"] = {
						-27, -- [1]
						1, -- [2]
					},
					["version"] = 3,
					["attribute_text"] = {
						["show_timer"] = {
							true, -- [1]
							true, -- [2]
							true, -- [3]
						},
						["shadow"] = true,
						["side"] = 1,
						["text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							0.7, -- [4]
						},
						["custom_text"] = "{name}",
						["text_face"] = "Bui Prototype",
						["anchor"] = {
							-2, -- [1]
							3, -- [2]
						},
						["text_size"] = 10,
						["enable_custom_text"] = false,
						["enabled"] = true,
					},
					["__locked"] = true,
					["menu_alpha"] = {
						["enabled"] = false,
						["onenter"] = 1,
						["iconstoo"] = true,
						["ignorebars"] = false,
						["onleave"] = 1,
					},
					["switch_damager_in_combat"] = false,
					["micro_displays_locked"] = true,
					["switch_tank_in_combat"] = false,
					["strata"] = "LOW",
					["grab_on_top"] = false,
					["__snap"] = {
						[3] = 2,
					},
					["switch_tank"] = false,
					["hide_in_combat_alpha"] = 0,
					["switch_all_roles_after_wipe"] = false,
					["menu_icons"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
						true, -- [4]
						true, -- [5]
						false, -- [6]
						["space"] = -2,
						["shadow"] = false,
					},
					["switch_damager"] = false,
					["micro_displays_side"] = 2,
					["statusbar_info"] = {
						["alpha"] = 1,
						["overlay"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
					},
					["window_scale"] = 1,
					["libwindow"] = {
						["y"] = 25.0000705718994,
						["x"] = -209.999877929687,
						["point"] = "BOTTOMRIGHT",
					},
					["desaturated_menu"] = true,
					["bars_inverted"] = false,
					["hide_icon"] = false,
					["switch_healer_in_combat"] = false,
					["bg_alpha"] = 0,
					["auto_current"] = true,
					["toolbar_side"] = 1,
					["bg_g"] = 0.3294,
					["skin"] = "ElvUI Frame Style",
					["hide_in_combat"] = false,
					["posicao"] = {
						["normal"] = {
							["y"] = -452.999885559082,
							["x"] = 650.000244140625,
							["w"] = 200.000061035156,
							["h"] = 123.999969482422,
						},
						["solo"] = {
							["y"] = 2,
							["x"] = 1,
							["w"] = 300,
							["h"] = 200,
						},
					},
					["menu_icons_size"] = 0.899999976158142,
					["ignore_mass_showhide"] = false,
					["wallpaper"] = {
						["enabled"] = false,
						["texture"] = "Interface\\AddOns\\Details\\images\\skins\\elvui",
						["texcoord"] = {
							0.0480000019073486, -- [1]
							0.298000011444092, -- [2]
							0.630999984741211, -- [3]
							0.755999984741211, -- [4]
						},
						["overlay"] = {
							0.999997794628143, -- [1]
							0.999997794628143, -- [2]
							0.999997794628143, -- [3]
							0.799998223781586, -- [4]
						},
						["anchor"] = "all",
						["height"] = 225.999984741211,
						["alpha"] = 0.800000071525574,
						["width"] = 266.000061035156,
					},
					["stretch_button_side"] = 1,
					["auto_hide_menu"] = {
						["left"] = true,
						["right"] = false,
					},
					["show_sidebars"] = false,
					["row_info"] = {
						["textR_outline"] = false,
						["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
						["textL_outline"] = false,
						["textR_outline_small"] = true,
						["textL_outline_small"] = true,
						["percent_type"] = 1,
						["fixed_text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["space"] = {
							["right"] = 0,
							["left"] = 0,
							["between"] = 2,
						},
						["texture_background_class_color"] = false,
						["start_after_icon"] = false,
						["font_face_file"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF",
						["textL_custom_text"] = "{data1}. {data3}{data2}",
						["font_size"] = 10,
						["texture_custom_file"] = "Interface\\",
						["texture_file"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\BuiOnePixel.tga",
						["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small_alpha",
						["use_spec_icons"] = true,
						["models"] = {
							["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
							["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
							["upper_alpha"] = 0.5,
							["lower_enabled"] = false,
							["lower_alpha"] = 0.1,
							["upper_enabled"] = false,
						},
						["textR_bracket"] = "(",
						["textR_enable_custom_text"] = false,
						["backdrop"] = {
							["enabled"] = false,
							["size"] = 4,
							["color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								1, -- [4]
							},
							["texture"] = "Details BarBorder 2",
						},
						["fixed_texture_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["textL_show_number"] = true,
						["fixed_texture_background_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							0.339636147022247, -- [4]
						},
						["texture_custom"] = "",
						["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
						["texture"] = "BuiOnePixel",
						["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
						["textL_enable_custom_text"] = false,
						["textR_class_colors"] = false,
						["textL_class_colors"] = true,
						["textR_outline_small_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["texture_background"] = "BuiEmpty",
						["alpha"] = 0.8,
						["no_icon"] = false,
						["textR_show_data"] = {
							true, -- [1]
							true, -- [2]
							true, -- [3]
						},
						["textL_outline_small_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["font_face"] = "Bui Prototype",
						["texture_class_colors"] = true,
						["texture_background_file"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\Empty.tga",
						["fast_ps_update"] = false,
						["textR_separator"] = ",",
						["height"] = 14,
					},
					["bg_b"] = 0.3294,
				}, -- [1]
				{
					["__pos"] = {
						["normal"] = {
							["y"] = -452.999885559082,
							["x"] = 852.000122070313,
							["w"] = 204.000091552734,
							["h"] = 123.999969482422,
						},
						["solo"] = {
							["y"] = 2,
							["x"] = 1,
							["w"] = 300,
							["h"] = 200,
						},
					},
					["hide_in_combat_type"] = 1,
					["backdrop_texture"] = "Details Ground",
					["color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["menu_anchor"] = {
						16, -- [1]
						2, -- [2]
						["side"] = 2,
					},
					["__snapV"] = false,
					["__snapH"] = false,
					["bg_r"] = 0.3294,
					["row_show_animation"] = {
						["anim"] = "Fade",
						["options"] = {
						},
					},
					["plugins_grow_direction"] = 1,
					["hide_out_of_combat"] = false,
					["__was_opened"] = true,
					["following"] = {
						["enabled"] = false,
						["bar_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
					},
					["color_buttons"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["switch_healer"] = false,
					["skin_custom"] = "",
					["bars_sort_direction"] = 1,
					["show_statusbar"] = false,
					["bars_grow_direction"] = 1,
					["menu_anchor_down"] = {
						16, -- [1]
						-2, -- [2]
					},
					["tooltip"] = {
						["n_abilities"] = 3,
						["n_enemies"] = 3,
					},
					["StatusBarSaved"] = {
						["center"] = "DETAILS_STATUSBAR_PLUGIN_CLOCK",
						["right"] = "DETAILS_STATUSBAR_PLUGIN_PDPS",
						["options"] = {
							["DETAILS_STATUSBAR_PLUGIN_PDPS"] = {
								["textYMod"] = 1,
								["textXMod"] = 0,
								["textFace"] = "FORCED SQUARE",
								["textAlign"] = 0,
								["textStyle"] = 2,
								["textSize"] = 10,
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									0.7, -- [4]
								},
							},
							["DETAILS_STATUSBAR_PLUGIN_THREAT"] = {
								["isHidden"] = false,
								["textStyle"] = 2,
								["textYMod"] = 1,
								["segmentType"] = 2,
								["textXMod"] = 0,
								["textFace"] = "FORCED SQUARE",
								["textAlign"] = 0,
								["textSize"] = 10,
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									0.7, -- [4]
								},
							},
							["DETAILS_STATUSBAR_PLUGIN_CLOCK"] = {
								["textColor"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
									0.7, -- [4]
								},
								["textXMod"] = 6,
								["textFace"] = "FORCED SQUARE",
								["textAlign"] = 0,
								["textStyle"] = 2,
								["timeType"] = 1,
								["textSize"] = 10,
								["textYMod"] = 1,
							},
						},
						["left"] = "DETAILS_STATUSBAR_PLUGIN_THREAT",
					},
					["total_bar"] = {
						["enabled"] = false,
						["only_in_group"] = true,
						["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
						["color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
					},
					["switch_all_roles_in_combat"] = false,
					["instance_button_anchor"] = {
						-27, -- [1]
						1, -- [2]
					},
					["version"] = 3,
					["attribute_text"] = {
						["show_timer"] = {
							true, -- [1]
							true, -- [2]
							true, -- [3]
						},
						["shadow"] = true,
						["side"] = 1,
						["text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							0.7, -- [4]
						},
						["custom_text"] = "{name}",
						["text_face"] = "Bui Prototype",
						["anchor"] = {
							-2, -- [1]
							3, -- [2]
						},
						["text_size"] = 10,
						["enable_custom_text"] = false,
						["enabled"] = true,
					},
					["__locked"] = true,
					["menu_alpha"] = {
						["enabled"] = false,
						["onenter"] = 1,
						["iconstoo"] = true,
						["ignorebars"] = false,
						["onleave"] = 1,
					},
					["switch_damager_in_combat"] = false,
					["micro_displays_locked"] = true,
					["switch_tank_in_combat"] = false,
					["strata"] = "LOW",
					["grab_on_top"] = false,
					["__snap"] = {
						1, -- [1]
					},
					["switch_tank"] = false,
					["hide_in_combat_alpha"] = 0,
					["switch_all_roles_after_wipe"] = false,
					["menu_icons"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
						true, -- [4]
						true, -- [5]
						false, -- [6]
						["space"] = -2,
						["shadow"] = false,
					},
					["switch_damager"] = false,
					["micro_displays_side"] = 2,
					["statusbar_info"] = {
						["alpha"] = 1,
						["overlay"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
					},
					["window_scale"] = 1,
					["libwindow"] = {
						["y"] = 25.0000705718994,
						["x"] = -5.9998779296875,
						["point"] = "BOTTOMRIGHT",
					},
					["desaturated_menu"] = true,
					["bars_inverted"] = false,
					["hide_icon"] = false,
					["switch_healer_in_combat"] = false,
					["bg_alpha"] = 0,
					["auto_current"] = true,
					["toolbar_side"] = 1,
					["bg_g"] = 0.3294,
					["skin"] = "ElvUI Frame Style",
					["hide_in_combat"] = false,
					["posicao"] = {
						["normal"] = {
							["y"] = -452.999885559082,
							["x"] = 852.000122070313,
							["w"] = 204.000091552734,
							["h"] = 123.999969482422,
						},
						["solo"] = {
							["y"] = 2,
							["x"] = 1,
							["w"] = 300,
							["h"] = 200,
						},
					},
					["menu_icons_size"] = 0.899999976158142,
					["ignore_mass_showhide"] = false,
					["wallpaper"] = {
						["enabled"] = false,
						["texture"] = "Interface\\AddOns\\Details\\images\\skins\\elvui",
						["texcoord"] = {
							0.0480000019073486, -- [1]
							0.298000011444092, -- [2]
							0.630999984741211, -- [3]
							0.755999984741211, -- [4]
						},
						["overlay"] = {
							0.999997794628143, -- [1]
							0.999997794628143, -- [2]
							0.999997794628143, -- [3]
							0.799998223781586, -- [4]
						},
						["anchor"] = "all",
						["height"] = 225.999984741211,
						["alpha"] = 0.800000071525574,
						["width"] = 266.000061035156,
					},
					["stretch_button_side"] = 1,
					["auto_hide_menu"] = {
						["left"] = true,
						["right"] = false,
					},
					["show_sidebars"] = false,
					["row_info"] = {
						["textR_outline"] = false,
						["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
						["textL_outline"] = false,
						["textR_outline_small"] = true,
						["textL_outline_small"] = true,
						["percent_type"] = 1,
						["fixed_text_color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["space"] = {
							["right"] = 0,
							["left"] = 0,
							["between"] = 2,
						},
						["texture_background_class_color"] = false,
						["start_after_icon"] = false,
						["font_face_file"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.ttf",
						["textL_custom_text"] = "{data1}. {data3}{data2}",
						["font_size"] = 10,
						["texture_custom_file"] = "Interface\\",
						["texture_file"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\BuiOnePixel.tga",
						["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small_alpha",
						["use_spec_icons"] = true,
						["models"] = {
							["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
							["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
							["upper_alpha"] = 0.5,
							["lower_enabled"] = false,
							["lower_alpha"] = 0.1,
							["upper_enabled"] = false,
						},
						["textR_bracket"] = "(",
						["textR_enable_custom_text"] = false,
						["backdrop"] = {
							["enabled"] = false,
							["size"] = 4,
							["color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								1, -- [4]
							},
							["texture"] = "Details BarBorder 2",
						},
						["fixed_texture_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["textL_show_number"] = true,
						["fixed_texture_background_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							0.339636147022247, -- [4]
						},
						["texture_custom"] = "",
						["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
						["texture"] = "BuiOnePixel",
						["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
						["textL_enable_custom_text"] = false,
						["textR_class_colors"] = false,
						["textL_class_colors"] = true,
						["textR_outline_small_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["texture_background"] = "BuiEmpty",
						["alpha"] = 0.8,
						["no_icon"] = false,
						["textR_show_data"] = {
							true, -- [1]
							true, -- [2]
							true, -- [3]
						},
						["textL_outline_small_color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["font_face"] = "Bui Prototype",
						["texture_class_colors"] = true,
						["texture_background_file"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\Empty.tga",
						["fast_ps_update"] = false,
						["textR_separator"] = ",",
						["height"] = 14,
					},
					["bg_b"] = 0.3294,
				}, -- [2]
			},
		}
		_detalhes:ApplyProfile('BenikUI')
	end

	-- ElvUI_VisualAuraTimers
	if E.db.VAT == nil then E.db.VAT = {} end
	if IsAddOnLoaded('ElvUI_VisualAuraTimers') then
		E.db["VAT"]["enableStaticColor"] = true
		E.db["VAT"]["barHeight"] = 5
		E.db["VAT"]["spacing"] = -5
		E.db["VAT"]["staticColor"]["r"] = 1
		E.db["VAT"]["staticColor"]["g"] = 0.5
		E.db["VAT"]["staticColor"]["b"] = 0
		E.db["VAT"]["showText"] = true
		E.db["VAT"]["colors"]["minutesIndicator"]["r"] = 1
		E.db["VAT"]["colors"]["minutesIndicator"]["g"] = 0.5
		E.db["VAT"]["colors"]["minutesIndicator"]["b"] = 0
		E.db["VAT"]["colors"]["hourminutesIndicator"]["r"] = 1
		E.db["VAT"]["colors"]["hourminutesIndicator"]["g"] = 0.5
		E.db["VAT"]["colors"]["hourminutesIndicator"]["b"] = 0
		E.db["VAT"]["colors"]["expireIndicator"]["r"] = 1
		E.db["VAT"]["colors"]["expireIndicator"]["g"] = 0.5
		E.db["VAT"]["colors"]["expireIndicator"]["b"] = 0
		E.db["VAT"]["colors"]["secondsIndicator"]["r"] = 1
		E.db["VAT"]["colors"]["secondsIndicator"]["g"] = 0.5
		E.db["VAT"]["colors"]["secondsIndicator"]["b"] = 0
		E.db["VAT"]["colors"]["daysIndicator"]["r"] = 1
		E.db["VAT"]["colors"]["daysIndicator"]["g"] = 0.5
		E.db["VAT"]["colors"]["daysIndicator"]["b"] = 0
		E.db["VAT"]["colors"]["hoursIndicator"]["r"] = 1
		E.db["VAT"]["colors"]["hoursIndicator"]["g"] = 0.5
		E.db["VAT"]["colors"]["hoursIndicator"]["b"] = 0
		E.db["VAT"]["statusbarTexture"] = 'BuiFlat'
		E.db["VAT"]["position"] = 'TOP'
	end

	-- SquareMinimapButtons
	if SquareMinimapButtonOptions == nil then SquareMinimapButtonOptions = {} end
	if IsAddOnLoaded('SquareMinimapButtons') then
		SquareMinimapButtonOptions['BarEnabled'] = true
		SquareMinimapButtonOptions['ButtonsPerRow'] = 6
		SquareMinimapButtonOptions['IconSize'] = 22
		SquareMinimapButtonOptions['ButtonSpacing'] = 1
		E.db["movers"]["SquareMinimapButtonBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-258"
	end

	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['Addons Set']
		InstallStepComplete:Show()
		titleText[8].check:Show()
	end
	E:UpdateAll(true)
end

function BUI:SetupBuiDts(role)
	-- Data Texts
	E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["right"] = 'BuiMail'
	if IsAddOnLoaded('ElvUI_LocPlus') then
		E.db["datatexts"]["panels"]["RightCoordDtPanel"] = 'Time'
		E.db["datatexts"]["panels"]["LeftCoordDtPanel"] = 'Spec Switch (BenikUI)'
		E.db["datatexts"]["panels"]["BuiRightChatDTPanel"]["left"] = 'Versatility'
	else
		E.db["datatexts"]["panels"]["BuiRightChatDTPanel"]["left"] = 'Spec Switch (BenikUI)'
	end
	if role == 'tank' then
		E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["left"] = 'Attack Power'
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["left"] = 'Avoidance'
	elseif role == 'dpsMelee' then
		E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["left"] = 'Attack Power'
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["left"] = 'Haste'
	elseif role == 'healer' or 'dpsCaster' then
		E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["left"] = 'Spell/Heal Power'
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["left"] = 'Haste'
	end
	E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["middle"] = 'Orderhall (BenikUI)'
	
	E.db["datatexts"]["panels"]["BuiRightChatDTPanel"]["right"] = 'Gold'
	E.db["datatexts"]["panels"]["BuiRightChatDTPanel"]["middle"] = 'Bags'
	
	E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["right"] = 'Crit Chance'
	E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["middle"] = 'Mastery'

	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['DataTexts Set']
		InstallStepComplete:Show()
		titleText[7].check:Show()
	end
	E:UpdateAll(true)
end

local function ResetAll()
	InstallNextButton:Disable()
	InstallPrevButton:Disable()
	InstallOption1Button:Hide()
	InstallOption1Button:SetScript('OnClick', nil)
	InstallOption1Button:SetText('')
	InstallOption2Button:Hide()
	InstallOption2Button:SetScript('OnClick', nil)
	InstallOption2Button:SetText('')
	InstallOption3Button:Hide()
	InstallOption3Button:SetScript('OnClick', nil)
	InstallOption3Button:SetText('')	
	InstallOption4Button:Hide()
	InstallOption4Button:SetScript('OnClick', nil)
	InstallOption4Button:SetText('')
	BUIInstallFrame.SubTitle:SetText('')
	BUIInstallFrame.Desc1:SetText('')
	BUIInstallFrame.Desc2:SetText('')
	BUIInstallFrame.Desc3:SetText('')
	BUIInstallFrame.Desc4:SetText('')
	BUIInstallFrame:Size(500, 400)
	BUITitleFrame:Size(140, 400)
end

local function InstallComplete()
	E.private.install_complete = E.version
	E.db.benikui.installed = true
	E.private.benikui.install_complete = BUI.Version
	
	ReloadUI()
end

local function SetPage(PageNum)
	CURRENT_PAGE = PageNum
	ResetAll()

	InstallStatus.anim.progress:SetChange(PageNum)
	InstallStatus.anim.progress:Play()
	
	local f = BUIInstallFrame
	
	if PageNum == MAX_PAGE then
		InstallNextButton:Disable()
	else
		InstallNextButton:Enable()
	end
	
	if PageNum == 1 then
		InstallPrevButton:Disable()
	else
		InstallPrevButton:Enable()
	end

	if PageNum == 1 then
		f.SubTitle:SetFormattedText(L['Welcome to BenikUI version %s, for ElvUI %s.'], BUI.Version, E.version)
		f.Desc1:SetFormattedText("%s", L["By pressing the Continue button, BenikUI will be applied in your current ElvUI installation.\n\n|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"])
		f.Desc2:SetFormattedText("%s", BUI:cOption(L['\nBenikUI options are marked with light blue color, inside ElvUI options.']))
		f.Desc3:SetFormattedText("%s", L['Please press the continue button to go onto the next step.'])
		titleText[1].text:SetText(titleText[1].text:GetText())		
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', InstallComplete)
		InstallOption1Button:SetFormattedText("%s", L['Skip Process'])			
	elseif PageNum == 2 then
		f.SubTitle:SetFormattedText("%s", L['Layout'])
		f.Desc1:SetFormattedText("%s", L['This part of the installation will change the default ElvUI look.'])
		f.Desc2:SetFormattedText("%s", L['Please click the button below to apply the new layout.'])
		f.Desc3:SetFormattedText("%s", L['Importance: |cff07D400High|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', SetupBuiLayout)
		InstallOption1Button:SetFormattedText("%s", L['Setup Layout'])
	elseif PageNum == 3 then
		f.SubTitle:SetFormattedText("%s", L['Color Themes'])
		f.Desc1:SetFormattedText("%s", L['This part of the installation will apply a Color Theme'])
		f.Desc2:SetFormattedText("%s", L['Please click a button below to apply a color theme.'])
		f.Desc3:SetFormattedText("%s", L['Importance: |cffD3CF00Medium|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() BUI:SetupBuiColors(); BUI:BuiColorThemes('Elv'); end)
		InstallOption1Button:SetFormattedText("%s", L['ElvUI'])
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() BUI:SetupBuiColors(); BUI:BuiColorThemes('Diablo'); end)
		InstallOption2Button:SetFormattedText("%s", L['Diablo'])
		InstallOption3Button:Show()
		InstallOption3Button:SetScript('OnClick', function() BUI:SetupBuiColors(); BUI:BuiColorThemes('Mists'); end)
		InstallOption3Button:SetFormattedText("%s", L['Mists'])
		InstallOption4Button:Show()
		InstallOption4Button:SetScript('OnClick', function() BUI:SetupBuiColors(); BUI:BuiColorThemes('Hearthstone'); end)
		InstallOption4Button:SetFormattedText("%s", L['Hearthstone'])	
	elseif PageNum == 4 then
		f.SubTitle:SetFormattedText("%s", L['Chat'])
		f.Desc1:SetFormattedText("%s", L['This part of the installation process sets up your chat fonts and colors.'])
		f.Desc2:SetFormattedText("%s", L['Please click the button below to setup your chat windows.'])
		f.Desc3:SetFormattedText("%s", L['Importance: |cffD3CF00Medium|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', SetupBuiChat)
		InstallOption1Button:SetFormattedText("%s", L['Setup Chat'])
	elseif PageNum == 5 then
		f.SubTitle:SetFormattedText("%s", L['UnitFrames'])
		f.Desc1:SetFormattedText("%s", L["This part of the installation process will reposition your Unitframes and will enable the EmptyBars."])
		f.Desc2:SetFormattedText("%s", L['Please click the button below to setup your Unitframes.'])
		f.Desc3:SetFormattedText("%s", L['Importance: |cff07D400High|r'])
		f.Desc4:SetFormattedText("%s", L['Buttons must be clicked twice'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() SetupUnitframes('normal') end)
		InstallOption1Button:SetFormattedText("%s", L['Setup Unitframes'].." - 1")
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() SetupUnitframes('detached') end)
		InstallOption2Button:SetFormattedText("%s", L['Setup Unitframes'].." - 2")		
	elseif PageNum == 6 then
		f.SubTitle:SetFormattedText("%s", L['ActionBars'])
		f.Desc1:SetFormattedText("%s", L['This part of the installation process will reposition your Actionbars and will enable backdrops'])
		f.Desc2:SetFormattedText("%s", L['Please click the button below to setup your actionbars.'])
		f.Desc3:SetFormattedText("%s", L['Importance: |cff07D400High|r'])
		f.Desc4:SetFormattedText("%s", L['Buttons must be clicked twice'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() SetupActionbars('big') end)
		InstallOption1Button:SetFormattedText("%s", L['Setup ActionBars'].." - 1")
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() SetupActionbars('small') end)
		InstallOption2Button:SetFormattedText("%s", L['Setup ActionBars'].." - 2")
	elseif PageNum == 7 then
		f.SubTitle:SetFormattedText("%s", L['DataTexts'])
		f.Desc1:SetFormattedText("%s", L["This part of the installation process will fill BenikUI datatexts.\n\n|cffff8000This doesn't touch ElvUI datatexts|r"])
		f.Desc2:SetFormattedText("%s", L['Please click the button below to setup your datatexts.'])
		f.Desc3:SetFormattedText("%s", L['Importance: |cffD3CF00Medium|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() E.db.datatexts.panels.BuiLeftChatDTPanel.left = nil; E.db.datatexts.panels.BuiLeftChatDTPanel.middle = nil; BUI:SetupBuiDts('tank') end)
		InstallOption1Button:SetFormattedText("%s", TANK)
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() E.db.datatexts.panels.BuiLeftChatDTPanel.left = nil; E.db.datatexts.panels.BuiLeftChatDTPanel.middle = nil; BUI:SetupBuiDts('healer') end)
		InstallOption2Button:SetFormattedText("%s", HEALER)
		InstallOption3Button:Show()
		InstallOption3Button:SetScript('OnClick', function() E.db.datatexts.panels.BuiLeftChatDTPanel.left = nil; E.db.datatexts.panels.BuiLeftChatDTPanel.middle = nil; BUI:SetupBuiDts('dpsMelee') end)
		InstallOption3Button:SetFormattedText("%s", L['Physical DPS'])
		InstallOption4Button:Show()
		InstallOption4Button:SetScript('OnClick', function() E.db.datatexts.panels.BuiLeftChatDTPanel.left = nil; E.db.datatexts.panels.BuiLeftChatDTPanel.middle = nil; BUI:SetupBuiDts('dpsCaster') end)
		InstallOption4Button:SetFormattedText("%s", L['Caster DPS'])
	elseif PageNum == 8 then
		f.SubTitle:SetFormattedText("%s", ADDONS)
		f.Desc1:SetFormattedText("%s", L['This part of the installation process will apply changes to the addons like Recount, DBM and ElvUI plugins'])
		f.Desc2:SetFormattedText("%s", L['Please click the button below to setup your addons.'])
		f.Desc3:SetFormattedText("%s", L['Importance: |cffD3CF00Medium|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() SetupBuiAddons(); SetupAddOnSkins(); end)
		InstallOption1Button:SetFormattedText("%s", L['Setup Addons'])	
	elseif PageNum == 9 then
		f.SubTitle:SetFormattedText("%s", L['Installation Complete'])
		f.Desc1:SetFormattedText("%s", L['You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org.'])
		f.Desc2:SetFormattedText("%s", L['Please click the button below so you can setup variables and ReloadUI.'])			
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', InstallComplete)
		InstallOption1Button:SetFormattedText("%s", L['Finished'])				
		BUIInstallFrame:Size(500, 400)
		BUITitleFrame:Size(140, 400)
		if InstallStepComplete then
			InstallStepComplete.message = BUI.Title..L['Installed']
			InstallStepComplete:Show()		
		end
	end
end

local function NextPage()	
	if CURRENT_PAGE ~= MAX_PAGE then
		CURRENT_PAGE = CURRENT_PAGE + 1
		SetPage(CURRENT_PAGE)
		titleText[CURRENT_PAGE].text.anim.color:SetChange(1, 1, 0)
		titleText[CURRENT_PAGE].text.anim:Play()
		E:UIFrameFadeIn(titleText[CURRENT_PAGE].hoverTex, .3, 0, 1)
		if CURRENT_PAGE > 1 then
			E:UIFrameFadeIn(titleText[CURRENT_PAGE - 1].hoverTex, .3, 1, 0)
			titleText[CURRENT_PAGE - 1].text.anim.color:SetChange(0, 0.68, 0.93)
			titleText[CURRENT_PAGE - 1].text.anim:Play()
		end
	end
end

local function PreviousPage()
	if CURRENT_PAGE ~= 1 then
		E:UIFrameFadeIn(titleText[CURRENT_PAGE].hoverTex, .3, 1, 0)
		titleText[CURRENT_PAGE].text.anim.color:SetChange(0, 0.68, 0.93)
		titleText[CURRENT_PAGE].text.anim:Play()		
		CURRENT_PAGE = CURRENT_PAGE - 1
		SetPage(CURRENT_PAGE)
		E:UIFrameFadeIn(titleText[CURRENT_PAGE].hoverTex, .3, 0, 1)
		titleText[CURRENT_PAGE].text.anim.color:SetChange(1, 1, 0)
		titleText[CURRENT_PAGE].text.anim:Play()
	end
end

function BUI:SetupBenikUI()	
	if not InstallStepComplete then
		local imsg = CreateFrame('Frame', 'InstallStepComplete', E.UIParent)
		imsg:Size(418, 72)
		imsg:Point('TOP', 0, -190)
		imsg:Hide()
		imsg:SetScript('OnShow', function(self)
			if self.message then 
				PlaySoundFile([[Sound\Interface\alarmclockwarning2.ogg]])
				self.text:SetText(self.message)
				UIFrameFadeOut(self, 3.5, 1, 0)
				E:Delay(4, function() self:Hide() end)	
				self.message = nil
			else
				self:Hide()
			end
		end)
		
		imsg.firstShow = false
		
		imsg.bg = imsg:CreateTexture(nil, 'BACKGROUND')
		imsg.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
		imsg.bg:SetPoint('BOTTOM')
		imsg.bg:Size(326, 103)
		imsg.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
		imsg.bg:SetVertexColor(1, 1, 1, 0.6)
		
		imsg.lineTop = imsg:CreateTexture(nil, 'BACKGROUND')
		imsg.lineTop:SetDrawLayer('BACKGROUND', 2)
		imsg.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
		imsg.lineTop:SetPoint('TOP')
		imsg.lineTop:Size(418, 7)
		imsg.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
		
		imsg.lineBottom = imsg:CreateTexture(nil, 'BACKGROUND')
		imsg.lineBottom:SetDrawLayer('BACKGROUND', 2)
		imsg.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
		imsg.lineBottom:SetPoint('BOTTOM')
		imsg.lineBottom:Size(418, 7)
		imsg.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
		
		imsg.text = imsg:CreateFontString(nil, 'ARTWORK')
		imsg.text:FontTemplate(nil, 32)
		imsg.text:Point('CENTER', 0, -4)
		imsg.text:SetTextColor(1, 0.82, 0)
		imsg.text:SetJustifyH('CENTER')
	end

	--Create Frame
	if not BUIInstallFrame then
		local f = CreateFrame('Button', 'BUIInstallFrame', E.UIParent)
		f.SetPage = SetPage
		f:Size(500, 400)
		f:SetTemplate('Transparent')
		f:SetPoint('CENTER', 70, 0)
		f:SetFrameStrata('TOOLTIP')
		f:Style('Outside')
		
		f.Title = f:CreateFontString(nil, 'OVERLAY')
		f.Title:FontTemplate(nil, 17, nil)
		f.Title:Point('TOP', 0, -5)
		f.Title:SetFormattedText("%s%s", BUI.Title, L['Installation'])
		
		f.Next = CreateFrame('Button', 'InstallNextButton', f, 'UIPanelButtonTemplate')
		f.Next:StripTextures()
		f.Next:SetTemplate('Default', true)
		f.Next:Size(110, 25)
		f.Next:Point('BOTTOMRIGHT', -5, 5)
		f.Next:SetFormattedText("%s", CONTINUE)
		f.Next:Disable()
		f.Next:SetScript('OnClick', NextPage)
		E.Skins:HandleButton(f.Next, true)
		
		f.Prev = CreateFrame('Button', 'InstallPrevButton', f, 'UIPanelButtonTemplate')
		f.Prev:StripTextures()
		f.Prev:SetTemplate('Default', true)
		f.Prev:Size(110, 25)
		f.Prev:Point('BOTTOMLEFT', 5, 5)
		f.Prev:SetFormattedText("%s", PREVIOUS)	
		f.Prev:Disable()
		f.Prev:SetScript('OnClick', PreviousPage)
		E.Skins:HandleButton(f.Prev, true)
		
		f.Status = CreateFrame('StatusBar', 'InstallStatus', f)
		f.Status:SetFrameLevel(f.Status:GetFrameLevel() + 2)
		f.Status:CreateBackdrop('Default')
		f.Status:SetStatusBarTexture(E['media'].normTex)
		f.Status:SetStatusBarColor(0, 0.68, 0.93)
		f.Status:SetMinMaxValues(0, MAX_PAGE)
		f.Status:Point('TOPLEFT', f.Prev, 'TOPRIGHT', 6, -2)
		f.Status:Point('BOTTOMRIGHT', f.Next, 'BOTTOMLEFT', -6, 2)
		-- Setup StatusBar Animation
		f.Status.anim = CreateAnimationGroup(f.Status)
		f.Status.anim.progress = f.Status.anim:CreateAnimation("Progress")
		f.Status.anim.progress:SetSmoothing("Out")
		f.Status.anim.progress:SetDuration(.3)
		
		f.Status.text = f.Status:CreateFontString(nil, 'OVERLAY')
		f.Status.text:FontTemplate()
		f.Status.text:SetPoint('CENTER')
		f.Status.text:SetFormattedText("%s / %s", CURRENT_PAGE, MAX_PAGE)
		f.Status:SetScript('OnValueChanged', function(self)
			self.text:SetText(ceil(self:GetValue())..' / '..MAX_PAGE)
		end)
		
		f.Option1 = CreateFrame('Button', 'InstallOption1Button', f, 'UIPanelButtonTemplate')
		f.Option1:StripTextures()
		f.Option1:Size(160, 30)
		f.Option1:Point('BOTTOM', 0, 45)
		f.Option1:SetText('')
		f.Option1:Hide()
		E.Skins:HandleButton(f.Option1, true)
		
		f.Option2 = CreateFrame('Button', 'InstallOption2Button', f, 'UIPanelButtonTemplate')
		f.Option2:StripTextures()
		f.Option2:Size(110, 30)
		f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45)
		f.Option2:SetText('')
		f.Option2:Hide()
		f.Option2:SetScript('OnShow', function() f.Option1:SetWidth(110); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOMRIGHT', f, 'BOTTOM', -4, 45) end)
		f.Option2:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOM', 0, 45) end)
		E.Skins:HandleButton(f.Option2, true)		
		
		f.Option3 = CreateFrame('Button', 'InstallOption3Button', f, 'UIPanelButtonTemplate')
		f.Option3:StripTextures()
		f.Option3:Size(100, 30)
		f.Option3:Point('LEFT', f.Option2, 'RIGHT', 4, 0)
		f.Option3:SetText('')
		f.Option3:Hide()
		f.Option3:SetScript('OnShow', function() f.Option1:SetWidth(100); f.Option1:ClearAllPoints(); f.Option1:Point('RIGHT', f.Option2, 'LEFT', -4, 0); f.Option2:SetWidth(100); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOM', f, 'BOTTOM', 0, 45) end)
		f.Option3:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOM', 0, 45); f.Option2:SetWidth(110); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45) end)
		E.Skins:HandleButton(f.Option3, true)			
		
		f.Option4 = CreateFrame('Button', 'InstallOption4Button', f, 'UIPanelButtonTemplate')
		f.Option4:StripTextures()
		f.Option4:Size(100, 30)
		f.Option4:Point('LEFT', f.Option3, 'RIGHT', 4, 0)
		f.Option4:SetText('')
		f.Option4:Hide()
		f.Option4:SetScript('OnShow', function() 
			f.Option1:Width(100)
			f.Option2:Width(100)
			
			f.Option1:ClearAllPoints(); 
			f.Option1:Point('RIGHT', f.Option2, 'LEFT', -4, 0); 
			f.Option2:ClearAllPoints(); 
			f.Option2:Point('BOTTOMRIGHT', f, 'BOTTOM', -4, 45)
		end)
		f.Option4:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOM', 0, 45); f.Option2:SetWidth(110); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45) end)
		E.Skins:HandleButton(f.Option4, true)			

		f.SubTitle = f:CreateFontString(nil, 'OVERLAY')
		f.SubTitle:FontTemplate(nil, 15, nil)		
		f.SubTitle:Point('TOP', 0, -40)
		
		f.Desc1 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc1:FontTemplate()	
		f.Desc1:Point('TOP', 0, -75)	
		f.Desc1:Width(f:GetWidth() - 40)
		
		f.Desc2 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc2:FontTemplate()	
		f.Desc2:Point('TOP', 0, -125)		
		f.Desc2:Width(f:GetWidth() - 40)
		
		f.Desc3 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc3:FontTemplate()	
		f.Desc3:Point('TOP', 0, -175)	
		f.Desc3:Width(f:GetWidth() - 40)
		
		f.Desc4 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc4:FontTemplate()	
		f.Desc4:Point('BOTTOM', 0, 75)	
		f.Desc4:Width(f:GetWidth() - 40)
	
		local close = CreateFrame('Button', nil, f, 'UIPanelCloseButton')
		close:SetPoint('TOPRIGHT', f, 'TOPRIGHT')
		close:SetScript('OnClick', function()
			f:Hide()
		end)		
		E.Skins:HandleCloseButton(close)

		f.tutorialImage = f:CreateTexture(nil, 'OVERLAY')
		f.tutorialImage:Size(256, 128)
		f.tutorialImage:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga')
		f.tutorialImage:Point('BOTTOM', 0, 75)

		f.side = CreateFrame('Frame', 'BUITitleFrame', f)
		f.side:SetTemplate('Transparent')
		f.side:Style('Outside')
		f.side:Size(140, 400)
		
		for i = 1, MAX_PAGE do
			titleText[i] = CreateFrame('Frame', nil, f.side)
			titleText[i]:Size(140, 20)
			titleText[i].text = titleText[i]:CreateFontString(nil, 'OVERLAY')
			titleText[i].text:SetPoint('LEFT', 27, 0)
			titleText[i].text:FontTemplate(nil, 12)
			titleText[i].text:SetTextColor(0, 0.68, 0.93)
			titleText[i].text:SetJustifyV("MIDDLE")
			
			-- Create animation
			titleText[i].text.anim = CreateAnimationGroup(titleText[i].text)
			titleText[i].text.anim.color = titleText[i].text.anim:CreateAnimation("Color")
			titleText[i].text.anim.color:SetColorType("Text")
			
			titleText[i].hoverTex = titleText[i]:CreateTexture(nil, 'OVERLAY')
			titleText[i].hoverTex:SetTexture([[Interface\MONEYFRAME\Arrow-Right-Up]])
			titleText[i].hoverTex:Size(14)
			titleText[i].hoverTex:Point('RIGHT', titleText[i].text, 'LEFT', 4, -2)
			titleText[i].hoverTex:SetAlpha(0)
			titleText[i].check = titleText[i]:CreateTexture(nil, 'OVERLAY')
			titleText[i].check:Size(20)
			titleText[i].check:Point('LEFT', titleText[i].text, 'RIGHT', 0, -2)
			titleText[i].check:SetTexture([[Interface\BUTTONS\UI-CheckBox-Check]])
			titleText[i].check:Hide()

			if i == 1 then titleText[i].text:SetFormattedText("%s", L['Welcome'])
				elseif i == 2 then titleText[i].text:SetFormattedText("%s", L['Layout'])
				elseif i == 3 then titleText[i].text:SetFormattedText("%s", L['Color Themes'])
				elseif i == 4 then titleText[i].text:SetFormattedText("%s", L['Chat'])
				elseif i == 5 then titleText[i].text:SetFormattedText("%s", L['UnitFrames'])
				elseif i == 6 then titleText[i].text:SetFormattedText("%s", L['ActionBars'])
				elseif i == 7 then titleText[i].text:SetFormattedText("%s", L['DataTexts'])
				elseif i == 8 then titleText[i].text:SetFormattedText("%s", ADDONS)
				elseif i == 9 then titleText[i].text:SetFormattedText("%s", L['Finish'])
			end

			if(i == 1) then
				titleText[i]:Point('TOP', f.side, 'TOP', 0, -40)
			else
				titleText[i]:Point('TOP', titleText[i - 1], 'BOTTOM')
			end
		end
	end
	
	-- Animations
	BUITitleFrame:Point('LEFT', 'BUIInstallFrame', 'LEFT', E.PixelMode and -1 or -3, 0)
	local animGroup = CreateAnimationGroup(BUITitleFrame)
	local anim = animGroup:CreateAnimation("Move")
	anim:SetOffset(-140, 0)
	anim:SetDuration(1)
	anim:SetSmoothing("Bounce")
	anim:Play()
	
	BUIInstallFrame:Show()
	NextPage()
end