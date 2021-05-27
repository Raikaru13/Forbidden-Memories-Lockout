# Forbidden-Memories-Lockout
A new Vs Race mode for Yugioh Forbidden Memories
Cards you win against a Duelist are locked out from your opponents. This only applies to getting said Card on the Duelist and Rank Bracket you won it on. The Rank Brackets are the standard `S/A POW`, `BCD POW/TEC` and `S/A TEC`. Any card you get locked out of will transform into Dark Magic Ritual once you leave the results screen.
> For example: You win Spike Seadra on Isis S/A POW. Your opponent(s) cannot win Spike Seadra from Isis S/A POW. Your opponent(s) CAN win Spike Seadra from Isis on BCD POW/TEC and S/A TEC as well as on all ranks for Kaiba. If your opponent wins Spike Seadra on Isis S/A POW, they will instead get a Dark Magic Ritual which cannot be used.
> > The exception to this rule is Megamorph. There are only 3 Megamorphs to be won regardless of where you win it. This can split between you and your opponents in any way, but at most 3 copies of Megamorph will exist in the match. This is to balance out that the only feasible way to obtain megamorph is through S/A TEC Pegasus. This way if your opponent gets a megamorph early, it doesn't mean you are locked out from the most powerful card in the game immediately.

This currently only works for the Bizhawk emulator. Known working on Bizhawk 2.6.2. There may be future support for more emulators and/or changing over to a standalone program.


## Setup
### You will need the following:
1. [Bizhawk 2.6.2](https://github.com/TASVideos/BizHawk/releases/tag/2.6.2)
2. [BizHawk prerequisite installer](https://github.com/TASVideos/BizHawk-Prereqs/releases/tag/2.1) (run this)
3. [luasocket](http://files.luaforge.net/releases/luasocket/luasocket/luasocket-2.0.2/luasocket-2.0.2-lua-5.1.2-Win32-vc8.zip)
4. [FM Lockout](https://github.com/Raikaru13/Forbidden-Memories-Lockout)
5. Port Forwarding for the host.

### Directory structure

The locations of files is very important! Make sure to put them in the right place. After unzipping BizHawk (1), you should be able to find the executable `EmuHawk.exe`, we will call the folder containing it `BizHawkRoot/`.

First, in luasocket (3), you should find three folders, a file, and an executable: `lua/`, `mime/`, `socket/`, `lua5.1.dll`, and `lua5.1.exe`.
Place the folders `mime/` and `socket/` in `BizHawkRoot/`, and place the *contents* of `lua/` in `BizHawkRoot/Lua/`. Place `lua5.1.dll` in `BizHawkRoot/dll/`. You do not need `lua5.1.exe`.

I would suggest placing the `FM_Lockout.lua` and `dropInfo.txt` from FM Lockout (4) into `BizHawkRoot/`. Then finally placing `json.lua` in `BizHawkRoot/Lua`.

This should complete the file placement.

## How to play

After launching Bizhawk 2.6.2 load up the version of Forbidden Memories you wish to play on. The mod will support Vanilla and any X card mod. It currently doesn't support the starchip mod nor any other existing mods such as Mod 13.

Then navigate your way to the Lua console under `Tools -> Lua Console`.
Open the script either through the Script menu or the Open Folder icon in the Lua console. The script should be within your `BizHawkRoot/` if you placed it there as suggested.

Once you open the script it should launch into two windows. One Labeled `FM Lockout` and one labeled `Lockout Data`. If you don't see `FM Lockout` it may be under `Lockout Data`.

### The Username Entry. 

Its use is to determine if you are on the same "Team" as another player. To create "Teams" just input the same username as the player you are teaming up with. You will not share drops between teammates, but any card you lockout will be locked out for anybody that does not have the same username as you.

### IP Address and Port

Everybody BUT the Host needs to input the Host's IP to connect.

Everybody inputs the Port number, but ONLY the Host needs to do portforwarding. There are countless instructions on how to Port Forward for every type of router, so Google is your best friend there.
>  * <ins>Port forwarding alternative:</ins> "In the event you do not have access to your router to apply port forwarding, try using the program called, "[Hamachi](https://www.vpn.net/)". This program allows you & others to connect to one another as if you are on the same LAN (Local Area Network). Don't let the subscription stuff scare you on their site, all you need is a free account!"


### Load Data?
This button should ONLY be used if you crashed for whatever reason. This will recover your opponent's card lockout data as well as your own.

## Lockout Data Window

This window is your means of telling what cards your opponent(s) have locked you out of on Duelists and their respective Rank Brackets. The order by which the cards are displayed are made to reflect their order on the [Pocket Duelist](https://pd.ygo.fm/) website. Using the website and tool together will help you route your way around your opponent. At the bottom of the window it also displays the Duelist your opponent beat last.

If you do not wish to use this tool, you are not forced to. Closing it will not effect anything, but to get it back you have to restart the entire script, which means closing out of the Lua Console entirely.

I would suggest right clicking the big empty box inside this window and enabling `Right to left Reading order`. This makes the info much easier to read.

## Worthwhile notes

1. If for whatever reason you need to close the room and reopen a new one, you should do so by closing out of the Lua Console entirely and continuing from there.

2. Do not win a duel with Sword of Revealing Light in play. This should be a rare enough occurance that you will never run into it, but should you then the results screen will be messed up and I cannot guarantee your cards will lockout correctly.
> This is due to the way the rewards are colored on the results screen and should you find yourself in this situation, spamming X till you clear out of the results screen should eventually get you out. 

## I hope you enjoy Forbidden Memories Lockout as much as I do.
-Raikaru
