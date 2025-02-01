-- Setup
local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)

tinker = {}
player_craft_status = {}
dofile(modpath.. "/anvil.lua")
dofile(modpath.. "/modification.lua")

dofile(modpath.. "/nodes.lua")



piece = {
  ["pickaxe_head"] = 3,
  ["tool_binding"] = 1,
  ["tool_rod"] = 2,
  ["axe_head"] = 3,
  ["shovel_head"] = 1,
  ["hoe_head"] = 2, 
  ["sword_head"] = 2,
  }


local pickhead = {}
local axehead = {}
local shohead = {}
local hoehead ={}
local sworhead = {}
local bind = {}
local rod = {}

local mat_list = {"ice","bone","detonar","amethyst"}

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end
function dele(str)
    return str:match(":(%w+)_") .. ""
end

function sound(name)
	minetest.sound_play(name, {
  	pos = pos,
  	gain = 0.7,
  	max_hear_distance = 10,
 	})
end

local registered_recipes = {}
function register_unique_craft(craft_def)
  local output = craft_def.output
  local recipe = craft_def.recipe

  -- Проверяем, является ли recipe таблицей
  if type(recipe) ~= "table" then
    recipe = {recipe}  -- Преобразуем строку в таблицу
  end
  local recipe_key_parts = {output} 

  for _, row in ipairs(recipe) do
    if type(row) == "table" then
      table.insert(recipe_key_parts, table.concat(row, ","))  -- Объединяем элементы строки
    else
      table.insert(recipe_key_parts, row)  -- Если это строка, просто добавляем
    end
  end

  local recipe_key = table.concat(recipe_key_parts, ";")  -- Объединяем все части ключа

  -- Проверяем, существует ли рецепт
  if not registered_recipes[recipe_key] then
    minetest.register_craft(craft_def)
    registered_recipes[recipe_key] = true  -- Помечаем рецепт как зарегистрированный
  end
end
local function make_piece(number, mat, rmat, hex, cooldown, sworddamage, snappy, choppy, cracky, crumbly, attributes)
	local full_mat = 'wreckage:' .. mat;
  for part,amount in pairs(piece) do
    local m_mat = mat:gsub("_ingot", "")
    if string.find(full_mat, "ingot") then
      minetest.register_craftitem("wreckage:hot_" .. m_mat,{
        description = S("Hot " .. mat:gsub("_", " ")),
        inventory_image = "hot_ingot.png"
      });

			register_unique_craft({
		    type = "cooking",
		    output = "wreckage:hot_" .. m_mat,
		    recipe = rmat,  
		    cooktime = 6,
			})

      minetest.register_craftitem("wreckage:defected_" .. mat,{
        description = S("Defected " .. mat:gsub("_", " ")),
        inventory_image = "defected_" .. mat .. ".png"
      });
    end

    local image =""
    if part ~= "tool_binding" then
  		image = part .. ".png^[multiply:" .. hex 
  		for _, image_mat in ipairs(mat_list) do
		    if rmat:find(image_mat)  then               
		      image = image_mat .. "_".. part ..".png"
		    end
		  end
	  else 
	  	image = part .. ".png^[multiply:" .. hex 
	  end

  	minetest.register_craftitem(full_mat .. '_' .. part, {
    	description = S(string.upper(mat:sub(1, 1)) .. mat:sub(2):gsub("_ingot", "") .. " " .. part:gsub("_", " ")),
      inventory_image = image,
      snappy=snappy,
      choppy=choppy,
      cracky=cracky,
      crumbly=crumbly,
      groups = {part = 1},
      attributes = attributes,
      sworddamage=sworddamage,
      rmat = rmat,
      hexx = hex,
      part = part,
      number = number
  	});

		if string.find(part, "pickaxe") then
      table.insert(pickhead, full_mat .. '_' .. part)
    elseif string.find(part, "binding") then
      table.insert(bind, full_mat .. '_' .. part)
    elseif string.find(part, "axe_head") then
      table.insert(axehead, full_mat .. '_' .. part)
    elseif string.find(part, "shovel") then
      table.insert(shohead, full_mat .. '_' .. part)
    elseif string.find(part, "sword") then
      table.insert(sworhead, full_mat .. '_' .. part)
    elseif string.find(part, "hoe") then
      table.insert(hoehead, full_mat .. '_' .. part)
    elseif string.find(part, "rod") then
      table.insert(rod, full_mat .. '_' .. part)
    end

    if string.find(full_mat, "ingot") then
      tinker.register_recipe({
        output = full_mat .. '_' .. part,
        input = "wreckage:hot_" .. m_mat .. " " .. amount,
        
      })
    end
  end
end
minetest.register_tool("wreckage:repair_hammer",{
	description = S("Hammer for repair"),
	inventory_image = "repair.png"
})
minetest.register_craftitem("wreckage:defected_tool",{
  inventory_image = "repair.png",
  groups = {not_in_creative_inventory=1}
})
tinker.register_recipe({
  output = "wreckage:defected_tool",
  modifi = "wreckage:repair_hammer",
  input = "wreckage:defected_tool"
})
local function tableHasKey(table, key)
  for _, item in ipairs(table) do
    if item.name == key then
      return true, item -- возвращаем также найденный элемент
    end
  end
  return false
end


make_piece(1, "steel_ingot",'default:steel_ingot','#9191ab', 0.9, 6, --do  ababab
  {times={[1]=2.5, [2]=1.20, [3]=0.35}, uses=30, maxlevel=2}, -- snappy
	{times={[1]=2.50, [2]=1.40, [3]=1.00}, uses=30, maxlevel=2}, -- choppy
	{times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=30, maxlevel=2}, -- cracky 
	{times={[1]=1.50, [2]=0.90, [3]=0.40}, uses=30, maxlevel=2}, -- crumbly
  {
		{
		  type="all",
			name=S("Reinforced"),
			durable = 10,
			func=[[return function(pos, node, digger,up,level)
			end]]
		}
	});
