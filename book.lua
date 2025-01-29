local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)
-- Регистрация книги
guideBooks.Common.register_guideBook("wreckage:my_guidebook", {
    description_short = S("The Blacksmith's Handbook"),
    description_long = S("About working with blacksmithing"),
    inventory_image = "wreckage_book.png",
    wield_image = "wreckage_book.png",
    style = {
        cover = {
            w = 6,
            h = 8,
            bg = "wreckage_cover.png",
            next = "wreckage_next.png"
        },
        page = {
            w = 12,
            h = 8,
            bg = "wreckage_cover2.png",
            next = "wreckage_next.png",
            prev = "wreckage_prev.png",
            start = "wreckage_start.png",
            textcolor = "white",
            label_textcolor = "white"
        },
        buttonGeneric = "wreckage_button.png",
    },
    pad_type = false,
    droppable = true
})

-- Добавление раздела
guideBooks.Common.register_section("wreckage:my_guidebook", "tutorial", {
    description = S("Introduction"),
})
-- Добавление страниц в раздел
guideBooks.Common.register_page("wreckage:my_guidebook", "tutorial", 1, {
    textcolor = "brown",
    text1 = S("Wreckage is a mod where you become a blacksmith. You'll have to work with various resources: wood, steel, gold, and you'll have to combine them to find the best tool for you!").."\n\n"..S("The main idea of the mod is to implement a variety of gameplay in terms of creating multifunctional tools."),
    text2 = S("The main place where tool parts originate is the anvil. Every time you create a new piece of a future tool, you gain experience in blacksmithing.").."\n\n"..S("Tinker's Construct, Axistools and Simple anvil served as the basis for creating this mod.")
})
guideBooks.Common.register_section("wreckage:my_guidebook", "material", {
    description = S("Materials"),
    master=1
})

guideBooks.Common.register_section("wreckage:my_guidebook", "ingot", {
    description = S("Metals"),
    slave = "material"
})
guideBooks.Common.register_page("wreckage:my_guidebook", "ingot", 1, {
    textcolor = "brown",
    text1 = S("Iron is a metal whose rocks are among the most common materials in the cubic world. Due to quenching, it acquires hardness.").."\n"..S("Property - Strengthening (increases strength by 10 units). Suitable for all tools").."\n"..S("Strength").." - 30\n"..S("Mining level").." - 2\n"..S("Damage").." - 6",
    text2 = S("Gold is a metal that has a strange property in which the resources it mines drop more than other types of materials.").."\n"..S("Property - Golden Luck (3% chance of dropping extra loot). Suitable for all tools except hoe.").."\n"..S("Strength").." - 10\n"..S("Mining level").." - 1\n"..S("Damage").." - 2",
    extra = "item_image[0.5,7;1,1;default:steel_ingot]" .. "item_image[1.5,7;1,1;wreckage:steel_ingot_pickaxe_head]" .."item_image[2.5,7;1,1;wreckage:steel_ingot_tool_binding]".."item_image[3.5,7;1,1;wreckage:steel_ingot_tool_rod]"..  "item_image[6.5,7;1,1;default:gold_ingot]" .. "item_image[7.5,7;1,1;wreckage:gold_ingot_pickaxe_head]" .."item_image[8.5,7;1,1;wreckage:gold_ingot_tool_binding]".."item_image[9.5,7;1,1;wreckage:gold_ingot_tool_rod]"
})
guideBooks.Common.register_page("wreckage:my_guidebook", "ingot", 2, {
    textcolor = "brown",
    text1 = S("Berillium is a metal whose rocks are rare but valuable materials. It's hard, but brittle.").."\n"..S("Property - Fragility (there is some chance of losing additional strength during use). Suitable for all tools.").."\n"..S("Strength").." - 52\n"..S("Mining level").." - 2\n"..S("Damage").." - 6\n"..S("Method of obtaining - Mining."),    
    text2 = S("Titanium is a material that is depleted from constant use.").."\n"..S("Property - Degradation(the more wear and tear a tool has, the slower it mines). Suitable only for picks, shovels and axes.").."\n"..S("Strength").." - 48\n"..S("Mining level").." - 2\n"..S("Damage").." - 9\n"..S("The method of production is created in a mixer."),
    extra = "item_image[0.5,7;1,1;wreckage:berillium_ingot]" .. "item_image[1.5,7;1,1;wreckage:berillium_ingot_pickaxe_head]" .."item_image[2.5,7;1,1;wreckage:berillium_ingot_tool_binding]".."item_image[3.5,7;1,1;wreckage:berillium_ingot_tool_rod]"..  "item_image[6.5,7;1,1;wreckage:titanium_ingot]" .. "item_image[7.5,7;1,1;wreckage:titanium_ingot_pickaxe_head]" .."item_image[8.5,7;1,1;wreckage:titanium_ingot_tool_binding]".."item_image[9.5,7;1,1;wreckage:titanium_ingot_tool_rod]"
})
guideBooks.Common.register_page("wreckage:my_guidebook", "ingot", 3,{
    textcolor = "brown",
    text1 = S("A detonar is a material that is unstable in its origin.").."\n"..S("Property - Explosion(When the block is broken, it produces an explosion, which depends on the amount of it in the tool.) Suitable for all tools.").."\n"..S("Strength").." - 30\n"..S("Mining level").." - 2\n"..S("Damage").." - 6\n"..S("Method of obtaining - Detonate the berillium block."),
    extra = "item_image[0.5,7;1,1;wreckage:detonar_ingot]" .. "item_image[1.5,7;1,1;wreckage:detonar_ingot_pickaxe_head]" .."item_image[2.5,7;1,1;wreckage:detonar_ingot_tool_binding]".."item_image[3.5,7;1,1;wreckage:detonar_ingot_tool_rod]" 
})

