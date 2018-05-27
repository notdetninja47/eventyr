import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    // MARK: Places
    let placesController = PlacesController()
    let placesRoute = "places"
    
    router.get   (placesRoute, Place.parameter, use: placesController.getAll)
    router.get   (placesRoute, use: placesController.getAll)
    router.post  (placesRoute, use: placesController.create)
    router.put   (placesRoute, Place.parameter, use: placesController.update)
    router.delete(placesRoute, Place.parameter, use: placesController.delete)
    
    
}
