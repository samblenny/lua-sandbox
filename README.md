<!-- SPDX-License-Identifier: MIT -->
<!-- SPDX-FileCopyrightText: Copyright 2026 Sam Blenny -->
# Lua Sandbox

This is a sandbox repo for me to experiment with Lua stuff.


## Raspberry Pi OS 13 (Debian 13) Packages

Install packages
```
sudo apt install lua5.1 lua5.2 lua5.3 lua5.4 lua-check lua-inspect love
```

Debian includes various Lua versions, and the value of `/usr/bin/lua` gets set
by the Debian alternatives system. The lua5.3 package gets highest priority if
it's installed:

Check which lua version is being used
```
readlink -f /usr/bin/lua
update-alternatives --display lua-interpreter
```

Install TigerVNC (this is for running love2d)
```
sudo apt install tigervnc-standalone-server openbox xterm

# Set password to 123456 or whatever (stored in ~/.config/tigervnc/passwd)
tigervncpasswd

# Make a config file, mainly to override the localhost default
mkdir -p $HOME/.config/tigervnc
cat <<'EOF' > ~/.config/tigervnc/config.pl
$geometry = "640x480";
$depth = "16";
$localhost = "no";
$SecurityTypes = "VncAuth";
EOF

# Add VNC start/stop convenience functions to .bashrc
cat <<'EOF' >> ~/.bashrc
function vnc-start() { tigervncserver :1; }
function vnc-stop() { tigervncserver -kill :1; }
EOF

# Set OpenBox desktop background color
mkdir -p ~/.config/openbox
cat <<'EOF' >> ~/.config/openbox/autostart.sh
xsetroot -solid "#6f206f"
EOF
```

Start the server
```
vnc-start
```

Stop the server
```
vnc-stop
```

Tune Pi Zero 2 W sysctl config for VNC performance and reduced SD card writes
```
cat <<'EOF' | sudo tee /etc/sysctl.d/99-pi-tuning.conf
# Swap less compared to the default of 60
vm.swappiness=10
# Delay SD card writes
vm.dirty_writeback_centisecs=3000
vm.dirty_ratio=15
vm.dirty_background_ratio=5
# Disable NMI watchdog
kernel.nmi_watchdog=0
# Pi Zero 2 W - USB gadget tuning for VNC
net.core.rmem_max = 524288
net.core.wmem_max = 524288
net.ipv4.tcp_rmem = 4096 131072 524288
net.ipv4.tcp_wmem = 4096 131072 524288
EOF
sudo sysctl --system
```


## Lua Interpreter Examples

Bitwise AND + Hex Format
```
$ lua5.4
Lua 5.4.7  Copyright (C) 1994-2024 Lua.org, PUC-Rio
> 0x55 & 0xF0
80
> function hex(n)
>> return string.format("0x%x", n)
>> end
> hex(0x55 & 0xF0)
0x50
> os.exit()
```


## LÖVE (Love2D) Examples

For this to these to work, you need to make a folder and put the code in a
main.lua file in that folder.

```
mkdir helloworld
cat <<'EOF' > helloworld/main.lua
function love.draw()
    love.graphics.print("Hello World!", 100, 100)
end
EOF
# If you haven't started VNC already, do this, then start a VNC client...
vnc-start
# The DISPLAY=:1 is necessary when running this on SSH (but not in an xterm)
DISPLAY=:1 love helloworld
```

There's also a LÖVE GUI launcher (Duckloon) in OpenBox. You can find it by
right-clicking the desktop to open the launcher menu, then picking Applications
-> Games -> LÖVE. If the launcher doesn't find any games, you'll just see a
duck balloon with "NO GAMES" spelled out on its string. To exit the launcher,
use the ESC key or close its window. So far I haven't figured out how to get
the Duckloon GUI to find any .love files on Debian. Trying to follow the few
directions I've found about how to do it didn't get me anywhere.
