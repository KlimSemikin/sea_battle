# frozen_string_literal: true

# Этот класс будет группировать и манипулировать остальными классами.
class Game
  attr_accessor :letters, :ships, :field_size

  def initialize; end

  # при старте игры назначаем текущего и следующего игрока
  def start_game; end

  # функция переключения статусов
  def status_check; end

  # при добавлении игрока создаем для него поле
  def add_player; end

  # делаем расстановку кораблей по правилам заданным в классе Game
  def ships_setup; end

  def draw; end

  def switch_players; end

  def clear_screen; end

end
