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
              return ListTile(
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(behavior == null ? 'Add Behavior' : 'Edit Behavior'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
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
                  await behaviorService.addBehavior(
                    Behavior(id: 0, name: name, points: 1),
                  );
                } else {
                  await behaviorService.updateBehavior(
                    Behavior(
                      id: behavior.id,
                      name: name,
                      points: behavior.points,
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
  }
}
