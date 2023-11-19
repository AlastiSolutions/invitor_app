import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:invitor_app/models/user_info.dart';
import 'package:invitor_app/widgets/global/bottom_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:invitor_app/models/friends.dart';
import 'package:invitor_app/main.dart';

class FriendsScreen extends StatefulWidget {
  final String profileId;

  const FriendsScreen({super.key, required this.profileId});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  bool _isLoading = true;
  List<Friends> authUserFrineds = [];

  Future<void> _fetchUserFriends() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await supabase
          .from('friends')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id);

      for (final friend in data) {
        final newFriends = Friends.fromJson(friend);
        setState(() {
          authUserFrineds.add(newFriends);
        });
      }
    } on PostgrestException catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: err.message,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 4,
        fontSize: 14,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
    } catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: 'An Unexpected error occuring try to fetch your friends',
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 4,
        fontSize: 14,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });

      // Fluttertoast.showToast(
      //   msg: 'Successfully fetched data',
      //   toastLength: Toast.LENGTH_LONG,
      //   backgroundColor: const Color.fromARGB(255, 93, 240, 101),
      //   textColor: Colors.black,
      //   timeInSecForIosWeb: 1,
      // );
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchUserFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('My Friends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(index: 0),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .05,
          vertical: MediaQuery.of(context).size.height * .025,
        ),
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .0125,
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: authUserFrineds.length,
                itemBuilder: (context, index) {
                  return _ProfileTile(id: authUserFrineds[index].friendId);
                },
              ),
      ),
    );
  }
}

class _ProfileTile extends StatefulWidget {
  final String id;

  const _ProfileTile({required this.id});

  @override
  State<_ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<_ProfileTile> {
  bool _isLoading = true;

  late UserInfo profileInfo;

  Future<void> _fetchUserInfo() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data =
          await supabase.from('user_info').select().eq('id', widget.id);

      profileInfo = UserInfo.fromJson(data[0]);
    } on PostgrestException catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: err.message,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 4,
        fontSize: 14,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
    } catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: 'An Unexpected error occuring try to fetch your data',
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 4,
        fontSize: 14,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : GestureDetector(
            onTap: () {
              context.go('/profile/${widget.id}');
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .05,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .0125,
                vertical: MediaQuery.of(context).size.height * .0125,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 216, 216, 216),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Column(
                    children: [Text(profileInfo.username!)],
                  )
                ],
              ),
            ),
          );
  }
}
