NDefines.NGame.START_DATE = "2019.7.1.12"						-- Default start date, base for some durations (e.g. license costs, AI construction strategy)
NDefines.NGame.END_DATE = "2077.1.1.1"							-- Decides on the date when the final scoreboard is shown, unless a sufficiently major war is ongoing
NDefines.NGame.HANDS_OFF_START_TAG = "ICE"						-- tag for player country for -hands_off runs. use an existing tag that is less likely to affect the game

NDefines.NGame.MAP_SCALE_PIXEL_TO_KM = 1.74						-- Translates the pixel distances from world map bitmaps into distances in-game, such as for unit speed

NDefines.NGame.LAG_DAYS_FOR_LOWER_SPEED = 30					-- Days of client lag for decrease of gamespeed
NDefines.NGame.LAG_DAYS_FOR_PAUSE = 60							-- Days of client lag for pause of gamespeed
NDefines.NGame.GAME_SPEED_SECONDS = { 0.04, 0.03, 0.02, 0.01, 0.0 } -- game speeds for each level. Must be 5 entries with last one 0 for unbound

NDefines.NGame.COMBAT_LOG_MAX_MONTHS = 36						-- Non-air combat log data will be pruned after this duration
NDefines.NGame.EVENT_TIMEOUT_DEFAULT = 15						-- Default days before an event times out if not scripted
NDefines.NGame.MISSION_REMOVE_FROM_INTERFACE_DEFAULT = 5		-- Default days before a mission is removed from the interface after having failed or completed
NDefines.NGame.ALERT_SFX_COOLDOWN_DAYS = 3						-- After playing an alert sound, don't play the same sound for XXX days, even if it fires again.



NDefines.NDiplomacy.DIPLOMACY_REQUEST_EXPIRY_DAYS = 30
NDefines.NDiplomacy.TRUCE_PERIOD_AFTER_KICKING_FROM_FACTION = 30				-- Truce period after kicking someone from faction in days.
NDefines.NDiplomacy.NUM_DAYS_TO_ENABLE_KICKING_NEW_MEMBERS_OF_FACTION = 90		-- Number of days before being able to kick a new member of faction
NDefines.NDiplomacy.NUM_DAYS_TO_ENABLE_REINVITE_KICKED_NATIONS = 60				-- Number of days before being able to re invite a kicked nation to your faction



NDefines.NCountry.EVENT_PROCESS_OFFSET = 30						-- Events are checked every X day per country or state (1 is ideal, but CPU heavy)

NDefines.NCountry.MIN_STABILITY = -1.0							-- min stability
NDefines.NCountry.MAX_STABILITY = 1.0							-- max stability
NDefines.NCountry.MIN_WAR_SUPPORT = -1.0						-- min war support
NDefines.NCountry.MAX_WAR_SUPPORT = 1.0							-- max war support

NDefines.NCountry.INTEL_FROM_ALLIANCE_FACTOR = 0.5				-- Multiplied to the difference between a country intel and the maximum value in the alliance to compute the amount of intel that flows from the alliance to that country. 0 means no alliance contribution, 1 means a country intel's is the same as the max in the alliance.

NDefines.NCountry.SPECIAL_FORCES_CAP_BASE = 0.2					-- Max ammount of special forces battalions is total number of non-special forces battalions multiplied by this and modified by a country modifier
NDefines.NCountry.SPECIAL_FORCES_CAP_MIN = 48					-- You can have a minimum of this many special forces battalions, regardless of the number of non-special forces battalions you have, this can also be modified by a country modifier



NDefines.NBuildings.OWNER_CHANGE_EXTRA_SHARED_SLOTS_FACTOR = 1 	-- Scale factor of extra shared slots when state owner change.



NDefines.NTechnology.BASE_RESEARCH_POINTS_SAVED = 50.0			-- Base amount of research points a country can save per slot.



NDefines.NMilitary.CORPS_COMMANDER_DIVISIONS_CAP = 6			-- how many divisions a corps commander is limited to. 0 = inf, < 0 = blocked
NDefines.NMilitary.CORPS_COMMANDER_ARMIES_CAP = -1				-- how many armies a corps commander is limited to. 0 = inf, < 0 = blocked
NDefines.NMilitary.FIELD_MARSHAL_DIVISIONS_CAP = 12				-- how many divisions a field marshall is limited to. 0 = inf, < 0 = blocked
NDefines.NMilitary.FIELD_MARSHAL_ARMIES_CAP = 3					-- how many armies a field marshall is limited to. 0 = inf, < 0 = blocked

NDefines.NMilitary.MAX_DIVISION_BRIGADE_WIDTH = 6				-- Max width of regiments in division designer.
NDefines.NMilitary.MAX_DIVISION_BRIGADE_HEIGHT = 6				-- Max height of regiments in division designer.
NDefines.NMilitary.MIN_DIVISION_BRIGADE_HEIGHT = 4				-- Min height of regiments in division designer.
NDefines.NMilitary.MAX_DIVISION_SUPPORT_WIDTH = 2				-- Max width of support in division designer.
NDefines.NMilitary.MAX_DIVISION_SUPPORT_HEIGHT = 6				-- Max height of support in division designer.

NDefines.NMilitary.UNIT_EXP_LEVELS = { 0.1, 0.3, 0.75, 0.9 }	-- Experience needed to progress to the next level

NDefines.NMilitary.EQUIPMENT_COMBAT_LOSS_FACTOR = 0.50			-- % of equipment lost to strength ratio in combat, so some % is returned if below 1



