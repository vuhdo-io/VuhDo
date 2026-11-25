if (GetLocale() ~= "frFR") then
	return;
end

-- @EXACT = true: Translation has to be the exact(!) match in the clients language,
--                beacause it carries technical semantics
-- @EXACT = false: Translation can be done freely, because text is only descriptive
-- @STABLE = true: Translate freely the first time, but never change once released,
--                 because the text is saved in players' settings as a name (bouquets, skins, buff categories)
-- Class Names
-- @EXACT = false
VUHDO_I18N_WARRIORS = "Guerriers";
VUHDO_I18N_ROGUES = "Voleurs";
VUHDO_I18N_HUNTERS = "Chasseurs";
VUHDO_I18N_PALADINS = "Paladins";
VUHDO_I18N_MAGES = "Mages";
VUHDO_I18N_WARLOCKS = "Démonistes";
VUHDO_I18N_SHAMANS = "Chamans";
VUHDO_I18N_DRUIDS = "Druides";
VUHDO_I18N_PRIESTS = "Prêtres";
VUHDO_I18N_DEATH_KNIGHT = "Chevaliers de la mort";
VUHDO_I18N_MONKS = "Moines";
-- Group Model Names
-- @EXACT = false
VUHDO_I18N_GROUP = "Groupe";
VUHDO_I18N_OWN_GROUP = "Mon groupe";
-- Special Model Names
-- @EXACT = false
VUHDO_I18N_PETS = "Familiers";
VUHDO_I18N_MAINTANKS = "Tanks \nprincipaux";
VUHDO_I18N_PRIVATE_TANKS = "Cibles personnalisées";
-- General Labels
-- @EXACT = false
VUHDO_I18N_OKAY = "Valider";
VUHDO_I18N_CLASS = "Classe";
VUHDO_I18N_PLAYER = "du joueur";
-- VuhDoTooltip.lua
-- @EXACT = false
VUHDO_I18N_TT_POSITION = "|cffffb233Position :|r";
VUHDO_I18N_TT_GHOST = "<FANTÔME>";
VUHDO_I18N_TT_DEAD = "<MORT>";
VUHDO_I18N_TT_AFK = "<ABS>";
VUHDO_I18N_TT_DND = "<NPD>";
VUHDO_I18N_TT_LIFE = "|cffffb233Vie :|r ";
VUHDO_I18N_TT_MANA = "|cffffb233Mana :|r ";
VUHDO_I18N_TT_LEVEL = "Niveau ";
-- VuhDoPanel.lua
-- @EXACT = false
VUHDO_I18N_CHOOSE = "Choisir";
VUHDO_I18N_DRAG = "Glisser";
VUHDO_I18N_REMOVE = "Supprimer";
VUHDO_I18N_ME = "moi !";
VUHDO_I18N_TYPE = "Type";
VUHDO_I18N_VALUE = "Valeur";
VUHDO_I18N_SPECIAL = "Spécial";
VUHDO_I18N_BUFF_ALL = "tous";
VUHDO_I18N_SHOW_BUFF_WATCH = "Montrer le suivi des buffs";
-- Heal Spell Names
-- @EXACT = true
--
-- Chat messages
-- @EXACT = false
VUHDO_I18N_COMMAND_LIST = "\n|cffffe566 - [ Commandes VuhDo ] -|r\n" ..
"|cffffe566opt|r[ions] - Options de VuhDo\n" ..
"|cffffe566res|r[et] - Réinitialiser la position des panneaux\n" ..
"|cffffe566lock|r - Verrouiller/Déverrouiller les panneaux\n" ..
"|cffffe566mm, map, minimap|r - Afficher/Masquer l'icône de la minicarte\n" ..
"|cffffe566compart|r[ment] - Afficher/Masquer l'icône du compartiment d'addon\n" ..
"|cffffe566show, hide, toggle|r - Afficher/Masquer les panneaux\n" ..
"|cffffe566load|r - [Profil],[Assignation de touche]\n" ..
"[broad]|cffffe566cast, mt|r[s] - Annoncer les tanks principaux\n" ..
"|cffffe566role|r - Réinitialiser les rôles des joueurs\n" ..
"|cffffe566ab|r[out] - À propos de cet addon\n" ..
"|cffffe566help,?|r - Liste des commandes\n";
VUHDO_I18N_BAD_COMMAND = "Commande inconnue ! Tapez '/vuhdo help' ou '/vd ?' pour la liste des commandes.";
VUHDO_I18N_CHAT_SHOWN = "|cffffe566visible|r.";
VUHDO_I18N_CHAT_HIDDEN = "|cffffe566caché|r.";
VUHDO_I18N_MM_ICON = "L'icône sur la minicarte est maintenant ";
VUHDO_I18N_MTS_BROADCASTED = "Les tanks principaux ont été diffusés à l'ensemble du raid";
VUHDO_I18N_PANELS_SHOWN = "Les panneaux de soins sont maintenant |cffffe566affichés|r.";
VUHDO_I18N_PANELS_HIDDEN = "Les panneaux de soins sont maintenant |cffffe566masqués|r.";
VUHDO_I18N_LOCK_PANELS_PRE = "La position des panneaux est maintenant ";
VUHDO_I18N_LOCK_PANELS_LOCKED = "|cffffe566verrouillée|r.";
VUHDO_I18N_LOCK_PANELS_UNLOCKED = "|cffffe566déverrouillée|r.";
VUHDO_I18N_PANELS_RESET = "La position des panneaux a été réinitialisée.";
-- Config Pop-Up
-- @EXACT = false
VUHDO_I18N_ROLE = "Rôle";
VUHDO_I18N_PRIVATE_TANK = "Cibles personnalisées";
VUHDO_I18N_SET_BUFF = "Définir les buffs";
-- Minimap
-- @EXACT = false
VUHDO_I18N_VUHDO_OPTIONS = "Options de VuhDo";
VUHDO_I18N_PANEL_SETUP = "Options";
VUHDO_I18N_MM_TOOLTIP = "Gauche : Définition des panneaux\nDroite : Menu";
VUHDO_I18N_TOGGLES = "États";
VUHDO_I18N_LOCK_PANELS = "Verr. panneaux";
VUHDO_I18N_SHOW_PANELS = "Afficher les panneaux";
VUHDO_I18N_MM_BUTTON = "Bouton de la minicarte";
VUHDO_I18N_CLOSE = "Fermer";
VUHDO_I18N_BROADCAST_MTS = "Diffuser les MTs";
-- Buff categories
-- @EXACT = false
-- Priest
-- Shaman
-- @STABLE = true
VUHDO_I18N_BUFFC_FIRE_TOTEM = "Totem de feu";
VUHDO_I18N_BUFFC_AIR_TOTEM = "Totem d'air";
VUHDO_I18N_BUFFC_EARTH_TOTEM = "Totem de terre";
VUHDO_I18N_BUFFC_WATER_TOTEM = "Totem d'eau";
VUHDO_I18N_BUFFC_WEAPON_ENCHANT = "Enchantement d'arme";
-- @STABLE = false
VUHDO_I18N_BUFFC_WEAPON_ENCHANT_2 = "Enchantement d'arme 2";
-- @STABLE = true
VUHDO_I18N_BUFFC_SHIELDS = "Boucliers";
-- Paladin
-- @STABLE = false
VUHDO_I18N_BUFFC_BLESSING = "Bénédiction";
VUHDO_I18N_BUFFC_SEAL = "Sceau";
-- Druids
-- Warlock
-- @STABLE = true
VUHDO_I18N_BUFFC_SKIN = "Peau";
-- Mage
VUHDO_I18N_BUFFC_ARMOR_MAGE = "Armure";
-- Death Knight
VUHDO_BUFFC_PRESENCE    = "Présence";
-- Warrior
-- @STABLE = false
VUHDO_I18N_BUFFC_SHOUT = "Cri";
-- Hunter
-- @STABLE = true
VUHDO_I18N_BUFFC_ASPECT = "Aspect";
-- Monk
-- @STABLE = false
VUHDO_I18N_BUFFC_STANCE = "Posture";

