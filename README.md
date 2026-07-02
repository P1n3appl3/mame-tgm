
- [shmupmametgm](https://github.com/MaryHal/shmupmametgm)


dir layout:
```
${XDG_CONF_DIR}/tgm/
  |- mame.ini
  |- cfg/<rom>.ini

${XDG_DATA_DIR}/tgm/
  |- roms/

${XDG_CACHE_DIR}/tgm/
  |- nvram/<rom>.nv
```

runtime behavior:
  - make new config file if not present
  -

todos:
  - [ ] build `shmupmametgm` from source?
  - [ ] desktop file (with icon)

  - [ ] HM module

  - [ ] rom management?
    * with home manager
    * provide rom, it arranges for the symlink into `roms` dir and gives you a desktop file (+ icon)
    * (expose these guys — app with ROM — as flake outputs too though)

  - [taptracker](https://github.com/MaryHal/TapTracker)
    * [ ] build from source
    * [ ] offer runner script integration (set up dev shm file, launch viewer)
