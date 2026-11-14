# Coalition & Banned Parties System Scripting Guide

This guide explains how to script, check, and customize **Coalitions** and **Banned Parties** in your mod's country history files, events, national focuses, and decisions.

---

## 1. Core Concepts & Automatic Rules

* **Ruling Party vs. Coalition Partners vs. Banned Parties:**
  * Every country has one primary **Ruling Party** (set via `set_politics`).
  * Any other ideology added to the government becomes a **Coalition Partner** and receives the coalition highlight bar (`GFX_coalition_pol_party_bg`) behind its party name in the Politics tab.
  * Any opposition ideology that is outlawed becomes a **Banned Party** and receives the banned party graphic (`GFX_banned_pol_party_bg`) in the Politics tab.
* **Topbar Popularity Display:**
  * When governing alone, the topbar shows the Ruling Party's popularity.
  * When in a coalition, the topbar automatically displays the **combined popularity** of the Ruling Party plus all active Coalition Partners (`coalition_ruling_combined_pop`).
* **Political Power Math:**
  * **Ruling Party:** Grants daily Political Power equal to its popularity (`ruling_party_pp_gain`).
  * **Coalition Partners:** Contribute a percentage of their popularity toward daily Political Power gain based on `coalition_stability` (defaults to $0.50$, or $50\%$).
  * **Banned Parties:** Inflict a daily Political Power penalty based on their popularity multiplied by `banned_party_penalty_factor` (defaults to $-0.50$, meaning a banned party with $20\%$ popularity causes $-0.10$ daily PP loss).
* **Automatic Safety Interlocks:**
  * **Ruling Party Changes:** If a junior coalition partner or a banned party becomes the new Ruling Party (via `set_politics`), `on_ruling_party_change` automatically removes them from the coalition list or unbans them so a ruling party is never listed as its own junior partner or as banned.
  * **Banning a Coalition Partner:** If you ban a party that is currently in your coalition, the system automatically kicks them out of the coalition first before banning them.
  * **Coalition Protection:** A banned party cannot be added to a coalition unless you unban it first. Likewise, you cannot ban your current Ruling Party.

---

## 2. Managing Coalitions (Scripted Effects)

### A. Adding a Party to a Coalition

You can add coalition partners using either the **One-Line Shorthand** (recommended for history files, events, and console testing) or the **Temp Variable Method**.

**Method 1: One-Line Shorthand**
```paradox
# Add Social Democracy and Progressivism to the coalition
add_coalition_social_democracy = yes
add_coalition_progressivism = yes
```

**Method 2: Temp Variable Method**
```paradox
set_temp_variable = { coalition_partner_var = token:social_democracy }
add_to_coalition = yes

set_temp_variable = { coalition_partner_var = token:progressivism }
add_to_coalition = yes
```

### B. Removing a Single Party from a Coalition

If a junior partner walks out of the government while the rest of the coalition stays intact:

**Method 1: One-Line Shorthand**
```paradox
remove_coalition_progressivism = yes
```

**Method 2: Temp Variable Method**
```paradox
set_temp_variable = { coalition_partner_var = token:progressivism }
remove_from_coalition = yes
```

### C. Dissolving the Entire Coalition

To collapse the entire coalition at once (removing all junior partners and clearing coalition PP bonuses):

```paradox
end_coalition = yes
```

---

## 3. Managing Banned Parties (Scripted Effects)

### A. Banning a Party

When you ban a party, it is marked with the banned graphic in the Politics tab, kicked out of any active coalition, and begins applying a daily Political Power penalty proportional to its remaining popularity.

**Method 1: One-Line Shorthand**
```paradox
# Ban Communism and Ultranationalism
ban_party_communism = yes
ban_party_ultranationalism = yes
```

**Method 2: Temp Variable Method**
```paradox
set_temp_variable = { banned_party_var = token:communism }
ban_party = yes
```

### B. Unbanning a Single Party

**Method 1: One-Line Shorthand**
```paradox
unban_party_communism = yes
```

**Method 2: Temp Variable Method**
```paradox
set_temp_variable = { banned_party_var = token:communism }
unban_party = yes
```

### C. Unbanning All Parties at Once

To legalize all banned political parties at once (for example, after a democratic transition or amnesty bill):

```paradox
unban_all_parties = yes
```

---

## 4. Customizing Multipliers & PP Mapping

### A. Adjusting Coalition Stability ($50\%$ Default)

By default, `coalition_stability` is set to $0.50$. The daily Political Power bonus from coalition partners is calculated as:

$$\text{Coalition PP Gain} = \left(\sum \text{Partner Popularity}\right) \times \text{coalition\_stability}$$

You can modify `coalition_stability` in any event, focus, or decision:

