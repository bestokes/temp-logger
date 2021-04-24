import time
import busio
from board import SCL, SDA

from oled_text import OledText, Layout64, BigLine, SmallLine

i2c = busio.I2C(SCL, SDA)
oled = OledText(i2c, 128, 64)

oled.layout = Layout64.layout_icon_1big_2small()
oled.auto_show = False
oled.text('\uf2ca', 1)
oled.text("VAR C", 2)
oled.text("Room", 3)
oled.text("temp", 4)
oled.show()
oled.auto_show = True
