class Border
  # +: 43 +: 43 +: 43 +: 43 -: 45 |: 124
  # ┌: 9484 ┐: 9488 └: 9492 ┘: 9496 ─: 9472 │: 9474
  # ┏: 9487 ┓: 9491 ┗: 9495 ┛: 9499 ━: 9473 ┃: 9475
  # ╔: 9556 ╗: 9559 ╚: 9562 ╝: 9565 ═: 9552 ║: 9553

  BORDERS = {
    0 => [32, 32, 32, 32, 32, 32],
    1 => [43, 43, 43, 43, 45, 124],
    2 => [9484, 9488, 9492, 9496, 9472, 9474],
    3 => [9487, 9491, 9495, 9499, 9473, 9475],
    4 => [9556, 9559, 9562, 9565, 9552, 9553],
  }

  def self.for(size:)
    BORDERS[size] || BORDERS[0]
  end
end

def draw_rectangle(x, y, width, height, color:)
  x1, x2 = x, x+width
  y1, y2 = y, y+height

  (x1..x2).each do |i|
    (y1..y2).each do |j|
      TB2.set_cell(i,j,0,color,"\s".ord)
    end
  end
end

def draw_rectangle_with_border(x, y, width, height, color:, border:)
  x1, x2 = x, x+width
  y1, y2 = y, y+height

  tl,tr,bl,br,hb,vb = Border.for(size: border)

  draw_rectangle(x, y, width, height, color: color)

  TB2.set_cell(x1, y1,1,color, tl)
  TB2.set_cell(x2, y1,1,color, tr)
  TB2.set_cell(x1, y2,1,color, bl)
  TB2.set_cell(x2, y2,1,color, br)

  (x1+1...x2).each do |i|
    TB2.set_cell(i,y1,1,color, hb)
    TB2.set_cell(i,y2,1,color, hb)
  end

  (y1+1...y2).each do |j|
    TB2.set_cell(x1,j,1,color, vb)
    TB2.set_cell(x2,j,1,color, vb)
  end

  TB2.print(x1+1, y1,1,color, " Hello, World! ")
end

TB2.init
draw_rectangle_with_border(5,8,30,5, color: 8, border: 1)
draw_rectangle_with_border(5,15,30,5, color: 8, border: 2)
draw_rectangle_with_border(5,22,30,5, color: 8, border: 3)
draw_rectangle_with_border(5,29,30,5, color: 8, border: 4)

draw_rectangle_with_border(37,8,30,5, color: 0, border: 1)
draw_rectangle_with_border(37,15,30,5, color: 0, border: 2)
draw_rectangle_with_border(37,22,30,5, color: 0, border: 3)
draw_rectangle_with_border(37,29,30,5, color: 0, border: 4)
TB2.present
event = TB2.poll_event
TB2.tb_shutdown
