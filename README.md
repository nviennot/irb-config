Installation
------------

To install, run

    git clone git://github.com/nviennot/irb-config.git ~/.irb
    cd ~/.irb
    make install

It installs all the required gems for all your installed rubies.
Furthermore, these gems will be automatically installed when you install a new ruby.

To update the repository, run

    make update

What is it ?
------------

It packages:
- [Pry](https://github.com/pry/pry)
- [Pry Doc](https://github.com/pry/pry-doc)
- [Pry Git](https://github.com/pry/pry-git)
- [Pry Rails](https://github.com/rweng/pry-rails)
- [Pry Debugger](https://github.com/nixme/pry-debugger)
- [Pry Remote](https://github.com/Mon-Ouie/pry-remote)
- [Pry Stack Explorer](https://github.com/pry/pry-stack_explorer)
- [Pry Coolline](https://github.com/pry/pry-coolline)
- [Awesome Print](https://github.com/michaeldv/awesome_print)
- Pry commands for [Gnuplot](https://github.com/rdp/ruby_gnuplot)
- Pry commands for [Rspec](https://github.com/rspec/rspec)/[Cucumber](https://github.com/cucumber/cucumber)
  to run tests directly in the rails console
- [Mongoid](https://github.com/mongoid/mongoid) pretty printing with [Coderay](https://github.com/rubychan/coderay)

It supports Rails envionment switches for:
- Active Record
- Mongoid
- CopycopterClient
- Rspec
- Cucumber

This way you can switch back and forth from the development environment and the
test environment, which is what the rspec/cucumber commands do.

How to use
----------

* All the goodies are automatically loaded into your rails console, `rails c`
  and you go straight to heaven.
* If Mongoid emits too much noise (For example you are running all your tests),
  you can make it quiet with `Mongoid.logger.level = Logger::WARN`.  Note that
  `Rails.logger == Mongoid.logger`.
* Use the `rspec` command pretty much like the usual one.
* Use the `cucumber` command pretty much like the usual one.
* Use the `env test` command to switch to the test environment.
* Use the `plot` command to plot an array of 2D points (accepts a Hash too).
* Type `help` to see the Pry help.

Notes
-----

* All the gems from your global gemset can be loaded bypassing Bundler.
* The RSpec/Cucumber context run with your test environment, including your test
  database settings.  Furthermore, whenever you run the rspec command, all your
  classes are reloaded with `reload!`.

Vim Integration
----------------

With the [Screen](https://github.com/ervandew/screen) plugin, you can
communicate with screen/tmux to send some commands. I find these one
particularly useful:

    command -nargs=? -complete=shellcmd W  :w | :call ScreenShellSend("load '".@%."';")
    map <Leader>c :ScreenShellVertical bundle exec rails c<CR>
    map <Leader>r :w<CR> :call ScreenShellSend("rspec ".@% . ':' . line('.'))<CR>
    map <Leader>f :w<CR> :call ScreenShellSend("Rails.logger.level = Logger::WARN;\n".
                                             \ "rspec ".@%."\n".
                                             \ "Rails.logger.level = Logger::DEBUG;")<CR>

Assuming you have a tmux session with vim and the rails console:
* `:W` saves and reloads the current file in the console.
* `,c` opens a tmux pane with a rails console.
* `,r` saves the file and run the rspec test corresponding to the cursor line.
* `,f` saves the file and run the rspec test on the entire rspec file.

This is setup in my [Vim configuration](https://github.com/nviennot/vim-config/).
