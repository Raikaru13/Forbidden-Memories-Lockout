-- load namespace
local socket = require("socket")
json = require("json")
local tcp = assert(socket.tcp())

isHosting = false
isConnected = false
duelCompleted = false
PlayerMMCount = 0
OpponentMMCount = 0
maxCard = 0

Inputs = joypad.get(1)

--first slot in the spoils after the duel
SpoilsAddress = 0x1AAC22
--Address for which Card is being looked at
CardSlot = 0x1AAC20
--Address for which duelist is being fought
DuelistAddress = 0x09B361
--Address for the value of the rank
RankAddress = 0x179A04
--Address to determine if its campaign or free duel
Mode = 0x09B26C
--Display Slot
DisplaySlot = memory.read_u16_le(0x1D56A8)
--Make an array for LockedOut
LockedOut = {}
dropInfo = {}
MMCount = 0

DuelistList = {
    [1] = "Simon",
    [2] = "Teana",
    [3] = "Jono",
    [4] = "Villager 1",
    [5] = "Villager 2",
    [6] = "Villager 3",
    [7] = "Seto",
    [8] = "Heishin 1",
    [9] = "Rex",
    [10] = "Weevil",
    [11] = "Mai",
    [12] = "Keith",
    [13] = "Shadi",
    [14] = "Bakura",
    [15] = "Pegasus",
    [16] = "Isis",
    [17] = "Kaiba",
    [18] = "Mage Soldier",
    [19] = "Jono 2nd",
    [20] = "Teana 2nd",
    [21] = "Ocean Mage",
    [22] = "Secmeton",
    [23] = "Forest Mage",
    [24] = "Anubisius",
    [25] = "Mountain Mage",
    [26] = "Atenza",
    [27] = "Desert Mage",
    [28] = "Martis",
    [29] = "Meadow Mage",
    [30] = "Kepura",
    [31] = "Labyrinth Mage",
    [32] = "Seto 2nd",
    [33] = "Sebek",
    [34] = "Neku",
    [35] = "Heishin 2nd",
    [36] = "Seto 3rd",
    [37] = "DarkNite",
    [38] = "Nitemare",
    [39] = "Duel Master K"
}
DuelistListList = {
    ["Simon"] = 1,
    ["Teana"] = 2,
    ["Jono"] = 3,
    ["Villager 1"] = 4,
    ["Villager 2"] = 5,
    ["Villager 3"] = 6,
    ["Seto"] = 7,
    ["Heishin"] = 8,
    ["Rex"] = 9,
    ["Weevil"] = 10,
    ["Mai"] = 11,
    ["Keith"] = 12,
    ["Shadi"] = 13,
    ["Bakura"] = 14,
    ["Pegasus"] = 15,
    ["Isis"] = 16,
    ["Kaiba"] = 17,
    ["Mage Soldier"] = 18,
    ["Jono 2nd"] = 19,
    ["Teana 2nd"] = 20,
    ["Ocean Mage"] = 21,
    ["Secmeton"] = 22,
    ["Forest Mage"] = 23,
    ["Anubisius"] = 24,
    ["Mountain Mage"] = 25,
    ["Atenza"] = 26,
    ["Desert Mage"] = 27,
    ["Martis"] = 28,
    ["Meadow Mage"] = 29,
    ["Kepura"] = 30,
    ["Labyrinth Mage"] = 31,
    ["Seto 2nd"] = 32,
    ["Sebek"] = 33,
    ["Neku"] = 34,
    ["Heishin 2nd"] = 35,
    ["Seto 3rd"] = 36,
    ["DarkNite"] = 37,
    ["Nitemare"] = 38,
    ["Duel Master K"] = 39
}
DuelistListListList = {
    "Simon",
    "Teana",
    "Jono",
    "Villager 1",
    "Villager 2",
    "Villager 3",
    "Seto",
    "Heishin",
    "Rex",
    "Weevil",
    "Mai",
    "Keith",
    "Shadi",
    "Bakura",
    "Pegasus",
    "Isis",
    "Kaiba",
    "Mage Soldier",
    "Jono 2nd",
    "Teana 2nd",
    "Ocean Mage",
    "Secmeton",
    "Forest Mage",
    "Anubisius",
    "Mountain Mage",
    "Atenza",
    "Desert Mage",
    "Martis",
    "Meadow Mage",
    "Kepura",
    "Labyrinth Mage",
    "Seto 2nd",
    "Sebek",
    "Neku",
    "Heishin 2nd",
    "Seto 3rd",
    "DarkNite",
    "Nitemare",
    "Duel Master K"
}
RewardsColoring = {
    0x0A5C4C,
    0x0C7F2C,
    0x0A5C64,
    0x0C7F44,
    0x0A5C7C,
    0x0C7F5C,
    0x0A5C94,
    0x0C7F74,
    0x0A5CAC,
    0x0C7F8C,
    0x0A5CC4,
    0x0C7FA4,
    0x0A5CDC,
    0x0C7FBC,
    0x0A5CF4,
    0x0C7FD4,
    0x0A5D0C,
    0x0C7FEC,
    0x0A5D24,
    0x0C8004,
    0x0A5D3C,
    0x0C801C,
    0x0A5D54,
    0x0C8034,
    0x0A5D6C,
    0x0C804C,
    0x0A5D84,
    0x0C8064,
    0x0A5D9C,
    0x0C807C,
    0x0A5DB4,
    0x0C8094,
    0x0A5DCC,
    0x0C80AC,
    0x0A5DE4,
    0x0C80C4,
    0x0A5DFC,
    0x0C80DC,
    0x0A5E14,
    0x0C80F4,
    0x0A5E2C,
    0x0C810C,
    0x0A5E44,
    0x0C8124,
    0x0A5E5C,
    0x0C813C,
    0x0A5E74,
    0x0C8154,
    0x0A5E8C,
    0x0C816C,
    0x0A5EA4,
    0x0C8184,
    0x0A5EBC,
    0x0C819C,
    0x0A5ED4,
    0x0C81B4,
    0x0A5EEC,
    0x0C81CC,
    0x0A5F04,
    0x0C81E4,
    0x0A5F1C,
    0x0C81FC,
    0x0A5F34,
    0x0C8214,
    0x0A5F4C,
    0x0C822C,
    0x0A5F64,
    0x0C8244,
    0x0C825C,
    0x0A5F7C
}
cardList = {
    "Blue-eyesWhiteDragon",
    "MysticalElf",
    "Hitotsu-meGiant",
    "BabyDragon",
    "Ryu-kishin",
    "FeralImp",
    "WingedDragon#1",
    "MushroomMan",
    "ShadowSpecter",
    "BlacklandFireDragon",
    "SwordArmofDragon",
    "SwampBattleguard",
    "Tyhone",
    "BattleSteer",
    "FlameSwordsman",
    "TimeWizard",
    "RightLegoftheForbiddenOne",
    "LeftLegoftheForbiddenOne",
    "RightArmoftheForbiddenOne",
    "LeftArmoftheForbiddenOne",
    "ExodiatheForbidden",
    "SummonedSkull",
    "TheWickedWormBeast",
    "SkullServant",
    "HornImp",
    "BattleOx",
    "BeaverWarrior",
    "RockOgreGrotto#1",
    "MountainWarrior",
    "ZombieWarrior",
    "KoumouriDragon",
    "Two-headedKingRex",
    "JudgeMan",
    "SaggitheDarkClown",
    "DarkMagician",
    "TheSnakeHair",
    "GaiatheDragonChampion",
    "GaiatheFierceKnight",
    "CurseofDragon",
    "DragonPiper",
    "CelticGuardian",
    "IllusionistFacelessMage",
    "KarbonalaWarrior",
    "RougeDoll",
    "OscilloHero#2",
    "Griffore",
    "Torike",
    "Sangan",
    "BigInsect",
    "BasicInsect",
    "ArmoredLizard",
    "HerculesBeetle",
    "KillerNeedle",
    "Gokibore",
    "GiantFlea",
    "LarvaeMoth",
    "GreatMoth",
    "Kuriboh",
    "MammothGraveyard",
    "GreatWhite",
    "Wolf",
    "HarpieLady",
    "HarpieLadySisters",
    "TigerAxe",
    "SilverFang",
    "Kojikocy",
    "PerfectlyUltimateGreatMoth",
    "Garoozis",
    "ThousandDragon",
    "FiendKraken",
    "Jellyfish",
    "CocoonofEvolution",
    "Kairyu-Shin",
    "GiantSoldierofStone",
    "Man-eatingPlant",
    "Krokodilus",
    "Grappler",
    "AxeRaider",
    "Megazowler",
    "Uraby",
    "CrawlingDragon#2",
    "Red-eyesB.Dragon",
    "CastleofDarkIllusions",
    "ReaperoftheCards",
    "KingofYamimakai",
    "Barox",
    "DarkChimera",
    "MetalGuardian",
    "CatapultTurtle",
    "GyakutennoMegami",
    "MysticHorseman",
    "RabidHorseman",
    "Zanki",
    "CrawlingDragon",
    "CrassClown",
    "ArmoredZombie",
    "DragonZombie",
    "ClownZombie",
    "PumpkingtheKingofGhosts",
    "BattleWarrior",
    "WingsofWickedFlame",
    "MaskofDarkness",
    "Job-ChangeMirror",
    "CurtainoftheDarkOnes",
    "Tomozaurus",
    "SpiritoftheWinds",
    "Kageningen",
    "GraveyardandtheHandofInvitation",
    "GoddesswiththeThirdEye",
    "HerooftheEast",
    "DomatheAgnelofSilence",
    "ThatWhichFeedsonLife",
    "DarkGray",
    "WhiteMagicalHat",
    "KamionWizard",
    "NightmareScorpion",
    "SpiritoftheBooks",
    "SupporterintheShadows",
    "TrialofNightmares",
    "DreamClown",
    "SleepingLion",
    "YamatanoDragonScroll",
    "DarkPlant",
    "AncientTool",
    "FaithBird",
    "OriontheBattleKing",
    "Ansatsu",
    "LaMoon",
    "Nemuriko",
    "WeatherControl",
    "Octoberser",
    "The13thGrave",
    "CharubintheFireKnight",
    "MysticalCaptureChain",
    "Fiend'sHand",
    "WittyPhantom",
    "MysteryHand",
    "DragonStatue",
    "Blue-eyedSilverZombie",
    "ToadMaster",
    "SpikedSnail",
    "FlameManipulator",
    "NecrolancertheTimelord",
    "DjinntheWatcheroftheWind",
    "TheBewitchingPhantomThief",
    "TempleofSkulls",
    "MonsterEgg",
    "TheShadowWhoControlstheDark",
    "LordoftheLamp",
    "Akihiron",
    "RhaimundosoftheRedSword",
    "TheMeltingRedShadow",
    "DokuroizotheGrimReaper",
    "FireReaper",
    "Larvas",
    "HardArmor",
    "Firegrass",
    "ManEater",
    "DigBeak",
    "M-warrior#1",
    "M-warrior#2",
    "TaintedWisdom",
    "Lisark",
    "LordofZemia",
    "TheJudgementHand",
    "MysteriousPuppeteer",
    "AncientJar",
    "DarkfireDragon",
    "DarkKingoftheAbyss",
    "SpiritoftheHarp",
    "BigEye",
    "Armail",
    "DarkPrisoner",
    "Hurricail",
    "AncientBrain",
    "FireEye",
    "Monsturtle",
    "ClawReacher",
    "PhantomDewan",
    "Arlownay",
    "DarkShade",
    "MaskedClown",
    "LuckyTrinket",
    "Genin",
    "Eyearmor",
    "FiendRefraction#2",
    "GateDeeg",
    "Synchar",
    "Fusionist",
    "Akakieisu",
    "LALALi-oon",
    "KeyMace",
    "TurtleTiger",
    "TerratheTerrible",
    "Doron",
    "ArmaKnight",
    "MechMoleZombie",
    "HappyLover",
    "PenguinKnight",
    "PetitDragon",
    "FrenziedPanda",
    "AirMarmotofNefariousness",
    "PhantomGhost",
    "Mabarrel",
    "Dorover",
    "TwinLongRods#1",
    "DrollBird",
    "PetitAngel",
    "WingedCleaver",
    "HinotamaSoul",
    "Kaminarikozou",
    "Meotoko",
    "AquaMadoor",
    "KagemushaoftheBlueFlame",
    "FlameGhost",
    "Dryad",
    "B.SkullDragon",
    "Two-mouthDarkruler",
    "Solitude",
    "MaskedSorcerer",
    "Kumootoko",
    "MidnightFiend",
    "RoaringOceanSnake",
    "TrapMaster",
    "FiendSword",
    "SkullStalker",
    "Hitodenchak",
    "WoodRemains",
    "HourglassofLife",
    "RareFish",
    "WoodClown",
    "MadjinnGunn",
    "DarkTitanofTerror",
    "BeautifulHeadhuntress",
    "WodantheResidentoftheForest",
    "GuardianoftheLabyrinth",
    "Haniwa",
    "Yashinoki",
    "VishwarRandi",
    "TheDrdek",
    "DarkAssailant",
    "CandleofFate",
    "WaterElement",
    "Dissolverock",
    "MedaBat",
    "OnewhoHuntsSouls",
    "RootWater",
    "Master&Expert",
    "WaterOmotics",
    "Hyo",
    "EnchantingMermaid",
    "Nekogal#1",
    "AngelWitch",
    "EmbryonicBeast",
    "PreventRat",
    "DimensionalWarrior",
    "StoneArmadiller",
    "BeastkingoftheSwamps",
    "AncientSorcerer",
    "LunarQueenElzaim",
    "WickedMirror",
    "TheLittleSwordsmanofAile",
    "RockOgreGrotto#2",
    "WingEggElf",
    "TheFuriosSeaKing",
    "PrincessofTsurugi",
    "UnknownWarrioroftheFiend",
    "SectarianofSecrets",
    "VersagotheDestroyer",
    "Wetha",
    "MegirusLight",
    "Mavelus",
    "AncientTreeofEnlightenment",
    "GreenPhantomKing",
    "GroundAttackerBugroth",
    "Ray&Temperature",
    "GorgonEgg",
    "PetitMoth",
    "KingFog",
    "ProtectoroftheThrone",
    "MysticClown",
    "MysticalSheep#2",
    "Holograh",
    "TaotheChanter",
    "SerpentMarauder",
    "Gatekeeper",
    "OgreoftheBlackShadow",
    "DarkArtist",
    "ChangeSlime",
    "MoonEnvoy",
    "Fireyarou",
    "PsychicKappa",
    "MasakitheLegendarySwordsman",
    "DragonesstheWickedKnight",
    "BioPlant",
    "One-eyedShieldDragon",
    "CyberSoldieroftheDarkworld",
    "WickedDragonwiththeErsatzHead",
    "SonicMaid",
    "Kurama",
    "LegendarySword",
    "SwordofDarkDestruction",
    "DarkEnergy",
    "AxeofDespair",
    "LaserCannonArmor",
    "InsectArmorwithLaserCannon",
    "Elf'sLight",
    "BeastFangs",
    "SteelShell",
    "VileGerms",
    "BlackPendant",
    "SilverBowandArrow",
    "HornofLight",
    "HornoftheUnicorn",
    "DragonTreasure",
    "Electro-whip",
    "CyberShield",
    "ElegantEgotist",
    "MysticalMoon",
    "StopDefense",
    "MalevolentNuzzler",
    "VioletCrystal",
    "BookofSecretArts",
    "Invigoration",
    "MachineConversionFactory",
    "RaiseBodyHeat",
    "FollowWind",
    "PowerofKaishin",
    "DragonCaptureJar",
    "Forest",
    "Wasteland",
    "Mountain",
    "Sogen",
    "Umi",
    "Yami",
    "DarkHole",
    "Raigeki",
    "MooyanCurry",
    "RedMedicine",
    "Goblin'sSecretRemedy",
    "SoulofthePure",
    "DianKetotheCureMaster",
    "Sparks",
    "Hinotama",
    "FinalFlame",
    "Ookazi",
    "TremendousFire",
    "SwordsofRevealingLight",
    "SpellbindingCircle",
    "Dark-piercingLight",
    "Yaranzo",
    "KanantheSwordmistress",
    "Takriminos",
    "StuffedAnimal",
    "MegasonicEye",
    "SuperWar-lion",
    "Yamadron",
    "Seiyaryu",
    "Three-leggedZombie",
    "ZeratheMant",
    "FlyingPenguin",
    "MilleniumShield",
    "Fairy'sGift",
    "BlackLusterSoldier",
    "FiendsMirror",
    "LabyrinthWall",
    "JiraiGumo",
    "ShadowGhoul",
    "WallShadow",
    "LabytinthTank",
    "SangaoftheThunder",
    "Kazejin",
    "Suijin",
    "GateGuardian",
    "DungeonWorm",
    "MonsterTamer",
    "Ryu-kishinPowered",
    "Swordstalker",
    "LaJinntheMysticalGenie",
    "Blue-eyeUltimateDragon",
    "ToonAlligator",
    "RudeKaiser",
    "ParrotDragon",
    "DarkRabbit",
    "Bickuribox",
    "Harpie'sPetDragon",
    "MysticLamp",
    "PendulumMachine",
    "GiltiatheD.Knight",
    "LauncherSpider",
    "Zoa",
    "Metalzoa",
    "ZoneEater",
    "SteelScorpion",
    "DancingElf",
    "Ocubeam",
    "Leghul",
    "Ooguchi",
    "SwordsmanfromaForeignLand",
    "EmperoroftheLandandSea",
    "UshiOni",
    "MonsterEye",
    "Leogun",
    "Tasunootoshigo",
    "SaberSlasher",
    "YaibaRobo",
    "MachineKing",
    "GiantMech-soldier",
    "MetalDragon",
    "MechanicalSpider",
    "Bat",
    "Giga-techWolf",
    "CyberSoldier",
    "ShovelCrusher",
    "Mechanicalchacer",
    "Blocker",
    "BlastJuggler",
    "Golgoil",
    "Giganto",
    "Cyber-Stein",
    "CyberCommander",
    "Jinzo#7",
    "DiceArmadillo",
    "SkyDragon",
    "ThunderDragon",
    "StoneD.",
    "KaiserDragon",
    "MagicianofFaith",
    "GoddessofWhim",
    "WaterMagician",
    "IcyWater",
    "WaterdragonFairy",
    "AncientElf",
    "BeautifulBeastTrainer",
    "WaterGirl",
    "WhiteDolphin",
    "DeepseaShark",
    "MetalFish",
    "BottomDweller",
    "7ColoredFish",
    "MechBass",
    "AquaDragon",
    "SeaKingDragon",
    "Turu-Purun",
    "GuardianoftheSea",
    "AquaSnake",
    "GiantRedSeasnake",
    "SpikeSeadra",
    "30,000-YearWhiteTurtle",
    "KappaAvenger",
    "Kanikabuto",
    "Zarigun",
    "MillenniumGolem",
    "DestroyerGolem",
    "BarrelRock",
    "MinomushiWarrior",
    "StoneGhost",
    "KaminariAttack",
    "TripwireBeast",
    "BoltEscarot",
    "BoltPenguin",
    "TheImmortalofThunder",
    "ElectricSnake",
    "WingEagle",
    "PunishedEagle",
    "SkullRedBird",
    "CrimsonSunbird",
    "QueenBird",
    "ArmedNinja",
    "MagicalGhost",
    "SoulHunter",
    "AirEater",
    "VermillionSparrow",
    "SeaKamen",
    "SinisterSerpent",
    "Ganigumo",
    "Alinsection",
    "InsectSoldiersoftheSky",
    "CockroachKnight",
    "Kuwagataα",
    "Burglar",
    "Pragtical",
    "Garvas",
    "Ameba",
    "Korogashi",
    "BooKoo",
    "FlowerWolf",
    "RainbowFlower",
    "BarrelLily",
    "NeedleBall",
    "Peacock",
    "Hoshiningen",
    "MahaVailo",
    "RainbowMarineMermaid",
    "MusicianKing",
    "Wilmee",
    "YadoKaru",
    "Morinphen",
    "Kattapillar",
    "DragonSeeker",
    "Man-eaterBug",
    "D.Human",
    "TurtleRaccoon",
    "FungioftheMusk",
    "Prisman",
    "GaleDogra",
    "CrazyFish",
    "CyberSaurus",
    "Bracchio-raidus",
    "LaughingFlower",
    "BeanSoldier",
    "CannonSoldier",
    "GuardianoftheThroneRoom",
    "BraveScizzar",
    "TheStatueofEasterIsland",
    "MukaMuka",
    "SandStone",
    "BoulderTortoise",
    "FireKraken",
    "TurtleBird",
    "Skullbird",
    "MonstrousBird",
    "TheBistroButcher",
    "StarBoy",
    "SpiritoftheMountain",
    "NeckHunter",
    "MilusRadiant",
    "Togex",
    "FlameCerebrus",
    "Eldeen",
    "MysticalSand",
    "GeminiElf",
    "KwagarHercules",
    "Minar",
    "Kamakiriman",
    "Mechaleon",
    "MegaThunderball",
    "Niwatori",
    "CorrodingShark",
    "Skelengel",
    "Hane-Hane",
    "Misairuzame",
    "Tongyo",
    "DharmaCannon",
    "Skelgon",
    "WowWarrior",
    "Griggle",
    "BoneMouse",
    "FrogtheJam",
    "Behegon",
    "DarkElf",
    "WingedDragon#2",
    "MushroomMan#2",
    "LavaBattleguard",
    "Tyhone#2",
    "TheWanderingDoomed",
    "SteelOgreGrotto#1",
    "PottheTrick",
    "OscilloHero",
    "InvaderfromAnotherDimension",
    "LesserDragon",
    "NeedleWorm",
    "WretchedGhostoftheAttic",
    "GreatMammothofGoldfine",
    "Man-eatingBlackShark",
    "Yormungarde",
    "DarkworldThorns",
    "Anthrosaurus",
    "DroolingLizard",
    "Trakadon",
    "B.DragonJungleKing",
    "EmpressJudge",
    "LittleD",
    "WitchoftheBlackForest",
    "AncientOneoftheDeepForest",
    "GiantScorpionoftheTundra",
    "CrowGoblin",
    "LeoWizard",
    "AbyssFlower",
    "PatrolRobo",
    "Takuhee",
    "DarkWitch",
    "WeatherReport",
    "BindingChain",
    "MechanicalSnail",
    "Greenkappa",
    "MonLarvas",
    "LivingVase",
    "TentaclePlant",
    "BeakedSnake",
    "MorphingJar",
    "Muse-A",
    "GiantTurtleWhoFeedsonFlames",
    "RoseSpectreofDunn",
    "FiendRefrection#1",
    "GhoulwithanAppetite",
    "PaleBeast",
    "LittleChimera",
    "ViolentRain",
    "KeyMace#2",
    "Tenderness",
    "PenguinSoldier",
    "FairyDragon",
    "ObeseMarmotofNefariousness",
    "LiquidBeast",
    "TwinLongRods2",
    "GreatBill",
    "ShiningFriendship",
    "Bladefly",
    "ElectricLizard",
    "Hiro'sShadowScout",
    "LadyofFaith",
    "Twin-headedThunderDragon",
    "HunterSpider",
    "ArmoredStarfish",
    "HourglassofCourage",
    "MarineBeast",
    "WarriorofTradition",
    "RockSpirit",
    "Snakeyashi",
    "SuccubusKnight",
    "IllWitch",
    "TheThingThatHidesIntheMud",
    "HighTideGyojin",
    "FairyoftheFountain",
    "AmazonoftheSeas",
    "Nekogal#2",
    "Witch'sApprentice",
    "ArmoredRat",
    "AncientLizardWarrior",
    "MaidenoftheMoonlight",
    "StoneOgreGrotto",
    "WingedEggofNewLife",
    "NightLizard",
    "Queen'sDouble",
    "Blue-wingedCrown",
    "Trent",
    "QueenofAutumnLeaves",
    "AmphibiousBugroth",
    "AcidCrawler",
    "InvaderoftheThrone",
    "MysticalSheep#1",
    "DiskMagician",
    "FlameViper",
    "RoyalGuard",
    "GruesomeGoo",
    "Hyosube",
    "MachineAttacker",
    "Hibikime",
    "WhiptailCrow",
    "KunaiwithChain",
    "MagicalLabyrinth",
    "WarriorElimination",
    "Salamandra",
    "Cursebreaker",
    "EternalRest",
    "Megamorph",
    "Metalmorph",
    "WingedTrumpeter",
    "StainStorm",
    "CrushCard",
    "EradicatingAerosol",
    "BreathofLight",
    "EternalDraught",
    "CurseofMillenniumShield",
    "YamadronRitual",
    "GateGuardianRitual",
    "BrightCastle",
    "ShadowSpell",
    "BlackLusterRitual",
    "ZeraRitual",
    "Harpie'sFeatherDuster",
    "War-lionRitual",
    "BeastryMirrorRitual",
    "UltimateDragon",
    "CommencementDance",
    "HamburgerRecipe",
    "RevivalofSennenGenjin",
    "Novox'sPrayer",
    "CurseofTri-HornedDragon",
    "HouseofAdhesiveTape",
    "Eatgaboon",
    "BearTrap",
    "InvisibleWire",
    "AcidTrapHole",
    "WidespreadRuin",
    "GoblinFan",
    "BadReactiontoSimochi",
    "ReverseTrap",
    "FakeTrap",
    "RevivedofSerpentNightDragon",
    "TurtleOath",
    "ContructofMask",
    "ResurrectionofChakra",
    "PuppetRitual",
    "JavelinBeetlePact",
    "GarmaSwordOath",
    "CosmoQueen'sPrayer",
    "RevivalofSkeletonRider",
    "FortressWhale'sOath",
    "PerformanceofSword",
    "HungryBurger",
    "Sengenjin",
    "SkullGuardian",
    "Tri-hornedDragon",
    "SerpentNightDragon",
    "SkullKnight",
    "CosmoQueen",
    "Chakra",
    "CrabTurtle",
    "Mikazukinoyaiba",
    "MeteorDragon",
    "MeteorB.Dragon",
    "FirewingPegasus",
    "Psycho-Puppet",
    "GarmaSword",
    "JavelinBeetle",
    "FortressWhale",
    "Dokurorider",
    "MaskofShine&Dark",
    "DarkMagicRitual",
    "MagicianofBlackChaos"
}

