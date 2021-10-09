
import 'package:notifications/export.dart';




extension SizerExtension on BuildContext {
  ///MediaQueryData
  MediaQueryData get mQuery => MediaQuery.of(this);
  double get safeArea => mQuery.padding.top + (mQuery.padding.bottom);

  ///Returns full height of a device
  double fH([double value = 1]) => value * (mQuery.size.height) - safeArea;

  ///Returns full width of a device
  double fW([double value = 1]) => value * mQuery.size.width;

  ///Returns a block width of a device totalWidth/100
  double w([double value = 1]) => value * (mQuery.size.width / 100);

  ///Returns a block height of a device totalHeight/100
  double h([double value = 1]) => value * (mQuery.size.height / 100);

  T ifOrientation<T>(T portraitValue, T landScapeValue) {
    if (orientation == Orientation.portrait) return portraitValue;
    return landScapeValue;
  }

  ///Returns a pixel ratio of height/width
  double px([double value = 1]) {
    
    
    
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

  bool get isMobile => fW() > 313 && fW() < 768;
  //bool get isTablet => fW() >= 768 && fW() < 1024;
  bool get isDesktop => fW() > 1024;
}
