import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iti_community_flutter/services/auth/Authentication.dart';
import 'package:iti_community_flutter/views/widgets/GroupsWidgets/GroupProfile/Comments.dart';
import 'package:iti_community_flutter/views/widgets/Spinner.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class SinglePost extends StatefulWidget {
  final String id;
  final data;
  SinglePost(this.id, this.data);

  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  String postBody;
  final _formKey = GlobalKey<FormState>();
  final controlCommentBody = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    final userDetails = authServices.storage.getItem('userDetails');
    print(userDetails['firstName']);
    CollectionReference comment = FirebaseFirestore.instance
        .collection('PostGroup')
        .doc(widget.id)
        .collection('Comments');
    Future writeComment(String body) async {
      return await comment.add({
        'Body': body,
        'CommentDate': DateTime.now(),
        'postImg': [],
        'User': {
          'id': '7Kxxu7T1AZYTDlbrzOH2Cun5uJm2',
          'firstName': 'Mohamed',
          'lastName': 'Farghal',
          'jobTitle': 'MEAN Stack Developer',
          'avatar':
              'https://firebasestorage.googleapis.com/v0/b/iti-community.appspot.com/o/UsersProfileImages%2Ffiver_g6.y02txtt?alt=media&token=92c5c725-c4d1-49da-bc9f-949010cb5586'
        }
      });
    }

    List<dynamic> likes = <dynamic>[];
    var userid = AuthServices.userID;
    var a = widget.data['Likes'].contains(userid);

    final Stream<QuerySnapshot> _fb2 = FirebaseFirestore.instance
        .collection('PostGroup')
        .doc(widget.id)
        .collection('Comments')
        .orderBy('CommentDate', descending: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: _fb2,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Spinner();
          }

          Future<bool> giveLike(bool isLiked) async {
            final Future<List> _fb2 = FirebaseFirestore.instance
                .collection('PostGroup')
                .doc(widget.id)
                .get()
                // ignore: missing_return
                .then((value) async {
              List.from(value.data()['Likes']).forEach((element) {
                likes.add(element);
              });
              if (a == true) {
                var rem = likes.indexOf(userid);
                likes.removeAt(rem);
                FirebaseFirestore.instance
                    .collection('PostGroup')
                    .doc(widget.id)
                    .update({'Likes': likes});
              } else {
                likes.add(userid);
                FirebaseFirestore.instance
                    .collection('PostGroup')
                    .doc(widget.id)
                    .update({'Likes': likes});
              }
            });
            return !isLiked;
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(''),
              backgroundColor: HexColor("801818"),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: SizedBox(
                                height: 60,
                                width: 60,
                                child: Image(
                                  image: NetworkImage(
                                      widget.data['Auther']['avatar']),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(widget.data['Auther']['firstName']),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(widget.data['Auther']['lastName']),
                                ],
                              ),
                              subtitle: Text(
                                widget.data['Auther']['jobTitle'],
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                widget.data['Body'],
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            Wrap(
                              alignment: WrapAlignment.start,
                              children: widget.data['postImg']
                                  .map<Widget>((imgUrl) => SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image(
                                            image: NetworkImage(imgUrl),
                                            height: 80,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.start,
                              children: [
                                LikeButton(
                                  onTap: giveLike,
                                  size: 30,
                                  circleColor: CircleColor(
                                      start: Color(0xff00ddff),
                                      end: Color(0xff0099cc)),
                                  bubblesColor: BubblesColor(
                                    dotPrimaryColor: Color(0xff33b5e5),
                                    dotSecondaryColor: Color(0xff0099cc),
                                  ),
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      a
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: a ? Colors.grey : Colors.grey,
                                      size: 30,
                                    );
                                  },
                                  likeCount: widget.data['Likes'].length,
                                  countBuilder:
                                      (int count, bool isLiked, String text) {
                                    var color = a
                                        ? Colors.deepPurpleAccent
                                        : Colors.grey;
                                    Widget result;
                                    if (count == 0) {
                                      result = Text(
                                        "Like",
                                        style: TextStyle(color: color),
                                      );
                                    } else
                                      result = Text(
                                        text,
                                        style: TextStyle(color: color),
                                      );
                                    return result;
                                  },
                                ),
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              insetPadding: EdgeInsets.zero,
                                              content: Stack(
                                                children: <Widget>[
                                                  Positioned(
                                                    // right: -40.0,
                                                    top: -40.0,
                                                    child: InkResponse(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: CircleAvatar(
                                                        child:
                                                            Icon(Icons.close),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: 280,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Form(
                                                        key: _formKey,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
                                                                height: 200,
                                                                child:
                                                                    TextFormField(
                                                                  maxLines:
                                                                      null,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .multiline,
                                                                  decoration: InputDecoration
                                                                      .collapsed(
                                                                          hintText:
                                                                              'Type Your Comment..'),
                                                                  // ignore: missing_return
                                                                  validator:
                                                                      (value) {
                                                                    value
                                                                        .isEmpty;
                                                                    // ignore: unnecessary_statements
                                                                    value.length >
                                                                        3;
                                                                  },
                                                                  controller:
                                                                      controlCommentBody,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Material(
                                                                color: Colors
                                                                    .blue[400],
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.0)),
                                                                child: InkWell(
                                                                  highlightColor:
                                                                      Colors.blue[
                                                                          100],
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Icon(Icons
                                                                            .edit),
                                                                        Text(
                                                                          "Post",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    final String
                                                                        body =
                                                                        controlCommentBody
                                                                            .text;
                                                                    if (body !=
                                                                            null ||
                                                                        body.length >
                                                                            3) {
                                                                      writeComment(
                                                                          body);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.mode_comment_outlined),
                                          Text(
                                            '  Comment',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.black),
                            Column(
                                children: snapshot.data.docs
                                    .map(
                                      (e) => Comments(e.id, e.data()),
                                    )
                                    .toList()),
                            if (snapshot.data.docs.length == 0)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Be First One Comment',
                                  style: TextStyle(color: Colors.blue[300]),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}