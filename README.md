### Для запуска:

1. `git clone git@github.com:Stakulik/json_api_on_rack.git`
2. `cd json_api_on_rack`
3. `bundle install`
4. запускаем `bundle exec rackup bin/config.ru`, для запуска на своем порту добавляем ` -p 1234`
5. работаем с `localhost:9292`, 9292 - порт по умолчанию

### Тестирование

`bundle exec rspec`

### Задание:

Реализовать JSON API, используя для роутинга только rack.
Хранилище данных на свое усмотрение (в памяти, в файловой системе, в редисе, в постгресе, ...).
Приложение должно отвечать на 3 запроса:

1) POST /users
Принимает json вида:
```json
{
  "email": "john@example.com"
}
```
email обязателен, проверяется на формат и уникальность. Ошибка возвращается с соответствующим кодом (email_missing, email_already_exists, wrong_email_format)

Возвращает:
```json
{
  "data": {
    "id": "2ea550bc-705c-4702-b6d0-831919a33e5c",
    "email": "john@example.com"
  }
}
```

2) GET /users
Возвращает список созданных пользователей:
```json
{
  "data": [
    {
      "id": "2ea550bc-705c-4702-b6d0-831919a33e5c",
      "email": "john@example.com"
    }
  ]
}
```

3) GET /users/:id
Возвращает пользователя по id:
```json
{
  "data": {
    "id": "2ea550bc-705c-4702-b6d0-831919a33e5c",
    "email": "john@example.com"
  }
}
```

* На все остальные запросы возвращается 404 с кодом not_found
