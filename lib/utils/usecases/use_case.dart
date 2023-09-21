

abstract class UseCase<Type, Parameter> {
  Future<Type> call([Parameter parameter]);
}

class NoParameter {}