```paradox
# Set a highly unified coalition (partners contribute 75% of their popularity)
set_variable = { coalition_stability = 0.75 }
update_coalition_pp_gain = yes

# Or increase/decrease existing coalition stability by +10%
add_to_variable = { coalition_stability = 0.10 }
clamp_variable = {
	var = coalition_stability
	min = 0.0
	max = 1.0
}
update_coalition_pp_gain = yes
```

### B. Adjusting Banned Party Penalty Factor ($-50\%$ Default)

By default, `banned_party_penalty_factor` is set to $-0.50$. The daily Political Power penalty from banned parties is calculated as:

$$\text{Banned PP Loss} = \left(\sum \text{Banned Party Popularity}\right) \times \text{banned\_party\_penalty\_factor}$$

You can make banned parties more or less punishing for a specific country (e.g., via a secret police spirit or martial law):

```paradox
# Reduce the PP penalty from banned parties to -25% of their popularity
set_variable = { banned_party_penalty_factor = -0.25 }
update_coalition_pp_gain = yes

# Increase the PP penalty from banned parties to -75% of their popularity
set_variable = { banned_party_penalty_factor = -0.75 }
update_coalition_pp_gain = yes
```

### C. Advanced Ruling Party Popularity Controls

* **Add popularity to the current Ruling Party:**
  ```paradox
  # Accepts whole percentages (e.g., 5 for +5%) or decimals (0.05)
  set_temp_variable = { ideology_change_var = 5 }
  change_ruling_party_popularity = yes
  ```
* **Map PP Gain to a Different Ideology** (if a shadow/puppet party controls the state behind the scenes):
  ```paradox
  set_variable = { political_power_ideology = token:oligarchism }
  map_party_popularity_PP_gain_to_ideology = yes
  ```
* **Restore Default Ruling Party PP Gain:**
  ```paradox
  default_party_popularity_PP_gain = yes
  ```
* **Disable Popularity PP Gain Entirely** (e.g., during anarchy or total collapse):
  ```paradox
  disable_party_popularity_PP_gain = yes
  ```

---

## 5. Checking Coalitions & Banned Parties in Triggers

Use these checks inside `trigger = { ... }`, `available = { ... }`, or `if = { limit = { ... } }` blocks.

### A. Check if the Country Has Any Active Coalition
```paradox
trigger = {
	check_variable = { coalition_partners^num > 0 }
}
```
Or check if the country is governing alone without coalition partners:
```paradox
trigger = {
	NOT = { check_variable = { coalition_partners^num > 0 } }
}
```

### B. Check if a Specific Ideology is in the Coalition
```paradox
trigger = {
	has_variable = is_in_coalition_with_@token:social_democracy
}
```

### C. Check if an Ideology is Either Ruling OR in the Coalition
```paradox
trigger = {
	OR = {
		has_government = social_democracy
		has_variable = is_in_coalition_with_@token:social_democracy
	}
}
```

### D. Check if Any Party is Banned / Check if a Specific Party is Banned
```paradox
# Check if at least one party is currently banned
trigger = {
	check_variable = { banned_parties^num > 0 }
}

# Check if Communism is currently banned
trigger = {
	has_variable = is_banned_party_@token:communism
}
```

### E. Check Combined Coalition Popularity Threshold
Because `coalition_ruling_combined_pop` stores the total popularity of the Ruling Party + all Coalition Partners on a $0.00$ to $1.00$ scale, you can check if the government coalition holds a majority ($> 50\%$):
```paradox
trigger = {
	check_variable = { coalition_ruling_combined_pop > 0.50 }
}
```

---

## 6. Complete Command Reference for All $13$ Ideologies

* **Communism** (`token:communism`)
  * Add to Coalition: `add_coalition_communism = yes`
  * Remove from Coalition: `remove_coalition_communism = yes`
  * Ban Party: `ban_party_communism = yes`
  * Unban Party: `unban_party_communism = yes`
* **Socialism** (`token:socialism`)
  * Add to Coalition: `add_coalition_socialism = yes`
  * Remove from Coalition: `remove_coalition_socialism = yes`
  * Ban Party: `ban_party_socialism = yes`
  * Unban Party: `unban_party_socialism = yes`
* **Social Democracy** (`token:social_democracy`)
  * Add to Coalition: `add_coalition_social_democracy = yes`
  * Remove from Coalition: `remove_coalition_social_democracy = yes`
  * Ban Party: `ban_party_social_democracy = yes`
  * Unban Party: `unban_party_social_democracy = yes`
* **Progressivism** (`token:progressivism`)
  * Add to Coalition: `add_coalition_progressivism = yes`
  * Remove from Coalition: `remove_coalition_progressivism = yes`
  * Ban Party: `ban_party_progressivism = yes`
  * Unban Party: `unban_party_progressivism = yes`
