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

## [GET] Listar todos os usuários dos sistema `/user/all`

Rota responsável por listar todos os usuários
> Essa Rota requer que o JWT usado tenha permissão de `user.all` 

### Response

```json
[
    {
        "id": 1,
        "name": "Administrador",
        "email": "admin@helpdoctor.com.br",
        "personal_document": "12345678923",
        "salt": "$2a$10$VfGHHzlP0BjjbHWWpg4BhO",
        "addressId": 1,
        "password": "$2a$10$VfGHHzlP0BjjbHWWpg4BhOR/zhjeDbmWjnAgNbvN7omojJMHtnw9a",
        "birthday": "1980-01-01T02:00:00.000Z",
        "genre": "M",
        "responsable_hospital": null,
        "createdAt": "2018-10-12T20:36:33.580Z",
        "updatedAt": "2018-10-12T20:36:33.580Z",
        "deletedAt": null,
        "roles": [
            {
                "id": 1,
                "name": "ADMIN",
                "actions": [
                    {
                        "id": 1,
                        "name": "user.create"
                    },
                    {
                        "id": 2,
                        "name": "user.all"
                    }
                ]
            }
        ],
        "address": {
            "id": 1,
            "address": "Rua teste",
            "formatedaddress": null
        },
        "hospitals": [
            {
                "name": "Hospital teste",
                "address": 1
            }
        ]
    }
]
```

### Erros Possíveis

| Status Code |     Error    |  Message  |  Motivo   |
|-------------|--------------|-----------|-----------|
| `403`       |   `Forbidden`|  `Insufficient scope` | O Usuário não possui a action `user.all` no JWT |

---

## Criar usuário `[POST] /user`

Cria o usuário

### Payload 
```json 
{
  "name": "Guilherme",
  "email": "guiihpr@gmail.com",
  "password": "123",
  "personal_document": "12345678998",
  "addressId": 1,
  "birthday": "1994-03-13",
  "roles_id": ["1"],
  "genre": "M"
  }
```

### Atributos

| Atributo | Tipo | Obrigatório | Descrição |
|-----------|------|------|-----------|
|`name`| `string` |`true` | Nome do usuário |
|`email`| `string` | `true` | Email do usuário |
|`password`| `string` | `true` | Senha do usuário, a principio não tem nenhuma validação de minimo de caracteres |
|`personal_document`| `string` | `true` | CPF do usuário |
|`birthday`| `date` | `true` | Data de aniversário do usuário |
|`roles_id`| `array` | `true` | uma lista de roles que o usuário vai ter |
|`genre`| `string` | `true` | Sexo do usuário |



### Erros Possíveis

| Status Code |     Error    |  Message  |  Motivo   |
|-------------|--------------|-----------|-----------|
| `403`       |   `Bad Request`|  `CPF Invalido` | O CPF passado é um CPF inválido |

----

## reset da senha `[POST] /user/reset


na API, precisa ver a rota para colocar o e-mail de envio

### Enviar
``` 
    {
        "email": "1"
    }
```

### Resposta
```
    usuario: object
```

