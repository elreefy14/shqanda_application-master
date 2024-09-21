import 'package:get_storage/get_storage.dart';

class LocalStorage {
  // write to storage
  void saveLanguageToDisk(String language) async {
    await GetStorage().write('lang', language);
  }
  //Read from storage
  Future<String> get languageSelected async {
    return await GetStorage().read('lang');
  }
}
