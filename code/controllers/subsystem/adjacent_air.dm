SUBSYSTEM_DEF(adjacent_air)
	name = "Atmos Adjacency"
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 10
	priority = FIRE_PRIORITY_ATMOS_ADJACENCY
	var/list/queue = list()

/datum/controller/subsystem/adjacent_air/stat_entry()
	..("P:[length(queue)]")

/datum/controller/subsystem/adjacent_air/Initialize()
	while(length(queue))
		fire(mc_check = FALSE)
	return ..()

/datum/controller/subsystem/adjacent_air/fire(resumed = FALSE, mc_check = TRUE)

	var/list/queue = src.queue

	while (length(queue))
		var/turf/currT = queue[1]
		queue.Cut(1,2)

		currT.ImmediateCalculateAdjacentTurfs()

		if(mc_check)
			if(MC_TICK_CHECK)
				break
		else
			CHECK_TICK

/atom/var/CanAtmosPass = ATMOS_PASS_YES
/atom/var/CanAtmosPassVertical = ATMOS_PASS_YES

/atom/proc/CanAtmosPass(turf/T)
	switch (CanAtmosPass)
		if (ATMOS_PASS_PROC)
			return ATMOS_PASS_YES
		if (ATMOS_PASS_DENSITY)
			return !density
		else
			return CanAtmosPass

/atom/proc/CanAtmosPassUp(turf/T)
	return CanAtmosPass(T)

/atom/proc/CanAtmosPassDown(turf/T)
	return CanAtmosPass(T)

/turf
	//list of open turfs adjacent to us
	var/list/atmos_adjacent_turfs
	///the chance this turf has to spread, basically 1% by default
	var/spread_chance = 1
	///means fires last at base 15 seconds
	var/burn_power = 15
	var/obj/effect/abstract/liquid_turf/liquids
	var/liquid_height = 0
	var/turf_height = 0
	var/path_weight = 50



/turf/proc/reasses_liquids()
	if(!liquids)
		return
	if(!liquids.liquid_group)
		liquids.liquid_group = new(1, liquids)

/turf/proc/liquid_update_turf()
	if(!liquids)
		return
	//Check atmos adjacency to cut off any disconnected groups
	if(liquids.liquid_group)
		//Check any cardinals that may have a matching group
		for(var/direction in GLOB.cardinals)
			var/turf/T = get_step(src, direction)
			if(!T.liquids)
				return

/turf/proc/add_liquid_from_reagents(datum/reagents/giver, no_react = FALSE, chem_temp, amount)
	var/list/compiled_list = list()
	if(!giver.total_volume)
		return
	var/multiplier = amount ? amount / giver.total_volume : 1
	for(var/r in giver.reagent_list)
		var/datum/reagent/R = r
		if(!(R.type in GLOB.liquid_blacklist))
			compiled_list[R.type] = R.volume * multiplier
	if(!compiled_list.len) //No reagents to add, don't bother going further
		return
	if(!liquids)
		liquids = new(src)
	liquids.liquid_group.add_reagents(liquids, compiled_list, chem_temp)

//More efficient than add_liquid for multiples
/turf/proc/add_liquid_list(reagent_list, no_react = FALSE, chem_temp)
	if(liquids && !liquids.liquid_group)
		qdel(liquids)
		return

	if(!liquids)
		liquids = new(src)
	liquids.liquid_group.add_reagents(liquids, reagent_list, chem_temp)
	//Expose turf
	liquids.liquid_group.expose_members_turf(liquids)

/turf/proc/add_liquid(reagent, amount, no_react = FALSE, chem_temp = 300)
	if(reagent in GLOB.liquid_blacklist)
		return
	if(!liquids)
		liquids = new(src)

	liquids.liquid_group.add_reagent(liquids, reagent, amount, chem_temp)
	//Expose turf
	liquids.liquid_group.expose_members_turf(liquids)

/turf/CanAtmosPass = ATMOS_PASS_NO
/turf/CanAtmosPassVertical = ATMOS_PASS_NO

/turf/open/CanAtmosPass = ATMOS_PASS_PROC
/turf/open/CanAtmosPassVertical = ATMOS_PASS_PROC

/turf/open/CanAtmosPass(turf/open/T)
	if(!isopenturf(T))
		return FALSE
	for(var/obj/O in src)
		if(!CANATMOSPASS(O, T))
			return FALSE
	for(var/obj/O in T)
		if(!CANATMOSPASS(O, src))
			return FALSE
	return TRUE

// Can air travel upwards from src to T?
/turf/open/CanAtmosPassUp(turf/open/T)
	if(!isopenturf(T))
		return FALSE
	if(!isopenspace(T)) // only openspace turfs let air enter going upwards (from below)
		return FALSE
	for(var/obj/O in src)
		if(!CANATMOSPASSUP(O, T))
			return FALSE
	for(var/obj/O in T)
		if(!CANATMOSPASSDOWN(O, src))
			return FALSE
	return TRUE

