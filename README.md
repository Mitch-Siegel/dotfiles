# dotfiles

## It Would be Cool if I Could use a Single Drive for *Everything* on my Computer
And I really do mean everything. I want to be able to natively run windows and linux from the drive. I want a bootloader scheme that doesn't require maintenance (*cough* grub *cough*). 

But here's the kicker: I hate dual booting. The only real reason I need Windows at all is for games. Being able to drop into Windows if I brick Linux is also a nice extra. But constantly having to ping back and forth between Windows and Linux is just something I'm sick of.

### What if running Windows natively *could* be something I do only as a last resort? 
I've spent plenty of time in a Windows VM using a second GPU passed through with VFIO to play games. I never went as far as to pass through an entire USB hub to try VR with this method. I never tried to hit all the performance optimizations to squeeze every last drop out of the VM. But it was good enough for general keyboard and mouse gaming. It would be nice to find out just how far I can take this concept.

### Duplicating Windows installs sucks
Previously, I had run a Windows install on an actual parttion of my drive, and one in a virtual disk. This was extremely lame, not to mention a colossal waste of disk space. I had to install everything twice, and would frequently be missing things I needed on one of the installs. And that's to say nothing of keeping track of what files went where. The only thing that made it at all manageable was that I had most of my games on separate drives, which would be accessible regardless of whether I was on the baremetal Windows or VM Windows.

### Now I want to fully send it
The goal here is not only to outline, document, and archive information about my Linux setup, but also to serve as a proof-of-concept for using the same drive partition for native Windows and a Windows QEMU/KVM setup. Doing this would mean that I would only ever have to dual boot if I needed native Windows (or if the VR performance doesn't pan out to be good enough for my gaming needs.) While passing through single partitions of host drives to a QEMU/KVM machine is doable, I'm not aware of anyone who's done exactly what I'm looking at here.

## this is the bad place
 - most of the documentation here is relatively unedited, really only intended for my use
 - this will surely bite me later as having better docs will be useful when I eventually brick something
 - if you're reading this and have questions you probably know how to ask me questions already. hi :)
