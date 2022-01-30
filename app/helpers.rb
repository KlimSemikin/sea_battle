# frozen_string_literal: true

module Color
  WHITE = "\033[1;37m"
  RESET = "\033[0m"
  BLUE = "\033[0;34m"
  YELLOW = "\033[1;93m"
  RED = "\033[31m"
  MISS = "\033[0;37m"
end

def set_color(text, color)
  color + text + Color::RESET
end

# "клетка". Здесь мы задаем и визуальное отображение клеток и их цвет.
module Cell
  # функция которая окрашивает текст в заданный цвет.
  EMPTY_CELL = set_color('·', Color::RESET)
  SHIP_CELL = set_color('S', Color::YELLOW)
  DESTROYED_SHIP = set_color('S', Color::RED)
  DAMAGED_SHIP = set_color('X', Color::RED)
  MISS_CELL = set_color('o', Color::MISS)
end

module FieldPart
  MAIN = 'map'
  RADAR = 'radar'
end
