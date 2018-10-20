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

## Remover paciente da fila `[DELETE] /queue/remove/{queue_id}`

### Resposta
```
    {
    	"id": 1,
	    "pronouncer_id": 1,
	    "schedule": "2011-11-18T02:00:00.000Z",
	    "type_id": 1,
	    "description": "Descrição",
	    "user_id": 1,
	    "skin_burn": 0,
	    "fever": 36,
	    "convulsion": 0,
	    "asthma": false,
	    "vomit": false,
	    "diarrhea": false,
	    "heart_attack": false,
	    "hypovolemic_shock": false,
	    "apnea": false,
	    "is_pregnant": false,
	    "medical_return": false,
	    "status": 4, //'recepção' : 1,'avaliação' : 2,'na fila': 3,'concluido': 4
	    "createdAt": "2018-10-19T22:14:03.245Z",
	    "updatedAt": "2018-10-20T04:41:04.269Z",
	    "deletedAt": null
    }
```

