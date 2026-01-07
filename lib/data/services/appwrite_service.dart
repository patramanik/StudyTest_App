import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:get/get.dart';
import '../../config/environment.dart';

class AppwriteService extends GetxService {
  late Client client;
  late Account account;

  @override
  void onInit() {
    super.onInit();
    client = Client()
        .setEndpoint(Environment.appwritePublicEndpoint)
        .setProject(Environment.appwriteProjectId)
        .setSelfSigned(status: true); // For self-signed certificates, only use in dev
    account = Account(client);
  }

  Future<models.User> signUp({required String email, required String password, required String name}) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<models.Session> login({required String email, required String password}) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return session;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } catch (e) {
      rethrow;
    }
  }

  Future<models.User?> getCurrentUser() async {
    try {
      final user = await account.get();
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<models.User> updateName({required String name}) async {
    try {
      return await account.updateName(name: name);
    } catch (e) {
      rethrow;
    }
  }

  Future<models.User> updatePhone({required String phone, required String password}) async {
    try {
      return await account.updatePhone(phone: phone, password: password);
    } catch (e) {
      rethrow;
    }
  }
}
