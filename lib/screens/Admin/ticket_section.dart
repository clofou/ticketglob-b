import 'package:flutter/material.dart';
import 'package:ticketglob/Widgets/ticket_data_table.dart';
import 'package:ticketglob/models/ticket.dart';
import 'package:ticketglob/services/db_service.dart';

class TicketSection extends StatefulWidget {
  final String searchQuery;
  final Function(String) onSearch;
  const TicketSection({super.key, required this.onSearch, required this.searchQuery});

  @override
  State<TicketSection> createState() => _TicketSectionState();
}

class _TicketSectionState extends State<TicketSection> {
  List<Ticket> tickets = [];
  bool _isLoading = true;
  String _selectedStatus = 'Tous';

  List<Ticket> _filterTicketsByStatus(String status) {
  // Filtrage par recherche
  List<Ticket> filteredTickets = tickets.where((ticket) =>
    ticket.titre.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
    ticket.description.toLowerCase().contains(widget.searchQuery.toLowerCase())
  ).toList();

  // Filtrage par statut
  if (status == 'Tous') {
    return filteredTickets;
  } else if (status == 'Résolus') {
    return filteredTickets.where((ticket) => ticket.resolvedDate != null).toList();
  } else if (status == 'Non Résolus') {
    return filteredTickets.where((ticket) => ticket.resolvedDate == null).toList();
  } else if (status == 'En Attente') {
    // Ajouter la logique pour les tickets en attente si nécessaire
    // Par exemple, si vous avez un champ `status` ou `priority` pour définir les tickets en attente
    return tickets;
  } else {
    return [];
  }
}

  @override
  void initState() {
    super.initState();
    _fetchTickets(); // Récupère les tickets à l'initialisation
  }

  Future<void> _fetchTickets() async {
    List<Ticket> fetchedTickets =
        await DbService().fetchTickets(); // Récupération des tickets
    setState(() {
      tickets = fetchedTickets;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _headerSection(),
        const SizedBox(height: 10),
        _filterSection(),
        const SizedBox(height: 15),
        _ticketTableView(),
      ],
    );
  }

  Widget _headerSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Tickets",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Ajoutez la logique pour ajouter un nouveau ticket si nécessaire
            },
            icon: const Icon(Icons.add),
            label: const Text("Ajouter un ticket"),
          ),
        ],
      ),
    );
  }

  Widget _filterSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 10,
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
      height: 55,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              style: Theme.of(context).textTheme.bodyMedium,
              value: _selectedStatus,
              items: <String>['Tous', 'Résolus', 'Non Résolus', 'En Attente']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    'Statut : $value',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _ticketTableView() {
    final filteredTickets = _filterTicketsByStatus(_selectedStatus);
    final resolvedCount =
        filteredTickets.where((ticket) => ticket.resolvedDate != null).length;

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: PaginatedDataTable(
                header: Row(
                  children: [
                    const Text(
                      'Tickets',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Spacer(),
                    Text(
                      'Total Résolus: $resolvedCount',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
                columns: const [
                  DataColumn(
                    label: Text('Date Création'),
                  ),
                  DataColumn(
                    label: Text('Titre'),
                  ),
                  DataColumn(
                    label: Text('Description'),
                  ),
                  DataColumn(
                    label: Text('Statut'),
                  ),
                ],
                source: TicketDataSource(tickets: filteredTickets),
                rowsPerPage: 5,
                columnSpacing: 15,
                headingRowHeight: 60,
              ),
            ),
          );
  }
}
