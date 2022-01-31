# frozen_string_literal: true

# Игрок. Будет иметь своё поле, будет совершать ходы.
class Player
  attr_accessor :enemy_ships, :enemy_field, :message

  def initialize(name)
    @name = name
    @message = []
    @enemy_ships = []
    @enemy_field = Field.new(Game::FIELD_SIZE)
  end

  def get_input(input_type)
    raise('Wrong input type') unless input_type == 'shot'

    user_input = $stdin.gets.chomp.upcase.gsub(' ', '')
    return 550, 0 if user_input == 'SURRENDER'

    x = user_input[0]
    y = user_input[1, 2].to_i

    if !Game::LETTERS.include?(x) || !(1..Game::FIELD_SIZE).include?(y)
      @message << 'Input Error.'
      return 500, 0
    end
    x = Game::LETTERS.find_index(x)
    y = y.to_i - 1
    [x, y]
  end

  def make_shot
    sx, sy = get_input('shot')

    return 'surrender' if sx + sy == 550

    return 'retry' if (sx + sy == 500) || (@enemy_field.radar[sx][sy] != Cell::EMPTY_CELL)

    shot_res = receive_shot([sx, sy])
    case shot_res
    when 'miss'
      @enemy_field.radar[sx][sy] = Cell::MISS_CELL
    when 'get'
      @enemy_field.radar[sx][sy] = Cell::DAMAGED_SHIP
    when Ship
      destroyed_ship = shot_res
      @enemy_field.mark_destroyed_ship(destroyed_ship, FieldPart::RADAR)
      shot_res = 'kill'
    else
      raise('Wrong shot result')
    end

    shot_res
  end

  def receive_shot(shot)
    sx, sy = shot

    if @enemy_field.map[sx][sy].is_a?(Ship)
      ship = @enemy_field.map[sx][sy]
      ship.hp -= 1

      if ship.hp <= 0
        @enemy_field.mark_destroyed_ship(ship, FieldPart::MAIN)
        @enemy_ships.delete(ship)
        return ship
      end
      @enemy_field.map[sx][sy] = Cell::DAMAGED_SHIP
      'get'
    else
      @enemy_field.map[sx][sy] = Cell::MISS_CELL
      'miss'
    end
  end
end
