{ config, pkgs, ... }:

{
    services.xserver = {
        displayManager = {
            defaultSession = "none+i3";
        };

        windowManager.i3 = {
            enable = true;
            extraPackages = with pkgs; [
                dmenu
                i3status
                i3lock
                i3blocks
            ];
        };
    };	
}