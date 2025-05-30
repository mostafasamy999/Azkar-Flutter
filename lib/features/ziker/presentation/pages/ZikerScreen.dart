
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/FontSize.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../data/models/ZikerModel.dart';
import '../../domain/entities/Ziker.dart';
import '../bloc/azkar/azkar/AzkarBloc.dart';
import '../bloc/azkar/setting/SettingBloc.dart';
import '../widgets/ZikerPageWidget/ZikerPageWidget.dart';
import '../widgets/titlePageWidget/message_display_widget.dart';

class ZikerScreen extends StatelessWidget {
  final String zikerTitle;
  final int type;

  ZikerScreen({required this.zikerTitle,required this.type});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: _appBar(context),
          body: _buildBody(),
        ));
  }
  AppBar _appBar(BuildContext context) => AppBar(
      title:  Text(
        getTitle(type),
        style: TextStyle(
            fontSize: 24),
      ),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }));


  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 10,bottom: 10),
      child: BlocBuilder<AzkarBloc, AzkarState>(
        builder: (context, state) {
          if (state is LoadingAzkarState) {
            return LoadingWidget();
          } else if (state is LoadedAzkarState) {
            // Use firstWhere instead of singleWhere
            final ziker = _findZikerByTitle(zikerTitle, state);
            return Container(child: ZikerPageWidget(azkar: ziker,type: type,onBack: (){
              Navigator.of(context).pop();
            },));
          } else if (state is ErrorAzkarState) {
            return MessageDisplayWidget(message: state.message);
          }
          return const LoadingWidget();
        },
      ),
    );
  }
  Ziker _findZikerByTitle(String zikerTitle, LoadedAzkarState state) {
    final lists = [
      state.azkarWithoutPray,
      state.pryaAzkar,
      state.haijAzkar,
      state.omraAzkar,
    ];

    for (final list in lists) {
      final ziker = list.firstWhere(
            (ziker) => ziker.name == zikerTitle,
        orElse: () => ZikerResponse(-1, '', []),
      );
      if (ziker.id != -1) {
        return ziker;
      }
    }

    return ZikerResponse(-1, '', []); // Return default if not found in any list
  }

}
