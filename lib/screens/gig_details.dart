import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gig_o/utils/buildTools.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/globals.dart' as globals;
import '../utils/formatTools.dart';
import '../utils/apiTools.dart';
import 'home.dart';
import '../utils/classes.dart';

//to-do: see how much you can break out the animation code to utils/animationTools.dart

//for user update on gig status
TextEditingController commentController;
//initialize memberList on each gig_details page load
List memberList = [];

//declare var for check icon animation
Animation<double> _fabScale;
AnimationController animationController;

class GigDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new GigDetailsState();
}

class GigDetailsState extends State<GigDetails> with TickerProviderStateMixin {
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    commentController.dispose();
    super.dispose();
  }

  //for comment text field
  FocusNode nodeOne = FocusNode();
  bool visibilityComment = false;
  String commentButtonText = "Error";

  //hiding or showing comment text field depending on user comment entered for gig or not
  void _currentPlanComment() {
    if (globals.currentPlanComment != "") {
      visibilityComment = true;
      commentButtonText = "Edit Comment";
    }
    if (globals.currentPlanComment == "") {
      visibilityComment = false;
      commentButtonText = "Submit Comment";
    }
  }

  void initState() {
    //build comment widget
    commentController =
        new TextEditingController(text: globals.currentPlanComment);

    buildGigMemberList().then((result) {
      setState(() {
        memberList = result;
        //use memberList for critical mass % calculation
        criticalMassPercent = calculateCriticalMassPercent(memberList);
      });
    });

    //cache gig details so gig details are fetched once on page init
    fetchedGigDetails = buildGigInfo();
    _currentPlanComment();

    //animation setup for check icon to confirm user comment input sent
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      }
    });
    _fabScale = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: animationController, curve: Curves.bounceOut));
    _fabScale.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  //init critical mass percent var
  int criticalMassPercent;
  //for setlist
  bool setListIsExpanded = false;
  //has to be declared after initState()
  Future fetchedGigDetails;

  //to-do: change statusButtons() to class and create a getter for yourStatus attribute
  //and figure out how to move this to formatTools
  String userStatus = globals.currentPlanDescription;
  statusButtons() {
    //for updating user status
    Widget newValue = globals.currentPlanIcon;
    int newStatus;
    return new DropdownButton<Widget>(
      items: <Widget>[
        needsValuePlanIconFormatted,
        definitelyPlanIconFormatted,
        probablyPlanIconFormatted,
        dontKnowPlanIconFormatted,
        probablyNotPlanIconFormatted,
        cantDoItPlanIconFormatted,
        notInterestedPlanIconFormatted,
      ].map((Widget val) {
        return new DropdownMenuItem<Widget>(
          value: val,
          child: val,
        );
      }).toList(),
      value: newValue,
      onChanged: (val) {
        newValue = val;
        if (val == needsValuePlanIconFormatted) {
          userStatus = "Needs Input";
          newStatus = 0;
        } else if (val == definitelyPlanIconFormatted) {
          userStatus = "Definitely!";
          newStatus = 1;
        } else if (val == probablyPlanIconFormatted) {
          userStatus = "Probably";
          newStatus = 2;
        } else if (val == dontKnowPlanIconFormatted) {
          userStatus = "Don't Know";
          newStatus = 3;
        } else if (val == probablyNotPlanIconFormatted) {
          userStatus = "Probably Not";
          newStatus = 4;
        } else if (val == cantDoItPlanIconFormatted) {
          userStatus = "Can't Do It";
          newStatus = 5;
        } else if (val == notInterestedPlanIconFormatted) {
          userStatus = "Not Interested";
          newStatus = 6;
        }
        putStatus(newStatus);
        setState(() {});
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //need initstate to run on return to homepage, to reload current gig information,
        //especially if user has updated status or comment. Disabled default back button and created one
        //that will do so
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Row(children: [
          Container(
            child: FlatButton(
              child: Icon(Icons.arrow_back),
              onPressed: () {
                return Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                globals.currentBandName,
                softWrap: true,
              ),
            ),
          ),
        ]),
      ),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10.0),
          child: FutureBuilder<GigInfo>(
            future: fetchedGigDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        gigTextHeader(globals.currentGigTitle),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              statusIcons(snapshot.data.gigStatus),
                              Container(
                                margin: EdgeInsets.only(left: 5.0),
                                child: statusText(snapshot.data.gigStatus),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        gigText(criticalMassPercent, "Critical Mass %"),
                        Divider(),
                        gigText(snapshot.data.gigDate, "Gig Date"),
                        gigText(snapshot.data.gigCallTime, "Call Time"),
                        gigText(snapshot.data.gigSetTime, "Set Time"),
                        gigText(snapshot.data.gigEndTime, "End Time"),
                        new Container(
                          margin: EdgeInsets.all(5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                child: new Text(
                                  "Gig Address: ",
                                  softWrap: true,
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              new Expanded(
                                  child: new Container(
                                child: FlatButton(
                                  child: Text("${snapshot.data.gigAddress}",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(14, 39, 96, 1.0),
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () async {
                                    if (await canLaunch(
                                        "${snapshot.data.gigAddressLink}")) {
                                      await launch(
                                          "${snapshot.data.gigAddressLink}");
                                    }
                                  },
                                ),
                              ))
                            ],
                          ),
                        ),
                        gigText(snapshot.data.gigPaid, "Pay"),
                        gigText(snapshot.data.gigLeader, "Leader"),
                        gigText(snapshot.data.gigPostGig, "Post-Gig Plans"),
                        Divider(),
                        gigTextHeader("Details"),
                        gigText(snapshot.data.gigDetails),
                        Divider(),
                        setListIsExpanded
                            ? Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        child: gigTextHeader("SetList"),
                                      ),
                                      new RawMaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              setListIsExpanded = false;
                                            });
                                          },
                                          child: new Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black,
                                            size: 35.0,
                                          )),
                                    ],
                                  ),
                                  gigText(snapshot.data.gigSetList),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: gigTextHeader("SetList"),
                                  ),
                                  Container(
                                    child: new RawMaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            setListIsExpanded = true;
                                          });
                                        },
                                        child: new Icon(
                                          Icons.arrow_drop_up,
                                          color: Colors.black,
                                          size: 35.0,
                                        )),
                                  ),
                                ],
                              ),

                        Divider(),
                        gigTextHeader("Your Status: "),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              statusButtons(),
                              new Text(userStatus,
                                  style: TextStyle(fontSize: 20.0)),
                            ],
                          ),
                        ),
                        //if there is a comment, reveal the comment in textfield, if not, hide text field
                        visibilityComment
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Flexible(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: new TextField(
                                        focusNode: nodeOne,
                                        controller: commentController,
                                        onSubmitted: (val) {
                                          postComment(val);
                                          //fire the check icon
                                          animationController.forward();
                                        },
                                      ),
                                    ),
                                  ),
                                  //check icon to confirm the user input completed
                                  Transform.scale(
                                    scale: _fabScale.value,
                                    child: Card(
                                      shape: CircleBorder(),
                                      color: Colors.green,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : new Container(),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: FlatButton(
                            onPressed: () {
                              //if a comment exists, clicking the button will focus on the textfield
                              visibilityComment
                                  ? FocusScope.of(context).requestFocus(nodeOne)
                                  //if a comment doesn't exist, clicking the button will reveal text field and change
                                  //the button text to editing
                                  : setState(() {
                                      visibilityComment = true;
                                      commentButtonText = "Edit Comment";
                                    });
                            },
                            child: Text(commentButtonText,
                                style: TextStyle(
                                    color: Color.fromRGBO(14, 39, 96, 1.0),
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Divider(),
                        gigTextHeader("Plans"),
                        Container(margin: EdgeInsets.only(bottom: 20.0)),
                        ListView.builder(
                          //need the physics property set otherwise you will hit an infinity error and can't scroll up!
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: memberList.length,
                          itemBuilder: (context, index) {
                            return Container(
                                margin: EdgeInsets.only(bottom: 5.0),
                                decoration: new BoxDecoration(
                                  border: new Border(
                                    left: new BorderSide(
                                        color: Colors.grey,
                                        width: 5.0,
                                        style: BorderStyle.solid),
                                  ),
                                ),
                                padding: EdgeInsets.only(left: 10.0),
                                child: Column(children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(right: 15.0),
                                          child: Text(
                                            '${memberList[index]["name"]}',
                                            style: TextStyle(fontSize: 20.0),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 15.0),
                                          child: Text(
                                            '${memberList[index]["section"]}',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                        ),
                                        Container(
                                          child: planValueIcons(
                                              '${memberList[index]["value"]}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    child: Text(
                                        '${memberList[index]["comment"]}',
                                        style: TextStyle(fontSize: 15.0)),
                                  ),
                                ]));
                          },
                        ),
                      ],
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                child: new CircularProgressIndicator(
                  strokeWidth: 3.0,
                  value: null,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            },
          )),
    );
  }
}
