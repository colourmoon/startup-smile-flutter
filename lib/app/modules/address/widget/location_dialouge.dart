import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../data/model/prediction_model.dart';
import '../../../../utils/constant.dart';
import '../controller/address_controller.dart';

class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController? mapController;
  const LocationSearchDialog({super.key, @required this.mapController});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Container(
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: double.infinity,
          child: TypeAheadField<PredictionModel>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _controller,
              textInputAction: TextInputAction.search,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: 'SEARCH_LOCATION'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(style: BorderStyle.none, width: 0),
                ),
                hintStyle: fontRegular,
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              style: fontRegular,
              onChanged: (value) async {
                // Optional: For real-time updates
                await Get.find<AddressController>()
                    .searchLocation(context, value);
              },
            ),
            suggestionsCallback: (pattern) async {
              return await Get.put(AddressController())
                  .searchLocation(context, pattern);
            },
            itemBuilder: (context, PredictionModel suggestion) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    Expanded(
                      child: Text(
                        suggestion.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: fontRegular,
                      ),
                    ),
                  ],
                ),
              );
            },
            onSuggestionSelected: (PredictionModel suggestion) async {
              Position position = await Get.find<AddressController>()
                  .setLocation(suggestion.placeId!, suggestion.description!,
                      mapController!);
              Get.back(result: position);
            },
          ),
        ),
      ),
    );
  }
}