local DuelistPlayer = {}
for i = 1, 39 do
    DuelistPlayer[i] = {["SA_POW"] = {},["BCD"] = {}, ["SA_TEC"] = {}}
end
DuelistPlayer[40] = 0
local DuelistOpponent = {}
for i = 1, 39 do
    DuelistOpponent[i] = {["SA_POW"] = {},["BCD"] = {}, ["SA_TEC"] = {}}
end
DuelistOpponent[40] = 0

-- define host and port
host = "*"
port = 50000

mainform = nil
subform = nil
local text1, btnQuit, btnJoin, btnHost, btnData, btnUpdate
local lblPort, txtPort
local lblDuelist, lblRank, text2, lblPlayerObtainds, lblPlayer2Obtainds, lblUsername
local server = 1

print("Loading information tool data!")
local infoDump = assert(io.open("dropInfo.txt"))
infoData = infoDump:read("*a")
dropInfo = json.decode(infoData)
infoDump:close()

rankListing = {"SA_POW", "BCD", "SA_TEC"}
testingNum = 1
testingNum2 = 1
testingNumTwo = 99
LastDuelist = "None"

--Add a line to the output. Inserts a timestamp to the string
function printOutput(str, window)
    local text = forms.gettext(window)
    local pos = #text
    forms.setproperty(window, "SelectionStart", pos)

    str = string.gsub(str, "\n", "\r\n")
    if pos > 0 then
        str = "\r\n" .. str
    end

    forms.setproperty(window, "SelectedText", str)
