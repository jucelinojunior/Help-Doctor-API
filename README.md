# Help Doctor API
API para consumo do help doctor

# Endpoints

## Autorização `[POST] /oauth/authorization`

Rota resposnável por fazer a autorização do usuário, com ela você recebe um token de autorização.

## Parametros

Os parametros deverá ser passado via post, nos fields

### Parametros na QUERY

|   Parametro  |    Descrição  |     Tipo    |  Obrigatório |
|--------------|---------------|-------------|--------------|
|`grant_type`  |  Tipo de autorização de a cordo como a especificação do oauth2| `string` |  `true` |

### Parametros com requisição via `form-data` ou `x-www-form-urlencodes`

|   Parametro | Descrição | Tipo  | Obrigatório |
|-------------|-----------|-------|-------------|
|`username`  |  O usuário da aplicação| `string` |  `true` |
|`password`  |  A senha do usuário | `string` |  `true` |


### Exemplo Curl
```
 POST /oauth/authorization HTTP/1.1

 Host: authorization-server.com.br
 &grant_type=password

```

### Exemplo CURL

```curl
curl -X POST -F 'username=admin@helpdoctor.com.br' -F 'password=123' authorization-server.com.br&grant_type=password
```

> Para logar no sistema, existe um usuário teste que é username: `admin@helpdoctor.com.br` e `password` sucesso1029


### Erros possíveis

| Status Code |     Error    |  Message  |  Motivo   |
|-------------|--------------|-----------|-----------|
|   `401`       | `Unauthorized` |  `Failed to authenticate` | O usuário forneceu credenciais inválidas |
| `400` | `Bad Request` | `child \"password\" fails because [\"password\" is required]` | Dentro do payload não foi fornecido uma senha |
| `400` | `Bad Request` | `child \"username\" fails because [\"password\" is required]` | Dentro do payload não foi fornecido um usuário |
| `400` | `Bad Request` | `"child \"username\" fails because [\"username\" must be a valid email]` | O usuário passado passou um email valido |
| `400` | `Bad Request` | `grant_type is required` | Não foi passado um grant_type na query |
| `400` | `Bad Request` | `grant_type must be password value` | o `grant_type` passado não é um `grant_type` válido. Ele só aceita o valor `password` |
| `500` | `Internal Server Error` | `An internal server error occurred` | Ocorreu um erro de implementação no servidor, nesse caso você deve ver o log do servidor |