make_piece(2, "gold_ingot",'default:gold_ingot',"#e5ce00", 1.2, 2,--do
  {times={[2]=1.6, [3]=0.40}, uses=10, maxlevel=1}, -- snappy
	{times={[2]=3.00, [3]=1.60}, uses=10, maxlevel=1}, -- choppy
	{times={[3]=1.60}, uses=5, maxlevel=1}, -- cracky
	{times={[1]=3.00, [2]=1.60, [3]=0.60}, uses=10, maxlevel=1}, -- crumbly
  {
    {
      type='all',
      gchance = 1.05,
      name=minetest.colorize("#FFD700", S("Golden luck")),
  	  func=[[return function(pos, node, digger,up,level)
			  if minetest.registered_nodes[node.name].drop then
  			    if math.random(1, 100) <= 5 * up *level  then
  					  digger:get_inventory():add_item("main", minetest.registered_nodes[node.name].drop)
  			    end
  			end
  		end]]
    },
    {
      type ="sword",
      death = true,
      gchance = 1.05,
      name=minetest.colorize("#FFD700", S("Golden luck")),
      func =[[return function(self, killer,def,up,level)
        local pos = self.object:get_pos()
        for _, drop in ipairs(def.drops) do
          if math.random(1, 100) <= 5 * up *level then
            local count = math.random(drop.min or 0, drop.max or 0)-- + math.random(1,2)
            local stack = ItemStack({
              name = drop.name,
              count = count 

            })
            if stack:get_count() > 0 then
              minetest.add_item(pos, stack)
            end
          
          end
        end
      end]]
    }
}); --e5ce00d0 fafa00
make_piece(3, "stone",'default:cobble','#555555',1.1, 4,--555555df
  {times={[2]=1.4, [3]=0.40}, uses=20, maxlevel=1}, -- snappy
	{times={[1]=3.00, [2]=2.00, [3]=1.30}, uses=20, maxlevel=1}, -- choppy
	{times={[2]=2.0, [3]=1.00}, uses=20, maxlevel=1}, -- cracky
	{times={[1]=1.80, [2]=1.20, [3]=0.50}, uses=20, maxlevel=1}, -- crumbly
  {
		{
			name=minetest.colorize("#6F7378", S("Stoneborn")),
			type="pick",

			func=[[return function(pos, node, digger,up,level)
			  if minetest.get_item_group(node.name, "stone") > 0 then
			    if math.random(1, 100) <= 5 * up *level then
					  digger:get_inventory():add_item("main", node.name)
					  
			    end
		    end
			end]]
		}
	});

make_piece(4, "wood","group:wood","#775208", 1.2, 2, --d0
  {times={[2]=1.6, [3]=0.40}, uses=10, maxlevel=1}, -- snappy
	{times={[2]=3.00, [3]=1.60}, uses=10, maxlevel=1}, -- choppy
	{times={[3]=1.60}, uses=10, maxlevel=1}, -- cracky
	{times={[1]=3.00, [2]=1.60, [3]=0.60}, uses=10, maxlevel=1}, -- crumbly
  {
		{
			name=minetest.colorize("#663636", S("Cheapness")),
			type="all",
			func=[[return function(pos, node, digger)
			end]]
		}
	});
make_piece(5, "apple","default:tree","#7e6030", 1.2, 2, --d0
  {times={[2]=1.6, [3]=0.40}, uses=10, maxlevel=1}, -- snappy
	{times={[2]=3.00, [3]=1.60}, uses=10, maxlevel=1}, -- choppy
	{times={[3]=1.60}, uses=10, maxlevel=1}, -- cracky
	{times={[1]=3.00, [2]=1.60, [3]=0.60}, uses=10, maxlevel=1}, -- crumbly
  {
		{
			name=minetest.colorize("#663636", S("Picking")),
			type="axe",
			func=[[return function(pos, node, digger,up,level)
				if minetest.get_item_group(node.name, "leaves") > 0 then
			    if math.random(1, 100) <= 10 *up*level then
					  digger:get_inventory():add_item("main", ItemStack("default:apple".. " "..1*up*level))
			    end
		  	end
			end]]
		}
	});
make_piece(6, 'ice','wreckage:dense_ice','#71abf2', 0.8, 4, --d2
  {times={[2]=1.30, [3]=0.375}, uses=25, maxlevel=1}, -- snappy 
  {times={[1]=2.75, [2]=1.70, [3]=1.15}, uses=25, maxlevel=1}, -- choppy
  {times={[2]=1.80, [3]=0.90}, uses=25, maxlevel=1}, -- cracky 
  {times={[1]=1.65, [2]=1.05, [3]=0.45}, uses=25, maxlevel=1}, -- crumbly
  {
		{
			name=minetest.colorize("#71abf2", S("Regelation")),
			type="all",
			func=[[return function(pos, node, digger,up,level)
				if math.random(1, 100) <= 5 * up *level  then
					local item = digger:get_wielded_item()
					local current_wear = item:get_wear()
					local wear_to_deduct = math.floor(current_wear * 0.1)
					item:set_wear(math.max(0, current_wear - wear_to_deduct))
					digger:set_wielded_item(item)
					end
				end
			end]]
		},
		{
			type="sword",
			name=minetest.colorize("#71abf2", S("Regelation")),
			death = false,
  		func =[[return function(self,tool_capabilities,puncher,up,level)
				if math.random(1, 100) <= 5 * up *level  then
					local item = puncher:get_wielded_item()
					local current_wear = item:get_wear()
					local wear_to_deduct = math.floor(current_wear * 0.1)

					item:set_wear(math.max(0, current_wear - wear_to_deduct))
					puncher:set_wielded_item(item)
					
				end
			end]]
		}
	});
