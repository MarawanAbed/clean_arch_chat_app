import 'package:clean_arch_chat/Chat/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/Chat/presentation/widgets/profile.dart';
import 'package:clean_arch_chat/Chat/presentation/widgets/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  final List<Tab> _tabList = [
    const Tab(text: 'Chats '),
    const Tab(text: 'Profile'),
  ];
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: _tabList.length, vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
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
      body:TabBarView(
        controller: _tabController,
          children: const [
            Users(),
            Profile(),
          ] ,
      ),
    );
  }
}


