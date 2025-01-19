import 'package:flutter/material.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kula_mobile/Data/Repositories/filling_repository_impl.dart';
import 'package:kula_mobile/Data/Repositories/sauce_repository_impl.dart';
import 'package:kula_mobile/Services/token_storage.dart';
import 'package:kula_mobile/Widgets/badge_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:social_media_buttons/social_media_buttons.dart';
import 'tiktok_social_media_button.dart';
import 'package:kula_mobile/Data/Repositories/favorite_repository_impl.dart';
import 'package:kula_mobile/Data/Data_sources/favorite_data_source.dart';

class KebabPlaceDetailsWidget extends StatefulWidget {
  final KebabPlaceModel kebabPlace;
  final FillingRepositoryImpl fillingRepository;
  final SauceRepositoryImpl sauceRepository;

  const KebabPlaceDetailsWidget({
    required this.kebabPlace,
    required this.fillingRepository,
    required this.sauceRepository,
    super.key,
  });

  @override
  KebabPlaceDetailsWidgetState createState() => KebabPlaceDetailsWidgetState();
}

class KebabPlaceDetailsWidgetState extends State<KebabPlaceDetailsWidget> {
  late Future<Map<int, Map<String, String?>>> fillingsFuture;
  late Future<Map<int, Map<String, String?>>> saucesFuture;
  late FavoriteRepositoryImpl favoriteRepository;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    final favoriteDataSource = FavoriteDataSource();
    favoriteRepository = FavoriteRepositoryImpl(favoriteDataSource: favoriteDataSource);
    fillingsFuture = _getFillings();
    saucesFuture = _getSauces();
    _checkLoginStatus();
    _checkIfFavorited();
  }

  Future<void> _checkLoginStatus() async {
    final token = await TokenStorage.getToken();
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  Future<void> _checkIfFavorited() async {
    if (_isLoggedIn) {
      final isFavorited = await favoriteRepository.isKebabPlaceFavorited(widget.kebabPlace.id.toString());
      setState(() {
        widget.kebabPlace.isFavorite = isFavorited;
      });
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

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      if (widget.kebabPlace.isFavorite) {
        await favoriteRepository.unfavoriteKebabPlace(widget.kebabPlace.id.toString());
      } else {
        await favoriteRepository.favoriteKebabPlace(widget.kebabPlace.id.toString());
      }
      setState(() {
        widget.kebabPlace.isFavorite = !widget.kebabPlace.isFavorite;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nie udało się zmienić statusu ulubionego kebaba'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kebabPlace.name),
        actions: [
          if (_isLoggedIn)
            IconButton(
              icon: Icon(
                widget.kebabPlace.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: _toggleFavorite,
            ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([fillingsFuture, saucesFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.kebabPlace.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.kebabPlace.address),
                    const SizedBox(height: 8),
                    if (widget.kebabPlace.googleMapsRating != null)
                      Row(
                        children: [
                          if (widget.kebabPlace.googleMapsRating != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: RatingBarIndicator(
                                rating: double.parse(
                                  widget.kebabPlace.googleMapsRating!,
                                ),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                            ),
                          Text(widget.kebabPlace.googleMapsRating!),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (widget.kebabPlace.isCraft == true) ...[
                          const BadgeWidget(
                            text: 'Kraft',
                            color: Colors.purple,
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (widget.kebabPlace.status == 'zamknięte') ...[
                          const BadgeWidget(
                            text: 'Zamknięte',
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                        ] else if (widget.kebabPlace.status == 'otwarte') ...[
                          const BadgeWidget(
                            text: 'Otwarte',
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                        ] else if (widget.kebabPlace.status == 'planowane') ...[
                          const BadgeWidget(
                            text: 'Planowane',
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (widget.kebabPlace.openedAtYear != null) ...[
                          BadgeWidget(
                            text: 'Od ${widget.kebabPlace.openedAtYear}',
                            color: Colors.deepOrangeAccent,
                          ),
                          const SizedBox(width: 8),
                        ],
                        BadgeWidget(
                          text: widget.kebabPlace.isChainRestaurant == true
                              ? 'Sieciówka'
                              : 'Lokalny Kebab',
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        BadgeWidget(
                          text:
                              widget.kebabPlace.locationType[0].toUpperCase() +
                                  widget.kebabPlace.locationType.substring(1),
                          color: Colors.blueGrey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (widget.kebabPlace.phone != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () =>
                                _launchURL('tel:${widget.kebabPlace.phone}'),
                            child: Text(
                              widget.kebabPlace.phone!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ],
                    if (widget.kebabPlace.website != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.web,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _launchURL(widget.kebabPlace.website!),
                            child: Text(
                              'Strona internetowa',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ],
                    if (widget.kebabPlace.email != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () async {
                              final emailUrl = Uri(
                                scheme: 'mailto',
                                path: widget.kebabPlace.email,
                              ).toString();
                              try {
                                await _launchURL(emailUrl);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Nie można wysłać email do: ${widget.kebabPlace.email}',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              widget.kebabPlace.email!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children:
                            widget.kebabPlace.socialMedia.map<Widget>((social) {
                          switch (social['name']) {
                            case 'fb':
                              return SocialMediaButton.facebook(
                                url: social['url']!,
                                size: 30,
                                color: Theme.of(context).iconTheme.color,
                              );
                            case 'ig':
                              return SocialMediaButton.instagram(
                                url: social['url']!,
                                size: 30,
                                color: Theme.of(context).iconTheme.color,
                              );
                            case 'x':
                              return SocialMediaButton.twitter(
                                url: social['url']!,
                                size: 30,
                                color: Theme.of(context).iconTheme.color,
                              );
                            case 'tt':
                              return TikTokSocialMediaButton(
                                url: social['url']!,
                                size: 30,
                                color: Theme.of(context).iconTheme.color ??
                                    Colors.black,
                              );
                            default:
                              return Container();
                          }
                        }).toList(),
                      ),
                    ],
                    if (widget.kebabPlace.orderOptions.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Opcje zamówienia:',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: widget.kebabPlace.orderOptions.map((option) {
                          return BadgeWidget(
                            text: option,
                            color: Colors.deepPurple,
                            solid: true,
                          );
                        }).toList(),
                      ),
                    ],
                    if (widget.kebabPlace.ios != null) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Aplikacja na iOS:',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _launchURL(widget.kebabPlace.ios!),
                        child: const BadgeWidget(
                          text: 'Pobierz na iOS',
                          color: Colors.blue,
                          solid: true,
                        ),
                      ),
                    ],
                    if (widget.kebabPlace.android != null) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Aplikacja na Androida:',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _launchURL(widget.kebabPlace.android!),
                        child: const BadgeWidget(
                          text: 'Pobierz na Androida',
                          color: Colors.green,
                          solid: true,
                        ),
                      ),
                    ],
                    if (widget.kebabPlace.openingHours.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Godziny otwarcia:',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Table(
                        children: widget.kebabPlace.openingHours.map((hours) {
                          final from = hours['from'];
                          final to = hours['to'];
                          final isClosed = from == null && to == null;
                          return TableRow(
                            children: [
                              Text(hours['day']),
                              Text(isClosed ? 'zamknięte' : '$from - $to'),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 8),
                    FutureBuilder<Map<int, Map<String, String?>>>(
                      future: fillingsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final fillingsMap = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.kebabPlace.fillings.isNotEmpty) ...[
                                const Text(
                                  'Główne składniki:',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: widget.kebabPlace.fillings
                                      .map((fillingId) {
                                    final filling = fillingsMap[fillingId];
                                    final fillingName =
                                        filling?['name'] ?? 'Unknown';
                                    final fillingColor =
                                        filling?['hexColor'] != null
                                            ? Color(
                                                int.parse(
                                                      filling!['hexColor']!
                                                          .substring(1, 7),
                                                      radix: 16,
                                                    ) +
                                                    0xFF000000,
                                              )
                                            : Colors.green;
                                    return BadgeWidget(
                                      text: fillingName,
                                      color: fillingColor,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<Map<int, Map<String, String?>>>(
                      future: saucesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final saucesMap = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.kebabPlace.sauces.isNotEmpty) ...[
                                const Text(
                                  'Dostępne sosy:',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children:
                                      widget.kebabPlace.sauces.map((sauceId) {
                                    final sauce = saucesMap[sauceId];
                                    final sauceName =
                                        sauce?['name'] ?? 'Unknown';
                                    final sauceColor =
                                        sauce?['hexColor'] != null
                                            ? Color(
                                                int.parse(
                                                      sauce!['hexColor']!
                                                          .substring(1, 7),
                                                      radix: 16,
                                                    ) +
                                                    0xFF000000,
                                              )
                                            : Colors.red;
                                    return BadgeWidget(
                                      text: sauceName,
                                      color: sauceColor,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
