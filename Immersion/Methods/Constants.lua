--	Filename:	Constants.lua
--	Project:	pretty_wow
--	Author:		s0high
--	E-mail:		s0h2x.hub@gmail.com
--	Web:		https://github.com/s0h2x

---@type table<string, EnumConst>
EnumConst = {}

---@const global
---@class quests
QUEST_SPELL_REWARD_TYPE_FOLLOWER = 1;
QUEST_SPELL_REWARD_TYPE_TRADESKILL_SPELL = 2;
QUEST_SPELL_REWARD_TYPE_ABILITY = 3;
QUEST_SPELL_REWARD_TYPE_AURA = 4;
QUEST_SPELL_REWARD_TYPE_SPELL = 5;

---@type table<number, QuestInfoSpellRewardType>
QUEST_INFO_SPELL_REWARD_ORDERING =
{
    QUEST_SPELL_REWARD_TYPE_FOLLOWER,
    QUEST_SPELL_REWARD_TYPE_TRADESKILL_SPELL,
    QUEST_SPELL_REWARD_TYPE_ABILITY,
    QUEST_SPELL_REWARD_TYPE_AURA,
    QUEST_SPELL_REWARD_TYPE_SPELL,
};

QUEST_INFO_SPELL_REWARD_TO_HEADER =
{
    [QUEST_SPELL_REWARD_TYPE_FOLLOWER] = REWARD_FOLLOWER,
    [QUEST_SPELL_REWARD_TYPE_TRADESKILL_SPELL] = REWARD_TRADESKILL_SPELL,
    [QUEST_SPELL_REWARD_TYPE_ABILITY] = REWARD_ABILITY,
    [QUEST_SPELL_REWARD_TYPE_AURA] = REWARD_AURA,
    [QUEST_SPELL_REWARD_TYPE_SPELL] = REWARD_SPELL,
};

---@enum SOUNDKIT
EnumConst.SOUNDKIT =
{
    IG_QUEST_LIST_OPEN = 875,
    IG_QUEST_LIST_CLOSE = 876,
    IG_QUEST_LIST_SELECT = 877,
    IG_QUEST_LIST_COMPLETE = 878,
    IG_QUEST_CANCEL = 879,
}

---@enum animation type<number>
local YELLING = 64
local ASKING = 65
local TALKING = 60
local AGREE = 185
local DISAGREE = 186
local READING = 520
local IDLE = 0

---@enum model zoom factory<boolean>
local ZOOM = true

