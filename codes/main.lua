--[[
	Cette fonction est appelée au lancement du jeu

	On se sert de cette fonction pour créer tous les objets qu'on va utiliser
	et initialiser les paramètres du jeu.
]]
function love.load(arg)
	require ("bullet") 
	require ("enemy")




	sticks = (love.joystick.getJoystickCount( )>=1)


	playerimage = love.graphics.newImage("images/player.png")
	playerspeed = 200
	playerAlive = true


	spawntime = 2
	lastspawn = 0
	spawnNumber = 1

	BulletTime = 0.15
	LastBullet = 0


	pos_x = 250
	pos_y = 200

	playerScore = 0
	HighScore = 0
end

function newGame()
	playerspeed = 200
	playerAlive = true


	spawntime = 2
	lastspawn = 0
	spawnNumber = 1


	pos_x = 250
	pos_y = 200

	playerScore = 0
	enemy = {}
	bullet = {}
end


--[[
	Cette fonction est appelée chaque fois qu'un joueur appuie sur un bouton
	de la manette

	On peut donc utiliser cette fonction pour executer les commandes.

]]
function love.joystickpressed(joy, btn)
	if joy==1 and btn==6 then 
		newBullet(
			pos_x,
			pos_y,
			love.joystick.getAxis (1,5),
			love.joystick.getAxis (1,4)
		)
	end
end

function love.mousepressed(x, y, btn)
	
end

function love.keypressed(key)
	if not playerAlive then
		if key == "return" then
			newGame()		
		end
	end 

	if key == "escape" then 
		love.event.push("quit")
	end	
end


--[[
	Cette fonction est appelée à chaque trame de jeu

	Elle sert à simuler chaque trame, on met à jour tous les objets dans le jeu.

]]
function love.update(dt)
	if playerAlive then
		if (sticks) then
			pos_x = pos_x + (playerspeed * dt)*love.joystick.getAxis(1, 1)
			pos_y = pos_y + (playerspeed * dt)*love.joystick.getAxis(1, 2)
		end

		--[[ Contrôle clavier ]]
		local vx = 0
		local vy = 0
		if love.keyboard.isDown("right") then
			vx = vx + 1
		end
		if love.keyboard.isDown("left") then
			vx = vx - 1
		end
		if love.keyboard.isDown("down") then
			vy = vy + 1
		end
		if love.keyboard.isDown("up") then
			vy = vy - 1
		end
		local d = math.sqrt(vx*vx+vy*vy)
		if d~=0 then
			vx = vx/d
			vy = vy/d
		end
		pos_x = pos_x + (playerspeed * dt)*vx
		pos_y = pos_y + (playerspeed * dt)*vy
		--[[ Fin contrôle clavier ]]


		if (pos_x < 10) then 
			pos_x = 10
		end	

		if ( pos_x > love.graphics.getWidth()-10) then
			pos_x = love.graphics.getWidth()-10
		end
		
		if ( pos_y < 10 ) then 
			pos_y = 10
		end
		
		if ( pos_y > love.graphics.getHeight()-10) then
			pos_y = love.graphics.getHeight()-10
		end		
		updateBullets(dt)
		updateEnemy (dt)


		lastspawn = lastspawn + dt
		if lastspawn > spawntime then
			for i=1,spawnNumber do
				newEnemyOnEdge()
			end
			spawnNumber = math.min(spawnNumber + 1, 8)
			lastspawn = 0
		end	

		LastBullet = LastBullet + dt
		if love.mouse.isDown("l") and LastBullet > BulletTime then
			newBullet(
				pos_x,
				pos_y,
				love.mouse.getX()-pos_x,
				love.mouse.getY()-pos_y
			)
			LastBullet = 0 
		end

	else
		
	end	
end


--[[
	Cette fonction est aussi appelée à chaque trame.

	Elle sert à dessiner tous les objets qu'on souhaite afficher

]]
function love.draw()
	if playerAlive then
		love.graphics.draw(playerimage, pos_x-10, pos_y-10)
		drawBullets()
		drawEnemy()
		love.graphics.print("SCORE : "..playerScore, 10, 10 )
	else
		love.graphics.print("GAME OVER", 200,200)
		love.graphics.print("SCORE : "..playerScore, 200, 220 )
		love.graphics.print("HIGHSCORE : "..HighScore, 200, 240 )
	end	
end