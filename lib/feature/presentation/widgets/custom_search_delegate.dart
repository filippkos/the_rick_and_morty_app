import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_rick_and_morty_app/feature/domain/entities/person_entity.dart';
import 'package:the_rick_and_morty_app/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:the_rick_and_morty_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:the_rick_and_morty_app/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:the_rick_and_morty_app/feature/presentation/widgets/search_result.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate() : super(searchFieldLabel: 'Search for characters...');

  final _suggestions = ['Rick', 'Morty', 'Summer', 'Beth', 'Jerry'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back_outlined),
      tooltip: 'Back',
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    BlocProvider.of<PersonSearchBloc>(context, listen: false)..add(SearchPersons(query));
    return BlocBuilder<PersonSearchBloc, PersonSearchState>(
      builder: (context, state) {
        if (state is PersonSearchLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PersonSearchLoaded) {
          final persons = state.persons;
          if (persons.isEmpty) {
            return _showErrorText('No characters with this name found.');
          } 
          return Container(
            child: ListView.builder(
              itemCount: persons.isNotEmpty ? persons.length : 0,
              itemBuilder: (context, index) {
                PersonEntity result = persons[index];
                return SearchResult(personResult: result);
              },
            ),
          );
        } else if (state is PersonSearchError) {
          return _showErrorText(state.message);
        } else {
          return Center(child: Icon(Icons.now_wallpaper));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length > 0) {
      return Container();
    }
    return ListView.separated(
      padding: EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return Text(
          _suggestions[index],
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: _suggestions.length,
    );
  }

  Widget _showErrorText(String errorMessage) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          errorMessage,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
