import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import '../models/echo_response.dart';

enum EchoState { idle, loading, success, error }

class EchoService extends ChangeNotifier {
  EchoState _state = EchoState.idle;
  EchoResponse? _response;
  String? _errorMessage;

  EchoState get state => _state;
  EchoResponse? get response => _response;
  String? get errorMessage => _errorMessage;

  late final FirebaseFunctions _functions;

  EchoService() {
    _functions = FirebaseFunctions.instance;
    if (kDebugMode) {
      _functions.useFunctionsEmulator('localhost', 5001);
    }
  }

  Future<void> submitEcho(String userInput) async {
    if (userInput.trim().isEmpty) return;

    _state = EchoState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final HttpsCallable callable = _functions.httpsCallable('processEcho');
      final result = await callable.call(<String, dynamic>{
        'userInput': userInput,
      });

      final data = Map<String, dynamic>.from(result.data);
      _response = EchoResponse.fromMap(data);
      _state = EchoState.success;
    } on FirebaseFunctionsException catch (e) {
      _errorMessage = e.message ?? 'An unknown error occurred in the ether.';
      _state = EchoState.error;
    } catch (e) {
      _errorMessage = 'Lost signal. Please try again.';
      _state = EchoState.error;
    } finally {
      notifyListeners();
    }
  }

  void reset() {
    _state = EchoState.idle;
    _response = null;
    _errorMessage = null;
    notifyListeners();
  }
}
