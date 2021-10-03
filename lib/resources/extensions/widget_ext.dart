import 'dart:math';
import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notifications/domain/services/auth_service/user_auth_service.dart';
import 'package:notifications/export.dart';
import 'package:flash/flash.dart';
import 'package:notifications/ui/widgets/screen_sizer.dart';

BuildContext getCtx(BuildContext c) => c;

// extension ErrorMsgSnackBarExtension on BuildContext {
//   void showDefaultErrorMsg<Type>(UserAuthService service, Type type) {
//     if (service.errorMsg != null && (type == service.authType))
//       this.showErrorBar(
//           content: Text(
//         service.errorMsg!,
//         style: TextStyle(fontSize: 14.sp),
//       ));
//   }
// }

extension SizerExtension on BuildContext {
  ///MediaQueryData
  MediaQueryData get mQuery => MediaQuery.of(this);
  double get safeArea => mQuery.padding.top + (mQuery.padding.bottom);

  ///Returns full height of a device
  double fH([double value = 1]) =>
      value * (mQuery.size.height) -
      (orientation == Orientation.portrait ? safeArea : 0);

  ///Returns full width of a device
  double fW([double value = 1]) => value * mQuery.size.width;

  ///Returns a block width of a device totalWidth/100
  double w([double value = 1]) => value * (mQuery.size.width / 100);

  ///Returns a block height of a device totalHeight/100
  double h([double value = 1]) => value * (mQuery.size.height / 100);
  double deviceRatio([double value = 1]) => value * mQuery.devicePixelRatio;

  Size setDefaultSize([double? h, double? w]) => Size(w ?? 375, h ?? 812);

  T ifOrientation<T>(T portraitValue, T landScapeValue) {
    if (orientation == Orientation.portrait) return portraitValue;
    return landScapeValue;
  }

  ///Returns a pixel ratio of height/width
  double px([double value = 1]) {
    final _max = max(mQuery.size.width, mQuery.size.height);
    final _min = min(mQuery.size.width, mQuery.size.height);
    //final ratio = (_max / _min);
    //debugPrint("Sizes: ${_max / _min} ${devicePixelRatio}");
    final ratio = mQuery.orientation == Orientation.portrait ? w() : h();
    return value * ratio; //ratio;
  }

  double factorSize([double value = 1]) {
    final ratio = mQuery.orientation == Orientation.portrait ? w() : h();
    //   ? mQuery.size.height / mQuery.size.width
    //  : mQuery.size.width / mQuery.size.height;
    return value * ratio;
  }

  double sqSize([double value = 1]) {
    final sq = orientation == Orientation.portrait ? w() : h();
    return value * sq;
  }
}

// extension SizerValues on num {
//   BuildContext? get _ctx => SizerContext.ctx;

  

//   ///Returns a pixel ratio of height/width
//   double get px {
//     final ratio = _ctx!.orientation == Orientation.portrait
//         ? MediaQuery.of(_ctx!).size.height / MediaQuery.of(_ctx!).size.width
//         : MediaQuery.of(_ctx!).size.width / MediaQuery.of(_ctx!).size.height;
    
//     return this * (ratio / _ctx!.devicePixelRatio);
//   }

//   //Block Width
//   double get bw => this * _ctx!.bw;
//   //Block Height
//   double get bh => this * _ctx!.bh;
//   //Multiples of Device Height
//   double get height => _ctx!.orientation == Orientation.portrait
//       ? this * MediaQuery.of(_ctx!).size.height
//       : this * MediaQuery.of(_ctx!).size.height;
//   //Multiples of Device Width
//   double get width => this * MediaQuery.of(_ctx!).size.width;
// }
