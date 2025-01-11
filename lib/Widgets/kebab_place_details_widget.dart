import 'package:flutter/material.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kula_mobile/Data/Repositories/filling_repository_impl.dart';
import 'package:kula_mobile/Data/Repositories/sauce_repository_impl.dart';
import 'package:kula_mobile/Widgets/badge_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();
    fillingsFuture = _getFillings();
    saucesFuture = _getSauces();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kebabPlace.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.kebabPlace.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          rating:
                              double.parse(widget.kebabPlace.googleMapsRating!),
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
                      text: 'Craft',
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (widget.kebabPlace.openedAtYear != null) ...[
                    BadgeWidget(
                      text: 'Since ${widget.kebabPlace.openedAtYear}',
                      color: Colors.deepOrangeAccent,
                    ),
                    const SizedBox(width: 8),
                  ],
                  BadgeWidget(
                    text: widget.kebabPlace.isChainRestaurant == true
                        ? 'Restauracja'
                        : 'Food Truck',
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (widget.kebabPlace.phone != null) ...[
                Row(
                  children: [
                    Icon(Icons.phone, color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _launchURL('tel:${widget.kebabPlace.phone}'),
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
                    Icon(Icons.web, color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _launchURL(widget.kebabPlace.website!),
                      child: Text(
                        widget.kebabPlace.website!,
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
                    Icon(Icons.email, color: Theme.of(context).iconTheme.color),
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
                                'Could not send email to: ${widget.kebabPlace.email}',
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
              ],
              if (widget.kebabPlace.openingHours.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('Godziny otwarcia:', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Table(
                  children: widget.kebabPlace.openingHours.map((hours) {
                    return TableRow(
                      children: [
                        Text(hours['day']),
                        Text('${hours['from']} - ${hours['to']}'),
                      ],
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 8),
              FutureBuilder<Map<int, Map<String, String?>>>(
                future: fillingsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                            'Dostępne nadzienia:',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            children:
                                widget.kebabPlace.fillings.map((fillingId) {
                              final filling = fillingsMap[int.parse(fillingId)];
                              final fillingName = filling?['name'] ?? 'Unknown';
                              final fillingColor = filling?['hexColor'] != null
                                  ? Color(int.parse(
                                          filling!['hexColor']!.substring(1, 7),
                                          radix: 16) +
                                      0xFF000000)
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                            children: widget.kebabPlace.sauces.map((sauceId) {
                              final sauce = saucesMap[sauceId];
                              final sauceName = sauce?['name'] ?? 'Unknown';
                              final sauceColor = sauce?['hexColor'] != null
                                  ? Color(int.parse(
                                          sauce!['hexColor']!.substring(1, 7),
                                          radix: 16) +
                                      0xFF000000)
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
      ),
    );
  }
}
