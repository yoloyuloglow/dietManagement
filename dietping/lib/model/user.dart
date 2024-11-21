class User{
  //int user_idx;
  var user_id;
  var user_name;
  var user_email;
  var user_password;
  var user_nickname;
  int user_age;

  User(this.user_id,  this.user_name, this.user_email, this.user_password,this.user_nickname, this.user_age);

  factory User.fromJson(Map<String, dynamic> json) => User(
    //int.parse(json['idx']),
    json['id'] ?? 'unknown',
    json['name'] ?? 'unknown',
    json['email'] ?? 'unknown',
    json['password'] ?? 'unknown',
    json['nickname'] ?? 'unknown',
    json['age'] ?? 0,
  );

  Map<String, dynamic> toJson()=> { // 키네임 , 밸류값
    //'idx' : user_idx.toString(),
    'id' : user_id,
    'name' : user_name,
    'email' : user_email,
    'password' : user_password,
    'nickname' : user_nickname,
    'age' : user_age
  };
}