#
# Topology for AppoloLake with headset on SSP1, spk on SSP5 and DMIC capture
#

# Include topology builder
include(`utils.m4')
include(`dai.m4')
include(`pipeline.m4')
include(`ssp.m4')

# Include TLV library
include(`common/tlv.m4')

# Include Token library
include(`sof/tokens.m4')

# Include bxt DSP configuration
include(`platform/intel/bxt.m4')
include(`platform/intel/dmic.m4')

#
# Define the pipelines
#
# PCM0 ----> volume -----> SSP5 (speaker - maxim98357a)
# PCM1 ----> volume -----> SSP1 (headset - da7219)
# PCM0 <---- volume <----- DMIC0 (dmic capture)
#

# Low Latency playback pipeline 1 on PCM 0 using max 2 channels of s32le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-playback.m4,
	1, 0, 2, s32le,
	48, 1000, 0, 0)

# Low Latency playback pipeline 2 on PCM 1 using max 2 channels of s32le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-playback.m4,
	2, 1, 2, s32le,
	48, 1000, 0, 0)

# # Low Latency capture pipeline 3 on PCM 0 using max 4 channels of s32le.
# # Schedule 48 frames per 1000us deadline on core 0 with priority 0
# PIPELINE_PCM_ADD(sof/pipe-volume-capture.m4,
# 	3, 0, 4, s32le,
# 	48, 1000, 0, 0)


#
# DAIs configuration
#

# playback DAI is SSP5 using 2 periods
# Buffers use s16le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	1, SSP, 5, SSP5-Codec,
	PIPELINE_SOURCE_1, 2, s16le,
	48, 1000, 0, 0)

# playback DAI is SSP1 using 2 periods
# Buffers use s16le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	2, SSP, 1, SSP1-Codec,
	PIPELINE_SOURCE_2, 2, s16le,
	48, 1000, 0, 0)

# # capture DAI is DMIC0 using 2 periods
# # Buffers use s16le format, with 48 frame per 1000us on core 0 with priority 0
# DAI_ADD(sof/pipe-dai-capture.m4,
# 	3, DMIC, 0, DMIC0,
# 	PIPELINE_SINK_3, 2, s32le,
# 	48, 1000, 0, 0)


# FIXME: Why is this needed? And is this correct?
# PCM (PCM_CAPTURE_ADD(name, pipeline, pcm_id, dai_id, capture))

# this was used on for sof-apl-pcm512x, no idea why there are two pipelines
# PCM_PLAYBACK_ADD(Port5, 0, 0, 0, PIPELINE_PCM_1, PIPELINE_PCM_2)

PCM_PLAYBACK_ADD(SSP5, 0, 0, 0, PIPELINE_PCM_1)
PCM_PLAYBACK_ADD(SSP1, 1, 1, 1, PIPELINE_PCM_2)

#PCM_CAPTURE_ADD(DMIC0, 2, 2, 2, PIPELINE_PCM_3)

#
# BE configurations - overrides config in ACPI if present
#

# FIXME: the machine driver uses .name = "SSP5-Codec", .id=0, .cpu_name="SSP5 Pin"
#SSP 5 (ID: 0) with 24.576 MHz mclk with MCLK_ID 0
DAI_CONFIG(SSP, 5, 0, SSP5-Codec,
	SSP_CONFIG(I2S, SSP_CLOCK(mclk, 24576000, codec_mclk_in),
		SSP_CLOCK(bclk, 1536000, codec_slave),
		SSP_CLOCK(fsync, 48000, codec_slave),
		SSP_TDM(2, 16, 3, 3),
		SSP_CONFIG_DATA(SSP, 5, 16, 0)))

# FIXME: the machine driver uses .name = "SSP1-Codec", .id=1, .cpu_name="SSP1 Pin"
#SSP 1 (ID: 1) with 24.576 MHz mclk with MCLK_ID 0
DAI_CONFIG(SSP, 1, 1, SSP1-Codec,
	SSP_CONFIG(I2S, SSP_CLOCK(mclk, 24576000, codec_mclk_in),
		SSP_CLOCK(bclk, 1536000, codec_slave),
		SSP_CLOCK(fsync, 48000, codec_slave),
		SSP_TDM(2, 16, 3, 3),
		SSP_CONFIG_DATA(SSP, 1, 16, 0)))

# # FIXME: the machine driver uses .name = "dmic01" and .id=2
# # DMIC0 (id: 2)
# DAI_CONFIG(DMIC, 0, 2, dmic01,
# 	DMIC_CONFIG(1, 500000, 4800000, 40, 60, 48000,
# 		DMIC_WORD_LENGTH(s32le), DMIC, 0,
# 		PDM_CONFIG(DMIC, 0, FOUR_CH_PDM0_PDM1)))
