ohr-cartographer
================
Reads OHR RPG formats and saves tilemaps as PNGs. Run mapper.exe through the command line, or click and drag an RPG file onto the file.

```
mapper.exe <rpg_name>
```

Visit http://rpg.hamsterrepublic.com/ohrrpgce/Main_Page to learn more about how to make games with the OHRRPGCE!

The mapper.exe executable was build using ocra. https://github.com/larsch/ocra

Mac and Unix Platforms
======================
You will need Ruby (installed by default on Mac OSX and most GNU/Linux distributions).
Install RubyGems if needed (unlikely; it's distributed with recent Ruby versions), then install the dependencies by running
```
gem install --user-install chunky_png oily_png
```
You can then run the program from the terminal with:
```
ruby main.rb <rpg_name>
```


unlump.exe, unlump-linux_x86 and unlump-mac are builds of the unlump utility, part of the OHRRPGCE.
It is licensed under the GNU GPL v2+. Source code is available from http://rpg.hamsterrepublic.com/ohrrpgce/Source.
If you are not on Windows, Mac OSX or 32-bit-compatible Linux then you will need to provide
your own build of 'unlump'. Either place it in the same directory as main.rb, or in your $PATH.
