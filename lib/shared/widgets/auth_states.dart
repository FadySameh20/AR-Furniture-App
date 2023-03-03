abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthSuccessfullyState extends AuthStates {}

class AuthErrorState extends AuthStates {}

class WeakPasswordState extends AuthStates {}

class EmailAlreadyInUse extends AuthStates {}