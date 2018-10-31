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

##Criar hospitais `[POST] /hospital

``` 
{
    "name": "HOSPITAL ALBERT EINSTEIN",
    "address": 1
}
```

ou

``` 
{
    "name": "HOSPITAL ALBERT EINSTEIN",
    "address": {
        "address": "string",
        "neighborhood": "string",
        "state": "string",
        "number": "string",
        "complement": "",
        "zipcode": ""
    }
}
```

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
    }
]
```


## Atualizar hospitais `[PUT] /hospital/{id}

``` 
{
    "name": "HOSPITAL ALBERT EINSTEIN",
    "address": 1
}
```

ou

``` 
{
    "name": "HOSPITAL ALBERT EINSTEIN",
    "address": {
        id: 1,
        data: {
            "address": "string",
            "neighborhood": "string",
            "state": "string",
            "number": "string",
            "complement": "",
            "zipcode": ""
        }
    }
}
```

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
    }
]
```


## Deletar hospitais `[DELETE] /hospital/{id}

### Resposta
``` 
1 | 0
```


## usuario nos hospitais `[POST] /hospital/user

``` 
{
    "user": id,
    "hospital": id
}
```

### Resposta
``` 
{
    "id": 1,
    "user_id": 1,
    "hospital_id": 1,
    "updatedAt": "2018-10-27T21:46:38.464Z",
    "createdAt": "2018-10-27T21:46:38.464Z",
    "deletedAt": null
}
```


## usuario nos hospitais `[GET] /medical/category



### Resposta
``` 
[
    {
        "id": 1,
        "name": "Clinico geral",
        "createdAt": "2018-10-31T18:58:53.657Z",
        "updatedAt": "2018-10-31T18:58:53.657Z",
        "deletedAt": null
    }
]
```


## cadastrar category medical `[POST] /medical/category



### Enviar
``` 
    {
        "name": "bakbakbka"
    }
```


### Resposta
``` 
{
    "id": 2,
    "name": "bakbakbka",
    "updatedAt": "2018-10-31T23:57:11.231Z",
    "createdAt": "2018-10-31T23:57:11.231Z",
    "deletedAt": null
}
```


## Listar todas as roles `[GET] /role



### Resposta
``` 
[
    {
        "id": 1,
        "name": "ADMIN",
        "createdAt": "2018-10-31T20:02:23.724Z",
        "updatedAt": "2018-10-31T20:02:23.724Z",
        "deletedAt": null,
        "actions": [
            {
                "id": 1,
                "name": "create-user",
                "roles_has_actions": {
                    "id": 1,
                    "action_id": 1,
                    "role_id": 1,
                    "createdAt": "2018-10-31T20:02:24.040Z",
                    "updatedAt": "2018-10-31T20:02:24.040Z",
                    "deletedAt": null
                }
            }
        ]
    },
    {
        "id": 2,
        "name": "Atendente",
        "createdAt": "2018-10-31T20:02:23.747Z",
        "updatedAt": "2018-10-31T20:02:23.747Z",
        "deletedAt": null,
        "actions": []
    },
    {
        "id": 5,
        "name": "eliterafapg97@gmail.com.br",
        "createdAt": "2018-10-31T23:06:04.199Z",
        "updatedAt": "2018-10-31T23:06:29.416Z",
        "deletedAt": null,
        "actions": []
    },
    {
        "id": 4,
        "name": "Médico",
        "createdAt": "2018-10-31T20:02:23.749Z",
        "updatedAt": "2018-10-31T20:02:23.749Z",
        "deletedAt": null,
        "actions": []
    },
    {
        "id": 3,
        "name": "Enfermeiro",
        "createdAt": "2018-10-31T20:02:23.748Z",
        "updatedAt": "2018-10-31T20:02:23.748Z",
        "deletedAt": null,
        "actions": []
    }
]
```

## ver actions `[GET] /action


### Resposta
``` 

   [
    {
        "id": 1,
        "name": "create-user",
        "createdAt": "2018-10-31T20:02:23.751Z",
        "updatedAt": "2018-10-31T20:02:23.751Z",
        "deletedAt": null
    }
    ]
```


## ver role `[GET] /role/{id}



### Resposta
``` 

    {
        "id": 1,
        "name": "ADMIN",
        "createdAt": "2018-10-31T20:02:23.724Z",
        "updatedAt": "2018-10-31T20:02:23.724Z",
        "deletedAt": null,
        "actions": [
            {
                "id": 1,
                "name": "create-user",
                "roles_has_actions": {
                    "id": 1,
                    "action_id": 1,
                    "role_id": 1,
                    "createdAt": "2018-10-31T20:02:24.040Z",
                    "updatedAt": "2018-10-31T20:02:24.040Z",
                    "deletedAt": null
                }
            }
        ]
    }
```


## cadastrar role `[POST] /role



### Enviar
``` 

    {
        "name": "ADMIN",
    }
```


### Resposta
``` 
    {
        "id": 1,
        "name": "ADMIN",
        "createdAt": "2018-10-31T20:02:23.724Z",
        "updatedAt": "2018-10-31T20:02:23.724Z",
        "deletedAt": null,
    }
```

## atualizar role `[PUT] /role/{id}



### Enviar
``` 
    {
        "name": "ADMIN",
    }
```


### Resposta
``` 
    {
        "id": 1,
        "name": "ADMIN",
        "createdAt": "2018-10-31T20:02:23.724Z",
        "updatedAt": "2018-10-31T20:02:23.724Z",
        "deletedAt": null,
    }
```

## cadastrar action na role `[POST] /role/action/



### Enviar
``` 
    {
        "action_id": 1,
        "role_id": 5
    }
```


### Resposta
``` 
    {
        "id": 3,
        "action_id": 1,
        "role_id": 5,
        "updatedAt": "2018-10-31T23:33:25.735Z",
        "createdAt": "2018-10-31T23:33:25.735Z",
        "deletedAt": null
    }
```

## remover action na role `[DELETE] /role/action/



### Enviar
``` 
    {
        "action_id": 1,
        "role_id": 5
    }
```


### Resposta
``` 
    1|0
```

## cadastrar user na role `[POST] /role/user/



### Enviar
``` 
    {
        "user_id": 1,
        "role_id": 5
    }
```


### Resposta
``` 
    {
        "id": 3,
        "user_id": 1,
        "role_id": 5,
        "updatedAt": "2018-10-31T23:33:25.735Z",
        "createdAt": "2018-10-31T23:33:25.735Z",
        "deletedAt": null
    }
```

## remover action na role `[DELETE] /role/user/



### Enviar
``` 
    {
        "user_id": 1,
        "role_id": 5
    }
```


### Resposta
``` 
    1|0
```