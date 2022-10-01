-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local data = require "main.data"
local hashed = require "main.hashed"

local M = {}

function M.search_player(self, dt)
	if self.is_attacking then return end

	local player_pos = go.get_position("/hero")
	local pos = go.get_position()

	if pos.y < player_pos.y then
		data.play_animation(self, hashed["anim_run"])
		self.vel.y = self.speed
	end

	if pos.y > player_pos.y then
		data.play_animation(self, hashed["anim_run"])
		self.vel.y = -self.speed
	end

	if pos.x > player_pos.x then
		self.vel.x = -self.speed
		data.play_animation(self, hashed["anim_run"])
	end

	if pos.x < player_pos.x then
		self.vel.x = self.speed
		data.play_animation(self, hashed["anim_run"])
	end

	if self.vel.x == 0 and self.vel.y == 0 and not self.is_attacking then
		data.play_animation(self, hashed["anim_idle"])
	end

	sprite.set_hflip("#sprite", self.vel.x < 0)
	pos = pos + self.vel * dt
	go.set_position(pos)


	self.vel = vmath.vector3()
	self.correction = vmath.vector3()
end

function M.on_init(self)
	self.vel = vmath.vector3(0, 0, 0)
	self.current_animation = nil
	self.correction = vmath.vector3()
	self.is_attacking = false
end

function M.on_hit(self, message)
	local remainder = self.health - data.player_damage
	self.health = remainder < 0 and 0 or remainder
	if self.health < 1 then go.delete() end
end

function M.on_kill(self)
	pprint("Dead")
end

function M.on_heal(self, message_id, message)
	if message_id == hashed["heal"] then
		self.health = self.health + message.amount
	end
end

return M
