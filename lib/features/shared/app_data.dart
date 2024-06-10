class AppData {
  static final _appData = new AppData._internal();

  

  factory AppData(){
    return _appData;
  }

  AppData._internal();
}

final _appData = AppData();