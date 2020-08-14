class Contato {

  int _id;
  String _nome;
  String _email;
  String _celular;

  Contato(this._nome, this._email, this._celular);

  int get id => (_id);
  set id(int value) => _id = value;

  String get nome => (_nome);
  set nome(String value) => _nome = value;

  String get email => (_email);
  set email(String value) => _email = value;

  String get celular => (_celular);
  set celular(String value) => _celular = value;

  // Método para converter de model para Map
  Map<String, dynamic> toMap() {

    //Cria o map
    var dadosMap = Map<String, dynamic>();

    dadosMap['id'] = _id;
    dadosMap['nome'] = _nome;
    dadosMap['email'] = _email;
    dadosMap['celular'] = _celular;

    return dadosMap;
  }

  // Método para converter de Map para Model
  Contato.mapDados(Map<String, dynamic>map){
    this._id = map['id'];
    this._nome = map['nome'];
    this._email = map['email'];
    this._celular = map['celular'];
  }

  // https://www.youtube.com/watch?v=kWkSrvmx5MA&list=PL69eBMqNvxhVTQ9XcnG-21BnOqWZDdCVt&index=23

}
