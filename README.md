<!-- SPDX-License-Identifier: MIT -->
<!-- SPDX-FileCopyrightText: Copyright 2026 Sam Blenny -->
# Lua Sandbox

This is a sandbox repo for me to experiment with Lua stuff.


## Raspberry Pi OS 13 (Debian 13) Packages

Install packages
```
$ sudo apt install lua-argparse lua-check lua-filesystem lua5.4
```

Check installed files and docs
```
$ pi@raspberrypi:~ $ dpkg -L lua5.4
/usr/bin/lua5.4
/usr/bin/luac5.4
/usr/share/doc/lua5.4
/usr/share/doc/lua5.4/changelog.Debian.gz
/usr/share/doc/lua5.4/copyright
/usr/share/man/man1/lua5.4.1.gz
/usr/share/man/man1/luac5.4.1.gz
$ man lua5.4.1
$ man luac5.4.1
```


## Examples


### Bitwise AND + Hex Format

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
