local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)
dofile(modpath.. "/modification.lua")

function sound(name)
	minetest.sound_play(name, {
  	pos = pos,
  	gain = 0.7,
  	max_hear_distance = 10,
 	})
end

local function levels(recipe, sender, exp, level)
	if level < 10 then
	  local new_exp  -- Временная переменная для хранения нового значения exp

	  if level == 0 then
	      new_exp = exp + recipe.input:get_count() 
	  else 
	      new_exp = exp + (0.7408 ^ (level - 1))  -- Увеличиваем exp по формуле
	  end

	  -- Проверяем новое значение exp
	  if new_exp > 6.8 then
	      exp = 0  -- Обнуляем exp, если новое значение превышает 6.8
	      level = level + 1  -- Увеличиваем уровень
	  else
	      exp = new_exp  -- В противном случае присваиваем новое значение exp
	  end
	end
	
  if sender then
		sender:get_meta():set_string("exp", exp)
		sender:get_meta():set_string("level", level)
	end
end

local function can_dig(pos, player)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("input") and inv:is_empty("modifi") and inv:is_empty("output")
end
local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	if listname == "output" then
		return 0
	elseif listname == "input" then
		return stack:get_count()
	elseif listname == "modifi" then
		return stack:get_count()
	end
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local MODNAME = minetest.get_current_modname()
local MN_PREFIX = MODNAME .. ":"
--local 
--local exp = exp or 0
--local level = level or 0
minetest.register_node(MN_PREFIX .. "anvil",{
	description = S("Anvil"),
	drawtype = "mesh",
	mesh = "anvil.obj",
	paramtype = 'light',
	drop = "wreckage:anvil",
	paramtype2 = "facedir",
	can_dig = can_dig,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "input", drops)
		default.get_inventory_drops(pos, "modifi", drops)
		default.get_inventory_drops(pos, "output", drops)
		drops[#drops+1] = "wreckage:anvil"
		minetest.remove_node(pos)
		return drops
	end,
	tiles = {
    	"anvil.png",
    },
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.37, 0.5, 0.5, 0.37}--{-0.37, -0.5, -0.5, 0.37, 0.5, 0.5},
		
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.37, 0.5, 0.5, 0.37},
	},
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_metal_defaults(),
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
    	tinker.update_formspec(pos, from_list, from_index, nil, player)
	end,

	on_metadata_inventory_put = function(...)
		tinker.update_formspec(...)
	end,
	on_metadata_inventory_take = function(...)
		tinker.update_formspec(...)
	end,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		exp = tonumber(placer:get_meta():get_string("exp")) or 0
		level = tonumber(placer:get_meta():get_string("level")) or 0
		
		inv:set_size("input", 1)
		inv:set_size("modifi", 1)
		inv:set_size("output", 2)
		local box_part = "box[0.5,0.2;".. exp ..",0.24;#00CF00]\nlabel[3.8,0.1;"..level.."]"

		-- Формируем formspec
		meta:set_string("formspec", [[
		    size[8,7]
		    list[current_player;main;0,3.25;8,4;]
		    list[context;input;1.5,1.9;1,1;]
		    image[0.5,0.19;8.5,0.3;bar.png]
		    image[3.5,1.9;1,1;arrow_book.png^[colorize:#1f1f1f]
		]] .. box_part .. [[
		    image[2.5,1.9;1,1;m.png]
		    list[context;modifi;2.5,1.9;1,1;]
		    list[context;output;4.5,1.9;2,1;]
		]])

	end,
	on_receive_fields = function(pos, formname, fields, sender)
		tinker.update_formspec(pos,'','','',sender)
		for k, v in pairs(fields) do
			if(fields.quit) then return end
			if v then
				local recipe = tinker.registered_recipes[tonumber(k)]
				local meta = minetest.get_meta(pos)
				local brick = minetest.find_nodes_in_area(
		      { x = pos.x - 1, y = pos.y-1, z = pos.z - 1 },
          { x = pos.x + 1, y = pos.y, z = pos.z + 1 },
          {'default:brick'})
        local chance = 0
        if #brick == 9 then
          chance = 40
        end

				local inv = meta:get_inventory()
				local toolstack = inv:get_stack("input", 1)
				local itemstack = inv:get_stack("modifi", 1)
				local item_count = itemstack:get_count()
				local toolmeta = toolstack:get_meta()
				local tooldef = toolstack:get_definition()
				local item_def = itemstack:get_definition() 
				
				if toolstack:get_name():find("wreckage:defected_tool") then
				  local name = toolmeta:get_string("tool_name")
				  local image = toolmeta:get_string("inventory_image"):gsub("%^%[mask:defect_tool%.png", "")
				  local ifmodi   = toolmeta:get_string("ifmodi")
				  local inventory  = toolmeta:get_string("inventory")
				  local capabilities = minetest.deserialize(toolmeta:get_string("capabilities"))
				  
					local attributes = toolmeta:get_string("attributes")
					local meta_table = toolmeta:get_string("meta_table")
					local description =  toolmeta:get_string("new_description")
					local uses = tonumber(description:match("(%d+)$"))
				  local new_toolstack = ItemStack(name)
				  local new_toolmeta = new_toolstack:get_meta()

				  new_toolmeta:set_string("inventory_image",image)
				  new_toolmeta:set_tool_capabilities(capabilities)
				  new_toolmeta:set_string("inventory", inventory)
				  new_toolmeta:set_string("attributes",attributes)
					new_toolmeta:set_string("ifmodi",ifmodi)
					new_toolmeta:set_string("meta_table",meta_table)
					new_toolmeta:set_string("description",description)
				  inv:remove_item("input", toolstack)
				  local wear = itemstack:get_wear()
				  
				  if wear<=(uses*100) then
				    new_toolstack:set_wear(wear)
				  end
				  itemstack:add_wear(uses *100)
				 	inv:set_stack("modifi",1,itemstack)
			    inv:add_item("output", new_toolstack)
					levels(recipe, sender, exp, level)
					sound("anvil_work")
				elseif toolstack:get_name():find("wreckage:tool") then
					if item_def and item_def.groups then
						if tooldef.rmat == itemstack:get_name() or (tooldef.rmat:find("group:") and item_def.groups[tooldef.rmat:match("group:(%S+)")]) then
				    	local current_wear = toolstack:get_wear()  -- Текущее значение износа
			        if current_wear > 0 then
			        	local required_items = 0
			          local wear_per_item = 18000  -- Износ, восстанавливаемый одним модификатором
			            -- Рассчитываем, сколько модификаторов нужно для полного восстановления
			            
		            if itemstack:get_name():find("wood") then
		            	required_items = math.floor((current_wear-3000) / wear_per_item)
		            elseif current_wear < wear_per_item then
		            	required_items = 1
		            else
		            	required_items = math.floor((current_wear / wear_per_item)+0.5)
		            end
		            if item_count >= required_items then 
		            -- Восстанавливаем прочность инструмента
		            	toolstack:set_wear(0)  -- Уменьшаем износ (восстанавливаем)
		            	--inv:set_stack("modifi", 1, "")
		            	inv:set_stack("modifi", 1, ItemStack(itemstack:get_name().. " " .. item_count-math.abs(required_items)))
		            else
		            	toolstack:add_wear(-wear_per_item *item_count)
		            	inv:set_stack("modifi", 1, "")
		            	--inv:set_stack("modifi", 1, ItemStack(itemstack:get_name()))
		            end
			            -- Удаляем предметы из инвентаря
			          
			          levels(recipe, sender, exp, level)
			          inv:remove_item("input", toolstack)
           			inv:add_item("output", toolstack)
           			sound("anvil_work")
			        end
          		
				    end
	        end
        	for item, item1 in pairs(modification_list) do
        		if item ==itemstack:get_name() then
        			if inv:room_for_item("output", toolstack) then
	        			local serialized_meta = toolmeta:get_string("meta_table")
								local meta_table 

								if serialized_meta and serialized_meta ~= "" then
								    meta_table = minetest.deserialize(serialized_meta)  
								else
								    meta_table = {}  
								end
	        			
	        			local modi_level = meta_table[item1.name] or 0
	        			if modi_level < item1.maxlevel then
									local capabilities = table.copy(tooldef.tool_capabilities)
									modi_level = modi_level + 1
									local gp = math.floor(modi_level * 1.15^(modi_level - 1)) 

									local modi_count = meta_table[item1.name.. "_count"] or 0
									local limit = meta_table.limit or 0
									if limit <5 or modi_level>1 then
									  local modi_item = item_count + modi_count
										if modi_item >= gp then 
											meta_table[item1.name] = modi_level
											item1.func(capabilities, toolstack, toolmeta,modi_level,sender,gp,modi_count)
											
											toolmeta:set_tool_capabilities(capabilities)        
											local inventory = toolmeta:get_string("inventory")
											
											local new_image = "^(" .. item1.name .. "_" .. toolstack:get_name():match("tool_(%w+)") .. ".png)"
											if item1.image == "all" then
												new_image =  "^(" .. item1.name .. ".png)"
											end
			    
											-- Проверяем, есть ли уже это изображение в inventory
											if not string.find(inventory, new_image) then
											    inventory = inventory .. new_image  -- Добавляем новое изображение, если его нет
											end

											toolmeta:set_string("inventory_image", tooldef.inventory_image .. inventory)
											toolmeta:set_string("inventory", inventory)
											inv:remove_item("input", toolstack)
			    						itemstack:take_item(gp)
			    						
			    						levels(recipe, sender, exp, level)
				    				else 
			    						inv:remove_item("input", toolstack)
			    						itemstack:take_item(item_count)

			    						local percentage = math.floor((100*modi_item)/gp)
			    						
			    						if percentage == 100 then percentage = 0 modi_item = 0 end
			    						modified_string = toolstack:get_description():gsub("%(%d+%%%s*%)","("..percentage.."%%)")
			    						toolmeta:set_string("description", modified_string)
			    						meta_table[item1.name.. "_count"] = modi_item
			    						
										end
										if modi_level == 1 then
											limit = limit + 1
											meta_table.limit = limit
										end
										
										toolmeta:set_string("meta_table", minetest.serialize(meta_table))
			    					inv:set_stack("modifi", 1, itemstack)
										inv:add_item("output", toolstack)
										sound("anvil_work")
									end
								end
        			end
        		end
        	end

				elseif recipe.modifi then
          -- Если recipe.modifi существует, проверяем его наличие в инвентаре
          local defect_item = ItemStack('wreckage:defected_'.. recipe.input:get_name():gsub(".*_", "")..'_ingot ' .. math.random(1, recipe.input:get_count()))
        	if inv:contains_item("input", recipe.input) and inv:contains_item("modifi", recipe.modifi) and inv:room_for_item("output", recipe.output) and inv:room_for_item("output", defect_item) then
            inv:remove_item("input", recipe.input)
            inv:remove_item("modifi", recipe.modifi)
            if math.random(1, 100) <= chance+ (level*6)   then
            	local name = recipe.output:get_name()
              inv:add_item("output", recipe.output)
            else 
              inv:add_item("output", defect_item)
            end

            levels(recipe, sender, exp, level)
            sound("anvil_work")
        	end
        end
			end
		end
		
		
		tinker.update_formspec(pos,'','','',sender)
	end
})

