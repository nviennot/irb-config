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

What is it good for ?
---------------------

* Features automatically loaded into your rails console, `rails c` and you go straight to heaven.
* Mongoid pretty traces. You can shut them off with `Mongoid.logger.level = Logger::WARN`.
  Note that `Rails.logger == Mongoid.logger`.
* RSpec support. Use `rspec spec` to launch a test, `rspec` to have an RSpec context.

Notes
-----

* All the gems from your global gemset can be loaded bypassing Bundler, so don't
  put garbage in it.
* The RSpec context run with your test environment, including using the test
  database. It also reloads all your classes
