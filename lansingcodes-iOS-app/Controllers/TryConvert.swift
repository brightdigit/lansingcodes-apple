

struct TryConvert {
  public static func fromStringOf<T>(_ object: Any, byConverting convert: (String) -> T?) -> T? {
    if let string = object as? String {
      return convert(string)
    }
    return nil
  }

  public static func fromStringOf<T>(_ object: Any?, byConverting convert: (String) -> T?) -> T? {
    if let string = object as? String {
      return convert(string)
    }
    return nil
  }
}
