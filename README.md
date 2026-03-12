<!-- SPDX-License-Identifier: MIT -->
<!-- SPDX-FileCopyrightText: Copyright 2026 Sam Blenny -->
# Lua Sandbox

This is a sandbox repo for me to experiment with Lua stuff.


## Raspberry Pi OS 13 (Debian 13) Packages

Install packages
```
$ sudo apt install lua5.1 lua5.3 lua5.4 lua-check lua-inspect
```

Debian includes various Lua versions, and the value of `/usr/bin/lua` gets set
by the Debian alternatives system. The lua5.3 package gets highest priority if
it's installed:

```
$ readlink /usr/bin/lua
/etc/alternatives/lua-interpreter
$ readlink -f /usr/bin/lua
/usr/bin/lua5.3
$
$ update-alternatives --display lua-interpreter
lua-interpreter - auto mode
  link best version is /usr/bin/lua5.3
  link currently points to /usr/bin/lua5.3
  link lua-interpreter is /usr/bin/lua
  slave lua-manual is /usr/share/man/man1/lua.1.gz
/usr/bin/lua5.1 - priority 110
  slave lua-manual: /usr/share/man/man1/lua5.1.1.gz
/usr/bin/lua5.3 - priority 120
  slave lua-manual: /usr/share/man/man1/lua5.3.1.gz
/usr/bin/lua5.4 - priority 20
  slave lua-manual: /usr/share/man/man1/lua5.4.1.gz
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