-- Key Binding Headers/Names
-- @EXACT = false
BINDING_HEADER_VUHDO_TITLE = "VuhDo - Cadres de raid";
BINDING_NAME_VUHDO_KEY_ASSIGN_1 = "Survol - Sort 1";
BINDING_NAME_VUHDO_KEY_ASSIGN_2 = "Survol - Sort 2";
BINDING_NAME_VUHDO_KEY_ASSIGN_3 = "Survol - Sort 3";
BINDING_NAME_VUHDO_KEY_ASSIGN_4 = "Survol - Sort 4";
BINDING_NAME_VUHDO_KEY_ASSIGN_5 = "Survol - Sort 5";
BINDING_NAME_VUHDO_KEY_ASSIGN_6 = "Survol - Sort 6";
BINDING_NAME_VUHDO_KEY_ASSIGN_7 = "Survol - Sort 7";
BINDING_NAME_VUHDO_KEY_ASSIGN_8 = "Survol - Sort 8";
BINDING_NAME_VUHDO_KEY_ASSIGN_9 = "Survol - Sort 9";
BINDING_NAME_VUHDO_KEY_ASSIGN_10 = "Survol - Sort 10";
BINDING_NAME_VUHDO_KEY_ASSIGN_11 = "Survol - Sort 11";
BINDING_NAME_VUHDO_KEY_ASSIGN_12 = "Survol - Sort 12";
BINDING_NAME_VUHDO_KEY_ASSIGN_13 = "Survol - Sort 13";
BINDING_NAME_VUHDO_KEY_ASSIGN_14 = "Survol - Sort 14";
BINDING_NAME_VUHDO_KEY_ASSIGN_15 = "Survol - Sort 15";
BINDING_NAME_VUHDO_KEY_ASSIGN_16 = "Survol - Sort 16";
BINDING_NAME_VUHDO_KEY_ASSIGN_SMART_BUFF = "Buff intelligent";
VUHDO_I18N_MOUSE_OVER_BINDING = "Raccourcis clavier";
VUHDO_I18N_UNASSIGNED = "(non assigné)";
-- #+V1.89
VUHDO_I18N_NO = "Non";
VUHDO_I18N_UP = "Haut";
VUHDO_I18N_VEHICLES = "Véhicules";
-- #+v1.94
VUHDO_I18N_DEFAULT_RES_ANNOUNCE = "Reviens à la vie, VuhDo, espèce de boulet !";
-- #v+1.151
VUHDO_I18N_MAIN_ASSISTS = "Assistants \nprincipaux";
-- #+v1.184
VUHDO_I18N_BW_CD = "CD";
VUHDO_I18N_BW_GO = "GO !";
VUHDO_I18N_BW_LOW = "BAS";
VUHDO_I18N_BW_N_A = "|cffff0000N/A|r";
VUHDO_I18N_BW_RNG_RED = "|cffff0000RNG|r";
VUHDO_I18N_BW_OK = "OK";
VUHDO_I18N_BW_RNG_YELLOW = "|cffffff00RNG|r";
VUHDO_I18N_PROMOTE_RAID_LEADER = "Promouvoir Chef de raid";
VUHDO_I18N_PROMOTE_ASSISTANT = "Promouvoir Assistant";
VUHDO_I18N_DEMOTE_ASSISTANT = "Rétrograder Assistant";
VUHDO_I18N_PROMOTE_MASTER_LOOTER = "Promouvoir Maître du butin";
VUHDO_I18N_MT_NUMBER = "MT #";
VUHDO_I18N_ROLE_OVERRIDE = "Remplacement de rôle";
VUHDO_I18N_MELEE_TANK = "Mêlée - Tank";
VUHDO_I18N_MELEE_DPS = "Mêlée - DPS";
VUHDO_I18N_RANGED_DPS = "À distance - DPS";
VUHDO_I18N_RANGED_HEALERS = "À distance - Soigneur";
VUHDO_I18N_AUTO_DETECT = "<détection auto>";
VUHDO_I18N_PROMOTE_ASSIST_MSG_1 = "Promu |cffffe566";
VUHDO_I18N_PROMOTE_ASSIST_MSG_2 = "|r assistant.";
VUHDO_I18N_DEMOTE_ASSIST_MSG_1 = "Rétrogradé |cffffe566";
VUHDO_I18N_DEMOTE_ASSIST_MSG_2 = "|r assistant.";
VUHDO_I18N_RESET_ROLES = "Réinitialiser les rôles";
VUHDO_I18N_LOAD_KEY_SETUP = "Charger la configuration des touches";
VUHDO_I18N_BUFF_ASSIGN_1 = "Buff |cffffe566";
VUHDO_I18N_BUFF_ASSIGN_2 = "|r a été assigné à |cffffe566";
VUHDO_I18N_BUFF_ASSIGN_3 = "|r";
VUHDO_I18N_MACRO_KEY_ERR_1 = "ERREUR : La taille de la macro souris-clavier dépasse la limite pour le sort : ";
VUHDO_I18N_MACRO_KEY_ERR_2 = "/256 caractères). Essayez de réduire les options de déclenchement automatique !!!";
VUHDO_I18N_MACRO_NUM_ERR = "Nombre maximum de macros par personnage dépassé ! Impossible de créer une macro souris pour : ";
VUHDO_I18N_SMARTBUFF_ERR_1 = "VuhDo : Impossible d'appliquer un buff intelligent en combat !";
VUHDO_I18N_SMARTBUFF_ERR_2 = "VuhDo : Aucune cible de buff disponible pour ";
VUHDO_I18N_SMARTBUFF_ERR_3 = " joueurs hors de portée pour ";
VUHDO_I18N_SMARTBUFF_ERR_4 = "VuhDo : Aucun buff à lancer.";
VUHDO_I18N_SMARTBUFF_OKAY_1 = "VuhDo : Application d'un buff sur |cffffffff";
VUHDO_I18N_SMARTBUFF_OKAY_2 = "|r sur ";
-- #+v1.189
VUHDO_I18N_UNKNOWN = "inconnu";
VUHDO_I18N_SELF = "Soi-même";
VUHDO_I18N_MELEES = "Mêlées";
VUHDO_I18N_RANGED = "À distance";
VUHDO_I18N_OPTIONS_NOT_LOADED = ">>> Le plugin Options de VuhDo n'est pas chargé ! <<<";
VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST_1 = "Erreur : La disposition de sorts \"";
VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST_2 = "\" n'existe pas.";
VUHDO_I18N_AUTO_ARRANG_1 = "Le nombre de membres du groupe est passé à ";
VUHDO_I18N_AUTO_ARRANG_2 = ". Activation automatique du profil : \"";
VUHDO_I18N_TRACK_BUFFS_FOR = "Suivre les buffs pour...";
VUHDO_I18N_OWN_GROUP_LONG = "Mon groupe";
VUHDO_I18N_NO_FOCUS = "[pas de focus]";
VUHDO_I18N_NOT_AVAILABLE = "[ N/A ]";
VUHDO_I18N_TT_DISTANCE = "|cffffb233Distance :|r";
VUHDO_I18N_TT_OF = " de ";
VUHDO_I18N_YARDS = "Mètres";
-- #+1.252
VUHDO_I18N_PANEL = "Panneau";
VUHDO_I18N_BOUQUET_AGGRO = "Drapeau : Aggro";
VUHDO_I18N_BOUQUET_OUT_OF_RANGE = "Drapeau : Portée, hors de";
VUHDO_I18N_BOUQUET_IN_RANGE = "Drapeau : Portée, dans";
VUHDO_I18N_BOUQUET_IN_YARDS = "Drapeau : Distance < mètres";
VUHDO_I18N_BOUQUET_OTHER_HOTS = "Drapeau : HoTs d'autres joueurs";
VUHDO_I18N_BOUQUET_DEBUFF_MAGIC = "Drapeau : Débuff Magie";
VUHDO_I18N_BOUQUET_DEBUFF_DISEASE = "Drapeau : Débuff Maladie";
VUHDO_I18N_BOUQUET_DEBUFF_POISON = "Drapeau : Débuff Poison";
VUHDO_I18N_BOUQUET_DEBUFF_CURSE = "Drapeau : Débuff Malédiction";
VUHDO_I18N_BOUQUET_CHARMED = "Drapeau : Charmé";
VUHDO_I18N_BOUQUET_DEAD = "Drapeau : Mort";
VUHDO_I18N_BOUQUET_DISCONNECTED = "Drapeau : Déconnecté";
VUHDO_I18N_BOUQUET_AFK = "Drapeau : AFK";
VUHDO_I18N_BOUQUET_PLAYER_TARGET = "Drapeau : Cible du joueur";
VUHDO_I18N_BOUQUET_MOUSEOVER_TARGET = "Drapeau : Survol de souris, unique";
VUHDO_I18N_BOUQUET_MOUSEOVER_GROUP = "Drapeau : Survol de souris, groupe";
VUHDO_I18N_BOUQUET_HEALTH_BELOW = "Drapeau : Santé < %";
VUHDO_I18N_BOUQUET_MANA_BELOW = "Drapeau : Mana < %";
VUHDO_I18N_BOUQUET_THREAT_ABOVE = "Drapeau : Menace > %";
VUHDO_I18N_BOUQUET_NUM_IN_CLUSTER = "Drapeau : Groupe >= joueurs";
VUHDO_I18N_BOUQUET_CLASS_COLOR = "Drapeau : Toujours couleur de classe";
VUHDO_I18N_BOUQUET_ALWAYS = "Drapeau : Toujours plein";
VUHDO_I18N_SWIFTMEND_POSSIBLE = "Drapeau : Soin rapide possible";
VUHDO_I18N_BOUQUET_MOUSEOVER_CLUSTER = "Drapeau : Groupe, survol de souris";
VUHDO_I18N_THREAT_LEVEL_MEDIUM = "Drapeau : Menace, élevée";
VUHDO_I18N_THREAT_LEVEL_HIGH = "Drapeau : Menace, maximale";
VUHDO_I18N_BOUQUET_STATUS_HEALTH = "Barre d'état : Santé %";
VUHDO_I18N_BOUQUET_STATUS_MANA = "Barre d'état : Mana %";
VUHDO_I18N_BOUQUET_STATUS_OTHER_POWERS = "Barre d'état : non-Mana %";
VUHDO_I18N_BOUQUET_STATUS_INCOMING = "Barre d'état : Soins entrants %";
VUHDO_I18N_BOUQUET_STATUS_THREAT = "Barre d'état : Menace %";
-- @STABLE = true
VUHDO_I18N_BOUQUET_NEW_ITEM_NAME = "-- entrer (dé)buff ici --";
VUHDO_I18N_DEF_BOUQUET_TANK_COOLDOWNS = "Temps de recharge du tank";
VUHDO_I18N_DEF_BOUQUET_PW_S_WEAKENED_SOUL = "PW:S & Âme affaiblie";
VUHDO_I18N_DEF_BOUQUET_MONK_STAGGER = "Report du moine";
VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI_AGGRO = "Bordure : Multi + Aggro";
VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI = "Bordure : Multi";
VUHDO_I18N_DEF_BOUQUET_BORDER_SIMPLE = "Bordure : Simple";
VUHDO_I18N_DEF_BOUQUET_SWIFTMENDABLE = "Soin rapide possible";
VUHDO_I18N_DEF_BOUQUET_MOUSEOVER_SINGLE = "Survol de souris : Unique";
VUHDO_I18N_DEF_BOUQUET_MOUSEOVER_MULTI = "Survol de souris : Multi";
VUHDO_I18N_DEF_BOUQUET_AGGRO_INDICATOR = "Indicateur d'aggro";
VUHDO_I18N_DEF_BOUQUET_CLUSTER_MOUSE_HOVER = "Groupe : Survol de souris";
VUHDO_I18N_DEF_BOUQUET_THREAT_MARKS = "Menace : Marques";
VUHDO_I18N_DEF_BOUQUET_BAR_MANA_ALL = "Barres de mana : Toutes les puissances";
VUHDO_I18N_DEF_BOUQUET_BAR_MANA_ONLY = "Barres de mana : Mana seulement";
VUHDO_I18N_DEF_BOUQUET_BAR_THREAT = "Menace : Barre d'état";
-- @STABLE = false
VUHDO_I18N_CUSTOM_ICON_NONE = "- Aucun / Défaut -";
VUHDO_I18N_CUSTOM_ICON_GLOSSY = "Brillant";
VUHDO_I18N_CUSTOM_ICON_MOSAIC = "Mosaïque";
VUHDO_I18N_CUSTOM_ICON_CLUSTER = "Groupe";
VUHDO_I18N_CUSTOM_ICON_FLAT = "Plat";
VUHDO_I18N_CUSTOM_ICON_SPOT = "Point";
VUHDO_I18N_CUSTOM_ICON_CIRCLE = "Cercle";
VUHDO_I18N_CUSTOM_ICON_SKETCHED = "Esquissé";
VUHDO_I18N_CUSTOM_ICON_RHOMB = "Losange";
VUHDO_I18N_ERROR_NO_PROFILE = "Erreur : Aucun profil nommé : ";
VUHDO_I18N_PROFILE_LOADED = "Profil chargé avec succès : ";
VUHDO_I18N_PROFILE_SAVED = "Profil enregistré avec succès : ";
VUHDO_I18N_PROFILE_OVERWRITE_1 = "Profil";
VUHDO_I18N_PROFILE_OVERWRITE_2 = "est actuellement possédé par\nun autre personnage";
VUHDO_I18N_PROFILE_OVERWRITE_3 = "\n- Écraser : Le profil existant sera écrasé.\n- Copier : Créer et enregistrer une copie. Conserver le profil existant.";
VUHDO_I18N_COPY = "Copier";
VUHDO_I18N_OVERWRITE = "Écraser";
VUHDO_I18N_DISCARD = "Abandonner";
-- 2.0, alpha #2
-- @STABLE = true
VUHDO_I18N_DEF_BAR_BACKGROUND_SOLID = "Arrière-plan : Plein";
VUHDO_I18N_DEF_BAR_BACKGROUND_CLASS_COLOR = "Arrière-plan : Couleur de classe";
-- 2.0 alpha #9
-- @STABLE = false
VUHDO_I18N_BOUQUET_DEBUFF_BAR_COLOR = "Drapeau : Débuff, configuré";
-- 2.0 alpha #11
-- @STABLE = true
VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH = "Barre de santé : (auto)";
-- @STABLE = false
VUHDO_I18N_UPDATE_RAID_TARGET = "Drapeau : Couleur de cible de raid";
VUHDO_I18N_BOUQUET_OVERHEAL_HIGHLIGHT = "Couleur : Surbrillance de sursoin";
VUHDO_I18N_BOUQUET_EMERGENCY_COLOR = "Couleur : Urgence";
VUHDO_I18N_BOUQUET_HEALTH_ABOVE = "Drapeau : Santé > %";
VUHDO_I18N_BOUQUET_RESURRECTION = "Drapeau : Résurrection";
VUHDO_I18N_BOUQUET_STACKS_COLOR = "Couleur : #Cumuls";
-- 2.1
-- @STABLE = true
VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_SOLID = "Santé : (générique, plein)";
VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_CLASS_COLOR = "Santé : (générique, couleur de classe)";
-- 2.9
-- @STABLE = false
VUHDO_I18N_NO_TARGET = "[pas de cible]";
VUHDO_I18N_TT_LEFT = " Gauche : ";
VUHDO_I18N_TT_RIGHT = " Droite : ";
VUHDO_I18N_TT_MIDDLE = " Milieu : ";
VUHDO_I18N_TT_BTN_4 = " Bouton 4 : ";
VUHDO_I18N_TT_BTN_5 = " Bouton 5 : ";
VUHDO_I18N_TT_WHEEL_UP = " Molette vers le haut : ";
VUHDO_I18N_TT_WHEEL_DOWN = " Molette vers le bas : ";
-- 2.13
VUHDO_I18N_BOUQUET_CLASS_ICON = "Icône : Classe";
VUHDO_I18N_BOUQUET_RAID_ICON = "Icône : Symbole de raid";
VUHDO_I18N_BOUQUET_ROLE_ICON = "Icône : Rôle";
-- 2.18
VUHDO_I18N_LOAD_PROFILE = "Charger le profil";
-- 2.20
VUHDO_I18N_DC_SHIELD_NO_MACROS = "Pas d'emplacements de macro libres pour ce personnage... le bouclier déco est désactivé temporairement.";
VUHDO_I18N_BROKER_TOOLTIP_1 = "|cffffff00Clic gauche|r pour afficher le menu des options";
VUHDO_I18N_BROKER_TOOLTIP_2 = "|cffffff00Clic droit|r pour afficher le menu contextuel";
-- 2.54
VUHDO_I18N_HOURS = "heures";
VUHDO_I18N_MINS = "mins";
VUHDO_I18N_SECS = "secs";
-- 2.65
VUHDO_I18N_BOUQUET_CUSTOM_DEBUFF = "Icône : Débuff personnalisé";
-- 2.66
VUHDO_I18N_OFF = "désactivé";
VUHDO_I18N_GHOST = "fantôme";
VUHDO_I18N_RIP = "mort";
VUHDO_I18N_DC = "déco";
VUHDO_I18N_FOC = "foc";
VUHDO_I18N_TAR = "cib";
VUHDO_I18N_VEHICLE = "O-O";
-- 2.67
VUHDO_I18N_BUFF_WATCH = "Surveillance des buffs";
-- @STABLE = true
VUHDO_I18N_HOTS = "HoTs";
-- @STABLE = false
VUHDO_I18N_DEBUFFS = "Débuffs";
VUHDO_I18N_BOUQUET_PLAYER_FOCUS = "Drapeau : Focus du joueur";
-- 2.69
VUHDO_I18N_SIDE_BAR_LEFT = "Barre latérale gauche";
VUHDO_I18N_SIDE_BAR_RIGHT = "Barre latérale droite";
VUHDO_I18N_OWN_PET = "Familier personnel";
-- 2.72
VUHDO_I18N_SPELL = "Sort";
VUHDO_I18N_COMMAND = "Commande";
VUHDO_I18N_MACRO = "Macro";
VUHDO_I18N_ITEM = "Objet";
-- 2.75
VUHDO_I18N_ERR_NO_BOUQUET = "\"%s\" essaie de se lier au bouquet \"%s\" qui n'existe pas !";

