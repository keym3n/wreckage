--[[
  melting_furnace - a simple crafting station mod.
  Copyright (C) 2019  Skamiz Kazzarch

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
]]
local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)
local sound_ids = {}


local timer_active = false
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
local function sound(name)
 local sound_id =  minetest.sound_play(name, {
    pos = pos,
    gain = 0.7,
    max_hear_distance = 10,
  })
  table.insert(sound_ids, sound_id)
end
local function stop_last_sound()
    if #sound_ids > 0 then
        local sound_id = table.remove(sound_ids) -- Получите и удалите последний идентификатор
        minetest.sound_stop(sound_id) -- Остановите звук по идентификатору
    end
end

local function button(pos, formname, fields, sender)
  melting_furnace.update_formspec(pos,'','','',sender)
  for k, v in pairs(fields) do
    if(fields.quit) then return end
    if v then
      local recipe = melting_furnace.registered_recipes[tonumber(k)]
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      meta:set_int("k", k)
      if recipe.modifi then
        -- Если recipe.modifi существует, проверяем его наличие в инвентаре
        if inv:contains_item("input", recipe.input) and 
          inv:contains_item("modifi", recipe.modifi) and 
          inv:room_for_item("output", recipe.output) then
            local timer = minetest.get_node_timer(pos)
            
            if timer_active == false then
              timer:start(1)
              sound("melting_furnace_work")
              inv:remove_item("input", recipe.input)
              inv:remove_item("modifi", recipe.modifi)
            end
            timer_active = true
        end
      end
    end
  end
end
local function swap_node(pos, name)
  local node = minetest.get_node(pos)
  if node.name == name then
    return
  end
  node.name = name
  minetest.swap_node(pos, node)
end
local function melting_timer(pos)
  local meta = minetest.get_meta(pos)
  local inv = meta:get_inventory()

  local k = meta:get_int("k")
  local recipe = melting_furnace.registered_recipes[tonumber(k)]

  local timer = minetest.get_node_timer(pos)
  local progress = meta:get_float("progress") or 0
  progress = math.min(progress + 0.2, 1)  -- Ограничение до 100%
  swap_node(pos, "wreckage:melting_furnace_active")
  meta:set_float("progress", progress)
  if progress >= 1 then
    stop_last_sound()
    inv:add_item("output", recipe.output)
    meta:set_float("progress", 0)
    timer:stop()  -- Остановка таймера, если прогресс достиг 100%
    timer_active= false
   
    swap_node(pos,"wreckage:melting_furnace")
     melting_furnace.update_formspec(pos)
  else
   
     -- Перезапуск таймера
    
    timer:start(1) 
     melting_furnace.update_formspec(pos)
  end
  melting_furnace.update_formspec(pos)

  --return false
end