make_piece(7, "berillium_ingot",'wreckage:berillium_ingot','#20e4e4', 0.8, 6,--d2
   {times={[1]=1.44, [2]=0.653}, uses=52, maxlevel=2}, -- snappy
   {times={[1]=1.913, [2]=0.833, [3]=0.653}, uses=52, maxlevel=2}, -- choppy
   {times={[1]=1.733, [2]=0.608, [3]=0.35}, uses=52, maxlevel=2}, -- cracky 
   {times={[1]=0.99, [2]=0.563, [3]=0.30}, uses=52, maxlevel=2}, -- crumbly
  {
		{
		  type="all",
			name=minetest.colorize("#20e4e4", S("Fragile")),
			func=[[return function(pos, node, digger,up,level)
				if math.random(1, 100) <= 5/up*level  then
					local item = digger:get_wielded_item()
					local current_wear = item:get_wear()
					local wear_to_deduct = math.floor(current_wear * 0.05)
					local last_wear = current_wear + wear_to_deduct
					if last_wear >= 65530 then
						last_wear = 65530
					end
					item:set_wear(math.max(0, last_wear))
					digger:set_wielded_item(item)
					
				end
			end]]
		},
		{
			type="sword",
			name=minetest.colorize("#20e4e4",S("Fragile")),
			death = false,
  		func =[[return function(self,tool_capabilities,puncher,up)
				if math.random(1, 100) <= 5/up*level  then
					local item = puncher:get_wielded_item()
					local current_wear = item:get_wear()
					local wear_to_deduct = math.floor(current_wear * 0.05)
					local last_wear = current_wear + wear_to_deduct
					if last_wear >= 65530 then
						last_wear = 65530
					end
					item:set_wear(math.max(0, last_wear))
					puncher:set_wielded_item(item)
					
				end
			end]]
		},
		{
			name=minetest.colorize("#20e4e4", S("Fragile")),
			type="hoe",
			func =[[return function(pt, under, player_name, itemstack, up, level, uses)
				if math.random(1, 100) <= 5/up*level  then
  				local current_wear = itemstack:get_wear()
					local wear_to_deduct = math.floor(current_wear * 0.05)
					local last_wear = current_wear + wear_to_deduct
					if last_wear >= 65530 then
						last_wear = 65530
					end
					itemstack:set_wear(math.max(0, last_wear))
					--itemstack:add_wear_by_uses(uses*0.9*up)
				end
			end]]
			}
	});
make_piece(8, "titanium_ingot","wreckage:titanium_ingot","#013220",0.45, 9,--d0
   {times={[1]=1.60, [2]=0.725}, uses=48, maxlevel=2}, -- snappy
   {times={[1]=2.125, [2]=0.925, [3]=0.725}, uses=48, maxlevel=2}, -- choppy
   {times={[1]=1.925, [2]=0.675, [3]=0.35}, uses=48, maxlevel=2}, -- cracky 
   {times={[1]=1.10, [2]=0.625, [3]=0.30}, uses=48, maxlevel=2}, -- crumbly
    {
  		{
  			name=minetest.colorize("#013220", S("Degradation")),
  			type="all",

  			func=[[return function(pos, node, digger,up,level)
					local item = digger:get_wielded_item()
					local itemmeta = item:get_meta()
					local itemdef = item:get_definition()
					local current_wear = item:get_wear()

					local speed_index = 1
					local base_wear_limit = 65535 -- Базовый предел износа
					local wear_factor = current_wear / base_wear_limit / (up * level)

					local capabilities = table.copy(itemdef.tool_capabilities)
					local cap_str = itemmeta:get_string("capabilities")
					if cap_str ~="" then
						capabilities = table.copy(minetest.deserialize(cap_str))
					end

					-- Устанавливаем коэффициент замедления
					local slowdown_coefficient = 2 -- Чем меньше значение, тем медленнее увеличивается время

					if wear_factor > 0 then
				    speed_index = 1 + wear_factor ^ slowdown_coefficient -- Используем степень для замедления роста
					end

					if itemdef.tool_capabilities then
				    for _, capas in pairs(capabilities.groupcaps) do
			        for i, t in pairs(capas.times) do
		            capas.times[i] = t * speed_index
			        end
				    end
				    itemmeta:set_tool_capabilities(capabilities)
				    itemmeta:set_string("capabilities", minetest.serialize(capabilities))
					end
					digger:set_wielded_item(item)
  			end]]
  		}
  	});
make_piece(9, "detonar_ingot",'wreckage:detonar_ingot','#cc1000', 0.9, 6, --do
  {times={[1]=2.5, [2]=1.20, [3]=0.35}, uses=30, maxlevel=2}, -- snappy
	{times={[1]=2.50, [2]=1.40, [3]=1.00}, uses=30, maxlevel=2}, -- choppy
	{times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=30, maxlevel=2}, -- cracky 
	{times={[1]=1.50, [2]=0.90, [3]=0.40}, uses=30, maxlevel=2}, -- crumbly
  {
		{
		  type="all",
			name=minetest.colorize("#cc1000", S("Explosion")),
			func=[[return function(pos, node, digger,up,level)
				
				tnt.boom(pos,{radius = 2*level*up, damage_radius = 0, sound =""})
				
				local item = digger:get_wielded_item()
				local current_wear = item:get_wear()
				local tool_capabilities = item:get_tool_capabilities()
				local wear_to_deduct = math.floor(6000*level*up)

				for _,capas in pairs(tool_capabilities.groupcaps) do
					wear_to_deduct = wear_to_deduct / (capas.uses/10)
					
				end

				item:set_wear(math.max(0, current_wear + wear_to_deduct))
				digger:set_wielded_item(item)
			end]]
		}
	});
	
