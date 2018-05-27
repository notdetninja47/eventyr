import Vapor

class ZonesController: RouteCollection {
    
    func boot(router: Router) throws {
        let route = router.grouped("api", "zones")
        route.get   (Zone.parameter, use: get)
        route.get   (use: getAll)
        route.post  (use: create)
        route.put   (Zone.parameter, use: update)
        route.delete(Zone.parameter, use: delete)
        route.get   (Zone.parameter, "place", use: getPlace)
    }
    
    func getAll(_ req: Request) throws -> Future<[Zone]> {
        return Zone.query(on: req).all()
    }
    
    func get(_ req: Request) throws -> Future<Zone> {
        return try req.parameters.next(Zone.self)
    }
    
    func create(_ req: Request) throws -> Future<Zone> {
        return try req.content.decode(Zone.self).save(on: req)
    }
    
    func update(_ req: Request) throws -> Future<Zone> {
        return try flatMap(to: Zone.self, req.parameters.next(Zone.self), req.content.decode(Zone.self), { Zone, updatedZone in
            Zone.name = updatedZone.name
            Zone.placeId = updatedZone.placeId
            
            return Zone.save(on: req)
        })
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Zone.self).flatMap { todo in
            return todo.delete(on: req)
            }.transform(to: .ok)
    }
    
    func getPlace(_ req: Request) throws -> Future<Place> {
        return try req.parameters.next(Zone.self).flatMap(to: Place.self) { zone in
            return try zone.place.get(on: req)
        }
    }
    
}
