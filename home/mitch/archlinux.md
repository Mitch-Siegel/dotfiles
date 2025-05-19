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


## post-install
 - [NetworkManager](https://wiki.archlinux.org/title/NetworkManager) for network
   - enable and start the systemctl service `NetworkManager`
 - [sudo](https://wiki.archlinux.org/title/sudo)
   - add `USER_NAME   ALL=(ALL:ALL) ALL` below `ROOT ALL=(ALL:ALL) ALL` to enable a user to use sudo at maximum permission
 - `alacritty`, `zsh`, oh-my-zsh
   - `alacritty` and `zsh` available as pacman packages
   - oh-my-zsh installable [here](https://ohmyz.sh/#install)
     - requires `git` to be installed
 - [sway](https://wiki.archlinux.org/title/sway)
   - systemd-logind should already be installed, so just install `polkit` and off to the races
   - or at least, it should be... on my system (10/8/2023, 7700x/32gb/3080/3070/990Pro) running `sway` just locks the system up, necesitating a restart
     - doesn't matter if running as root or user
   - this was due to integrated graphics being enabled? turning it off after enabling nvidia to the modules list and rengerating initramfs made nouveau stop being loaded
