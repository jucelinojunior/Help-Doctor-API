# Help Doctor API
API para consumo do help doctor

# Endpoints
## Carga automática `[GET] /init`
Rota responsavel por criar as tabelas e preencher os dados

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

## Inserir paciente na fila `[POST] /queue`

### Post

``` 
    {id: int}
``` 

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

### Resposta

```
    [{
        "id": 1,
        "name": "afraates",
        "personal_document": "13650671816",
        "email": "afraates@gmail.com",
        "birthday": "1962-07-06T03:00:00.000Z",
        "address_id": 85,
        "genre": "M",
        "phonenumber": "(11) 99620-2147",
        "createdAt": "2018-10-19T22:14:03.054Z",
        "updatedAt": "2018-10-19T22:14:03.054Z",
        "deletedAt": null,
        "severity": 1,
        "appointment_id": 1,
        "start": "2018-10-20T04:41:04.192Z",
        "queue_id": 4,
        "neednow": 1 //parametro para prioridade da fila, quanto menor, maior a prioridade, já vem ordernado por maior prioridade
    }]
```


##Listar hospitais `[GET] /hospital

|   Parametro Query |    Descrição  |     Tipo  
|--------------|---------------|-------------|
|`name`  |  Buscar por nome | `String` |
|`address`  |  Buscar por endereço | `String` |

passar um ou outro, opcional

### Resposta
``` 
[
    {
        "id": 1,
        "name": "HOSPITAL ALBERT EINSTEIN",
        "address": 1,
        "createdAt": "2018-10-20T18:56:02.620Z",
        "updatedAt": "2018-10-20T18:56:02.620Z",
        "deletedAt": null,
        "address_info": [
            {
                "id": 1,
                "formatedaddress": "Avenida Alet Einstein, 627 Moumi | São Paulo Telefone: (11) 2151-1233"
            }
        ]
    }
]
```




