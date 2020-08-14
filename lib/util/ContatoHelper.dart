import 'dart:io';

import 'package:agenda/model/Contato.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ContatoHelper {

  //Estrutura da tabela
  String nomeTabela = "tb_contato";
  String colId = "id";
  String colNome = "nome";
  String colEmail = "email";
  String colCelular = "celular";

  //Conectar ao banco de dados

  static ContatoHelper _databaseHelper;
  static Database _database;

  ContatoHelper._createInstace();

  factory ContatoHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = ContatoHelper._createInstace();      
    }

    return _databaseHelper;
  }

  //Método que cria a tabela no banco de dados
  void _criaBanco(Database db, int versao) async {
    await db.execute('CREATE TABLE $nomeTabela ('
    '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
    '$colNome Text, '
    '$colEmail Text, '
    '$colCelular Text)'
    );

  }

  //Verifica se banco foi inicializado
  Future<Database> get database async {
    if (_database == null) {
      _database = await inicializaBanco();      
    }

    return _database;
  }

  Future<Database> inicializaBanco() async {

    //Pega o caminho dos Android ou Ios para salvar o banco de dados
    Directory diretorio = await getApplicationDocumentsDirectory();
    String caminho = diretorio.path + 'bdcontatos.bd';

    var bancoDeDados = await openDatabase(caminho, version: 1, onCreate: _criaBanco);

    return bancoDeDados;
  }

  
  

  //Método CRUD da tabela

  //Método cadastro
  Future<int> inserirContato(Contato contato) async {

    // Seleciona o banco de dados
    Database db = await this.database;

    var resultado = await db.insert(nomeTabela, contato.toMap());

    return resultado;
  }

  //Método lista
  listarContatos() async {

    // Seleciona o banco de dados
    Database db = await this.database;

    //Monta a query a ser executada
    String sql = "SELECT * FROM $nomeTabela";

    List lista = await db.rawQuery(sql);

    return lista;
  }

  //Método edita
  Future<int> editarContato(Contato contato) async {

    // Selecione o banco de dados
    Database db = await this.database;

    var resultado =  await db.update(nomeTabela, contato.toMap(), where: "id = ?", whereArgs: [contato.id]);

    return resultado;
  }


  //Método excluir
  Future<int> excluirContato(int id) async {

    // Selecionar a base de dados
    Database db = await this.database;

    var resultado = await db.delete(nomeTabela, where: "id = ?", whereArgs: [id]);

    return resultado;
  }

}