guideBooks.Common.register_section("wreckage:my_guidebook", "nonmetal", {
    description = S("Non-metals"),
    slave = "material",
    --hidden=true,
})

guideBooks.Common.register_page("wreckage:my_guidebook", "nonmetal", 1, {
    textcolor = "brown",
    text1 = S("Wood is a material that is fused with similar objects using a special technique, which allows you to spend less money on repairing tools.").."\n"..S("Property - Cheap (less materials to repair). Suitable for all tools.").."\n"..S("Strength").." - 10\n"..S("Mining level").." - 1".."\n"..S("Damage").." - 2",
    text2 = S("Stone is an available material at the initial stage. It is a relatively hard rock found everywhere.") .. "\n".. S("Property - Stoneborn(5% chance to mine additional stone). Suitable for pickaxe only.").."\n"..S("Strength").." - 20\n"..S("Mining level").." - 1\n"..S("Damage").." - 3",
    extra = "item_image[0.5,7;1,1;default:wood]" .. "item_image[1.5,7;1,1;wreckage:wood_pickaxe_head]" .."item_image[2.5,7;1,1;wreckage:wood_tool_binding]".."item_image[3.5,7;1,1;wreckage:wood_tool_rod]"..  "item_image[6.5,7;1,1;default:stone]" .. "item_image[7.5,7;1,1;wreckage:stone_pickaxe_head]" .."item_image[8.5,7;1,1;wreckage:stone_tool_binding]".."item_image[9.5,7;1,1;wreckage:stone_tool_rod]"
})
guideBooks.Common.register_page("wreckage:my_guidebook", "nonmetal", 2, {
    textcolor = "brown",
    text1 = S("Dense ice is a material that has greater strength due to compression.").."\n"..S("Property - Regelation (5% chance to restore the tool's strength). Suitable for all tools except hoe.").."\n"..S("Strength").." - 25\n"..S("Mining level").." - 1\n"..S("Damage").." - 4\n"..S("Method of obtaining - created in the workbench from 9 ordinary ice"),
    text2 = S("An apple tree is a material that can find an apple in any foliage.").."\n"..S("Property - Picking (10% chance of an apple falling out when harvesting foliage).").."\n"..S("Strength").." - 10\n"..S("Mining level").." - 1\n"..S("Damage").." - 2",
    extra = "item_image[0.5,7;1,1;wreckage:dense_ice]" .. "item_image[1.5,7;1,1;wreckage:ice_pickaxe_head]" .."item_image[2.5,7;1,1;wreckage:ice_tool_binding]".."item_image[3.5,7;1,1;wreckage:ice_tool_rod]" .. "item_image[6.5,7;1,1;default:wood]" .. "item_image[7.5,7;1,1;wreckage:apple_pickaxe_head]" .."item_image[8.5,7;1,1;wreckage:apple_tool_binding]".."item_image[9.5,7;1,1;wreckage:apple_tool_rod]" 
})
if minetest.get_modpath("amethyst_new") then
    guideBooks.Common.register_page("wreckage:my_guidebook", "nonmetal", 3, {
        textcolor = "brown",
        text1 = S("Amethyst is a material that can be found in geodes.").."\n"..S("Property - Shards (with a certain chance, crystals will drop from certain blocks, which can be used to modify the tools).").."\n"..S("Strength").." - 30\n"..S("Mining level").." - 2\n"..S("Damage").." - 6\n" .. S("Iron Ore -> Hematite") .."\n"..S("Ores -> Carnelian").."\n"..S("Tree -> Peridot"),
        extra = "item_image[0.5,7;1,1;amethyst_new:amethyst]" .. "item_image[1.5,7;1,1;wreckage:amethyst_pickaxe_head]" .."item_image[2.5,7;1,1;wreckage:amethyst_tool_binding]".."item_image[3.5,7;1,1;wreckage:amethyst_tool_rod]"
    })