if minetest.get_modpath("amethyst_new") then
  make_piece(10, "amethyst",'amethyst_new:amethyst','#b38ef3', 0.9, 6, --do  ababab
    {times={[1]=2.5, [2]=1.20, [3]=0.35}, uses=30, maxlevel=2}, -- snappy
  	{times={[1]=2.50, [2]=1.40, [3]=1.00}, uses=30, maxlevel=2}, -- choppy
  	{times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=30, maxlevel=2}, -- cracky 
  	{times={[1]=1.50, [2]=0.90, [3]=0.40}, uses=30, maxlevel=2}, -- crumbly
    {
  		{
  		  type="all",
  			name=minetest.colorize("#b38ef3", S("Shard")),
  			func=[[return function(pos, node, digger,up,level)
  			local item = {
  			  {name = "default:stone_with_iron", drop = "wreckage:hematite", mchance = 70},
  			  {name = "default:stone_with", drop = "wreckage:carnelian", mchance = 1},
  			  {name = "tree", drop = "wreckage:peridot", mchance = 1}
  			}
  			  for _, items in ipairs(item) do
    			  if node.name:find(items.name)  then
              if math.random(1, 100) <= items.mchance * up *level then
              	local inv = digger:get_inventory() 
              	local pos = digger:get_pos()
              	if inv:room_for_item("main", items.drop) then  
    			      	digger:get_inventory():add_item("main", items.drop)
    			      
    			      else
    			      	minetest.add_item(pos, items.drop) 
    			      end
    		      end
    		    end
    		  end
  			end]]
  		}
  	});
end
if minetest.get_modpath("moreores") then
  make_piece(11, "silver_ingot","moreores:silver_ingot","#Dddddd",1.0,6, --d0
  	{times={[1]=2.5, [2]=1.20, [3]=0.35}, uses = 27, maxlevel= 1}, -- snappy
  	{times={[1]=2.50, [2]=1.40, [3]=1.00}, uses = 27, maxlevel= 1}, -- choppy
  	{times={[1]=4.00, [2]=1.60, [3]=0.80}, uses = 27, maxlevel= 1}, -- cracky 
  	{times={[1]=1.50, [2]=0.90, [3]=0.40}, uses = 27, maxlevel= 1}, -- crumbly
  	{
  		{
  			name=minetest.colorize("#c0c0c0", S("Holiness")),
  			type="sword",
  			death = false,
  			func =[[return function(self,tool_capabilities,puncher,up,level)
  				damage = tool_capabilities.damage_groups.fleshy
  				if self.object:get_entity_name():find("mobs_monster:") then
  					tool_capabilities.damage_groups.fleshy = tool_capabilities.damage_groups.fleshy + 5 + up * level 
  					
  				--if target and target:get_luaentity() and target:get_luaentity().name:find("mobs_monster:") then

  					return tool_capabilities.damage_groups.fleshy
  				else
  					return damage
  				end
  			end]]
  		}
  })
  make_piece(12, "mithril_ingot","moreores:mithril_ingot","#5622e6",0.45, 9,--d0
  	{times = {[2] = 0.70, [3] = 0.25}, uses = 66, maxlevel= 2}, -- snappy
  	{times = {[1] = 1.75, [2] = 0.45, [3] = 0.45}, uses = 66, maxlevel= 2}, -- choppy
  	{times = {[1] = 2.25, [2] = 0.55, [3] = 0.35}, uses = 66, maxlevel= 2}, -- cracky 
  	{times = {[1] = 0.70, [2] = 0.35, [3] = 0.20}, uses = 66, maxlevel= 2}, -- crumbly
  	{
  		{
  			name=minetest.colorize("#af38ff", S("Mythic")),
  			type="all",
  			upg = 1.2,
  			func=[[return function(pos, node, digger)
  			end]]
  		},
  		{
  			name=minetest.colorize("#af38ff", S("Mythic")),
  			type="sword",
  			upg = 1.2,
  			death = false,
  			func =[[return function(self,tool_capabilities,puncher,up,level)
  			end]]
  		}
  	})
end
if minetest.get_modpath("bonemeal") then
	make_piece(13, "bone","bonemeal:bone","#f2e8c9",1.0,6, --d0
  	{times={[2]=1.30, [3]=0.375}, uses=20, maxlevel=1}, -- snappy 
	  {times={[1]=2.75, [2]=1.70, [3]=1.15}, uses=20, maxlevel=1}, -- choppy
	  {times={[2]=1.80, [3]=0.90}, uses=20, maxlevel=1}, -- cracky 
	  {times={[1]=1.65, [2]=1.05, [3]=0.45}, uses=20, maxlevel=1}, -- crumbly
  	{
  		{
  			name=minetest.colorize("#c0c0c0", S("Serration")),
  			type="sword",
  			death = false,
  			func =[[return function(self,tool_capabilities,puncher,up,level)
  				local item = puncher:get_wielded_item()
					local current_wear = item:get_wear()
  				local index = current_wear/6500
					if index < 1 then
		      	damage_index = 1 + index 
		      else 
		      	damage_index = index 
			    end
  				--damage = tool_capabilities.damage_groups.fleshy
  				local base_damage = tool_capabilities.damage_groups.fleshy
    			local increased_damage = base_damage + damage_index +(up * level) 

  				return increased_damage
  			end]]
  		},
  		{
  			name=minetest.colorize("#c0c0c0", S("Сultivation")),
  			type="hoe",
  			func =[[return function(pt, under, player_name, itemstack, up, level, uses)
  				if under.name:find("^farming:%w+_%d+$") ~= nil then
	  				local base_name, number = under.name:match("^(.*):%w+_(%d+)$")

						if number then
							if tonumber(number) < 8 then
								local new_number = tonumber(number) + 1 + level
								if new_number >8 then
									new_number = 8
								end
						    local new_a = string.format("%s:wheat_%d", base_name, new_number)
						    minetest.set_node(pt.under,{name = new_a})
						    if not minetest.is_creative_enabled(player_name) then
									-- wear tool
									local wdef = itemstack:get_definition()
									itemstack:add_wear_by_uses(uses*0.9*up)
									-- tool break sound
									if itemstack:get_count() == 0 and wdef.sound and wdef.sound.breaks then
										minetest.sound_play(wdef.sound.breaks, {pos = pt.above,
											gain = 0.5}, true)
									end
								end
							end
						end

					elseif under.name:find("^farming:seed_%w+") then
						-- Используем паттерн для извлечения базового имени и части с семенами
						local base_name, seed_part = under.name:match("^(.*):seed_(.*)$")
						if base_name and seed_part then
						    -- Формируем новую строку
					    local new_string = string.format("%s:wheat_" .. level, base_name)
					    minetest.set_node(pt.under,{name = new_string})
					  end
				  end
				end]]
			}
	})
