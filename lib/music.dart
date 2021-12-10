import 'package:flutter/cupertino.dart';

class Music {
  int id;
  String name;
  AssetImage picture;
  String soundLink;
  String author;

  Music(this.id, this.name, this.soundLink, this.picture, this.author);

  
  
  @override
  String toString() {
    return '#' + id.toString() + ' - '+ name + ' | ' + author;
  }
}