end

function checkSum()
    info = gameinfo.getromhash()
    if info == "BA75C09D" then
        maxCard = 1
        printOutput("Vanilla detected!", text1)
    elseif info == "3176311E" then
        maxCard = 2
        printOutput("2 Card mod detected!", text1)
    elseif info == "8BFA791A" then
        maxCard = 3
        printOutput("3 Card mod detected!", text1)
    elseif info == "82B2B619" then
        maxCard = 4
        printOutput("4 Card mod detected!", text1)
    elseif info == "14358180" then
        maxCard = 5
        printOutput("5 Card mod detected!", text1)
    elseif info == "287A712E" then
        maxCard = 6
        printOutput("6 Card mod detected!", text1)
    elseif info == "5287D478" then
        maxCard = 7
        printOutput("7 Card mod detected!", text1)
    elseif info == "02A34F75" then
        maxCard = 8
        printOutput("8 Card mod detected!", text1)
    elseif info == "16CF99DA" then
        maxCard = 9
        printOutput("9 Card mod detected!", text1)
    elseif info == "094FD431" then
        maxCard = 10
        printOutput("10 Card mod detected!", text1)
    elseif info == "DBD97342" then
        maxCard = 11
        printOutput("11 Card mod detected!", text1)
    elseif info == "C4C54058" then
        maxCard = 12
        printOutput("12 Card mod detected!", text1)
    elseif info == "95DA50AD" then
        maxCard = 13
        printOutput("13 Card mod detected!", text1)
    elseif info == "F891881D" then
        maxCard = 14
        printOutput("14 Card mod detected!", text1)
    elseif info == "AF6149F7" then
        maxCard = 15
        printOutput("15 Card mod detected!", text1)
    else
        printOutput(
            "This game is not compatible with Lockout. Please check you are using Vanilla or the X Card variants.",
            text1
        )
    end