end


local function createDescription(attrpt,headp, name, binding, rodp, uses) --Функцич для создания описания
  local descriptionParts ={}
  local uniqueTable = {}
  for _, part in ipairs({
    S(firstToUpper(dele(headp)) .. name),
    S(firstToUpper(dele(binding))),
    S(firstToUpper(dele(rodp))),
    S("Property:")..attrpt,
    uses,
    durable,
  }) do
    if not uniqueTable[part] then
      uniqueTable[part] = true  
      table.insert(descriptionParts, part)  
    end
  end
    return table.concat(descriptionParts, "\n")
end


function get_image(def, def_dop)         --функция для создания текстурки
  local part_name = def.part
  local part_hex = def.hexx
  
  if part_name:find("binding") then
  	local binding = def_dop.part:gsub("_head","")
    local image = binding .. "_binding.png^[multiply:" .. part_hex 
    
		for _, image_mat in ipairs(mat_list) do
	    if def.rmat:find(image_mat)  then               
	      image = image_mat .. "_".. binding.."_binding.png"
	    end
	  end
    return image
  else
    local image = def.part .. ".png^[multiply:" .. part_hex 
    
    for _, image_mat in ipairs(mat_list) do
	    if def.rmat:find(image_mat)  then              
	      image = image_mat .. "_".. part_name ..".png"
	    end
	  end
    return image
  end
  
end

function attributes_func(headp, binding, rodp, name1, name2)
  local head_def = ItemStack(headp):get_definition()
  local binding_def = ItemStack(binding):get_definition()
  local rod_def = ItemStack(rodp):get_definition()
  local attrlist = {}
  local list = {}
  local durable = 0
  local up = 0
	for _,attr in ipairs(head_def.attributes) do
	  table.insert(list, attr)
	end
	for _,attr in ipairs(binding_def.attributes) do
	  table.insert(list, attr)
	end
	for _,attr in ipairs(rod_def.attributes) do
	  table.insert(list, attr)
	end
	
	for _,attr in ipairs(list) do
	  if attr.type == name1 or attr.type == name2 then
	  	attr.durable = attr.durable or 0
	    durable =durable + attr.durable
	    attr.upg = attr.upg or 0
	    up =up + attr.upg + (attr.gchance or 0)
			if attr.name then
        local exists, item = tableHasKey(attrlist, attr.name)
        if not exists then  -- Если имя не существует, добавляем новый элемент в массив с type и func
          table.insert(attrlist, { 
            name = attr.name, 
            level = 1,
            type = attr.type,
            func = attr.func 
          })
        else
          -- Если имя существует, увеличиваем уровень
          item.level = item.level + 1
        end
      end
		end
	end
	
	local attrpt=""
	for _,n in ipairs(attrlist) do
		attrpt=attrpt.."\n"..n.name.." "..n.level 
	end
	return head_def, binding_def, rod_def, attrlist, attrpt, durable, up  -- Возвращаем определения и значения
end
function defected_tool(itemstack, user, node, uses)
  local wear = itemstack:get_wear()
  local itemmeta = itemstack:get_meta()
  local itemdef = itemstack:get_definition()
  local capabilities = itemdef.tool_capabilities
  local cap_str = itemmeta:get_string("capabilities")
	if cap_str ~="" then
		capabilities = table.copy(minetest.deserialize(cap_str))
	end
  for group_name,capas in pairs(capabilities.groupcaps) do
  	if wear > 65535 - (65535/capas.uses) then 
      local capabilities = itemmeta:get_string("capabilities")
      local description = itemmeta:get_string("description")
      if description == "" then 
      	description = itemdef.description
      end
      local ifmodi   = itemmeta:get_string("ifmodi")
      local name = itemstack:get_name()
      local image = itemdef.inventory_image
      local inventory = itemmeta:get_string("inventory")
      local attributes = itemmeta:get_string("attributes")
      local meta_table = itemmeta:get_string("meta_table")

      itemstack:replace("wreckage:defected_tool")

      local itemmeta1 = itemstack:get_meta()
      itemmeta1:set_string("capabilities",capabilities)
      itemmeta1:set_string("attributes",attributes)
      itemmeta1:set_string("ifmodi",ifmodi)
      itemmeta1:set_string("meta_table",meta_table)
      itemmeta1:set_string("tool_name",name)
      itemmeta1:set_string("description",S("Broken").."[" .. description.. "]")
      itemmeta1:set_string("new_description",description )
      
      itemmeta1:set_string("inventory_image",image .. inventory .. "^[mask:defect_tool.png")
      itemmeta1:set_string("inventory",inventory)
      sound("default_tool_breaks")
  	end
  	local groups = tonumber(minetest.get_node_group(node.name, "level"))
		itemstack:add_wear_by_uses(capas.uses * (math.max((capas.maxlevel - groups) * 3, 1)))
	end
  return itemstack
end

for _, headp in ipairs(pickhead) do
  for __, binding in ipairs(bind) do
    for ___, rodp in ipairs(rod) do
    	local head_def, binding_def, rod_def, attrlist, attrpt, durable, up = attributes_func(headp, binding, rodp, "pick", "all")
      local usees = math.floor(((head_def.cracky.uses * 0.45)+((binding_def.cracky.uses/2) * 0.35)+((rod_def.cracky.uses/3)*0.2)) / 0.33)+math.floor(durable*up) 
      minetest.register_tool("wreckage:tool_pick_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number, {
        description = createDescription(attrpt,headp, " Pickaxe", binding, rodp, usees),
        inventory_image = "("..get_image(rod_def)..")^("..get_image(head_def)..")^("..get_image(binding_def, head_def)..")",
        tool_capabilities = {
          full_punch_interval = head_def.cooldown,
          max_drop_level=0,
          groupcaps={
            cracky = {times={[1]=head_def.cracky.times[1], [2]=head_def.cracky.times[2], [3]=head_def.cracky.times[3]}, uses= usees, maxlevel=head_def.cracky.maxlevel},
          },
          damage_groups = {fleshy=2},
        },
        after_use = function(itemstack, user, node)
        	return defected_tool(itemstack, user, node, usees)
        end,
        groups = {not_in_creative_inventory=1},
        sound = {breaks = "default_tool_breaks"},
        rmat = head_def.rmat,
        up = up,
        attributes= attrlist,
      })
      
      minetest.register_craft({
        output = "wreckage:tool_pick_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
        recipe = {
          {headp},
          {binding},
          {rodp},
        },
      });
      tinker.register_recipe({
        output = "wreckage:tool_pick_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
        modifi = head_def.rmat,
        input ="wreckage:tool_pick_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
      });
      for item, item1 in pairs(modification_list) do
      	tinker.register_recipe({
	        output = "wreckage:tool_pick_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
	        modifi = item,
	        input ="wreckage:tool_pick_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
	      })
      end
    end
  end
