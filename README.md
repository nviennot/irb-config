Installation
------------

To install, run

    git clone git://github.com/nviennot/irb-config.git ~/.irb
    cd ~/.irb
    make install

    rvm use XXX@global # Replace XXX with your ruby interpreter
    gem install pry pry-doc coderay awesome_print
    gem install --ignore-dependencies interactive_rspec # prevent the installation of the rspec gem
    rvm use XXX

To update the repository, run

    make update

What is it ?
------------

It packages
[Pry](https://github.com/pry/pry),
[Awesome Print](https://github.com/michaeldv/awesome_print),
[Interactive RSpec](https://github.com/amatsuda/interactive_rspec),
and a Mongoid logger colorizer.

How to use
----------

* All the goodies are automatically loaded into your rails console, `rails c`
  and you go straight to heaven.
* If Mongoid emits too much noise (For example you are running all your tests),
  you can make it quiet with `Mongoid.logger.level = Logger::WARN`.  Note that
  `Rails.logger == Mongoid.logger`.
* Use the `rspec` command pretty much like the usual one.
* Type `help` to see the Pry help.

Notes
-----

* All the gems from your global gemset can be loaded bypassing Bundler, so
  don't put garbage in it. Use `gem list` while in your global gemset to make
  sure everything looks ok.
* The RSpec context run with your test environment, including your test
  database settings.  Furthermore, whenever you run the rspec command, all your
  classes are reloaded with `reload!`.

Vim Integration
----------------

With the [Screen](https://github.com/ervandew/screen) plugin, you can
communicate with screen/tmux to send some commands. I find these one
particularly useful:

    map <Leader>c :ScreenShellVertical bundle exec rails c<CR>
    map <Leader>r :w<CR> :call ScreenShellSend("rspec ".@% . ':' . line('.'))<CR>
    map <Leader>f :w<CR> :call ScreenShellSend("Rails.logger.level = Logger::WARN\n".
                                             \ "rspec ".@%."\n".
                                             \ "Rails.logger.level = Logger::DEBUG")<CR>

Assuming you have a tmux session with vim and the rails console:
* `,c` opens a tmux pane with a rails console.
* `,r` saves the file and run the rspec test corresponding to the cursor line.
* `,f` saves the file and run the rspec test on the entire rspec file.

This is setup in my [Vim configuration](https://github.com/nviennot/vim-config/).
