import FluentMySQL
import Vapor

/// A single entry of a Todo list.
final class Place: MySQLModel  {

    var id: Int?
    var name: String
    var adress: String?
    var description: String?
    var userId: User.ID
    
    init(id: Int? = nil, name: String, adress: String? = nil, description: String? = nil, userId: User.ID) {
        self.name = name
        self.adress = adress
        self.description = description
        self.userId = userId
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Place: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Place: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Place: Parameter { }

extension Place {
    var zones: Children<Place, Zone> {
        return children(\.placeId)
    }
}
