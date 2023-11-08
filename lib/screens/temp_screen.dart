import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invitor_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _usernameController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (err) {
      if (!context.mounted) return;

      SnackBar(
        content: Text(err.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (err) {
      if (!context.mounted) return;

      SnackBar(
        content: const Text('Unexpected Error Occured'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        context.go('/auth/login');
      }
    }
  }

  Future<void> _updateUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    final user = supabase.auth.currentUser;
    final username = _usernameController.text.trim();

    final updateUserInfoProfile = {
      'id': user!.id,
      'username': username,
      'updated_at': DateTime.now().toIso8601String(),
    };

    try {
      await supabase.from('user_info').upsert(updateUserInfoProfile);

      if (mounted) {
        const SnackBar(content: Text('Successfully updated your profile!'));
      }
    } on PostgrestException catch (err) {
      if (!context.mounted) return;
      SnackBar(
        content: Text(err.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (err) {
      if (!context.mounted) return;

      SnackBar(
        content: const Text('Unexpected Error Occured'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('user_info')
          .select<Map<String, dynamic>>()
          .eq('id', userId)
          .single();

      _usernameController.text = (data['username'] ?? '') as String;
    } on PostgrestException catch (err) {
      if (!context.mounted) return;

      SnackBar(
        content: Text(err.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (err) {
      if (!context.mounted) return;
      SnackBar(
        content: const Text('Unexpected Error Occured'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(hintText: 'Username'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .05),
                ElevatedButton(
                  onPressed: _isLoading ? null : _updateUserProfile,
                  child: Text(_isLoading ? 'Updating...' : 'Update Profile'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .025),
                TextButton(onPressed: _logout, child: const Text('Logout')),
              ],
            ),
    );
  }
}
