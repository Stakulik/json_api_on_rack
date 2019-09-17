### Для запуска:

1. [Ставим Postman](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop) 
2. Копируем репу `git clone git@github.com:Stakulik/json_api_on_rack.git`
3. Переходим в репу и делаем `rackup config.ru`
4. Работаем с адресом `localhost:9292`


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