--Just a check that the recipe doesn't contain unexisting items.
local function sanitize_ItemStack(itemstack)
	if not minetest.registered_items[itemstack:get_name()] then
		error("Trying to register a recipe using '" .. itemstack:get_name() .. "', which doesn't exist.")
		return
	end
	if itemstack:get_count() < 1 then
		itemstack:set_count(1)
	end
	return true
end


tinker = {}
tinker.registered_recipes = {}
--[[Takes a recipe in the form:
	{
	input = itemstack,
	output = itemstack,
	}
itemstack should work for any of the three formats they come in.
]]
local recipe_id = 0
tinker.register_recipe = function(recipe)
	recipe.input = ItemStack(recipe.input)
	recipe.modifi = ItemStack(recipe.modifi)
	recipe.output = ItemStack(recipe.output)
	if recipe.modifi ~=nil then
	  if sanitize_ItemStack(recipe.input) and  sanitize_ItemStack(recipe.output) then
   --(not recipe.modifi or sanitize_ItemStack(recipe.modifi)) then
		  recipe.id = recipe_id
		  tinker.registered_recipes[recipe_id] = recipe
		  recipe_id = recipe_id + 1
	  end
	else
	  if sanitize_ItemStack(recipe.input) and recipe.modifi and  sanitize_ItemStack(recipe.output) then
   --(not recipe.modifi or sanitize_ItemStack(recipe.modifi)) then
        recipe.id = recipe_id
        tinker.registered_recipes[recipe_id] = recipe
        recipe_id = recipe_id + 1
		end
	end
