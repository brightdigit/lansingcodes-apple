

struct MissingDocumentFieldError: Error {
  let fieldName: String

  var localizedDescription: String {
    return "missing field \(fieldName)"
  }
}
