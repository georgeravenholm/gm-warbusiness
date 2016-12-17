War Business readme.txt

-- about --





-- custom entities, for mappers --

- wb_info -
War business point entity, essential for any non 2way deathmatch map.

keys:
gamemode <number> (exactly the same as wb_gamemode convar)
roundtime<number> (exactly the same as wb_roundtime convar)
wb_setuptime <number> (exactly the same as wb_setuptime convar)

wb_musicurl <str>	online music to play, if you want hl2 music just map it in
wb_musiccredit <str>	print to chat the credits of the music when it starts to play so you dont get sued

- wb_flag -
CTF entity, flag the enemy must capture
keys: "team" <number> (what team the flag belongs to, 1=hrt, 2=oec etc)

- wb_trig_flagcap -
CTF trigger, brush entity. Where the flag can be captured
keys: "team" <number> (what team can cap, 1=hrt, 2=oec etc)

- wb_spawn_hrt, wb_spawn_abi, bbe, oec, svr -

Spawn points for each team, if none are found an info_playerspawn is used. Including an info_playerspawn is alright, as the War Business gamemode sets the spawnpoints to these entities if possible, add an info_playerspawn in the center in case of a deathly bug or for testing in sandbox.
(bbe is Belmont Enterprises, old name of Slaver Enterprises (before nick fernandez demanded it))

-filter_wbteam- 
filter entity

keys: "team" <number>	what team of player (1,2,3,4) is accepted, you link it to a trigger or whatever


-- to do

- wb_healthpack_ small,large -
Health regen zones.

- wb_ammo_ small,large -
Ammo regen zones.

- wb_trig_resupply -
brush entity that replenishes all health and ammo

keys: "team" <number> (what team the resupply can be used by, 1=hrt, 2=oec etc)
