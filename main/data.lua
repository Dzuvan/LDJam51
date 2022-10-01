-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local camera = require "orthographic.camera"

local M = {
  current_wave = 1,
  player_damage = 1,
  spawned = {}
}

function M.play_animation(self, animation, redo)
  if redo or self.current_animation ~= animation then
    self.current_animation = animation
    sprite.play_flipbook("#sprite", animation)
  end
end

function M.resolve_geometry(self, message_id, message)
  if message.distance > 0 then
    local proj = vmath.project(self.correction, message.normal * message.distance)
    if proj < 1 then
      local comp = (message.distance - message.distance * proj) * message.normal
      go.set_position(go.get_position() + comp)
      self.correction = self.correction + comp
    end
  end
end

function M.find_index(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

function M.get_rotation(action, pos)
    local from = pos or camera.screen_to_world(hash("/camera"), vmath.vector3(action.x, action.y, 0))
    local to = go.get_position() - go.get_position("/camera")
    local angle = math.atan2(to.x - from.x, from.y - to.y)

    return vmath.quat_rotation_z(angle)
  end

return M
