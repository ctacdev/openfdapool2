## Dependencies ##

This application requires:

- *NIX-based operating system
- Ruby 2.2.2
- Rails 4.2.1
- MySQL 5.5+

## Developer Setup ##

Assuming that the above dependencies are installed and MySQL is running:

    cd openfda_rfq/
    bundle install

Copy `config/*.yml.example` files to `config/*.yml`:

    for i in `ls config/*.example`; do cp -f $i `echo $i | sed "s/.example//g"`; done

Edit `database.yml` to ensure correct connection information for MySQL, then:

    rake db:setup import_active_ingredients
    rails s

Once Rails is running, you should be able to browse to <a href="http://localhost:3000" target="_blank">the local server</a>.
