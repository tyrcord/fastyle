import os
import subprocess


def convert_svg_to_vec(folder_path):
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            if file.endswith(".svg"):
                svg_path = os.path.join(root, file)
                vec_path = svg_path + '.vec'

                # Run the command to convert the SVG file
                subprocess.run(
                    ["dart", "run", "vector_graphics_compiler", "-i", svg_path, "-o", vec_path])

                # Remove the original SVG file
                os.remove(svg_path)
                print(f"Converted and removed: {svg_path}")


convert_svg_to_vec("./assets")
