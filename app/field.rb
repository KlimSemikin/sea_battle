# frozen_string_literal: true


# Поле. Будет состоять из двух частей: основная карта и радар.
# Поле будет проверять возможность расположения кораблей, расставлять корабли, уничтожать их.
class Field
  attr_accessor :radar, :size, :map

  def initialize(size)
    @size = size
    @map = Array.new(size) { Array.new(size, Cell::EMPTY_CELL) }
    @radar = Array.new(size) { Array.new(size, Cell::EMPTY_CELL) }
  end

  def get_field_part(element)
    case element
    when FieldPart::MAIN
      @map
    when FieldPart::RADAR
      @radar
    else
      raise('Wrong field value')
    end
  end

  def draw_field(element, letters)
    field = get_field_part(element)

    (-1...@size).each do |y|
      (-1...@size).each do |x|
        if x == -1 && y == -1
          print '   '
          next
        end

        if x == -1 && y >= 0
          space = ' ' * (2 - (y + 1).to_s.size)
          print "#{y + 1}#{space}"
          next
        end

        if x >= 0 && y == -1
          print "#{letters[x]} "
          next
        end

        print " #{field[x][y]}"
      end
      puts ''
    end
    puts ''
  end

  # Функция проверяет помещается ли корабль на конкретную позицию конкретного поля.
  def check_ship_fits(ship, element)
    field = get_field_part(element)

    if ship.x_pos + ship.height - 1 >=
       @size || ship.x_pos.negative? || ship.y_pos + ship.width - 1 >= @size || ship.y_pos.negative?
      return false
    end

    x = ship.x_pos
    y = ship.y_pos
    width = ship.width
    height = ship.height

    (x...x + height).each do |p_x|
      (y...y + width).each do |p_y|
        return true if field[p_x][p_y].to_s == Cell::MISS_CELL
      end
    end

    (x - 1..x + height).each do |p_x|
      (y - 1..y + width).each do |p_y|
        next if p_x.negative? || p_x >= field.size || p_y.negative? || p_y >= field.size
        return false if [Cell::SHIP_CELL, Cell::DESTROYED_SHIP].include? field[p_x][p_y].to_s
      end
    end
    true
  end

  # когда корабль уничтожен, клетки вокруг него помечаются сыграными.
  # а все клетки корабля - уничтожеными.
  def mark_destroyed_ship(ship, element)
    field = get_field_part(element)

    x = ship.x_pos
    y = ship.y_pos
    width = ship.width
    height = ship.height

    (x - 1..x + height).each do |p_x|
      (y - 1..y + width).each do |p_y|
        next if p_x.negative? || p_x >= field.size || p_y.negative? || p_y >= field.size

        field[p_x][p_y] = Cell::MISS_CELL
      end
    end

    (x...x + height).each do |p_x|
      (y...y + width).each do |p_y|
        field[p_x][p_y] = Cell::DESTROYED_SHIP
      end
    end
  end

  # добавление корабля: пробегаемся от позиции х у корабля по его высоте и ширине и помечаем на поле эти клетки
  # параметр element - сюда мы передаем к какой части поля мы обращаемся: основная, радар
  def add_ship_to_field(ship, element)
    field = get_field_part(element)

    x = ship.x_pos
    y = ship.y_pos
    width = ship.width
    height = ship.height

    (x...x + height).each do |p_x|
      (y...y + width).each do |p_y|
        field[p_x][p_y] = ship
      end
    end
  end
end
