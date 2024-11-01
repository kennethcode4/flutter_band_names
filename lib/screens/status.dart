import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:band_names/services/services.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => socketService.emit('emitir-mensaje',
              {'nombre': 'Flutter', 'mensaje': 'Hola desde Flutter'}),
          child: const Icon(Icons.message_outlined)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status : ${socketService.serverStatus}'),
          ],
        ),
      ),
    );
  }
}
