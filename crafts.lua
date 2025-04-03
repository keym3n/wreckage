local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)
dofile(modpath.. "/melting_furnace.lua")



local group_tab = {}

for name, def in pairs(minetest.registered_nodes) do
    if def.groups and def.groups["wood"] then
        table.insert(group_tab, name)
    end
end
for name, def in pairs(minetest.registered_nodes) do
    for _, wname in ipairs(group_tab) do
      if name:find("slab") and name:find(wname:match(":(.+)$")) then
        minetest.register_craft({
  	output = "wreckage:wood_pickaxe_head",
  	recipe = {
  		{name, "group:wood", name},
  	}
  })
  minetest.register_craft({
  	output = "wreckage:wood_tool_binding",
  	recipe = {
  		{name, "", name},
  		{"",name,""},
  		{name, "", name},
  	}
  })
  minetest.register_craft({
  	output = "wreckage:wood_shovel_head",
  	recipe = {
  		{"stairs:slab_"..name},
  	}
  })
  minetest.register_craft({
  	output = "wreckage:wood_sword_head",
  	recipe = {
  		{name},
  		{"group:wood"},
  	}
  })
      end
    end
end

minetest.register_craft({
	output = "wreckage:wood_tool_rod",
	recipe = {
		{"group:wood"},
		{"group:wood"},
	}
})

minetest.register_craft({
	output = "wreckage:wood_axe_head",
	recipe = {
		{"group:wood", "group:wood", ""},
		{"group:wood","",""},
	}
})
minetest.register_craft({
	output = "wreckage:wood_axe_head",
	recipe = {
		{"", "group:wood", "group:wood"},
		{"","","group:wood"},
	}
})


minetest.register_craft({
	output = "wreckage:wood_hoe_head",
	recipe = {
		{"group:wood","group:wood"},
	}
})

minetest.register_craft({
	output = "wreckage:stone_pickaxe_head",
	recipe = {
		{"stairs:slab_cobble", "default:cobble", "stairs:slab_cobble"},
	}
})
minetest.register_craft({
	output = "wreckage:stone_tool_rod",
	recipe = {
		{"default:cobble"},
		{"default:cobble"},
	}
})
minetest.register_craft({
	output = "wreckage:stone_tool_binding",
	recipe = {
		{"stairs:slab_cobble", "", "stairs:slab_cobble"},
		{"","stairs:slab_cobble",""},
		{"stairs:slab_cobble", "", "stairs:slab_cobble"},
	}
})
minetest.register_craft({
	output = "wreckage:stone_axe_head",
	recipe = {
		{"default:cobble", "default:cobble", ""},
		{"default:cobble","",""},
	}
})
minetest.register_craft({
	output = "wreckage:stone_axe_head",
	recipe = {
		{"", "default:cobble", "default:cobble"},
		{"","","default:cobble"},
	}
})
minetest.register_craft({
	output = "wreckage:stone_shovel_head",
	recipe = {
		{"stairs:slab_cobble"},
	}
})
minetest.register_craft({
	output = "wreckage:stone_hoe_head",
	recipe = {
		{"default:cobble","default:cobble"},
	}
})
minetest.register_craft({
	output = "wreckage:stone_sword_head",
	recipe = {
		{"stairs:slab_cobble"},
		{"default:cobble"},
	}
})



minetest.register_craft({
	output = "wreckage:dense_ice",
	recipe = {
		{"default:ice", "default:ice", "default:ice"},
		{"default:ice","default:ice","default:ice"},
		{"default:ice", "default:ice", "default:ice"},
	}
})

minetest.register_craft({
	output = "wreckage:ice_pickaxe_head",
	recipe = {
		{"stairs:slab_dense_ice", "wreckage:dense_ice", "stairs:slab_dense_ice"},
	}
})
minetest.register_craft({
	output = "wreckage:ice_tool_rod",
	recipe = {
		{"wreckage:dense_ice"},
		{"wreckage:dense_ice"},
	}
})
minetest.register_craft({
	output = "wreckage:ice_tool_binding",
	recipe = {
		{"stairs:slab_dense_ice", "", "stairs:slab_dense_ice"},
		{"","stairs:slab_dense_ice",""},
		{"stairs:slab_dense_ice", "", "stairs:slab_dense_ice"},
	}
})
minetest.register_craft({
	output = "wreckage:ice_axe_head",
	recipe = {
		{"wreckage:dense_ice", "wreckage:dense_ice", ""},
		{"wreckage:dense_ice","",""},
	}
})
minetest.register_craft({
	output = "wreckage:ice_axe_head",
	recipe = {
		{"", "wreckage:dense_ice", "wreckage:dense_ice"},
		{"","","wreckage:dense_ice"},
	}
})
minetest.register_craft({
	output = "wreckage:ice_shovel_head",
	recipe = {
		{"stairs:slab_dense_ice"},
	}
})
minetest.register_craft({
	output = "wreckage:ice_hoe_head",
	recipe = {
		{"wreckage:dense_ice","wreckage:dense_ice"},
	}
})
minetest.register_craft({
	output = "wreckage:ice_sword_head",
	recipe = {
		{"stairs:slab_dense_ice"},
		{"wreckage:dense_ice"},
	}
})


