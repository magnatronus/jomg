import 'package:example/src/api.dart';
import 'package:example/src/models/api_model.dart';
import 'package:example/src/models/version_model.dart';
import 'package:flutter/material.dart';

import '../../models/details_model.dart';
import '../../models/groups_model.dart';

/// Our main Homepage widget
/// [api] - this is our faux API
class HomePage extends StatefulWidget {
  final FauxApi api = FauxApi();
  HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

/// This is just to show the data from the API can be used with the generated
/// object classes, it is not a best practices for data display! (before anyone comments)
class _HomePageState extends State<HomePage> {
  ApiModel? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("JOMG generator Example")),
        body: Column(
          children: [
            // button to run faux api call
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                child: const Text("Run API"),
                onPressed: () async {
                  final apiResult = await widget.api.callApi();
                  setState(() {
                    result = apiResult;
                  });
                },
              ),
            ),

            // show version info
            Padding(
                padding: const EdgeInsets.all(8),
                child: versionInfo(
                    result?.version, Theme.of(context).textTheme.headline6)),

            // show tags
            Padding(
              padding: const EdgeInsets.all(8),
              child: generateTags(result?.tags)
            ),

            // show groups data
            Padding(
                padding: const EdgeInsets.all(8),
                child: groupData(
                    result?.groups, Theme.of(context).textTheme.headline6)),
          ],
        ));
  }

  // Show the tags
  Widget generateTags(List? tags){
    String tagList = "";
    if(tags != null && tags.isNotEmpty){
      for(final tag in tags){
        tagList += "$tag,";
      }
    }
    return Text("[$tagList]");
  }


  /// Display the version info
  Widget versionInfo(VersionModel? version, TextStyle? style) {
    if (version == null) {
      return const Text('no version info available');
    }
    return Column(
      children: [
        Text("Obtained VersionInfo", style: style),
        Text("version: ${version.major}.${version.minor}"),
        Text("copyright: ${version.copyright}"),
      ],
    );
  }

  /// Display the groups data
  Widget groupData(List<GroupsModel>? groups, TextStyle? style) {
    if (groups == null) {
      return const Text('no group data available');
    }
    return Column(
      children: [
        Text("Obtained GroupsInfo", style: style),
        for (final group in groups)
          Column(
            children: [
              const Text("-------------------------------------------"),
              Text("${group.groupName} - order: ${group.order}"),
              groupDetailData(group.details)
            ],
          )
      ],
    );
  }

  // display any group details
  Widget groupDetailData(List<DetailsModel>? details) {
    if (details == null) {
      return const Text("no details found");
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [for (final detail in details) detailInfo(detail)]);
  }

  // display each detail
  Widget detailInfo(DetailsModel detail) {
    return Text(
        "${detail.order} : ${detail.heading}, percentage: ${detail.percentage} - visible: ${detail.isVisible}");
  }
}
