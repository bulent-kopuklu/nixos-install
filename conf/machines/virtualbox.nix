
{ config, pkgs,... }:

{
    boot.loader.grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";
    };

    users.extraGroups.vboxusers.members = [
        "bulentk" 
    ];
    
    virtualisation.virtualbox.guest.enable = true;
}