# AddonLocale

World of Warcraft addon that allows configuring a custom client locale to be respected by addons that use AceLocale.

## Usage

- Run `/addonlocale` to show the currently configured locale, if any.
- Run `/addonlocale set <locale name>` to configure a custom locale for addons.
- Run `/addonlocale reset` to reset any custom locale configuration and allow the default client locale to be used.

## Integration

AddOns that use AceLocale will automatically be configured to use the appropriate locale. Otherwise, AddOns should check for the presence of a `GAME_LOCALE` global variable and use that in-preference to the return from [GetLocale], as shown below. It may also be beneficial to list `!!AddonLocale` as an optional dependency in your TOC.

```lua
if (GAME_LOCALE or GetLocale()) == "deDE" then
    -- Set up translations for the deDE locale.
end
```

## License

This addon is published under the terms of the [Creative Commons Zero v1.0 Universal] (CC0-1.0) license, of which a copy can be found in the [LICENSE] file at the root of this repository.

## Contributors

- Daniel "Meorawr" Yates \<me@meorawr.io>

[Creative Commons Zero v1.0 Universal]: https://spdx.org/licenses/CC0-1.0.html
[GetLocale]: https://wowpedia.fandom.com/wiki/API_GetLocale
[LICENSE]: LICENSE
