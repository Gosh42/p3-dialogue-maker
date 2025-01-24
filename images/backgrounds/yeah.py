from os import listdir
from os.path import isfile, join
from PIL import Image


path = r"D:\xJIaM\projects\p3-dialogue-maker\images\backgrounds"

files = [join(path, f) for f in listdir(path) if f.endswith(".png")]

images = [Image.open(f).crop((56, 0, 696, 448)) for f in files]

for i, image in enumerate(images):
    image.save(join(path, str(i) + ".png"))

print(files)