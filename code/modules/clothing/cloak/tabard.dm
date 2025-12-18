
/obj/item/clothing/cloak/tabard
	name = "tabard"
	desc = "A common short coat commonly worn by just about anyone."
	color = null
	icon_state = "tabard"
	item_state = "tabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	var/picked

/obj/item/clothing/cloak/tabard/update_overlays()
	. = ..()
	if(!get_detail_tag())
		return
	var/mutable_appearance/pic = mutable_appearance(icon, "[icon_state][detail_tag]")
	pic.appearance_flags = RESET_COLOR
	if(get_detail_color())
		pic.color = get_detail_color()
	. += pic

/obj/item/clothing/cloak/tabard/get_heraldry_designs()
	return list("None", "Symbol", "Split", "Quadrants", "Boxes", "Diamonds")

/obj/item/clothing/cloak/tabard/proc/get_heraldry_symbols(mob/user, design)
	return list("chalice","psy","peace","z","imp","skull","widow","arrow")

/obj/item/clothing/cloak/tabard/heraldry_resolve_design(mob/user, design)
	var/list/symbols = get_heraldry_symbols(user, design)
	if(design == "Symbol" && length(symbols))
		design = input(user, "Select a symbol.","Tabard Design") as null|anything in symbols
		if(!design)
			return null // abort setup
		return "_[design]"
	return ..() // base design

/obj/item/clothing/cloak/tabard/knight
	color = CLOTHING_PLUM_PURPLE
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/cloak/tabard/knight/select_heraldry(mob/user)
	return SECONDARY_ATTACK_CALL_NORMAL // pretend heraldry doesn't even exist for this

/obj/item/clothing/cloak/tabard/crusader
	detail_tag = "_psy"

/obj/item/clothing/cloak/tabard/crusader/Initialize()
	. = ..()
	update_appearance(UPDATE_ICON)

/obj/item/clothing/cloak/tabard/crusader/get_heraldry_designs()
	return list("Default", "Gold Cross", "Jeruah", "BlackGold", "BlackWhite")

/obj/item/clothing/cloak/tabard/crusader/apply_forced_heraldry_color(design)
	if(uses_lord_coloring)
		return TRUE // skip color selection entirely
	switch(design)
		if("Gold Cross")
			detail_color = "#b5b004"
			return TRUE
		if("Jeruah")
			detail_color = "#b5b004"
			color = "#249589"
			return TRUE
		if("BlackGold")
			detail_color = CLOTHING_MUSTARD_YELLOW
			color = CLOTHING_SOOT_BLACK
			return TRUE
		if("BlackWhite")
			detail_color = CLOTHING_WHITE
			color = CLOTHING_SOOT_BLACK
			return TRUE
	return FALSE

/obj/item/clothing/cloak/tabard/crusader/tief/get_heraldry_designs()
	return list("Default", "RedBlack", "BlackRed")

/obj/item/clothing/cloak/tabard/crusader/tief/apply_forced_heraldry_color(design)
	if(uses_lord_coloring)
		return TRUE // skip color selection entirely
	switch(design)
		if("RedBlack")
			detail_color = CLOTHING_SOOT_BLACK
			color = CLOTHING_BLOOD_RED
			return TRUE
		if("BlackRed")
			detail_color = CLOTHING_BLOOD_RED
			color = CLOTHING_SOOT_BLACK
			return TRUE
	return FALSE

/obj/item/clothing/cloak/tabard/knight/guard
	desc = "A tabard with the lord's heraldic colors."
	color = CLOTHING_BLOOD_RED
	detail_tag = "_spl"
	detail_color = CLOTHING_PLUM_PURPLE
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/cloak/tabard/knight/guard/get_heraldry_designs()
	return list("Split", "Quadrants", "Boxes", "Diamonds")

/obj/item/clothing/cloak/tabard/adept
	detail_tag = "_psy"
	color = CLOTHING_SOOT_BLACK
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/adept/Initialize()
	. = ..()
	update_appearance(UPDATE_ICON)

/obj/item/clothing/cloak/tabard/adept/select_heraldry(mob/user)
	return SECONDARY_ATTACK_CALL_NORMAL // pretend heraldry doesn't even exist for this
