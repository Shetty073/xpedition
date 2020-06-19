import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xpedition/data_models/with_id/user_data_with_id.dart';

class SettingsView extends StatefulWidget {
  final UserDataWithId myUserDataWithId;

  SettingsView({@required this.myUserDataWithId});

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

// TODO: Build settings_view
class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
        left: 0.025 * deviceWidth,
        right: 0.025 * deviceWidth,
        top: 0.025 * deviceWidth,
        bottom: 0.025 * deviceWidth,
      ),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: InkWell(
              onTap: () {},
              splashColor: Theme.of(context).textTheme.headline4.color,
              child: Container(
                height: 0.12 * deviceHeight,
                padding: EdgeInsets.only(
                  left: 0.03 * deviceWidth,
                  right: 0.03 * deviceWidth,
                  top: 0.025 * deviceWidth,
                  bottom: 0.025 * deviceWidth,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 0.08 * deviceWidth,
                      backgroundImage: NetworkImage(
                          "https://api.adorable.io/avatars/285/${widget.myUserDataWithId.firstName}${widget.myUserDataWithId.lastName}@adorable.io.png"),
                    ),
                    SizedBox(
                      width: 0.05 * deviceWidth,
                    ),
                    Text(
                      "${widget.myUserDataWithId.firstName} ${widget.myUserDataWithId.lastName}",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 0.05 * deviceWidth,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            color: Theme.of(context).textTheme.bodyText1.color,
            thickness: 0.001 * deviceWidth,
          ),
          SizedBox(
            height: 0.02 * deviceWidth,
          ),
          Center(
            child: Text(
              "More features coming soon...",
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontSize: 0.03 * deviceWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
