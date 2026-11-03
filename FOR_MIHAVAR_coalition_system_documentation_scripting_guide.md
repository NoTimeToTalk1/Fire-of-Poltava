# Coalition System Scripting Guide

This guide explains how to use the coalition system in your mod's history files, events, national focuses, and decisions.

---

## 1. Core Concepts & Rules

* **Ruling Party vs. Coalition Partners:** A country always has one primary **Ruling Party** (set via `set_politics`). Any other ideology added to the coalition becomes a **Coalition Partner**.
* **UI Highlight:** In the Politics tab, the Ruling Party uses its normal highlight bar, while any active Coalition Partner displays the secondary coalition highlight bar (`GFX_coalition_pol_party_bg`) behind its party name.
* **Topbar Popularity & Political Power:** Coalition partners contribute a portion of their party popularity (determined by `coalition_stability`, which defaults to $0.50$ or $50\%$) toward your Ruling Party's effective popularity and daily Political Power gain.
* **Ruling Party Changes:** Calling `set_politics = { ruling_party = ... }` will automatically clear the existing coalition (via `on_ruling_party_change`), or if the new ruling party was previously a junior coalition partner, remove it from the partner list. **Always add coalition partners *after* calling `set_politics`.**

---

## 2. Basic Scripted Effects

### A. Adding Ideologies to a Coalition
To add a party to the current government's coalition, set the temporary variable `coalition_partner_var` to the ideology's `token:` and run `add_to_coalition = yes`.

```paradox
# Add a single ideology to the coalition
set_temp_variable = { coalition_partner_var = token:social_democracy }
add_to_coalition = yes
```

To add multiple parties at once, repeat the two lines for each ideology:

```paradox
# Add Social Democracy and Progressivism to a coalition
set_temp_variable = { coalition_partner_var = token:social_democracy }
add_to_coalition = yes

set_temp_variable = { coalition_partner_var = token:progressivism }
add_to_coalition = yes
```

> **Note:** If you accidentally try to add the current `ruling_party` or an ideology that is already in the coalition, the scripted effect will safely ignore it so duplicates cannot occur.

---

### B. Removing a Single Ideology from a Coalition
If a junior partner walks out of the government but the rest of the coalition remains intact, set `coalition_partner_var` and run `remove_from_coalition = yes`:

```paradox
# Remove Progressivism from the coalition
set_temp_variable = { coalition_partner_var = token:progressivism }
remove_from_coalition = yes
```

---

### C. Dissolving the Entire Coalition
To collapse or end the entire coalition at once (removing all junior partners and resetting coalition Political Power bonuses), use:

```paradox
# Dissolve the entire coalition
end_coalition = yes
```

---

## 3. Adjusting Coalition Stability (PP Gain Ratio)

By default, coalition partners contribute **$50\%$** ($0.50$) of their party popularity toward the government's Political Power gain:

$$\text{Effective Popularity} = \text{Ruling Party Popularity} + \left(\sum \text{Partner Popularity} \times \text{Coalition Stability}\right)$$

You can customize how cohesive a country's coalition is by changing the `coalition_stability` variable on the country scope:

```paradox
# Set a highly unified coalition (partners give 75% of their popularity)
set_variable = { coalition_stability = 0.75 }

# Or increase/decrease existing coalition stability
add_to_variable = { coalition_stability = 0.10 }
clamp_variable = {
	var = coalition_stability
	min = 0.0
	max = 1.0
}
```

---

## 4. Scripted Triggers (Checking Coalitions)

Use these triggers inside `trigger = { ... }`, `available = { ... }`, or `if = { limit = { ... } }` blocks in events, focuses, and decisions.

### A. Check if the Country Has Any Coalition
```paradox
trigger = {
	has_coalition = yes
}
```
Or to check that the country is governing alone without partners:
```paradox
trigger = {
	has_coalition = no
}
```

### B. Check if a Specific Ideology is a Coalition Partner
```paradox
trigger = {
	set_temp_variable = { coalition_partner_var = token:social_democracy }
	is_in_coalition_with = yes
}
```