end

minetest.register_on_dignode(function(pos, node, digger)
	if digger then
		local stack = digger:get_wielded_item()
		if string.match(stack:get_name(), "^wreckage:tool_pick") then
			local attr_table = stack:get_definition().attributes
				if stack:get_meta():get_string("ifmodi") == "true" then
					attr_table = minetest.deserialize(stack:get_meta():get_string("attributes"))
				end
			for _,attr in ipairs(attr_table) do
				if attr.type=="pick" or attr.type=="all" then
					local up = stack:get_definition().up 
				  if up == 0 then
            up = 1
          end
        	local funcs = loadstring(attr.func)
        	if funcs then
        		local attr_func = funcs()(pos, node, digger,up,attr.level)
        	end
				end
			end
		end
	end
end)

for _, headp in ipairs(axehead) do
  for __, binding in ipairs(bind) do
    for ___, rodp in ipairs(rod) do
			local head_def, binding_def, rod_def, attrlist, attrpt, durable, up = attributes_func(headp, binding, rodp, "axe", "all")
      local usees = math.floor(((head_def.choppy.uses * 0.45)+((binding_def.choppy.uses/2) * 0.35)+((rod_def.choppy.uses/3)*0.2)) / 0.33)+math.floor(durable*up) 
      minetest.register_tool("wreckage:tool_axe_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number, {
				description = createDescription(attrpt,headp, " Axe", binding, rodp, usees),
        inventory_image = "("..get_image(rod_def)..")^("..get_image(head_def)..")^("..get_image(binding_def, head_def)..")",
				tool_capabilities = {
					full_punch_interval = head_def.cooldown,
					max_drop_level=0,
					groupcaps={
						choppy = {times={[1]=head_def.choppy.times[1], [2]=head_def.choppy.times[2], [3]=head_def.choppy.times[3]}, uses=usees, maxlevel=head_def.choppy.maxlevel},
					},
					damage_groups = {fleshy=head_def.damage},
				},
				after_use = function(itemstack, user, node)
        	return defected_tool(itemstack, user, node, usees)
        end,
				groups = {not_in_creative_inventory=1},
				sound = {breaks = "default_tool_breaks"},
				rmat = head_def.rmat,
				attributes= attrlist,
				up = up
			})
    
      minetest.register_craft({
        output = "wreckage:tool_axe_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
        recipe = {
          {'', headp, ''},
          {'', binding, ''},
          {'', rodp, ''},
        },
      });
      tinker.register_recipe({
        output = "wreckage:tool_axe_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
        modifi = head_def.rmat,
        input ="wreckage:tool_axe_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
      })
      for item, item1 in pairs(modification_list) do
      	tinker.register_recipe({
	        output = "wreckage:tool_axe_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
	        modifi = item,
	        input ="wreckage:tool_axe_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
	      })
      end
    end 
  end
end

minetest.register_on_dignode(function(pos, node, digger)
	if digger then
		local stack = digger:get_wielded_item()
		if string.match(stack:get_name(), "^wreckage:tool_axe") then
			local attr_table = stack:get_definition().attributes
				if stack:get_meta():get_string("ifmodi") == "true" then
					attr_table = minetest.deserialize(stack:get_meta():get_string("attributes"))
				end
			for _,attr in ipairs(attr_table) do
				if attr.type=="axe" or attr.type=="all" then
					local up = stack:get_definition().up 
				  if up == 0 then
            up = 1
          end
        	local funcs = loadstring(attr.func)
        	if funcs then
        		local attr_func = funcs()(pos, node, digger,up,attr.level)
        	end
				end
			end
		end
	end
end)

for _, headp in ipairs(shohead) do
  for __, binding in ipairs(bind) do
    for ___, rodp in ipairs(rod) do
			local head_def, binding_def, rod_def, attrlist, attrpt, durable, up = attributes_func(headp, binding, rodp, "shovel", "all")
      local usees = math.floor((((head_def.crumbly.uses/2) * 0.4)+((binding_def.crumbly.uses/2) * 0.4)+((rod_def.crumbly.uses/3)*0.2)) / 0.33)+math.floor(durable*up) 
      minetest.register_tool("wreckage:tool_shovel_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number, {
				description = createDescription(attrpt,headp," Shovel", binding, rodp, usees),
				inventory_image = "("..get_image(rod_def)..")^("..get_image(head_def)..")^("..get_image(binding_def, head_def)..")",
				tool_capabilities = {
					full_punch_interval = head_def.cooldown,
					max_drop_level=0,
					groupcaps={
						crumbly = {times={[1]=head_def.crumbly.times[1], [2]=head_def.crumbly.times[2], [3]=head_def.crumbly.times[3]}, uses=usees, maxlevel=head_def.crumbly.maxlevel},
					},
					damage_groups = {fleshy=2},
				},
				after_use = function(itemstack, user, node)
        	return defected_tool(itemstack, user, node, usees)
        end,
				groups = {not_in_creative_inventory=1},
				sound = {breaks = "default_tool_breaks"},
				rmat = head_def.rmat,
				attributes= attrlist,
				up = up,
			})
      minetest.register_craft({
        output = "wreckage:tool_shovel_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
        recipe = {
          {'', headp, ''},
          {'', binding, ''},
          {'', rodp, ''},
        },
      });
      tinker.register_recipe({
        output = "wreckage:tool_shovel_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
        modifi = head_def.rmat,
        input ="wreckage:tool_shovel_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
      })
      for item, item1 in pairs(modification_list) do
      	tinker.register_recipe({
	        output = "wreckage:tool_shovel_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
	        modifi = item,
	        input ="wreckage:tool_shovel_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
	      })
      end
    end 
  end
