//login
class UserNotFoundAuthEception implements Exception {}

class WrongPasswordAuthEception implements Exception {}

//register
class WeakPasswordAuthEception implements Exception {}

class PasswordIsTooShortAuthException implements Exception {}

class EmailAlreadyInUseAuthEception implements Exception {}

class InvalidEmailAuthEception implements Exception {}

//generic
class GenericAuthEception implements Exception {}

class UserNotLoggedInAuthEception implements Exception {}

class NotManifestLoadException implements Exception {}
