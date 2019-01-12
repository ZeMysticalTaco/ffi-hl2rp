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

##### New Attributes

##### Citizen Production

##### Crafting

##### Identity System

##### Item Population

##### Quests

##### Radio

##### Admin Commands

##### Better Thirdperson

##### Combine Chatter

##### Combine Display Messages

##### Combine HUD

##### Combine MOTD

##### Cool Things

##### Item Spawner

##### Squad System

##### Survival System

#### Disabled Plugins; non-functional or unfinished, or otherwise;

##### Donator System
##### Weapon Construction

