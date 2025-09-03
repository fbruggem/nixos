sudo rm -rf /etc/nixos
sudo nixos-generate-config
sudo mv /etc/nixos/hardware-configuration.nix /tmp/hardware-configuration.nix
sudo rm -rf /etc/nixos
sudo git clone git@github.com:FelixBrgm/nixos.git /etc/nixos
sudo mv /tmp/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
sudo nixos-rebuild switch
