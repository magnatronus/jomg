# example

This is just a simple example of using the JOMG to create a set of Dart class objects that represent
the output of a fictious API. Just take a look in the [example](https://github.com/magnatronus/jomg/tree/master/example) directory.

## Running
The JOMG converter has already been run and has generated the required Dart Object models. So to test delete all ***_model.dart** files
found in `/example/lib/src/models` then run  the JOMG builder inside the example directory (**flutter packages pub run jomg**).

This should recreate the required classes and the example app should be able to use then to use the data from the faux API.