local MODNAME = minetest.get_current_modname()
local MN_PREFIX = MODNAME .. ":"
minetest.register_node(MN_PREFIX .. "melting_furnace",{
  description = S("Melting furnace"),
  drawtype = "mesh",
  mesh = "melting_furnace.obj",
  paramtype = 'light',
  drop = "wreckage:melting_furnace",
  paramtype2 = "facedir",
  can_dig = can_dig,
  sounds = default.node_sound_stone_defaults(),
  on_blast = function(pos)
		local drops = {}
    default.get_inventory_drops(pos, "input", drops)
    default.get_inventory_drops(pos, "modifi", drops)
    default.get_inventory_drops(pos, "output", drops)
    drops[#drops+1] = "wreckage:melting_furnace"
    minetest.remove_node(pos)
    return drops
	end,
  tiles = {
    "melting_furnace.png",
    },
  selection_box = {
    type = "fixed",
    fixed = {-0.5, -0.5, -0.4, 0.5, 0.5, 0.4},
  },
  collision_box = {
    type = "fixed",
    fixed = {
      {-0.5, -0.5, -0.2, 0.5, 0.5, 0.2}, 
      {-0.2, -0.5, -0.5, 0.2, 0.5, 0.5}, 
      },
  },
  is_ground_content = false,
  groups = {cracky = 1, level = 2},
  allow_metadata_inventory_put = allow_metadata_inventory_put,
  allow_metadata_inventory_move = allow_metadata_inventory_move,
  on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
      melting_furnace.update_formspec(pos, from_list, from_index, nil, player)
  end,

  on_metadata_inventory_put = function(...)
    melting_furnace.update_formspec(...)
  end,
  on_metadata_inventory_take = function(...)
    melting_furnace.update_formspec(...)
  end,
  after_place_node = function(pos, placer)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    
    inv:set_size("input", 1)
    inv:set_size("modifi", 1)
    inv:set_size("output", 1)
    

    -- Формируем formspec
   meta:set_string("formspec", [[
        size[8,7]
        list[current_player;main;0,3.25;8,4;]
        image[3.5,1.1;1,1;arrow.png^[transformR180]
        list[context;input;2.5,0.5;1,1;]
        list[context;modifi;4.5,0.5;1,1;]
        list[context;output;3.5,2;1,1;]
      ]])

  end,
  on_receive_fields = function(pos, formname, fields, sender)
    return button(pos, formname, fields, sender)
  end,
  on_timer = function(pos)
    return melting_timer(pos)
  end
})


minetest.register_node(MN_PREFIX .. "melting_furnace_active",{
  description = S("Melting furnace"),
  drawtype = "mesh",
  mesh = "melting_furnace_active.obj",
  paramtype = 'light',
  drop = "wreckage:melting_furnace",
  paramtype2 = "facedir",
  groups = {cracky=2, not_in_creative_inventory=1, level = 2},
  light_source = 8,
  can_dig = can_dig,
  sounds = default.node_sound_stone_defaults(),
  on_blast = function(pos)
    
    minetest.remove_node(pos)
    minetest.set_node(pos, {name = "default:lava_source"})
    return drops
  end,
  tiles = {
    "melting_furnace.png",
    },
  selection_box = {
    type = "fixed",
    fixed = {-0.5, -0.5, -0.4, 0.5, 0.5, 0.4},
  },
  collision_box = {
    type = "fixed",
    fixed = {
      {-0.5, -0.5, -0.2, 0.5, 0.5, 0.2}, 
      {-0.2, -0.5, -0.5, 0.2, 0.5, 0.5}, 
      },
  },
  is_ground_content = false,
  allow_metadata_inventory_put = allow_metadata_inventory_put,
  allow_metadata_inventory_move = allow_metadata_inventory_move,
  on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
      melting_furnace.update_formspec(pos, from_list, from_index, nil, player)
  end,

  on_metadata_inventory_put = function(...)
    melting_furnace.update_formspec(...)
  end,
  on_metadata_inventory_take = function(...)
    melting_furnace.update_formspec(...)
  end,
  after_place_node = function(pos, placer)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    
    inv:set_size("input", 1)
    inv:set_size("modifi", 1)
    inv:set_size("output", 1)
    meta:set_string("formspec", [[
        size[8,7]
        list[current_player;main;0,3.25;8,4;]
        image[3.5,1.1;1,1;arrow.png^[transformR180]
        list[context;input;2.5,0.5;1,1;]
        list[context;modifi;4.5,0.5;1,1;]
        list[context;output;3.5,2;1,1;]
      ]])
  end,
  on_receive_fields = function(pos, formname, fields, sender)
    return button(pos, formname, fields, sender)
  end,
  on_timer = function(pos)
    return melting_timer(pos)
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


melting_furnace = {}
melting_furnace.registered_recipes = {}
--[[Takes a recipe in the form:
  {
  input = itemstack,
  output = itemstack,
  }
itemstack should work for any of the three formats they come in.
]]
local recipe_id = 0
melting_furnace.register_recipe = function(recipe)
  recipe.input = ItemStack(recipe.input)
  recipe.modifi = ItemStack(recipe.modifi)
  recipe.output = ItemStack(recipe.output)
  if recipe.modifi ~=nil then
    if sanitize_ItemStack(recipe.input) and  sanitize_ItemStack(recipe.output) then
   --(not recipe.modifi or sanitize_ItemStack(recipe.modifi)) then
      recipe.id = recipe_id
      melting_furnace.registered_recipes[recipe_id] = recipe
      recipe_id = recipe_id + 1
    end
  else
    if sanitize_ItemStack(recipe.input) and recipe.modifi and  sanitize_ItemStack(recipe.output) then
   --(not recipe.modifi or sanitize_ItemStack(recipe.modifi)) then
        recipe.id = recipe_id
        melting_furnace.registered_recipes[recipe_id] = recipe
        recipe_id = recipe_id + 1
    end
  end
end



--Returns a table containing all tinker recipes which v=can be crafted from the given input.
melting_furnace.get_craftable_recipes = function(aviable, modifier)
    aviable = ItemStack(aviable)
    modifier = ItemStack(modifier)
    local recipes = {}
    for _, r in pairs(melting_furnace.registered_recipes) do
        -- Проверяем, есть ли модификатор и соответствует ли он тому, что есть в инвентаре
        if r.modifi then
          if r.input:get_name() == aviable:get_name() and 
            r.input:get_count() <= aviable:get_count() and
            r.modifi:get_name() == modifier:get_name() then
              recipes[#recipes + 1] = r
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

melting_furnace.get_formspec = function (progress,itemstack,modistack)
  local formspec  = {}
  local recipes = melting_furnace.get_craftable_recipes(itemstack,modistack)
  
  local arrow = "image[3.5,1.1;1,1;arrow.png^[lowpart:".. (progress*100)..":arrow_full.png^[transformR180]"
  --local box_part = "box[0.5,0.2;".. progress ..",0.22;#00CF00]"
  formspec[#formspec + 1] = [[
      size[8,7]
       list[current_player;main;0,3.25;8,4;]
       ]] .. arrow.. [[
        
       list[context;input;2.5,0.5;1,1;]
       list[context;modifi;4.5,0.5;1,1;]
       list[context;output;3.5,2;1,1;]
    ]]
  local x = 4 - (#recipes / 2)
  for _, v in pairs(recipes) do
    formspec[#formspec + 1] = "item_image_button["
    formspec[#formspec + 1] = tostring(x)
    formspec[#formspec + 1] = ",0.2;1,1;"
    formspec[#formspec + 1] = v.output:get_name()
    formspec[#formspec + 1] = ";"
    formspec[#formspec + 1] = tostring(v.id)
    formspec[#formspec + 1] = ";]"
    x = x + 1
  end
  return table.concat(formspec)
end

melting_furnace.update_formspec = function(pos, listname, index, stack, player)
  local meta = minetest.get_meta(pos)
  local progress = meta:get_float("progress") or 0
  meta:set_string("formspec", melting_furnace.get_formspec(progress,meta:get_inventory():get_stack("input", 1),meta:get_inventory():get_stack("modifi", 1)))
end

register_unique_craft({
  output = "wreckage:melting_furnace",
  recipe = {
    {"default:brick", "dye:black", "default:brick"},
    {"default:obsidian_shard","amethyst_new:calcite","default:obsidian_shard"},
    {"default:brick", "default:obsidian_shard", "default:brick"},
  }
})

