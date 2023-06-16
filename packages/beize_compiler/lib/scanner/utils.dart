class BeizeStringBuffer {
  BeizeStringBuffer([final String? content])
      : _buffer = StringBuffer(content ?? '');

  final StringBuffer _buffer;

  void write(final String value) {
    _buffer.write(value);
  }

  @override
  String toString() => _buffer.toString();
}
