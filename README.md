awesomerc
=========
This is my configuration setup for the Awesome Tiling Wm.
(http://awesome.naquadah.org/)

## IDEAS
I like the concept of tiling WM, and use it happily since a few years,
and Awesome is fast, customisable and got a big community to find help.

I also really endorse UNIX phylosophy: «Make each program do one thing well.»
see : http://www.faqs.org/docs/artu/ch01s06.html

Then I try to keep each module in their own git tree, for that purpose,
I use git submodule and add them in a bundle directory.

## Features
So I try to also do it on my WM:
- Keep clear configuration around each need of the config in different files idea taken from https://github.com/vincentbernat/awesome-configuration.
- Keep every module in a submodule in the bundle directory, big fan of NeoBundle https://github.com/Shougo/neobundle.vim
- Disable non-working module, to help portability by adding a check function.

## Toolbar
For widget that require things that are not on all my computer,
I add a function to detect if the prerequisites are here and if not,
disable (not add in the toolbar) the given widget.

Here the list of available modules:

Name             | Description
-----------------|------------
`RfkillWidget`   | Display the state of the rfkill switch.
`NetWidget`      | Display the network status, auto switch on active interface.
`PomodoroWidget` | Display a Pomodoro timer and count done run this session.
`MailWidget`     | Display the INBOX unread messages by using notmuch.
`ScreenWidget`   | Display the brightness of the screen.
`RedshiftWidget` | Display the redshift setup actually.
`MemWidget`      | Display the memory usage.
`CpuGraph`       | Display the CPU graph usage.
`CpuWidget`      | Display the load of the CPU.
`FsWidget`       | Display the space usage in the system.
`TempWidget`     | Display temp information.
`SoundWidget`    | Display the sound level (PulseAudio support).
`BatWidget`      | Display the information of available bat of the system.
`DateWidget`     | Display the date.
`TimeWidget`     | Display the current time.

## Install
Install is simple :
    # Clone the git tree
    git clone https://github.com/GuillaumeSeren/awesomerc ~/.config/awesome
    # Go to the profile directory
    cd ~/.config/awesome
    # Pull all the submodule
    git submodule foreach --recursive git submodule update --init

## Participate !
If you find it useful, and would like to add your tips and tricks in it,
feel free to fork this project and fill a __Pull Request__.

## Licence
The project is GPLv3.
