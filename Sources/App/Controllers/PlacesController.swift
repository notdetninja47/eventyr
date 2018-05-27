import Vapor

class PlacesController {
    
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
    
}




/*
/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            return todo.create(on: req)
        }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
}
*/
