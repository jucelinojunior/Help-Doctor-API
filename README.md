# Help Doctor API
API para consumo do help doctor

# Endpoints
## Carga automática `[GET] /init`
Rota responsavel por criar as tabelas e preencher os dados

## Autorização `[POST] /oauth/authorization`

Rota resposnável por fazer a autorização do usuário, com ela você recebe um token de autorização.

## Parametros

Os parametros deverá ser passado via post, nos fields

### Post

|   Parametro  |    Descrição  |     Tipo    |  Obrigatório |
|--------------|---------------|-------------|--------------|
|`grant_type`  |  Tipo de autorização de a cordo como a especificação do oauth2| `string` |  `true` |
|`username`  |  O usuário da aplicação| `string` |  `true` |
|`password`  |  A senha do usuário | `string` |  `true` |


### Exemplo
```
 POST /oauth/authorization HTTP/1.1

 Host: authorization-server.com.br
 &grant_type=password
 &username=12345678923
 &password=mypassword
```


### Erros possíveis

| Status Code |     Error    |  Message  |  Motivo   |
|-------------|--------------|-----------|-----------|
|   `401`       | `Unauthorized` |  `Failed to authenticate` | O usuário forneceu credenciais inválidas |
| `400` | `Bad Request` | `child \"password\" fails because [\"password\" is required]` | Dentro do payload não foi fornecido uma senha |
| `400` | `Bad Request` | `child \"username\" fails because [\"password\" is required]` | Dentro do payload não foi fornecido um usuário |
| `400` | `Bad Request` | `child \"username\" fails because [\"username\" with value \"12345678\" fails to match the required pattern: /\\d{11}/]` | O usuário passado não possui um formato de CPF valido, ou seja, de 11 digitos |
| `400` | `Bad Request` | `child \"grant_type\" fails because [\"grant_type\" is required]` | Não foi passado um grant_type dentro do payload |
| `400` | `Bad Request` | `child \"grant_type\" fails because [\"grant_type\" must be one of [password]]` | o `grant_type` passado não é um `grant_type` válido. Ele só aceita o valor `password` |
| `500` | `Internal Server Error` | `An internal server error occurred` | Ocorreu um erro de implementação no servidor, nesse caso você deve ver o log do servidor |

## Inserir paciente na fila `[POST] /queue`

### Post

|   Parametro  |    Descrição  |     Tipo    |  Obrigatório |
|--------------|---------------|-------------|--------------|
|`id`  |  Enviar o ID da consulta do paciente | `integer` |  `true` |

### Resposta (OBJETO QUEUE)
```
{
    "id": 4,
    "hospital_id": 1,
    "appointment_id": 1,
    "status": 1, // 1 -> está na fila; 2 -> não está na fila
    "severity": 1, // 1-> AZUL; 2-> VERDE; 3-> AMARELO -> 4 VERMELHO
    "updatedAt": "2018-10-20T04:41:04.192Z",
    "createdAt": "2018-10-20T04:41:04.192Z",
    "deletedAt": null
}
```

## Listar fila em um hospital `[GET] /queue/hospital/{hospital_id}`

### Resposta (OBJETO QUEUE)

```
    Array: QUEUE
```

## Remover paciente da fila `[DELETE] /queue/remove/{hospital_id}`

### Resposta (OBJETO QUEUE)

```
    Objeto: APPOINTMENT
```

