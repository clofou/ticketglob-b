import 'package:flutter/material.dart';
import 'package:ticketglob/models/ticket.dart';

class TicketDataSource extends DataTableSource {
  final List<Ticket> tickets;

  TicketDataSource({required this.tickets});

  @override
  DataRow getRow(int index) {
    final ticket = tickets[index];
    return DataRow(
      cells: [
        DataCell(Text(ticket.creationDate.toDate().toString())),
        DataCell(Text(ticket.titre)),
        DataCell(Text(ticket.description)),
        DataCell(Text(ticket.resolvedDate == null ? 'Non Résolu' : 'Résolu')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => tickets.length;

  @override
  int get selectedRowCount => 0;

  void setSelectedRowCount(int count) {}

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
