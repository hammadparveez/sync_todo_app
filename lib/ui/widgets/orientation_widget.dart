import "package:notifications/export.dart";

class OrientationWidget extends StatelessWidget {

  const OrientationWidget(
      {Key? key,
      this.portrait,
      this.landsacpe,
      this.showLandInPortrait = false,
      this.showPortraitInLand = false})
      : super(key: key);


  ///Widget for [Orientation.portrait]
  final Widget? portrait;
  
  ///Widget for [Orientation.landscape]
  final Widget? landsacpe;

  ///When [portrait] is null, and [showLandInPortrait] is true, It will show
  ///[landsacpe] when is [Orientation.Portrait] else [SizedBox]
  final bool showLandInPortrait;

  ///When [landsacpe] is null, and [showPortraitInLand] is true, It will show
  ///[portrait] when is [Orientation.landscape] else [SizedBox]
  final bool showPortraitInLand;



  @override
  Widget build(BuildContext context) {
    Widget? widget;
    if (context.orientation == Orientation.portrait) {
      widget = portrait ?? (this.showLandInPortrait ? landsacpe : null);
    } else {
      widget = landsacpe ?? (this.showPortraitInLand ? landsacpe : null);
    }

    return widget ?? const SizedBox();
  }
}
