import Vapor
import Crypto
import Authentication

struct UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoutes = router.grouped("api", "users")
        usersRoutes.post(use: create)
        usersRoutes.get(use: getAll)
        usersRoutes.get(User.Public.parameter, use: get)
        usersRoutes.get(User.parameter, "places", use: getPlaces)
        
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let basicAuthGroup = usersRoutes.grouped(basicAuthMiddleware)
        basicAuthGroup.post("login", use: loginHandler)
    }
    
    func create(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap(to: User.self) { user in
            let hasher = try req.make(BCryptDigest.self)
            user.password = try hasher.hash(user.password)
            return user.save(on: req)
        }
    }
    
    func getAll(_ req: Request) throws -> Future<[User.Public]> {
        return User.Public.query(on: req).all()
    }
    
    func get(_ req: Request) throws -> Future<User.Public> {
        return try req.parameters.next(User.Public.self)
    }
    
    func getPlaces(_ req: Request) throws -> Future<[Place]> {
        return try req.parameters.next(User.self).flatMap(to: [Place].self){ user in
            return try user.places.query(on: req).all()
        }
    }
    func loginHandler(_ req: Request) throws -> Future<Token> {
        let user = try req.requireAuthenticated(User.self)
        let token = try Token.generate(for: user)
        return token.save(on: req)
    }
}

extension User: Parameter {}
extension User.Public: Parameter {}

