import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';
import '../../cubits/home_cubit.dart';
import '../../cubits/home_states.dart';
import '../../models/furniture_model.dart';


class ObjectGesturesWidget extends StatefulWidget {
  List<String> model3DUrls;
  List<FurnitureModel> model3D;
  ObjectGesturesWidget(this.model3DUrls, this.model3D, {Key? key})
      : super(key: key);
  @override
  _ObjectGesturesWidgetState createState() => _ObjectGesturesWidgetState();
}

class _ObjectGesturesWidgetState extends State<ObjectGesturesWidget> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  int index = 0;
  List<Color?> availableColors = [];
  bool _isvisible = false;
  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          child:
          return Scaffold(
              appBar: AppBar(
                title: const Text('Object Transformation Gestures'),
              ),
              body: Container(
                  child: Stack(children: [
                ARView(
                  onARViewCreated: onARViewCreated,
                  planeDetectionConfig:
                      PlaneDetectionConfig.horizontalAndVertical,
                ),
                Padding(
                  padding: EdgeInsets.only(top:450,left:MediaQuery.of(context).size.width/1.18),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: onRemoveEverything,
                             icon: Icon(Icons.delete_forever_outlined,
                             size: 43,), ),

                        // ElevatedButton(
                        //     onPressed: onRemoveEverything,
                        //     child: Text("Remove Everything")),

                      ]),
                ),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: IconButton(
                //     onPressed: index == widget.model3DUrls.length - 1
                //         ? null
                //         : () {
                //             setState(() {
                //               index += 1;
                //             });
                //           },
                //     icon: Icon(Icons.arrow_circle_right_rounded),
                //   ),
                // ),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: IconButton(
                //     onPressed: index == 0
                //         ? null
                //         : () {
                //             setState(() {
                //               index -= 1;
                //             });
                //           },
                //     icon: Icon(Icons.arrow_circle_left_rounded),
                //   ),
                // ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width / 1,
                        height: MediaQuery.of(context).size.height / 9,
                        decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff708090),
                                blurRadius: 7,
                              )
                            ]),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.only(left: 9, right: 9),
                        width: MediaQuery.of(context).size.width / 1,
                        height: MediaQuery.of(context).size.height / 8,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: widget.model3D.length,
                          itemBuilder: (context, int index) {
                            return InkWell(
                              onTap: () {
                                availableColors =
                                    BlocProvider.of<HomeCubit>(context)
                                        .getAvailableColorsOfFurniture(
                                            widget.model3D[index]);
                                setState(() {
                                  _isvisible= !_isvisible;
                                });

                              },
                              child: Align(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(left: 5.0, right: 7.0),
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    height:
                                        MediaQuery.of(context).size.height / 15,
                                    // decoration: BoxDecoration(
                                    //   //color: Color(0xFFEEEEEE),
                                    // ),
                                    child: Image.network(widget
                                        .model3D[index].shared.first.image)),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                Visibility(
                  visible: _isvisible,
                  child: Stack(children: [
                    Padding(
                     // padding: EdgeInsets.fromLTRB(left, top, right, bottom),
                      padding: EdgeInsets.fromLTRB(360, 150, 0, 50),
                      child: Container(
                        margin: EdgeInsets.only(left: 5.0),
                        width: MediaQuery.of(context).size.height / 17,
                        height: MediaQuery.of(context).size.height / 3,
                        decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff708090),
                                blurRadius: 7,
                              )
                            ]),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(360, 150, 0, 50),
                        child: Container(
                          width: MediaQuery.of(context).size.height / 17,
                          height: MediaQuery.of(context).size.height / 3,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: availableColors.length,
                              itemBuilder: (context, int index) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                                  child: InkWell(
                                    onTap: () {},
                                    child: CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.height > 700
                                              ? 15.0
                                              : 12.0,
                                      backgroundColor: availableColors[index],
                                    ),

                                    // child: CustomCircleAvatar(
                                    //   radius:
                                    //       MediaQuery.of(context).size.height > 700
                                    //           ? 15.0
                                    //           : 12.0,
                                    //   CavatarColor: Color(0xff7d0552),
                                    //   // CavatarColor: int.parse(widget
                                    //   //     .selectedFurniture
                                    //   //     .shared[selectedColorIndex]
                                    //   //     .quantity) >
                                    //   // 0
                                    //   // ? kAppBackgroundColor
                                    //   //     : Colors.grey,
                                    //   icon: Icon(
                                    //     Icons.remove,
                                    //     // size: 100,
                                    //     size: MediaQuery.of(context).size.height >
                                    //             700
                                    //         ? 22.0
                                    //         : 18.0,
                                    //     color: Color(
                                    //       0xffe42217,
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                                );
                              }),
                        ))
                  ]),
                )
              ])));
        });
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "Images/triangle.png",
          showWorldOrigin: true,
          handlePans: true,
          handleRotation: true,
        );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onPanStart = onPanStarted;
    this.arObjectManager!.onPanChange = onPanChanged;
    this.arObjectManager!.onPanEnd = onPanEnded;
    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationChange = onRotationChanged;
    this.arObjectManager!.onRotationEnd = onRotationEnded;
  }

  Future<void> onRemoveEverything() async {
    /*nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });*/
    anchors.forEach((anchor) {
      this.arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
    setState(() {
      _isvisible = !_isvisible;
    });
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.webGLB,
            uri: widget.model3DUrls[index].toString(),
            scale: Vector3(1, 1, 1),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor = await this
            .arObjectManager!
            .addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          this.nodes.add(newNode);
        } else {
          this.arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }

  onPanStarted(String nodeName) {
    print("Started panning node " + nodeName);
  }

  onPanChanged(String nodeName) {
    print("Continued panning node " + nodeName);
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Ended panning node " + nodeName);
    final pannedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //pannedNode.transform = newTransform;
  }

  onRotationStarted(String nodeName) {
    print("Started rotating node " + nodeName);
  }

  onRotationChanged(String nodeName) {
    print("Continued rotating node " + nodeName);
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Ended rotating node " + nodeName);
    final rotatedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //rotatedNode.transform = newTransform;
  }
}
