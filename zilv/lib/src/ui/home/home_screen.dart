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
                  final score = snapshot.data ?? 0;
                  final theme = Theme.of(context);
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.star_rounded,
                          size: 36,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Score',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              '$score',
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                final positives = behaviors.where((b) => b.points >= 0).toList();
                final negatives = behaviors.where((b) => b.points < 0).toList();
                return ListView(
                  children: [
                    if (positives.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                        child: Text('Positive', style: Theme.of(context).textTheme.labelLarge),
                      ),
                      ...positives.map((behavior) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                              child: Icon(
                                Icons.thumb_up_alt,
                                color: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ),
                            title: Text(behavior.name),
                            trailing: Chip(
                              label: Text('${behavior.points}'),
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () async {
                              try {
                                await behaviorService.logBehavior(behavior);
                              } catch (e) {
                                final message = e
                                        .toString()
                                        .contains('DAILY_POSITIVE_LIMIT_REACHED')
                                    ? '今日正面积分已达上限'
                                    : '记录失败';
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                }
                              } finally {
                                _loadData(); // Refresh data
                              }
                            },
                          ),
                        );
                      }),
                    ],
                    if (negatives.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text('Negative', style: Theme.of(context).textTheme.labelLarge),
                      ),
                      ...negatives.map((behavior) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.errorContainer,
                              child: Icon(
                                Icons.thumb_down_alt,
                                color: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                            ),
                            title: Text(behavior.name),
                            trailing: Chip(
                              label: Text('${behavior.points}'),
                              backgroundColor: Theme.of(context).colorScheme.errorContainer,
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onErrorContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () async {
                              try {
                                await behaviorService.logBehavior(behavior);
                              } catch (e) {
                                final message = e
                                        .toString()
                                        .contains('DAILY_POSITIVE_LIMIT_REACHED')
                                    ? '今日正面积分已达上限'
                                    : '记录失败';
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                }
                              } finally {
                                _loadData(); // Refresh data
                              }
                            },
                          ),
                        );
                      }),
                    ],
                  ],
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
