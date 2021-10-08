import 'package:flutter/material.dart';

class AcatarHomeWidget extends StatefulWidget {
  AcatarHomeWidget();

  @override
  AvatarHomeWidgetState createState() => AvatarHomeWidgetState();
}

class AvatarHomeWidgetState extends State<AcatarHomeWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildListDelegate([
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text('アバターを選ぶ', textAlign: TextAlign.center),
          ),
        ])),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisExtent: 200,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                      child: Image.asset(
                    'assets/avatar$index.png',
                    fit: BoxFit.contain,
                  )),
                ),
              );
            },
            childCount: 6,
          ),
        ),
      ],
    ));
  }
}

// child: cameraContainer(
//                 cameraService: cameraService,
//                 setState: setState,
//                 mounted: mounted,
//                 context: context,
//                 onAvatarPressedCallback: goToAvatarSelectHome),


// import 'package:flutter/material.dart';
// import 'package:neon/component/camera_home/camera_preview.dart';
// import 'package:neon/service/camera/camera_scale_service.dart';
// import 'package:neon/service/camera/camera_service.dart';

// Stack cameraContainer({
//   required CameraService cameraService,
//   required void Function(void Function() fn) setState,
//   required bool mounted,
//   required BuildContext context,
//   required Function onAvatarPressedCallback,
// }) {
//   return Stack(
//     alignment: AlignmentDirectional.bottomEnd,
//     children: <Widget>[
//       Center(
//         child: cameraPreviewWidget(
//           calcPointer: CameraScaleChangeService.calcPointer,
//           cameraService: cameraService,
//           handleScaleStart: CameraScaleChangeService.handleScaleStart,
//           handleScaleUpdate: CameraScaleChangeService.handleScaleUpdate,
//           setState: setState,
//           mounted: mounted,
//         ),
//       ),
//       SizedBox(
//           width: MediaQuery.of(context).size.width / 2.5,
//           height: MediaQuery.of(context).size.width / 2.5,
//           child: InkWell(
//             onTap: () {
//               onAvatarPressedCallback();
//             },
//             child: Image.asset(
//               'assets/avatar0.png',
//               fit: BoxFit.contain,
//             ),
//           )),
//     ],
//   );
// }