VUHDO_I18N_BOUQUET_HEALTH_BELOW_ABS = "Drapeau : Santé < k";
VUHDO_I18N_BOUQUET_HEALTH_ABOVE_ABS = "Drapeau : Santé > k";
VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST = "La disposition de sorts \"%s\" n'existe pas.";

--VUHDO_I18N_ADDON_WARNING = "AVERTISSEMENT : L'addon |cffffffff\"%s\"|r est activé avec VuhDo, ce qui peut être problématique. Raison : %s";
--VUHDO_I18N_MAY_CAUSE_LAGS = "Peut causer des lags sévères.";

VUHDO_I18N_DISABLE_BY_MIN_VERSION = "!!! VUHDO EST DÉSACTIVÉ !!! Cette version (%s) est pour les versions de client %d et supérieures seulement !!!"
VUHDO_I18N_DISABLE_BY_MAX_VERSION = "!!! VUHDO EST DÉSACTIVÉ !!! Cette version (%s) est pour les versions de client %d et inférieures seulement !!!"

VUHDO_I18N_BOUQUET_STATUS_ALTERNATE_POWERS = "Barre d'état : Puissance alternative %"
VUHDO_I18N_BOUQUET_ALTERNATE_POWERS_ABOVE = "Drapeau : Puissance alternative > %";
-- @STABLE = true
VUHDO_I18N_DEF_ALTERNATE_POWERS = "Pouvoirs alternatifs";
VUHDO_I18N_DEF_TANK_CDS_EXTENDED = "Temps de recharge du tank étendus";
-- @STABLE = false
VUHDO_I18N_BOUQUET_HOLY_POWER_EQUALS = "Drapeau : Pouvoir sacré personnel ==";
-- @STABLE = true
VUHDO_I18N_DEF_PLAYER_HOLY_POWER = "Pouvoir sacré du joueur";
-- @STABLE = false
VUHDO_I18N_CUSTOM_ICON_ONE_THIRD = "Tiers : Un";
VUHDO_I18N_CUSTOM_ICON_TWO_THIRDS = "Tiers : Deux";
VUHDO_I18N_CUSTOM_ICON_THREE_THIRDS = "Tiers : Trois";
-- @STABLE = true
VUHDO_I18N_DEF_ROLE_ICON = "Icône de rôle";

