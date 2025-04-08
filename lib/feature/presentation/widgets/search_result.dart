import 'package:flutter/material.dart';
import 'package:the_rick_and_morty_app/feature/domain/entities/person_entity.dart';
import 'package:the_rick_and_morty_app/feature/presentation/pages/person_detail_screen.dart';
import 'package:the_rick_and_morty_app/feature/presentation/widgets/person_cache_image_widget.dart';

class SearchResult extends StatelessWidget {
  final PersonEntity personResult;

  const SearchResult({super.key, required this.personResult});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetailPage(person: personResult),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2.0,
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: PersonCacheImage(imageUrl: personResult.image),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                personResult.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                personResult.location?.name ?? '',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
