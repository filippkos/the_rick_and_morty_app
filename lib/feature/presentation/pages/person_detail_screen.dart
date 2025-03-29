import 'package:flutter/material.dart';
import 'package:the_rick_and_morty_app/common/app_colors.dart';
import 'package:the_rick_and_morty_app/feature/domain/entities/person_entity.dart';
import 'package:the_rick_and_morty_app/feature/presentation/widgets/person_cache_image_widget.dart';

class PersonDetailPage extends StatelessWidget {
  final PersonEntity person;

  const PersonDetailPage({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Character')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24),
            Text(
              person.name,
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12),
            Container(
              child: PersonCacheImage(
                imageUrl: person.image,
                width: 260,
                height: 260,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: person.status == 'Alive' ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  person.status,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(height: 16),
            if (person.type.isNotEmpty) _buildText('Type', person.type),
            _buildText('Gender', person.gender),
            _buildText('Number Of Episodes', person.episode.length.toString()),
            _buildText('Species', person.species),
            _buildText('Last known location', person.location?.name ?? ''),
            _buildText('Origin', person.origin?.name ?? ''),
            _buildText('Was created', person.created.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Text(text, style: TextStyle(color: AppColors.greyColor)),
          Text(value, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