end

function tprint(tbl, indent)
    if not indent then
        indent = 0
    end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            printOutput(formatting, infoBox)
            tprint(v, indent + 1)
        elseif type(v) == "boolean" then
            printOutput(formatting .. tostring(v), infoBox)
        else
            printOutput(formatting .. v, infoBox)
        end
    end
end

function RankCalc(r)
    if r >= 80 then
        DuelRank = "SA_POW"
        return DuelRank
    else
        if r <= 19 then
            DuelRank = "SA_TEC"
            return DuelRank
        else
            DuelRank = "BCD"
            return DuelRank
        end
    end
end

function updateInfo()
    forms.settext(infoBox, "")
    opponentDuelistCheck = forms.gettext(duelistCheck)
    duelistInfoCheck = DuelistListList[opponentDuelistCheck]
    duelistRankCheck = forms.gettext(rankCheck)
    testingNum = #DuelistPlayer[duelistInfoCheck][duelistRankCheck]
    testingNum2 = #DuelistOpponent[duelistInfoCheck][duelistRankCheck]
    testingNumTwo = #dropInfo[duelistInfoCheck][duelistRankCheck]
    forms.settext(lblPlayerObtaindNum, testingNum .. "/" .. testingNumTwo)
    forms.settext(lblOpponentObtaindNum, testingNum2 .. "/" .. testingNumTwo)
    for i = 1, #dropInfo[duelistInfoCheck][duelistRankCheck] do
        checkCard = dropInfo[duelistInfoCheck][duelistRankCheck][i]["Card"]
        --print("TESTING: " .. checkCard)
        for k, v in pairs(DuelistOpponent[duelistInfoCheck][duelistRankCheck]) do
            if checkCard == v then
                printOutput(dropInfo[duelistInfoCheck][duelistRankCheck][i]["Name"] .. " | " .. "Rarity: " .. dropInfo[duelistInfoCheck][duelistRankCheck][i]["Rarity"], infoBox)
                break
            end
        end
        i = i + 1
    end