end


minetest.register_on_dignode(function(pos, node, digger)
	if digger then
		local stack = digger:get_wielded_item()
		if string.match(stack:get_name(), "^wreckage:tool_shovel") then
			local attr_table = stack:get_definition().attributes
				if stack:get_meta():get_string("ifmodi") == "true" then
					attr_table = minetest.deserialize(stack:get_meta():get_string("attributes"))
				end
			for _,attr in ipairs(attr_table) do
				if attr.type=="shovel" or attr.type=="all" then
					local up = stack:get_definition().up 
				  if up == 0 then
            up = 1
          end
        	local funcs = loadstring(attr.func)
        	if funcs then
        		local attr_func = funcs()(pos, node, digger,up,attr.level)
        	end
				end
			end
		end
	end
end)

for _, headp in ipairs(sworhead) do
  for __, binding in ipairs(bind) do
    for ___, rodp in ipairs(rod) do
			local head_def, binding_def, rod_def, attrlist, attrpt, durable, up = attributes_func(headp, binding, rodp, "sword", "")
      local usees = math.floor(((head_def.snappy.uses * 0.6)+((binding_def.snappy.uses/3) * 0.2)+((rod_def.snappy.uses/3)*0.2)) / 0.33)+math.floor(durable*up) 
      minetest.register_tool("wreckage:tool_sword_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number, {
				description = createDescription(attrpt,headp," Sword", binding, rodp , "+"..head_def.sworddamage..S(" Attack Damage").."\n" .. usees),
				inventory_image = "("..get_image(rod_def)..")^("..get_image(head_def)..")^("..get_image(binding_def, head_def)..")",
				tool_capabilities = {
					full_punch_interval = head_def.cooldown,
					max_drop_level=0,
					groupcaps={
						snappy = {times={[1]=head_def.snappy.times[1], [2]=head_def.snappy.times[2], [3]=head_def.snappy.times[3]}, uses=usees, maxlevel=head_def.snappy.maxlevel},
					},
					damage_groups = {fleshy=head_def.sworddamage, uses=head_def.snappy.uses}, --head_def.sworddamage
				},
				after_use = function(itemstack, user, node)
        	return defected_tool(itemstack, user, node, usees)
        end,
				groups = {not_in_creative_inventory=1},
				sound = {breaks = "default_tool_breaks"},
				rmat = head_def.rmat,
				attributes = attrlist,
				up = up,
			})
      minetest.register_craft({
        output = "wreckage:tool_sword_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
        recipe = {
          {'', headp, ''},
          {'', binding, ''},
          {'', rodp, ''},
        },
      });
      tinker.register_recipe({
        output = "wreckage:tool_sword_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
        modifi = head_def.rmat,
        input ="wreckage:tool_sword_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
      })
      for item, item1 in pairs(modification_list) do
      	tinker.register_recipe({
	        output = "wreckage:tool_sword_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
	        modifi = item,
	        input ="wreckage:tool_sword_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
	      })
      end
    end 
  end
end
local function starts_with(str, start)
    return str:sub(1, #start) == start
end

-- Функция для обработки дропа предметов при убийстве

minetest.register_on_mods_loaded(function()
  -- Перебор зарегистрированных сущностей
  for name, def in pairs(minetest.registered_entities) do
    -- Проверяем, является ли сущность мобом
    if name:find("mobs_animal:") or name:find("mobs_monster:") or name:find("nether_mobs") then
    	if def.on_punch then
        local prev_on_punch = def.on_punch
    		def.on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
	        if not self
            or not self.object
            or not self.object:get_luaentity()
            or not puncher
            or not tool_capabilities
	        then
            return prev_on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
	        end
	        local wield_stack = puncher:get_wielded_item()
	        if string.match(wield_stack:get_name(), "^wreckage:tool_sword") then

	        	local attr_table = wield_stack:get_definition().attributes
						if wield_stack:get_meta():get_string("ifmodi") == "true" then
							attr_table = minetest.deserialize(wield_stack:get_meta():get_string("attributes"))
						end

	        	for _,attr in  ipairs(attr_table) do
	        		if attr.type=="sword" then
	        			if attr.death == false then
	        				local pos = self.object:get_pos()
	        				local up = wield_stack:get_definition().up
								  if up == 0 then
				            up = 1
				          end
				          local funcs = loadstring(attr.func)
				        	if funcs then
				        		local attr_func = funcs()(self,tool_capabilities,puncher, up, attr.level)
				        	end

	            	end
	            end
	          end
	        end
	        prev_on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
       	end
       	
      end

      if def.drops then
        -- Создаем новую функцию on_death, которая добавляет золото при смерти от игрока
        local original_on_death = def.on_death or function(self, killer) end
        def.on_death = function(self, killer)
          -- Вызываем оригинальную функцию on_death (если она существует)
          original_on_death(self, killer)
          -- Проверяем, что убийца - игрок
          if killer and killer:is_player() then
            local wield_stack = killer:get_wielded_item()
            if string.match(wield_stack:get_name(), "^wreckage:tool_sword") then

              local attr_table = wield_stack:get_definition().attributes
							if wield_stack:get_meta():get_string("ifmodi") == "true" then
								attr_table = minetest.deserialize(wield_stack:get_meta():get_string("attributes"))
							end

		        	for _,attr in  ipairs(attr_table) do
                if attr.type=="sword" then
                	if attr.death==true then
                		local up = wield_stack:get_definition().up
									  if up == 0 then
					            up = 1
					          end
					          local funcs = loadstring(attr.func)
					        	if funcs then
					        		local attr_func = funcs()(self, killer,def, up,attr.level)
					        	end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end)

for _, headp in ipairs(hoehead) do
  for __, binding in ipairs(bind) do
    for ___, rodp in ipairs(rod) do
			local head_def, binding_def, rod_def, attrlist, attrpt, durable, up = attributes_func(headp, binding, rodp, "hoe", "")
			local usees = math.floor((((head_def.snappy.uses/3) * 0.2)+((binding_def.snappy.uses/2) * 0.6)+((rod_def.snappy.uses/3)*0.2)) / 0.33)+math.floor(durable*up) 
      minetest.register_tool("wreckage:tool_hoe_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number, {
        description = createDescription(attrpt,headp," Hoe", binding, rodp, usees),
        inventory_image = "("..get_image(rod_def)..")^("..get_image(head_def)..")^("..get_image(binding_def, head_def)..")",  
       -- on_use =  
        on_use = function(itemstack, user, pointed_thing)--farming.hoe_on_use,	
          return hoe_on_use(itemstack, user, pointed_thing, usees, attrlist)
        end,
        after_use = function(itemstack, user, node)
        	return defected_tool(itemstack, user, node, usees)
        end,
        tool_capabilities = {
					full_punch_interval = head_def.cooldown,
					max_drop_level=0,
					groupcaps={
						snappy = {times={[1]=head_def.snappy.times[1], [2]=head_def.snappy.times[2], [3]=head_def.snappy.times[3]}, uses=usees, maxlevel=head_def.snappy.maxlevel},
					},
					damage_groups = {fleshy=2},
				},
        groups = {not_in_creative_inventory=1},
        rmat = head_def.rmat,
        attributes= attrlist,
        up = up,
        sound = {breaks = "default_tool_breaks"},
      })
      minetest.register_craft({
        output = "wreckage:tool_hoe_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
        recipe = {
          {'', headp, ''},
          {'', binding, ''},
          {'', rodp, ''},
        },
      });
      tinker.register_recipe({
        output = "wreckage:tool_hoe_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
        modifi = head_def.rmat,
        input ="wreckage:tool_hoe_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
      })
      for item, item1 in pairs(modification_list) do
      	tinker.register_recipe({
	        output = "wreckage:tool_hoe_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
	        modifi = item,
	        input ="wreckage:tool_hoe_"..head_def.number.."_"..binding_def.number.."_"..rod_def.number,
	      })
      end
    end 
  end
