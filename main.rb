# frozen_string_literal: true

require_relative './app/player'
require_relative './app/game'
require_relative './app/helpers'

player = Player.new('User')
game = Game.new(player)

loop do
  game.clear_screen
  game.status_check

  case game.status
  when 'prepare'
    player.message << 'Game started!'
  when 'in game'
    player.message << 'Enter the coordinates of the ship: '
    game.draw
    player.message.clear
    shot_result = player.make_shot
    case shot_result
    when 'miss'
      player.message << 'Miss!'
    when 'retry'
      player.message << 'Try again!'
    when 'get'
      player.message << 'Nice shot!'
    when 'kill'
      player.message << 'Enemy ship was destroyed!'
    when 'surrender'
      game.status = 'game over'
    else
      raise('Wrong shot_result')
    end

  when 'game over'
    player.enemy_field.draw_field(FieldPart::MAIN, Game::LETTERS)
    if !player.enemy_ships.empty?
      puts 'What a shame...'
    else
      puts "It was the last one.\nYou win!"
    end
    break
  else
    raise("Wrong game status #{game.status}")
  end
end
