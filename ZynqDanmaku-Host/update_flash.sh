scp skyworks@thu-skyworks.org:~/ZynqDanmaku/ZynqDanmaku-Petalinux/danmaku/images/linux/image.ub .
dd if=image.ub of=/dev/mtdblock2
scp skyworks@thu-skyworks.org:~/ZynqDanmaku/ZynqDanmaku-Petalinux/danmaku/images/linux/BOOT.BIN .
dd if=BOOT.BIN of=/dev/mtdblock0

# m25p80 spi0.0: s25fl256s1 (32768 Kbytes)
# 4 ofpart partitions found on MTD device spi0.0
# Creating 4 MTD partitions on "spi0.0":
# 0x000000000000-0x000000500000 : "boot"
# 0x000000500000-0x000000520000 : "bootenv"
# 0x000000520000-0x000000fa0000 : "kernel"
# 0x000000fa0000-0x000002000000 : "spare"