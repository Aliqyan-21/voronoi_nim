import random

# width, height and number of seeds we will generate
# most likely we can make this a user input
const
  Width = 800
  Height = 600
  SeedsCount = 10

# this image array will store the pixels of image
var image: array[Height, array[Width, uint32]]

# style constants
const
  BACKGROUND_COLOR = 0xFF121212'u32
  SEED_MARKER_RADIUS = 5
  SEED_MARKER_COLOR = 0xFF121212'u32


# Palette colors inspired by Rosé Pine
const 
  base = 0xFF363123'u32
  surface = 0xFF403C4B'u32
  overlay = 0xFF62607D'u32
  muted = 0xFF9893A5'u32
  text = 0xFFE1D6E0'u32
  love = 0xFFB66A7B'u32
  gold = 0xFFF4CDAF'u32
  rose = 0xFFE2B7C5'u32
  pine = 0xFF8B9C31'u32
  foam = 0xFFB7D6C6'u32
  iris = 0xFFD6C2C5'u32
  highlight = 0xFFF7E9E9'u32

# p.x and py
type Point = object
    x: int
    y: int

# seeds and pallete array
var seeds: array[SeedsCount, Point]
var pallete: array[12, uint32] = [
    base, surface, overlay, muted, text, love, gold, rose, pine, foam, iris, highlight
]

# fills image with the provided color
proc fill_image(color: uint32) =
  for y in 0..<Height:
    for x in 0..<Width:
      image[y][x] = color

# genenerate output file
proc save_image_ppm(file_path: string) =
  try:
    let outF = open(file_path, fmWrite)
    defer: outF.close
    outF.write("P6\n" & $Width & " " & $Height & "\n255\n")
    for y in 0..<Height:
      for x in 0..<Width:
        var pixel: uint32 = image[y][x]
        # masking and taking individual r,g and b
        var bytes: array[3, uint8] =  [
          cast[uint8]((pixel and 0x0000FF) shr (8 * 0)),
          cast[uint8]((pixel and 0x00FF00) shr (8 * 1)),
          cast[uint8]((pixel and 0xFF0000) shr (8 * 2)),
        ]
        # outF.write(bytes)
        discard outF.write_buffer(bytes[0].addr(), sizeof(bytes))
  except IOError:
    stderr.write("File not found: " & file_path & "\n")
    quit(1)

# sqrt distance: d = sqrt(a^2 + b^2)
proc sqrt_dist(x1, y1, x2, y2: int): int =
  var
    dx: int = x1 - x2
    dy: int = y1 - y2
  return dx * dx + dy * dy

# make circle and fill it with given color, for seed markers
proc fill_circle(cx, cy, radius: int, color: uint32) =
  var
    x0: int = cx - radius
    y0: int = cy - radius
    x1: int = cx + radius
    y1: int = cy + radius

  for x in x0..x1:
    if x >= 0 and x < Width:
      for y in y0..y1:
        if y >= 0 and y < Height:
          if (sqrt_dist(cx, cy, x, y) <= radius * radius):
            image[y][x] = color

# random seed generator!
proc generate_random_seeds() =
  for i in 0..<SeedsCount:
    seeds[i].x = rand(Width - 1)
    seeds[i].y = rand(Height - 1)

# markers render
proc render_seed_markers() =
  for i in 0..<SeedsCount:
    fill_circle(seeds[i].x, seeds[i].y, SEED_MARKER_RADIUS, SEED_MARKER_COLOR)

# render the voronoi
proc render_voronoi() =
  for y in 0..<Height:
    for x in 0..<Width:
      var j: int = 0
      for i in 1..<SeedsCount:
        if sqrt_dist(seeds[i].x, seeds[i].y, x, y) < sqrt_dist(seeds[j].x, seeds[j].y, x, y):
          j = i
      image[y][x] = pallete[j mod pallete.len()]

when isMainModule:
  randomize();
  fill_image(BACKGROUND_COLOR)
  generate_random_seeds()
  render_voronoi()
  render_seed_markers();
  save_image_ppm("output.ppm");
