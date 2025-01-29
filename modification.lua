local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)
function descr_str(toolstack, name,level)
	local str =toolstack:get_description()
	local part1 = str:sub(1, str:find(":") - 1)..":"
	local part2 = str:sub(str:find(":") + 3)
	return  part1 .."E\n"..S(name).." "..level ..part2
end
modification_list = {
	["default:diamond"] = {
		name = "diamond",
		maxlevel = 1,
		func = function(capabilities, toolstack, itemmeta,level)
			local durable = 500
			for group_name,capas in pairs(capabilities.groupcaps) do
				capas.uses = capas.uses + durable
			end
			local new_number = tonumber( toolstack:get_description():match("(%d+)$")) + durable
			--local modified_string = toolstack:get_description():gsub("(Property:)", "Diamond " .. level .. "\n%1")
			itemmeta:set_string("description", descr_str(toolstack,"Diamond",level):gsub("(%d+)$", tostring(new_number)))
			itemmeta:set_string("capabilities", minetest.serialize(capabilities))
			return capabilities
		end	    	
	},
	["wreckage:hematite"] = {--speed
		name = "hematite",
		maxlevel = 20,
		func = function(capabilities, toolstack, itemmeta,level,sender,gp,modi_item)
			local speed = 0.2
			--local percentage = math.floor(((gp*modi_item)/gp)*100)
			local cap_str = itemmeta:get_string("capabilities")
			if cap_str ~="" then

				capabilities = table.copy(minetest.deserialize(cap_str))
			end
			if percentage == 100 then percentage = 0 end
			for group_name,capas in pairs(capabilities.groupcaps) do
				for i,t in pairs(capas.times) do
	        capas.times[i] = capas.times[i]/1.1   
      	end
			end

			local modified_string = ""
			if not toolstack:get_description():find("Hematite") then
			  local str =toolstack:get_description()
			  local part1 = str:sub(1, str:find(":") - 1)..":"
				local part2 = str:sub(str:find(":") + 3)
			  modified_string = part1 .."E\n"..S("Hematite").." "..level.." (0%)" ..part2
			else
			  modified_string = toolstack:get_description():gsub("Hematite[^\n]*", "HematiteE ".. level .. " (0%%)") 
			end
			
			itemmeta:set_string("description", modified_string)
			itemmeta:set_string("capabilities", minetest.serialize(capabilities))
			return capabilities
		end	    	
	},
	["wreckage:peridot"] = {--treecap
		name = "peridot_all",
		maxlevel = 1,
		image = "all",
		func = function(capabilities, toolstack, itemmeta,level,sender)
			local attributes = table.copy(toolstack:get_definition().attributes)
			if itemmeta:get_string("attributes") ~= "" then
				attributes = minetest.deserialize(itemmeta:get_string("attributes"))
				
			end
			local new_attribute = {
				name = "peridot",
			    type = "all",
			   	--ifmodi = true,
			    func = [[return function(pos, node, digger)
						local item = digger:get_wielded_item()
						local new_number = tonumber(item:get_description():match("(%d+)$"))
						local capab = item:get_definition().tool_capabilities
						local meta = item:get_meta()

						-- Таблица для хранения координат найденных блоков
						local found_coordinates = {}

						local function remove_connected_trees(position)
						    local neighbors = {
						        {x=1, y=0, z=0}, {x=-1, y=0, z=0}, 
						        {x=0, y=1, z=0}, {x=0, y=-1, z=0}, 
						        {x=0, y=0, z=1}, {x=0, y=0, z=-1}
						    }

						    for _, dir in ipairs(neighbors) do
						        local neighbor_pos = {x = position.x + dir.x, y = position.y + dir.y, z = position.z + dir.z}
						        local neighbor_node = minetest.get_node(neighbor_pos)

						        if minetest.get_item_group(neighbor_node.name, "tree") > 0  then
						            -- Сохраняем координаты найденного блока
						            table.insert(found_coordinates, neighbor_pos)

						            minetest.remove_node(neighbor_pos)
						            local inv = digger:get_inventory()  
						            if inv:room_for_item("main", neighbor_node.name) then  
						                inv:add_item("main", minetest.registered_nodes[neighbor_node.name])  
						            else
						                minetest.add_item(neighbor_pos, minetest.registered_nodes[neighbor_node.name].drop)  
						            end
						            
						            --for group_name, capas in pairs(capab.groupcaps) do 
						            	
						              if item:get_wear() <60000 then
						                item:add_wear_by_uses(new_number/0.1)
						              else
						                return
						              end
						            --end

						            -- Рекурсивно удаляем связанные блоки
						            remove_connected_trees(neighbor_pos)

						            -- Обработка атрибутов
						            attr_table = minetest.deserialize(item:get_meta():get_string("attributes"))
						            if attr_table and type(attr_table) == "table" then
						                for _, attr in ipairs(attr_table) do
						                    if attr.type == "pick" or attr.type == "all" then
						                        local up = item:get_definition().up 
						                        if up == 0 then up = 1 end
						                        local funcs = loadstring(attr.func)
						                        if funcs then
						                            local attr_func = funcs()(pos, node, digger, up, attr.level)
						                        end
						                    end
						                end
						            end
						        end
						    end
						end

						-- Удаляем блоки начиная с исходной позиции
						remove_connected_trees(pos)

						digger:set_wielded_item(item)
					end]]
			}

			-- Добавляем новый атрибут в таблицу
			table.insert(attributes, new_attribute)

			-- Преобразуем таблицу обратно в строку
			local new_string = minetest.serialize(attributes)

			-- Сохраняем новую строку обратно в метаданные предмета
			itemmeta:set_string("attributes", new_string)
			--local modified_string = toolstack:get_description():gsub("(Property:)", "Treecap " .. level .. "\n%1")
			itemmeta:set_string("description", descr_str(toolstack,"Peridot",level))
			itemmeta:set_string("ifmodi", "true")
			--minetest.chat_send_player(sender:get_player_name(),"  Uses: " ..a)
			
		end	    	
	},
		["wreckage:carnelian"] = { --orecap
		name = "carnelian_all",
		maxlevel = 1,
		image = "all",
		func = function(capabilities, toolstack, itemmeta,level,sender)
			local attributes = table.copy(toolstack:get_definition().attributes)
			if itemmeta:get_string("attributes") ~= "" then
				attributes = minetest.deserialize(itemmeta:get_string("attributes"))
				
			end
			local new_attribute = {
				name = "carnelian",
			    type = "all",
			    func = [[return function(pos, node, digger)
				    local item = digger:get_wielded_item()
				    local new_number = tonumber(item:get_description():match("(%d+)$"))
				    local capab = item:get_definition().tool_capabilities
				    local meta = item:get_meta()

				    -- Таблица для хранения координат найденных блоков
				    local found_coordinates = {}

				    local function remove_connected_trees(position)
				        local neighbors = {
				            {x=1, y=0, z=0}, {x=-1, y=0, z=0}, 
				            {x=0, y=1, z=0}, {x=0, y=-1, z=0}, 
				            {x=0, y=0, z=1}, {x=0, y=0, z=-1}
				        }

				        for _, dir in ipairs(neighbors) do
				            local neighbor_pos = {x = position.x + dir.x, y = position.y + dir.y, z = position.z + dir.z}
				            local neighbor_node = minetest.get_node(neighbor_pos)

				            if neighbor_node.name:find("default:stone_with") then
				                -- Сохраняем координаты найденного блока
				                table.insert(found_coordinates, neighbor_pos)

				                minetest.remove_node(neighbor_pos)
				                local inv = digger:get_inventory()  
				                if inv:room_for_item("main", neighbor_node.name) then  
				                    inv:add_item("main", minetest.registered_nodes[neighbor_node.name].drop)  
				                else
				                    minetest.add_item(neighbor_pos, minetest.registered_nodes[neighbor_node.name].drop)  
				                end
				                
				                --for group_name, capas in pairs(capab.groupcaps) do 
				                	
				                  if item:get_wear() <60000 then
				                    item:add_wear_by_uses(new_number/0.1)
				                  else
				                    return
				                  end
				                --end

				                -- Рекурсивно удаляем связанные блоки
				                remove_connected_trees(neighbor_pos)

				                -- Обработка атрибутов
				                attr_table = minetest.deserialize(item:get_meta():get_string("attributes"))
				                if attr_table and type(attr_table) == "table" then
				                    for _, attr in ipairs(attr_table) do
				                        if attr.type == "pick" or attr.type == "all" then
				                            local up = item:get_definition().up 
				                            if up == 0 then up = 1 end
				                            local funcs = loadstring(attr.func)
				                            if funcs then
				                                local attr_func = funcs()(pos, node, digger, up, attr.level)
				                            end
				                        end
				                    end
				                end
				            end
				        end
				    end

				    -- Удаляем блоки начиная с исходной позиции
				    remove_connected_trees(pos)

				    digger:set_wielded_item(item)
				end
				]]
			}
			-- Добавляем новый атрибут в таблицу
			table.insert(attributes, new_attribute)
			-- Преобразуем таблицу обратно в строку
			local new_string = minetest.serialize(attributes)
			-- Сохраняем новую строку обратно в метаданные предмета
			itemmeta:set_string("attributes", new_string)
			--local modified_string = toolstack:get_description():gsub("(Property:)", "Carnelian " .. level .. "\n%1")
			itemmeta:set_string("description", descr_str(toolstack,"Carnelian",level))
			itemmeta:set_string("ifmodi", "true")
		end	    	
	},
}
minetest.register_craftitem("wreckage:hematite",{
  description = S("Hematite"),
  inventory_image = "hematite.png"
});
minetest.register_craftitem("wreckage:peridot",{
  description = S("Peridot"),
  inventory_image = "peridot.png"
});
minetest.register_craftitem("wreckage:carnelian",{
  description = S("Carnelian"),
  inventory_image = "carnelian.png"
});