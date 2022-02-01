# frozen_string_literal: true

require_relative 'service/exceptions'

# Игрок. Будет иметь своё поле, будет совершать ходы.
class Player
  attr_accessor :enemy_ships, :enemy_field, :message, :shame

  def initialize(name)
    @name = name
    @message = []
    @enemy_ships = []
    @enemy_field = Field.new(Game::FIELD_SIZE)
  end

  def console_input
    user_input = $stdin.gets.chomp.gsub(' ', '')
    get_input(user_input)
  end

  def get_input(user_input)
    if user_input == 'surrender'
      @shame = true
      return 'surrender'
    end

    begin
      x, y = check_input_coord_and_convert(user_input)
    rescue WrongCoordError, InputError, CellIsNotEmptyError
      return 'retry'
    end

    make_shot([x, y])
  end

  private

  def convert_check_empty_return(letter, num)
    x = Game::LETTERS.find_index(letter)
    y = num - 1
    raise CellIsNotEmptyError if @enemy_field.radar[x][y] != Cell::EMPTY_CELL

    [x, y]
  end

  def check_input_coord_and_convert(input)
    letter = input[0]
    num = input[1, 2]
    raise InputError unless letter && num

    raise InputError unless letter.match?(/[[:alpha:]]/) && num.match?(/[[:digit:]]/) && !num.match?(/[[:alpha:]]/)

    letter = letter.upcase
    num = num.to_i
    raise WrongCoordError unless Game::LETTERS.include?(letter) && (1..Game::FIELD_SIZE).include?(num)

    convert_check_empty_return(letter, num)
  end

  def make_shot(shot)
    sx, sy = shot

    if ship?(shot)
      ship = @enemy_field.map[sx][sy]
      ship.hp -= 1
      if ship.hp <= 0
        @enemy_field.mark_destroyed_ship(ship, FieldPart::MAIN)
        @enemy_field.mark_destroyed_ship(ship, FieldPart::RADAR)
        @enemy_ships.delete(ship)
        return 'kill'
      end
      @enemy_field.map[sx][sy] = Cell::DAMAGED_SHIP
      @enemy_field.radar[sx][sy] = Cell::DAMAGED_SHIP
      'get'
    else
      @enemy_field.map[sx][sy] = Cell::MISS_CELL
      @enemy_field.radar[sx][sy] = Cell::MISS_CELL
      'miss'
    end
  end

  def ship?(shot)
    sx, sy = shot
    @enemy_field.map[sx][sy].is_a?(Ship)
  end
end
