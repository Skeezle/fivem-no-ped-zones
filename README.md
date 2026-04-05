# 🧍‍♂️ No Ped Spawn Zones
**Version:** 1.0.1 
**Author:** Skeezle  

This FiveM client-side script written for Qbox that prevents random NPCs and vehicles from spawning in specific areas — perfect for keeping your RP zones like mechanic shops, hospitals, and police stations clear.  

It’s lightweight, framework-independent, and runs efficiently on every client.

## Dependencies 

Polyzone

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

Create polyzones where you don't want peds or vehicles to spawn

## License

This project is licensed under the MIT License. You are free to use, modify, and distribute this script, including for commercial use, as long as the original license notice is included.
