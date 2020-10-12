import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:weatherapp/search/bloc/search_bloc.dart';

class SearchsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        print(state);
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    border: InputBorder.none,
                    hintText: 'Enter a city...'),
                onFieldSubmitted: (value) {
                  context.bloc<SearchBloc>().add(SearchFetchEvent(value));
                },
              ),
              SearchListView()
            ],
          ),
        ),
      ),
    );
  }
}

class SearchListView extends StatelessWidget {
  List<City> _cities = List();
  List<Weather> _weathers = List();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      if (state is SearchLoadSuccess) {
        _cities = state.cities;
        _weathers = state.weather;
        context.bloc<SearchBloc>().add(SearchEvent());
      }
      return Expanded(
          child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              separatorBuilder: (context, index) => Divider(
                    color: Colors.grey,
                  ),
              padding: const EdgeInsets.all(8),
              itemCount: _cities.length,
              itemBuilder: (BuildContext context, int index) {
                return SearchTile(_cities[index], _weathers);
              }));
    }, buildWhen: (previous, current) {
      return previous != current;
    });
  }
}

class SearchTile extends StatelessWidget {
  final City _city;
  final List<Weather> _weathers;

  SearchTile(this._city, this._weathers);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: RichText(
          text: TextSpan(children: [
        WidgetSpan(
            child: Icon(
          Icons.location_city,
          color: Colors.grey,
        )),
        TextSpan(
          text: '  ',
        ),
        TextSpan(text: _city.name, style: TextStyle(color: Colors.black)),
        TextSpan(
            text: ', ' + _city.country, style: TextStyle(color: Colors.black)),
      ], style: TextStyle(fontSize: 18))),
      onTap: () {
        if (_weathers
            .where((element) => element.city.id == _city.id)
            .isNotEmpty) {
          context
              .bloc<SearchBloc>()
              .add(SearchUnsubscribeEvent(cityId: _city.id));
        } else {
          context
              .bloc<SearchBloc>()
              .add(SearchSubscribeEvent(cityId: _city.id));
        }
      },
      trailing: Visibility(
        visible: _weathers
            .where((element) => element.city.id == _city.id)
            .isNotEmpty,
        child: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }
}
