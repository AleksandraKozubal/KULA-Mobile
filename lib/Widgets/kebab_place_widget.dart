import 'package:flutter/material.dart';
import 'package:kula_mobile/Data/Data_sources/kebab_place_data_source.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';
import 'package:kula_mobile/Data/Repositories/kebab_place_repository_impl.dart';

class KebabPlaceWidget extends StatelessWidget {
  const KebabPlaceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Kebab Places'),
      ),
      body: Center(
        child: FutureBuilder<List<KebabPlaceModel>>(
            future: KebabPlaceRepositoryImpl(KebabPlaceDataSource()).getKebabPlaces(),
            builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No kebab places found');
            } else {
            return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
            final kebabPlace = snapshot.data![index];
            return ListTile(
            title: Text(kebabPlace.name),
            subtitle: Text(kebabPlace.street),
            );
            },
            );
            }
            },
        ),
      ),
    );
  }
}