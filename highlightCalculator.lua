-- ========== Settings ================
--Settings:setCompareDimension(true, 960)
--Settings:setScriptDimension(true, 960)
Settings:set("MinSimilarity", 0.75)
--setImagePath("/storage/emulated/0/AnkuLua/ozon/image")
reg_full = Region(10, 85, 510, 770)
reg_clear_apps = Region(400, 42, 150, 30)
reg_ananas = Region(132, 82, 70, 770)
reg_heart_1 = Region(490, 190, 50, 670)
reg_heart_2 = Region(220, 190, 50, 670)
a = Location(490, 800)
b = Location(490, 150)
counter = 12
c = 0
arr = {reg_heart_1, reg_heart_2}
-- ==========  main program ===========

function Swipe()
	swipe(a, b, 1)
	--wait(1)
end

function Swipe_down()
	swipe(b, a, 1)
	--wait(1)
end

function start_ozon()
	snapshot()
	ananas = Pattern("ozon.png"):similar(0.9)
	temp = reg_full:exists(ananas, 2)
	if (temp ~= nil) then
		temp:highlight(2)
		--print(temp)
		click(temp)
		return true
	end
	return false
end

function reboot()
	while (not start_ozon()) do
		keyevent(187)
		wait(1)
		Swipe_down()
		click(reg_clear_apps:getCenter()) --clear button
		wait(1)
		keyevent(4)
		wait(1)
	end
end

function find_ananas()
	for i=1,9 do
		wait(0.1)
		Swipe()
		snapshot()
		ananas = Pattern("ananas.png"):similar(0.9)
		temp = reg_ananas:exists(ananas)
		if (temp ~= nil) then
			temp:highlight(2)
			--print(temp)
			click(Location(temp:getX()-math.random(5), temp:getY()-math.random(5)))
			wait(2)
			
			break
		end
	end
	if (c + math.random(-7, 7) ~= 10) then 
		keyevent(4)
		wait(1)
	end
	
end

function set_swipes()
	for i=1,10 do
		Swipe()
	end
end


function main()
	c = 0
	start_ozon()
	set_swipes()
	while (true) do
		toast(c)
		if (c > counter) then
			reboot()
			set_swipes()
			c = 0
		end
		Swipe()
		
		--reg_full:save("image_1.png")
		hearts = Pattern("heart2.png"):similar(0.6)
		for i = 1,2 do
			snapshot()	
			reg = arr[i]
			reg:highlight(1)
			--wait(1)
			hearts_list = listToTable(reg:findAllNoFindException(hearts))
			--print(hearts)
			for i, m in ipairs(hearts_list) do
				--print(m)
  		  	m:highlight(1)
				click(Location(m:getX()-15,m:getY()))
				find_ananas()
			end
		end
		c = c+1
	end
end
toast("123")
reg_full:highlight(1)
main()
