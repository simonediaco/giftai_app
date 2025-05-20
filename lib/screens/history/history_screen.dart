import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/history/history_bloc.dart';
import 'package:giftai/blocs/history/history_event.dart';
import 'package:giftai/blocs/history/history_state.dart';
import 'package:giftai/models/history_model.dart';
import 'package:giftai/screens/history/history_detail_screen.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    
    // Carica la cronologia
    context.read<HistoryBloc>().add(HistoryFetchRequested());
  }
  
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays < 1) {
      // Oggi
      return 'Oggi, ${DateFormat.Hm().format(timestamp)}';
    } else if (difference.inDays < 2) {
      // Ieri
      return 'Ieri, ${DateFormat.Hm().format(timestamp)}';
    } else if (difference.inDays < 7) {
      // Questa settimana
      return DateFormat.EEEE().format(timestamp);
    } else {
      // Più di una settimana fa
      return DateFormat.yMMMd().format(timestamp);
    }
  }
  
  String _getRequestDescription(HistoryModel history) {
    final requestData = history.requestData;
    final List<String> details = [];
    
    if (requestData['category'] != null) {
      details.add('Categoria: ${requestData['category']}');
    }
    
    if (requestData['budget'] != null) {
      details.add('Budget: ${requestData['budget']}');
    }
    
    if (requestData['name'] != null && requestData['name'].isNotEmpty) {
      details.add('Per: ${requestData['name']}');
    } else if (requestData['gender'] != null) {
      details.add('Per: ${requestData['gender']}');
    }
    
    return details.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronologia'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HistoryBloc>().add(HistoryFetchRequested());
        },
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading && state is! HistoryLoadSuccess) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (state is HistoryLoadFailure) {
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
                        context.read<HistoryBloc>().add(HistoryFetchRequested());
                      },
                      child: const Text('Riprova'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is HistoryLoadSuccess) {
              if (state.histories.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.history,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nessuna ricerca nella cronologia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Le tue ricerche di regali appariranno qui',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Vai alla schermata di generazione
                          DefaultTabController.of(context)?.animateTo(1);
                        },
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Genera idee regalo'),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.histories.length,
                itemBuilder: (context, index) {
                  final history = state.histories[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryDetailScreen(
                              historyId: history.id,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Icona
                                CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  child: Icon(
                                    Icons.search,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Timestamp
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatTimestamp(history.timestamp),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _getRequestDescription(history),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                // Numero risultati
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${history.results.length} risultati',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            if (history.results.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              
                              // Miniature dei regali trovati
                              SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: history.results.length > 3 ? 3 : history.results.length,
                                  itemBuilder: (context, giftIndex) {
                                    final gift = history.results[giftIndex];
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            gift.getFullImageUrl(),
                                          ),
                                          fit: BoxFit.cover,
                                          onError: (exception, stackTrace) {
                                            // Fallback in caso di errore
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}