end

function lockout()
    --while a duel is going on (free duel or campaign)
    if (memory.read_u32_le(0x09B26C) == 0x008106C3 or 0x008105C3) --[[ and duelCompleted == false ]] then
        --If Opponents LP reaches 0 or Opponent draws 40 cards
        if memory.readbyte(0x0EA024) == 0 or memory.readbyte(0x0EA028) == 40 then
            --Determine which duelist is being fought
            duelist = memory.readbyte(DuelistAddress)
            wonCards = {}
            rewardsList = {}
            --if the game is at the Spoils screen, test each card for lockout
            if memory.readbyte(SpoilsAddress) > 0 then
                --calculate and store the rank
                DuelRank = RankCalc(memory.readbyte(RankAddress))
                
                --set a changing Spoils Address variable
                for i = 1, maxCard do
                    Lockout = false
                    Obtained = false
                    Spoils = (SpoilsAddress + ((i - 1) * 0x2))
                    CurrentCard = memory.read_u16_le(Spoils)
                    rewardsList[i] = CurrentCard
                    for k, card in pairs(DuelistOpponent[duelist][DuelRank]) do
                        if card == CurrentCard and card ~= 657 then
                            Lockout = true
                            printOutput("Card locked out!", text1)
                            LockedOut[i] = true
                            break
                        else
                            Lockout = false
                        end
                    end
                    for k, card in pairs(DuelistPlayer[duelist][DuelRank]) do
                        if card == CurrentCard and card ~= 657 then
                            Obtained = true
                            printOutput("Card already obtained!", text1)
                            LockedOut[i] = false
                            break
                        else
                            Obtained = false
                        end
                    end
                    --Megamorph Rule
                    if CurrentCard == 657 then
                        if MMCount >= 3 then
                            printOutput("All Megamorphs have been obtained already!", text1)
                            Lockout = true
                            --print("Card locked out!")
                            LockedOut[i] = true
                        else
                            PlayerMMCount = PlayerMMCount + 1
                            DuelistPlayer[40] = PlayerMMCount
                            Lockout = false
                        end
                    end
                    if Lockout ~= true and Obtained ~= true then
                        
                        printOutput("Locking out card!", text1)
                        
                        table.insert(DuelistPlayer[duelist][DuelRank], CurrentCard)
                        table.insert(wonCards, CurrentCard)

                        LockedOut[i] = false
                    end
                end
                --ideal moment to sync lists
                --tprint(DuelistPlayer)
                table.insert(wonCards, duelist)
                table.insert(wonCards, DuelRank)
                local test = assert(io.open("duelistPlayer.txt", "w"))
                backupPlayer = json.encode(DuelistPlayer)
                test:write(backupPlayer)
                test:close()
                --print(result)
                result = json.encode(wonCards)
                tcp:send(result .. "\n")

                --write opponent LP and cards used to base to prevent looping
                memory.write_u16_le(0x0EA024, 8000)
                memory.writebyte(0x0EA028, 0)

                duelCompleted = true
                printOutput("----------------", text1)

            --tprint(DuelistPlayer[duelist])
            --memory.writebyte(0x106068, 0)
            end
        end
    end
