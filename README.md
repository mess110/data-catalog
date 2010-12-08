# National Data Catalog

This is the source code for the National Data Catalog. The current version (v2) intended to be more social and more collaborative than v1.

## History

Version 1 of the National Data Catalog consisted of multiple applications (a Sinatra API, a Rails 2 web app, and many importers) that worked together.

This version (v2) is instead one combined Rails 3 application. This will make it easier to modify and maintain the application, plus it will be easier to customize and install if you want to run your own data catalog.

## Changes since Version 1

### Users

* Each User has a dedicated page.
* Each User page has an activity stream.
* Users can watch DataSources.
* Users can follow other Users.

### Sites

* Sites, external web sites that we import from, are top-level resources
* Sites have useful metadata describing their 'goodness' as data catalogs.

### Catalogs

* A Catalog is a grouping of DataSources.
* The application can contain multiple Catalogs.
* Each Catalog can be administered by its owners and curators.

### Organizations

* An Organization can group other Organizations when needed. Two examples are the "U.S. District Courts" and the "U.S. Executive Departments".

### DataSources

* DataSources can aggregate other DataSources. (This is a useful way to bundle up very similar DataSources, such as the Toxic Release Inventory data sets on Data.gov.)
* DataSources can be rated along three dimensions: Interestingness, Documentation Quality, and Data Quality.
* Users can suggest DataSources and provide as much metadata as they like.
* Users can suggest 'missing' DataSources.
* Added DataSource activity stream.
* DataSources can belong to more than one Catalog.

### Locations

* Locations, geographical locations, are top-level resources.
* Locations are hierarchical.
* Locations are a better way to convey the ideas of:
    * jurisdiction of an Organization
    * geographic coverage of a DataSource

## Installation / Setup

Just install the National Data Catalog like a typical Rails 3 application. Here are a few notes about parts that are less common:

1. Download and run [MongoDB](http://mongodb.org)
2. Configure [Mongoid](http://mongoid.org)
    * Adjust `config/mongoid.yml` as necessary
3. Install and run [Redis](http://code.google.com/p/redis/)
    * On Mac OS X, we recommend [homebrew](http://http://mxcl.github.com/homebrew/):
        * `brew install redis`
4. Load data into the database
    * Development:
        * `rake db:setup db:seed_examples`
    * Production:
        * `rake db:setup rake import:*`
5. Start the background processing system
    * `QUEUE=* rake resque:work`
    * `rake resque:scheduler`
    * Optionally: `resque-web`
6. Start the Rails server:
    * `rails s`

## Notable Directories

Our directory structure follows the Rails conventions; however, we have a few differences that are worth highlighting:

1. Importers are kept in `lib/importers`.
2. Cached gravatars live in `public/images/gravatars`.
3. Delayed processing logic (for Resque) lives in `lib/resque`.
4. Some Mongoid models use map-reduce. The map and reduce functions live in javascript files located in `app/models/{model}/{method}`. Separating the javascript functions out of the ruby models is helpful to your text editor -- it allow for accurate syntax highlighting and [JSLint](http://www.jslint.com/) checking.
