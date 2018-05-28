import FluentMySQL
import Vapor
import Authentication


/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentMySQLProvider())

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    try services.register(AuthenticationProvider())

    // Configure a SQLite database
    let mysqlConfig = MySQLDatabaseConfig(
        hostname: "$DATABASE_HOSTNAME",
        username: "$DATABASE_USER",
        password: "$DATABASE_PASSWORD",
        database: "$DATABASE_DB"
    )
    services.register(mysqlConfig)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Place.self, database: .mysql)
    migrations.add(model: Zone.self, database: .mysql)
    migrations.add(model: ARObject.self, database: .mysql)
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Token.self, database: .mysql)
    migrations.add(model: User.self, database: .mysql)

    services.register(migrations)

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
}
