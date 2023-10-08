# Arch Linux Installation process


## Bootloader

 - ensure to mount ESP to /efi (and generate corresponding fstab) during setup so that rEFInd works correctly
 - the way to do this is:
   1. create the `/efi` directory
   2. mount the EFI (ESP) partition to it
   3. run [pacstrap](https://wiki.archlinux.org/title/installation_guide#Install_essential_packages)
   4. create the `/mnt/efi/EFI/arch` directory
   5. move the files generated in `/mnt/boot` to `/mnt/efi/EFI/arch`
   6. ensure that the files were *moved* and `/boot` is now *empty*
   7. [create a bind mount](https://wiki.archlinux.org/title/EFI_system_partition#Using_bind_mount) with `mount --bind /esp/EFI/arch /boot`
   8. now upon running `genfstab` this will be cemented
   9. on getting to the [initramfs](https://wiki.archlinux.org/title/installation_guide#Initramfs) step of the install, verify that the initramfs files appear identically in `/esp/EFI/arch` and `/boot  `
 - For the [bootloader](https://wiki.archlinux.org/title/installation_guide#Boot_loader) section, follow [the rEFInd wiki page](https://wiki.archlinux.org/title/REFInd#Installation_with_refind-install_script)
 - Because the bootloader config is being generated from within the chroot environment, it is necessary to edit the [refind_linux.conf](https://wiki.archlinux.org/title/REFInd#refind_linux.conf) file to include the actual partition uuids and kernel arguments
