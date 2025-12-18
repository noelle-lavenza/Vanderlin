
/obj/item/clothing/cloak/stabard
	name = "surcoat"
	icon_state = "stabard"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK

/obj/item/clothing/cloak/stabard/proc/get_heraldry_designs()
	return list("None", "Split", "Quadrants", "Boxes", "Diamonds")

// Handles things like symbol selection for special heraldries. Returns the new design.
/obj/item/clothing/cloak/proc/heraldry_resolve_design(mob/user, design)
	return design // return the one we already had

/obj/item/clothing/cloak/stabard/guard
	desc = "A tabard with the lord's heraldic colors. This one is worn typically by guards."
	color = CLOTHING_BLOOD_RED
	detail_tag = "_spl"
	detail_color = CLOTHING_PLUM_PURPLE
	uses_lord_coloring = LORD_PRIMARY | LORD_DETAIL_AND_COLOR

/obj/item/clothing/cloak/stabard/guard/get_heraldry_designs() // Doesn't allow "None" as an option.
	return list("Split", "Quadrants", "Boxes", "Diamonds")

/obj/item/clothing/cloak/stabard/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/cloak/tabard/colored/select_heraldry(mob/user)
	return SECONDARY_ATTACK_CALL_NORMAL // pretend heraldry doesn't even exist for this

/obj/item/clothing/cloak/stabard/colored/dungeon
	color = CLOTHING_SOOT_BLACK


/obj/item/clothing/cloak/stabard/mercenary
	detail_tag = "_quad"

/obj/item/clothing/cloak/stabard/mercenary/Initialize()
	. = ..()
	detail_tag = pick("_quad", "_spl", "_box", "_dim")
	color = clothing_color2hex(pick(CLOTHING_COLOR_NAMES))
	detail_color = clothing_color2hex(pick(CLOTHING_COLOR_NAMES))
	update_appearance(UPDATE_ICON)
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/tabard/mercenary/select_heraldry(mob/user)
	return SECONDARY_ATTACK_CALL_NORMAL // pretend heraldry doesn't even exist for this

/obj/item/clothing/cloak/stabard/kaledon
	detail_tag = "_box"
	color = CLOTHING_MAGE_BLUE
	detail_color = CLOTHING_BOG_GREEN

/obj/item/clothing/cloak/tabard/kaledon/select_heraldry(mob/user)
	return SECONDARY_ATTACK_CALL_NORMAL // pretend heraldry doesn't even exist for this

//////////////////////////
/// CRUSADER
////////////////////////

/obj/item/clothing/cloak/stabard/templar
	name = "surcoat of the golden order"
	icon_state = "tabard_weeping"
	item_state = "tabard_weeping"
	icon = 'icons/roguetown/clothing/special/templar.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/templar.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/templar.dmi'

/obj/item/clothing/cloak/tabard/templar/select_heraldry(mob/user)
	return SECONDARY_ATTACK_CALL_NORMAL // pretend heraldry doesn't even exist for this

/obj/item/clothing/cloak/stabard/templar/astrata
	name = "surcoat of the solar order"
	icon_state = "tabard_astrata"
	item_state = "tabard_astrata"

/obj/item/clothing/cloak/stabard/templar/astrata/alt
	icon_state = "tabard_astrata_alt"
	item_state = "tabard_astrata_alt"

/obj/item/clothing/cloak/stabard/templar/necra
	name = "surcoat of the necran order"
	icon_state = "tabard_necra"
	item_state = "tabard_necra"

/obj/item/clothing/cloak/stabard/templar/necra/alt
	icon_state = "tabard_necra_alt"
	item_state = "tabard_necra_alt"

/obj/item/clothing/cloak/stabard/templar/dendor
	name = "surcoat of the dendorian order"
	icon_state = "tabard_dendor"
	item_state = "tabard_dendor"

/obj/item/clothing/cloak/stabard/templar/noc
	name = "surcoat of the lunar order"
	icon_state = "tabard_noc"
	item_state = "tabard_noc"

/obj/item/clothing/cloak/stabard/templar/noc/alt
	icon_state = "tabard_noc_alt"
	item_state = "tabard_noc_alt"

/obj/item/clothing/cloak/stabard/templar/abyssor
	name = "surcoat of the abyssal order"
	icon_state = "tabard_abyssor"
	item_state = "tabard_abyssor"

/obj/item/clothing/cloak/stabard/templar/abyssor/alt
	name = "surcoat of the abyssal order"
	icon_state = "tabard_abyssor_alt"
	item_state = "tabard_abyssor_alt"


/obj/item/clothing/cloak/stabard/templar/malum
	name = "surcoat of the malumite order"
	icon_state = "tabard_malum"
	item_state = "tabard_malum"

/obj/item/clothing/cloak/stabard/templar/eora
	name = "surcoat of the eoran order"
	icon_state = "tabard_eora"
	item_state = "tabard_eora"

/obj/item/clothing/cloak/stabard/templar/pestra
	name = "surcoat of the pestran order"
	icon_state = "tabard_pestra"
	item_state = "tabard_pestra"

/obj/item/clothing/cloak/stabard/templar/ravox
	name = "surcoat of the ravoxian order"
	icon_state = "tabard_ravox"
	item_state = "tabard_ravox"

/obj/item/clothing/cloak/stabard/templar/xylix
	name = "surcoat of the xylixian order"
	icon_state = "tabard_xylix"
	item_state = "tabard_xylix"

//////////////////////////
/// SURCOATS
////////////////////////

/obj/item/clothing/cloak/stabard/jupon
	name = "jupon"
	icon_state = "surcoat"

/obj/item/clothing/cloak/stabard/jupon/guard
	desc = "A jupon with the lord's heraldic colors."
	color = CLOTHING_BLOOD_RED
	detail_tag = "_quad"
	detail_color = CLOTHING_PLUM_PURPLE
	uses_lord_coloring = LORD_PRIMARY | LORD_DETAIL_AND_COLOR