* **Centrism** (`token:centrism`)
  * Add to Coalition: `add_coalition_centrism = yes`
  * Remove from Coalition: `remove_coalition_centrism = yes`
  * Ban Party: `ban_party_centrism = yes`
  * Unban Party: `unban_party_centrism = yes`
* **Liberalism** (`token:liberalism`)
  * Add to Coalition: `add_coalition_liberalism = yes`
  * Remove from Coalition: `remove_coalition_liberalism = yes`
  * Ban Party: `ban_party_liberalism = yes`
  * Unban Party: `unban_party_liberalism = yes`
* **Conservatism** (`token:conservatism`)
  * Add to Coalition: `add_coalition_conservatism = yes`
  * Remove from Coalition: `remove_coalition_conservatism = yes`
  * Ban Party: `ban_party_conservatism = yes`
  * Unban Party: `unban_party_conservatism = yes`
* **National Democracy** (`token:national_democracy`)
  * Add to Coalition: `add_coalition_national_democracy = yes`
  * Remove from Coalition: `remove_coalition_national_democracy = yes`
  * Ban Party: `ban_party_national_democracy = yes`
  * Unban Party: `unban_party_national_democracy = yes`
* **Traditionalism** (`token:traditionalism`)
  * Add to Coalition: `add_coalition_traditionalism = yes`
  * Remove from Coalition: `remove_coalition_traditionalism = yes`
  * Ban Party: `ban_party_traditionalism = yes`
  * Unban Party: `unban_party_traditionalism = yes`
* **Authoritarianism** (`token:authoritarianism`)
  * Add to Coalition: `add_coalition_authoritarianism = yes`
  * Remove from Coalition: `remove_coalition_authoritarianism = yes`
  * Ban Party: `ban_party_authoritarianism = yes`
  * Unban Party: `unban_party_authoritarianism = yes`
* **Ultranationalism** (`token:ultranationalism`)
  * Add to Coalition: `add_coalition_ultranationalism = yes`
  * Remove from Coalition: `remove_coalition_ultranationalism = yes`
  * Ban Party: `ban_party_ultranationalism = yes`
  * Unban Party: `unban_party_ultranationalism = yes`
* **Esotericism** (`token:esotericism`)
  * Add to Coalition: `add_coalition_esotericism = yes`
  * Remove from Coalition: `remove_coalition_esotericism = yes`
  * Ban Party: `ban_party_esotericism = yes`
  * Unban Party: `unban_party_esotericism = yes`
* **Oligarchism** (`token:oligarchism`)
  * Add to Coalition: `add_coalition_oligarchism = yes`
  * Remove from Coalition: `remove_coalition_oligarchism = yes`
  * Ban Party: `ban_party_oligarchism = yes`
  * Unban Party: `unban_party_oligarchism = yes`

---

## 7. Practical Examples

### Example 1: Setting Up Starting Coalitions & Banned Parties in `history/countries/`
Always place your coalition and ban effects **after** `set_popularities` and `set_politics`:

```paradox
set_popularities = {
	communism = 12
	socialism = 8
	social_democracy = 14
	progressivism = 18
	liberalism = 28
	conservatism = 20
}

set_politics = {
	ruling_party = liberalism
	last_election = "1934.5.12"
	election_frequency = 48
	elections_allowed = yes
}

# Form a Center-Left Coalition with Progressivism and Social Democracy
add_coalition_progressivism = yes
add_coalition_social_democracy = yes

# Outlaw the Communist party at game start
ban_party_communism = yes
```

### Example 2: Election Event Replacing the Government Coalition
When an election changes the Ruling Party, call `end_coalition = yes` first, then `set_politics`, and then add the new coalition partners:

```paradox
country_event = {
	id = mod_elections.1
	title = mod_elections.1.t
	desc = mod_elections.1.d
	is_triggered_only = yes

	# Option A: Left-Wing Popular Front wins
	option = {
		name = mod_elections.1.a
		end_coalition = yes
		set_politics = {
			ruling_party = social_democracy
			elections_allowed = yes
		}
		unban_party_communism = yes
		add_coalition_socialism = yes
		add_coalition_progressivism = yes
	}

	# Option B: Right-Wing Coalition wins and bans leftist parties
	option = {
		name = mod_elections.1.b
		end_coalition = yes
		set_politics = {
			ruling_party = conservatism
			elections_allowed = yes
		}
		add_coalition_national_democracy = yes
		add_coalition_traditionalism = yes
		ban_party_communism = yes
		ban_party_socialism = yes
	}
}
```

### Example 3: Console Commands (`~`) for Quick In-Game Testing
You can test any coalition or party ban live in-game using the console:
* `effect add_coalition_social_democracy = yes`
* `effect remove_coalition_social_democracy = yes`
* `effect end_coalition = yes`
* `effect ban_party_communism = yes`
* `effect unban_party_communism = yes`
* `effect unban_all_parties = yes`