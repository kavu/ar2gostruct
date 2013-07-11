# Ar2gostruct

Automatically generate Golang Struct from your activerecord models.

Installation
---

Install GMO as a gem:
```bash
gem install ar2gostruct
```

or add to your Gemfile:
```ruby
# Gemfile
gem "ar2gostruct"
```
and run bundle install to install the dependency.

Usage
---

On your rails directory.
```bash
bundle exec ar2gostruct
```
this will puts
```bash
// app/models/users.rb
// Table name: users
type Users struct {
  Id                     int32          'json:"id"'
  Email                  string         'json:"email"'
  EncryptedPassword      string         'json:"encrypted_password"'
  ResetPasswordToken     string         'json:"reset_password_token"'
  ResetPasswordSentAt    time.Time      'json:"reset_password_sent_at"'
  RememberCreatedAt      time.Time      'json:"remember_created_at"'
  SignInCount            int32          'json:"sign_in_count"'
  CurrentSignInAt        time.Time      'json:"current_sign_in_at"'
  LastSignInAt           time.Time      'json:"last_sign_in_at"'
  CurrentSignInIp        string         'json:"current_sign_in_ip"'
  LastSignInIp           string         'json:"last_sign_in_ip"'
  CreatedAt              time.Time      'json:"created_at"'
  UpdatedAt              time.Time      'json:"updated_at"'
}
```

If you're using [qbs](https://github.com/coocood/qbs#), Additional options are available.

```bash
bundle exec ar2gostruct -o qbs

// app/models/users.rb
// Table name: users
type Users struct {
  Id                     int32          'json:"id" qbs:"pk,notnull"'
  Email                  string         'json:"email" qbs:"notnull,default:''"'
  EncryptedPassword      string         'json:"encrypted_password" qbs:"notnull,default:''"'
  ResetPasswordToken     string         'json:"reset_password_token"'
  ResetPasswordSentAt    time.Time      'json:"reset_password_sent_at"'
  RememberCreatedAt      time.Time      'json:"remember_created_at"'
  SignInCount            int32          'json:"sign_in_count" qbs:"default:'0'"'
  CurrentSignInAt        time.Time      'json:"current_sign_in_at"'
  LastSignInAt           time.Time      'json:"last_sign_in_at"'
  CurrentSignInIp        string         'json:"current_sign_in_ip"'
  LastSignInIp           string         'json:"last_sign_in_ip"'
  CreatedAt              time.Time      'json:"created_at"'
  UpdatedAt              time.Time      'json:"updated_at"'
  RoleId                 int8           'json:"role_id" qbs:"notnull,default:'1'"'
}

```

Contributing
---

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request