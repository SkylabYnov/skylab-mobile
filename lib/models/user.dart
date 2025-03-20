class UserModel {
    final String id;
    final String name;
    final String email;
    final String? profileImageUrl;

    UserModel({
        required this.id,
        required this.name,
        required this.email,
        this.profileImageUrl,
    });

    factory UserModel.fromFirebaseUser(Map<String, dynamic> userData) {
        return UserModel(
            id: userData['uid'],
            name: userData['displayName'] ?? '',
            email: userData['email'] ?? '',
            profileImageUrl: userData['photoURL'],
        );
    }

    Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'displayName': name,
      'email': email,
      'photoURL': profileImageUrl,
    };
  }
}