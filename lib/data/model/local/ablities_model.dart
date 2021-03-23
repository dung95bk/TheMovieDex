import 'dart:core';

class AbilitiesModel {
   int id = 0;
   String text = "";
   String icon = "";
   String description = "";
   String link = "";
   bool isLeft = true;
   bool isExpanded = false;

   AbilitiesModel();

  AbilitiesModel.fromData(this.text, this.icon, this.description, this.link, this.isLeft);
}