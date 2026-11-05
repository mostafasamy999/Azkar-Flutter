import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/colors.dart';
import '../../domain/entities/DailyPrayerTimes.dart';
import '../bloc/PrayerTimesScreenCubit.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<PrayerTimesScreenCubit>()..load(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text(
                'مواقيت الصلاة',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.my_location),
                  tooltip: 'تحديث الموقع',
                  onPressed: () => context.read<PrayerTimesScreenCubit>().load(),
                ),
              ],
            ),
            body: BlocBuilder<PrayerTimesScreenCubit, PrayerTimesScreenState>(
              builder: (context, state) => switch (state) {
                PrayerTimesScreenLoading() => const _Loading(),
                PrayerTimesScreenError(:final message) => _ErrorView(message: message),
                PrayerTimesScreenLoaded(:final times) => RefreshIndicator(
                    onRefresh: () => context.read<PrayerTimesScreenCubit>().load(),
                    child: _PrayerTimesBody(times: times),
                  ),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text('جاري تحديد موقعك...', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  bool get _isPermission => message.contains('إذن الموقع');
  bool get _isServiceOff => message.contains('خدمات الموقع');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isPermission || _isServiceOff ? Icons.location_off : Icons.cloud_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'نحتاج موقعك لحساب مواقيت الصلاة بدقة لمدينتك',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () => context.read<PrayerTimesScreenCubit>().load(),
              icon: const Icon(Icons.refresh),
              label: const Text('حاول مرة اخرى'),
            ),
            if (_isPermission || _isServiceOff) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _isServiceOff
                    ? Geolocator.openLocationSettings()
                    : Geolocator.openAppSettings(),
                child: const Text('فتح الإعدادات', style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PrayerTimesBody extends StatefulWidget {
  final DailyPrayerTimes times;
  const _PrayerTimesBody({required this.times});

  @override
  State<_PrayerTimesBody> createState() => _PrayerTimesBodyState();
}

class _PrayerTimesBodyState extends State<_PrayerTimesBody> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final times = widget.times;
    final next = times.nextPrayer(_now);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        _NextPrayerCard(times: times, next: next, remaining: next.time.difference(_now)),
        const SizedBox(height: 16),
        ...times.slots.map((slot) => _PrayerRow(slot: slot, isNext: slot.key == next.key && slot.isPrayer)),
        const SizedBox(height: 12),
        if (times.methodName.isNotEmpty)
          Text(
            'طريقة الحساب: ${times.methodName}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        if (times.fromCache)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'تم عرض آخر مواقيت محفوظة لعدم توفر الاتصال',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
      ],
    );
  }
}

class _NextPrayerCard extends StatelessWidget {
  final DailyPrayerTimes times;
  final PrayerSlot next;
  final Duration remaining;

  const _NextPrayerCard({required this.times, required this.next, required this.remaining});

  String _fmt(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryLight, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          if (times.placeName != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 18),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    times.placeName!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 6),
          Text(times.hijriDate, style: const TextStyle(color: Colors.white, fontSize: 16)),
          Text(times.gregorianDate,
              textDirection: TextDirection.ltr,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const Divider(color: Colors.white24, height: 28),
          Text('الصلاة القادمة: ${next.nameAr}',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            _fmt(remaining),
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.bold,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const Text('متبقي', style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  final PrayerSlot slot;
  final bool isNext;

  const _PrayerRow({required this.slot, required this.isNext});

  static const _icons = {
    'Fajr': Icons.nights_stay_outlined,
    'Sunrise': Icons.wb_twilight,
    'Dhuhr': Icons.wb_sunny,
    'Asr': Icons.wb_sunny_outlined,
    'Maghrib': Icons.wb_twighlight,
    'Isha': Icons.dark_mode_outlined,
  };

  String _time12(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m ${t.hour < 12 ? 'ص' : 'م'}';
  }

  @override
  Widget build(BuildContext context) {
    final fg = isNext ? Colors.white : AppColors.textPrimary;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isNext ? AppColors.primary : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(_icons[slot.key] ?? Icons.access_time,
              color: isNext ? Colors.white : AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              slot.nameAr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: slot.isPrayer ? FontWeight.bold : FontWeight.normal,
                color: slot.isPrayer ? fg : (isNext ? Colors.white70 : AppColors.textSecondary),
              ),
            ),
          ),
          Text(
            _time12(slot.time),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: fg),
          ),
        ],
      ),
    );
  }
}