end
if minetest.get_modpath("moreores") then  --страницы связанные с модом moreores
    guideBooks.Common.register_section("wreckage:my_guidebook", "moreores", {
        description = S("Materials from Moreores"),
        slave = "material"
    })
    guideBooks.Common.register_page("wreckage:my_guidebook", "moreores", 1, {
        textcolor = "brown",
        text1 = S("Silver is a precious metal of white color, objects of which affect the evil in a special way.").."\n"..S("Property - Holiness(Increased damage against monsters). Suitable for sword only.").."\n"..S("Strength").." - 27\n"..S("Mining level").." - 1\n"..S("Damage").." - 6",
        text2 = S("Mythril is a fantasy metal known for its super strength and lightness that can enhance the properties of other materials.").."\n"..S("Property - Mythical (able to enhance the properties of other materials). Suitable for all tools.").."\n"..S("Strength").." - 66\n"..S("Mining level").." - 2\n"..S("Damage").." - 9",
        extra = "item_image[0.5,7;1,1;moreores:silver_ingot]" .. "item_image[1.5,7;1,1;wreckage:silver_ingot_pickaxe_head]" .."item_image[2.5,7;1,1;wreckage:silver_ingot_tool_binding]".."item_image[3.5,7;1,1;wreckage:silver_ingot_tool_rod]"..  "item_image[6.5,7;1,1;moreores:mithril_ingot]" .. "item_image[7.5,7;1,1;wreckage:mithril_ingot_pickaxe_head]" .."item_image[8.5,7;1,1;wreckage:mithril_ingot_tool_binding]".."item_image[9.5,7;1,1;wreckage:mithril_ingot_tool_rod]"
    })
