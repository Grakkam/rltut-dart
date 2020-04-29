## 0.8.0

- Part 8 of the tutorial implemented. Added basic item management.
- Healing potions can now be picked up, dropped, and used to heal the hero.
- Removed the game states FSM, as I don't believe it is needed.
- Known bug: When dropping or using a potion, the game does not
update until a valid key (for instance movement) is pressed. Need
to figure out how to skip waiting for input after coming back from
the inventory screen.

## 0.7.0

- Re-numbered the versions to match the tutorial parts.
- Scrolling message log added.
- Part 7 of the tutorial implemented, except for mouse support.
Will skip mouse for now.

## 0.6.0

- Substantial re-write. Code re-organised along the lines of Hauberk,
now easier to manage. Code now even more a hybrid of Hauberk, the
Python libtcod tutorial, and my own ideas.
- Part 6 of the tutorial implemented. The hero can deal and take damage,
and die.

## 0.0.1

- Initial version, created by Stagehand
