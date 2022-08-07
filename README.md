# JOMG

 The Json Object Model Generator is an *opinionated* builder designed to convert 1 or more json definitions into a set of class based object models.
 It does this by analysing the JSON and attempting to create a representation of the JSON  as Dart classes.


## Features

JOMG will create a set of 1 or more Dart models from each *.json* file that it finds in the defined *src_dir*, the number of generated classes will depend on how complex the JSON is. These files are created (or overwritten) to the defined *output_dir*.


## Getting started

Install the plugin as one of the  *dev_dependencies* in your project *pubspec.yaml* then at the top level create an entry to define the
*src_dir* and *output_dir* directories. **PLEASE NOTE** these directories must exist. See below for an example entry, or look in 
the `/example` directory at the *pubspec.yaml*.

```yaml
jomg:
  src_dir: 'src/json'
  output_dir: 'lib/src/models'
  all_attributes_required: false
```
There is a third configuration option *all_attributes_required*. This is optional and is only required if you wish all the attributes generated in a 
model to be **required**. By default all are set to optional so they can be null if needed, this is done as the model does not know which attributes in the JSON
are always present and which are not (its is simpler, and safer, to assume they can all be null).


## Conversion rules
- The name of the dart file created is  *{json file name}_model.dart*
- The name of the object created is *{json file name}Model*
- Any complex types in the json will have there own models created (Dart List and Map types)
- Any sub models are named using the JSON attribute name i.e.  *{json attribute}_model.dart* and *{json attribute name}Model*

## Known Limitations
The JSON must be well formed and not contain complex types of the same name with varying structures. For example

```
{
  "question": "How long is a piece of string?",
  "answers": [
    {"order": 1, "answer": "Too long"},
    {"order": 2, "answer": "Too short"},
    {"order": 3, "answer": "Who cares"},
    {"order": 4, "answer": "Stupid question"}
  ],
  "help":{
    "title": "hints"
    "answers": [
        {"id": 1, "description": "Always reply with answer 4"},
        {"id": 1, "description": "Answer 3 is the best bet"}
    ]
  }
}
```

This has 2 Lists defined both named **answers**, but they are *NOT* the same object as they have a different structure which will mean the JOMG will overwrite 
any **AnswersModel** generated only with the last one found. The solution would be to change the attribute name of one, for example the **answers** in 
the **help** structure could be called **help_answers**.

## Usage

Just run the **flutter packages pub run jomg** command in the root of your project to start the generator process, and create the models from the JSON found.

For example a simple object defined in a file called  entry.json:

```
{
  "id": 1,
  "name": "Test Entry"
}
```

would be converted  as entry_model.dart to

```dart
class EntryModel {
  final int? id;
  final String? name;
  EntryModel(this.id, this.name);
}
```

For a more in-depth example that generates multiple objects from a single JSON file
see the  `/example` folder. This example also shows the automated creation of **static fromJson**
methods to import the JSON data directory into the Object Model.


## Additional information

This is currently an experimental package, originally created as a private builder for 
generating Dart objects that can be used to track the data returned from APIs. I have 
released it to see if it is helpful to anyone else.