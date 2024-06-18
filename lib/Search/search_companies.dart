import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_finder_flutter/Widgets/all_companies_widget.dart';
import 'package:job_finder_flutter/Widgets/bottom_nav_bar.dart';

class AllWorkersScreen extends StatefulWidget {
  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Search query';

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Buscar empresas/personas....',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          _clearSearchQuery();
        },
      ),
    ];
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade300, Colors.blueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBarForApp(
            indexNum: 1,
          ),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepOrange.shade300, Colors.blueAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.2, 0.9],
                ),
              ),
            ),
            automaticallyImplyLeading: false,
            title: _buildSearchField(),
            actions: _buildActions(),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Filtrar los datos solo si searchQuery no está vacío
                if (snapshot.data!.docs.isNotEmpty) {
                  var filteredDocs = snapshot.data!.docs.where((doc) {
                    if (searchQuery.isNotEmpty &&
                        searchQuery != "Search query") {
                      // Aquí puedes ajustar la lógica de filtrado según tus necesidades
                      return doc['name']
                          .toString()
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                    } else {
                      // Si searchQuery está vacío, devolver true para incluir todos los documentos
                      return true;
                    }
                  }).toList();

                  if (filteredDocs.isNotEmpty) {
                    return ListView.builder(
                      itemCount: filteredDocs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AllWorkersWidget(
                          userID: filteredDocs[index]['id'],
                          userName: filteredDocs[index]['name'],
                          userEmail: filteredDocs[index]['email'],
                          phoneNumber: filteredDocs[index]['phoneNumber'],
                          userImageUrl: filteredDocs[index]['userImage'],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No se encontraron usuarios'),
                    );
                  }
                } else {
                  return const Center(
                    child: Text('No hay usuarios disponibles'),
                  );
                }
              } else {
                return const Center(
                  child: Text(
                    'Algo salió mal :(',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                );
              }
            },
          )),
    );
  }
}
