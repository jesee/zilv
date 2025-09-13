import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zilv/src/models/behavior.dart';
import 'package:zilv/src/services/behavior_service.dart';

class ManageBehaviorsScreen extends StatefulWidget {
  const ManageBehaviorsScreen({super.key});

  @override
  State<ManageBehaviorsScreen> createState() => _ManageBehaviorsScreenState();
}

class _ManageBehaviorsScreenState extends State<ManageBehaviorsScreen> {
  late Future<List<Behavior>> _behaviorsFuture;

  @override
  void initState() {
    super.initState();
    _loadBehaviors();
  }

  void _loadBehaviors() {
    final behaviorService = Provider.of<BehaviorService>(
      context,
      listen: false,
    );
    setState(() {
      _behaviorsFuture = behaviorService.getBehaviors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Behaviors')),
      body: FutureBuilder<List<Behavior>>(
        future: _behaviorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading behaviors'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No behaviors yet.'));
          }

          final behaviors = snapshot.data!;
          return ListView.builder(
            itemCount: behaviors.length,
            itemBuilder: (context, index) {
              final behavior = behaviors[index];
              final isPositive = behavior.points >= 0;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isPositive
                        ? Theme.of(context).colorScheme.tertiaryContainer
                        : Theme.of(context).colorScheme.errorContainer,
                    child: Icon(
                      isPositive ? Icons.thumb_up_alt : Icons.thumb_down_alt,
                      color: isPositive
                          ? Theme.of(context).colorScheme.onTertiaryContainer
                          : Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  title: Text(behavior.name),
                  subtitle: Text('Points: ${behavior.points}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showBehaviorDialog(behavior: behavior),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteBehavior(behavior.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBehaviorDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteBehavior(int id) async {
    final behaviorService = Provider.of<BehaviorService>(
      context,
      listen: false,
    );
    await behaviorService.deleteBehavior(id);
    _loadBehaviors();
  }

  void _showBehaviorDialog({Behavior? behavior}) {
    final nameController = TextEditingController(text: behavior?.name ?? '');
    bool isPositive = (behavior?.points ?? 1) >= 0;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
          title: Text(behavior == null ? 'Add Behavior' : 'Edit Behavior'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Text('Type'),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Positive'),
                    selected: isPositive,
                    onSelected: (_) {
                      setState(() {
                        isPositive = true;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Negative'),
                    selected: !isPositive,
                    onSelected: (_) {
                      setState(() {
                        isPositive = false;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final name = nameController.text;
                final behaviorService = Provider.of<BehaviorService>(
                  context,
                  listen: false,
                );

                if (behavior == null) {
                  final newPoints = isPositive ? 1 : -1;
                  await behaviorService.addBehavior(
                    Behavior(id: 0, name: name, points: newPoints),
                  );
                } else {
                  final magnitude = behavior.points.abs();
                  final updatedPoints = isPositive ? magnitude : -magnitude;
                  await behaviorService.updateBehavior(
                    Behavior(
                      id: behavior.id,
                      name: name,
                      points: updatedPoints,
                    ),
                  );
                }
                _loadBehaviors();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
            );
          },
        );
      },
    );
  }
}
