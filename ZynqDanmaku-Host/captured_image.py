#!/usr/bin/env python3
import cv2
import numpy as np
import sys

def create_blank(width, height, rgb_color=(0, 0, 0)):
    """Create new image(numpy array) filled with certain color in RGB"""
    # Create black blank image
    image = np.zeros((height, width, 3), np.uint8)

    # Since OpenCV uses BGR, convert the color first
    color = tuple(reversed(rgb_color))
    # Fill image with color
    image[:] = color

    return image

width, height = 1920, 1080

byte_array = np.fromfile(sys.argv[1], np.uint8, -1)

image = byte_array.reshape((height, width, 1))
# cv2.imwrite('red.jpg', image)
cv2.imshow('capture', image)
cv2.waitKey()