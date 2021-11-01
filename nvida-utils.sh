#!/bin/env bash

DEVICE_BUS_ID="0000:01:00.0"
CONTROLLER_BUS_ID="0000:00:01.0"
REMOVE_DEVICE=1
BUS_RESCAN_WAIT_SEC=1

function execute {
  if [[ ${DRY_RUN} -eq 1 ]]; then
    echo ">>Dry run. Command: $*"
  else
    eval "$@"
  fi
}

function turn_on_gpu {
  echo 'Turning the PCIe controller on to allow card rescan'
  execute "sudo tee /sys/bus/pci/devices/${CONTROLLER_BUS_ID}/power/control <<<on"

  echo 'Waiting 1 second'
  execute "sleep 1"

  if [[ ! -d /sys/bus/pci/devices/${DEVICE_BUS_ID} ]]; then
    echo 'Rescanning PCI devices'
    execute "sudo tee /sys/bus/pci/rescan <<<1"
    echo "Waiting ${BUS_RESCAN_WAIT_SEC} second for rescan"
    execute "sleep ${BUS_RESCAN_WAIT_SEC}"
  fi

  echo 'Turning the card on'
  execute "sudo tee /sys/bus/pci/devices/${DEVICE_BUS_ID}/power/control <<<on"
}

function turn_off_gpu {
  if [[ "$REMOVE_DEVICE" == '1' ]]; then
    echo 'Removing Nvidia bus from the kernel'
    execute "sudo tee /sys/bus/pci/devices/${DEVICE_BUS_ID}/remove <<<1"
  else
    echo 'Enabling powersave for the graphic card'
    execute "sudo tee /sys/bus/pci/devices/${DEVICE_BUS_ID}/power/control <<<auto"
  fi

  echo 'Enabling powersave for the PCIe controller'
  execute "sudo tee /sys/bus/pci/devices/${CONTROLLER_BUS_ID}/power/control <<<auto"
}
