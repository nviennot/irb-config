Installation
------------

Prerequisites: rvm or rbenv.

To install, run

    git clone git://github.com/nviennot/irb-config.git ~/.irb
    cd ~/.irb
    make install

`make install` installs all the required gems for all your installed rubies.
When installing a new ruby, please `make update` in the ~/.irb directory.

Updates
--------

To update the repository and all the gems, run

    make update

What is it ?
------------

### Watch the screencast

[![Watch the screencast!](https://s3.amazonaws.com/velvetpulse/screencasts/irb-config-screencast.jpg)](http://velvetpulse.com/2012/11/19/improve-your-ruby-workflow-by-integrating-vim-tmux-pry/)

It packages:
- [Pry](https://github.com/pry/pry)
- [Pry Doc](https://github.com/pry/pry-doc)
- [Pry Debugger](https://github.com/nixme/pry-debugger)
- [Awesome Print](https://github.com/michaeldv/awesome_print)
- [Commands](https://github.com/rails/commands)
- [Rails Env Switcher](https://github.com/nviennot/rails-env-switcher)
- [RSpec Console](https://github.com/nviennot/rspec-console)
- [Cucumber Console](https://github.com/nviennot/cucumber-console)
- [Mongoid Colors](https://github.com/nviennot/mongoid-colors)
- Pry commands for [Gnuplot](https://github.com/rdp/ruby_gnuplot)
  to run tests directly in the rails console

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
* Use the `rake`, `test`, `generate`, `destroy`, `update` commands as usual.
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
    map <Leader>e :w<CR> :call ScreenShellSend("cucumber --format=pretty ".@% . ':' . line('.'))<CR>
    map <Leader>b :w<CR> :call ScreenShellSend("break ".@% . ':' . line('.'))<CR>

This is setup in my [Vim configuration](https://github.com/nviennot/vim-config/).

Assuming you have a tmux session with vim and the rails console:
* `:W` saves and reloads the current file in the console.
* `,c` opens a tmux pane with a rails console.
* `,r` saves the file and run the rspec test corresponding to the cursor line.
* `,e` saves the file and run the cucumber test corresponding to the cursor line.
* `,b` puts a break point on the current line

License
--------

irb config is released under the MIT license.
