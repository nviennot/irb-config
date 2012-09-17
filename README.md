Installation
------------

To install, run

    git clone git://github.com/nviennot/irb-config.git ~/.irb
    cd ~/.irb
    make install

The following gems will be installed for all your installed rubies:

    pry pry-doc pry-rails pry-nav pry-stack_explorer coderay awesome_print gnuplot

Furthermore, when you install a new ruby, these gems will be automatically installed.

To update the repository, run

    make update

What is it ?
------------

It packages
[Pry](https://github.com/pry/pry) and some plugins (
[pry-rails](https://github.com/rweng/pry-rails),
[pry-nav](https://github.com/nixme/pry-nav),
[pry-stack-explorer](https://github.com/pry/pry-stack_explorer)
[Awesome Print](https://github.com/michaeldv/awesome_print),
[Gnuplot](https://github.com/rdp/ruby_gnuplot).

It also provides support for Mongoid, Rails, CopycopterClient, Rspec/Cucumber.

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
