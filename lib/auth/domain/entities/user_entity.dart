class UserEntity {
  final String? userUId;
  final String? userName;
  final String? userEmail;
  final String? userPassword;
  final String? userImage;
  final DateTime? userLastActive;
  final bool? userIsOnline;

  UserEntity({
     this.userPassword,
     this.userUId,
     this.userName,
     this.userEmail,
     this.userImage,
     this.userLastActive,
     this.userIsOnline,
  });
}
