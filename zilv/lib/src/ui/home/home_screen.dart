import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zilv/src/models/behavior.dart';
import 'package:zilv/src/services/behavior_service.dart';
import 'package:zilv/src/ui/behaviors/manage_behaviors_screen.dart';
import 'package:zilv/src/ui/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Behavior>> _behaviorsFuture;
  late Future<int> _scoreFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final behaviorService = Provider.of<BehaviorService>(
      context,
      listen: false,
    );
    setState(() {
      _behaviorsFuture = behaviorService.getBehaviors();
      _scoreFuture = behaviorService.getCurrentScore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final behaviorService = Provider.of<BehaviorService>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zilv Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Score display
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<int>(
                future: _scoreFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  return Column(
                    children: [
                      const Text(
                        'Current Score',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '${snapshot.data ?? 0}',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          // Behavior list
          Expanded(
            child: FutureBuilder<List<Behavior>>(
              future: _behaviorsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading behaviors'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No behaviors yet. Add one!'),
                  );
                }

                final behaviors = snapshot.data!;
                return ListView.builder(
                  itemCount: behaviors.length,
                  itemBuilder: (context, index) {
                    final behavior = behaviors[index];
                    return ListTile(
                      title: Text(behavior.name),
                      trailing: Text('${behavior.points}'),
                      onTap: () async {
                        await behaviorService.logBehavior(behavior);
                        _loadData(); // Refresh data
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ManageBehaviorsScreen(),
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
