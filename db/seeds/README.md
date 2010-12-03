Load the examples data by using:

    rake db:seed

Q: How is the db/examples data different from the db/seeds data?

A: The example data is used for testing -- meaning that it only should be loaded for a development environment. The seed data is meant to be used both in testing and in production.

Q: What is a recommended order to load the seed data?

    # Example #1 - Quick Development / Testing
    rake db:reset
    rake db:seed
    rake db:seed_examples
    
    # Example #1 - Load Importer
    rake db:reset
    rake db:seed
    rake db:seed_examples
    rake import:*
