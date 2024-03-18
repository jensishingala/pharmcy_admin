import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constants.dart';
import 'package:grocery_app/firebase/firebase_service.dart';

import '../../model/category.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  Future<void> _showDeleteDialog(
      Category category, BuildContext context) async {
    var res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child:const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child:const Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (res) {
      await FirebaseService().deleteCategory(category.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Category List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: StreamBuilder<List<Category>>(
            stream: FirebaseService().categoryStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.redAccent,
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Category category = snapshot.data![index];
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppConstant.categoryView,
                                  arguments: snapshot.data![index]);
                            },
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blueAccent.shade100,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.network(
                                  category.imageUrl,
                                 // color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            title: Text(
                              category.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(category.description),
                            trailing: IconButton(
                              onPressed: () {
                                _showDeleteDialog(
                                    snapshot.data![index], context);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            /*isThreeLine: true,*/
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Text('No categories found'),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppConstant.categoryView);
        },
        backgroundColor: Colors.blueAccent.shade100,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
