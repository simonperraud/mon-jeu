bullet = {}

bulletspeed = 500

function newBullet(x, y, Vx, Vy) -- Crée une nouvelle balle
	local l = math.sqrt(Vx*Vx + Vy*Vy)
	local nx = Vx/l 
	local ny = Vy/l

	table.insert(bullet,
		{x = x,
		y = y,
		Vx = nx,
		Vy = ny } 
	)
end

function updateBullets(dt)              -- met a jour toute les balles
	local i = 1
	while i <= #bullet do
		local v = bullet [i]
		if (v.x < 0 or 
			v.x > love.graphics.getWidth() or
			v.y < 0 or
			v.y > love.graphics.getHeight()) then
			table.remove(bullet, i)
		else	
			v.x = v.x + bulletspeed * dt * v.Vx
			v.y = v.y + bulletspeed * dt * v.Vy
			local alive = true

			for j,u in ipairs(enemy) do
				local dx = v.x - u.x
				local dy = v.y - u.y
				local d = math.sqrt(dx*dx + dy*dy)
				if d <= 10 then
					playerScore = playerScore + 100
					HighScore = math.max(HighScore, playerScore)
					alive = false
					table.remove (enemy, j) 
					table.remove (bullet, i)
					break
				end
			end




			if alive then
				i = i + 1
			end
		end
	end	
end

function drawBullets( ... )
	for i,v in ipairs(bullet) do
		love.graphics.line(v.x, v.y, v.x + v.Vx, v.y + v.Vy)
	end
end