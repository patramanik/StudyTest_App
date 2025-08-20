String getCurrentScreen({required screenSize}) {
  String currentScreen = screenSize < 500
      ? 'xsmall'
      : screenSize < 799 && screenSize > 499
      ? "small"
      : screenSize > 799 && screenSize < 900
      ? 'medium'
      : 'big';

  return currentScreen;
}

// String getCurrentScreen2({required double screenSize}) {
//   if (screenSize < 500) return 'mob'; // mobile
//   if (screenSize < 700) return 'tab'; // tablet
//   if (screenSize < 1024) return 'desk'; // small desktop
//   return 'big'; // large desktop
// }
