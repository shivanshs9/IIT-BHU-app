import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/club_&_council_widgets.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';

class CouncilPage extends StatefulWidget {
  @override
  _CouncilPageState createState() => _CouncilPageState();
}

class _CouncilPageState extends State<CouncilPage> {
  BuiltCouncilPost councilData;
  File _councilLargeLogoFile;
  @override
  void initState() {
    fetchCouncilById();
    super.initState();
  }

  void fetchCouncilById() async {
    print('fetching council data ');
    councilData = await AppConstants.getCouncilDetailsFromDatabase(
        councilId: AppConstants.currentCouncilId);

    _councilLargeLogoFile = AppConstants.getImageFile(
        isCouncil: true, isSmall: false, id: councilData.id);

    if (_councilLargeLogoFile == null) {
      AppConstants.writeImageFileIntoDisk(
          isCouncil: true,
          isSmall: false,
          id: councilData.id,
          url: councilData.large_image_url);
    }

    if (!this.mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  final space = SizedBox(height: 8.0);

  final divide = Divider(height: 8.0, thickness: 2.0, color: Colors.blue);

  SliverAppBar _getSliverAppBar(context) {
    return SliverAppBar(
      leading: Container(),
      backgroundColor: Colors.white,
      floating: true,
      expandedHeight: MediaQuery.of(context).size.height * 3 / 4,
      flexibleSpace: FlexibleSpaceBar(
        background: councilData == null
            ? Container(
                height: MediaQuery.of(context).size.height * 3 / 4,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Stack(
                children: [
                  Container(
                    //height: MediaQuery.of(context).size.height * 0.75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(35.0),
                            bottomRight: Radius.circular(35.0)),
                        color: Color(0xFF736AB7)),
                  ),
                  Container(
                    child: _councilLargeLogoFile == null
                        ? Image.network(councilData.large_image_url,
                            fit: BoxFit.cover, height: 300.0)
                        : Image.file(_councilLargeLogoFile,
                            fit: BoxFit.cover, height: 300.0),
                    constraints: new BoxConstraints.expand(height: 295.0),
                  ),
                  ClubAndCouncilWidgets.getGradient(),
                  _getDescription(),
                  ClubAndCouncilWidgets.getToolbar(context),
                ],
              ),
      ),
    );
  }

  Container _getDescription() {
    final _overviewTitle = "Description".toUpperCase();
    return new Container(
      child: new ListView(
        padding: new EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          ClubAndCouncilWidgets.getClubCard(
              title: councilData.name,
              id: councilData.id,
              imageUrl: councilData.large_image_url,
              isCouncil: true,
              context: context),
          SizedBox(height: 8.0),
          Container(
            padding: new EdgeInsets.symmetric(horizontal: 32.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  _overviewTitle,
                  style: Style.headerTextStyle,
                ),
                new Separator(),
                Text(councilData.description, style: Style.commonTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getClubs() {
    return councilData == null
        ? Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: councilData.clubs.length,
              itemBuilder: (context, index) {
                return ClubAndCouncilWidgets.getClubCard(
                  context: context,
                  title: councilData.clubs[index].name,
                  subtitle: councilData.name,
                  id: councilData.clubs[index].id,
                  imageUrl: councilData.clubs[index].small_image_url,
                  isCouncil: false,
                  club: councilData.clubs[index],
                  horizontal: true,
                );
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _getSliverAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    //scrollDirection: Axis.vertical,
                    children: <Widget>[
                      space,
                      Container(
                        color: Colors.white,
                        //margin: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Clubs',
                                      style: Style.headingStyle,
                                      textAlign: TextAlign.left),
                                  divide,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _getClubs(),
                      councilData == null
                          ? Container(
                              height: MediaQuery.of(context).size.height / 4,
                              child: Center(child: CircularProgressIndicator()))
                          : ClubAndCouncilWidgets.getSecies(context,
                              secy: councilData.gensec,
                              joint_secy: councilData.joint_gensec),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