---@enum UiModelPositionCamera
---@param x, y, z, angle
EnumConst.UiModelPositionCamera =
{
    ['Original'] = {
        ['airelemental/airelemental']                           = { 1.600, 0.540, -1.500, -0.410 },
        ['arakkoa/arakkoa']                                     = { 1.015, 0.925, -1.580, -0.335, ZOOM },
        ['arcanegolem/arcanegolem']                             = { 0.455, 0.855, -4.440, -0.280 },
        ['banshee/banshee']                                     = { 6.750, 0.888, 1.050, -0.460 },
        ['bloodelf/female/bloodelffemale']                      = { 1.454, 0.132, -1.756, 0.191, ZOOM },
        ['bloodelf/male/bloodelfmale']                          = { 1.898, 0.110, -2.012, 0.360, ZOOM },
        ['centaur/centaur']                                     = { 3.516, 1.100, -2.000, -0.360 },
        ['cfx_paladin_precastspecial_precasthand']              = { 1.900, 0.000, 0.780, 0.210 },
        ['chicken/chicken']                                     = { 7.850, 0.200, 2.850, -0.520 },
        ['draenei/female/draeneifemale']                        = { 1.830, 0.000, -2.280, 0.274, ZOOM },
        ['draenei/male/draeneimale']                            = { 1.900, -0.070, -2.010, 0.200, ZOOM },
        ['dragonspawn/dragonspawn']                             = { 1.300, 3.650, -1.650, -0.580 },
        ['dragonwhelp/dragonwhelp']                             = { 0.150, 0.321, -1.450, -0.400, ZOOM },
        ['dreadlord/dreadlord']                                 = { 3.000, 0.010, -2.500, -0.160, ZOOM },
        ['dryad/dryad']                                         = { 4.600, 0.540, -0.780, -0.310 },
        ['dwarf/female/dwarffemale']                            = { 1.095, -0.021, -1.219, 0.355, ZOOM },
        ['dwarf/male/dwarfmale']                                = { 1.040, -0.041, -1.152, 0.340, ZOOM },
        ['earthendwarf/earthendwarf']                           = { 1.095, -0.021, -1.950, 0.355, ZOOM },
        ['elementalearth/elementalearth']                       = { 1.150, 0.525, -1.700, -0.390, ZOOM },
        ['etherial/etherial']                                   = { 3.604, -0.112, -2.187, -0.225, ZOOM },
        ['etherialrobe/etherialrobe']                           = { 2.200, -0.180, -2.320, 0.010, ZOOM },
        ['fleshgolem/fleshgolem']                               = { -1.900, 0.224, -3.546, -0.250 },
        ['forceofnature/forceofnature']                         = { 0.800, 0.536, -1.800, -0.420, ZOOM },
        ['freia/freia']                                         = { 5.012, 0.600, -7.520, -0.320, ZOOM },
        ['furbolg/furbolg']                                     = { 0.115, 0.585, -1.100, -0.610, ZOOM },
        ['ghost/ghost']                                         = { -1.280, 0.000, 4.000, 0.000 },
        ['gnome/female/gnomefemale']                            = { 0.400, 0.020, -0.660, 0.510, ZOOM },
        ['gnome/male/gnomemale']                                = { 0.271, -0.002, -0.735, 0.360, ZOOM },
        ['gnomespidertank/gnomepounder']                        = { -1.371, 0.452, -2.200, -0.160, ZOOM },
        ['goblin/female/goblinfemale']                          = { 0.503, -0.006, -1.094, -0.480, ZOOM },
        ['goblin/male/goblinmale']                              = { 0.503, 0.076, -1.040, -0.480, ZOOM },
        ['highelf/highelffemale_hunter']                        = { 1.170, 0.000, -2.200, 0.240, ZOOM },
        ['highelf/highelfmale_hunter']                          = { 1.370, 0.000, -1.900, 0.240, ZOOM },
        ['hodir/hodir']                                         = { 2.459, 0.320, -6.015, -0.150, ZOOM },
        ['human/female/humanfemale']                            = { 1.309, 0.067, -1.788, 0.295, ZOOM },
        ['human/male/humanmale']                                = { 1.505, -0.012, -1.920, 0.280, ZOOM },
        ['humanfemalefarmer/humanfemalefarmer']                 = { 7.200, 0.100, -0.500, -0.250 },
        ['humanmalefarmer/humanmalefarmer']                     = { 7.400, 0.200, -0.450, 0.180 },
        ['humanmalekid/humanmalekid']                           = { 7.800, 0.000, 1.000, -0.280 },
        ['humlblacksmith/humlblacksmith']                       = { 6.500, -0.090, -0.540, -0.500 },
        ['illidan/illidan']                                     = { 3.720, -0.070, -4.300, -0.300, ZOOM },
        ['interface/buttons/talktome']                          = { 1.100, 0.000, 0.400, 0.000 },
        ['keeperofthegrove/keeperofthegrove']                   = { 1.250, -1.800, -2.800, -0.255 },
        ['kelthuzad/kelthuzad']                                 = { 2.200, 0.010, 0.800, -0.250 },
        ['lich/lich']                                           = { 2.300, 0.350, -4.500, -0.460 },
        ['lostone/lostone']                                     = { 1.065, 0.135, -1.520, -0.420, ZOOM },
        ['malygos/malygos']                                     = { -5.037, 5.045, -3.980, -0.335, ZOOM },
        ['miev/miev']                                           = { 1.310, 0.000, -1.400, -0.315, ZOOM },
        ['moarg/moarg1']                                        = { 3.514, 0.045, -1.029, -0.145 },
        ['murloc/murloc']                                       = { 4.255, 0.365, 1.100, -0.590 },
        ['naga_/female/naga_female']                            = { 2.300, 0.116, -1.880, -0.300, ZOOM },
        ['naga_/male/naga_male']                                = { 1.435, 0.340, -1.770, -0.335, ZOOM },
        ['nightelf/female/nightelffemale']                      = { 2.022, 0.001, -2.114, 0.220, ZOOM },
        ['nightelf/male/nightelfmale']                          = { 2.181, 0.001, -2.335, 0.230, ZOOM },
        ['northrendgiant/gymer']                                = { -0.071, 0.485, -10.285, -0.250, ZOOM },
        ['ogre/ogre']                                           = { 1.205, -0.012, -2.354, 0.280, ZOOM },
        ['orc/female/orcfemale']                                = { 1.641, -0.017, -1.768, 0.300, ZOOM },
        ['orc/male/orcmale']                                    = { 0.964, -0.122, -1.902, 0.300, ZOOM },
        ['satyr/satyr']                                         = { 3.800, 0.536, -1.800, -0.420 },
        ['scourge/female/scourgefemale']                        = { 1.570, -0.060, -1.700, 0.350, ZOOM },
        ['scourge/male/scourgemale']                            = { 1.234, 0.155, -1.714, 0.360, ZOOM },
        ['seaturtle/seaturtle']                                 = { 0.555, 0.325, -0.300, -0.440, ZOOM },
        ['spirithealer/spirithealer']                           = { -2.700, 0.420, -8.500, -0.320 },
        ['stonekeeper/stonekeeper']                             = { -5.000, 1.400, -10.000, -0.380 },
        ['tauren/female/taurenfemale']                          = { 1.359, -0.225, -1.700, 0.421, ZOOM },
        ['tauren/male/taurenmale']                              = { 1.074, -0.387, -1.567, 0.430, ZOOM },
        ['titanmale/titanmale']                                 = { -6.700, 2.400, -5.800, -0.380 },
        ['troll/female/trollfemale']                            = { 2.087, 0.045, -2.102, 0.295, ZOOM },
        ['troll/male/trollmale']                                = { 1.591, -0.170, -1.928, 0.295, ZOOM },
        ['tuskarr/male/tuskarrmale']                            = { 1.310, -0.010, -1.714, 0.240, ZOOM },
        ['tuskarrmalefisherman/tuskarrmalefisherman']           = { 1.900, 0.010, -1.400, -0.250 },
        ['ulduar/ul_planet_azeroth_nobase']                     = { -97.000, 0.000, 185.0, 0.000 },
        ['voidcaller/voidcaller']                               = { -1.250, 0.100, -2.000, -0.120, ZOOM },
        ['vrykul/male/vrykulmale']                              = { 3.160, 0.440, -4.010, -0.215, ZOOM },
        ['vrykulfemale/femalevrykulboss']                       = { 4.303, 0.120, -4.013, -0.280, ZOOM },
        ['waterelemental/waterelemental']                       = { 0.720, 0.500, -3.600, -0.440 },
    },
    ['HD'] = {
        ---@enum HD models
        ['airelemental/airelemental']                           = { 0.850, 0.425, -1.900, -0.390, ZOOM },
        ['ancientoflore2/ancientoflore2']                       = { 14.512, 0.600, -5.820, -0.320, ZOOM },
        ['anubisath/anubisath']                                 = { 3.700, 1.000, -6.300, -0.460, ZOOM },
        ['arcanegolem/arcanegolem']                             = { 4.195, 0.452, -2.635, -0.370, ZOOM },
        ['centaur2/centaur2']                                   = { 2.816, 0.756, -3.427, -0.390, ZOOM },
        ['centaur2_female/centaur2_female']                     = { 0.260, 0.400, -2.600, -0.390, ZOOM },
        ['chicken/chicken']                                     = { 0.180, 0.100, -0.250, -0.520, ZOOM },
        ['draenei/male/draeneimale']                            = { 1.450, -0.070, -2.250, 0.200, ZOOM },
        ['dragonspawn2_female/dragonspawn2_female']             = { 2.600, 0.480, -2.500, -0.450, ZOOM },
        ['dragonwhelp/dragonwhelp']                             = { 3.770, 0.321, -0.400, -0.400, ZOOM },
        ['druidbear/druidbeartauren']                           = { -0.400, 1.500, -0.500, -0.750, ZOOM },
        ['dryad/dryad']                                         = { 1.100, 0.140, -1.820, -0.280, ZOOM },
        ['dwarf/female/dwarffemale']                            = { 0.895, -0.021, -1.219, 0.355, ZOOM },
        ['dwarf/male/dwarfmale']                                = { 1.150, -0.041, -1.350, 0.340, ZOOM },
        ['ent2/ent2']                                           = { 1.100, 0.355, -1.500, -0.420, ZOOM },
        ['fleshgolem/fleshgolem']                               = { 2.970, -0.796, -2.200, -0.760, ZOOM },
        ['freia/freia']                                         = { 8.812, 0.600, -7.520, -0.320, ZOOM },
        ['furbolg2/furbolg2']                                   = { 1.670, 0.855, -2.110, -0.500, ZOOM },
        ['ghost/ghost']                                         = { 2.350, 0.000, -2.300, -0.350, ZOOM },
        ['goblin/female/goblinfemale']                          = { 0.911, -0.006, -0.940, 0.210, ZOOM },
        ['goblin/male/goblinmale']                              = { 0.911, 0.016, -0.940, 0.210, ZOOM },
        ['human/female/humanfemale']                            = { 1.225, -0.040, -1.800, 0.315, ZOOM },
        ['human/male/humanmale']                                = { 1.425, -0.012, -1.930, 0.280, ZOOM },
        ['jaina3/jaina3']                                       = { 1.440, 0.140, -1.306, 0.320, ZOOM },
        ['keeperofthegrove/keeperofthegrove']                   = { 1.800, 0.290, -2.080, -0.255, ZOOM },
        ['kultiran/male/kultiranmale']                          = { 2.961, -0.015, -2.430, 0.295, ZOOM },
        ['lich2/lich2']                                         = { 4.000, 0.180, -3.350, -0.300, ZOOM },
        ['malfurion/malfurion']                                 = { 3.900, 0.001, -2.345, 0.230, ZOOM },
        ['malygos/malygos']                                     = { -5.037, 5.045, -3.980, -0.335, ZOOM },
        ['rexxar/rexxar']                                       = { 2.630, 0.000, -2.375, 0.300, ZOOM },
        ['satyr/satyr']                                         = { 4.200, 0.175, -2.200, -0.390, ZOOM },
        ['scourge/female/scourgefemale']                        = { 1.795, -0.060, -1.660, 0.350, ZOOM },
        ['tauren/male/taurenmale']                              = { 1.560, -0.395, -1.700, 0.430, ZOOM },
        ['thinhuman_male/thinhuman_citizens_pirat']             = { 2.330, -0.020, -1.690, 0.300, ZOOM },
        ['thrall/thrall']                                       = { 1.835, -0.012, -2.000, 0.280, ZOOM },
        ['troll/female/trollfemale']                            = { 1.880, 0.045, -2.110, 0.295, ZOOM },
        ['troll/male/trollmale']                                = { 1.280, -0.170, -1.980, 0.255, ZOOM },
        ['valkier/valkier']                                     = { 6.500, 0.150, -3.870, -0.280, ZOOM },
        ['varimathras/varimathras']                             = { 3.016, 0.136, -2.427, -0.200, ZOOM },
        ['velen/velen']                                         = { 3.880, -0.080, -2.260, 0.050, ZOOM },
    },
}
---@enum model equals
---@type table<string, Enum>
local CustomCamera = EnumConst.UiModelPositionCamera['Original']
CustomCamera['akama/akama']                                           = CustomCamera['human/male/humanmale']
CustomCamera['alexstrasza/ladyalexstrasa']                            = CustomCamera['bloodelf/female/bloodelffemale']
CustomCamera['alglontheobserver/algalontheobserver']                  = CustomCamera['vrykul/male/vrykulmale']
CustomCamera['anubisath/anubisath']                                   = CustomCamera['titanmale/titanmale']
CustomCamera['arakkoa/arakkoa_sage']                                  = CustomCamera['arakkoa/arakkoa']
CustomCamera['arakkoa/arakkoa_warrior']                               = CustomCamera['arakkoa/arakkoa']
CustomCamera['arcanegolem/arcanegolembroken']                         = CustomCamera['arcanegolem/arcanegolem']
CustomCamera['arcanevoidwraith/arcanevoidwraith']                     = CustomCamera['elementalearth/elementalearth']
CustomCamera['arthas/arthas']                                         = CustomCamera['human/male/humanmale']
CustomCamera['arthaslichking/arthaslichking']                         = CustomCamera['human/male/humanmale']
CustomCamera['arthasundead/arthasundead']                             = CustomCamera['human/male/humanmale']
CustomCamera['bloodelffemalekid/bloodelffemalekid']                   = CustomCamera['humanmalekid/humanmalekid']
CustomCamera['bloodelfmalekid/bloodelfmalekid']                       = CustomCamera['humanmalekid/humanmalekid']
CustomCamera['broken/male/brokenmale']                                = CustomCamera['human/male/humanmale']
CustomCamera['centaur/centaurcaster']                                 = CustomCamera['centaur/centaur']
CustomCamera['centaur/centaurkhan']                                   = CustomCamera['centaur/centaur']
CustomCamera['centaur/centaurwarrior']                                = CustomCamera['centaur/centaur']
CustomCamera['clockworkgnome/clockworkgnome']                         = CustomCamera['gnome/male/gnomemale']
CustomCamera['clockworkgnome/clockworkgnome_a']                       = CustomCamera['gnome/male/gnomemale']
CustomCamera['clockworkgnome/clockworkgnome_b']                       = CustomCamera['gnome/male/gnomemale']
CustomCamera['clockworkgnome/clockworkgnome_c']                       = CustomCamera['gnome/male/gnomemale']
CustomCamera['clockworkgnome/clockworkgnome_d']                       = CustomCamera['gnome/male/gnomemale']
CustomCamera['crackelf/crackelfmale']                                 = CustomCamera['scourge/male/scourgemale']
CustomCamera['crystaldryad/crystaldryad']                             = CustomCamera['dryad/dryad']
CustomCamera['direfurbolg/direfurbolg']                               = CustomCamera['furbolg/furbolg']
CustomCamera['draeneifemalekid/draeneifemalekid']                     = CustomCamera['humanmalekid/humanmalekid']
CustomCamera['draeneimalekid/draeneimalekid']                         = CustomCamera['humanmalekid/humanmalekid']
CustomCamera['dragonhawk/dragonhawk']                                 = CustomCamera['dragonwhelp/dragonwhelp']
CustomCamera['dragonspawn/dragonspawnarmored']                        = CustomCamera['dragonspawn/dragonspawn']
CustomCamera['dragonspawn/dragonspawngreater']                        = CustomCamera['dragonspawn/dragonspawn']
CustomCamera['dragonspawn/dragonspawnoverlord']                       = CustomCamera['dragonspawn/dragonspawn']
CustomCamera['dragonspawn/dragonspawnoverlordnexus']                  = CustomCamera['dragonspawn/dragonspawn']
CustomCamera['dragonspawncaster/dragonspawncaster']                   = CustomCamera['dragonspawn/dragonspawn']
CustomCamera['dragonspawncasterdarkshade/dragonspawncasterdarkshade'] = CustomCamera['dragonspawn/dragonspawn']
CustomCamera['dragonspawndarkshade/dragonspawndarkshade']             = CustomCamera['dragonspawn/dragonspawn']
CustomCamera['dragonspawnnexus/dragonspawnarmorednexus']              = CustomCamera['dragonspawn/dragonspawn']
CustomCamera['eredar/eredar']                                         = CustomCamera['draenei/male/draeneimale']
CustomCamera['eredarfemale/eredarfemale']                             = CustomCamera['draenei/female/draeneifemale']
CustomCamera['faeriedragon/faeriedragon']                             = CustomCamera['dragonwhelp/dragonwhelp']
CustomCamera['felelfcasterfemale/felelfcasterfemale']                 = CustomCamera['bloodelf/female/bloodelffemale']
CustomCamera['felelfcastermale/felelfcastermale']                     = CustomCamera['bloodelf/male/bloodelfmale']
CustomCamera['felelfhunterfemale/felelfhunterfemale']                 = CustomCamera['bloodelf/female/bloodelffemale']
CustomCamera['felelfwarriormale/felelfwarriormale']                   = CustomCamera['bloodelf/male/bloodelfmale']
CustomCamera['felorc/felorc']                                         = CustomCamera['orc/male/orcmale']
CustomCamera['felorc/felorc_axe']                                     = CustomCamera['orc/male/orcmale']
CustomCamera['felorc/felorc_sword']                                   = CustomCamera['orc/male/orcmale']
CustomCamera['felorc/male/felorcmale']                                = CustomCamera['orc/male/orcmale']
CustomCamera['felorc/male/felorcmaleaxe']                             = CustomCamera['orc/male/orcmale']
CustomCamera['felorc/male/felorcmalesword']                           = CustomCamera['orc/male/orcmale']
CustomCamera['felorcaxe/felorcwarrioraxe']                            = CustomCamera['orc/male/orcmale']
CustomCamera['felorcwarlord/felorcwarlord']                           = CustomCamera['orc/male/orcmale']
CustomCamera['fireelemental/fireelemental']                           = CustomCamera['elementalearth/elementalearth']
CustomCamera['foresttroll/male/foresttrollmale']                      = CustomCamera['troll/male/trollmale']
CustomCamera['frostnymph/frostnymph']                                 = CustomCamera['dryad/dryad']
CustomCamera['frostvrykulmale/frostvrykulmale']                       = CustomCamera['vrykul/male/vrykulmale']
CustomCamera['generic/scourge/sc_eyeofacherus_02']                    = CustomCamera['ghost/ghost']
CustomCamera['gnomespidertank/gnomebot']                              = CustomCamera['gnomespidertank/gnomepounder']
CustomCamera['golemiron/golemiron']                                   = CustomCamera['tuskarrmalefisherman/tuskarrmalefisherman']
CustomCamera['highelf/highelffemale_mage']                            = CustomCamera['highelf/highelffemale_hunter']
CustomCamera['highelf/highelffemale_priest']                          = CustomCamera['highelf/highelffemale_hunter']
CustomCamera['highelf/highelffemale_warrior']                         = CustomCamera['highelf/highelffemale_hunter']
CustomCamera['highelf/highelfmale_mage']                              = CustomCamera['highelf/highelfmale_hunter']
CustomCamera['highelf/highelfmale_priest']                            = CustomCamera['highelf/highelfmale_hunter']
CustomCamera['highelf/highelfmale_warrior']                           = CustomCamera['highelf/highelfmale_hunter']
CustomCamera['humanfemalecaster/humanfemalecaster']                   = CustomCamera['humanfemalefarmer/humanfemalefarmer']
CustomCamera['humanfemalekid/humanfemalekid']                         = CustomCamera['humanmalekid/humanmalekid']
CustomCamera['humanfemalemerchantfat/humanfemalemerchantfat']         = CustomCamera['humanfemalefarmer/humanfemalefarmer']
CustomCamera['humanfemalemerchantthin/humanfemalemerchantthin']       = CustomCamera['humanfemalefarmer/humanfemalefarmer']
CustomCamera['humanfemalepeasant/humanfemalepeasant']                 = CustomCamera['humanfemalefarmer/humanfemalefarmer']
CustomCamera['humanfemalewarriorheavy/humanfemalewarriorheavy']       = CustomCamera['humanfemalefarmer/humanfemalefarmer']
CustomCamera['humanfemalewarriorlight/humanfemalewarriorlight']       = CustomCamera['humanfemalefarmer/humanfemalefarmer']
CustomCamera['humanmalecaster/humanmalecaster']                       = CustomCamera['humanfemalefarmer/humanfemalefarmer']
CustomCamera['humanmalemarshal/humanmalemarshal']                     = CustomCamera['humlblacksmith/humlblacksmith']
CustomCamera['humanmalenoble/humanmalenoble']                         = CustomCamera['humlblacksmith/humlblacksmith']
CustomCamera['humanmalepiratecaptain/humanmalepiratecaptain']         = CustomCamera['human/male/humanmale']
CustomCamera['humanmalepiratecrewman/humanmalepiratecrewman']         = CustomCamera['humlblacksmith/humlblacksmith']
CustomCamera['humanmalewarriorheavy/humanmalewarriorheavy']           = CustomCamera['humlblacksmith/humlblacksmith']
CustomCamera['humanmalewarriorlight/humanmalewarriorlight']           = CustomCamera['humlblacksmith/humlblacksmith']
CustomCamera['humanmalewarriormedium/humanmalewarriormedium']         = CustomCamera['humlblacksmith/humlblacksmith']
CustomCamera['humlmagicsmith/humlmagicsmith']                         = CustomCamera['miev/miev']
CustomCamera['humlmerchant/humlmerchant']                             = CustomCamera['humlblacksmith/humlblacksmith']
CustomCamera['humscitizenmid/humscitizenmid']                         = CustomCamera['humlblacksmith/humlblacksmith']
CustomCamera['icetroll/male/icetrollmale']                            = CustomCamera['troll/male/trollmale']
CustomCamera['illidan/illidandark']                                   = CustomCamera['illidan/illidan']
CustomCamera['interface/buttons/talktomequestion_grey']               = CustomCamera['interface/buttons/talktome']
CustomCamera['interface/buttons/talktomequestion_white']              = CustomCamera['interface/buttons/talktome']
CustomCamera['interface/buttons/talktomequestionmark']                = CustomCamera['interface/buttons/talktome']
CustomCamera['irondwarf/irondwarf']                                   = CustomCamera['earthendwarf/earthendwarf']
CustomCamera['ironvrykulmale/ironvrykulmale']                         = CustomCamera['vrykul/male/vrykulmale']
CustomCamera['jaina/jaina']                                           = CustomCamera['human/female/humanfemale']
CustomCamera['kaelthas/kaelthas']                                     = CustomCamera['bloodelf/male/bloodelfmale']
CustomCamera['kaelthas_broken/kaelthasbroken']                        = CustomCamera['bloodelf/male/bloodelfmale']
CustomCamera['kalecgos/kalecgos']                                     = CustomCamera['human/male/humanmale']
CustomCamera['kargath/kargath']                                       = CustomCamera['orc/male/orcmale']
CustomCamera['kingvarianwrynn/kingvarianwrynn']                       = CustomCamera['human/male/humanmale']
CustomCamera['kingymiron/kingymiron']                                 = CustomCamera['vrykul/male/vrykulmale']
CustomCamera['kobold/kobold']                                         = CustomCamera['murloc/murloc']
CustomCamera['ladysylvanaswindrunner/ladysylvanaswindrunner']         = CustomCamera['bloodelf/female/bloodelffemale']
CustomCamera['ladyvashj/ladyvashj']                                   = CustomCamera['naga_/female/naga_female']
CustomCamera['madscientist/madscientist']                             = CustomCamera['scourge/male/scourgemale']
CustomCamera['medivh/medivh']                                         = CustomCamera['nightelf/male/nightelfmale']
CustomCamera['mounteddeathknight/mounteddeathknight_blaumeux']        = CustomCamera['gnomespidertank/gnomepounder']
CustomCamera['mounteddeathknight/unmounteddeathknight']               = CustomCamera['human/male/humanmale']
CustomCamera['nagamale/nagamale']                                     = CustomCamera['naga_/male/naga_male']
CustomCamera['necromancer/necromancer']                               = CustomCamera['human/male/humanmale']
CustomCamera['nerubianwarrior/nerubianwarrior']                       = CustomCamera['fleshgolem/fleshgolem']
CustomCamera['northrendicegiant/northrendicegiant']                   = CustomCamera['northrendgiant/gymer']
CustomCamera['ogre/ogremage']                                         = CustomCamera['ogre/ogre']
CustomCamera['ogre/ogrewarlord']                                      = CustomCamera['ogre/ogre']
CustomCamera['ogre02/ogre02']                                         = CustomCamera['ogre/ogre']
CustomCamera['ogreking/ogreking']                                     = CustomCamera['ogre/ogre']
CustomCamera['ogremage02/ogremage02']                                 = CustomCamera['ogre/ogre']
CustomCamera['ogremagelord/ogremagelord']                             = CustomCamera['ogre/ogre']
CustomCamera['orcfemalekid/orcfemalekid']                             = CustomCamera['humanmalekid/humanmalekid']
CustomCamera['orcmalekid/orcmalekid']                                 = CustomCamera['humanmalekid/humanmalekid']
CustomCamera['orcmalemerchantlight/orcmalemerchantlight']             = CustomCamera['orc/male/orcmale']
CustomCamera['orcmalewarriorlight/orcmalewarriorlight']               = CustomCamera['orc/male/orcmale']
CustomCamera['rat/rat']                                               = CustomCamera['chicken/chicken']
CustomCamera['rexxar/rexxar']                                         = CustomCamera['orc/male/orcmale']
CustomCamera['seavrykulmale/seavrykulmale']                           = CustomCamera['vrykul/male/vrykulmale']
CustomCamera['seavrykulmale/seavrykulmale_a']                         = CustomCamera['vrykul/male/vrykulmale']
CustomCamera['skeleton/male/skeletonmale']                            = CustomCamera['scourge/male/scourgemale']
CustomCamera['squirrel/squirrel']                                     = CustomCamera['chicken/chicken']
CustomCamera['talktome_chat']                                         = CustomCamera['interface/buttons/talktome']
CustomCamera['taunka/male/taunkamale']                                = CustomCamera['tauren/male/taurenmale']
CustomCamera['terongorefiend/terongorefiend']                         = CustomCamera['human/male/humanmale']
CustomCamera['thorum/thorum']                                         = CustomCamera['stonekeeper/stonekeeper']
CustomCamera['titanfemale/titanfemale']                               = CustomCamera['freia/freia']
CustomCamera['undeadicetroll/undeadicetroll']                         = CustomCamera['troll/male/trollmale']
CustomCamera['valkier/valkier']                                       = CustomCamera['vrykulfemale/femalevrykulboss']
CustomCamera['valkierdark/valkierdark']                               = CustomCamera['vrykulfemale/femalevrykulboss']
CustomCamera['velen/velen']                                           = CustomCamera['draenei/male/draeneimale']
CustomCamera['voidlord/voidlord']                                     = CustomCamera['voidcaller/voidcaller']
CustomCamera['vrykulfemale/frostvrykulfemalecaster']                  = CustomCamera['vrykulfemale/femalevrykulboss']
CustomCamera['vrykulfemale/frostvrykulfemaledruid']                   = CustomCamera['vrykulfemale/femalevrykulboss']
CustomCamera['vrykulfemale/frostvrykulfemalehunter']                  = CustomCamera['vrykulfemale/femalevrykulboss']
CustomCamera['vrykulfemale/frostvrykulfemalewarrior']                 = CustomCamera['vrykulfemale/femalevrykulboss']
CustomCamera['vrykulfemale/vrykulfemale']                             = CustomCamera['vrykulfemale/femalevrykulboss']
CustomCamera['vrykulfemale/vrykulfemalecaster']                       = CustomCamera['vrykulfemale/femalevrykulboss']
CustomCamera['vrykulfemale/vrykulfemaledruid']                        = CustomCamera['vrykulfemale/femalevrykulboss']
CustomCamera['vrykulfemale/vrykulfemalehunter']                       = CustomCamera['vrykulfemale/femalevrykulboss']
CustomCamera['vrykulfemale/vrykulfemalewarrior']                      = CustomCamera['vrykulfemale/femalevrykulboss']
CustomCamera['wolvar/wolvar']                                         = CustomCamera['furbolg/furbolg']
---@enum HD models<table>
local CustomHDCamera = EnumConst.UiModelPositionCamera['HD']
CustomHDCamera['alleria/alleria']                                     = CustomCamera['bloodelf/female/bloodelffemale']
CustomHDCamera['ancientofwar2/ancientofwar2']                         = CustomHDCamera['ancientoflore2/ancientoflore2']
CustomHDCamera['ancientofwar2diseased/ancientofwar2diseased']         = CustomHDCamera['ancientoflore2/ancientoflore2']
CustomHDCamera['anduin2/anduin2']                                     = CustomHDCamera['human/male/humanmale']
CustomHDCamera['arakkoa2/arakkoa2']                                   = CustomCamera['arakkoa/arakkoa']
CustomHDCamera['arakkoaoutland/arakkoaoutland']                       = CustomCamera['arakkoa/arakkoa']
CustomHDCamera['arcanegolem/arcanegolembroken']                       = CustomHDCamera['arcanegolem/arcanegolem']
CustomHDCamera['banshee/banshee']                                     = CustomHDCamera['ghost/ghost']
CustomHDCamera['black_keeper/black_keeper']                           = CustomHDCamera['human/male/humanmale']
CustomHDCamera['bloodelf_female_magich/bloodelf_female_magich']       = CustomCamera['bloodelf/female/bloodelffemale']
CustomHDCamera['bloodelf_guard/bloodelfmale_hd']                      = CustomCamera['bloodelf/male/bloodelfmale']
CustomHDCamera['bloodtrollfemale_caster/bloodtrollfemale_caster']     = CustomHDCamera['troll/female/trollfemale']
CustomHDCamera['centaur2_female/centaur2_female_hunter']              = CustomHDCamera['centaur2_female/centaur2_female']
CustomHDCamera['chromie/chromie']                                     = CustomCamera['gnome/female/gnomefemale']
CustomHDCamera['crackelf/crackelfmale']                               = CustomCamera['bloodelf/male/bloodelfmale']
CustomHDCamera['customcharacters/emelia/emelia_hood']                 = CustomCamera['bloodelf/female/bloodelffemale']
CustomHDCamera['customcharacters/engelarder/engelarder_deathknight']  = CustomHDCamera['human/male/humanmale']
CustomHDCamera['customcharacters/heyngwood/heyngwood_neutral']        = CustomHDCamera['human/male/humanmale']
CustomHDCamera['customcharacters/hordin/hordin']                      = CustomHDCamera['human/male/humanmale']
CustomHDCamera['customcharacters/langrimath/langrimath']              = CustomHDCamera['human/male/humanmale']
CustomHDCamera['customcreature_hd/spectralwizard/spectralwizard']     = CustomHDCamera['lich2/lich2']
CustomHDCamera['customcreature_hd/undeadarmy/skeletonwarriorhd']      = CustomHDCamera['human/male/humanmale']
CustomHDCamera['darnavan/darnavan']                                   = CustomHDCamera['human/male/humanmale']
CustomHDCamera['dragon/northrenddragon']                              = CustomCamera['malygos/malygos']
CustomHDCamera['dragonspawn2/dragonspawnoverlord2']                   = CustomHDCamera['dragonspawn2_female/dragonspawn2_female']
CustomHDCamera['dragonspawn2/dragonspawnoverlord3']                   = CustomHDCamera['dragonspawn2_female/dragonspawn2_female']
CustomHDCamera['dragonspawn2/dragonspawnoverlord4']                   = CustomHDCamera['dragonspawn2_female/dragonspawn2_female']
CustomHDCamera['dragonspawn2/dragonspawnoverlord5']                   = CustomHDCamera['dragonspawn2_female/dragonspawn2_female']
CustomHDCamera['dragonspawn2/dragonspawnoverlord6']                   = CustomHDCamera['dragonspawn2_female/dragonspawn2_female']
CustomHDCamera['dragonspawn2/dragonspawnoverlord7']                   = CustomHDCamera['dragonspawn2_female/dragonspawn2_female']
CustomHDCamera['dragonspawn2/dragonspawnoverlord8']                   = CustomHDCamera['dragonspawn2_female/dragonspawn2_female']
CustomHDCamera['dragonspawn2/dragonspawnoverlord9']                   = CustomHDCamera['dragonspawn2_female/dragonspawn2_female']
CustomHDCamera['dreadlordshadowlands/dreadlordshadowlands']           = CustomCamera['dreadlord/dreadlord']
CustomHDCamera['druid_ccl/druid_night_elffemale_1']                   = CustomCamera['nightelf/female/nightelffemale']
CustomHDCamera['dwarf_guard/dwarf_guard']                             = CustomHDCamera['dwarf/male/dwarfmale']
CustomHDCamera['eredar/eredar']                                       = CustomHDCamera['draenei/male/draeneimale']
CustomHDCamera['eredarfemale2/draeneifemale_hd']                      = CustomCamera['draenei/female/draeneifemale']
CustomHDCamera['faeriedragon/faeriedragon']                           = CustomHDCamera['dragonwhelp/dragonwhelp']
CustomHDCamera['felbroken/felbroken']                                 = CustomHDCamera['draenei/male/draeneimale']
CustomHDCamera['felbroken_akama/felbroken_akama']                     = CustomHDCamera['draenei/male/draeneimale']
CustomHDCamera['felbroken_hair/felbroken_hair']                       = CustomHDCamera['draenei/male/draeneimale']
CustomHDCamera['felbroken_helm/felbroken_helm']                       = CustomHDCamera['draenei/male/draeneimale']
CustomHDCamera['felbroken_helm2/felbroken_helm2']                     = CustomHDCamera['draenei/male/draeneimale']
CustomHDCamera['felbroken_hunter/felbroken_hunter']                   = CustomHDCamera['draenei/male/draeneimale']
CustomHDCamera['felbroken_mage/felbroken_mage']                       = CustomHDCamera['draenei/male/draeneimale']
CustomHDCamera['felbroken_mystic/felbroken_mystic']                   = CustomHDCamera['draenei/male/draeneimale']
CustomHDCamera['felbroken_shaman/felbroken_shaman']                   = CustomHDCamera['draenei/male/draeneimale']
CustomHDCamera['felelfhunterfemale2/bloodelffemale_hd']               = CustomCamera['bloodelf/female/bloodelffemale']
CustomHDCamera['felorcboss/felorcwarriorboss']                        = CustomCamera['orc/male/orcmale']
CustomHDCamera['felorcbrute/felorcbruteboss']                         = CustomCamera['orc/male/orcmale']
CustomHDCamera['felorcmalehd/felorcjubei_baked']                      = CustomCamera['orc/male/orcmale']
CustomHDCamera['felorcmalehd/felorcmalehd']                           = CustomCamera['orc/male/orcmale']
CustomHDCamera['felorcmalehd_batle/felorcmalehd_batle']               = CustomCamera['orc/male/orcmale']
CustomHDCamera['felorcmalehd_caster/felorcmalehd_caster']             = CustomCamera['orc/male/orcmale']
CustomHDCamera['felorcmalehd_caster2/felorcmalehd_caster2']           = CustomCamera['orc/male/orcmale']
CustomHDCamera['felorcmalehd_noarmor/felorcmalehd_noarmor']           = CustomCamera['orc/male/orcmale']
CustomHDCamera['felorcmalehd_noarmor2/felorcmalehd_noarmor2']         = CustomCamera['orc/male/orcmale']
CustomHDCamera['felorcmalehd_rarnik/felorcmalehd_rarnik']             = CustomCamera['orc/male/orcmale']
CustomHDCamera['felorcmalehd_shield/felorcmalehd_shield']             = CustomCamera['orc/male/orcmale']
CustomHDCamera['felorcmalehd_watcher/felorcmalehd_watcher']           = CustomCamera['orc/male/orcmale']
CustomHDCamera['felorcmalehd_watcher2/felorcmalehd_watcher2']         = CustomCamera['orc/male/orcmale']
CustomHDCamera['fireelemental/fireelemental']                         = CustomCamera['voidcaller/voidcaller']
CustomHDCamera['foresttrollcouncilor/foresttrollcouncilor']           = CustomHDCamera['troll/male/trollmale']
CustomHDCamera['foresttrollcouncilor/foresttrollcouncilor_1']         = CustomHDCamera['troll/male/trollmale']
CustomHDCamera['generic/scourge/sc_eyeofacherus_02']                  = CustomHDCamera['ghost/ghost']
CustomHDCamera['ghost2/ghost2']                                       = CustomHDCamera['ghost/ghost']
CustomHDCamera['grandmagistrixelisande/grandmagistrixelisande']       = CustomCamera['bloodelf/female/bloodelffemale']
CustomHDCamera['grommash2/grommash2']                                 = CustomCamera['orc/male/orcmale']
CustomHDCamera['hulkedguldan/hulkedguldan']                           = CustomCamera['orc/male/orcmale']
CustomHDCamera['human_guard_elit/human_guard_elit']                   = CustomHDCamera['human/male/humanmale']
CustomHDCamera['humanmalekid/argentsquirehumanmalekid']               = CustomCamera['goblin/male/goblinmale']
CustomHDCamera['igc_yseravisage/igc_yseravisage']                     = CustomCamera['nightelf/female/nightelffemale']
CustomHDCamera['illidandark2/illidandark2']                           = CustomCamera['illidan/illidan']
CustomHDCamera['jaina/jaina']                                         = CustomHDCamera['human/female/humanfemale']
CustomHDCamera['kaelthasshadowlands/kaelthasshadowlands']             = CustomCamera['bloodelf/male/bloodelfmale']
CustomHDCamera['kalecgos2/kalecgos2']                                 = CustomHDCamera['human/male/humanmale']
CustomHDCamera['kargathbladefist/kargathbladefist']                   = CustomCamera['orc/male/orcmale']
CustomHDCamera['kelthuzadshadowlands/kelthuzadshadowlands']           = CustomHDCamera['lich2/lich2']
CustomHDCamera['khadgar2/khadgar2']                                   = CustomHDCamera['human/male/humanmale']
CustomHDCamera['kultiran/female/kultiranfemale']                      = CustomHDCamera['troll/female/trollfemale']
CustomHDCamera['kvaldir/kvaldir']                                     = CustomCamera['vrykul/male/vrykulmale']
CustomHDCamera['kyrianmaw/kyrianmaw']                                 = CustomCamera['vrykulfemale/femalevrykulboss']
CustomHDCamera['ladyalexstrasza/ladyalexstrasza']                     = CustomCamera['bloodelf/female/bloodelffemale']
CustomHDCamera['lightforgeddraenei/female/lightforgeddraeneifemale']  = CustomCamera['draenei/female/draeneifemale']
CustomHDCamera['lightforgeddraenei/male/lightforgeddraeneimale']      = CustomHDCamera['draenei/male/draeneimale']
CustomHDCamera['lightforgedfemale_megalow/lightforgedfemale_megalow'] = CustomCamera['draenei/female/draeneifemale']
CustomHDCamera['lightforgedmale_megalow/lightforgedmale_megalow']     = CustomHDCamera['draenei/male/draeneimale']
CustomHDCamera['lorthemar/lorthemar']                                 = CustomCamera['bloodelf/male/bloodelfmale']
CustomHDCamera['madscientist2/madscientist2']                         = CustomCamera['scourge/male/scourgemale']
CustomHDCamera['maghar_female/maghar_female_1']                       = CustomCamera['orc/female/orcfemale']
CustomHDCamera['maghar_female/maghar_female_2']                       = CustomCamera['orc/female/orcfemale']
CustomHDCamera['maghar_male/maghar_male_1']                           = CustomCamera['orc/male/orcmale']
CustomHDCamera['maghar_male/maghar_male_2']                           = CustomCamera['orc/male/orcmale']
CustomHDCamera['maghar_male/maghar_male_3']                           = CustomCamera['orc/male/orcmale']
CustomHDCamera['maghar_male/maghar_male_4']                           = CustomCamera['orc/male/orcmale']
CustomHDCamera['maghar_male/maghar_male_5']                           = CustomCamera['orc/male/orcmale']
CustomHDCamera['maghar_male/maghar_male_6']                           = CustomCamera['orc/male/orcmale']
CustomHDCamera['maldraxxusmutant/maldraxxusmutant']                   = CustomHDCamera['varimathras/varimathras']
CustomHDCamera['maldraxxusskeleton/maldraxxusskeleton']               = CustomHDCamera['kultiran/male/kultiranmale']
CustomHDCamera['maldraxxusskeleton/maldraxxusskeleton2']              = CustomHDCamera['kultiran/male/kultiranmale']
CustomHDCamera['maldraxxusskeleton/maldraxxusskeleton3']              = CustomHDCamera['kultiran/male/kultiranmale']
CustomHDCamera['maldraxxusskeleton/maldraxxusskeleton4']              = CustomHDCamera['kultiran/male/kultiranmale']
CustomHDCamera['maldraxxusskeleton/maldraxxusskeleton5']              = CustomHDCamera['kultiran/male/kultiranmale']
CustomHDCamera['maldraxxusskeleton/maldraxxusskeleton6']              = CustomHDCamera['kultiran/male/kultiranmale']
CustomHDCamera['maldraxxusskeleton/maldraxxusskeleton7']              = CustomHDCamera['kultiran/male/kultiranmale']
CustomHDCamera['malganis/malganis']                                   = CustomHDCamera['varimathras/varimathras']
CustomHDCamera['medivh/medivh']                                       = CustomHDCamera['human/male/humanmale']
CustomHDCamera['mekkatorque/mekkatorque']                             = CustomCamera['gnome/male/gnomemale']
CustomHDCamera['merithra_night_elf/merithra_night_elf']               = CustomCamera['nightelf/female/nightelffemale']
CustomHDCamera['ministerofdeath/ministerofdeath']                     = CustomCamera['lich/lich']
CustomHDCamera['moarg/moarg1']                                        = CustomCamera['northrendgiant/gymer']
CustomHDCamera['necromancer_custom/necromancer_custom']               = CustomCamera['human/male/humanmale']
CustomHDCamera['nightborneastronomer/nightborneastronomer']           = CustomCamera['bloodelf/male/bloodelfmale']
CustomHDCamera['nightbornefemalecitizen/nightbornefemalecitizen']     = CustomCamera['bloodelf/male/bloodelfmale']
CustomHDCamera['nightbornemalecitizen/nightbornemalecitizen']         = CustomCamera['bloodelf/male/bloodelfmale']
CustomHDCamera['nightfallenmale/nightfallenmale']                     = CustomCamera['bloodelf/male/bloodelfmale']
CustomHDCamera['ogredraenor/ogredraenor']                             = CustomCamera['ogre/ogre']
CustomHDCamera['ogredraenor/ogredraenor2']                            = CustomCamera['ogre/ogre']
CustomHDCamera['ogredraenor/ogredraenor3']                            = CustomCamera['ogre/ogre']
CustomHDCamera['ogredraenor/ogredraenor4']                            = CustomCamera['ogre/ogre']
CustomHDCamera['ogredraenor/ogredraenor5']                            = CustomCamera['ogre/ogre']
CustomHDCamera['ogredraenor/ogredraenor6']                            = CustomCamera['ogre/ogre']
CustomHDCamera['ogredraenor/ogredraenor7']                            = CustomCamera['ogre/ogre']
CustomHDCamera['ogredraenor/ogredraenor8']                            = CustomCamera['ogre/ogre']
CustomHDCamera['pirat_human/pirat_human']                             = CustomHDCamera['human/male/humanmale']
CustomHDCamera['pirat_kultiran_male/kultiranmale']                    = CustomHDCamera['kultiran/male/kultiranmale']
CustomHDCamera['quarter_of_blood/blood_elf_female_1']                 = CustomCamera['bloodelf/female/bloodelffemale']
CustomHDCamera['quarter_of_blood/blood_elf_male_1']                   = CustomCamera['bloodelf/male/bloodelfmale']
CustomHDCamera['sabellian/sabellian']                                 = CustomHDCamera['human/male/humanmale']
CustomHDCamera['saurfang/saurfang']                                   = CustomHDCamera['thrall/thrall']
CustomHDCamera['shatteredhandorcs/shatteredhandcaster']               = CustomCamera['orc/male/orcmale']
CustomHDCamera['shatteredhandorcs/shatteredhandcaster2']              = CustomCamera['orc/male/orcmale']
CustomHDCamera['shatteredhandorcs/shatteredhandmelee']                = CustomCamera['orc/male/orcmale']
CustomHDCamera['shatteredhandorcs/shatteredhandmelee2']               = CustomCamera['orc/male/orcmale']
CustomHDCamera['shatteredhandorcs/shatteredhandmelee2']               = CustomCamera['orc/male/orcmale']
CustomHDCamera['stormforgedvrykul/stormforgedvrykul']                 = CustomCamera['vrykul/male/vrykulmale']
CustomHDCamera['succubus_fel/succubus_fel']                           = CustomHDCamera['dryad/dryad']
CustomHDCamera['thrallshadowlands/thrallshadowlands']                 = CustomHDCamera['thrall/thrall']
CustomHDCamera['titanfemale/titanfemale']                             = CustomHDCamera['freia/freia']
CustomHDCamera['tuskarr/tuskarrmale_hd']                              = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd10']                            = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd11']                            = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd12']                            = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd13']                            = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd14']                            = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd15']                            = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd16']                            = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd17']                            = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd2']                             = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd3']                             = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd4']                             = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd5']                             = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd6']                             = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd7']                             = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd8']                             = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tuskarr/tuskarrmale_hd9']                             = CustomCamera['tuskarr/male/tuskarrmale']
CustomHDCamera['tyrande3/tyrande3']                                   = CustomCamera['nightelf/female/nightelffemale']
CustomHDCamera['unk_exp09_3946582/3946582']                           = CustomCamera['malygos/malygos']
CustomHDCamera['unk_exp09_4327591/4327591']                           = CustomCamera['malygos/malygos']
CustomHDCamera['unk_exp09_4416923/4416923']                           = CustomCamera['malygos/malygos']
CustomHDCamera['unk_exp09_4495214/4495214']                           = CustomCamera['malygos/malygos']
CustomHDCamera['unk_exp09_4496906/4496906']                           = CustomCamera['malygos/malygos']
CustomHDCamera['unk_exp09_4498203/4498203']                           = CustomCamera['malygos/malygos']
CustomHDCamera['unk_exp09_4498270/4498270']                           = CustomCamera['malygos/malygos']
CustomHDCamera['unk_exp09_4500511/4500511_2']                         = CustomCamera['malygos/malygos']
CustomHDCamera['unk_exp09_4519034/4519034']                           = CustomCamera['malygos/malygos']
CustomHDCamera['unk_exp09_4519034/4519034_1']                         = CustomCamera['malygos/malygos']
CustomHDCamera['unk_exp09_4553742/4553742']                           = CustomCamera['malygos/malygos']
CustomHDCamera['unk_exp09_4665405/4665405']                           = CustomCamera['malygos/malygos']
CustomHDCamera['valkierdark/valkierdark']                             = CustomHDCamera['valkier/valkier']
CustomHDCamera['voljin/voljin']                                       = CustomHDCamera['troll/male/trollmale']
CustomHDCamera['vrykulfemale2/vrykulfemale2']                         = CustomCamera['vrykulfemale/femalevrykulboss']
CustomHDCamera['war_commander/war_commander_human']                   = CustomHDCamera['human/male/humanmale']
CustomHDCamera['waterelemental/waterelemental']                       = CustomCamera['elementalearth/elementalearth']


