import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let placesController = PlacesController()
    try router.register(collection: placesController)
    
    let zonesController = ZonesController()
    try router.register(collection: zonesController)
    
    let arObjectsController = ARObjectsController()
    try router.register(collection: arObjectsController)
    
    let usersController = UsersController()
    try router.register(collection: usersController)
}
