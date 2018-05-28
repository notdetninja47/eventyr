import Vapor

class PlacesController: RouteCollection {
    
    func boot(router: Router) throws {
        let route = router.grouped("api", "places")
        route.get   (Place.parameter, use: get)
        route.get   (use: getAll)
        route.get   (Place.parameter, "zones", use: getZones)
        
        route.post  (use: create)
        route.put   (Place.parameter, use: update)
        route.delete(Place.parameter, use: delete)
    }
    
    func getAll(_ req: Request) throws -> Future<[Place]> {
        return Place.query(on: req).all()
    }
    
    func get(_ req: Request) throws -> Future<Place> {
        return try req.parameters.next(Place.self)
    }
    
    func create(_ req: Request) throws -> Future<Place> {
        return try req.content.decode(Place.self).save(on: req)
    }
    
    func update(_ req: Request) throws -> Future<Place> {
        return try flatMap(to: Place.self, req.parameters.next(Place.self), req.content.decode(Place.self), { place, updatedPlace in
            place.name = updatedPlace.name
            place.adress = updatedPlace.adress
            place.description = updatedPlace.description
            
            return place.save(on: req)
        })
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Place.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
    
    func getZones(_ req: Request) throws -> Future<[Zone]> {
        return try req.parameters.next(Place.self).flatMap(to: [Zone].self) { place in
            return try place.zones.query(on: req).all()
        }
    }
    
}