---@enum model index<string, number>
---@type table<number, Enum>
EnumConst.ReplaceTalkAnimation =
{
    [TALKING] = AGREE,
    [TALKING] = ASKING,
    [TALKING] = YELLING,
}

EnumConst.OnlyTalkAnimation =
{
    [AGREE]   = TALKING,
    [ASKING]  = TALKING,
    [YELLING] = TALKING,
}

EnumConst.OnlyIdleAnimation =
{
    [AGREE]   = IDLE,
    [ASKING]  = IDLE,
    [TALKING] = IDLE,
    [YELLING] = IDLE,
}

EnumConst.StandartAnimation =
{
    [AGREE]   = AGREE,
    [ASKING]  = ASKING,
    [TALKING] = TALKING,
    [YELLING] = YELLING,
}


EnumConst.AnimationModelDefect =
{
    ['Original'] = {
        ['alexstrasza/ladyalexstrasa']                      = EnumConst.ReplaceTalkAnimation,
        ['bloodelf/female/bloodelffemale']                  = EnumConst.ReplaceTalkAnimation,
        ['felelfcasterfemale/felelfcasterfemale']           = EnumConst.ReplaceTalkAnimation,
        ['felelfhunterfemale/felelfhunterfemale']           = EnumConst.ReplaceTalkAnimation,
        ['ladysylvanaswindrunner/ladysylvanaswindrunner']   = EnumConst.ReplaceTalkAnimation,
        ['miev/miev']                                       = EnumConst.ReplaceTalkAnimation,
    },
    ['HD'] = {
        ---@enum HD models animations
        ['alleria/alleria']                                 = EnumConst.ReplaceTalkAnimation,
        ['bloodelf_female_magich/bloodelf_female_magich']   = EnumConst.ReplaceTalkAnimation,
        ['customcharacters/emelia/emelia_hood']             = EnumConst.ReplaceTalkAnimation,
        ['felelfhunterfemale2/bloodelffemale_hd']           = EnumConst.ReplaceTalkAnimation,
        ['ladyalexstrasza/ladyalexstrasza']                 = EnumConst.ReplaceTalkAnimation,
        ['necromancer2/necromancer2']                       = EnumConst.ReplaceTalkAnimation,
        ['quarter_of_blood/blood_elf_female_1']             = EnumConst.ReplaceTalkAnimation,
    },
}

