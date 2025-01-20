import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kula_mobile/Data/Data_sources/kebab_place_data_source.dart';
import 'package:kula_mobile/Data/Models/filling_model.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';
import 'package:kula_mobile/Data/Models/sauce_model.dart';
import 'package:kula_mobile/Data/Repositories/filling_repository_impl.dart';
import 'package:kula_mobile/Data/Repositories/kebab_place_repository_impl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kula_mobile/Data/Repositories/sauce_repository_impl.dart';
import 'package:kula_mobile/Widgets/kebab_place_details_widget.dart';
import 'package:kula_mobile/Data/Data_sources/filling_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/sauce_data_source.dart';
import 'badge_widget.dart';

class KebabPlaceWidget extends StatefulWidget {
  final FillingRepositoryImpl fillingRepository;
  final SauceRepositoryImpl sauceRepository;

  const KebabPlaceWidget({
    required this.fillingRepository,
    required this.sauceRepository,
    super.key,
  });
  @override
  KebabPlaceWidgetState createState() => KebabPlaceWidgetState();
}

class KebabPlaceWidgetState extends State<KebabPlaceWidget> {
  List<KebabPlaceModel> _kebabPlaces = [];
  bool _isLoading = true;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalKebabs = 0;
  late Future<Map<int, Map<String, String?>>> fillingsFuture;
  late Future<Map<int, Map<String, String?>>> saucesFuture;

  final Map<String, bool> _badgeStates = {
    'Sieć': false,
    'Kraft': false,
    'Data otwarcia': false,
    'Lokalizacja': false,
    'Status': false,
    'Otwarte': false,
    'Zamknięte': false,
    'Planowane': false,
    'Sosy': false,
    'Składniki': false,
  };

