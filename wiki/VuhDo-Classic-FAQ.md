**1.  How do I bind or assign a specific rank of a spell or ability?**

Append the spell or ability name with 'Rank(N)' where 'N' is the rank or level desired.

For example:

> *Lesser Heal(Rank 2)* 

**2.  Why does spell trace not work for some spells and abilities?**

In Classic, Blizzard chose to deliberately hide the spell ID associated with various spell events. This means that VuhDo can only internally associate spell traces by name.  Blizzard further restricts fetching the ID for a given spell name if that spell is not known in the player's spellbook.  

What this mean is that for example, a Priest could spell trace 'Lesser Heal' but not a Druid's 'Regrowth'.

**3.  Why do the shield bar or other shield/absorb related features of VuhDo not work properly?**

In Classic, Blizzard chose to deliberately hide the amount of absorption on units.  At this time, VuhDo does not have any additional tracking in place to work around this Blizzard API restriction. 
