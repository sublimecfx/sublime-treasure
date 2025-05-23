# Sublime Treasure

An automatic and legal event system that regularly triggers an immersive treasure hunt in the city or rural areas.

## Features

### Treasure Hunt System
- Automatic events every 3 hours
- Event duration: 1 hour
- Configurable treasure spawn zones
- Multi-language support (EN, FR, ES, DE, IT, PT)
- Customizable reward system

### Configurable Rewards (with chance rates)
- Items
- Money
- Weapons
- Vehicles
- Each reward can have its own chance rate

### Interface and Interaction
- Support for ox_target and qb-target
- Map blips to locate treasures
- Treasure opening animations
- Visual effects upon opening
- Admin commands:
  - `/starttreasurehunt` : Manually start a hunt
  - `/gototreasure` : Teleport to the treasure

### Advanced Logging System
- Comprehensive Discord webhook integration
- Detailed player information logging
- Event tracking (start, end, rewards)
- Staff action monitoring
- Cheat detection and reporting
- Vehicle reward tracking
- Location tracking for all events
- Server status information

### Multi-language Support
- English (en)
- French (fr)
- Spanish (es)
- German (de)
- Italian (it)
- Portuguese (pt)
- Easy to add new languages
- Complete translation of all messages and logs

### Compatibility
- Support for multiple frameworks:
  - ESX
  - QB-Core
  - Custom framework
- Support for multiple target systems:
  - ox_target
  - qb-target

### Configuration
- Adjustable event frequency
- Customizable spawn zones
- Configurable rewards
- Customizable blip appearance
- Configurable treasure models
- Customizable animations and effects
- Discord webhook configuration
- Language selection

## Requirements
- oxmysql
- A supported framework (ESX or QB-Core)
- Discord webhook URLs (for logging)

## Installation
1. Make sure you have the requirements installed
2. Place the resource in your `resources` folder
3. Add `ensure sublime-treasure` to your `server.cfg`
4. Configure zones and rewards according to your needs
5. Set up your Discord webhooks in `configs/webhooks.lua`
6. Choose your preferred language in `configs/locale.lua`
7. Restart your server

## Usage
- Treasure hunts trigger automatically
- Players can see blips on the map
- Use the target system to interact with treasures
- Administrators can use commands to manage events
- All actions are logged to Discord
- Staff actions are tracked and reported

## Configuration
All parameters are configurable in the `configs/` folder:
- `main.lua` : Main configuration
- `zones.lua` : Treasure spawn zones
- `perms.lua` : Permissions
- `locale.lua` : System language
- `webhooks.lua` : Discord webhook configuration
