# 🧍‍♂️ No Ped Spawn Zones
**Version:** 1.0.0  
**Author:** Skeezle  

This FiveM client-side script prevents random NPCs and vehicles from spawning in specific areas — perfect for keeping your RP zones like mechanic shops, hospitals, and police stations clear.  

It’s lightweight, framework-independent, and runs efficiently on every client.

---

## 📦 Installation

1. **Add the Resource**  
   Copy or drag the folder (e.g. `no-ped-zones`) into your server’s `resources` directory:

resources/
└── no-ped-zones/
├── fxmanifest.lua
└── client.lua


2. **Add to Server Configuration**  
Open your `server.cfg` and add:


3. **Restart the Server**  
Either restart your server or run the following commands in the console:


---

## ⚙️ Configuration

Edit **`client.lua`** to define the restricted zones where NPCs and vehicles are blocked.

Example:

```lua
local restrictedZones = {
 {coords = vector3(-494.7597, 288.4936, 83.4150), radius = 25.0},  -- Sauce Mechanics
 {coords = vector3(309.1922, -589.1412, 43.2684), radius = 30.0},  -- Hospital
 {coords = vector3(-589.2979, -718.1133, 36.2606), radius = 25.0}, -- Police Department
}

Each entry includes:

coords — The center of the zone where peds and vehicles won’t spawn.

radius — The size of the area in meters.

You can add or remove as many entries as you need.

