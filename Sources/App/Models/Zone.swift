import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class Zone: SQLiteModel  {
    
    var id: Int?
    var placeId: Place.ID
    var name: String
    
    init(id: Int? = nil, name: String, placeId: Place.ID) {
        self.id = id
        self.name = name
        self.placeId = placeId
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Zone: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Zone: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Zone: Parameter { }

// Convienience method for retrieving parent
extension Zone {
    var place: Parent<Zone, Place> {
        return parent(\.placeId)
    }
}
