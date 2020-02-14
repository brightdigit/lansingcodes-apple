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

extension Result where Success == Void {
  init(withError error: Failure?) {
    if let error = error {
      self = .failure(error)
    } else {
      self = .success(Void())
    }
  }
}
