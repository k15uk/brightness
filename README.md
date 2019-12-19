brightness
==========

## About

this plugin is brightness adjustment by timer

## Dependends

xrandr

### debian/ubuntu
``` bash
  apt install x11-xserver-utils
```

### Arch
``` bash
  pacman -S xorg-xrandr
```

### Gentoo
``` bash
  emerge xorg-xrandr
```


## Usage

### widget create

#### method create

  * first arg = device name ( example is 'HDMI-0' )

  * second arg = interval ( example is 10 minutes )

  ``` lua
  local brightness = require( "brightness" )
  brightness:create( 'HDMI-0' , 10 ) ,
  ```

### Set timer

  * arg = list on length 24

  Adjust the brightness with the offset amount for each hour at the interval specified in the "interval"

  ``` lua
  brightness:timer({
    '-0.01', -- 01:00
    '-0.01', -- 02:00
    '-0.01', -- 03:00
    '0'    , -- 04:00
    '0.01' , -- 05:00
    '0.01' , -- 06:00
    '0.01' , -- 07:00
    '0.01' , -- 08:00
    '0.01' , -- 09:00
    '0.01' , -- 10:00
    '0.01' , -- 11:00
    '0.01' , -- 12:00
    '0.01' , -- 13:00
    '0'    , -- 14:00
    '0'    , -- 15:00
    '0'    , -- 16:00
    '0'    , -- 17:00
    '0'    , -- 18:00
    '-0.01', -- 19:00
    '-0.01', -- 20:00
    '-0.01', -- 21:00
    '-0.01', -- 22:00
    '-0.01', -- 23:00
    '-0.01', -- 24:00
  })
  ```
