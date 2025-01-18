import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:kula_mobile/Data/Data_sources/kebab_place_data_source.dart';
import 'package:kula_mobile/Data/Repositories/kebab_place_repository_impl.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'badge_widget.dart';
import 'kebab_place_details_widget.dart';
import 'package:kula_mobile/Data/Data_sources/filling_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/sauce_data_source.dart';
import 'package:kula_mobile/Data/Repositories/filling_repository_impl.dart';
import 'package:kula_mobile/Data/Repositories/sauce_repository_impl.dart';
import 'package:flutter/services.dart' show rootBundle;

class KebabPlaceMapWidget extends StatefulWidget {
  const KebabPlaceMapWidget({super.key});

  @override
  State<KebabPlaceMapWidget> createState() => _KebabPlaceMapWidgetState();
}

class _KebabPlaceMapWidgetState extends State<KebabPlaceMapWidget> {
  final LatLng _initialPosition = const LatLng(51.2070, 16.1550);
  List<KebabPlaceModel> _kebabPlaces = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKebabPlaces();
  }

  Future<void> _fetchKebabPlaces({int page = 1}) async {
    try {
      final response = await KebabPlaceRepositoryImpl(
        KebabPlaceDataSource(client: http.Client()),
      ).getKebabPlaces(page: page);
      setState(() {
        _kebabPlaces = response['data'];
        _isLoading = false;
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

  Future<String> _loadSvgAsset(String path) async {
    var svgString = await rootBundle.loadString(path);
    svgString = svgString.replaceAll('<sodipodi:namedview/>', '');
    return svgString;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: _initialPosition,
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              retinaMode: RetinaMode.isHighDensity(context),
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            if (!_isLoading)
              MarkerLayer(
                markers: _kebabPlaces
                    .map(
                      (kebabPlace) => Marker(
                        width: 60.0,
                        height: 60.0,
                        point: LatLng(
                          double.parse(kebabPlace.latitude!),
                          double.parse(kebabPlace.longitude!),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        kebabPlace.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Adres: ${kebabPlace.address}'),
                                    if (kebabPlace.googleMapsRating != null)
                                      Row(
                                        children: [
                                          Text(
                                            'Ocena: ${kebabPlace.googleMapsRating}',
                                          ),
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
                                      ),
                                    if (kebabPlace.phone != null)
                                      Text('Telefon: ${kebabPlace.phone}'),
                                    if (kebabPlace.website != null)
                                      Text(
                                        'Strona internetowa: ${kebabPlace.website}',
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
                                        if (kebabPlace.openedAtYear !=
                                            null) ...[
                                          BadgeWidget(
                                            text:
                                                'Od ${kebabPlace.openedAtYear}',
                                            color: Colors.deepOrangeAccent,
                                          ),
                                          const SizedBox(width: 8.0),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                KebabPlaceDetailsWidget(
                                              kebabPlace: kebabPlace,
                                              fillingRepository:
                                                  FillingRepositoryImpl(
                                                FillingDataSource(
                                                  client: http.Client(),
                                                ),
                                              ),
                                              sauceRepository:
                                                  SauceRepositoryImpl(
                                                SauceDataSource(
                                                  client: http.Client(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Zobacz szczegóły'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: FutureBuilder<String>(
                            future: _loadSvgAsset('assets/kebab.svg'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Icon(Icons.error);
                              } else {
                                return SizedBox(
                                  width: 5.0,
                                  height: 5.0,
                                  child: SvgPicture.string(
                                    snapshot.data!,
                                    fit: BoxFit.scaleDown,
                                    colorFilter:
                                        kebabPlace.status == 'zamknięte'
                                            ? const ColorFilter.mode(
                                                Colors.blueGrey,
                                                BlendMode.srcIn,
                                              )
                                            : kebabPlace.status == 'planowane'
                                                ? const ColorFilter.mode(
                                                    Colors.deepPurple,
                                                    BlendMode.srcIn,
                                                  )
                                                : null,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: theme.cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: SvgPicture.asset(
                        'assets/kebab.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.blueGrey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text('Zamknięte',
                        style:
                            TextStyle(color: theme.textTheme.bodyLarge?.color)),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: SvgPicture.asset(
                        'assets/kebab.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.deepPurple,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text('Planowane',
                        style:
                            TextStyle(color: theme.textTheme.bodyLarge?.color)),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: SvgPicture.asset(
                        'assets/kebab.svg',
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text('Otwarte',
                        style:
                            TextStyle(color: theme.textTheme.bodyLarge?.color)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
