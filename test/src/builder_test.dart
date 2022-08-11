import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jomg/jomg.dart';
import 'package:path/path.dart' as p;


main(){

  group("builder", (){

    test("JOMGYamlException on jomg: no yaml entry", () async {
      expect( () => build(), throwsA(const TypeMatcher<JOMGYamlException>()));
    });

    test("JOMGYamlException on jomg: no src or output dir", () async {
      expect( () => build(config: {'jomg': {}}), throwsA(const TypeMatcher<JOMGYamlException>()));
    });

    test("JOMGNoSrcDirException on no src dir exists", () async {
      Map config = {
        'jomg' : {
          'src_dir': '',
          'output_dir': ''
        }
      };
      expect( () => build(config: config), throwsA(const TypeMatcher<JOMGNoSrcDirException>()));
    });

    test("JOMGNoOutputDirException on no output dir exists", () async {
      Map config = {
        'jomg' : {
          'src_dir': 'test/nojson',
          'output_dir': ''
        }
      };
      expect( () => build(config: config), throwsA(const TypeMatcher<JOMGNoOutputDirException>()));
    });

    test("JOMGNoSourceFilesException on src dir empty", () async {
      Map config = {
        'jomg' : {
          'src_dir': 'test/nojson',
          'output_dir': 'test/output'
        }
      };
      expect( () => build(config: config), throwsA(const TypeMatcher<JOMGNoSourceFilesException>()));
    });

    test("runs and creates an output", () async {
      Map config = {
        'jomg' : {
          'src_dir': 'test/json',
          'output_dir': 'test/output'
        }
      };
      await build(config: config);

      // check names of generate files
      List <String> files = ["test_model.dart", "version_model.dart", "comments_model.dart"];
      final jsonFiles = Directory(config['jomg']['output_dir']).listSync(followLinks: false);
      expect(jsonFiles.length, equals(3));
      for (var file in jsonFiles) {
        expect(files.contains(p.basename(file.path)), isTrue);
      }

      // remove generated files
      for (var file in jsonFiles) {
        file.deleteSync();
      }
    
    });         

  });
}