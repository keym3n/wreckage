local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)
function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

minetest.register_node("wreckage:stone_with_berillium", {
	description = S("Berillium Ore"),
	
	sounds = default.node_sound_metal_defaults(),
	tiles = {"default_stone.png^berillium_ore.png"},
	groups = {cracky = 1, level = 2},
	drop = "wreckage:berillium_lump",
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_ore({
	ore_type       = "scatter",
	ore            = "wreckage:stone_with_berillium",
	wherein        = "default:stone",
	clust_scarcity = 20 * 20 * 20,
	clust_num_ores = 4,
	clust_size     = 4,
	y_max          = -264,
	y_min          = -31000,
})
minetest.register_craftitem("wreckage:berillium_lump", {
	description = S("Berillium lump"),
	inventory_image = "berillium_lump.png",
})

minetest.register_craftitem("wreckage:detonar_ingot", {
	description = S("Detonar ingot"),
	inventory_image = "detonar_ingot.png",
})

minetest.register_node("wreckage:berillium_block", {
	description = S("Berillium block"),
  	tiles = {"berillium_block.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "wreckage:berillium_block",
	sounds = default.node_sound_metal_defaults(),
	on_blast = function(pos)
		local drops ={'wreckage:detonar_ingot'}
		minetest.remove_node(pos)
		return drops
	end,
})
minetest.register_node("wreckage:detonar_block", {
	description = S("Detonar block"),
  	tiles = {"detonar_block.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "wreckage:detonar_block",
	sounds = default.node_sound_metal_defaults(),
	on_blast = function(pos)
		tnt.boom(pos,{radius = 4, damage_radius = 2})
	end,
})
minetest.register_node("wreckage:titanium_block", {
	description = S("Titanium block"),
  	tiles = {"titanium_block.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "wreckage:titanium_block",
	sounds = default.node_sound_metal_defaults(),
	on_blast = function(pos)
		local drops ={'wreckage:titanium_block'}
		minetest.remove_node(pos)
		return drops
	end,
})

local block_list = {"hematite","peridot","carnelian"}
for _, material in ipairs(block_list) do 
	minetest.register_node("wreckage:"..material .."_block", {
	description = S(firstToUpper(material).." block"),
  	tiles = {material.."_block.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "wreckage:"..material .."_block",
	sounds = {
		footstep = {name = "cristall", gain = 0.1},
		dig = {name = "cristall", gain = 0.4},
		place = {name = "cristall", gain = 0.2},
	},
	on_blast = function(pos)
		local drops ={"wreckage:"..material .."_block"}
		minetest.remove_node(pos)
		return drops
	end,
})
end
minetest.register_node('wreckage:dense_ice',{
	description = S('Dense ice'),
	tiles = {'dense_ice.png'},
	is_ground_content = false,
	groups = {cracky = 3, cools_lava = 1, slippery = 3},
	sounds = default.node_sound_ice_defaults(),
})
local function my_register_stair_and_slab(subname, recipeitem, groups, images,
		desc_stair, desc_slab, sounds, worldaligntex)
	stairs.register_stair(subname, recipeitem, groups, images, S(desc_stair),
		sounds, worldaligntex)
	stairs.register_stair_inner(subname, recipeitem, groups, images, "",
		sounds, worldaligntex, S("Inner " .. desc_stair))
	stairs.register_stair_outer(subname, recipeitem, groups, images, "",
		sounds, worldaligntex, S("Outer " .. desc_stair))
	stairs.register_slab(subname, recipeitem, groups, images, S(desc_slab),
		sounds, worldaligntex)
end

my_register_stair_and_slab(
	"dense_ice",
	"wreckage:dense_ice",
	{cracky = 3, cools_lava = 1, slippery = 3},
	{"dense_ice.png"},
	"Dense Ice Stair",
	"Dense Ice Slab",
	default.node_sound_ice_defaults(),
	true
)