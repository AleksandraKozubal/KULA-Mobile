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
  const KebabPlaceWidget({super.key});

  @override
  KebabPlaceWidgetState createState() => KebabPlaceWidgetState();
}

class KebabPlaceWidgetState extends State<KebabPlaceWidget> {
  List<KebabPlaceModel> _kebabPlaces = [];
  bool _isLoading = true;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalKebabs = 0;

  @override
  void initState() {
    super.initState();
    _fetchKebabPlaces();
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
            child:
                BadgeWidget(text: 'Razem: $_totalKebabs', color: Colors.white),
          ),
        ],
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