// Can air travel downwards from src to T?
/turf/open/CanAtmosPassDown(turf/open/T)
	if(!isopenturf(T))
		return FALSE
	if(!isopenspace(src)) // only openspace turfs let air leave downwards (from below)
		return FALSE
	for(var/obj/O in src)
		if(!CANATMOSPASSDOWN(O, T))
			return FALSE
	for(var/obj/O in T)
		if(!CANATMOSPASSUP(O, src))
			return FALSE
	return TRUE

// Only open turfs actually do anything in this proc, this just clears stuff after changeturf.
/turf/proc/ImmediateCalculateAdjacentTurfs()
	if(atmos_adjacent_turfs) // we have neighbors to remove from when we were an open turf
		for(var/turf/neighbor in atmos_adjacent_turfs) // disconnect from neighbors
			LAZYREMOVE(neighbor.atmos_adjacent_turfs, src)
		LAZYNULL(src.atmos_adjacent_turfs)
	return

/turf/open/ImmediateCalculateAdjacentTurfs()
	var/list/atmos_adjacent_turfs = src.atmos_adjacent_turfs // local variable to avoid datum var access overhead
	for(var/direction in GLOB.cardinals)
		var/turf/neighbor = get_step(src, direction)
		if(!isopenturf(neighbor))
			continue
		if(CANATMOSPASS(neighbor, src))
			LAZYINITLIST(atmos_adjacent_turfs)
			LAZYINITLIST(neighbor.atmos_adjacent_turfs)
			atmos_adjacent_turfs[neighbor] = TRUE
			neighbor.atmos_adjacent_turfs[src] = TRUE
		else
			if (atmos_adjacent_turfs)
				atmos_adjacent_turfs -= neighbor // do not use lazyremove, we do UNSETEMPTY later
			LAZYREMOVE(neighbor.atmos_adjacent_turfs, src)

	var/turf/above_turf = GET_TURF_ABOVE(src)
	if(isopenturf(above_turf))
		if(CANATMOSPASSUP(above_turf, src))
			LAZYINITLIST(atmos_adjacent_turfs)
			LAZYINITLIST(above_turf.atmos_adjacent_turfs)
			atmos_adjacent_turfs[above_turf] = TRUE
			above_turf.atmos_adjacent_turfs[src] = TRUE
		else
			if (atmos_adjacent_turfs)
				atmos_adjacent_turfs -= above_turf
			if (above_turf.atmos_adjacent_turfs)
				above_turf.atmos_adjacent_turfs -= src
			UNSETEMPTY(above_turf.atmos_adjacent_turfs)
	var/turf/below_turf = GET_TURF_BELOW(src)
	if(isopenturf(below_turf))
		if(CANATMOSPASSDOWN(below_turf, src))
			LAZYINITLIST(atmos_adjacent_turfs)
			LAZYINITLIST(below_turf.atmos_adjacent_turfs)
			atmos_adjacent_turfs[below_turf] = TRUE
			below_turf.atmos_adjacent_turfs[src] = TRUE
		else
			if (atmos_adjacent_turfs)
				atmos_adjacent_turfs -= below_turf
			if (below_turf.atmos_adjacent_turfs)
				below_turf.atmos_adjacent_turfs -= src
			UNSETEMPTY(below_turf.atmos_adjacent_turfs)
	UNSETEMPTY(atmos_adjacent_turfs)
	src.atmos_adjacent_turfs = atmos_adjacent_turfs

//returns a list of adjacent turfs that can share air with this one.
//alldir includes adjacent diagonal tiles that can share
//	air with both of the related adjacent cardinal tiles
/turf/proc/GetAtmosAdjacentTurfs(alldir = 0)
	var/adjacent_turfs
	if (atmos_adjacent_turfs)
		adjacent_turfs = atmos_adjacent_turfs.Copy()
	else
		adjacent_turfs = list()

	if (!alldir)
		return adjacent_turfs

	var/turf/curloc = src

	for (var/direction in GLOB.diagonals_multiz)
		var/matchingDirections = 0
		var/turf/S = get_step_multiz(curloc, direction)
		if(!S)
			continue

		for (var/checkDirection in GLOB.cardinals_multiz)
			var/turf/checkTurf = get_step(S, checkDirection)
			if(!S.atmos_adjacent_turfs || !S.atmos_adjacent_turfs[checkTurf])
				continue

			if (adjacent_turfs[checkTurf])
				matchingDirections++

			if (matchingDirections >= 2)
				adjacent_turfs += S
				break

	return adjacent_turfs

/atom/proc/air_update_turf(command = 0)
	if(!isturf(loc) && command)
		return
	var/turf/T = get_turf(loc)
	T?.air_update_turf(command)

/turf/air_update_turf(command = 0)
	if(command)
		ImmediateCalculateAdjacentTurfs()

/atom/movable/proc/move_update_air(turf/T)
	if(isturf(T))
		T.air_update_turf(1)
	air_update_turf(1)
