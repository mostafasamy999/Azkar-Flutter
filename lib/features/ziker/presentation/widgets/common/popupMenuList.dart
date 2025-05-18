import 'package:flutter/material.dart';

import '../../../domain/entities/Ziker.dart';
import '../../pages/ZikerScreen.dart';


void showListDialog(
    {required BuildContext context,required  List<Ziker> azkar,required  void Function(String) onTap}) {
  // Calculate the height based on screen size, max 80% of screen height
  final double screenHeight = MediaQuery.of(context).size.height;
  final double dialogHeight = screenHeight * 0.7 > 600 ? 600 : screenHeight * 0.7;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl, // RTL direction
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: const Color(0xFFFFFBF7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: const BoxDecoration(
                  color: Color(0xFF3C5665),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'ما كان يقرأ به ﷺ في الصلوات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: dialogHeight,
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 6,
                  radius: const Radius.circular(10),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: azkar.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          azkar[index].name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        trailing: const Icon(Icons.menu_book_outlined, color: Color(0xFF3C5665)),
                        onTap: () {
                          Navigator.pop(context);
                          onTap(azkar[index].name);




                        },
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3C5665),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Text('إغلاق'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

