enemy = {}

enemyspeed = 100

function newEnemy(x, y)
	table.insert(enemy,
	{x = x,
	y = y}	)
end

function newEnemyOnEdge()
	local edge = math.random(1, 4)
	if edge == 1 then
		newEnemy(
			math.random(0, love.graphics.getWidth()),
			0
		) 
	end	
	if edge == 2 then 
		newEnemy(
			math.random(0, love.graphics.getWidth()),
			love.graphics.getHeight()
		)
	end
	if edge == 3 then 
		newEnemy(
			0,
			math.random(0, love.graphics.getHeight())
		)
	end
	if edge == 4 then 
		newEnemy(
			love.graphics.getWidth(),
			math.random(0, love.graphics.getHeight())
		)
	end
end

function updateEnemy(dt)
	for i,v in ipairs(enemy) do
		local Vx = pos_x - v.x
		local Vy = pos_y - v.y
		local l = math.sqrt(Vx*Vx + Vy*Vy)
		local nx = Vx/l 
		local ny = Vy/l
		v.x = v.x + enemyspeed * dt * nx
		v.y = v.y + enemyspeed * dt * ny

		local dx = v.x - pos_x   
		local dy = v.y - pos_y
		local d = math.sqrt(dx*dx + dy*dy)
		if d < 10 then 
			playerAlive = false	
		end
	end
end

function drawEnemy()
	for i,v in ipairs(enemy) do
		love.graphics.circle("fill", v.x, v.y, 10) 
	end
end