end
hoe_on_use = function(itemstack, user, pointed_thing, uses, attributes, up)
	local pt = pointed_thing
	-- check if pointing at a node
	if not pt then
		return
	end
	if pt.type ~= "node" then
		return
	end
	local under = minetest.get_node(pt.under)
	local p = {x=pt.under.x, y=pt.under.y+1, z=pt.under.z}
	local above = minetest.get_node(p)
	-- return if any of the nodes is not registered
	if not minetest.registered_nodes[under.name] then
		return
	end
	if not minetest.registered_nodes[above.name] then
		return
	end
	
	-- check if the node above the pointed thing is air
	if above.name ~= "air" then
		return
	end
	local player_name = user and user:get_player_name() or ""
	-- check if pointing at soil
	if minetest.get_item_group(under.name, "soil")  >0 then
		-- check if (wet) soil defined
		local regN = minetest.registered_nodes
		if regN[under.name].soil == nil or regN[under.name].soil.wet == nil or regN[under.name].soil.dry == nil then
			return
		end
		
		if minetest.is_protected(pt.under, player_name) then
			minetest.record_protection_violation(pt.under, player_name)
			return
		end
		if minetest.is_protected(pt.above, player_name) then
			minetest.record_protection_violation(pt.above, player_name)
			return
		end
		-- turn the node into soil and play sound
		minetest.set_node(pt.under, {name = regN[under.name].soil.dry})
		minetest.sound_play("default_dig_crumbly", {
			pos = pt.under,
			gain = 0.3,
		}, true)
		if not minetest.is_creative_enabled(player_name) then
		-- wear tool
			local wdef = itemstack:get_definition()
			itemstack:add_wear_by_uses(uses)
			-- tool break sound
			if itemstack:get_count() == 0 and wdef.sound and wdef.sound.breaks then
				minetest.sound_play(wdef.sound.breaks, {pos = pt.above,
					gain = 0.5}, true)
			end
		end
	elseif under.name:find("^farming:") then
		local stack = user:get_wielded_item()
		local attr_table = stack:get_definition().attributes
		if stack:get_meta():get_string("ifmodi") == "true" then
			attr_table = minetest.deserialize(stack:get_meta():get_string("attributes"))
		end

		for _,attr in ipairs(attr_table) do
			
			if attr.type=="hoe" then
				local up = stack:get_definition().up
			  if up == 0 then
          up = 1
        end
        local funcs = loadstring(attr.func)
      	if funcs then
      		local attr_func = funcs()(pt, under, player_name, itemstack, up, attr.level,uses)
      	end
				--attr.func(pt, under, player_name, itemstack, up, attr.level,uses)
			end
		end		  
	end
	return itemstack
end
minetest.register_on_dignode(function(pos, node, digger)
	if digger then
		local stack = digger:get_wielded_item()
		if string.match(stack:get_name(), "^wreckage:tool_hoe") then
			for _,attr in ipairs(stack:get_definition().attributes) do
				if attr.type=="hoe" or attr.type=="all" then
				  --minetest.chat_send_player(digger:get_player_name(), "Удалено " .. attr.level)
				  local up = stack:get_definition().up 
				  if up == 0 then
            up = 1
          end
					attr.func(pos, node, digger, up, attr.level)
				end
			end
		end
	end
end)
dofile(modpath.. "/melting_furnace.lua")
dofile(modpath.. "/crafts.lua")
melting_furnace.register_recipe({
  input ="wreckage:hot_steel 2",
  modifi = "default:coal_lump",
  output = "wreckage:titanium_ingot",
})
dofile(modpath.. "/book.lua")

