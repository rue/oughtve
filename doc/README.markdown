 Oughtve
=========

- Shotgun:              $105.95.
- Beat-up Olds:         $2000.
- Chemistry 101:        $36.

- Remembering "niktu":  Priceless.


 What?
-------

Oughtve is a very simple command-line notation tool based on
your filesystem location, always at your fingertips to avoid the few
seconds/minutes/aeons that invariably cause you to lose the
thought you had.

Yeah. It lets you make notes. *And* read them later.


 Status
--------

Waiting for a rewrite, but feel free to muck with it.


 Why?
------

Because you *will* forget.


 Features
----------

- Notes are grouped based on the working directory they are
  written from. You might, for example, define a group for
  each of your coding projects' top directories: any notes
  you write in or under those directories will be grouped
  respectively.

- Notes can be "struck out" or closed so that they do not
  appear in the default listings (e.g. to emulate simple todo
  lists.)

- Sets of notes in a group can be enclosed as a "chapter", or
  a completed section. For example, one might close a section
  once all items for the 0.3.0 release have been completed.
  This starts a new section and removes the old one from the
  default views.

- The directory grouping always looks progressively higher in
  the hierarchy until it finds a defined group, all the way up
  to the default group bound at / if it comes across none on
  the way.

- The normal directory lookup and various other things can be
  overridden with option switches. Sometimes you want to write
  a note in a specific group from somewhere else in the system:
  just specify the group name.

- A group's notes can be exported to JSON or YAML (rudimentary.)


 Examples
----------

An extremely curt introduction is found in doc/HOWTO.using.

I like to rename my script to "--", so that I can use the
following to enter a note:

    $ -- Remember to actually write the HOWTO.


 Requirements
--------------

- Ruby
  - 1.8.7, 1.9.1, 1.9.2, jruby-1.4

- Gems
  - dm-core        >= 0.10.2
  - data_objects   >= 0.10.1
  - do_sqlite3     >= 0.10.1

- Other
  - [SQLite3](http://sqlite.org)
  - UNIXy system.

- Development
  - Gems
  - RSpec (>= 1.3.0)


 Status
--------

Experimental rewrite of an age-old workhorse of mine. The
intent of this release is to figure out if anyone else
finds this useful.

Please break it. 'Some' robustness is needed.


 Where?
--------

    $ gem install oughtve

Source is found on [Github](http://github.com/rue/oughtve).


 Who Do I Complain To?
-----------------------

- oughtve MEOW projects _purr_ kittensoft _rawr_ org.

- IRC channel #oughtve on Freenode ("rue", in case I am not the only person.)