VUHDO_I18N_DEF_BOUQUET_TARGET_HEALTH = "Santé (générique, cible)";

-- @STABLE = false
VUHDO_I18N_TAPPED_COLOR = "Drapeau : Cible déjà engagée";
VUHDO_I18N_ENEMY_STATE_COLOR = "Couleur : Ami/Ennemi";
VUHDO_I18N_FRIEND_STATUS = "Drapeau : Ami";
VUHDO_I18N_FOE_STATUS = "Drapeau : Ennemi";
VUHDO_I18N_BOUQUET_STATUS_ALWAYS_FULL = "Barre d'état : toujours pleine";
VUHDO_I18N_BOUQUET_STATUS_FULL_IF_ACTIVE = "Barre d'état : pleine si active";
VUHDO_I18N_AOE_ADVICE = "Icône : Conseil de zone";
-- @STABLE = true
VUHDO_I18N_DEF_AOE_ADVICE = "Conseil de zone";

-- @STABLE = false
VUHDO_I18N_BOUQUET_DURATION_ABOVE = "Drapeau : Durée > sec";
VUHDO_I18N_BOUQUET_DURATION_BELOW = "Drapeau : Durée < sec";
VUHDO_I18N_DEF_WRACK = "Sinestra : Tourment";

-- @STABLE = true
VUHDO_I18N_DEF_DIRECTION_ARROW = "Flèche directionnelle";
VUHDO_I18N_BOUQUET_DIRECTION_ARROW = "Flèche directionnelle";
-- @STABLE = false
VUHDO_I18N_DEF_RAID_LEADER = "Icône : Chef de raid";
VUHDO_I18N_DEF_RAID_ASSIST = "Icône : Assistant de raid";
VUHDO_I18N_DEF_MASTER_LOOTER = "Icône : Maître du butin";
VUHDO_I18N_DEF_PVP_STATUS = "Icône : Statut JcJ";

