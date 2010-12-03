Load the examples data by using:

    rake db:seed_examples

Q: How is the db/examples data different from the db/seeds data?

A: The example data is used for testing -- meaning that it only should be loaded for a development environment. The seed data is meant to be used both in testing and in production.