end                                     --конец
if minetest.get_modpath("bonemeal") then  --страницы связанные с модом moreores
    guideBooks.Common.register_section("wreckage:my_guidebook", "bonemeal", {
        description = S("Materials from Bonemeal"),
        slave = "material"
    })
    guideBooks.Common.register_page("wreckage:my_guidebook", "bonemeal", 1, {
        textcolor = "brown",
        text1 = S("Bone is a material that becomes sharper over time, allowing you to deal more damage. The hoe has an alternative use in the form of bone meal.").."\n"..S("Property - Serrated (the more wear and tear on the tool, the more damage). Only suitable for swords.").. "\n"..S("Property - Cultivation (accelerates the growth of vegetation). Suitable only for hoe.").."\n"..S("Strength").." - 20\n"..S("Mining level").." - 1\n"..S("Damage").." - 6",
        extra = "item_image[0.5,7;1,1;bonemeal:bone]" .. "item_image[1.5,7;1,1;wreckage:bone_pickaxe_head]" .."item_image[2.5,7;1,1;wreckage:bone_tool_binding]".."item_image[3.5,7;1,1;wreckage:bone_tool_rod]"
    })
end

guideBooks.Common.register_section("wreckage:my_guidebook", "anvil", {     -- Наковальня
    description = S("Anvil"),
})
guideBooks.Common.register_page("wreckage:my_guidebook", "anvil", 1, {
    textcolor = "brown",
    text2 = S("Anvil").."\n\n"..S("The workplace where the main tasks take place: creation, repair and modification of tools. Parts of the tools are created using hot ingots. The first slot is used for hot ingots and tools, the second for modifiers and repair materials."),
    extra = "item_image[1,1.5;5,5;wreckage:anvil]"
    --text1 = "Добро пожаловать в Мою книгу!",
    --"model[1,1;6,4;wreckage:anvil;anvil.obj;2;4]"
})

guideBooks.Common.register_page("wreckage:my_guidebook", "anvil", 2, {
    textcolor = "brown",
    text2 = S("Repair").."\n\n"..S("To repair the tool, you need to put it in the first slot, and put the repair item in the modifier slot.").."\n"..S("No defects are guaranteed during the repair of tools.").."\n\n"..S("Modifications").."\n\n"..S("To modify the tool, you need to put it in the first slot, put the modifier in the modifier slot."),
    extra =  "image[1,2.5;1,1;slot.png^[colorize:#1f1f1f]".."image[3,2.5;1,1;arrow_book.png^[colorize:#1f1f1f]".."image[2,2.5;1,1;slot.png^[colorize:#1f1f1f]".. "image[2,2.5;1,1;m.png]".."image[4,2.5;1,1;slot.png^[colorize:#1f1f1f]"--"image[1,1.5;5,3;gui.png]"
})
guideBooks.Common.register_page("wreckage:my_guidebook", "anvil", 3, {
    textcolor = "brown",
    text2 = S("Brick floor").."\n"..S("If you put an anvil on the ground, you can't make normal tool parts, only defective ingots will be created.").."\n\n"..S("Defective ingot").."\n"..S("Due to trying to create parts under unfavorable conditions or with little experience, defective ingots will be created. These can be remelted and part of the ingot can be reclaimed.").."\n\n"..S("Blacksmith experience").."\n"..S("The anvil interface has an experience bar. When creating parts, the character will accumulate experience. The more experienced the blacksmith is, the less chance to create defective ingots. The maximum level is 10."),
    extra = "item_image[2.5,3;1.5,1.5;default:brick]" ..
        "item_image[1.975,3.3;1.5,1.5;default:brick]" ..
        "item_image[1.45,3.6;1.5,1.5;default:brick]" ..
        "item_image[3.025,3.3;1.5,1.5;default:brick]" ..
        "item_image[3.55,3.6;1.5,1.5;default:brick]" ..
        "item_image[2.5,3.6;1.5,1.5;default:brick]" ..
        "item_image[2.5,3;1.5,1.5;wreckage:anvil]" ..
        "item_image[3.025,3.9;1.5,1.5;default:brick]" ..
        "item_image[1.975,3.9;1.5,1.5;default:brick]" ..
        "item_image[2.5,4.2;1.5,1.5;default:brick]"

})       --Конец
guideBooks.Common.register_section("wreckage:my_guidebook", "melting_furnace", {
    description = S("Melting furnace"),
})
guideBooks.Common.register_page("wreckage:my_guidebook", "melting_furnace", 1, {
    textcolor = "brown",
    text2 = S("Melting furnace").."\n\n"..S("A special block designed to create alloys from two hot ingots. This process allows players to combine different metals and create new materials with unique properties.").."\n\n"..S("Features:").."\n"..S("-The melting furnace can only process hot ingots.").."\n"..S("-If there is lava under the melting furnace, the processing speed increases."),
    extra = "item_image[1,1.5;5,5;wreckage:melting_furnace]"
})

