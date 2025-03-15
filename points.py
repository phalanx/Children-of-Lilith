import math
import sys

points = int(sys.argv[1])

slice = 2 * math.pi / points
for i in range(points):
    angle = slice * i
    newX = format(100 * math.sin(angle),'.6f')
    newY = format(100 * math.cos(angle),'.6f')
    rotZ = format(360 - math.degrees(angle), '.6f')
    print(f"X:{newX},Y:{newY},Z-Rotation:{rotZ}")