end

function startHost()
    port = forms.gettext(txtPort)
    -- create socket and bind to an available port
    server = assert(socket.bind(host, port))
    isHosting = true
    -- new client connected, settimeout to not block connetcion
    server:settimeout(0)
    local client, err = server:accept()
    -- print the info of new client and add new client to the table
    if (not err) then
        clientname = client:receive()
        totalclient = totalclient + 1
        clients[totalclient] = client
        clientnames[totalclient] = clientname
        printOutput(">> " .. clientname .. " connected!", text1)
    end

    host = "127.0.0.1"
    tcp:connect(host, port)
    username = forms.gettext(txtUsername)
    tcp:send(username .. "\n")
    
end

function Hosting()
    -- new client connected, settimeout to not block connetcion
    server:settimeout(0)
    local client, err = server:accept()

    -- print the info of new client and add new client to the table
    if (not err) then
        clientname = client:receive()
        totalclient = totalclient + 1
        clients[totalclient] = client
        clientnames[totalclient] = clientname
        printOutput(">> " .. clientname .. " connected!", text1)
    end

    -- loop through the client table
    for i = 1, totalclient do
        -- if there is client, listen to that client
        if (clients[i] ~= nil) then
            clients[totalclient]:settimeout(0) -- prevent blocking
            clientmessage, err = clients[i]:receive() -- accept data from client
            -- check if there is something sent to server, and no error occured
            if (err == nil and clientmessage ~= nil) then
                --for
                -- loop through the list of client to send broadcast message
                --DO WORK HERE
                --print(clientmessage)
                --else
                for j = 1, totalclient do
                    -- check not to send broadcast to the speaker
                    if clientnames[i] ~= clientnames[j] then
                        clients[j]:send(tostring(clientmessage .. "\n"))
                    end
                end
            else
                Listen()
                lockout()
            end
        --if
        end
        --if
    end
    --if
