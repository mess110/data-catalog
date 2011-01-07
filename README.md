# National Data Catalog

This is the source code for the National Data Catalog. The current version (v2) intended to be more social and more collaborative than v1.

## History

Version 1 of the National Data Catalog consisted of multiple applications (a Sinatra API, a Rails 2 web app, and many importers) that worked together.

This version (v2) is instead one combined Rails 3 application. This will make it easier to modify and maintain the application, plus it will be easier to customize and install if you want to run your own data catalog.

## Changes since Version 1

### Users

* Each User has a dedicated page.
* Each User page has an activity stream.
* Users can watch DataSets.
* Users can follow other Users.

### Sites

* Sites, external web sites that we import from, are top-level resources
* Sites have useful metadata describing their 'goodness' as data catalogs.

### Catalogs

* A Catalog is a grouping of DataSets.
* The application can contain multiple Catalogs.
* Each Catalog can be administered by its owners and curators.

### Organizations

* An Organization can group other Organizations when needed. Two examples are the "U.S. District Courts" and the "U.S. Executive Departments".

### DataSets

* DataSets can aggregate other DataSets. (This is a useful way to bundle up very similar DataSets, such as the Toxic Release Inventory data sets on Data.gov.)
* DataSets can be rated along three dimensions: Interestingness, Documentation Quality, and Data Quality.
* Users can suggest DataSets and provide as much metadata as they like.
* Users can suggest 'missing' DataSets.
* Added DataSet activity stream.
* DataSets can belong to more than one Catalog.

### Locations

* Locations, geographical locations, are top-level resources.
* Locations are hierarchical.
* Locations are a better way to convey the ideas of:
    * jurisdiction of an Organization
    * geographic coverage of a DataSet

## Installation / Setup

Just install the National Data Catalog like a typical Rails 3 application. Here are a few notes about parts that are less common:

1. We highly recommend that you use the [latest stable version of Ruby](http://www.ruby-lang.org/en/downloads/). As of this writing we are using 1.9.2p136. While the app may run on Ruby 1.8.7, we will not be developing or testing it for that environment.
    * We recommend installing a current version of the Ruby interpreter using [RVM, the Ruby Version Manager](http://rvm.beginrescueend.com/).
2. Download and run [MongoDB](http://mongodb.org).
3. Configure [Mongoid](http://mongoid.org).
    * Adjust `config/mongoid.yml` as necessary.
4. Install and run [Redis](http://code.google.com/p/redis/).
    * On Mac OS X, we recommend [homebrew](http://http://mxcl.github.com/homebrew/):
        * `brew install redis`
5. Load data into the database:
    * For quicker testing:
        * `rake db:reset db:seed db:seed_examples`
    * For a full setup:
        * `rake db:reset db:seed db:seed_examples import:*`
6. Start the background processing system:
    * `QUEUE=* rake resque:work`
    * `rake resque:scheduler`
    * Optionally: `resque-web`
7. Start the Rails server:
    * `rails s`
8. Optional: if you are customizing or modifying the source code, fire up autotest:
    * `autotest`

## Notable Directories

Our directory structure follows the Rails conventions; however, we have a few differences that are worth highlighting:

1. [Sass](http://sass-lang.com) templates live in `app/sass` (which is different from the default location of `public/stylesheets/sass`). (Sass is extension of CSS3 that adds nested rules, variables, mixins, and selector inheritance.)
2. Importers (which import DataSets from external Sites) are kept in `lib/importers`.
3. Cached [gravatars](http://gravatar.com) live in `public/images/gravatars`.
4. Delayed processing logic (for [Resque](http://github.com/defunkt/resque)) lives in `lib/resque`.
5. Some [Mongoid](http://mongoid.org) models take advantage of [MongoDB's](http://mongodb.org) [map/reduce](http://www.mongodb.org/display/DOCS/MapReduce). The map and reduce functions live in javascript files located in `app/models/{model}/{method}`. Separating the javascript functions out of the ruby models is helpful to your text editor -- it allows for accurate syntax highlighting and [JSLint](http://www.jslint.com/) checking.
