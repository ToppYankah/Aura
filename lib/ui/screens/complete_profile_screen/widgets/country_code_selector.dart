import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/ui/global_components/app_radio_button.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/app_text_field.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CountryCallCodeSelector extends StatefulWidget {
  final String selected;
  final VoidCallback onClose;
  final Function(String) onSelect;
  const CountryCallCodeSelector({
    super.key,
    required this.onSelect,
    this.selected = "+233",
    required this.onClose,
  });

  @override
  State<CountryCallCodeSelector> createState() =>
      _CountryCallCodeSelectorState();
}

class _CountryCallCodeSelectorState extends State<CountryCallCodeSelector> {
  final TextEditingController _searchController = TextEditingController();
  ValueNotifier<List<Country>> codes = ValueNotifier<List<Country>>([]);

  @override
  void initState() {
    super.initState();

    CommonUtils.performPostBuild(context, () async {
      codes.value = await getCountries(context);
    });
  }

  @override
  void dispose() {
    codes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: codes,
        builder: (context, codeList, _) {
          return Column(
            children: [
              AppTextField(
                controller: _searchController,
                placeholder: "Search Country",
                icon: Iconsax.search_normal_1,
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.6,
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: SingleChildScrollView(
                  child: ValueListenableBuilder(
                      valueListenable: _searchController,
                      builder: (context, searchValue, _) {
                        final filteredCountries = codes.value.where(
                          (e) => e.name
                              .toLowerCase()
                              .contains(searchValue.text.toLowerCase()),
                        );

                        return Column(
                          children: [
                            for (Country country in filteredCountries)
                              Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  onTap: () {
                                    widget.onSelect(country.callingCode);
                                    widget.onClose();
                                  },
                                  leading: AppTextButton(
                                    enableBackground: true,
                                    text: country.callingCode,
                                  ),
                                  title: Text(country.name),
                                  trailing: AppRadioButton(
                                    active:
                                        country.callingCode == widget.selected,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                ),
              ),
            ],
          );
        });
  }
}
