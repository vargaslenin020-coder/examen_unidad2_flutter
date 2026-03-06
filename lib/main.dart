import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'person_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro SQLite',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ListadoScreen(),
    );
  }
}

// --- 1. PANTALLA DE LISTADO ---
class ListadoScreen extends StatefulWidget {
  const ListadoScreen({super.key});
  @override
  State<ListadoScreen> createState() => _ListadoScreenState();
}

class _ListadoScreenState extends State<ListadoScreen> {
  List<Person> personas = [];

  void _refresh() async {
    final data = await DatabaseHelper().getAll();
    setState(() => personas = data);
  }

  @override
  void initState() { super.initState(); _refresh(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Personas")),
      body: ListView.builder(
        itemCount: personas.length,
        itemBuilder: (context, i) => ListTile(
          title: Text("${personas[i].nombre} ${personas[i].apellido}"),
          subtitle: Text("Cédula: ${personas[i].cedula}"),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DetalleScreen(person: personas[i]))).then((_) => _refresh()),
          trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
            await DatabaseHelper().delete(personas[i].id!);
            _refresh();
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RegistroScreen())).then((_) => _refresh()),
      ),
    );
  }
}

// --- 2. PANTALLA DE REGISTRO ---
class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});
  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _n = TextEditingController(), _a = TextEditingController(), _ce = TextEditingController(), _ed = TextEditingController(), _ci = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _n, decoration: const InputDecoration(labelText: "Nombre")),
              TextFormField(controller: _a, decoration: const InputDecoration(labelText: "Apellido")),
              TextFormField(
                controller: _ce, 
                decoration: const InputDecoration(labelText: "Cédula"),
                validator: (v) => v!.length != 10 ? "Debe tener 10 dígitos" : null,
              ),
              TextFormField(controller: _ed, decoration: const InputDecoration(labelText: "Edad"), keyboardType: TextInputType.number),
              TextFormField(controller: _ci, decoration: const InputDecoration(labelText: "Ciudad")),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await DatabaseHelper().insert(Person(nombre: _n.text, apellido: _a.text, cedula: _ce.text, edad: int.parse(_ed.text), ciudad: _ci.text));
                  Navigator.pop(context);
                }
              }, child: const Text("Guardar Registro"))
            ],
          ),
        ),
      ),
    );
  }
}

// --- 3. PANTALLA DE DETALLE ---
class DetalleScreen extends StatelessWidget {
  final Person person;
  const DetalleScreen({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nombre Completo: ${person.nombre} ${person.apellido}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Text("Cédula: ${person.cedula}"),
            Text("Edad: ${person.edad} años"),
            Text("Ciudad: ${person.ciudad}"),
          ],
        ),
      ),
    );
  }
}