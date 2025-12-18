// Contains all the heraldry handling for cloaks.
/obj/item/clothing/cloak
	var/heraldry_picked

/obj/item/clothing/cloak/proc/get_heraldry_designs()
	return null

/obj/item/clothing/cloak/proc/apply_forced_heraldry_color(design)
	if(uses_lord_coloring)
		return TRUE // skip color selection entirely
	// this is where you'd do a switch(design) if you wanted to force colors for a design. set the color vars and then return true
	return FALSE

// this will only do anything if we have heraldry designs available
/obj/item/clothing/cloak/attack_hand_secondary(mob/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	return select_heraldry()

// Now centralised to include handling for lord coloring as well.
/obj/item/clothing/cloak/proc/select_heraldry(mob/user, input_name = "Tabard Design")
	. = SECONDARY_ATTACK_CALL_NORMAL // don't cancel anything if we fail this early
	if(heraldry_picked)
		return
	var/list/designs = get_heraldry_designs()
	if(!length(designs))
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN // at this point we've shown stuff to the user, so cancel further attack interactions in this chain
	var/the_time = world.time
	var/design = input(user, "Select a design.",input_name) as null|anything in get_heraldry_designs()
	if(!design)
		return
	design = heraldry_resolve_design(user, design) // handle extra steps like symbols, etc.
	// if we force certain colors for specific designs, or use lord coloration, do that now
	var/heraldry_color_forced = apply_forced_heraldry_color(design)
	var/colorone
	var/colortwo
	if(!heraldry_color_forced)
		colorone = input(user, "Select a primary color.",input_name) as null|anything in CLOTHING_COLOR_NAMES
		if(!colorone)
			return
		if(design != "None")
			colortwo = input(user, "Select a secondary color.",input_name) as null|anything in CLOTHING_COLOR_NAMES
			if(!colortwo)
				return
	if(world.time > (the_time + 30 SECONDS))
		return
	switch(design)
		if("Split")
			detail_tag = "_spl"
		if("Quadrants")
			detail_tag = "_quad"
		if("Boxes")
			detail_tag = "_box"
		if("Diamonds")
			detail_tag = "_dim"
	if(!heraldry_color_forced) // apply our custom colors
		color = clothing_color2hex(colorone)
		if(colortwo)
			detail_color = clothing_color2hex(colortwo)
	update_appearance(UPDATE_ICON)
	update_slot_icon()
	if(alert("Are you pleased with your heraldry?", "Heraldry", "Yes", "No") != "Yes")
		if(!uses_lord_coloring) // don't check heraldry_color_forced here
			color = initial(color)
			detail_color = initial(detail_color)
		detail_tag = initial(detail_tag)
		update_appearance(UPDATE_ICON)
		update_slot_icon()
		return
	heraldry_picked = TRUE