---@type table<number, Enum>
EnumConst.AnimationMap =
{
    ['Original'] = {
        ['airelemental/airelemental']                             = EnumConst.OnlyIdleAnimation,
        ['alglontheobserver/algalontheobserver']                  = EnumConst.OnlyTalkAnimation,
        ['ancientoflore/ancientoflore']                           = EnumConst.OnlyIdleAnimation,
        ['ancientofwar/ancientofwar']                             = EnumConst.OnlyIdleAnimation,
        ['ancientprotector/ancientprotector']                     = EnumConst.OnlyIdleAnimation,
        ['anubisath/anubisath']                                   = EnumConst.OnlyIdleAnimation,
        ['arakkoa/arakkoa']                                       = EnumConst.OnlyTalkAnimation,
        ['arakkoa/arakkoa_sage']                                  = EnumConst.OnlyTalkAnimation,
        ['arakkoa/arakkoa_warrior']                               = EnumConst.OnlyTalkAnimation,
        ['arcanegolem/arcanegolem']                               = EnumConst.OnlyTalkAnimation,
        ['arcanegolem/arcanegolembroken']                         = EnumConst.OnlyIdleAnimation,
        ['arcanevoidwraith/arcanevoidwraith']                     = EnumConst.OnlyIdleAnimation,
        ['bloodelffemalekid/bloodelffemalekid']                   = EnumConst.OnlyTalkAnimation,
        ['bloodelfmalekid/bloodelfmalekid']                       = EnumConst.OnlyTalkAnimation,
        ['centaur/centaur']                                       = EnumConst.OnlyTalkAnimation,
        ['centaur/centaurcaster']                                 = EnumConst.OnlyTalkAnimation,
        ['centaur/centaurkhan']                                   = EnumConst.OnlyTalkAnimation,
        ['centaur/centaurwarrior']                                = EnumConst.OnlyTalkAnimation,
        ['chicken/chicken']                                       = EnumConst.OnlyIdleAnimation,
        ['crystaldryad/crystaldryad']                             = EnumConst.OnlyIdleAnimation,
        ['crystalsatyr/crystalsatyr']                             = EnumConst.OnlyIdleAnimation,
        ['direfurbolg/direfurbolg']                               = EnumConst.OnlyTalkAnimation,
        ['draeneifemalekid/draeneifemalekid']                     = EnumConst.OnlyTalkAnimation,
        ['draeneimalekid/draeneimalekid']                         = EnumConst.OnlyTalkAnimation,
        ['dragon/dragon']                                         = EnumConst.OnlyTalkAnimation,
        ['dragon/northrenddragon']                                = EnumConst.OnlyTalkAnimation,
        ['dragonkalecgos/dragonkalecgos']                         = EnumConst.OnlyTalkAnimation,
        ['dragonspawn/dragonspawn']                               = EnumConst.OnlyIdleAnimation,
        ['dragonspawn/dragonspawnarmored']                        = EnumConst.OnlyIdleAnimation,
        ['dragonspawn/dragonspawnarmored']                        = EnumConst.OnlyIdleAnimation,
        ['dragonspawn/dragonspawngreater']                        = EnumConst.OnlyIdleAnimation,
        ['dragonspawn/dragonspawnoverlord']                       = EnumConst.OnlyIdleAnimation,
        ['dragonspawn/dragonspawnoverlord']                       = EnumConst.OnlyIdleAnimation,
        ['dragonspawn/dragonspawnoverlordnexus']                  = EnumConst.OnlyIdleAnimation,
        ['dragonspawncaster/dragonspawncaster']                   = EnumConst.OnlyIdleAnimation,
        ['dragonspawncaster/dragonspawncaster']                   = EnumConst.OnlyIdleAnimation,
        ['dragonspawncasterdarkshade/dragonspawncasterdarkshade'] = EnumConst.OnlyIdleAnimation,
        ['dragonspawndarkshade/dragonspawndarkshade']             = EnumConst.OnlyIdleAnimation,
        ['dragonspawnnexus/dragonspawnarmorednexus']              = EnumConst.OnlyIdleAnimation,
        ['dragonspawnnexus/dragonspawnarmorednexus']              = EnumConst.OnlyIdleAnimation,
        ['dragonwhelp/dragonwhelp']                               = EnumConst.OnlyIdleAnimation,
        ['dreadlord/dreadlord']                                   = EnumConst.OnlyTalkAnimation,
        ['druidbear/druidbeartauren']                             = EnumConst.OnlyIdleAnimation,
        ['druidowlbear/druidowlbear']                             = EnumConst.OnlyTalkAnimation,
        ['dryad/dryad']                                           = EnumConst.OnlyIdleAnimation,
        ['elementalearth/elementalearth']                         = EnumConst.OnlyIdleAnimation,
        ['ent/ent']                                               = EnumConst.OnlyTalkAnimation,
        ['etherial/etherial']                                     = EnumConst.OnlyTalkAnimation,
        ['etherialrobe/etherialrobe']                             = EnumConst.OnlyTalkAnimation,
        ['felorcnetherdrake/felorcnetherdrakemounted']            = EnumConst.OnlyTalkAnimation,
        ['fireelemental/fireelemental']                           = EnumConst.OnlyIdleAnimation,
        ['fleshgolem/fleshgolem']                                 = EnumConst.OnlyIdleAnimation,
        ['forceofnature/forceofnature']                           = EnumConst.OnlyIdleAnimation,
        ['freia/freia']                                           = EnumConst.OnlyIdleAnimation,
        ['frostnymph/frostnymph']                                 = EnumConst.OnlyIdleAnimation,
        ['frostvrykulmale/frostvrykulmale']                       = EnumConst.OnlyTalkAnimation,
        ['furbolg/furbolg']                                       = EnumConst.OnlyTalkAnimation,
        ['ghost/ghost']                                           = EnumConst.OnlyIdleAnimation,
        ['ghoul/ghoul']                                           = EnumConst.OnlyTalkAnimation,
        ['gnomespidertank/gnomealertbot']                         = EnumConst.OnlyIdleAnimation,
        ['gnomespidertank/gnomebot']                              = EnumConst.OnlyIdleAnimation,
        ['gnomespidertank/gnomepounder']                          = EnumConst.OnlyIdleAnimation,
        ['gnomespidertank/gnomepoundervehicle']                   = EnumConst.OnlyIdleAnimation,
        ['gnomespidertank/gnomespidertank']                       = EnumConst.OnlyIdleAnimation,
        ['golemdwarven/golemdwarven']                             = EnumConst.OnlyTalkAnimation,
        ['golemiron/golemiron']                                   = EnumConst.OnlyTalkAnimation,
        ['highelf/highelffemale_hunter']                          = EnumConst.OnlyTalkAnimation,
        ['highelf/highelffemale_mage']                            = EnumConst.OnlyTalkAnimation,
        ['highelf/highelffemale_priest']                          = EnumConst.OnlyTalkAnimation,
        ['highelf/highelffemale_warrior']                         = EnumConst.OnlyTalkAnimation,
        ['highelf/highelfmale_hunter']                            = EnumConst.OnlyTalkAnimation,
        ['highelf/highelfmale_mage']                              = EnumConst.OnlyTalkAnimation,
        ['highelf/highelfmale_priest']                            = EnumConst.OnlyTalkAnimation,
        ['highelf/highelfmale_warrior']                           = EnumConst.OnlyTalkAnimation,
        ['hodir/hodir']                                           = EnumConst.OnlyIdleAnimation,
        ['humanfemalecaster/humanfemalecaster']                   = EnumConst.OnlyTalkAnimation,
        ['humanfemalefarmer/humanfemalefarmer']                   = EnumConst.OnlyTalkAnimation,
        ['humanfemalekid/humanfemalekid']                         = EnumConst.OnlyTalkAnimation,
        ['humanfemalemerchantfat/humanfemalemerchantfat']         = EnumConst.OnlyTalkAnimation,
        ['humanfemalemerchantthin/humanfemalemerchantthin']       = EnumConst.OnlyTalkAnimation,
        ['humanfemalepeasant/humanfemalepeasant']                 = EnumConst.OnlyTalkAnimation,
        ['humanfemalewarriorheavy/humanfemalewarriorheavy']       = EnumConst.OnlyTalkAnimation,
        ['humanfemalewarriorlight/humanfemalewarriorlight']       = EnumConst.OnlyTalkAnimation,
        ['humanmalecaster/humanmalecaster']                       = EnumConst.OnlyTalkAnimation,
        ['humanmalekid/humanmalekid']                             = EnumConst.OnlyTalkAnimation,
        ['humanmalemarshal/humanmalemarshal']                     = EnumConst.OnlyIdleAnimation,
        ['humanmalenoble/humanmalenoble']                         = EnumConst.OnlyTalkAnimation,
        ['humanmalepeasant/humanmalepeasantwood']                 = EnumConst.OnlyIdleAnimation,
        ['humanmalepiratecrewman/humanmalepiratecrewman']         = EnumConst.OnlyTalkAnimation,
        ['humanmalewarriorheavy/humanmalewarriorheavy']           = EnumConst.OnlyTalkAnimation,
        ['humanmalewarriorlight/humanmalewarriorlight']           = EnumConst.OnlyTalkAnimation,
        ['humanmalewarriormedium/humanmalewarriormedium']         = EnumConst.OnlyTalkAnimation,
        ['humlblacksmith/humlblacksmith']                         = EnumConst.OnlyIdleAnimation,
        ['humlmagicsmith/humlmagicsmith']                         = EnumConst.OnlyIdleAnimation,
        ['humlmerchant/humlmerchant']                             = EnumConst.OnlyIdleAnimation,
        ['humscitizenmid/humscitizenmid']                         = EnumConst.OnlyIdleAnimation,
        ['illidan/illidan']                                       = EnumConst.OnlyTalkAnimation,
        ['illidan/illidandark']                                   = EnumConst.OnlyTalkAnimation,
        ['ironvrykulmale/ironvrykulmale']                         = EnumConst.OnlyTalkAnimation,
        ['keeperofthegrove/keeperofthegrove']                     = EnumConst.OnlyIdleAnimation,
        ['kelthuzad/kelthuzad']                                   = EnumConst.OnlyTalkAnimation,
        ['kobold/kobold']                                         = EnumConst.OnlyIdleAnimation,
        ['ladyvashj/ladyvashj']                                   = EnumConst.OnlyTalkAnimation,
        ['lich/lich']                                             = EnumConst.OnlyTalkAnimation,
        ['lostone/lostone']                                       = EnumConst.OnlyIdleAnimation,
        ['magnataur/magnataur']                                   = EnumConst.OnlyTalkAnimation,
        ['malganis/malganis']                                     = EnumConst.OnlyTalkAnimation,
        ['moarg/moarg1']                                          = EnumConst.OnlyTalkAnimation,
        ['moarg/moarg2']                                          = EnumConst.OnlyTalkAnimation,
        ['mounteddeathknight/mounteddeathknight_blaumeux']        = EnumConst.OnlyIdleAnimation,
        ['murloc/murloc']                                         = EnumConst.OnlyIdleAnimation,
        ['murloccostume/murloccostume']                           = EnumConst.StandartAnimation,
        ['naga_/female/naga_female']                              = EnumConst.OnlyTalkAnimation,
        ['naga_/male/naga_male']                                  = EnumConst.OnlyTalkAnimation,
        ['nagamale/nagamale']                                     = EnumConst.OnlyTalkAnimation,
        ['nerubianwarrior/nerubianwarrior']                       = EnumConst.OnlyTalkAnimation,
        ['northrendghoul/morthrendghoulspiked']                   = EnumConst.OnlyTalkAnimation,
        ['northrendghoul/northrendghoul']                         = EnumConst.OnlyTalkAnimation,
        ['northrendgiant/gymer']                                  = EnumConst.OnlyTalkAnimation,
        ['northrendgiant/northrendgiant']                         = EnumConst.OnlyTalkAnimation,
        ['northrendicegiant/northrendicegiant']                   = EnumConst.OnlyTalkAnimation,
        ['northrendskeleton/male/northrendskeletonmale']          = EnumConst.OnlyTalkAnimation,
        ['northrendworgen/northrendworgen']                       = EnumConst.OnlyTalkAnimation,
        ['ogre/ogre']                                             = EnumConst.OnlyTalkAnimation,
        ['ogre/ogremage']                                         = EnumConst.OnlyTalkAnimation,
        ['ogre/ogrewarlord']                                      = EnumConst.OnlyTalkAnimation,
        ['ogre02/ogre02']                                         = EnumConst.OnlyTalkAnimation,
        ['ogreking/ogreking']                                     = EnumConst.OnlyTalkAnimation,
        ['ogremage02/ogremage02']                                 = EnumConst.OnlyTalkAnimation,
        ['ogremagelord/ogremagelord']                             = EnumConst.OnlyTalkAnimation,
        ['orcfemalekid/orcfemalekid']                             = EnumConst.OnlyTalkAnimation,
        ['orcmalekid/orcmalekid']                                 = EnumConst.OnlyTalkAnimation,
        ['orcmalemerchantlight/orcmalemerchantlight']             = EnumConst.OnlyIdleAnimation,
        ['orcmalewarriorlight/orcmalewarriorlight']               = EnumConst.OnlyIdleAnimation,
        ['rat/rat']                                               = EnumConst.OnlyIdleAnimation,
        ['revenantair/revenantair']                               = EnumConst.OnlyIdleAnimation,
        ['revenantearth/revenantearth']                           = EnumConst.OnlyIdleAnimation,
        ['revenantfire/revenantfire']                             = EnumConst.OnlyIdleAnimation,
        ['revenantwater/revenantwater']                           = EnumConst.OnlyIdleAnimation,
        ['satyr/satyr']                                           = EnumConst.OnlyIdleAnimation,
        ['seaturtle/seaturtle']                                   = EnumConst.OnlyIdleAnimation,
        ['seavrykulmale/seavrykulmale']                           = EnumConst.OnlyTalkAnimation,
        ['seavrykulmale/seavrykulmale_a']                         = EnumConst.OnlyTalkAnimation,
        ['squirrel/squirrel']                                     = EnumConst.OnlyIdleAnimation,
        ['stonekeeper/stonekeeper']                               = EnumConst.OnlyIdleAnimation,
        ['thorum/thorum']                                         = EnumConst.OnlyIdleAnimation,
        ['titanfemale/titanfemale']                               = EnumConst.OnlyIdleAnimation,
        ['titanmale/titanmale']                                   = EnumConst.OnlyIdleAnimation,
        ['tuskarr/male/tuskarrmale']                              = EnumConst.OnlyTalkAnimation,
        ['tuskarrmalefisherman/tuskarrmalefisherman']             = EnumConst.OnlyIdleAnimation,
        ['ulduar/ul_planet_azeroth_nobase']                       = EnumConst.OnlyIdleAnimation,
        ['valkier/valkier']                                       = EnumConst.OnlyTalkAnimation,
        ['valkierdark/valkierdark']                               = EnumConst.OnlyTalkAnimation,
        ['voidcaller/voidcaller']                                 = EnumConst.OnlyIdleAnimation,
        ['voidlord/voidlord']                                     = EnumConst.OnlyIdleAnimation,
        ['vrykul/male/vrykulmale']                                = EnumConst.OnlyTalkAnimation,
        ['vrykulfemale/femalevrykulboss']                         = EnumConst.OnlyTalkAnimation,
        ['vrykulfemale/frostvrykulfemalecaster']                  = EnumConst.OnlyTalkAnimation,
        ['vrykulfemale/frostvrykulfemaledruid']                   = EnumConst.OnlyTalkAnimation,
        ['vrykulfemale/frostvrykulfemalehunter']                  = EnumConst.OnlyTalkAnimation,
        ['vrykulfemale/frostvrykulfemalewarrior']                 = EnumConst.OnlyTalkAnimation,
        ['vrykulfemale/vrykulfemale']                             = EnumConst.OnlyTalkAnimation,
        ['vrykulfemale/vrykulfemalecaster']                       = EnumConst.OnlyTalkAnimation,
        ['vrykulfemale/vrykulfemaledruid']                        = EnumConst.OnlyTalkAnimation,
        ['vrykulfemale/vrykulfemalehunter']                       = EnumConst.OnlyTalkAnimation,
        ['vrykulfemale/vrykulfemalewarrior']                      = EnumConst.OnlyTalkAnimation,
        ['waterelemental/waterelemental']                         = EnumConst.OnlyIdleAnimation,
        ['wolvar/wolvar']                                         = EnumConst.OnlyTalkAnimation,
        ['yeti/yeti']                                             = EnumConst.OnlyTalkAnimation,
        ['zombiefiedvrykul/zombiefiedvrykul']                     = EnumConst.OnlyTalkAnimation,
    },
    ['HD'] = {
        ---@enum HD models animation
        ['ancientoflore2/ancientoflore2']                         = EnumConst.OnlyIdleAnimation,
        ['ancientofwar2/ancientofwar2']                           = EnumConst.OnlyIdleAnimation,
        ['ancientofwar2diseased/ancientofwar2diseased']           = EnumConst.OnlyIdleAnimation,
        ['arakkoa2/arakkoa2']                                     = EnumConst.OnlyTalkAnimation,
        ['arakkoaoutland/arakkoaoutland']                         = EnumConst.OnlyTalkAnimation,
        ['arcanegolem/arcanegolem']                               = EnumConst.OnlyIdleAnimation,
        ['ashvampire/ashvampire']                                 = EnumConst.OnlyTalkAnimation,
        ['centaur2/centaur2']                                     = EnumConst.OnlyTalkAnimation,
        ['centaur2_female/centaur2_female']                       = EnumConst.OnlyTalkAnimation,
        ['centaur2_female/centaur2_female_hunter']                = EnumConst.OnlyTalkAnimation,
        ['customcreature_hd/spectralwizard/spectralwizard']       = EnumConst.OnlyTalkAnimation,
        ['dragonspawn2/dragonspawnoverlord2']                     = EnumConst.OnlyTalkAnimation,
        ['dragonspawn2/dragonspawnoverlord3']                     = EnumConst.OnlyTalkAnimation,
        ['dragonspawn2/dragonspawnoverlord4']                     = EnumConst.OnlyTalkAnimation,
        ['dragonspawn2/dragonspawnoverlord5']                     = EnumConst.OnlyTalkAnimation,
        ['dragonspawn2/dragonspawnoverlord6']                     = EnumConst.OnlyTalkAnimation,
        ['dragonspawn2/dragonspawnoverlord7']                     = EnumConst.OnlyTalkAnimation,
        ['dragonspawn2/dragonspawnoverlord7']                     = EnumConst.OnlyTalkAnimation,
        ['dragonspawn2/dragonspawnoverlord8']                     = EnumConst.OnlyTalkAnimation,
        ['dragonspawn2/dragonspawnoverlord9']                     = EnumConst.OnlyTalkAnimation,
        ['dragonspawn2_female/dragonspawn2_female']               = EnumConst.OnlyTalkAnimation,
        ['ent2/ent2']                                             = EnumConst.OnlyTalkAnimation,
        ['fleshgolem/fleshgolem']                                 = EnumConst.StandartAnimation,
        ['ghost2/ghost2']                                         = EnumConst.OnlyIdleAnimation,
        ['grandmagistrixelisande/grandmagistrixelisande']         = EnumConst.OnlyIdleAnimation,
        ['humanmalekid/argentsquirehumanmalekid']                 = EnumConst.OnlyTalkAnimation,
        ['kelthuzadshadowlands/kelthuzadshadowlands']             = EnumConst.OnlyTalkAnimation,
        ['kultiran/female/kultiranfemale']                        = EnumConst.OnlyIdleAnimation,
        ['kultiran/male/kultiranmale']                            = EnumConst.OnlyTalkAnimation,
        ['kvaldir/kvaldir']                                       = EnumConst.OnlyTalkAnimation,
        ['lich2/lich2']                                           = EnumConst.OnlyTalkAnimation,
        ['maldraxxusskeleton/maldraxxusskeleton']                 = EnumConst.OnlyTalkAnimation,
        ['maldraxxusskeleton/maldraxxusskeleton2']                = EnumConst.OnlyTalkAnimation,
        ['maldraxxusskeleton/maldraxxusskeleton3']                = EnumConst.OnlyTalkAnimation,
        ['maldraxxusskeleton/maldraxxusskeleton4']                = EnumConst.OnlyTalkAnimation,
        ['maldraxxusskeleton/maldraxxusskeleton5']                = EnumConst.OnlyTalkAnimation,
        ['maldraxxusskeleton/maldraxxusskeleton6']                = EnumConst.OnlyTalkAnimation,
        ['maldraxxusskeleton/maldraxxusskeleton7']                = EnumConst.OnlyTalkAnimation,
        ['ministerofdeath/ministerofdeath']                       = EnumConst.OnlyTalkAnimation,
        ['nightfallenmale/nightfallenmale']                       = EnumConst.OnlyTalkAnimation,
        ['ogredraenor/ogredraenor']                               = EnumConst.OnlyTalkAnimation,
        ['ogredraenor/ogredraenor2']                              = EnumConst.OnlyTalkAnimation,
        ['ogredraenor/ogredraenor3']                              = EnumConst.OnlyTalkAnimation,
        ['ogredraenor/ogredraenor4']                              = EnumConst.OnlyTalkAnimation,
        ['ogredraenor/ogredraenor5']                              = EnumConst.OnlyTalkAnimation,
        ['ogredraenor/ogredraenor6']                              = EnumConst.OnlyTalkAnimation,
        ['ogredraenor/ogredraenor7']                              = EnumConst.OnlyTalkAnimation,
        ['ogredraenor/ogredraenor8']                              = EnumConst.OnlyTalkAnimation,
        ['oracle2/oracle2']                                       = EnumConst.OnlyTalkAnimation,
        ['pirat_kultiran_male/kultiranmale']                      = EnumConst.OnlyTalkAnimation,
        ['stormforgedvrykul/stormforgedvrykul']                   = EnumConst.OnlyTalkAnimation,
        ['succubus_fel/succubus_fel']                             = EnumConst.OnlyIdleAnimation,
        ['tuskarr/tuskarrmale_hd']                                = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd10']                              = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd11']                              = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd12']                              = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd13']                              = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd14']                              = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd15']                              = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd16']                              = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd17']                              = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd2']                               = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd3']                               = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd4']                               = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd5']                               = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd6']                               = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd7']                               = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd8']                               = EnumConst.OnlyTalkAnimation,
        ['tuskarr/tuskarrmale_hd9']                               = EnumConst.OnlyTalkAnimation,
        ['varimathras/varimathras']                               = EnumConst.OnlyTalkAnimation,
        ['vrykulfemale2/vrykulfemale2']                           = EnumConst.OnlyTalkAnimation,
    },
}

