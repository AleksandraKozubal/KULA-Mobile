import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kula_mobile/Data/Data_sources/kebab_place_data_source.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';
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
  bool _showFillings = false;
  bool _showSauces = false;
  final TextEditingController _timeController = TextEditingController();
  String? _selectedDay;

  final Map<String, dynamic> _filters = {};
  String? _sortBy;
  String? _sortDirection;

  final ScrollController _drawerScrollController = ScrollController();

  void _toggleBadge(String key, dynamic value) {
    setState(() {
      if (_filters.containsKey(key) && (_filters[key] is List)) {
        if ((_filters[key] as List).contains(value)) {
          (_filters[key] as List).remove(value);
          if ((_filters[key] as List).isEmpty) {
            _filters.remove(key);
          }
        } else {
          (_filters[key] as List).add(value);
        }
      } else if (_filters.containsKey(key) && _filters[key] == value) {
        _filters.remove(key);
      } else {
        if (key == 'Składniki' || key == 'Sosy') {
          _filters[key] = [value];
        } else if (key == 'Sieć' || key == 'Kraft') {
          _filters[key] = value == 'Tak' ? 'true' : 'false';
        } else if (key == 'Otwarte teraz') {
          _filters['fopen'] = value == 'Tak' ? 'true' : 'false';
        } else if (key == 'Pokaż wyników') {
          _filters['paginate'] = int.parse(value);
        } else if (key == 'fdatetime') {
          _filters['fdatetime'] = value;
        } else {
          _filters[key] = value.toString().toLowerCase();
        }
      }
    });
  }

  void _setSort(String sortBy, String direction) {
    setState(() {
      _sortBy = sortBy.toLowerCase();
      _sortDirection = direction.toLowerCase();
    });
  }

  void _clearFilters() {
    setState(() {
      _filters.clear();
      _timeController.clear();
      _selectedDay = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _filters['paginate'] = 10;
    _sortBy = 'id';
    _sortDirection = 'asc';
    _fetchKebabPlaces();
    fillingsFuture = _getFillings();
    saucesFuture = _getSauces();
  }

  @override
  void dispose() {
    _drawerScrollController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _fetchKebabPlaces() async {
    try {
      final response = await KebabPlaceRepositoryImpl(
        KebabPlaceDataSource(client: http.Client()),
      ).getKebabPlaces(
        page: _currentPage,
        paginate: _filters['paginate'] ?? 10,
        fchain: _filters['Sieć'],
        fcraft: _filters['Kraft'],
        fdatetime: _filters['fdatetime'],
        ffillings:
            (_filters['Składniki'] as List?)?.map((e) => e as int).toList(),
        flocation: _filters['Lokalizacja'],
        fopen: _filters['fopen'],
        fordering: _filters['Sposoby zamawiania'],
        fsauces: (_filters['Sosy'] as List?)?.map((e) => e as int).toList(),
        fstatus: _filters['Status'],
        sby: _sortBy,
        sdirection: _sortDirection,
      );
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

  void _updateDateTimeFilter() {
    if (_selectedDay != null && _timeController.text.isNotEmpty) {
      _toggleBadge('fdatetime', '$_selectedDay-${_timeController.text}');
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
        child: Stack(
          children: [
            ListView(
              controller: _drawerScrollController,
              padding: EdgeInsets.zero,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Filtrowanie i sortowanie',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                FutureBuilder(
                  future: Future.wait([fillingsFuture, saucesFuture]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final fillings = snapshot.data![0];
                    final sauces = snapshot.data![1];
                    return Column(
                      children: [
                        ListTile(
                          title: ElevatedButton(
                            onPressed: _clearFilters,
                            child: const Text('Wyczyść filtry'),
                          ),
                        ),
                        const Divider(),
                        const ListTile(
                          title: Text('Ilość kebabów na stronie:'),
                        ),
                        ListTile(
                          title: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              GestureDetector(
                                onTap: () => _toggleBadge('Pokaż wyników', '10'),
                                child: BadgeWidget(
                                  text: '10',
                                  color: Colors.blue,
                                  solid: _filters['paginate'] == 10,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _toggleBadge('Pokaż wyników', '20'),
                                child: BadgeWidget(
                                  text: '20',
                                  color: Colors.blue,
                                  solid: _filters['paginate'] == 20,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _toggleBadge('Pokaż wyników', '50'),
                                child: BadgeWidget(
                                  text: '50',
                                  color: Colors.blue,
                                  solid: _filters['paginate'] == 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        const ListTile(
                          title: Text('Sortowanie:'),
                        ),
                        const ListTile(
                          title: Text('Według'),
                        ),
                        ListTile(
                          title: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              GestureDetector(
                                onTap: () => _setSort('google_maps_rating', 'asc'),
                                child: BadgeWidget(
                                  text: 'Ocena Google Maps',
                                  color: Colors.amber,
                                  solid: _sortBy == 'google_maps_rating' &&
                                      _sortDirection == 'asc',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _setSort('name', 'asc'),
                                child: BadgeWidget(
                                  text: 'Nazwa',
                                  color: Colors.black,
                                  solid: _sortBy == 'name' &&
                                      _sortDirection == 'asc',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _setSort('ID', 'asc'),
                                child: BadgeWidget(
                                  text: 'Domyślne',
                                  color: Colors.black,
                                  solid: _sortBy == 'id' &&
                                      _sortDirection == 'asc',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _setSort('opened_at_year', 'asc'),
                                child: BadgeWidget(
                                  text: 'Data otwarcia',
                                  color: Colors.deepOrangeAccent,
                                  solid: _sortBy == 'opened_at_year' &&
                                      _sortDirection == 'asc',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _setSort('closed_at_year', 'asc'),
                                child: BadgeWidget(
                                  text: 'Data zamknięcia',
                                  color: Colors.deepOrangeAccent,
                                  solid: _sortBy == 'closed_at_year' &&
                                      _sortDirection == 'asc',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        const ListTile(
                          title: Text('Kierunek'),
                        ),
                        ListTile(
                          title: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              GestureDetector(
                                onTap: () => _setSort(_sortBy!, 'asc'),
                                child: BadgeWidget(
                                  text: 'Rosnąco',
                                  color: Colors.green,
                                  solid: _sortDirection == 'asc',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _setSort(_sortBy!, 'desc'),
                                child: BadgeWidget(
                                  text: 'Malejąco',
                                  color: Colors.red,
                                  solid: _sortDirection == 'desc',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('Składniki'),
                          trailing: IconButton(
                            icon: Icon(_showFillings
                                ? Icons.expand_less
                                : Icons.expand_more),
                            onPressed: () {
                              setState(() {
                                _showFillings = !_showFillings;
                              });
                            },
                          ),
                        ),
                        if (_showFillings)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: fillings.length,
                            itemBuilder: (context, index) {
                              final entry = fillings.entries.elementAt(index);
                              return CheckboxListTile(
                                title: Text(entry.value['name']!),
                                value: (_filters['Składniki'] as List?)
                                        ?.contains(entry.key) ??
                                    false,
                                onChanged: (bool? value) {
                                  _toggleBadge('Składniki', entry.key);
                                },
                              );
                            },
                          ),
                        const Divider(),
                        ListTile(
                          title: const Text('Sosy'),
                          trailing: IconButton(
                            icon: Icon(_showSauces
                                ? Icons.expand_less
                                : Icons.expand_more),
                            onPressed: () {
                              setState(() {
                                _showSauces = !_showSauces;
                              });
                            },
                          ),
                        ),
                        if (_showSauces)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: sauces.length,
                            itemBuilder: (context, index) {
                              final entry = sauces.entries.elementAt(index);
                              return CheckboxListTile(
                                title: Text(entry.value['name']!),
                                value: (_filters['Sosy'] as List?)
                                        ?.contains(entry.key) ??
                                    false,
                                onChanged: (bool? value) {
                                  _toggleBadge('Sosy', entry.key);
                                },
                              );
                            },
                          ),
                        const Divider(),
                        const ListTile(
                          title: Text('Sieć'),
                        ),
                        ListTile(
                          title: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              GestureDetector(
                                onTap: () => _toggleBadge('Sieć', 'Tak'),
                                child: BadgeWidget(
                                  text: 'Tak',
                                  color: Colors.blue,
                                  solid: _filters['Sieć'] == 'true',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _toggleBadge('Sieć', 'Nie'),
                                child: BadgeWidget(
                                  text: 'Nie',
                                  color: Colors.grey,
                                  solid: _filters['Sieć'] == 'false',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        const ListTile(
                          title: Text('Status'),
                        ),
                        ListTile(
                          title: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              GestureDetector(
                                onTap: () => _toggleBadge('Status', 'Otwarte'),
                                child: BadgeWidget(
                                  text: 'Otwarte',
                                  color: Colors.green,
                                  solid: _filters['Status'] == 'otwarte',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _toggleBadge('Status', 'Zamknięte'),
                                child: BadgeWidget(
                                  text: 'Zamknięte',
                                  color: Colors.red,
                                  solid: _filters['Status'] == 'zamknięte',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _toggleBadge('Status', 'Planowane'),
                                child: BadgeWidget(
                                  text: 'Planowane',
                                  color: Colors.orange,
                                  solid: _filters['Status'] == 'planowane',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        const ListTile(
                          title: Text('Otwarte'),
                        ),
                        ListTile(
                          title: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              GestureDetector(
                                onTap: () => _toggleBadge('Otwarte teraz', 'Tak'),
                                child: BadgeWidget(
                                  text: 'Tak',
                                  color: Colors.green,
                                  solid: _filters['fopen'] == 'true',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _toggleBadge('Otwarte teraz', 'Nie'),
                                child: BadgeWidget(
                                  text: 'Nie',
                                  color: Colors.red,
                                  solid: _filters['fopen'] == 'false',
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_filters['fopen'] == 'true') ...[
                          const Divider(),
                          ListTile(
                            title: const Text('Filtruj według dnia tygodnia i godziny'),
                            subtitle: const Text('Wybierz dzień tygodnia i godzinę'),
                            trailing: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _timeController.clear();
                                  _selectedDay = null;
                                  _filters.remove('fdatetime');
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: DropdownButtonFormField<String>(
                              value: _selectedDay,
                              decoration: const InputDecoration(
                                hintText: 'Wybierz dzień tygodnia',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: '0', child: Text('Poniedziałek')),
                                DropdownMenuItem(value: '1', child: Text('Wtorek')),
                                DropdownMenuItem(value: '2', child: Text('Środa')),
                                DropdownMenuItem(value: '3', child: Text('Czwartek')),
                                DropdownMenuItem(value: '4', child: Text('Piątek')),
                                DropdownMenuItem(value: '5', child: Text('Sobota')),
                                DropdownMenuItem(value: '6', child: Text('Niedziela')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedDay = value;
                                  _updateDateTimeFilter();
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              controller: _timeController,
                              decoration: const InputDecoration(
                                hintText: 'Np. 12:00',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateDateTimeFilter();
                              },
                            ),
                          ),
                        ],
                        const Divider(),
                        const ListTile(
                          title: Text('Kraft'),
                        ),
                        ListTile(
                          title: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              GestureDetector(
                                onTap: () => _toggleBadge('Kraft', 'Tak'),
                                child: BadgeWidget(
                                  text: 'Tak',
                                  color: Colors.purple,
                                  solid: _filters['Kraft'] == 'true',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _toggleBadge('Kraft', 'Nie'),
                                child: BadgeWidget(
                                  text: 'Nie',
                                  color: Colors.grey,
                                  solid: _filters['Kraft'] == 'false',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        const ListTile(
                          title: Text('Lokalizacja'),
                        ),
                        ListTile(
                          title: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              GestureDetector(
                                onTap: () => _toggleBadge('Lokalizacja', 'buda'),
                                child: BadgeWidget(
                                  text: 'Buda',
                                  color: Colors.blue,
                                  solid: _filters['Lokalizacja'] == 'buda',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _toggleBadge('Lokalizacja', 'lokal'),
                                child: BadgeWidget(
                                  text: 'Lokal',
                                  color: Colors.grey,
                                  solid: _filters['Lokalizacja'] == 'lokal',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        const ListTile(
                          title: Text('Sposoby zamawiania'),
                        ),
                        ListTile(
                          title: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              GestureDetector(
                                onTap: () => _toggleBadge(
                                  'Sposoby zamawiania',
                                  'własna aplikacja',
                                ),
                                child: BadgeWidget(
                                  text: 'Własna aplikacja',
                                  color: Colors.blue,
                                  solid: _filters['Sposoby zamawiania'] ==
                                      'własna aplikacja',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _toggleBadge(
                                  'Sposoby zamawiania',
                                  'przez telefon',
                                ),
                                child: BadgeWidget(
                                  text: 'Przez telefon',
                                  color: Colors.blue,
                                  solid: _filters['Sposoby zamawiania'] ==
                                      'przez telefon',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _toggleBadge(
                                  'Sposoby zamawiania',
                                  'własna strona',
                                ),
                                child: BadgeWidget(
                                  text: 'Własna strona',
                                  color: Colors.blue,
                                  solid: _filters['Sposoby zamawiania'] ==
                                      'własna strona',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _toggleBadge(
                                  'Sposoby zamawiania',
                                  'pyszne.pl',
                                ),
                                child: BadgeWidget(
                                  text: 'Pyszne.pl',
                                  color: Colors.blue,
                                  solid: _filters['Sposoby zamawiania'] ==
                                      'pyszne.pl',
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    _toggleBadge('Sposoby zamawiania', 'glovo'),
                                child: BadgeWidget(
                                  text: 'Glovo',
                                  color: Colors.blue,
                                  solid: _filters['Sposoby zamawiania'] == 'glovo',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100.0),
                      ],
                    );
                  },
                ),
              ],
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: ElevatedButton(
                onPressed: _fetchKebabPlaces,
                child: const Text('Zastosuj filtry'),
              ),
            ),
          ],
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
