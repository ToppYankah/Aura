import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/aqi_util.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/section_card_title.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/screens/aqi_details_screen/widgets/aqi_status_definition.dart';
import 'package:aura/ui/screens/aqi_details_screen/widgets/aqi_status_range.dart';
import 'package:aura/ui/screens/home_screen/widgets/aqi_graph/aqi_graph.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class AQIDetailsScreen extends StatelessWidget {
  const AQIDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyBuilder: (theme, isDark) {
        return Column(
          children: [
            const SafeArea(
                bottom: false, child: AppHeader(title: "Air Quality Index")),
            Expanded(
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  SectionCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0)
                          .copyWith(top: 20),
                      child: Row(
                        children: [
                          AQIGraph(
                            size: MediaQuery.of(context).size.width * 0.25,
                            thickness: 8,
                            textSize: 45,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Transform.translate(
                                offset: const Offset(0, -10),
                                child: Wrap(
                                  spacing: 10,
                                  direction: Axis.vertical,
                                  children: _generateRanges(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SectionCard(
                    title: const SectionCardTitle("What is AQI?",
                        icon: Icons.question_mark_outlined),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20)
                          .copyWith(bottom: 20),
                      child: Text(
                        "Air Quality Index, short handed as AQI, is an index for reporting daily air quality. It tells you how clean or polluted your air is, and what ssociated health effects might be concern for you.",
                        style: TextStyle(
                            color: theme.paragraphDeep,
                            height: 1.5,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  SectionCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    title: const SectionCardTitle("Color Definitions",
                        icon: IconlyLight.category),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20)
                          .copyWith(bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            "The following are meanings to all the colours that define each range of the Air Quality Index.",
                            style: TextStyle(
                                color: theme.paragraphDeep,
                                height: 1.5,
                                fontSize: 16),
                          ),
                          Column(
                            children: _generateDefinitions(theme.paragraph!),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SectionCard(
                    title: const SectionCardTitle("Want to learn more?",
                        icon: IconlyLight.category),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20)
                          .copyWith(bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            "Follow the link below to read more about Air Quality Index on the United States Environmental Protection Agency (US EPA) website for free.",
                            style: TextStyle(
                                color: theme.paragraphDeep,
                                height: 1.5,
                                fontSize: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: AppTextButton(
                              paddingSpace: 20,
                              text: "Learn More",
                              enableBackground: true,
                              icon: EvaIcons.arrowForward,
                              onTap: () => Navigation.openWebView(
                                context,
                                const NavigationParams(
                                  argument: ExternalLinks.AQIWebsite,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        );
      },
    );
  }

  List<Widget> _generateRanges() {
    List<Widget> output = [];

    for (var status in AQIUtil.statuses) {
      output.add(StatusRange(status: status));
    }

    return output;
  }

  List<Widget> _generateDefinitions(Color textColor) {
    List<Widget> output = [];

    for (var status in AQIUtil.statuses) {
      output.add(StatusDefinition(status: status, textColor: textColor));
    }

    return output;
  }
}
