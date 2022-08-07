// Copyright (c) 2022 SpiralArm Consulting ltd. All rights reserved. 
// Use of this source code is governed by a BSD-style license 
// that can be found in the LICENSE file.


/// Simple helper class to track the info for a JSON attribute
/// [type] is the Dart type (i.e. String, int, bool, List, Map etc)
/// [cast] is optional and is used to generate type specific inference for any complex types like List and Map 
class JsonAttribute {
  final String type;
  final String? cast;
  JsonAttribute(this.type,{this.cast});
}