minetest.register_craft({
	output = "wreckage:apple_pickaxe_head",
	recipe = {
		{"stairs:slab_wood", "default:tree", "stairs:slab_wood"},
	}
})
minetest.register_craft({
	output = "wreckage:apple_tool_rod",
	recipe = {
		{"default:tree"},
		{"default:tree"},
	}
})
minetest.register_craft({
	output = "wreckage:apple_tool_binding",
	recipe = {
		{"stairs:slab_wood", "", "stairs:slab_wood"},
		{"","stairs:slab_wood",""},
		{"stairs:slab_wood", "", "stairs:slab_wood"},
	}
})
minetest.register_craft({
	output = "wreckage:apple_axe_head",
	recipe = {
		{"default:tree", "default:tree", ""},
		{"default:tree","",""},
	}
})
minetest.register_craft({
	output = "wreckage:apple_axe_head",
	recipe = {
		{"", "default:tree", "default:tree"},
		{"","","default:tree"},
	}
})
minetest.register_craft({
	output = "wreckage:apple_shovel_head",
	recipe = {
		{"stairs:slab_wood"},
	}
})
minetest.register_craft({
	output = "wreckage:apple_hoe_head",
	recipe = {
		{"default:tree","default:tree"},
	}
})
minetest.register_craft({
	output = "wreckage:apple_sword_head",
	recipe = {
		{"stairs:slab_wood"},
		{"default:tree"},
	}
})
local material_list = {
	
	}
if minetest.get_modpath("bonemeal") then
	table.insert(material_list,{mat ="bonemeal:bone", name = "bone"})
end
if minetest.get_modpath("amethyst_new") then
	table.insert(material_list,{mat ="amethyst_new:amethyst", name = "amethyst"})
end
for _,material in ipairs(material_list) do
	minetest.register_craft({
	output = "wreckage:".. material.name .."_pickaxe_head",
	recipe = {
		{material.mat, material.mat, material.mat},
	}
	})
	minetest.register_craft({
		output = "wreckage:".. material.name .."_tool_rod",
		recipe = {
			{material.mat},
			{material.mat},
		}
	})
	minetest.register_craft({
		output = "wreckage:".. material.name .."_tool_binding",
		recipe = {
			{material.mat, ""},
			{"",material.mat},
			
		}
	})
		minetest.register_craft({
		output = "wreckage:".. material.name .."_tool_binding",
		recipe = {
			{"",material.mat},
			{material.mat, ""},

		}
	})
	minetest.register_craft({
		output = "wreckage:".. material.name .."_axe_head",
		recipe = {
			{material.mat, material.mat, ""},
			{material.mat,"",""},
		}
	})
	minetest.register_craft({
		output = "wreckage:".. material.name .."_axe_head",
		recipe = {
			{"", material.mat, material.mat},
			{"","",material.mat},
		}
	})
	minetest.register_craft({
		output = "wreckage:".. material.name .."_shovel_head",
		recipe = {
			{material.mat},
		}
	})
	minetest.register_craft({
		output = "wreckage:".. material.name .."_hoe_head",
		recipe = {
			{material.mat,material.mat},
		}
	})
	minetest.register_craft({
		output = "wreckage:".. material.name .."_sword_head",
		recipe = {
			{material.mat},
			{material.mat},
			{material.mat},
		}
	})
end
minetest.register_craft({
  type = "cooking",
  output = "wreckage:berillium_ingot",
  recipe = "wreckage:berillium_lump",
  cooktime = 10
});
minetest.register_craft({
	output = "wreckage:berillium_block",
	recipe = {
		{"wreckage:berillium_ingot", "wreckage:berillium_ingot", "wreckage:berillium_ingot"},
		{"wreckage:berillium_ingot","wreckage:berillium_ingot","wreckage:berillium_ingot"},
		{"wreckage:berillium_ingot", "wreckage:berillium_ingot", "wreckage:berillium_ingot"},
	}
})
local ingot_list = {"titanium","berillium"}
for _,material in ipairs(ingot_list) do
	minetest.register_craftitem('wreckage:'.. material ..'_ingot',{
	  description = S(material:gsub("^%l", string.upper) ..' ingot'),
	  inventory_image = material ..'_ingot.png'
	})
end
local list_defect = {'default:steel_ingot','default:gold_ingot','wreckage:berillium_ingot',"wreckage:titanium_ingot",}
if minetest.get_modpath("moreores") then
	for _, value in ipairs({"moreores:silver_ingot","moreores:mithril_ingot"}) do
    table.insert(list_defect, value)
	end
end
for _,defect in ipairs(list_defect) do
	minetest.register_craft({
		type = "shapeless",
	  output = defect,
	  recipe = {
			"wreckage:defected_" .. defect:match(":(.*)$"),
			"wreckage:defected_" .. defect:match(":(.*)$"),
			
		}
	})
end



minetest.register_craft({
	output = "wreckage:repair_tool",
	recipe = {
		{"wreckage:titanium_ingot","wreckage:titanium_ingot","wreckage:titanium_ingot"},
		{"wreckage:titanium_ingot","default:stick","wreckage:titanium_ingot"},
		{"","default:stick",""}
	}
})
minetest.register_craft({
	output = "dye:green",
	recipe = {
		{"wreckage:peridot"},
	}
})
minetest.register_craft({
	output = "dye:red",
	recipe = {
		{"wreckage:hematite"},
	}
})
minetest.register_craft({
	output = "dye:orange",
	recipe = {
		{"wreckage:carnelian"},
	}
})