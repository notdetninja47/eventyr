import FluentMySQL
import Vapor

/// A single entry of a Todo list.
final class ARObject: SQLiteModel  {
    
    var id: Int?
    var zoneId: Zone.ID
    var name: String
    
    /*
     1 - static
     2 - video
     3 - model
     4 - interactive
     */
    var holderNodeName: String
    var typeNumber: Int
    var parentObjectId: ARObject.ID?
    
    var contentURL: String
    
    var urlToOpen: String?
    
    
    
    init(id: Int? = nil, name: String,
         zoneId: Place.ID, holderNodeName: String,
         typeNumber: Int, parentObjectId: ARObject.ID? = nil,
         contentURL: String, urlToOpen: String? = nil) {
        
        self.id = id
        self.name = name
        
        self.zoneId = zoneId
        self.holderNodeName = holderNodeName
        self.typeNumber = typeNumber
        
        self.parentObjectId = parentObjectId
        
        self.contentURL = contentURL
        self.urlToOpen = urlToOpen
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension ARObject: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension ARObject: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension ARObject: Parameter { }

// Convienience method for retrieving parent
extension ARObject {
    var zone: Parent<ARObject, Zone> {
        return parent(\.zoneId)
    }
}

// Convienience method for retrieving parent
extension ARObject {
    var parentObject: Parent<ARObject, ARObject>? {
        return parent(\.parentObjectId)
    }
}

extension ARObject {
    var childObjects: Children<ARObject, ARObject> {
        return children(\.parentObjectId)
    }
}

