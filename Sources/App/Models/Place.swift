import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class Place: SQLiteModel  {

    var id: Int?
    var name: String
    var adress: String?
    var description: String?

    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Place: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Place: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Place: Parameter { }