-- @STABLE = true
VUHDO_I18N_GRID_MOUSEOVER_SINGLE = "Grille : Survol de souris unique";
VUHDO_I18N_GRID_BACKGROUND_BAR = "Grille : Barre d'arrière-plan";
VUHDO_I18N_DEF_BIT_O_GRID = "Bit'o'Grid";
VUHDO_I18N_DEF_VUHDO_ESQUE = "Vuhdo'esque";

VUHDO_I18N_DEF_ROLE_COLOR = "Couleur de rôle";
-- @STABLE = false
VUHDO_I18N_BOUQUET_ROLE_TANK = "Drapeau : Rôle Tank";
VUHDO_I18N_BOUQUET_ROLE_DAMAGE = "Drapeau : Rôle Dégâts";
VUHDO_I18N_BOUQUET_ROLE_HEALER = "Drapeau : Rôle Soigneur";

VUHDO_I18N_BOUQUET_STACKS = "Drapeau : Cumuls >";
-- @STABLE = true
VUHDO_I18N_DEF_PLAYER_CHI = "\195\130nergie du joueur";

-- @STABLE = false
VUHDO_I18N_BOUQUET_TARGET_RAID_ICON = "Icône : Symbole de raid de la cible";
VUHDO_I18N_BOUQUET_OWN_CHI_EQUALS = "Drapeau : Chi personnel ==";
VUHDO_I18N_CUSTOM_ICON_FOUR_THIRDS = "Tiers : Quatre";
VUHDO_I18N_CUSTOM_ICON_FIVE_THIRDS = "Tiers : Cinq";
-- @STABLE = true
VUHDO_I18N_DEF_RAID_CDS = "Temps de recharge de raid";
-- @STABLE = false
VUHDO_I18N_BOUQUET_STATUS_CLASS_COLOR_IF_ACTIVE = "Drapeau : Couleur de classe si actif";

-- @STABLE = true
VUHDO_I18N_LETHAL_POISONS = "Poisons létaux";
VUHDO_I18N_NON_LETHAL_POISONS = "Poisons non létaux";
-- @STABLE = false
VUHDO_I18N_DEF_COUNTER_SHIELD_ABSORB = "Compteur : Toute absorption de bouclier #k";
-- @STABLE = true
VUHDO_I18N_BUFFC_WEAPON_ENCHANT_OFF = "Enchantement d'arme (main gauche)";

VUHDO_I18N_DEF_PVP_FLAGS = "Porteurs de drapeaux JcJ";
-- @STABLE = false
VUHDO_I18N_DEF_STATUS_SHIELD = "Barre d'état : Bouclier";

VUHDO_I18N_TARGET = "Cible";
VUHDO_I18N_FOCUS = "Focus";
VUHDO_I18N_DEF_STATUS_OVERSHIELDED = "Barre d'état : Sur-bouclier";

-- 3.65
VUHDO_I18N_BOUQUET_OUTSIDE_ZONE = "Drapeau : Zone du joueur, à l'extérieur";
VUHDO_I18N_BOUQUET_INSIDE_ZONE = "Drapeau : Zone du joueur, à l'intérieur";
VUHDO_I18N_BOUQUET_WARRIOR_TANK = "Drapeau : Rôle Tank, Guerrier";
VUHDO_I18N_BOUQUET_PALADIN_TANK = "Drapeau : Rôle Tank, Paladin";
VUHDO_I18N_BOUQUET_DK_TANK = "Drapeau : Rôle Tank, Chevalier de la mort";
VUHDO_I18N_BOUQUET_MONK_TANK = "Drapeau : Rôle Tank, Moine";
VUHDO_I18N_BOUQUET_DRUID_TANK = "Drapeau : Rôle Tank, Druide";

-- 3.66
-- @STABLE = true
VUHDO_I18N_BOUQUET_PALADIN_BEACON = "Phare du Paladin";
-- @STABLE = false
VUHDO_I18N_BOUQUET_STATUS_EXCESS_ABSORB = "Barre d'état : Absorption excédentaire %";
VUHDO_I18N_BOUQUET_STATUS_TOTAL_ABSORB = "Barre d'état : Absorption totale %";

