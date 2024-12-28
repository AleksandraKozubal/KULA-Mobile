import 'package:flutter/material.dart';
import 'package:kula_mobile/Data/Data_sources/kebab_place_data_source.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';
import 'package:kula_mobile/Data/Repositories/kebab_place_repository_impl.dart';
import 'badge_widget.dart';

class KebabPlaceWidget extends StatelessWidget {
  const KebabPlaceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Kebab Places'),
      ),
      body: FutureBuilder<List<KebabPlaceModel>>(
        future: KebabPlaceRepositoryImpl(KebabPlaceDataSource()).getKebabPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No kebab places found'));
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final kebabPlace = snapshot.data![index];
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
                        Text('${kebabPlace.street} ${kebabPlace.buildingNumber}'),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            if  (kebabPlace.isKraft!) ... [const BadgeWidget(text: 'Kraft', color: Colors.purple), const SizedBox(width: 8.0)],
                            if (kebabPlace.yearEstablished != null) ... [BadgeWidget(text: 'Since ${kebabPlace.yearEstablished}', color: Colors.orangeAccent), ]
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            );
          }
        },
      ),
    );
  }
}
