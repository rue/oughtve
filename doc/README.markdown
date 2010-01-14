 Oughtve
=========

- Shotgun:              $105.95.
- Beat-up Olds:         $2000.
- Chemistry 101:        $36.

- Remembering "niktu":  Priceless.


 What?
-------

Oughtve is a very simple command-line- and directory-based
notation tool, always at your fingertips to avoid the few
seconds/minutes/aeons that invariably cause you to lose the
thought you had.

Yeah. It lets you make notes. *And* read them later.


 Why?
------

Because you *will* forget.


 Features
----------

* Notes are grouped based on the working directory they are
  written from. You might, for example, define a group for
  each of your coding projects' top directories: any notes
  you write in or under those directories will be grouped
  respectively.

* Notes can be "struck out" or closed so that they do not
  appear in the default listings (e.g. to emulate simple todo
  lists.)

* Sets of notes in a group can be enclosed as a "chapter", or
  a completed section. For example, one might close a section
  once all items for the 0.3.0 release have been completed.
  This starts a new section and removes the old one from the
  default views.

* The directory grouping always looks progressively higher in
  the hierarchy until it finds a defined group, all the way up
  to the default group bound at / if it comes across none on
  the way.

* The normal directory lookup and various other things can be
  overridden with option switches. Sometimes you want to write
  a note in a specific group from somewhere else in the system:
  just specify the group name.

* A group's notes can be exported to JSON or YAML (rudimentary.)


 Examples
----------

An extremely curt introduction is found in doc/HOWTO.using.

I like to rename my script to "--", so that I can use the
following to enter a note:

    $ -- Remember to actually write the HOWTO.


 Requirements
--------------

* Gems
** dm-core
** data_objects
** do_sqlite3

* Other
** UNIXy system.


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

* oughtve MEOW projects _purr_ kittensoft _rawr_ org.
* IRC channel #oughtve on Freenode ("rue", in case I
  am not the only other person on the channel.)

