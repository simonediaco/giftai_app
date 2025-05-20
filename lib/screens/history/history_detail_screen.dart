import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/history/history_bloc.dart';
import 'package:giftai/blocs/history/history_event.dart';
import 'package:giftai/blocs/history/history_state.dart';
import 'package:giftai/screens/wizard/wizard_screen.dart';
import 'package:giftai/widgets/gift/gift_grid_item.dart';
import 'package:intl/intl.dart';

class HistoryDetailScreen extends StatefulWidget {
  final int historyId;

  const HistoryDetailScreen({
    super.key,
    required this.historyId,
  });

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    
    // Carica il dettaglio della cronologia
    context.read<HistoryBloc>().add(
      HistoryDetailRequested(id: widget.historyId),
    );
  }
  
  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().add_Hm().format(date);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio Ricerca'),
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is HistoryDetailFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Errore: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HistoryBloc>().add(
                        HistoryDetailRequested(id: widget.historyId),
                      );
                    },
                    child: const Text('Riprova'),
                  ),
                ],
              ),
            );
          }
          
          if (state is HistoryDetailSuccess) {
            final history = state.history;
            final requestData = history.requestData;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Intestazione
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Data
                          Text(
                            'Ricerca del ${_formatDate(history.timestamp)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Parametri di ricerca
                          const Text(
                            'Criteri di ricerca',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Lista parametri
                          _buildRequestParameter('Categoria', requestData['category']),
                          _buildRequestParameter('Budget', requestData['budget']),
                          _buildRequestParameter('Nome', requestData['name']),
                          _buildRequestParameter('Età', requestData['age']?.toString()),
                          _buildRequestParameter('Genere', requestData['gender']),
                          _buildRequestParameter('Relazione', requestData['relation']),
                          _buildRequestParameter(
                            'Interessi',
                            requestData['interests'] != null
                                ? (requestData['interests'] as List).join(', ')
                                : null,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Pulsante per rifare la ricerca
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WizardScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Rifare questa ricerca'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Risultati
                  Text(
                    'Risultati trovati (${history.results.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  history.results.isEmpty
                      ? const Center(
                          child: Text(
                            'Nessun risultato trovato',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: history.results.length,
                          itemBuilder: (context, index) {
                            final gift = history.results[index];
                            return GiftGridItem(
                              gift: gift,
                              onTap: () {
                                // TODO: Implementare visualizzazione dettaglio regalo
                              },
                            );
                          },
                        ),
                ],
              ),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
  
  Widget _buildRequestParameter(String label, dynamic value) {
    if (value == null || (value is String && value.isEmpty)) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value.toString()),
          ),
        ],
      ),
    );
  }
}