end

function Listen()
    tcp:settimeout(0)
    local opponentMessage, err = tcp:receive()
    if (err == nil and opponentMessage ~= nil) then
        lockedCards = json.decode(opponentMessage)
        lockedCardCount = #lockedCards - 2
        opponentDueilst = #lockedCards - 1
        opponentRank = #lockedCards
        tempDuelist = lockedCards[opponentDueilst]
        tempDuelRank = lockedCards[opponentRank]
        if lockedCardCount ~= 0 then
            for i=1, lockedCardCount do
                table.insert(DuelistOpponent[tempDuelist][tempDuelRank], lockedCards[i])
                if lockedCards[i] == 657 then
                    OpponentMMCount = OpponentMMCount + 1
                end
            end
        end
        --print(OpponentMMCount)
        LastDuelistNum = tempDuelist
        --print(LastDuelistNum)
        LastDuelist = DuelistList[LastDuelistNum]
        printOutput("Opponent beat: " .. LastDuelist, text1)
        forms.settext(lastSeen, "Opponent Last Seen at: " .. LastDuelist)
        local test = assert(io.open("duelistOpponent.txt", "w"))
        opponentBackup = json.encode(DuelistOpponent)
        test:write(opponentBackup)
        test:close()
        printOutput("----------------", text1)
    end
