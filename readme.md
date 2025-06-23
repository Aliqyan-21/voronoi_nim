# Nim Voronoi Diagram Generator

A simple Nim project to generate a Voronoi diagram with random seed points, colored using a Rosé Pine-inspired palette, and saved as a PPM image. This project is designed for learning Nim’s basics, including arrays, types, file I/O, and bitwise operations.

![output](assets/output.png)

## Purpose
This project demonstrates:
- Generating random points using the `random` module.
- Bitwise operations to extract RGB colors from ABGR `uint32` pixels.
- Writing binary PPM (`P6`) files for image output.
- Creating a Voronoi diagram with a custom color palette.

## Implementation Details
- **Language**: Nim
- **Structure**:
  - **Point Type**: `Point = object` with `x, y: int` for seed coordinates.
  - **Image Array**: `array[Height, array[Width, uint32]]` stores ABGR pixels.
  - **Palette**: 12 Rosé Pine-inspired colors (e.g., `base = 0xFF363123’u32`) in ABGR format.
  - **Seeds**: `array[SeedsCount, Point]` with random `x, y` in `[0, Width-1]` and `[0, Height-1]`.
- **Key Procedures**:
  - `fill_image(color)`: Fills the image with a background color (e.g., `0xFF121212`).
  - `generate_random_seeds()`: Uses `rand()` to place `SeedsCount` random points.
  - `sqrt_dist(x1, y1, x2, y2)`: Computes squared Euclidean distance for Voronoi regions.
  - `render_voronoi()`: Assigns each pixel the color of the nearest seed’s palette entry.
  - `fill_circle(cx, cy, radius, color)`: Draws seed markers as circles.
  - `save_image_ppm(file_path)`: Writes the image as a PPM file, extracting RGB bytes from ABGR pixels using bitwise operations (`and`, `shr`).
- **File I/O**: Uses `writeBuffer` to write raw RGB bytes to `output.ppm`.
- **Palette**: Rosé Pine colors (e.g., `love = 0xFFB66A7B`, RGB `235, 106, 146`) for soft, muted Voronoi regions.

## Usage
1. Install Nim: `choosenim stable`.
2. Compile and run: `nim c -r voronoi.nim`.
3. Output: `output.ppm` (view in GIMP, feh, etc).
4. Customize: Adjust `Width`, `Height`, `SeedsCount`, or palette in `voronoi.nim`.

## Notes
- **Color Format**: ABGR `uint32` (alpha, blue, green, red) for compatibility with C++-style pixel handling.
- **Seed Markers**: Dark gray (`0xFF121212`) may be faint; try `0xFFF7E9E9` for white.
- **Improvements**: Add command-line args for dimensions or seed count, or optimize distance calculations.
