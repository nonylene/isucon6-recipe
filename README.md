# set up

- bundle

```sh
$ bundle install
```

- Set password in `config.rb` (See `config.rb.example`)

```sh
$ gem install unix-crypt
$ mkunixcrypt
```

# dry-run

```sh
$ bundle exec itamae ssh -h {HOST} -u {USER} -n recipe.rb
```

# deploy

```sh
$ bundle exec itamae ssh -h {HOST} -u {USER} recipe.rb
```
