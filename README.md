### Welcome To Redemption on Rails

To work on the project (roughly speaking)

1. Install Ruby version 2.2.3 (you can use rbenv or rvm to manage ruby version if you like!)

2. Install nodejs, sqlite3 (for now!) and the rails gem (rails version 4.2.5.1 or later)

    sudo apt-get install nodejs
    sudo apt-get install sqlite3
    gem install rails

3. Clone this repository
4. Run "bundle install" to install the required gems

	bundle install

NOTE: this might fail because of a missing sqlite dependency.  If it does, follow the suggested instructions!

5. Launch the app!

    bundle exec rails s