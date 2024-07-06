#!/bin/bash

set -e

SOURCES=${HOME}/sources
CROPDROID_HOME=${SOURCES}/go-cropdroid
RPI_KERNEL=${SOURCES}/qemu-rpi-kernel

qemu-system-arm \
	-M versatilepb \
	-cpu arm1176 \
	-m 256 \
	-hda ${CROPDROID_HOME}/extra/devops/images/node1.img \
	-net user,hostfwd=tcp::5022-:22 \
	-dtb ${RPI_KERNEL}/versatile-pb-buster.dtb \
	-kernel ${RPI_KERNEL}/kernel-qemu-4.19.50-buster \
	-append 'root=/dev/sda2 panic=1' \
	-no-reboot

qemu-system-arm \
	-M versatilepb \
	-cpu arm1176 \
	-m 256 \
	-hda ${CROPDROID_HOME}/extra/devops/images/node2.img \
	-net user,hostfwd=tcp::5022-:22 \
	-dtb ${RPI_KERNEL}/versatile-pb-buster.dtb \
	-kernel ${RPI_KERNEL}/kernel-qemu-4.19.50-buster \
	-append 'root=/dev/sda2 panic=1' \
	-no-reboot

qemu-system-arm \
	-M versatilepb \
	-cpu arm1176 \
	-m 256 \
	-hda ${CROPDROID_HOME}/extra/devops/images/node3.img \
	-net user,hostfwd=tcp::5022-:22 \
	-dtb ${RPI_KERNEL}/versatile-pb-buster.dtb \
	-kernel ${RPI_KERNEL}/kernel-qemu-4.19.50-buster \
	-append 'root=/dev/sda2 panic=1' \
	-no-reboot
