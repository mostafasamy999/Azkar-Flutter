import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/colors.dart';
import '../../../../core/utils/FontSize.dart';
import '../../../../core/utils/Utils.dart';
import '../bloc/azkar/setting/SettingBloc.dart';

class MyWillScreen extends StatelessWidget {
  MyWillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: _buildAppbar(context),
          body: _buildBody(),
        ));
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () async {
          Navigator.pop(context);
        },
      ),
      title: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          if (state is LoadedSettingState) {
            return Text(
              'هذه وصيتي',
              style: TextStyle(fontSize: Utils().fontSize(state.setting.fontSize)),
            );
          }

          return  Text('هذه وصيتي',);
        },
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<SettingBloc, SettingState>(builder: (context, state) {
      if (state is LoadedSettingState) {
        final _textSize = Utils().fontSize(state.setting.fontSize);
        return _bodyContent(_textSize);
      }
      return _bodyContent(Utils().fontSize(FontSize.Median));
    });
  }

  Widget _bodyContent(double fontSize) {
    return Container(
      // color: AppColors.c2Read,
      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 16.0, bottom: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'هذه وصيتي',
                style: TextStyle(
                  fontFamily: 'alfont',
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: fontSize * 3,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: fontSize,
                ),
                children: [
                  TextSpan(
                    text: 'قال رسول الله ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ': ((ما حَقُّ امرئٍ مسلم يَبيتُ ليلَتين وله شيءٌ يُريد أن يُوصي فيه، إلَّا ووصيتُه مكتوبةٌ تحت رأسه)) قال ابن عمر: ما مرت عليَّ ليلةٌ منذ سمعت رسول الله صلى الله عليه وسلم قال ذلك، إلا وعِندي وصيتي.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'هذا ما أَوْصَى به ........................ وهو يشهد أن لا إله إلا الله وحده لا شريك له، وأن محمدًا عبده ورسوله، وأن عيسى عبد الله ورسوله، وكلمته ألقاها إلى مريم وروح منه، وأنَّ الجنَّة حقٌّ، وأن النار حق، وأن الساعة لا ريب فيها، وأن الله يبعث من في القبور، وأوصي أولادي وأهلي وأقاربي وجميع المسلمين بتقوى الله عز وجل، وأوصيهم بما وَصَّى به إبراهيم بنيه ويعقوب: {وَوَصَّى بِهَا إِبْرَاهِيمُ بَنِيهِ وَيَعْقُوبُ يَا بَنِيَّ إِنَّ اللَّهَ اصْطَفَى لَكُمُ الدِّينَ فَلَا تَمُوتُنَّ إِلَّا وَأَنتُم مسلمون).',
              style: TextStyle(
                // color: AppColors.c4Actionbar,
                fontSize: fontSize,
              ),
            ),
            SizedBox(height: 16.0),
            _buildBulletPoint('وأُوصِي زوجتي وأولادي وأصدقائي وكل محب لي إذا بلغه خبر وفاتي بأن يدعو لي بالمغفرة والرحمة-أولا-وألا يبكون علي نياحةً أو بصوت مرتفع، فإذا أنا مت وقبضت روحي، فعليهم بتغميضي، وتغطيتي بثوب غير الذي مت فيه يستر جميع بدني، ولا مانع لمحارمي من تقبيلي، والدعاء لي بالرحمة والمغفرة.', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي بتسديد ما على من الدَّين - إن كان عليّ -  ، وأولادي القُصَّر يكون وليهم..................، يحفظ لهم حقهم من التركة حتى يبلغوا.', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي من مالي لغير الورثة فيما لا يزيد على الثلث  ...... ( الثلث او الربع او الخمس .... الخ ،يُنفق في سبيل الله تعالى صدقة جارية على طلب العلم الشرعي والأقارب والجيران الفقراء.', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي بتَلْقِيني كلمةَ التوحيد   قبل الموت لا بعده؛ ويحضرني من يذكِّروني بحسن الظن بالله من أهل السنة الصالحين.', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي بعد خروج روحي بقول: إنَّا لله وإنَّا إليه راجعون، اللهم أجُرْني في مُصيبتي، وأخلف لي خيرًا منها.  ، وبالصبرُ والرضا بقدر الله، وألا ينعوني نعياً منهيَّاً عنه.', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي بألا يدعوا على أنفسهم إلا بخير فإن الملائكة تؤمن على ما يقولون  ، وأن يدعوَ لي بخير ، ويقولوا اللهم اغفر له، وارفع درجته في المهديين، واخلفه في عقبه في الغابرين، واغفر لنا وله يا رب العالمين، اللهم افسح له في قبره ونور له فيه ، وبما صح عن النبي  .', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي أن يتولى غسلي ................ ومن يختاره هو لإعانته على ذلك ، فإن لم يوجد فأعرف الناس بسُنَّةِ الغسل، ولاسيما أن يكون من أهلي، وأن يبتغي بذلك وجه الله، وأن يكتمَ ما يراه مني ولا يُحدِّث به أحداً، وأن يغسلني ثلاثاً أو أكثر على ما يرى القائمون على غُسلي، على أن يكون غُسلي وتراً، وأن يُقْرِن مع بعض الغسلات شيء للتنظيف (كالصابون)، وأن يجعل مع آخِر غسلة شيء من الطيب (كافور... فإن لم يُوجد فغيرِهِ من الطِيب) وأن يبدأ بالميامن ومواضع الوضوء مِنِّي.', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي بعد غسلي بتكفيني، وأن يكون ثمن الكفن من مالي ولو لم أترك غيره، ويكون أبيض اللون، وأن يكون سابغاً يستر جميع بدني، ولا يكون فيه قميص أو عمامة، ويُبَخّر الكفن ثلاثاً من العُود، فإن لم يوجد فبأي بخور).', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي بالتعزية للمصاب بما ورد عنه صلى الله عليه وسلم: ((إن لله ما أخَذَ، وله ما أعطى، وكل شيء عنده بأجل مسمًّى، فلتصبر ولتحتسب)) ', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي بالإسراع بتجهيزي ولا تؤخروا دفني لقدوم غائب أو مسافر وإن كان والدي أو ولدي.', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي أن يُصلِّي عليَّ إمام المسلمين الراتب أو أقرأ النـاس لكتاب الله، ثم أعْلَمهم بالسُنَّة، وأن يقف عند رأسي، أما المرأة فعند وسطها ، ولا يتحرى اوقات الكراهة في الصلاة عليّ أو دفني إلا لضرورة.', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('تكثير صفوف المصلِّين، وإخلاص الدعاء لي، والدفن في أقرب مقابر للمسلمين ،واختاروا قبرا غير مشيدٍ أو مجصصٍ أو مبني عليه بناءا ، ولا تلقوني على وجه الأرض دون دفن – لحد أو شق ، واللحد أفضل - وأن يُعمَّق الحفر في القبر ويُوسَّع، وأن يقول الذي يضعني في قبري: "بسم الله وعلى سُنَّة ـ أو على مِلَّة ـ رسول الله "،وألا يكشفوا وجهي في القبر.', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي بألا تصحبنى نائحة ولا نار -السيجارة وما شابه- فإذا دفنتمونى فشنوا على التراب شناً ثم أقيموا حول قبري قدر ما تُنحَر جزورٌ ويُقسم لحمها حتى أستأنس بكم وأنظر ماذا أراجع به رسل ربى.', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي بالدعاء لي بالمغفرة والتثبيت بعد الدفن  .', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي أهلي و أقاربي وأحبابي وأخواني بكثرة الدعاء لي، وقضاء صومي النذر الذي لم أستطع صومه.', fontSize),
            SizedBox(height: 8.0),
            _buildBulletPoint('وأُوصِي الأقارب والجيران والأصدقاء بتهيئة الطعام لأهلي؛ لقوله صلى الله عليه وسلم: ((اصنعوا لآل جعفر طعامًا؛ فقد أتاهم ما يَشغَلُهم)).', fontSize),
            SizedBox(height: 16.0),
            Text(
              'هذا وأنا برئ ممن برئ منه رسول الله  ؛برئ من الصالقة والحالقة والحالقة  والشاقة.',
              style: TextStyle(
                // color: AppColors.c4Actionbar,
                fontSize: fontSize,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'الصالقة: المولولة بالصوت الشديد، والحالقة : تحلق شعرها عند المصيبة، والشاقة : تشق ثيابها',
              style: TextStyle(
                // color: AppColors.c4Actionbar,
                fontSize: fontSize * 0.9,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'وأنهى عن رفع الصوت بالبكاء، والنياحة، ولطم الخدود، وشقُّ الثياب، ولبس السواد؛ لقوله صلى الله عليه وسلم : ((الميت يُعذَّب في قبره بما نِيحَ عليه))',
              style: TextStyle(
                // color: AppColors.c4Actionbar,
                fontSize: fontSize,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'وأنهى عن وضع الأحجار العالية وفرشة الحجر وغيرها على القبر، وكذلك تدهينه والكتابة عليه أو تجصيصه  .',
              style: TextStyle(
                // color: AppColors.c4Actionbar,
                fontSize: fontSize,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'وأنهى عن الاجتماع في الذكرى السنوية والأربعين او الخميس وتأجير من يقرأ القرآن فهي من البدع والمحرمات.، وأنهى عن اتخاذ قبري عيدا فلا يخص بالزيارة في يوم أو شهر أو ما شابه.',
              style: TextStyle(
                // color: AppColors.c4Actionbar,
                fontSize: fontSize,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'وأنهى نسائي عن الإكثار من زيارة قبري فقد نهى عن ذلك رسول الله .  ',
              style: TextStyle(
                // color: AppColors.c4Actionbar,
                fontSize: fontSize,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'وأنهى عن تأجير جماعة عتاقة أو ختمة أو إسقاط صلاة عني.',
              style: TextStyle(
                // color: AppColors.c4Actionbar,
                fontSize: fontSize,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'ويُكتفى بوضع حجر بارتفاع شبر؛ ليعرف القبر، كما فعل الرسول صلى الله عليه وسلم عندما وضع حجرًا على قبر عثمان بن مظعون، وقال: ((أتعلَّم بها قبر أخي)).',
              style: TextStyle(
                // color: AppColors.c4Actionbar,
                fontSize: fontSize,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'والحمد لله رب العالمين ، فاللَّهُمَّ بِعِلْمِكَ الْغَيْبَ وَقُدْرَتِكَ عَلَى الْخَلْقِ ؛ أَحْيِنِي مَا عَلِمْتَ الْحَيَاةَ خَيْرًا لِي، وَتَوَفَّنِي إِذَا عَلِمْتَ الْوَفَاةَ خَيْرًا لِي، اللَّهُمَّ وَأَسْأَلُكَ خَشْيَتَكَ فِي الْغَيْبِ وَالشَّهَادَةِ، وَأَسْأَلُكَ كَلِمَةَ الْحَقِّ فِي الرِّضَا وَالْغَضَبِ، وَأَسْأَلُكَ الْقَصْدَ فِي الْفَقْرِ وَالْغِنَى، وَأَسْأَلُكَ نَعِيمًا لَا يَنْفَدُ، وَأَسْأَلُكَ قُرَّةَ عَيْنٍ لَا تَنْقَطِعُ، وَأَسْأَلُكَ الرِّضَاءَ بَعْدَ الْقَضَاءِ، وَأَسْأَلُكَ بَرْدَ الْعَيْشِ بَعْدَ الْمَوْتِ، وَأَسْأَلُكَ لَذَّةَ النَّظَرِ إِلَى وَجْهِكَ وَالشَّوْقَ إِلَى لِقَائِكَ فِي غَيْرِ ضَرَّاءَ مُضِرَّةٍ وَلَا فِتْنَةٍ مُضِلَّةٍ، اللَّهُمَّ زَيِّنَّا بِزِينَةِ الْإِيمَانِ، وَاجْعَلْنَا هُدَاةً مُهْتَدِينَ "،اللَّهُمَّ أَصْلِحْ لِي دِينِي الَّذِي هُوَ عِصْمَةُ أَمْرِي، وَأَصْلِحْ لِي دُنْيَايَ الَّتِي فِيهَا مَعَاشِي، وَأَصْلِحْ لِي آخِرَتِي الَّتِي فِيهَا مَعَادِي، وَاجْعَلِ الْحَيَاةَ زِيَادَةً لِي فِي كُلِّ خَيْرٍ، وَاجْعَلِ الْمَوْتَ رَاحَةً لِي مِنْ كُلِّ شَرٍّ ".',
              style: TextStyle(
                // color: AppColors.c4Actionbar,
                fontSize: fontSize,
              ),
            ),
            SizedBox(height: 20.0),
            Divider(
                // color: AppColors.c4Actionbar.withOpacity(0.3
                // )
    )
            ,
            SizedBox(height: 12.0),
            // Text(
            //   'الموصي بما فيه :..............................',
            //   style: TextStyle(
            //     color: AppColors.c4Actionbar,
            //     fontSize: fontSize,
            //   ),
            // ),
            // SizedBox(height: 12.0),
            // Text(
            //   'توثيق الوصية بشهادة شاهدين عدلين',
            //   style: TextStyle(
            //     color: AppColors.c4Actionbar,
            //     fontSize: fontSize,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // SizedBox(height: 8.0),
            // Text(
            //   'شاهد أول:.......................   شاهد ثاني:......................',
            //   style: TextStyle(
            //     color: AppColors.c4Actionbar,
            //     fontSize: fontSize,
            //   ),
            // ),
            // SizedBox(height: 8.0),
            // Text(
            //   'اسم منفذ الوصية:.................',
            //   style: TextStyle(
            //     color: AppColors.c4Actionbar,
            //     fontSize: fontSize,
            //   ),
            // ),
            // SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text, double fontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•  ',
          style: TextStyle(
            // color: AppColors.c4Actionbar,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              // color: AppColors.c4Actionbar,
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }
}