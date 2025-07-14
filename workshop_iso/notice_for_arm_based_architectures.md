The guidelines provided by @tkea

- Install UTM (via Mac app store or website). 
- You also need QEMU to convert the VM from OVA to QCOW2 (which is the format used by UTM/QEMU).

## Install QEMU and convert the OVA to a UTM-compatible image

```
brew install qemu

tar -xvf lubuntu_foss4g_ws2.ova

qemu-img convert -f vmdk -O qcow2 lubuntu_foss4g_ws-disk002.vmdk foss4g.qcow2
```

## Create a new VM in UTM:

- New VM -> Emulate -> Other -> select "foss4g.qcow2" as "Boot ISO Image" -> Next
- Hardware Screen: I chose 8192 GB Memory and 8 cores.
- Summary Screen: Check "Open VM Settings"

## VM Settings:
- System -> Check "Force Multicore"
- QEMU -> Uncheck "UEFI Boot":

<img width="2024" height="1528" alt="image" src="https://github.com/user-attachments/assets/2662a3c9-865d-4f36-92f5-44e9d7dacbe4" />

## Importing the foss4g.qcow2 image

- for each "drive" (Under "Drives" in the left sidebar menu), right click on each one and delete it.
- press "New" to create a new drive, and then "Import". Choose the foss4g.qcow2 image.

The VM can now be started (it will take quite some time to boot).
