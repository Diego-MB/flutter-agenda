import 'package:agenda/model/Contato.dart';
import 'package:agenda/util/ContatoHelper.dart';
import 'package:flutter/material.dart';
import 'package:asuka/asuka.dart' as asuka;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController txtNome = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtCelular = TextEditingController();  

  //Criando lista de contato
  List<Contato> listaDeContatos = List<Contato>();

  //Objeto que realiza operações no banco de dados
  ContatoHelper db = ContatoHelper();

  //Metodo para salvar no banco de dados
  void salvarContato({Contato contatoSelecionado}) async {
    
    int resultado;

    //Verifica se há contado
    //Se não houver realiza o cadastro
    if (contatoSelecionado == null) {
      Contato contato = Contato(txtNome.text, txtEmail.text, txtCelular.text);

      resultado = await db.inserirContato(contato);

      if (resultado != null) {
        // print("Cadastrado com sucesso!" + resultado.toString());
        showSnackBar("Cadastrado com sucesso!");                       
      } else {
        // print("Erro ao inserir contato!");
        showSnackBar("Erro ao inserir contato!");
      }
    } else {

      //Armazenar os dados do campos
      contatoSelecionado.nome = txtNome.text;
      contatoSelecionado.email = txtEmail.text;
      contatoSelecionado.celular = txtCelular.text;

      //chamar método editar
      resultado = await db.editarContato(contatoSelecionado);

      if (resultado != null) {
        // print("Editado com sucesso!" + resultado.toString());
        showSnackBar("Editado com sucesso!");
      } else {
        // print("Erro ao editar contato!");
        showSnackBar("Erro ao editar contato!");
      }

    }

    setState(() {      

      //Limpa os campos
      txtNome.clear();
      txtEmail.clear();
      txtCelular.clear();

      listaContatos();
    });
  }

  void showSnackBar(String msg) {
    asuka.showSnackBar(SnackBar(content: Text(msg)));
  }

  //Metodo lista contatos
  void listaContatos() async {
    List lista = await db.listarContatos();

    //Lista temporaria para guardar dados do tipo Map
    List<Contato> listaTemporaria = List<Contato>();

    //Convertendo dados do tipo Map para o model
    for (var item in lista) {
      Contato c = Contato.mapDados(item);

      listaTemporaria.add(c);
    }

    //Atualiza a lista
    setState(() {
      listaDeContatos = listaTemporaria;
    });

    //Limpa a lista temporaria
    listaTemporaria = null;
  }

  //Método para remover o contato
  void excluirContato(int id) async {

    int resultado = await db.excluirContato(id);

    listaContatos();

  }

  //Método confirmação de exclusão
  void exibirTelaConfirmar(int id) {

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Excluir contato"),
          content: Text("Você tem certeza que deseja excluir?"),
          backgroundColor: Colors.white,
          actions: [
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text("Sim"),
              onPressed: () {
                excluirContato(id);
                Navigator.pop(context);
              },
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );

  }


  void exibirTelaCadastro({Contato contato}) {
    String titulo = "";
    String botao = "";

    //Cadastrando um contato
    if (contato == null) {
      titulo = "Adicionar um Contado";
      botao = "Salvar";
    } else {
      titulo = "Editar um Contado";
      botao = "Editar";

      txtNome.text = contato.nome;
      txtEmail.text = contato.email;
      txtCelular.text = contato.celular;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtNome,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Nome",
                  hintText: "Digite o nome",
                ),
              ),
              TextField(
                controller: txtEmail,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "E-mail",
                  hintText: "Digite o e-mail",
                ),
              ),
              TextField(
                controller: txtCelular,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Celular",
                  hintText: "Digite o número de celular",
                ),
              ),
            ],
          ),
          actions: [
            FlatButton(
              child: Text(botao),
              onPressed: () {
                salvarContato(contatoSelecionado: contato);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    listaContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Contatos"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listaDeContatos.length,
              itemBuilder: (BuildContext context, int index) {
                final contato = listaDeContatos[index];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      size: 40,
                    ),
                    title: Text(contato.nome),
                    subtitle: Text(contato.celular),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            exibirTelaCadastro(contato: contato);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: 16,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            exibirTelaConfirmar(contato.id);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: 16,
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          exibirTelaCadastro();
        },
      ),
    );
  }
}
