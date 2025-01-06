import 'package:flutter/material.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kula_mobile/Widgets/badge_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diacritic/diacritic.dart';

class KebabPlaceDetailsWidget extends StatelessWidget {
  final KebabPlaceModel kebabPlace;

  const KebabPlaceDetailsWidget({required this.kebabPlace, super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Map<String, String> _parseOpeningHours(String openingHours) {
    final Map<String, String> hoursMap = {};
    final List<String> days = openingHours.split(', ');
    for (var day in days) {
      final List<String> parts = day.split(': ');
      if (parts.length == 2) {
        final key = removeDiacritics(parts[0].trim());
        hoursMap[key] = parts[1].trim();
      }
    }
    return hoursMap;
  }

  @override
  Widget build(BuildContext context) {
    final openingHoursMap = kebabPlace.openingHours != null
      ? _parseOpeningHours(kebabPlace.openingHours!)
      : {};

    return Scaffold(
      appBar: AppBar(
        title: Text(kebabPlace.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kebabPlace.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${kebabPlace.street} ${kebabPlace.buildingNumber}'),
            const SizedBox(height: 8),
            if (kebabPlace.googleMapsRating != null)
              Row(
                children: [
                  if (kebabPlace.googleMapsRating != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: RatingBarIndicator(
                        rating: double.parse(kebabPlace.googleMapsRating!),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                    ),
                  Text(kebabPlace.googleMapsRating!),
                ],
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (kebabPlace.isKraft == true) ...[
                  const BadgeWidget(
                    text: 'Kraft',
                    color: Colors.purple,
                  ),
                  const SizedBox(width: 8),
                ],
                if (kebabPlace.yearEstablished != null) ...[
                  BadgeWidget(
                    text: 'Od ${kebabPlace.yearEstablished}',
                    color: Colors.deepOrangeAccent,
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
            const SizedBox(height: 8),
            if (kebabPlace.phone != null) ... [
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => _launchURL('tel:${kebabPlace.phone}'),
                    child: Text(
                      kebabPlace.phone!,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
            if (kebabPlace.website != null) ... [
              Row(
                children: [
                  const Icon(Icons.web),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => _launchURL(kebabPlace.website!),
                    child: Text(
                      kebabPlace.website!,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
            if (kebabPlace.email != null) ... [
              Row(
                children: [
                  const Icon(Icons.email),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () async {
                      final emailUrl = Uri(
                        scheme: 'mailto',
                        path: kebabPlace.email,
                      ).toString();
                      try {
                        await _launchURL(emailUrl);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Nie można było wysłać mail do: ${kebabPlace.email}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      kebabPlace.email!,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
            if (kebabPlace.openingHours != null) ... [
              const SizedBox(height: 8),
              const Text('Godziny otwarcia:', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 8),
              Table(
                children: [
                  TableRow(
                    children: [
                      const Text('Poniedziałek - Piątek:'),
                      Text(openingHoursMap['Poniedzialek - Piatek'] ??
                          'Brak danych'),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text('Sobota:'),
                      Text(openingHoursMap['Sobota'] ?? 'Brak danych'),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text('Niedziela:'),
                      Text(openingHoursMap['Niedziela'] ?? 'Brak danych'),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
