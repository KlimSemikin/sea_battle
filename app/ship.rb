# frozen_string_literal: true

# Корабль. Хранит координаты и свои HP.
class Ship
  include Cell
  attr_accessor :x_pos, :y_pos, :width, :height, :hp

  def initialize(size, x_pos, y_pos, rotation)
    @size = size
    @hp = size
    @x_pos = x_pos
    @y_pos = y_pos
    @rotation = rotation
    set_rotation(rotation)
  end

  def to_s
    Cell::SHIP_CELL
  end

  def set_position(x_pos, y_pos, rotation)
    @x_pos = x_pos
    @y_pos = y_pos
    set_rotation(rotation)
  end

  def set_rotation(rotation)
    @rotation = rotation

    case @rotation
    when 0
      @width = @size
      @height = 1
    when 1
      @width = 1
      @height = @size
    when 2
      @y_pos -= @size + 1
      @width = @size
      @height = 1
    when 3
      @x_pos -= @size + 1
      @width = 1
      @height = @size
    else
      raise('Wrong rotation value')
    end
  end
end
