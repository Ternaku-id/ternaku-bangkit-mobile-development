import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  final List<dynamic>? history;
  final Function() onRefresh;

  const HistoryPage({Key? key, this.history, required this.onRefresh})
      : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String filter = 'All';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
        onRefresh: () async {
          widget.onRefresh();
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterButton(
                    label: 'All',
                    onPressed: () {
                      setFilter('All');
                    },
                    isActive: filter == 'All',
                  ),
                  SizedBox(width: 10),
                  FilterButton(
                    label: 'Sapi',
                    onPressed: () {
                      setFilter('Sapi');
                    },
                    isActive: filter == 'Sapi',
                  ),
                  SizedBox(width: 10),
                  FilterButton(
                    label: 'Kambing',
                    onPressed: () {
                      setFilter('Kambing');
                    },
                    isActive: filter == 'Kambing',
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      widget.onRefresh();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredHistory.length,
                itemBuilder: (context, index) {
                  final item =
                      filteredHistory[filteredHistory.length - index - 1];
                  final dateFormat = DateFormat('E, d MMM yyyy HH:mm:ss');
                  final createdAt = dateFormat.parse(item['created_at']);
                  final formattedDate =
                      DateFormat('dd MMM yyyy').format(createdAt);
                  final formattedTime = DateFormat('HH:mm').format(createdAt);
                  final formattedDay = DateFormat('EEEE').format(createdAt);
                  return Card(
                    child: ListTile(
                      onTap: () {
                        navigateToDetailPage(context, item);
                      },
                      leading: Image.asset(
                        'assets/logo.png',
                        width: 50,
                        height: 60,
                      ),
                      title: Text(item['animal_category']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formattedDate),
                          Text('$formattedDay, $formattedTime'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> get filteredHistory {
    if (filter == 'All') {
      return widget.history ?? [];
    } else {
      return (widget.history ?? [])
          .where((item) => item['animal_category'] == filter)
          .toList();
    }
  }

  void setFilter(String value) {
    setState(() {
      filter = value;
    });
  }

  void navigateToDetailPage(BuildContext context, dynamic item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryDetailPage(item: item)),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isActive;

  const FilterButton({
    required this.label,
    required this.onPressed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: isActive ? Colors.green : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class HistoryDetailPage extends StatelessWidget {
  final dynamic item;

  const HistoryDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Detail'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Animal Category: ${item['animal_category']}'),
            SizedBox(height: 10),
            Text('Prediction Result: ${item['prediction_result']}'),
            SizedBox(height: 10),
            Text('Created At: ${item['created_at']}'),
            SizedBox(height: 10),
            InteractiveViewer(
              child: Image.network(
                item['image_url'],
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
