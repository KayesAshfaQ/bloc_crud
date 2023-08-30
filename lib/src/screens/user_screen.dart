import 'package:bloc_crud/src/uti/user_screen_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user_list/user_list_bloc.dart';
import '../models/user.dart';
import '../uti/util.dart';

class UserScreen extends StatefulWidget {
  final UserScreenAction action;
  final User? user;

  const UserScreen({
    super.key,
    this.user,
    required this.action,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;

  @override
  void initState() {
    super.initState();
    _name = widget.user?.name ?? '';
    _email = widget.user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final action = widget.action;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            action == UserScreenAction.create ? 'Create User' : 'Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                initialValue: _name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                initialValue: _email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  } else if (Util.isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (action == UserScreenAction.create) {
                      _createUser();
                    } else {
                      _editUser();
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createUser() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = User(
        id: 0,
        name: _name,
        email: _email,
      );
      BlocProvider.of<UserListBloc>(context).add(AddUser(user: user));

      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User created successfully.'),
        ),
      );
    }
  }

  void _editUser() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = User(
        id: widget.user?.id ?? 0,
        name: _name,
        email: _email,
      );
      BlocProvider.of<UserListBloc>(context).add(UpdateUser(user: user));

      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User updated successfully.'),
        ),
      );
    }
  }
}