### C. Check if an Ideology is Either Ruling OR in the Coalition
If a focus or decision should be available whenever an ideology is part of the government (whether as the main Ruling Party or as a junior Coalition Partner):

```paradox
trigger = {
	OR = {
		has_government = social_democracy
		AND = {
			set_temp_variable = { coalition_partner_var = token:social_democracy }
			is_in_coalition_with = yes
		}
	}
}
```

---

## 5. Practical Examples & Use Cases

### Example 1: Setting Up a Starting Coalition in `history/countries/`
In a country history file (e.g., `history/countries/UKR - Ukraine.txt`), always define `set_popularities` and `set_politics` **first**, and then add your coalition partners afterward:

```paradox
set_popularities = {
	liberalism = 28
	progressivism = 18
	social_democracy = 14
	conservatism = 25
	authoritarian_democracy = 15
}

set_politics = {
	ruling_party = liberalism
	last_election = "1934.5.12"
	election_frequency = 48
	elections_allowed = yes
}

# Form starting Center-Left Coalition
set_temp_variable = { coalition_partner_var = token:progressivism }
add_to_coalition = yes

set_temp_variable = { coalition_partner_var = token:social_democracy }
add_to_coalition = yes
```

---

### Example 2: Election Event Changing the Government & Forming a New Coalition
Because `set_politics` clears the old coalition, build the new coalition immediately after `set_politics` inside your event option:

```paradox
country_event = {
	id = poltava.10
	title = poltava.10.t
	desc = poltava.10.d
	is_triggered_only = yes

	# Option A: Social Democrats win and form a Popular Front
	option = {
		name = poltava.10.a
		set_politics = {
			ruling_party = social_democracy
			elections_allowed = yes
		}
		set_temp_variable = { coalition_partner_var = token:progressivism }
		add_to_coalition = yes
		set_temp_variable = { coalition_partner_var = token:libertarian_socialism }
		add_to_coalition = yes
	}

	# Option B: Conservatives win a majority and govern alone
	option = {
		name = poltava.10.b
		 end_coalition = yes
		set_politics = {
			ruling_party = conservatism
			elections_allowed = yes
		}
	}
}
```

---

### Example 3: Coalition Crisis / Junior Partner Walkout Event
When a partner leaves the coalition, you often want to pair `remove_from_coalition = yes` with a Political Power or Stability hit:

```paradox
country_event = {
	id = poltava.15
	title = poltava.15.t
	desc = poltava.15.d
	is_triggered_only = yes

	trigger = {
		set_temp_variable = { coalition_partner_var = token:progressivism }
		is_in_coalition_with = yes
	}

	option = {
		name = poltava.15.a
		set_temp_variable = { coalition_partner_var = token:progressivism }
		remove_from_coalition = yes
		add_stability = -0.05
		add_political_power = -50
	}
}
```

---

### Example 4: Boosting All Current Coalition Partners in a Focus
If you want a National Focus to give $+3\%$ popularity to every junior partner currently in the player's coalition, iterate over the `coalition_partners` array:

```paradox
completion_reward = {
	# Boost the ruling party by 5%
	add_popularity = {
		ideology = var:current_party_ideology_group
		popularity = 0.05
	}
	# Boost every junior coalition partner by 3%
	for_each_loop = {
		array = coalition_partners
		value = v
		add_popularity = {
			ideology = var:v
			popularity = 0.03
		}
	}
}
```

---

## 6. Quick Troubleshooting Checklist

1. **Always use `token:`** when setting `coalition_partner_var` (e.g., `token:social_democracy`, not just `social_democracy`).
2. **Double-check ideology spelling:** The token name must exactly match the top-level ideology key in `common/ideologies/00_ideologies.txt` (not a sub-ideology key).
3. **Order of operations with `set_politics`:** Always put `add_to_coalition = yes` *after* `set_politics`, never before it.
4. **Adding popularity:** When you use `add_popularity` in an event or focus, the coalition Political Power bonus updates automatically on the next daily tick, or immediately if `recalculate_party_popularity_pp_gain = yes` is called at the end of your effect.