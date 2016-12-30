GM.Name = "War Business"
GM.Author = "georgeravenholm"
GM.Email = "N/A"
GM.Website = "N/A"

include('sconvars.lua')



--function GM:CreateTeams()
  team.SetUp(1,"HRT",Color(60,60,255),true) --holmrekR tek (me, american soldiers)
  team.SetUp(2,"OEC",Color(255,100,0), true )-- Orangee Co (jake, hawaiians)
  team.SetUp(3,"SVR",Color(160,20,20), fourway ) --Slaver Enterprises (slaves or somethinbg)
  team.SetUp(4,"ABI",Color(0,255,0), fourway ) -- Abrika industries (melons)
  team.SetUp(5,"spectatorfags",Color(50,50,50), false )

  team.SetSpawnPoint( 1, { "wb_spawn_hrt" } )
  team.SetSpawnPoint( 2, { "wb_spawn_oec" } )
  team.SetSpawnPoint( 3, { "wb_spawn_svr" } )
  team.SetSpawnPoint( 4, { "wb_spawn_abi" } )
--end


specialpeople =
{
	"STEAM_0:1:66236244", -- me!
	"STEAM_0:1:44076617", -- TechNohKitty
	"STEAM_0:0:47703393", -- SpookySpazo
	"STEAM_0:1:76497564", -- vMajx-
	"STEAM_0:1:38333670", -- dwanofwar
}

weponverbs = // These should be shared constants!
{
     ["weapon_357"]="high noon'd",
     ["weapon_crowbar"]="struck down",
     ["weapon_pistol"]="shot",
     ["weapon_smg1"]="gunned down",
     ["weapon_ar2"]="shot down",
     ["weapon_frag"]="exploded",
     ["weapon_agent_backstab"]="backstabbed",
     ["weapon_crossbow"]="sniped",
     ["weapon_sharp_rifle"]="sniped",
     ["weapon_doc_heal"]="slapped",
     ["weapon_shotgun"]="buck'd up",
     ["weapon_teirtwo_shotgun"]="buck'd up",
     ["weapon_heavyweapons_gattlinggun"]="gunly gattled"
}

teamdata={}
teamdata[1]=
{
  name="holmrekR tek",
  model="models/player/dod_american.mdl",
  image="images/wb_teamicons/holmrekr.png",
	tooltip="\"Bigger is Better!\"\nA big company that loves big moneys, arabian slavery and holmium lasers."
}
teamdata[2]=
{
  name="Orangee Co.",
  model="models/player/Group01/male_07.mdl",
  image="images/wb_teamicons/orangee.png",
	tooltip="\"When life gives you oranges, you gotta make a profit.\"\nThe radest, coolest, hip hop doodes this side of the mississippi\nthe dippiest, the freshest, the coolest doodes\nthe rockers, the rollers\nthe outta-controllers\nwe are Orangee Co.\ndon't you forgetti.\ndon't eat our spaghetti\n(started war)"
}
teamdata[3]=
{
  name="Slaver Enterprises",
  model="models/player/dod_german.mdl",
  image="images/wb_teamicons/belmont.png",
	tooltip="\"we use the best slaves for you\"\nwe work in selling the best mangos, cotton, suger, coco beans and coffee beans\nwe help prisoners learn life lessons such as how to make slaver enterprises seal of approval mangos\nmost of our workers are from prisons and 3rd world countries\nwe also steal grapes because its cheaper to send 5 children soldier to steal grapes then buying them\nyours trueley, rick fenado"
}

teamdata[4]=
{
  name="Abrika Industries",
  model="models/player/gman_high.mdl",
  image="images/wb_teamicons/abrika.png",
	tooltip="\"Paving the future, one melon at a time.\"\nArmed with melon combat, these melon-heads mass produce watermelons inefficiently for no reason whatsoever."
}

teamdata[5]=
{
  name="Spectatorfags United",
  image="images/wb_teamicons/spectate.png",
	tooltip="Be a fucking creep and watch over everyone.\nAlthough it is not (AND SHOULD NOT BE) enforced, dont be a dick and ghost."
}

classdata = {}
classdata[1] =
{
	name="Teir One",
	info="The basic employee.\nAR2, 2 Grenades, Pistol, Crowbar\nAttack players, capture objectives,\nbasically the best class in the gamemode.\nYou have 1 AR2 combine ball.2",
	basic="The basic empoyee",
	weapons="3 Grenades, a pistol, a crowbar and an AR2 with 1 ball",
	tip1="Attack players, capture objectives.",
	tip2="Basically the best class in the gamemode.",
	animation="gesture_salute_original",
	speed=300,
	health=130,
	loadout={"weapon_frag","weapon_pistol","weapon_crowbar","weapon_ar2"},
	--ammotypes={"SMG1","Grenade","Pistol"},
	--ammocount={200,3,100},
	ammo=
	{
		[1] = {type="SMG1",amount="200",},
		[2] = {type="Grenade",amount="3",},
		[3] = {type="Pistol",amount="999",},
		[4] = {type="AR2",amount="350",},
		[5] = {type="AR2AltFire",amount=1,}
	},
}
classdata[2] =
{
	name="Agent",
	info="The high paid insurance manager, he's smart enough to be a backstabbing dime-a-dozen scumbag.\n357, Knife, Invisinator\nUse the Invisinator to go invisible, get behind the enemy and stab 'em in the bum.\nYou can right click with the Invisinator to fake going invisible, confusing the enemy.",
	basic="The high paid insurance manager, he's smart enough to be a backstabbing dime-a-dozen scumbag.",
	weapons="357, Knife, Invisinator",
	tip1="Backstab for an instant kill.",
	tip2="The Invisinator lets go go invisible and fast. Right clicking forces it to turn off.",
	animation="menu_gman",
	speed=325,
	health=80,
	loadout={"weapon_357","weapon_agent_backstab","weapon_agent_invis"},
	--ammotypes={"357"},
	--ammocount={24},
	ammo=
	{
		[1] = {type="357",amount="6",},
	},
}

