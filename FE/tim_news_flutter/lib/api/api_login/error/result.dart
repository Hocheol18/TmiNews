class Result<T, E> {
  final T? _value;
  final E? _error;
  final bool isSuccess;

  Result._({T? value, E? error, required this.isSuccess})
      : _value = value,
        _error = error;

  factory Result.success(T value) => Result._(value: value, isSuccess: true);
  factory Result.failure(E error) => Result._(error: error, isSuccess: false);

  T get value => _value as T;
  E get error => _error as E;
}