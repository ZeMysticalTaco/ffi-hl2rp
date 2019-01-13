# Files
These are all the files to the FFI HL2RP.

# Support

For some time I'll be offering support on everything here, should you need help getting something working or something like that, I'm available on discord here: ZeMysticalTaco#1104 

I do not get on steam often anymore, so this is the best and fastest way to contact me, if you would like to immediately DM me, you can always join the Helix discord server and DM me directly from there. https://discord.gg/mJatDRd

## Documentation
*This section is a work in progress, and is not complete.*

#### Schema Overview

First off, I'm going to preface this with this schema was not intended for public release, and more than likely will not be modified and rectified as such, plugins will be modified individually and released for public use, however ANY plugins in this pack are not intended to support customized environments *unless* you customize it yourself. Support will be provided if you need help doing it, but there is no more promise than that, unless there's compensation involved, I won't make your modifications for you, as I just don't have the time.

Let's begin.
FFI-HL2RP was a server project I worked on for about a month every day and created all this content for it, the intention was to try and automate some of the more tedious tasks, and provide a healthy focus to the Citizen faction, the primary instances for this were the production system and the identity system, allowing an easier run CWU production that supports espionage and theft, the same sported for the identity system, almost everything in the schema is tied to the ID cards.

Save for the base schema and some other tidbits, everything in here was made by me, and I reserve the right their contents, if the plugins are modified in any manner, credit must be maintained.

Credits:

1 Gmod Legs 3; https://steamcommunity.com/sharedfiles/filedetails/?id=112806637

2 Facial Recognition, the original plugin base for the Combine Hud; Elec

3 Thirdperson; TFA


#### Plugin Overview


##### Application System
Description: The Application System is an in-built CCA application system built using MySQL, which allows players to apply for your respective MPF branches in-game.

Customization:
Customizing the questions of the Application System is simple, and the questions can be found in cl_panels.lua, keep in mind you'll have to change both the view text and the application panel text, the application view panel text starts at line 127, and end at line 248, for the application window itself, it starts at line 326 and ends at 472.

I do not provide support for adding additional questions, you'll have to figure it out yourself, or change existing questions.

Known Errors:
When there are no applications present, when opening on the view application interface (/viewapplications) an error will output.


To Use: Spawn an application terminal. Citizens will be able to press use on it and apply. Viewing applications by default is admin only; when accepting an application; the citizen will receive a card either next log-on or immediately if they're on the server, which can be turned into the MPF to get a whitelist.
##### New Attributes
Description: Adds new attributes.

Customization: You can customize the jump height in sh_acr.lua
To refer to the attribute in code, use the tag "acr".

Known Errors: none

##### Citizen Production
Description: A full on automated production system using Black Tea's old crafting system as a base.
Customization: You can add new blueprints in sh_items.lua and new items via lua generation in sh_items.lua.
To Use: Spawn the production table entity. Users in the CWU faction or MPF faction can use the "production" menu, which will spawn items and blueprints according, place a blueprint in the table along with all the items need for it and click produce, and it will create items.

##### Crafting
Description: Legacy version of the Crafting System, this is an out of date version of: https://github.com/ZeMysticalTaco/helix-crafting

Customization: New recipes can be added in sh_plugin.lua, new items can be added via lua generated code at sh_items.lua



##### Identity System
Description: The bread and butter of the schema, a full on identity system, when characters are created they will receive a card,  this card serves as an identifier for machines such as the loyalty kiosk, a machine which dispenses wages and items.

Customization: To add new loyalty items use the BUILD_LOYALTY table, all the other ones are legacy adding methods and will not be supported if you have errors, you can set what factions can use it and if having that specific loyalty item will disable another; for instance metropolice wages disable normal citizen wages, cooldown is in seconds.

ID cards are given on spawn, except if you're a citizen, you're instead given transfer papers, take these to an officer who can make an ID card for you, provided a CID terminal is spawned.

Known issues: using a name format other than the one provided by the schema will break ID cards for MPF and the combine hud.

##### Item Population
Description: Populates the schema with miscellaneous items.

##### Quests
Description: A fully functional quest system.

Customization: All quest dialogue and data is in sh_plugin.lua.

To Use: Spawn a quest NPC, and hold ALT and press E on it, to customize name, quests and all.

Known issues: Text cuts off in dialogue after a certain point.
##### Radio
Description: A better radio system, using text frequencies instead of numerics.

Customization: You can add new radio items in the items folder.

/togglefrequency will toggle a frequency on someone
/setprimaryfrequency is needed if you don't have a radio item for your frequency and must use quotes for ones with spaces ie "cp main"

##### Admin Commands
Description: A server guard integration plugin.

##### Better Thirdperson
Description: TFA's third person.

##### Combine Chatter
Description: Plays periodic sounds from units.

##### Combine Display Messages
Description: Adds a set of periodic display messages where they normally are.
Customization: You can customize the messages and add more in the plugi nfile.

##### Combine HUD
Description: A HUD interface for combine to quickly identify other units.
Customization: Unless you know what you're doing, don't touch this plugin.
Known issues; if you use a name system separate from what the schema provides, or do not provide a proper syntax to names, it will error out and break.

##### Combine MOTD
Description: A combine MOTD which displays a message of the day and status update to all units, provides a databank for units to get up to date information that moment.

##### Cool Things
Description: A set of features
Contains:
Animation support for "The metropolice of city 18"
Automatic grenade callout for MPF
Item saving.
Business remival
Moves settings to the tab menu.
Serverguard Admin SUpport on the SCoreboard
Enhanced kill and hurt logs.
Enhanced Admin ESP
A meta function to get an player's currently held weapon in the form of an item.
IsCombineCommand function.
Fixed player damage scaling
Resource add workshop stuff.
Admin chat (@)
Admin request (/ar)
Gmod legs 3

##### Item Spawner
Description: An item spawner.

Customization: All items that are in the category Survival or Crafting are automatically added, to increase their spawn rate increase their chance, to add custom items to the spawner, go to line 93 and add items as you need, use their item ID's.
##### Squad System
Description: A patrol team system which is supported by the Combine HUD
To Use: Type /squadmenu and create or invite to a squad.

##### Survival System
Description: Hunger & Thirst
Customization: All customization for the plugin is the same as all the other plugins.

#### Disabled Plugins; non-functional or unfinished, or otherwise;

##### Donator System
Description: A donator system that works with Xenforo and can be customized; provided your database for your website and helix schema are the same... for whatever reason.
##### Weapon Construction
Description: A mostly functioning Escape from Tarkov style weapon construction system.