-- 3.67
VUHDO_I18N_NO_BOSS = "[pas de PNJ]";
VUHDO_I18N_BOSSES = "PNJ";

-- 3.71
VUHDO_I18N_BOUQUET_CUSTOM_FLAG = "Drapeau personnalisé";
VUHDO_I18N_ERROR_CUSTOM_FLAG_LOAD = "{VuhDo} Erreur : Votre validateur de drapeau personnalisé n'a pas été chargé :";
VUHDO_I18N_ERROR_CUSTOM_FLAG_EXECUTE = "{VuhDo} Erreur : Votre validateur de drapeau personnalisé n'a pas été exécuté :";
VUHDO_I18N_ERROR_CUSTOM_FLAG_BLOCKED = "{VuhDo} Erreur : Un drapeau personnalisé de ce bouquet a essayé d'appeler une fonction interdite mais a été bloqué. Souvenez-vous d'importer des chaînes uniquement à partir de sources de confiance.";
VUHDO_I18N_ERROR_INVALID_VALIDATOR = "{VuhDo} Erreur : Validateur invalide :";

-- 3.72
VUHDO_I18N_BOUQUET_DEMON_HUNTER_TANK = "Drapeau : Rôle Tank, Chasseur de démons";
VUHDO_I18N_DEMON_HUNTERS = "Chasseurs de démons";

-- 3.77
VUHDO_I18N_DEF_COUNTER_OVERFLOW_ABSORB = "Compteur : Absorption de débordement mythique+ #k";

-- 3.79
VUHDO_I18N_DEFAULT_RES_ANNOUNCE_MASS = "Lancement de la résurrection de masse !";

-- 3.81
-- @STABLE = true
VUHDO_I18N_BOUQUET_OVERFLOW_COUNTER = "Affix de d\195\169bordement mythique+";

-- 3.82
-- @STABLE = false
VUHDO_I18N_SPELL_TRACE = "Trace\nde sort";
-- @STABLE = true
VUHDO_I18N_DEF_SPELL_TRACE = "Trace de sort";
-- @STABLE = false
VUHDO_I18N_TRAIL_OF_LIGHT = "Icône : Traînée de lumière";
-- @STABLE = true
VUHDO_I18N_DEF_TRAIL_OF_LIGHT = "Traînée de lumière";

-- 3.83
-- @STABLE = false
VUHDO_I18N_BOUQUET_STATUS_MANA_HEALER_ONLY = "Barre d'état : Mana % (Soigneur uniquement)";
-- @STABLE = true
VUHDO_I18N_DEF_BOUQUET_BAR_MANA_HEALER_ONLY = "Barres de mana : Mana (Soigneur uniquement)";

-- 3.98
-- @STABLE = false
VUHDO_I18N_BOUQUET_HAS_SUMMON_ICON = "Icône : A une invocation";
-- @STABLE = true
VUHDO_I18N_DEF_BOUQUET_HAS_SUMMON = "Icône d'état d'invocation";
VUHDO_I18N_DEF_BOUQUET_ROLE_AND_SUMMON = "Icône d'état de rôle et d'invocation";

-- 3.99
-- @STABLE = false
VUHDO_I18N_BOUQUET_IS_PHASED = "Icône : Est phasé";
VUHDO_I18N_BOUQUET_IS_WAR_MODE_PHASED = "Icône : Est phasé en mode guerre";
-- @STABLE = true
VUHDO_I18N_DEF_BOUQUET_IS_PHASED = "Icône Est phasé";

-- 3.101
VUHDO_I18N_DEF_PLAYER_COMBO_POINTS = "Points de combo du joueur";
-- @STABLE = false
VUHDO_I18N_BOUQUET_OWN_COMBO_POINTS_EQUALS = "Drapeau : Points de combo personnels ==";
-- @STABLE = true
VUHDO_I18N_DEF_PLAYER_SOUL_SHARDS = "Fragments d'\195\130me du joueur";
-- @STABLE = false
VUHDO_I18N_BOUQUET_OWN_SOUL_SHARDS_EQUALS = "Drapeau : Fragments d'âme personnels ==";
-- @STABLE = true
VUHDO_I18N_DEF_PLAYER_RUNES = "Runes du joueur";
-- @STABLE = false
VUHDO_I18N_BOUQUET_OWN_RUNES_EQUALS = "Drapeau : Runes personnelles ==";
-- @STABLE = true
VUHDO_I18N_DEF_PLAYER_ARCANE_CHARGES = "Charges arcaniques du joueur";
-- @STABLE = false
VUHDO_I18N_BOUQUET_OWN_ARCANE_CHARGES_EQUALS = "Drapeau : Charges arcaniques personnelles ==";
VUHDO_I18N_DEBUFF_BLACKLIST_ADDED = "Ajout de \"[%s] %s\" à la liste noire des débuffs.";

-- 3.104
VUHDO_I18N_PLAY_SOUND_FILE_ERR = "Impossible de jouer le son \"%s\" : %s";
VUHDO_I18N_PLAY_SOUND_FILE_DEBUFF_ERR = "Impossible de jouer le son \"%s\" pour le débuff standard. Ajustez vos paramètres sous 'Options VuhDo > Débuffs > Standard > Son de débuff'.";
VUHDO_I18N_PLAY_SOUND_FILE_CUSTOM_DEBUFF_ERR = "Impossible de jouer le son \"%s\" pour le débuff personnalisé \"%s\". Ajustez vos paramètres sous 'Options VuhDo > Débuffs > Personnalisé'.";

-- 3.122
VUHDO_I18N_BOUQUET_STATUS_POWER_TANK_ONLY = "Barre d'état : Puissance % (Tank uniquement)";
-- @STABLE = true
VUHDO_I18N_DEF_BOUQUET_BAR_MANA_TANK_ONLY = "Barres de mana : Puissance (Tank uniquement)";

-- 3.131
VUHDO_I18N_DEF_COUNTER_HEAL_ABSORB = "Compteur : Toute absorption de soin #k";
-- @STABLE = false
VUHDO_I18N_DEF_STATUS_HEAL_ABSORB = "Barre d'état : Absorption de soin";

-- 3.135
VUHDO_I18N_TRINKET_1 = "Bijou 1";
VUHDO_I18N_TRINKET_2 = "Bijou 2";

-- 3.139
VUHDO_I18N_EVOKERS = "Évocateurs";

-- 3.143
VUHDO_I18N_BUFFC_EARTH_SHIELD = "Bouclier de terre (Soi)";

-- 3.150
VUHDO_I18N_ADDON_COMPARTMENT_ICON = "L'icône du compartiment d'addon est maintenant ";

-- 3.152
VUHDO_I18N_SPELL_TRACE_SINGLE = "Icône : Trace de sort (Unique)";

-- 3.154
VUHDO_I18N_SPELL_TRACE_INCOMING = "Icône : Trace de sort (Entrant)";
VUHDO_I18N_SPELL_TRACE_HEAL = "Icône : Trace de sort (Soin)";

