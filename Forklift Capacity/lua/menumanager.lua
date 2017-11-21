_G.ForkliftCapacity = _G.ForkliftCapacity or {}
ForkliftCapacity._path = ModPath
ForkliftCapacity._data_path = SavePath .. 'forklift_capacity.txt'
ForkliftCapacity.settings = {
	forklift_capacity = 3
}

function ForkliftCapacity:Load()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
end

function ForkliftCapacity:Save()
	local file = io.open(self._data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_ForkliftCapacity', function(loc)
	for _, filename in pairs(file.GetFiles(ForkliftCapacity._path .. 'loc/')) do
		local str = filename:match('^(.*).txt$')
		if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			loc:load_localization_file(ForkliftCapacity._path .. 'loc/' .. filename)
			break
		end
	end

	loc:load_localization_file(ForkliftCapacity._path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_ForkliftCapacity', function(menu_manager)

	MenuCallbackHandler.ModifyForkliftCapacity = function(this, item)
		ForkliftCapacity.settings.forklift_capacity = item:value()
	end

	MenuCallbackHandler.ForkliftCapacitySave = function(this, item)
		ForkliftCapacity:Save()
	end

	ForkliftCapacity:Load()

	MenuHelper:LoadFromJsonFile(ForkliftCapacity._path .. 'menu/options.txt', ForkliftCapacity, ForkliftCapacity.settings)

    tweak_data.vehicle.forklift.max_loot_bags = ForkliftCapacity.settings.forklift_capacity

end)

Announcer:AddHostMod("Host is using Forklift Capacity mod that modifies the amount of bags a single forklift can carry")