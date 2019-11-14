

extension Result {
  init(_ data: Success?, withError error: Failure?, defaultError: Failure) {
    if let data = data {
      self = .success(data)
    } else {
      self = .failure(error ?? defaultError)
    }
  }

  var error: Failure? {
    if case let .failure(error) = self {
      return error
    } else {
      return nil
    }
  }
}
