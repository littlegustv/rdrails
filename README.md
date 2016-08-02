### Welcome To Redemption on Rails

To work on the project (roughly speaking)

1. Install Ruby version 2.2.3 (you can use rbenv or rvm to manage ruby version if you like!)

2. Install **redis**, nodejs, sqlite3, (for now!) and the rails gem (**rails version 5.0 or later**)

    sudo apt-get install nodejs
    sudo apt-get install sqlite3
    gem install rails

3. Clone this repository
4. Run "bundle install" to install the required gems

	bundle install

NOTE: this might fail because of a missing sqlite dependency.  If it does, follow the suggested instructions!

5. Launch the app!

    bundle exec rails s

6. Launch the game!


The game is located in the ./game directory.  Make sure to install the gem dependencies.  There is a Gemfile, so you can try Bundle install, or just install them manually.  You can then start the game with:

    ruby start.rb

However, I prefer using the 'rerun' gem so that it automatically restarts on changes:

    rerun start.rb

And that's it!