guideBooks.Common.register_page("wreckage:my_guidebook", "melting_furnace", 2, {
    textcolor = "brown",
    text2 = S("Crafts").."\n\n"..S("Titanium is created from 2 hot steel ingots and coal."),
    extra = "image[1,1;1,1;slot.png]".."item_image[1,1;1,1;wreckage:hot_steel]" .. "label[1.6,1.4;2]" .."image[2,1;1,1;slot.png]" .. "item_image[2.05,0.95;1,1;default:coal_lump]" .."image[3,1;1,1;arrow_book.png]" .."image[4,1;1,1;slot.png]".. "item_image[4,1;1,1;wreckage:titanium_ingot]"
})
guideBooks.Common.register_section("wreckage:my_guidebook", "modification", {
    description = S("Modifications"),
})
guideBooks.Common.register_page("wreckage:my_guidebook","modification", 1, {
    textcolor = "brown",
    text1 = S("The diamond adds strength to the tool, strengthening the shoe.").."\n\n"..S("Features:").."\n"..S("-Increases the strength of the tool by 500 units,").."\n"..S("-One-time use."),
    text2 = S("Hematite adds speed to the use of tools.").."\n\n"..S("Features:").."\n"..S("-Increases the speed of block mining and the speed of sword strikes,").."\n"..S("-20 levels,") .. "\n" .. S("-The method of obtaining it is given with a 70% chance when mining iron ore with an amethyst pickaxe."),
    extra = "item_image[0.5,7;1,1;default:diamond]" .. "item_image[6.5,7;1,1;wreckage:hematite]"
})
guideBooks.Common.register_page("wreckage:my_guidebook","modification", 2, {
    textcolor = "brown",
    text1 = S("Carnelian - orange colored crystals, which will allow you to dig out the entire accumulation of ore in one go.").."\n\n"..S("Features:").."\n"..S("-When mining one block of ore, the remaining blocks in the vein will be mined,").."\n"..S("-One-time use,").."\n"..S("-The method of obtaining it is given with a 1% chance when mining any ore with an amethyst pickaxe."),
    text2 = S("Peridot is a green crystal that will allow you to cut down the entire tree in one go.").."\n\n"..S("Features:").."\n"..S("-When one block of wood is extracted, the entire tree will be extracted,").."\n"..S("-One-time use,")..",\n"..S("-The method of obtaining it is given with a 1% chance when extracting any wood with an amethyst axe."),
    extra = "item_image[0.5,7;1,1;wreckage:carnelian]" .. "item_image[6.5,7;1,1;wreckage:peridot]"
})
guideBooks.Common.register_section("wreckage:my_guidebook","instruments",{
    description = S("Instruments")
})
guideBooks.Common.register_page("wreckage:my_guidebook", "instruments", 1, {
    textcolor = "brown",
    text1 = S("The game features five different tools: a pickaxe, an axe, a shovel, a sword, and a hoe. All of them are created on a workbench from a butt, a mount and a rod. The tools can be modified using five different modifiers."),
    text2 = S("In order not to lose the modified tool, it is possible to repair it, even if it is broken. For routine repairs, the material from which the shoe is made is required, and to repair a broken tool, a special tool is needed - a hammer for repair."),
})

minetest.register_craft({
	output = "wreckage:my_guidebook",
    type = "shapeless",
	recipe = {
		"default:book", "default:pick_wood",
		
	}
})