classdata[3] =
{
	name="HeavyWeapons",
	info="Big boy with big guns\nGattling Gun, Fists",
	basic="Big boy with big guns",
	weapons="Gattling Gun, Fists",
	tip1="The Gattling Gun takes time to charge up. You can idle it with right click.",
	tip2="While charged, you are slow and can not jump.",
	animation="pose_standing_02",
	speed=200,
	health=200,
	loadout={"weapon_heavyweapons_gattlinggun","weapon_fists","weapon_pistol"},
	--ammotypes={"357"},
	--ammocount={24},
	ammo=
	{
		[1] = {type="SMG1",amount="0",},
		[2] = {type="Pistol",amount="50",},
	},
}

classdata[4] =
{
	name="Doc",
	info="A gloved man with some adhesive strips\nAdhesive Strips / Hand, Pistol\nWhile the slap may be fun on 4fort,\nyou can heal your fellow empoyees and give them\n10 EXTRA HEALTH. Also you can heal yourself with\nright-click, but careful you can not move or attack while\nhealing yourself!",
	basic="A gloved man with some adhesive strips",
	weapons="Adhesive Strips",
	tip1="While the slap may be fun on 4fort, heal your workmates, mate.",
	tip2="You can heal yourself with right click, however you are vulnrable.",
	animation="pose_standing_04",
	speed=260,
	health=100,
	loadout={"weapon_pistol","weapon_doc_heal"},
	--ammotypes={"357"},
	--ammocount={24},
	ammo=
	{
		[1] = {type="XBowBolt",amount="70",},
		[2] = {type="pistol",amount="100",},
	},
}

classdata[5] =
{
	name="Electrician (NYI)",
	info="An actual engineer who can build things.\nHammer, Pistol, Zapper, Blueprints",
	basic="NYI=Not Yet Implemented",
	weapons="Hammer, Pistol, Zapper, Blueprints",
	tip1="Not Yet Implemented = Does not work",
	tip2="Dont bother trying to use this class, he only has a pistol and stunstick.",
	animation="taunt_dance",
	speed=260,
	health=100,
	loadout={"weapon_pistol","weapon_stunstick"},
	--ammotypes={"357"},
	--ammocount={24},
	ammo=
	{
		[1] = {type="pistol",amount="100",},
	},
}

classdata[6] =
{
	name="Sharp Shooter",
	info="Snip, snip, snip, snip snip!\nRifle, Crowbar\nRight click to zoom in the rifle, also aim for the head.\nDo not play this class if you can not aim,\nor you like to move around.\n(moving makes it inaccurate)",
	basic="Snip, snip, snip, snip snip!",
	weapons="Rifle, Crowbar",
	tip1="Right click to zoom in; also aim for the head.", // ; == smart
	tip2="Do not play if you cant aim, or like to move (makes shots inaccurate)",
	animation="pose_ducking_01",
	speed=260,
	health=100,
	loadout={"weapon_crowbar","weapon_sharp_rifle"},
	--ammotypes={"357"},
	--ammocount={24},
	ammo=
	{
		[1] = {type="XBowBolt",amount="60",},
	},
}


classdata[7] =
{
	name="Shotgunner",
	info="Buck them up, teir two!\nSuper Shotgun, Crowbar, Pistol\nGet up close and buck them real good.",
	basic="Buck them up, teir two!",
	weapons="Super Shotgun, Pistol, Crowbar",
	tip1="Get close and buck'em' up",
	tip2="The Super Shotgun has a kick, do not fire facing away from a cliff.",
	animation="pose_standing_01",
	speed=280,
	health=100,
	loadout={"weapon_crowbar","weapon_pistol","weapon_teirtwo_shotgun"},
	--ammotypes={"357"},
	--ammocount={24},
	ammo=
	{
		[1] = {type="Pistol",amount=100,},
		[2] = {type="Buckshot",amount=40,},
	},
}

classdata[8] =
{
	name="CEO",
	info="???\nOwO Whats this?\nMaybe if you play enough you'll find out.\nsorry, nothin personell kid.",
	animation="taunt_dance",
	basic="---",
	weapons="---",
	tip1="---",
	tip2="---",
	speed=200,
	health=750,
	loadout={"weapon_357","weapon_crowbar","weapon_agent_backstab","weapon_smg1","weapon_frag","weapon_rpg","weapon_crossbow","weapon_agent_invis","weapon_sharp_rifle","weapon_doc_heal","weapon_teirtwo_shotgun","weapon_ar2","weapon_heavyweapons_gattlinggun"},
	--ammotypes={"357"},
	--ammocount={24},
	ammo=
	{
		[1] = {type="357",amount="999",},
		[2] = {type="SMG1",amount="1000000000",},
		[3] = {type="SMG1_Grenade",amount="999",},
		[4] = {type="Grenade",amount="999",},
		[5] = {type="RPG_Round",amount="999",},
		[6] = {type="XBowBolt",amount="999999",},
		[7] = {type="Buckshot",amount=9999,},
		[8] = {type="AR2AltFire",amount=9999,},
		[9] = {type="AR2",amount=9999,},
	},
}


--models
-- cap   - models/props_gameplay/cap_point_base.mdl
