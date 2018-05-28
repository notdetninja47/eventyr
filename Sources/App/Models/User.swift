import Foundation
import FluentMySQL
import Vapor
import Authentication

final class User: Codable {
  var id: UUID?
  var name: String
  var email: String
  var password: String
    
  init(name: String, email: String, password: String) {
    self.name = name
    self.email = email
    self.password = password
  }
}

extension User: MySQLUUIDModel {}
extension User: Migration {}
extension User: Content {}

extension User {
  var places: Children<User, Place> {
    return children(\.userId)
  }
}

extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \User.email
    static let passwordKey: PasswordKey = \User.password
}

extension User: TokenAuthenticatable {
    typealias TokenType = Token
}
