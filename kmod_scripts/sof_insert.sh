#!/bin/bash

modprobe snd_soc_rt5670
modprobe snd_soc_rt5645
modprobe snd_soc_rt5651
modprobe snd_soc_rt5640
modprobe snd_soc_da7213
modprobe snd_soc_pcm512x_i2c
modprobe snd_soc_wm8804_i2c
modprobe snd_soc_tdf8532
modprobe snd_soc_rt274

modprobe sof_acpi_dev
modprobe sof_pci_dev


