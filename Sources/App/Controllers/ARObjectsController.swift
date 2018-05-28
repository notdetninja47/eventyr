import Vapor

class ARObjectsController: RouteCollection {
    
    func boot(router: Router) throws {
        let route = router.grouped("api", "ARObjects")
        
        route.get   (ARObject.parameter, use: self.get)
        route.get   (use: self.getAll)
        route.post  (use: self.create)
        route.put   (ARObject.parameter, use: self.update)
        route.delete(ARObject.parameter, use: self.delete)
        
        route.get   (ARObject.parameter, "place", use: getZone)
        route.get   (ARObject.parameter, "childObjects", use: getChildObjects)
    }
    
    func getAll(_ req: Request) throws -> Future<[ARObject]> {
        return ARObject.query(on: req).all()
    }
    
    func get(_ req: Request) throws -> Future<ARObject> {
        return try req.parameters.next(ARObject.self)
    }
    
    func create(_ req: Request) throws -> Future<ARObject> {
        return try req.content.decode(ARObject.self).save(on: req)
    }
    
    func update(_ req: Request) throws -> Future<ARObject> {
        return try flatMap(to: ARObject.self, req.parameters.next(ARObject.self), req.content.decode(ARObject.self), { arObject, updatedARObject in
            
            arObject.id             = updatedARObject.id
            arObject.name           = updatedARObject.name
            
            arObject.zoneId         = updatedARObject.zoneId
            arObject.holderNodeName = updatedARObject.holderNodeName
            arObject.typeNumber     = updatedARObject.typeNumber
            
            arObject.parentObjectId = updatedARObject.parentObjectId
            
            arObject.contentUrl     = updatedARObject.contentUrl
            arObject.urlToOpen      = updatedARObject.urlToOpen
            
            return arObject.save(on: req)
        })
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(ARObject.self).flatMap { todo in
            return todo.delete(on: req)
            }.transform(to: .ok)
    }
    
    func getZone(_ req: Request) throws -> Future<Zone> {
        return try req.parameters.next(ARObject.self).flatMap(to: Zone.self) { ARObject in
            return try ARObject.zone.get(on: req)
        }
    }
    
    func getChildObjects(_ req: Request) throws -> Future<Zone> {
        return try req.parameters.next(ARObject.self).flatMap(to: Zone.self) { ARObject in
            return try ARObject.zone.get(on: req)
        }
    }
    
}
