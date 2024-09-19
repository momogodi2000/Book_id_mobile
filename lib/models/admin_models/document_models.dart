class Document {
  final String user;
  final String birthCertificate;
  final String proofOfNationality;
  final String passportPhotos;
  final String residencePermit;
  final String marriageCertificate;
  final String deathCertificate;
  final String swornStatement;

  Document({
    required this.user,
    required this.birthCertificate,
    required this.proofOfNationality,
    required this.passportPhotos,
    this.residencePermit = '',
    this.marriageCertificate = '',
    this.deathCertificate = '',
    this.swornStatement = '',
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      user: json['user'],
      birthCertificate: json['birth_certificate'],
      proofOfNationality: json['proof_of_nationality'],
      passportPhotos: json['passport_photos'],
      residencePermit: json['residence_permit'],
      marriageCertificate: json['marriage_certificate'],
      deathCertificate: json['death_certificate'],
      swornStatement: json['sworn_statement'],
    );
  }
}
