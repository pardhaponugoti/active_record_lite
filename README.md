# Active Record Lite

This is a program I made during App Academy which is a "lite" version of ActiveRecord.

It has the main functionality of ActiveRecord:
* For a database, it has the functions all, find, insert, update, and save
* Infers table names based on the class of the object in the table
* Generates getter and setter methods for column names in a table
* Initializes a new Ruby object using an input hash, and raises error when the keys are not part of the table
* Has a "where" function to search a database
* Associations - has_one, has_many, belongs_to

## How it works

### `SQLObject`

We first create a `SQLObject` class that has the following methods:

* `all` - returns an array of all the records in the database
* `find` - looks up a single record by primary key
* `insert` - inserts a new row into the table
* `update` - updates a row with the id of the `SQLObject`
* `save` - calls either insert/update depending on if the Object is already persisted

This class also has functions to create instance variables from the column names of the table and also infer table names based on the class name of the Ruby object

### `Searchable`

After creating the `SQLObject` class, we create a module named `Searchable` which we extend into the `SQLObject` class to add the module as class methods.

This module is where we define the `where` function, which takes in an options hash and searches a table for objects which fit the parameters.  It does so by taking the options hash and generating a SQL "WHERE" line from the key-value pairs to add to a query.

### `Associatable`

We now create a module names `Associatable` which we will extend into the `SQLObject` class to allow for associations.  This module has a class named `AssocOptions`, from which `BelongsToOptions` and `HasManyOptions` will inherit from.  `AssocOptions` stores the following:

* `foreign_key`
* `class_name`
* `primary_key`

Lastly, we define the function `has_one_through` that combines two `belongs_to` associations.
