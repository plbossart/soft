#
# Topology for pass through pipeline
#

# Include topology builder
include(`pipeline.m4')
include(`dai.m4')
include(`ssp.m4')
include(`utils.m4')

# Include TLV library
include(`common/tlv.m4')

# Include Token library
include(`sof/tokens.m4')

# Include bxt DSP configuration
include(`platform/intel/bxt.m4')

#
# Define the pipeline
#
# PCM0 <---> SSP 5
#

# Passthrough playback pipeline 1 on PCM 0 using max 2 channels of s16le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0

PIPELINE_PCM_DAI_ADD(sof/pipe-volume-playback.m4,
	1, 0, 2, s16le,
	48, 1000, 0, 0,
	SSP, 5, s16le, 2)
#
# DAI configuration
#
# SSP port 5 is our only pipeline DAI
#

# playback DAI is SSP 5 using 2 periods
# Buffers use s24le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	1, SSP, 5, SSP5-Codec,
	PIPELINE_SOURCE_1, 2, s16le,
	48, 1000, 0, 0)

# PCM Passthrough
PCM_PLAYBACK_ADD(Passthrough, 3, 0, 0, PIPELINE_PCM_1)

#
# BE configurations - overrides config in ACPI if present
#
# Clocks masters wrt codec
#
# TEST_SSP_DATA_BITS bit I2S using 20 bit sample conatiner on SSP 5
#
DAI_CONFIG(SSP, 5, 0, SSP5-Codec,
	   SSP_CONFIG(I2S,
		      SSP_CLOCK(mclk,19200000, codec_mclk_in),
		      SSP_CLOCK(bclk, 1920000, codec_slave),
		      SSP_CLOCK(fsync, 48000, codec_slave),
		      SSP_TDM(2, 20, 3, 3),
		      SSP_CONFIG_DATA(SSP, 5, 16, 0)))