---@type table<string, Enum>
EnumConst.ModelToDefectList =
{
    ['Original'] = {
        ['broken/male/brokenmale']                 = { [TALKING] = 2600, [YELLING] = 1800, [ASKING] = 1800 },
        ['centaur/centaur']                        = { [TALKING] = 3860, [YELLING] = 3860, [ASKING] = 3860 },
        ['centaur/centaurcaster']                  = { [TALKING] = 3860, [YELLING] = 3860, [ASKING] = 3860 },
        ['centaur/centaurkhan']                    = { [TALKING] = 4500, [YELLING] = 4500, [ASKING] = 4500 },
        ['centaur/centaurwarrior']                 = { [TALKING] = 4500, [YELLING] = 4500, [ASKING] = 4500 },
        ['dwarf/male/dwarfmale']                   = { [TALKING] = 2000, [YELLING] = 1800, [ASKING] = 1800 },
        ['highelf/highelffemale_hunter']           = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 1600 },
        ['highelf/highelffemale_mage']             = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 1600 },
        ['highelf/highelffemale_priest']           = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 1600 },
        ['highelf/highelffemale_warrior']          = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 1600 },
        ['highelf/highelfmale_hunter']             = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 1600 },
        ['highelf/highelfmale_mage']               = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 1600 },
        ['highelf/highelfmale_priest']             = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 1600 },
        ['highelf/highelfmale_warrior']            = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 1600 },
        ['illidan/illidan']                        = { [TALKING] = 3022, [YELLING] = 3022, [ASKING] = 3022 },
        ['illidan/illidandark']                    = { [TALKING] = 3022, [YELLING] = 3022, [ASKING] = 3022 },
        ['ironvrykulmale/ironvrykulmale']          = { [TALKING] = 3400, [YELLING] = 3400, [ASKING] = 3400 },
        ['medivh/medivh']                          = { [TALKING] = 2000, [YELLING] = 1900, [ASKING] = 1900 },
        ['naga_/female/naga_female']               = { [TALKING] = 1800, [YELLING] = 1800, [ASKING] = 1800 },
        ['nightelf/female/nightelffemale']         = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 1600 },
        ['vrykul/male/vrykulmale']                 = { [TALKING] = 3400, [YELLING] = 3400, [ASKING] = 3400 },
    },
    ['HD'] = {
        ['centaur2/centaur2']                      = { [TALKING] = 4500, [YELLING] = 4500, [ASKING] = 4500 },
        ['centaur2_female/centaur2_female']        = { [TALKING] = 4500, [YELLING] = 4500, [ASKING] = 4500 },
        ['centaur2_female/centaur2_female_hunter'] = { [TALKING] = 4500, [YELLING] = 4500, [ASKING] = 4500 },
        ['druid_ccl/druid_night_elffemale_1']      = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 1600 },
        ['ent2/ent2']                              = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 2000 },
        ['igc_yseravisage/igc_yseravisage']        = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 1600 },
        ['kultiran/male/kultiranmale']             = { [TALKING] = 3500, [YELLING] = 3500, [ASKING] = 3500 },
        ['maldraxxusskeleton/maldraxxusskeleton']  = { [TALKING] = 3500, [YELLING] = 3500, [ASKING] = 3500 },
        ['maldraxxusskeleton/maldraxxusskeleton2'] = { [TALKING] = 3500, [YELLING] = 3500, [ASKING] = 3500 },
        ['maldraxxusskeleton/maldraxxusskeleton3'] = { [TALKING] = 3500, [YELLING] = 3500, [ASKING] = 3500 },
        ['maldraxxusskeleton/maldraxxusskeleton4'] = { [TALKING] = 3500, [YELLING] = 3500, [ASKING] = 3500 },
        ['maldraxxusskeleton/maldraxxusskeleton5'] = { [TALKING] = 3500, [YELLING] = 3500, [ASKING] = 3500 },
        ['maldraxxusskeleton/maldraxxusskeleton6'] = { [TALKING] = 3500, [YELLING] = 3500, [ASKING] = 3500 },
        ['maldraxxusskeleton/maldraxxusskeleton7'] = { [TALKING] = 3500, [YELLING] = 3500, [ASKING] = 3500 },
        ['merithra_night_elf/merithra_night_elf']  = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 1600 },
        ['pirat_kultiran_male/kultiranmale']       = { [TALKING] = 3500, [YELLING] = 3500, [ASKING] = 3500 },
        ['rexxar/rexxar']                          = { [TALKING] = 3500, [YELLING] = 3500, [ASKING] = 3500 },
        ['tuskarr/tuskarrmale_hd']                 = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd10']               = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd11']               = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd12']               = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd13']               = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd14']               = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd15']               = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd16']               = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd17']               = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd2']                = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd3']                = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd4']                = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd5']                = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd6']                = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd7']                = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd8']                = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tuskarr/tuskarrmale_hd9']                = { [TALKING] = 2960, [YELLING] = 2960, [ASKING] = 2960 },
        ['tyrande3/tyrande3']                      = { [TALKING] = 2000, [YELLING] = 2000, [ASKING] = 1600 },
        ['varimathras/varimathras']                = { [TALKING] = 2700, [YELLING] = 2700, [ASKING] = 2700 },
    },
}