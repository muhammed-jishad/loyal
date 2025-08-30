class Branch {
  final int code;
  final String description;
  final String arabicDescription;

  Branch(
      {required this.code,
      required this.description,
      required this.arabicDescription});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      code: json['code'],
      description: json['description'],
      arabicDescription: json['arabicDescription'],
    );
  }
}

class Flyer {
  final String path;
  final String description;
  final String fname;
  final String fthumb;

  	

  Flyer({required this.path, required this.description, required this.fname,required this.fthumb});

  factory Flyer.fromJson(Map<String, dynamic> json) {
    return Flyer(
        path: json['path'],
        description: json['description'],
        fname: json['fname'],
        fthumb: json['fthumb'],
        );
  }
}