-- 3.157
VUHDO_I18N_BOUQUET_STATUS_HEALTH_IF_ACTIVE = "Barre d'état : Santé % si actif";

-- @STABLE = true
VUHDO_I18N_DEF_COUNTER_ACTIVE_AURAS = "Compteur : Auras de bouquet actives #k";

VUHDO_I18N_BOUQUET_EVOKER_REVERSION = "R\195\169version de l'\195\130vocateur (non-\195\169cho)";
VUHDO_I18N_BOUQUET_EVOKER_REVERSION_ECHO = "R\195\169version de l'\195\130vocateur (\195\169cho)";
VUHDO_I18N_BOUQUET_EVOKER_DREAM_BREATH = "Souffle de r\195\170ve de l'\195\130vocateur (non-\195\169cho)";
VUHDO_I18N_BOUQUET_EVOKER_DREAM_BREATH_ECHO = "Souffle de r\195\170ve de l'\195\130vocateur (\195\169cho)";
VUHDO_I18N_BOUQUET_EVOKER_ALL_ECHO = "Tous les \195\169chos de soins de l'\195\130vocateur";

-- @STABLE = false
VUHDO_I18N_TRAIL_OF_LIGHT_NEXT = "Drapeau : Traînée de lumière (Suivant)";
-- @STABLE = true
VUHDO_I18N_DEF_TRAIL_OF_LIGHT_NEXT = "Traînée de lumière (Suivant)";
-- @STABLE = false
VUHDO_I18N_BOUQUET_DEBUFF_BLEED = "Drapeau : Débuff Saignement";

-- @STABLE = true
VUHDO_I18N_DEF_SPELL_TRACE_INCOMING = "Trace de sort (Entrant)";

VUHDO_I18N_BOUQUET_CHI_HARMONY_ICON_MINE = "Icône : Harmonie du Chi (Mien)";
VUHDO_I18N_DEF_BOUQUET_CHI_HARMONY_ICON_MINE = "Harmonie du Chi (Mien)";
VUHDO_I18N_BOUQUET_CHI_HARMONY_ICON_OTHERS = "Icône : Harmonie du Chi (Autres)";
VUHDO_I18N_DEF_BOUQUET_CHI_HARMONY_ICON_OTHERS = "Harmonie du Chi (Autres)";
VUHDO_I18N_BOUQUET_CHI_HARMONY_ICON_BOTH = "Icône : Harmonie du Chi (Les deux)";
VUHDO_I18N_DEF_BOUQUET_CHI_HARMONY_ICON_BOTH = "Harmonie du Chi (Les deux)";

-- @STABLE = false
VUHDO_I18N_BOUQUET_DEBUFF_ENRAGE = "Drapeau : Débuff Enrager";

VUHDO_I18N_AURA_GROUP_MY_HOTS = "Mes HoTs (Auras de combat)";
VUHDO_I18N_AURA_GROUP_OTHERS_HOTS = "HoTs des autres (Auras de combat)";
VUHDO_I18N_AURA_GROUP_ALL_HOTS = "Tous les HoTs (Auras de combat)";
VUHDO_I18N_AURA_GROUP_DISPELLABLE = "Débuffs dissipables";
VUHDO_I18N_AURA_GROUP_CC = "Effets de CC";
VUHDO_I18N_AURA_GROUP_BIG_DEF = "Gros défensifs";
VUHDO_I18N_AURA_GROUP_EXTERNAL_DEF = "Défensifs externes";
VUHDO_I18N_AURA_GROUP_ALL_DEBUFFS = "Tous les débuffs";
VUHDO_I18N_AURA_GROUP_ALL_BUFFS = "Tous les buffs";
VUHDO_I18N_AURA_GROUP_MY_BUFFS = "Mes buffs de classe";
VUHDO_I18N_AURA_GROUP_OTHERS_BUFFS = "Buffs de classe des autres";
VUHDO_I18N_AURA_GROUP_ALL_RAID_BUFFS = "Tous les buffs de classe";
VUHDO_I18N_AURA_GROUP_RAID_DEBUFFS = "Débuffs de raid";
VUHDO_I18N_AURA_GROUP_IMPORTANT_BUFFS = "Buffs importants";
VUHDO_I18N_AURA_GROUP_IMPORTANT_DEBUFFS = "Débuffs importants";
VUHDO_I18N_AURA_GROUP_CANCELABLE = "Buffs annulables";
VUHDO_I18N_AURA_GROUP_NOT_CANCELABLE = "Buffs non annulables";
VUHDO_I18N_AURA_GROUP_TORGHAST_ANIMA = "Pouvoirs d'Anima de Tourment";
VUHDO_I18N_AURA_GROUP_INFERRED_RIPTIDE = "Remous (Déduit)";
VUHDO_I18N_AURA_GROUP_INFERRED_ECHO = "Écho (Déduit)";
VUHDO_I18N_AURA_GROUP_INFERRED_ATONEMENT = "Expiation (Déduit)";
VUHDO_I18N_AURA_GROUP_MY_NAMEPLATE = "Mes débuffs (incl. barre d'info)";
VUHDO_I18N_AURA_GROUP_OTHERS_NAMEPLATE = "Débuffs des autres (incl. barre d'info)";
VUHDO_I18N_AURA_GROUP_ALL_NAMEPLATE = "Tous les débuffs (incl. barre d'info)";
VUHDO_I18N_AURA_GROUP_MY_DEBUFFS = "Mes débuffs";
VUHDO_I18N_AURA_GROUP_MY_EXTERNAL_DEF = "Mes défensifs externes";
VUHDO_I18N_AURA_GROUP_MY_RAID_DEBUFFS = "Mes débuffs de raid";
VUHDO_I18N_AURA_GROUP_PRESERVATION_EVOKER_HOTS = "HoTs Évocateur Préservation";
VUHDO_I18N_AURA_GROUP_AUGMENTATION_EVOKER_BUFFS = "Buffs Évocateur Augmentation";
VUHDO_I18N_AURA_GROUP_RESTORATION_DRUID_HOTS = "HoTs Druide Restauration";
VUHDO_I18N_AURA_GROUP_DISCIPLINE_PRIEST_HOTS = "HoTs Prêtre Discipline";
VUHDO_I18N_AURA_GROUP_HOLY_PRIEST_HOTS = "HoTs Prêtre Sacré";
VUHDO_I18N_AURA_GROUP_MISTWEAVER_MONK_HOTS = "HoTs Moine Tisse-brume";
VUHDO_I18N_AURA_GROUP_RESTORATION_SHAMAN_HOTS = "HoTs Chaman Restauration";
VUHDO_I18N_AURA_GROUP_HOLY_PALADIN_HOTS = "HoTs Paladin Sacré";
VUHDO_I18N_AURA_GROUP_RAID_BUFFS = "Buffs de raid";
VUHDO_I18N_AURA_GROUP_BLESSING_OF_BRONZE = "Bénédiction du bronze";
VUHDO_I18N_AURA_GROUP_ROGUE_POISONS = "Poisons de voleur";
VUHDO_I18N_AURA_GROUP_SHAMAN_WEAPON_IMBUEMENTS = "Imprégnations d'arme du chaman";
VUHDO_I18N_AURA_GROUP_PALADIN_WEAPON_IMBUEMENTS = "Imprégnations d'arme du paladin";
VUHDO_I18N_AURA_GROUP_ENHANCEMENT_SHAMAN_BUFFS = "Buffs Chaman Amélioration";
VUHDO_I18N_AURA_GROUP_BREWMASTER_MONK_BUFFS = "Buffs Moine Maître brasseur";
VUHDO_I18N_AURA_GROUP_WARLOCK_METAMORPHOSIS = "Métamorphose du Démoniste";
VUHDO_I18N_AURA_GROUP_MIGRATED_HOTS = "HoTs migrés";
VUHDO_I18N_AURA_GROUP_MIGRATED_HOT_ICONS = "Icônes de HoTs migrées";
VUHDO_I18N_AURA_GROUP_MIGRATED_HOT_BARS = "Barres de HoTs migrées";

