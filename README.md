<br />
<div align="center">
  <a href="https://github.com/WirzRexTon/rVigneron"> </a>
  <h3 align="center">winemaking job - Legacy x OX</h3>

  <p align="center">
    A winemaking job made for you! 
    <br />
    <a href="https://discord.gg/v8nrrJd4Zw">Discord RexTon</a>
    ·
    <a href="https://discord.com/invite/RPX2GssV6r">ESX Discord</a>
    ·
    <a href="https://documentation.esx-framework.org/">ESX Documentation</a>
  </p>
</div>

## About The Project
Hello, this is a simple looking winemaking job. But I find it very well done in terms of programming. If you have any feedback to give me, please join the discord. 

## Getting Started

### Installation : 

1. You must have an artifact greater than or equal to `6116` ! (https://runtime.fivem.net/artifacts/fivem/)
2. Import the sql into your database. 
3. Check that the config.lua is in order 
4. Start the resource in the server.cfg 
   ```sh
    ensure rVigneron
   ```
4. Launch your server and enjoy. 

### Disclaimer

I could help to make this job work without ox_inventory. But for other changes (including major ones) I could not help you. 

_Do not try to take over this work and sell it._

### Add item in ox_inventory 

1. Go to [ox]/ox_inventory/data/items.lua
2. Here are the items you need by default for the job
  ```sh
    ['water'] = {
      label = 'Water',
      weight = 500,
      client = {
        status = { thirst = 200000 },
        anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
        prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
        usetime = 2500,
        cancel = true,
        notification = 'You drank some refreshing water'
      }
    },

    ["grape"] = {
      label = "Grape",
      weight = 250,
      stack = true,
      close = true,
    },

    ["wineyeast"] = {
      label = "wine-making yeast",
      weight = 150,
      stack = true,
      close = true,
    },

    ["wine"] = {
      label = "Vin",
      weight = 500,
      stack = true,
      close = true,
    },
  ```
5. Just restart ox_inventory and try! 


## Contact

WirzRexton - (https://discord.gg/v8nrrJd4Zw) 

