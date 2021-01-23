import platform
arch=platform.processor()

fpgamem_offset=0
mem_width=512

#x86 only
if arch == 'x86_64':
    fpgamem_mapbase=0
    traffic_engine_offset=0
    h2c_fpath='/dev/xdma0_h2c_0'
    c2h_fpath='/dev/xdma0_c2h_0'
else:
#mpsoc arm64 only
    fpgamem_mapbase=0x400000000
    traffic_engine_offset=0xA0011000
    cdma_offset=0xA0010000
    ps_buf_size=1024**3
    ps_offset=0
