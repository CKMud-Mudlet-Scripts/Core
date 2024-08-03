# CKMud-Core

## CKMud-Core by fried

This is a set of automations for android characters like Core

The script can automatate buffs, learning, fights. 

`vent` automattically configures for max heat disipation and moves back to previous setting

From Time to time the script will issue `score`, and use scouter on yourself to calibrate damage, abilitiy costs, and health %. 

## Installation

`installPackage("https://github.com/CKMud-Mudlet-Scripts/Core/releases/latest/download/CKMud-Core.mpackage")`

After installation `core update` alias will take care of updating the script. 

## Usage

Type `learn` as soon as possible, this teaches the script what abilities you have.  Including automatic buffs. 

### Keys

F10 - Enable auto fight() (Will automaticlly use best abilities during a fight)
F9 - Start Auto Learn / Training mode using a `child` targets:

### Aliases

autolearn <target> - Start Auto Learn / Training mode using <target> as attack target. 
configure - Capture android `configure` command so we can save your confiures through vent 
fight <target> - Auto Combo / Melee combat picker 
blast <target> - Auto Ki Attack Picker