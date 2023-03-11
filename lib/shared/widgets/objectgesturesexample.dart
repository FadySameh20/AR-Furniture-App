import 'dart:async';

import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:flutter/material.dart' as material;
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

import '../../cubits/home_cubit.dart';
import '../../cubits/home_states.dart';
import '../../models/furniture_model.dart';
import '../constants/constants.dart';
import 'circle_avatar.dart';

class ObjectGesturesWidget extends StatefulWidget {
  List<FurnitureModel> furnModel;
  List<Color?> availableColors = [];

  ObjectGesturesWidget(this.furnModel, [this.availableColors = const []]);

  @override
  _ObjectGesturesWidgetState createState() => _ObjectGesturesWidgetState();
}

class _ObjectGesturesWidgetState extends State<ObjectGesturesWidget> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  bool isLoadingGLB = false;
  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  int? index;

  // List<Color?> availableColors = [];
  bool _isvisible = false;
  int selectedColorIndex = 0;
  int selectedNodeIndex = -1;
  Map<String, dynamic> modelsMap = {};
  bool toolTip = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTimer();
    print(widget.availableColors.isEmpty);
    if (widget.availableColors.isEmpty) {
      index = -1;
      print("indexxxxxxxxxxx" + index.toString());
    } else {
      index = 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  Future<void> setTimer() async {
    Timer(Duration(seconds: 3), () {
      setState(() {
        toolTip = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          child:
          return Scaffold(
              appBar: AppBar(
                title: const Text('Augmented Reality'),
                backgroundColor: kAppBackgroundColor,
                centerTitle: true,
              ),
              body: Container(
                  child: Stack(children: [
                ARView(
                  onARViewCreated: onARViewCreated,
                  planeDetectionConfig:
                      PlaneDetectionConfig.horizontalAndVertical,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 1.5,
                      right: MediaQuery.of(context).size.width / 40),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    toolTip == false
                        ? Material(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(0.0),
                            ),
                            elevation: 5.0,
                            color: kAppBackgroundColor.withAlpha(200),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                "Remove Everything",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: material.Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Text(""),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: GestureDetector(
                        onTap: onRemoveEverything,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(
                            Icons.delete_forever_outlined,
                            size: 43,
                            color: material.Colors.red,
                          ),
                        ),
                      ),
                    ),

                    // ElevatedButton(
                    //     onPressed: onRemoveEverything,
                    //     child: Text("Remove Everything")),
                  ]),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width / 1,
                    height: MediaQuery.of(context).size.height / 9.5,
                    decoration: BoxDecoration(
                        color: Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff708090),
                            blurRadius: 7,
                          )
                        ]),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.only(left: 9, right: 9),
                        width: MediaQuery.of(context).size.width / 1,
                        height: MediaQuery.of(context).size.height / 8,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: widget.furnModel.length,
                          itemBuilder: (context, int index) {
                            return InkWell(
                              onTap: () {
                                widget.availableColors =
                                    BlocProvider.of<HomeCubit>(context)
                                        .getAvailableColorsOfFurniture(
                                            widget.furnModel[index]);
                                setState(() {
                                  _isvisible = true;
                                  this.index = index;
                                  selectedColorIndex = 0;
                                  selectedNodeIndex = -1;
                                });
                              },
                              child: Align(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(left: 5.0, right: 7.0),
                                    width:
                                        MediaQuery.of(context).size.width / 5.5,
                                    height:
                                        MediaQuery.of(context).size.height / 12,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: this.index == index &&
                                              this.index != -1 &&
                                              selectedNodeIndex == -1
                                          ? kAppBackgroundColorLowOpacity
                                          : Color(0xFFEEEEEE),
                                    ),
                                    child: Image.network(widget
                                        .furnModel[index].shared.first.image)),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isvisible,
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 5,
                            right: 10),
                        width: MediaQuery.of(context).size.width / 7,
                        height: MediaQuery.of(context).size.height / 3.2,
                        decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff708090),
                                blurRadius: 7,
                              )
                            ]),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 3,
                          child: Column(
                            children: [
                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: widget.availableColors.length,
                                  itemBuilder: (context, int index) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 17),
                                      child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            selectedColorIndex = index;
                                          });
                                          if (nodes.isNotEmpty) {
                                            bool flag = false;
                                            String tempNode = "";
                                            for (var node in modelsMap.keys) {
                                              if (modelsMap[node]
                                                      ["furnitureName"] ==
                                                  widget.furnModel[this.index!]
                                                      .name) {
                                                tempNode = node;
                                                flag = true;
                                                break;
                                              }
                                            }
                                            if (flag) {
                                              if (modelsMap[tempNode]
                                                      ["colorIndex"] !=
                                                  selectedColorIndex) {
                                                await replaceColor();
                                              }
                                            }
                                          }
                                        },
                                        child: CircleAvatar(
                                          radius: 18.0,
                                          backgroundColor:
                                              widget.availableColors[index],
                                          child: CircleAvatar(
                                            radius: 15.0,
                                            backgroundColor: Color(0xffffffff),
                                            child: CustomCircleAvatar(
                                              radius: 10.0,
                                              CavatarColor:
                                                  widget.availableColors[index],
                                              icon: index == selectedColorIndex
                                                  ? Icon(
                                                      Icons.check,
                                                      color: Color(0xff000000),
                                                      size: 18.0,
                                                    )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                              Spacer(),
                              selectedNodeIndex != -1
                                  ? Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4.0),
                                        child: IconButton(
                                          icon: Icon(Icons.cancel_outlined),
                                          iconSize: 35,
                                          color: material.Colors.red,
                                          onPressed: () {
                                            removeModel();
                                          },
                                        ),
                                      ),
                                    )
                                  : Text(""),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                Visibility(
                    visible: isLoadingGLB,
                    child: Container(
                        color: Color(0x8E645E5E),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: kAppBackgroundColor,
                          ),
                        )))
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
    this.arObjectManager!.onNodeTap = onNodeTap;
  }

  Future<void> onRemoveEverything() async {
    /*nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });*/
    anchors.forEach((anchor) {
      this.arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
    nodes = [];
    modelsMap = {};
    setState(() {
      _isvisible = false;
      selectedColorIndex = 0;
      index = -1;
    });
  }

  Future<void> removeModel() async {
    this.arAnchorManager!.removeAnchor(anchors[selectedNodeIndex]);
    print(modelsMap.length);
    modelsMap.remove(nodes[selectedNodeIndex].name);
    print("Models map");
    print(modelsMap.length);
    nodes.removeAt(selectedNodeIndex);
    anchors.removeAt(selectedNodeIndex);
    setState(() {
      _isvisible = false;
    });
  }

  Future<void> replaceColor() async {
    var newNode = ARNode(
      type: NodeType.webGLB,
      uri: widget.furnModel[index!].shared[selectedColorIndex].model.toString(),
      transformation: nodes[selectedNodeIndex].transform,
      scale: nodes[selectedNodeIndex].scale,
      // position: nodes[selectedNodeIndex].position,
      // rotation: Vector4.fromFloat64List(nodes[selectedNodeIndex].transform.storage)
    );
    print("tttttttttt");
    // print(nodes[selectedNodeIndex].rotation.);
    if (isLoadingGLB == true) {
      return;
    }
    setState(() {
      isLoadingGLB = true;
    });
    var newArAnchor = ARPlaneAnchor(
        transformation: anchors[selectedNodeIndex].transformation);
    await removeModel();
    bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newArAnchor);
    if (didAddAnchor!) {
      this.anchors.add(newArAnchor);
      bool? didAddNodeToAnchor = await this
          .arObjectManager!
          .addNode(newNode, planeAnchor: newArAnchor);
      if (didAddNodeToAnchor!) {
        this.nodes.add(newNode);
        modelsMap[newNode.name] = {
          "furnitureName": widget.furnModel[index!].name,
          "furnitureIndex": index,
          "colorIndex": selectedColorIndex,
          "availableColors": widget.availableColors.toList()
        };
      }
    }
    setState(() {
      isLoadingGLB = false;
    });
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    print(this.index);
    print("Tapping a node");

    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      if (this.index == -1 || isLoadingGLB == true) {
        return;
      }
      setState(() {
        isLoadingGLB = true;
      });
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.webGLB,
            uri: widget.furnModel[index!].shared[selectedColorIndex].model
                .toString(),
            scale: Vector3(1, 1, 1),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor = await this
            .arObjectManager!
            .addNode(newNode, planeAnchor: newAnchor);
        setState(() {
          isLoadingGLB = false;
        });
        if (didAddNodeToAnchor!) {
          this.nodes.add(newNode);
          modelsMap[newNode.name] = {
            "furnitureName": widget.furnModel[index!].name,
            "furnitureIndex": index,
            "colorIndex": selectedColorIndex,
            "availableColors": widget.availableColors.toList()
          };
          setState(() {
            _isvisible = false;
            selectedColorIndex = 0;
            index = -1;
          });
        } else {
          this.arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }

  onNodeTap(List<String> nodeName) {
    selectedNodeIndex =
        nodes.indexWhere((element) => element.name == nodeName.first);
    setState(() {
      _isvisible = true;
      selectedColorIndex = modelsMap[nodeName.first]["colorIndex"];
      this.index = modelsMap[nodeName.first]["furnitureIndex"];
      widget.availableColors = modelsMap[nodeName.first]["availableColors"];
    });
  }

  onPanStarted(String nodeName) {
    print("Started panning node " + nodeName);
  }

  onPanChanged(String nodeName) {
    print("Continued panning node " + nodeName);
    final pannedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Ended panning node " + nodeName);
    final pannedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);
    pannedNode.transform = newTransform;

    setState(() {
      _isvisible = false;
      index = -1;
      selectedColorIndex = 0;
    });
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
    rotatedNode.transform = newTransform;
    print("hhhhhh");
    print(rotatedNode.transform);
    print(rotatedNode.transform.getRotation());
    print(Vector4.fromFloat64List(rotatedNode.transform.getRotation().storage));
    print(rotatedNode.transform.row1.a);
    print(rotatedNode.transform.row2.a);

    setState(() {
      _isvisible = false;
      index = -1;
      selectedColorIndex = 0;
    });
    // print(rotatedNode)
  }
}
