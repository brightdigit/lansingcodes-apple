import Foundation

public struct LCGeocodedEvent: Identifiable {
  public var id: String {
    return event.id
  }

  let event: LCEvent
  let coordinate: Coordinate?
}
