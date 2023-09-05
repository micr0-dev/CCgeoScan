## GeoScan for ComputerCraft's Pocket GeoScanner

A LUA script specifically crafted for the Pocket GeoScanner peripheral in the Computer Craft mod when combined with the Advanced Peripherals mod.

![Screenshot from 2023-09-04 22-06-55](https://github.com/MiraslauKavaliou/CCgeoScan/assets/26364458/7e60c060-3d9a-4bd3-9639-96f768f5a647)

![Screenshot from 2023-09-04 22-07-16](https://github.com/MiraslauKavaliou/CCgeoScan/assets/26364458/aec1b1e1-f28c-4ed1-b664-e761c2e76810)

![Screenshot from 2023-09-04 22-04-45](https://github.com/MiraslauKavaliou/CCgeoScan/assets/26364458/e32005f1-6ce3-4ca6-ba86-1eb46aebd826)

#### Installation

1. Ensure you have both the Computer Craft mod and Advanced Peripherals mod installed.
2. Using the Computer Craft terminal, run the following command:
   ```lua
   wget https://pastebin.com/raw/75yBSSJ6 geoScan
   ```

#### Usage

To start using GeoScan, simply type the command followed by the desired block name(s) and an optional scan mode:

```lua
geoScan <block(s)> [auto|mine]
```

- `auto`: Automatically scan every second.
- `mine`: Show the best vein to mine and where.
- `default`: Show all matching blocks in radius.
- For multiple blocks, separate them with a comma, like: `geoScan iron,diamond auto`.

For a complete usage guide, type any of the following commands:
```lua
geoScan help
geoScan h
geoScan -h
```

#### A Note From The Creator

This is my first time coding in LUA, and I embarked on this project solo. I'm proud of the result and hope the Minecraft community finds it as helpful as I do.

#### License

This project is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).
