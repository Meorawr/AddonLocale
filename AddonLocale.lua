local ADDON_NAME = ...
local L

local AVAILABLE_LOCALES = {
	deDE = "Deutsch",
	enUS = "English",
	esES = "Español (EU)",
	esMX = "Español (AL)",
	frFR = "Français",
	itIT = "Italiano",
	koKR = "한국어",
	ptBR = "Português",
	ruRU = "Pусский",
	zhCN = "简体中文",
	zhTW = "繁體中文",
}

local EFFECTIVE_LOCALE

local function GenerateLocaleDisplayText(localeName)
	local localeNameLong = AVAILABLE_LOCALES[localeName] or UNKNOWN
	return string.format(L.LOCALE_DISPLAY_TEXT, localeName, localeNameLong)
end

local function GenerateCommandHyperlink(command, ...)
	local prefix = string.format("|cff82c5ff|Hgarrmission:addonlocale:%1$s:%2$s|h[", command, string.join(" ", ...))
	local suffix = "]|h|r"
	return prefix, suffix
end

local function DisplayFormattedMessage(message, ...)
	ChatFrame_DisplaySystemMessageInCurrent(string.format(message, ...))
end

local function DisplayPreferredAddonLocale()
	if GAME_LOCALE then
		DisplayFormattedMessage(L.PREFERRED_LOCALE_CURRENT, GenerateLocaleDisplayText(GAME_LOCALE))
	else
		DisplayFormattedMessage(L.PREFERRED_LOCALE_NOT_SET)
	end

	DisplayFormattedMessage(L.PROMPT_SET_LOCALE, GenerateCommandHyperlink("set", ""))

	if GAME_LOCALE then
		DisplayFormattedMessage(L.PROMPT_RESET_LOCALE, GenerateCommandHyperlink("reset"))
	end
end

local function DisplayAvailableAddonLocales()
	DisplayFormattedMessage(L.PROMPT_SET_LOCALE_CHOICES)

	local locales = {}

	for localeName in pairs(AVAILABLE_LOCALES) do
		table.insert(locales, localeName)
	end

	table.sort(locales)

	for _, localeName in ipairs(locales) do
		local choiceLinkPrefix, choiceLinkSuffix = GenerateCommandHyperlink("set", localeName)
		local choiceLinkInfix = GenerateLocaleDisplayText(localeName)
		local choiceLink = string.join("", choiceLinkPrefix, choiceLinkInfix, choiceLinkSuffix)

		DisplayFormattedMessage(DASH_WITH_TEXT, choiceLink)
	end
end

local function SetPreferredAddonLocale(localeName)
	if localeName == nil then
		GAME_LOCALE = nil
		DisplayFormattedMessage(L.PREFERRED_LOCALE_RESET)
	elseif AVAILABLE_LOCALES[localeName] then
		GAME_LOCALE = localeName
		DisplayFormattedMessage(L.PREFERRED_LOCALE_CHANGED, GenerateLocaleDisplayText(localeName))
	else
		DisplayFormattedMessage(L.ERR_INVALID_LOCALE, localeName)
		return
	end

	if (GAME_LOCALE or GetLocale()) ~= EFFECTIVE_LOCALE then
		DisplayFormattedMessage(L.PROMPT_RELOAD_UI, GenerateCommandHyperlink("reload"))
	end
end

local function ProcessCommand(command, ...)
	if command == "" then
		DisplayPreferredAddonLocale()
	elseif command == "set" or command == L.SLASH_COMMAND_SET then
		local localeName = string.trim((...) or "")

		if localeName == "" then
			DisplayAvailableAddonLocales()
		else
			SetPreferredAddonLocale(localeName)
		end
	elseif command == "reset" or command == L.SLASH_COMMAND_RESET then
		SetPreferredAddonLocale(nil)
	elseif command == "reload" then
		C_UI.Reload()
	else
		-- Treat '/addonlocale <locale name>' as-if "set" was executed.
		local localeName = command
		SetPreferredAddonLocale(localeName)
	end
end

local function OnHyperlinkClick(link)
	local linkType, linkSubtype, linkCommand = string.split(":", link, 3)

	if linkType == "garrmission" and linkSubtype == "addonlocale" then
		ProcessCommand(string.split(":", linkCommand))
	end
end

local function OnSlashCommand(data)
	ProcessCommand(string.split(" ", data))
end

local function OnAddonLoaded(owner, addonName)
	if addonName == ADDON_NAME then
		EFFECTIVE_LOCALE = GAME_LOCALE or GetLocale()
		L = setmetatable(AddonLocale_Strings[EFFECTIVE_LOCALE] or {}, { __index = AddonLocale_Strings.enUS })
		EventRegistry:UnregisterCallback("ADDON_LOADED", owner)
		EventRegistry:UnregisterFrameEvent("ADDON_LOADED")
	end
end

SLASH_ADDONLOCALE1 = "/addonlocale"
SlashCmdList["ADDONLOCALE"] = OnSlashCommand
hooksecurefunc("SetItemRef", OnHyperlinkClick)

EventRegistry:RegisterFrameEvent("ADDON_LOADED")
EventRegistry:RegisterCallback("ADDON_LOADED", OnAddonLoaded, {})
