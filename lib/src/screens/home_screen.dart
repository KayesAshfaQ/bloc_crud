import 'package:bloc_crud/src/blocs/user_list/user_list_bloc.dart';
import 'package:bloc_crud/src/models/user.dart';
import 'package:bloc_crud/src/screens/user_screen.dart';
import 'package:bloc_crud/src/uti/user_screen_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BlocBuilder<UserListBloc, UserListState>(
        bloc: BlocProvider.of<UserListBloc>(context),
        builder: (context, state) {
          /*UserListUpdated && */
          if (state.users.isNotEmpty) {
            final users = state.users;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return buildUserTile(context, users[index]);
              },
            );
          } else {
            return const Center(
              child: Text('No users found.'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserScreen(
                        action: UserScreenAction.create,
                      )));
        },
        tooltip: 'Create User',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListTile buildUserTile(
    BuildContext context,
    User user,
  ) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          BlocProvider.of<UserListBloc>(context).add(DeleteUser(user: user));
        },
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserScreen(
                      action: UserScreenAction.edit,
                      user: user,
                    )));
      },
    );
  }
}
