import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/new_version/new_version_android.dart';
import '../../../../core/utils/FontSize.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/utils/notification_helper.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/azkar/azkar/AzkarBloc.dart';
import '../bloc/azkar/setting/SettingBloc.dart';
import '../widgets/TitlePageWidget/DrawerWidget.dart';
import '../widgets/titlePageWidget/TitlesListPageWidget.dart';
import '../widgets/titlePageWidget/message_display_widget.dart';
import 'ZikerScreen.dart';

class MainScreen extends StatefulWidget {
  final String? title; // when open from notification
  final int type;

  MainScreen({super.key, this.title, required this.type});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();




  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: _appBar(),
          body: _buildBody(),
        ));
  }

  AppBar _appBar() => AppBar(
      title:  Text(
        getTitle(widget.type),
        style: TextStyle(
            fontSize: 24),
      ),
  );

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<AzkarBloc, AzkarState>(
        builder: (context, state) {
          if (state is LoadingAzkarState) {
            return LoadingWidget();
          } else if (state is LoadedAzkarState) {
            if (widget.type == 1) {
              return Container(
                  child: AzkarListWidget(
                azkar: state.azkarWithoutPray,
                type: widget.type,
              ));
            }
            if (widget.type == 2) {
              return Container(
                  child: AzkarListWidget(
                azkar: state.pryaAzkar,
                type: widget.type,
              ));
            }
            if (widget.type == 3) {
              return Container(
                  child: AzkarListWidget(
                azkar: state.haijAzkar,
                type: widget.type,
              ));
            }
            if (widget.type == 4) {
              return Container(
                  child: AzkarListWidget(
                azkar: state.omraAzkar,
                type: widget.type,
              ));
            }
          } else if (state is ErrorAzkarState) {
            return MessageDisplayWidget(message: state.message);
          }
          return const LoadingWidget();
        },
      ),
    );
  }


}
