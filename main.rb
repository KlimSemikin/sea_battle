# frozen_string_literal: true

require_relative './app/player'
require_relative './app/game'
require_relative './app/helpers'

answers = {
  'kill' => 'Enemy ship was destroyed!',
  'miss' => 'Miss!',
  'retry' => 'Try again!',
  'get' => 'Nice shot!'
}

player = Player.new('User')
game = Game.new

loop do
  game.clear_screen
  game.status_check

  case game.status
  when 'prepare'
    player.message << 'Game started!'
    game.add_player(player)
  when 'in game'
    player.message << 'Enter the coordinates of the ship: '
    game.draw
    player.message.clear
    result = player.console_input
    game.send_mess_to_player(answers, player, result)
  when 'game over'
    player.enemy_field.draw_field(FieldPart::MAIN, Game::LETTERS)
    if player.shame
      puts 'What a shame...'
    else
      puts 'You win!'
    end
    break
  else
    raise("Wrong game status #{game.status}")
  end
end