NDefines.NAir.AIR_REGION_SUPERIORITY_PIXEL_SCALE = 0.02			-- air superiority scale = superiority/(pixels*this)



NDefines.NNavy.NAVAL_RANGE_TO_INGAME_DISTANCE = 0.24			-- Scale the ship stats "naval_range" to the ingame distance



NDefines.NSupply.CAPITAL_SUPPLY_BASE = 1.75 					-- base supply for capital
NDefines.NSupply.CAPITAL_SUPPLY_CIVILIAN_FACTORIES = 0.3		-- supply from one civilian factory
NDefines.NSupply.CAPITAL_SUPPLY_MILITARY_FACTORIES = 0.7		-- supply from one military factory
NDefines.NSupply.CAPITAL_SUPPLY_DOCKYARDS = 0.5					-- supply from one naval factory

NDefines.NSupply.CAPITAL_INITIAL_SUPPLY_FLOW = 3.0 				-- starting supply from capital
NDefines.NSupply.CAPITAL_STARTING_PENALTY_PER_PROVINCE = 0.25 	-- starting penalty that will be added as supply moves away from its origin (modified by stuff like terrain)
NDefines.NSupply.CAPITAL_ADDED_PENALTY_PER_PROVINCE = 0.5 		-- added penalty as we move away from origin

NDefines.NSupply.NODE_INITIAL_SUPPLY_FLOW = 2.0					-- defines that are used for supply reach for built nodes
NDefines.NSupply.NODE_STARTING_PENALTY_PER_PROVINCE = 0.25
NDefines.NSupply.NODE_ADDED_PENALTY_PER_PROVINCE = 0.5

NDefines.NSupply.NAVAL_BASE_INITIAL_SUPPLY_FLOW = 1.2
NDefines.NSupply.NAVAL_BASE_STARTING_PENALTY_PER_PROVINCE = 0.6
NDefines.NSupply.NAVAL_BASE_ADDED_PENALTY_PER_PROVINCE = 0.7

NDefines.NSupply.FLOATING_HARBOR_INITIAL_SUPPLY_FLOW = 0.8
NDefines.NSupply.FLOATING_HARBOR_STARTING_PENALTY_PER_PROVINCE = 0.8
NDefines.NSupply.FLOATING_HARBOR_ADDED_PENALTY_PER_PROVINCE = 0.8

NDefines.NSupply.INFRA_TO_SUPPLY = 0.15							-- each level of infra gives this many supply
NDefines.NSupply.VP_TO_SUPPLY_BASE = 0							-- Bonus to supply from a VP, no matter the level
NDefines.NSupply.VP_TO_SUPPLY_BONUS_CONVERSION = 0.025			-- Bonus to supply local supplies from Victory Points, multiplied by this aspect and rounded to closest integer






NDefines_Graphics.NGraphics.PROVINCE_NAME_DRAW_DISTANCE = 1000.0 		-- Remove province names beyond this distance

NDefines.NGraphics.COUNTRY_FLAG_TEX_MAX_SIZE = 2048						-- Tweak dependly on amount of countries. Must be power of 2. No more then 2048.
NDefines.NGraphics.COUNTRY_FLAG_MEDIUM_TEX_MAX_SIZE = 1024				-- Tweak dependly on amount of countries. Must be power of 2. No more then 2048.
NDefines.NGraphics.COUNTRY_FLAG_SMALL_TEX_MAX_SIZE = 512				-- Tweak dependly on amount of countries. Must be power of 2. No more then 2048.

NDefines.NGraphics.VICTORY_POINT_MAP_ICON_TEXT_CUTOFF = {200, 375, 750} -- At what camera distance the VP name text disappears
NDefines.NGraphics.CAPITAL_ICON_CUTOFF = 1650							-- At what camera distance capital icons disappears
NDefines.NGraphics.UNITS_DISTANCE_CUTOFF = 180
NDefines.NGraphics.SHIPS_DISTANCE_CUTOFF = 360

NDefines.NGraphics.MAP_ICONS_GROUP_CAM_DISTANCE = 145.0 				-- camera distance at which the icons begin to group up
NDefines.NGraphics.MAP_ICONS_STATE_GROUP_CAM_DISTANCE = 270.0			-- camera distance at which the icons begin to group up on state level
NDefines.NGraphics.MAP_ICONS_STRATEGIC_GROUP_CAM_DISTANCE = 525 		-- second camera distance at which the icons begin to group up

NDefines_Graphics.NGraphics.CAMERA_ZOOM_SPEED = 50
NDefines_Graphics.NGraphics.CAMERA_ZOOM_KEY_SCALE = 0.02
NDefines_Graphics.NGraphics.CAMERA_ZOOM_SPEED_DISTANCE_MULT = 9

NDefines_Graphics.NGraphics.MINIMUM_PROVINCE_SIZE_IN_PIXELS = 4			-- Provinces that are smaller than that are just making the game unplayable. It doesn't affect the game, just informs in the error.log



NDefines_Graphics.NFrontend.CAMERA_MIN_HEIGHT = 30.0
NDefines_Graphics.NFrontend.CAMERA_MAX_HEIGHT = 3800.0

NIntel = {
    ARMY_ARMY_COUNT_RANGE_INTEL_MIN = 0.0,
	ARMY_ARMY_COUNT_RANGE_INTEL_MAX = 0.7,
	ARMY_ARMY_COUNT_RANGE_INTEL_RANGE_AT_LOWEST_INTEL = 0.8,
}