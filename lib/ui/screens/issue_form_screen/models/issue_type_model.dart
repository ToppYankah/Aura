import 'package:flutter/material.dart';

enum IssueType { bug, question, featureRequest, documentation, other }

class IssueTypeData {
  final String name;
  final IconData icon;
  final IssueType type;

  IssueTypeData({required this.icon, required this.name, required this.type});
}
