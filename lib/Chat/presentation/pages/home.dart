import 'package:clean_arch_chat/Chat/presentation/manager/Home/home_cubit.dart';
import 'package:clean_arch_chat/Chat/presentation/widgets/profile.dart';
import 'package:clean_arch_chat/Chat/presentation/widgets/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final List<Tab> _tabList = [
    const Tab(text: 'Chats '),
    const Tab(text: 'Profile'),
  ];
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: _tabList.length, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final currentTime = DateTime.now();
    switch (state) {
      case AppLifecycleState.resumed:
        HomeCubit.get(context).updateData(
          {
            'isOnline': true,
            'lastActive': currentTime,
          }
        );
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        HomeCubit.get(context).updateData(
            {
              'isOnline': false,
              'lastActive': currentTime,
            }
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chat App'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Center(
            child: TabBar(
              controller: _tabController,
              tabs: _tabList,
              isScrollable: true,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/auth');
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Users(),
          Profile(),
        ],
      ),
    );
  }
}