end



--Returns a table containing all tinker recipes which v=can be crafted from the given input.
tinker.get_craftable_recipes = function(aviable, modifier)
    aviable = ItemStack(aviable)
    modifier = ItemStack(modifier)
    local recipes = {}
    for _, r in pairs(tinker.registered_recipes) do
        -- Проверяем, есть ли модификатор и соответствует ли он тому, что есть в инвентаре
        if r.modifi then
          if r.modifi:get_name() == "group:wood" then
            for node_name, def in pairs(minetest.registered_nodes) do
              if def.groups and def.groups["wood"] then
                if r.input:get_name() == aviable:get_name() and 
                   r.input:get_count() <= aviable:get_count() and 
                   node_name == modifier:get_name() then
                    recipes[#recipes + 1] = r
                end
              end
            end
          else
            if r.input:get_name() == aviable:get_name() and 
             r.input:get_count() <= aviable:get_count() and
            r.modifi:get_name() == modifier:get_name() then
            recipes[#recipes + 1] = r
            end
        end
        else
            if r.input:get_name() == aviable:get_name() and 
               r.input:get_count() <= aviable:get_count() then
                recipes[#recipes + 1] = r
            end
          end
      end
    
    return recipes
end

tinker.get_formspec = function (itemstack,modistack,pos,level)
  local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local formspec  = {}
	local recipes = tinker.get_craftable_recipes(itemstack,modistack)
	local box_part = "box[0.5,0.2;".. exp ..",0.22;#00CF00]\nlabel[3.8,0.1;"..level .."]"
	formspec[#formspec + 1] = [[
			size[8,7]
			list[current_player;main;0,3.25;8,4;]
			list[context;input;1.5,1.9;1,1;]
			image[0.5,0.19;8.5,0.3;bar.png]
			image[3.5,1.9;1,1;arrow_book.png^[colorize:#1f1f1f]
			]] .. box_part ..  [[
			
			list[context;modifi;2.5,1.9;1,1;]
			listring[]
			list[context;output;4.5,1.9;2,1;]
		]]
	if inv:is_empty("modifi") then
	  formspec[#formspec + 1] = "image[2.5,1.9;1,1;m.png]" 
	end 
	local x = 4 - (#recipes / 2)
	for _, v in pairs(recipes) do
		formspec[#formspec + 1] = "item_image_button["
		formspec[#formspec + 1] = tostring(x)
		formspec[#formspec + 1] = ",0.7;1,1;"
		formspec[#formspec + 1] = v.output:get_name()
		formspec[#formspec + 1] = ";"
		formspec[#formspec + 1] = tostring(v.id)
		formspec[#formspec + 1] = ";]"
		x = x + 1
	end
	return table.concat(formspec)
end

tinker.update_formspec = function(pos, listname, index, stack, player)
	local meta = minetest.get_meta(pos)
	exp = tonumber(player:get_meta():get_string("exp")) or 0
	level = tonumber(player:get_meta():get_string("level")) or 0
	meta:set_string("formspec", tinker.get_formspec(meta:get_inventory():get_stack("input", 1),meta:get_inventory():get_stack("modifi", 1),pos, level))
end

minetest.register_craft({
	output = "wreckage:anvil",
	recipe = {
		{"default:steelblock", "default:steelblock", "default:steelblock"},
		{"","default:steel_ingot",""},
		{"default:steel_ingot", "", "default:steel_ingot"},
	}
})
