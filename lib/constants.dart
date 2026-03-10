import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color weatherCardTitleColor = Color(0xFF998FAA);
const Color weatherCardBorderColor  = Color(0xFF6B3FB5);
const LinearGradient weatherCardBackgroundColor  = LinearGradient(
  colors: [Color(0xFF2B1C49),Color(0xFF321E56),Color(0xFF37215D)],
  stops: [0.0, 0.5, 1.0],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

const LinearGradient draggableScrollableBackgroundColor  = LinearGradient(
  colors: [Color(0xFF271F45),Color(0xFF452976),Color(0xFF4E2C80)],
  stops: [0.0, 0.5, 1.0],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

const LinearGradient topBackgroundColor  = LinearGradient(
  colors: [Color(0xFF271F45),Color(0xFF452976),Color(0xFF4E2C80)],
  stops: [0.0, 0.5, 1.0],
  end: Alignment.bottomCenter,
  begin: Alignment.topCenter,
);

const LinearGradient forecastBackgroundColor  = LinearGradient(
  colors: [Color(0xFF4B2C85),Color(0xFF4E2D8B),Color(0xFF4E2D8B)],
  stops: [0.0, 0.5, 1.0],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

const LinearGradient searchBackgroundColor  = LinearGradient(
  colors: [Color(0xFF0D57AB),Color(0xFFC7E5F0)],
  stops: [0.0, 0.06,],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);


TextStyle cityStyle = TextStyle(
  fontSize: 35.sp,
  color: Colors.white,
  height: 1,
);

TextStyle temperatureStyle = TextStyle(
  fontSize: 96.sp,
  color: Colors.white,
  height: 1,
);

TextStyle conditionStyle = TextStyle(
  fontSize: 20.sp,
  color: Colors.grey,
  height: 1,
);