VUHDO_I18N_BOUQUET_AURA_GROUP_ACTIVE = "Marqueur : Groupe d'auras actif";
VUHDO_I18N_AURA_GROUP_FERAL_DRUID_BUFFS = "Buffs Druide Farouche";
VUHDO_I18N_BW_MISS = "|cffff0000RATÉ|r";
VUHDO_I18N_BW_LOCK = "|cff4488ffVERR|r";
VUHDO_I18N_BW_TARGET_MODE = "Ciblé par";
VUHDO_I18N_BW_TARGET_BY_NAME = "Nom du joueur";
VUHDO_I18N_BW_TARGET = "Cible";
VUHDO_I18N_BW_FOCUS = "Focus";

VUHDO_I18N_AURA_GROUP_ALL_DISPELLABLE = "Tous les débuffs dissipables";

VUHDO_I18N_TEXT_PROVIDER_SOURCE_MANA = "Mana";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_RAGE = "Rage";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_FOCUS = "Focalisation";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_ENERGY = "Énergie";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_RUNIC_POWER = "Puissance runique";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_LUNAR_POWER = "Puissance astrale";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_MAELSTROM = "Maelström";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_INSANITY = "Insanité";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_FURY = "Fureur";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_PAIN = "Douleur";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_ESSENCE = "Essence";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_ALL_POWERS = "Toutes les ressources";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_CHI = "Chi";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_HOLY_POWER = "Puissance sacrée";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_COMBO_POINTS = "Points de combo";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_SOUL_SHARDS = "Fragments d'âme";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_RUNES = "Runes";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_ARCANE_CHARGES = "Charges arcaniques";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_THREAT = "Menace";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_OVERHEAL = "Sursoin";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_INCOMING_HEAL = "Soin entrant";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_SHIELD_ABSORB = "Absorption de bouclier";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_HEAL_ABSORB = "Absorption de soin";
VUHDO_I18N_TEXT_PROVIDER_FORMAT_PERCENT = "<#n>%";
VUHDO_I18N_TEXT_PROVIDER_FORMAT_PERCENT_TENTH = "<#n/10%>";
VUHDO_I18N_TEXT_PROVIDER_FORMAT_UNIT_OF_UNIT = "<#n>/<#n>";
VUHDO_I18N_TEXT_PROVIDER_FORMAT_KILO_OF_KILO = "<#nk>/<#nk>";
VUHDO_I18N_TEXT_PROVIDER_FORMAT_N = "<#n>";
VUHDO_I18N_TEXT_PROVIDER_FORMAT_NK = "<#nk>";
VUHDO_I18N_TEXT_PROVIDER_FORMAT_NK_PLUS = "+<#nk>";
VUHDO_I18N_TEXT_PROVIDER_FORMAT_NK_PERCENT = "<#nk> (<#n>%)";
VUHDO_I18N_TEXT_PROVIDER_FORMAT_KILO_OF_KILO_PERCENT = "<#nk>/<#nk> (<#n>%)";
VUHDO_I18N_TEXT_PROVIDER_SOURCE_LABEL = "Source du texte";
VUHDO_I18N_TEXT_PROVIDER_FORMAT_LABEL = "Format du texte";

VUHDO_I18N_BLIZZ_RESTORE_RELOAD = "Rechargez votre interface (/reload) pour restaurer les cadres Blizzard masqués.";

VUHDO_I18N_AURA_GROUP_PURGEABLE_BUFFS = "Buffs purgeables";
VUHDO_I18N_AURA_GROUP_ALL_PURGEABLE_BUFFS = "Tous les buffs purgeables";
VUHDO_I18N_AURA_GROUP_BOSS_DEBUFFS = "Débuffs de boss et de rôle";
VUHDO_I18N_AURA_GROUP_PRIORITY_DEBUFFS = "Débuffs prioritaires";
VUHDO_I18N_AURA_GROUP_RELEVANT_BUFFS = "Buffs pertinents";
VUHDO_I18N_AURA_GROUP_RELEVANT_DEBUFFS = "Débuffs pertinents";
VUHDO_I18N_AURA_GROUP_TIMED_DEBUFFS = "Débuffs chronométrés";

VUHDO_I18N_PT_NAME_AMBIGUOUS = "Nom de tank personnalisé ambigu : %s. Utilisez le nom complet (Nom-Royaume ou Prénom-Nom).";

VUHDO_I18N_AURA_GROUP_PRIEST_WEAKENED_SOUL = "Âme affaiblie du Prêtre";

VUHDO_I18N_BW_MAIN_HAND = "Main droite";
VUHDO_I18N_BW_OFF_HAND = "Main gauche";
VUHDO_I18N_ERROR_NO_LIST_GROUP_BOUQUET = "Le groupe d'auras \"%s\" contient le bouquet \"%s\" qui n'existe pas !";

VUHDO_I18N_BOUQUET_STATUS_POWER_HEALER_ONLY = "Barre d'état : Ressource % (Soigneur uniquement)";
-- @STABLE = true
VUHDO_I18N_DEF_BOUQUET_BAR_POWER_HEALER_ONLY = "Manabars: Power (Healer Only)";
VUHDO_I18N_DEF_BOUQUET_PW_S_WEAKENED_SOUL_ICONS = "PW:S & Weakened Soul (Icons)";

-- @STABLE = false
VUHDO_I18N_CLICK_BINDING_CONFLICT = "AVERTISSEMENT : Le lancer au clic de Blizzard lie |cffffffff\"%s\"|r à |cffffffff%s|r et remplace l'assignation de VuhDo pour ce clic ! Retirez-le dans Menu du jeu > Options > Jouabilité > Raccourcis > Lancer au clic.";

VUHDO_I18N_AFK = "abs";
VUHDO_I18N_CUSTOM = "Personnalisé";
VUHDO_I18N_TEXT_PROVIDER_EMPTY = "- vide / rien -";

