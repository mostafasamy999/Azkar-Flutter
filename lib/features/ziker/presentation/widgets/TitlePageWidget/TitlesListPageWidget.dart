import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahih_azkar/features/ziker/presentation/widgets/common/popupMenuList.dart';

import '../../../../../core/colors.dart';
import '../../../../../core/utils/FontSize.dart';
import '../../../../../core/utils/Utils.dart';
import '../../../domain/entities/Ziker.dart';
import '../../bloc/azkar/setting/SettingBloc.dart';
import '../../pages/ZikerScreen.dart';

class AzkarListWidget extends StatelessWidget {
  final List<Ziker> azkar;
  final int type;

  const AzkarListWidget({
    Key? key,
    required this.azkar,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: AppColors.c2Read,
        child: BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
            if (state is LoadedSettingState) {
              return ListView.builder(
                itemCount: azkar.length,
                itemBuilder: (context, index) {
                  return _itemList(context, index, state.setting.fontSize);
                },
              );
            } else if (state is ErrorSettingState) {}
            return ListView.builder(
              itemCount: azkar.length,
              itemBuilder: (context, index) {
                return _itemList(context, index, FontSize.Median);
              },
            );
          },
        ));
  }

  Widget _itemList(BuildContext context, int index, FontSize fontSize) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(20), // Corner radius
          color: azkar[index].isEmportant? AppColors.drawerBg5: AppColors.cardBackground,
          child: ListTile(
            title: Text(
            '${azkar[index].name.removeNumberInParentheses()}',
            // '${azkar[index].id}- ${azkar[index].name.removeNumberInParentheses()}',
            textAlign: azkar[index].isEmportant?TextAlign.center:TextAlign.start,
              style: TextStyle(
                fontSize: Utils().fontSize(fontSize),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            onTap: () {
              final zikerTitle = azkar[index].name;

            //   if (zikerTitle == 'ما كان يقرأ به ﷺ في الصلوات') {
            //     showListDialog(context: context,title: zikerTitle,azkar:prayAzkar,onTap: (title){
            //       _goToZikerPage(context, title);
            //     });
            //   } else if (zikerTitle == 'الحج'){
            //     showListDialog(context: context,title: zikerTitle,azkar:haijAzkar,onTap: (title){
            //       _goToZikerPage(context, title);
            //     });
            // } else if (zikerTitle == 'العمرة'){
            //     showListDialog(context: context,title: zikerTitle,azkar:omraAzkar,onTap: (title){
            //       _goToZikerPage(context, title);
            //     });
            // } else {
                _goToZikerPage(context, zikerTitle);
              // }
            },
          ),
        ));
  }

  void _goToZikerPage(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ZikerScreen(zikerTitle: title,type: type,),
      ),
    );
  }
}
