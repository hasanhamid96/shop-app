
class HttpExecption implements Exception{

  final String message;

  HttpExecption(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}