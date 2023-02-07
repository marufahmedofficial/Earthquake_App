import 'package:earthquake_app/providers/earthquake_provider.dart';
import 'package:earthquake_app/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? magnitudeValue;

  late EarthquakeProvider provider;
  bool isFirst = true;
  String? _fromDate;
  String? _toDate;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      provider = Provider.of<EarthquakeProvider>(context);
      _getData();

      isFirst = false;
    }

    super.didChangeDependencies();
  }

  _getData() async {
    try {
      provider.getEarthquakeData();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Earthquake List",style: TextStyle(color: Colors.redAccent),),
        centerTitle: true,
        backgroundColor: Colors.white60,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: _showFromDatePicker,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.deepOrange),
                      alignment: Alignment.center,
                      height: 60,
                      child: Text(
                        _fromDate == null ? "From" : _fromDate.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: _showToDatePicker,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.deepOrange),
                      alignment: Alignment.center,
                      height: 60,
                      child: Text(
                        _toDate == null ? "To" : _toDate.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Card(
                  elevation: 5,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.deepOrange),
                    alignment: Alignment.center,
                    height: 60,
                    child: DropdownButton(
                      alignment: Alignment.center,
                      hint: const Text(
                        "0",
                        style: TextStyle(color: Colors.white),
                      ),
                      underline: Container(),
                      borderRadius: BorderRadius.circular(20),
                      dropdownColor: Colors.deepOrange,
                      value: magnitudeValue,
                      icon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                      items: provider.magnitudeList.map((items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Center(child: Text(items.toString())),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          magnitudeValue = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Card(
                  child: InkWell(
                    onTap: () {
                      provider.setNewData(_fromDate.toString(),
                          _toDate.toString(), magnitudeValue.toString());
                      provider.getEarthquakeData();
                    },
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.deepOrange),
                      alignment: Alignment.center,
                      height: 60,
                      child: const Text(
                        "Go",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          provider.earthquakeModel != null
              ? Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      itemCount: provider.earthquakeModel!.features!.length,
                      itemBuilder: (context, index) {
                        final model =
                            provider.earthquakeModel!.features![index];
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 8),
                            tileColor: Theme.of(context).primaryColor,
                            leading: Card(

                              child: Container(
                                height: 60,
                                alignment: Alignment.center,
                                width: 60,
                                decoration: const BoxDecoration(color: Colors.white),
                                child: Text(
                                  model.properties!.mag.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            title: Text(
                              model.properties!.place == null
                                  ? "No place"
                                  : "${model.properties!.place}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              getFormattedDate(
                                model.properties!.time!,
                              ),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        );
                      }))
              : const Text("No data found"),
        ],
      ),
    );
  }

  void _showFromDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now());

    if (selectedDate != null) {
      setState(() {
        _fromDate = DateFormat("yyyy-MM-dd").format(selectedDate);
      });
    }
  }

  void _showToDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now());

    if (selectedDate != null) {
      setState(() {
        _toDate = DateFormat("yyyy-MM-dd").format(selectedDate);
      });
    }
  }


}