  void _toggleBadge(String key) {
    setState(() {
      _badgeStates[key] = !_badgeStates[key]!;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchKebabPlaces();
    fillingsFuture = _getFillings();
    saucesFuture = _getSauces();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchKebabPlaces() async {
    try {
      final response = await KebabPlaceRepositoryImpl(
        KebabPlaceDataSource(client: http.Client()),
      ).getKebabPlaces(page: _currentPage, paginate: 10);
      setState(() {
        if (_currentPage == 1) {
          _kebabPlaces = response['data'];
        } else {
          _kebabPlaces.addAll(response['data']);
        }
        _isLoading = false;
        _totalPages = response['last_page'];
        _totalKebabs = response['total'];
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nie udało się załadować kebabów'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Map<int, Map<String, String?>>> _getFillings() async {
    final fillings = await widget.fillingRepository.getFillings();
    return {
      for (var filling in fillings)
        filling.id: {'name': filling.name, 'hexColor': filling.hexColor},
    };
  }

  Future<Map<int, Map<String, String?>>> _getSauces() async {
    final sauces = await widget.sauceRepository.getSauces();
    return {
      for (var sauce in sauces)
        sauce.id: {'name': sauce.name, 'hexColor': sauce.hexColor},
    };
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _isLoading = true;
        _kebabPlaces.clear();
      });
      _fetchKebabPlaces();
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
        _isLoading = true;
        _kebabPlaces.clear();
      });
      _fetchKebabPlaces();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Kebaby w okolicy'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: BadgeWidget(
              text: 'Razem: $_totalKebabs',
              color: Colors.white,
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
                _getFillings();
                _getSauces();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: FutureBuilder(
          future: Future.wait([fillingsFuture, saucesFuture]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            final fillings = snapshot.data![0];
            final sauces = snapshot.data![1];
            return ListView(
              children: [
                const DrawerHeader(
                  child: Text('Filtruj i sortuj'),
                ),
                ListTile(
                  title: Column(
                    children: [
                      const Text('Filtry:'),
                      const ListTile(
                        title: Text('Składniki'),
                      ),
                      ListTile(
                        title: Column(
                          children: fillings.entries
                              .map(
                                (entry) => ListTile(
                                  title: GestureDetector(
                                    onTap: () =>
                                        _toggleBadge(entry.value['name']!),
                                    child: BadgeWidget(
                                      text: entry.value['name']!,
                                      color: Colors.indigo,
                                      solid:
                                          _badgeStates[entry.value['name']] ??
                                              false,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const ListTile(
                        title: Text('Sosy'),
                      ),
                      ListTile(
                        title: Column(
                          children: sauces.entries
                              .map(
                                (entry) => ListTile(
                                  title: GestureDetector(
                                    onTap: () =>
                                        _toggleBadge(entry.value['name']!),
                                    child: BadgeWidget(
                                      text: entry.value['name']!,
                                      color: Colors.pink,
                                      solid:
                                          _badgeStates[entry.value['name']] ??
                                              false,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const ListTile(
                        title: Text('Sieć'),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _toggleBadge('Sieć'),
                              child: BadgeWidget(
                                text: 'Tak',
                                color: Colors.blue,
                                solid: _badgeStates['Sieć'] == true,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Sieć'),
                              child: BadgeWidget(
                                text: 'Nie',
                                color: Colors.grey,
                                solid: _badgeStates['Sieć'] == false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const ListTile(
                        title: Text('Status'),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _toggleBadge('Otwarte'),
                              child: BadgeWidget(
                                text: 'Otwarte',
                                color: Colors.green,
                                solid: _badgeStates['Otwarte'] ?? false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Zamknięte'),
                              child: BadgeWidget(
                                text: 'Zamknięte',
                                color: Colors.red,
                                solid: _badgeStates['Zamknięte'] ?? false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Planowane'),
                              child: BadgeWidget(
                                text: 'Planowane',
                                color: Colors.orange,
                                solid: _badgeStates['Planowane'] ?? false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const ListTile(
                        title: Text('Kraft'),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _toggleBadge('Kraft'),
                              child: BadgeWidget(
                                text: 'Tak',
                                color: Colors.purple,
                                solid: _badgeStates['Kraft'] == true,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Kraft'),
                              child: BadgeWidget(
                                text: 'Nie',
                                color: Colors.grey,
                                solid: _badgeStates['Kraft'] == false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const ListTile(
                        title: Text('Lokaliazacja'),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _toggleBadge('Lokalizacja'),
                              child: BadgeWidget(
                                text: 'Buda',
                                color: Colors.blue,
                                solid: _badgeStates['Lokalizacja'] == true,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Lokalizacja'),
                              child: BadgeWidget(
                                text: 'Lokal',
                                color: Colors.grey,
                                solid: _badgeStates['Lokalizacja'] == false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const ListTile(
                        title: Text('Czynne'),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _toggleBadge('Status'),
                              child: BadgeWidget(
                                text: 'Otwarte',
                                color: Colors.green,
                                solid: _badgeStates['Status'] == true,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Status'),
                              child: BadgeWidget(
                                text: 'Zamknięte',
                                color: Colors.red,
                                solid: _badgeStates['Status'] == false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const ListTile(
                        title: Text('Sposoby zamawiania'),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _toggleBadge('Własna aplikacja'),
                              child: BadgeWidget(
                                text: 'Własna aplikacja',
                                color: Colors.blue,
                                solid:
                                    _badgeStates['Własna aplikacja'] ?? false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Przez telefon'),
                              child: BadgeWidget(
                                text: 'Przez telefon',
                                color: Colors.blue,
                                solid: _badgeStates['Przez telefon'] ?? false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Własna strona'),
                              child: BadgeWidget(
                                text: 'Własna strona',
                                color: Colors.blue,
                                solid: _badgeStates['Własna strona'] ?? false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Pyszne.pl'),
                              child: BadgeWidget(
                                text: 'Pyszne.pl',
                                color: Colors.blue,
                                solid: _badgeStates['Pyszne.pl'] ?? false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Glovo'),
                              child: BadgeWidget(
                                text: 'Glovo',
                                color: Colors.blue,
                                solid: _badgeStates['Glovo'] ?? false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const ListTile(
                        title: Text('Pokaż wyników'),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _toggleBadge('10'),
                              child: BadgeWidget(
                                text: '10',
                                color: Colors.blue,
                                solid: _badgeStates['10'] ?? false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('20'),
                              child: BadgeWidget(
                                text: '20',
                                color: Colors.blue,
                                solid: _badgeStates['20'] ?? false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('50'),
                              child: BadgeWidget(
                                text: '50',
                                color: Colors.blue,
                                solid: _badgeStates['50'] ?? false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Column(
                    children: [
                      const Text('Sortowanie:'),
                      const ListTile(
                        title: Text('Według'),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            // data otwarcia, ocena google maps, nazwa, id, data zamknięcia
                            GestureDetector(
                              onTap: () => _toggleBadge('Ocena Google Maps'),
                              child: BadgeWidget(
                                text: 'Ocena Google Maps',
                                color: Colors.amber,
                                solid:
                                    _badgeStates['Ocena Google Maps'] ?? false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Nazwa'),
                              child: BadgeWidget(
                                text: 'Nazwa',
                                color: Colors.black,
                                solid: _badgeStates['Nazwa'] ?? false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('ID'),
                              child: BadgeWidget(
                                text: 'ID',
                                color: Colors.black,
                                solid: _badgeStates['ID'] ?? false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Data otwarcia'),
                              child: BadgeWidget(
                                text: 'Data otwarcia',
                                color: Colors.deepOrangeAccent,
                                solid: _badgeStates['Data otwarcia'] ?? false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Data zamknięcia'),
                              child: BadgeWidget(
                                text: 'Data zamknięcia',
                                color: Colors.deepOrangeAccent,
                                solid: _badgeStates['Data zamknięcia'] ?? false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const ListTile(
                        title: Text('Kierunek'),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _toggleBadge('Rosnąco'),
                              child: BadgeWidget(
                                text: 'Rosnąco',
                                color: Colors.green,
                                solid: _badgeStates['Rosnąco'] ?? false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleBadge('Malejąco'),
                              child: BadgeWidget(
                                text: 'Malejąco',
                                color: Colors.red,
                                solid: _badgeStates['Malejąco'] ?? false,
                              ),
                            ),
                          ],
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: _kebabPlaces.length,
                    itemBuilder: (context, index) {
                      final kebabPlace = _kebabPlaces[index];
                      return ListTile(
                        leading: const Icon(Icons.fastfood, size: 50.0),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            kebabPlace.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    kebabPlace.address,
                                  ),
                                  if (kebabPlace.googleMapsRating != null) ...[
                                    const SizedBox(width: 8.0),
                                    RatingBarIndicator(
                                      rating: double.parse(
                                        kebabPlace.googleMapsRating!,
                                      ),
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  if (kebabPlace.status == 'zamknięte')
                                    const BadgeWidget(
                                      text: 'Zamknięte',
                                      color: Colors.red,
                                      solid: true,
                                    ),
                                  if (kebabPlace.status == 'otwarte')
                                    const BadgeWidget(
                                      text: 'Otwarte',
                                      color: Colors.green,
                                      solid: true,
                                    ),
                                  if (kebabPlace.status == 'planowane')
                                    const BadgeWidget(
                                      text: 'Planowane',
                                      color: Colors.orange,
                                      solid: true,
                                    ),
                                  const SizedBox(width: 8.0),
                                  if (kebabPlace.isCraft == true) ...[
                                    const BadgeWidget(
                                      text: 'Kraft',
                                      color: Colors.purple,
                                    ),
                                    const SizedBox(width: 8.0),
                                  ],
                                  if (kebabPlace.openedAtYear != null)
                                    BadgeWidget(
                                      text: 'Od ${kebabPlace.openedAtYear}',
                                      color: Colors.deepOrangeAccent,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KebabPlaceDetailsWidget(
                                kebabPlace: kebabPlace,
                                fillingRepository: FillingRepositoryImpl(
                                  FillingDataSource(client: http.Client()),
                                ),
                                sauceRepository: SauceRepositoryImpl(
                                  SauceDataSource(client: http.Client()),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _previousPage,
                        child: const Icon(Icons.arrow_back),
                      ),
                      BadgeWidget(
                        text: 'Strona $_currentPage / $_totalPages',
                        color: Theme.of(context).textTheme.bodyLarge?.color ??
                            Colors.black,
                      ),
                      ElevatedButton(
                        onPressed: _nextPage,
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
