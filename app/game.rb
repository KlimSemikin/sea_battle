# frozen_string_literal: true

require_relative 'field'
require_relative 'ship'

# Этот клаысс будет группировать и манипулировать остальными классами.
class Game
  attr_accessor :status, :player

  LETTERS = Array('A'..'J').freeze
  SHIPS_RULES = [1, 1, 1, 1, 2, 2, 2, 3, 3, 4].freeze
  FIELD_SIZE = LETTERS.size

  def initialize
    @status = 'prepare'
  end

  def add_player(player)
    @player = player
    ships_setup(player)
  end

  # функция переключения статусов
  def status_check
    if @status == 'prepare' && @player
      @status = 'in game'
      true
    # переключаем в статус game over если у врага осталось 0 кораблей или он сдался.
    elsif @status == 'in game' && (@player.enemy_ships.empty? || @player.shame)
      @status = 'game over'
      true
    end
  end

  # делаем расстановку кораблей по правилам заданным в классе Game
  def ships_setup(player)
    Game::SHIPS_RULES.sort_by { rand }.each do |ship_size|
      ship = Ship.new(ship_size, 0, 0, 0)
      loop do
        x = rand(player.enemy_field.size)
        y = rand(player.enemy_field.size)
        r = rand(4)
        ship.set_position(x, y, r)

        break if player.enemy_field.check_ship_fits(ship, FieldPart::MAIN)
      end
      player.enemy_field.add_ship_to_field(ship, FieldPart::MAIN)
      player.enemy_ships.append(ship)
    end
  end

  def draw
    @player.enemy_field.draw_field(FieldPart::RADAR, LETTERS)
    @player.message.each do |line|
      puts line
    end
  end

  def clear_screen
    Gem.win_platform? ? (system 'cls') : (system 'clear')
  end

  def send_mess_to_player(answers, player, result)
    player.message << answers[result]
  end
end
