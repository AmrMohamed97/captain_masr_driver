import 'package:flutter/material.dart';

const num uiWidth = 375;
const num uiHeight = 812;

extension ResponsiveUI on num {
  rW(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return MediaQuery.of(context).size.width * (this / uiWidth);
    } else {
      return MediaQuery.of(context).size.width * (this / uiHeight);
    }
  }

  rH(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return MediaQuery.of(context).size.height * (this / uiHeight);
    } else {
      return MediaQuery.of(context).size.height * (this / uiWidth);
    }
  }

  rT(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return MediaQuery.of(context).size.height * (this / uiHeight);
    } else {
      return MediaQuery.of(context).size.height * (this / uiWidth);
    }
  }
}