end

function Join()
    joiningPort = forms.gettext(txtPort)
    joiningIP = forms.gettext(txtIP)

    username = forms.gettext(txtUsername)
    tcp:connect(joiningIP, joiningPort)
    tcp:send(username .. "\n")
    isConnected = true
end

function loadData()
    printOutput("Loading Data from duelistPlayer.txt", text1)
    local test = assert(io.open("duelistPlayer.txt"))
    LoadData = test:read("*a")
    print(LoadData)
    print("Junk")
    DuelistPlayer = json.decode(LoadData)
    test:close()
    printOutput("Loading Data from duelistOpponent.txt", text1)
    local test2 = assert(io.open("duelistOpponent.txt"))
    LoadData = test2:read("*a")
    print(LoadData)
    DuelistOpponent = json.decode(LoadData)
    test2:close()
    PlayerMMCount = DuelistPlayer[40]
    OpponentMMCount = DuelistOpponent[40]
end

--Quit/Disconnect click handle for the quit button
function leaveRoom()
    printOutput("Closing connection", text1)
    if isHosting == true then
        server:close()
        isHosting = false
    end
end

mainform = forms.newform(310, 280, "FM Lockout")

subform = forms.newform(520, 640, "Lockout Data")

txtUsername = forms.textbox(mainform, "", 210, 20, nil, 69, 14, false, false)
lblUsername = forms.label(mainform, "Username:", 12, 16)
txtIP = forms.textbox(mainform, "", 120, 20, nil, 69, 40, false, false)
lblIP = forms.label(mainform, "Host IP:", 25, 42)
txtPort = forms.textbox(mainform, "", 55, 20, nil, 224, 40, false, false)
lblPort = forms.label(mainform, "Port:", 195, 42)
text1 = forms.textbox(mainform, "", 263, 130, nil, 16, 96, true, true, "Vertical")
forms.setproperty(text1, "ReadOnly", true)
btnHost =
    forms.button(
    mainform,
    "Create Room",
    function()
        startHost()
    end,
    15, 65, 85, 25
)
btnJoin =
    forms.button(
    mainform,
    "Join Room",
    function()
        Join()
    end,
    105,
    65,
    85,
    25
)
btnReset =
    forms.button(
    mainform,
    "Load Data?",
    function()
        loadData()
    end,
    195,
    65,
    85,
    25
)
lastSeen = forms.label(subform, "Opponent Last Seen at: " .. LastDuelist, 150, 580, 280, 500)
lblDuelist = forms.label(subform, "Duelist:", 6, 10, 50, 12)
duelistCheck = forms.dropdown(subform, DuelistListListList, 9, 27, 92, 25)
lblRank = forms.label(subform, "Rank:", 6, 52, 50, 12)
rankCheck = forms.dropdown(subform, rankListing, 9, 69, 92, 25)
btnUpdate =
    forms.button(
    subform,
    "Update",
    function()
        updateInfo()
    end,
    8,
    100,
    94,
    35
)
infoBox = forms.textbox(subform, "", 390, 570, nil, 110, 5, true, true, "Vertical")
forms.setproperty(infoBox, "ReadOnly", true)

lblPlayerObtaind = forms.label(subform, "Cards Obtained:", 17, 142)
lblPlayerObtaindNum = forms.label(subform, testingNum .. "/" .. testingNumTwo, 45, 164)

lblOpponentObtaind = forms.label(subform, "Cards Locked Out:", 10, 187)
lblOpponentObtaindNum = forms.label(subform, testingNum2 .. "/" .. testingNumTwo, 45, 210)

--btnData = forms.button(mainform, "Lockout Data", lockoutData, 15, 70, 130, 25)
--forms.setproperty(btnQuit, "Enabled", false)


totalclient = 0 -- store the total connections
clients = {} -- e.g. clients[1] = 0xSocketAddress
clientnames = {} -- e.g. clientnames[1] = "john"

--tprint(dropInfo)

checkSum()

--Main Loop
while true do
    --End script if form is closed
    if forms.gettext(mainform) == "" then
        leaveRoom()
        forms.destroy(subform)
        return
    end

    if isHosting == true then
        Hosting()
    end

    if isConnected == true and isHosting ~= true then
        Listen()
        lockout()
    end
    --rewards colors in a place where it won't block
    if duelCompleted == true and (memory.read_u32_le(0x09B26C) == 0x008106C3 or 0x008105C3) then
        --print("Color rewards")
        k = memory.read_u16_le(0x1AAC20)
        if k == 0 then
            k = #LockedOut
        end
        --color spoils rewards
        cardShown = rewardsList[k]
        cardName = cardList[cardShown]
        if LockedOut[k] == true then
            for i = 1, (((#cardName + 3)*2)+2) do
                memory.write_u32_le(RewardsColoring[i], 0x646E71C4)
                i = i + 1
            end
        else
            for i = 1, (((#cardName + 3)*2)+2) do
                memory.write_u32_le(RewardsColoring[i], 0x6474B575)
                i = i + 1
            end
        end
        Inputs = joypad.get(1)
        if Inputs["Cross"] == true then
            --check cards for locked out values, if true replace card with card 721
            for k, v in pairs(LockedOut) do
                Spoils = (SpoilsAddress + ((k - 1) * 0x2))
                if v == true then
                    memory.write_u16_le(Spoils, 721)
                end
            end
            duelCompleted = false
        end
    end
    --need this or emu crashes since it can't advance in a while loop
    emu.frameadvance()
end
--now go check out DK64 Rando.