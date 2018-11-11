# Help Doctor API
API para consumo do help doctor

<!-- TOC -->

- [Help Doctor API](#help-doctor-api)
- [Permissões do sistema](#permissões-do-sistema)
  - [Tabelas de ações](#tabelas-de-ações)
- [Usuarios do sistema](#usuarios-do-sistema)
- [Endpoints](#endpoints)
  - [Carga automática `[GET] /init`](#carga-automática-get-init)
  - [Autorização `[POST] /oauth/authorize`](#autorização-post-oauthauthorize)
  - [Parametros](#parametros)
    - [Parametros na QUERY](#parametros-na-query)
    - [Parametros com requisição via `form-data` ou `x-www-form-urlencodes`](#parametros-com-requisição-via-form-data-ou-x-www-form-urlencodes)
    - [Exemplo Curl](#exemplo-curl)
    - [Exemplo CURL](#exemplo-curl)
    - [Erros possíveis](#erros-possíveis)
  - [Listar fila em um hospital `[GET] /queue/hospital/{hospital_id}`](#listar-fila-em-um-hospital-get-queuehospitalhospital_id)
    - [Resposta](#resposta)
  - [Listar hospitais `[GET] /hospital`](#listar-hospitais-get-hospital)
    - [Resposta](#resposta-1)
  - [Ver hospital `[GET] /hospital/{id}`](#ver-hospital-get-hospitalid)
    - [Resposta](#resposta-2)
  - [Criar hospitais `[POST] /hospital`](#criar-hospitais-post-hospital)
    - [Resposta](#resposta-3)
  - [Atualizar hospitais `[PUT] /hospital/{id}`](#atualizar-hospitais-put-hospitalid)
    - [Payload](#payload)
    - [Resposta](#resposta-4)
  - [Deletar hospitais `[DELETE] /hospital/{id}`](#deletar-hospitais-delete-hospitalid)
    - [Resposta](#resposta-5)
  - [usuario nos hospitais `[POST] /hospital/user`](#usuario-nos-hospitais-post-hospitaluser)
    - [Resposta](#resposta-6)
  - [usuario nos hospitais `[GET] /medical/category`](#usuario-nos-hospitais-get-medicalcategory)
    - [Resposta](#resposta-7)
  - [cadastrar category medical `[POST] /medical/category`](#cadastrar-category-medical-post-medicalcategory)
    - [Enviar](#enviar)
    - [Resposta](#resposta-8)
  - [Listar todas as roles `[GET] /role`](#listar-todas-as-roles-get-role)
    - [Resposta](#resposta-9)
  - [ver actions `[GET] /action`](#ver-actions-get-action)
    - [Resposta](#resposta-10)
  - [ver role `[GET] /role/{id}`](#ver-role-get-roleid)
    - [Resposta](#resposta-11)
  - [cadastrar role `[POST] /role`](#cadastrar-role-post-role)
    - [Enviar](#enviar-1)
    - [Resposta](#resposta-12)
  - [atualizar role `[PUT] /role/{id}`](#atualizar-role-put-roleid)
    - [Enviar](#enviar-2)
    - [Resposta](#resposta-13)
  - [cadastrar action na role `[POST] /role/action/`](#cadastrar-action-na-role-post-roleaction)
    - [Enviar](#enviar-3)
    - [Resposta](#resposta-14)
  - [remover action na role `[DELETE] /role/action/`](#remover-action-na-role-delete-roleaction)
    - [Enviar](#enviar-4)
    - [Resposta](#resposta-15)
  - [cadastrar user na role `[POST] /role/user/`](#cadastrar-user-na-role-post-roleuser)
    - [Enviar](#enviar-5)
    - [Resposta](#resposta-16)
  - [remover action na role `[DELETE] /role/user/`](#remover-action-na-role-delete-roleuser)
    - [Enviar](#enviar-6)
    - [Resposta](#resposta-17)
  - [[GET] Listar todos os usuários dos sistema `/user`](#get-listar-todos-os-usuários-dos-sistema-user)
    - [Response](#response)
    - [Erros Possíveis](#erros-possíveis)
  - [Procurar usuario no sistema `[GET] /user/:id`](#procurar-usuario-no-sistema-get-userid)
    - [Parametros](#parametros-1)
    - [Querystring](#querystring)
    - [Exemplo Curl](#exemplo-curl-1)
    - [Erros possíveis](#erros-possíveis-1)
  - [Criar usuário `[POST] /user`](#criar-usuário-post-user)
    - [Payload](#payload-1)
    - [Atributos](#atributos)
    - [Erros Possíveis](#erros-possíveis-1)
  - [Editar usuario `[PUT] /user/:id`](#editar-usuario-put-userid)
    - [Atributos](#atributos-1)
    - [Atributos](#atributos-2)
    - [URL exemplo](#url-exemplo)
    - [Payload](#payload-2)
  - [Deletar usuario `[DELETE] /user/{id}`](#deletar-usuario-delete-userid)
    - [Parametros](#parametros-2)
  - [reset da senha `[POST] /user/reset`](#reset-da-senha-post-userreset)
    - [Enviar](#enviar-7)
    - [Resposta](#resposta-18)
  - [Listar Paciente `[GET] /patient`](#listar-paciente-get-patient)
    - [Response](#response-1)
  - [Procurar um paciente `[GET] /patient/:id](#procurar-um-paciente-get-patientid)
    - [Parametros da URL](#parametros-da-url)
    - [Response](#response-2)
  - [Editar paciente `[/PUT] /patient/:id`](#editar-paciente-put-patientid)
    - [Payload](#payload-3)
    - [Response](#response-3)
  - [Criar paciente `[POST] /patient`](#criar-paciente-post-patient)
    - [Payload](#payload-4)
    - [Response](#response-4)
  - [Deletar `[DELETE] /patient/:id`](#deletar-delete-patientid)
    - [Response](#response-5)

<!-- /TOC -->
# Permissões do sistema

Toda role possui 0 ou N actions, e toda action possui 0 ou N roles. Por exemplo, para criar um usuário, é necessário que uma das roles do usuario tenha a action `user.create`. Dessa forma para adicionar uma nova ação, é necessário adicionar a ação na role desejada.

## Tabelas de ações

| Action | Descrição | Requer action |
|--------|-----------|---------------|
|`user.create`| Permissão para a criação de novos usuarios| - |
| `user.list` | Permissão para listar os usuarios, caso o usuário só possua a `user.list` ele retorna apenas os usuarios de hospitais que ele seja responsável | - |
|`user.all`| Permissão para listar **TODOS** os usuários| `user.list` |
|`user.find`| Permissão para pesquisar usuarios | - |
|`user.update` | Permissão para editar o usuário, caso o JWT do usuario não tenha a action `user.update_all` ele só podera editar o proprio usuario | - |
|`user.update_all`| Permissão para editar qualquer usuario do sistema | `user.update` |
|`user.delete` | Permissão para fazer um soft delete | - |
|`hospital.create`|Permissão para criar hospitais | - |
|`hospital.update`| Permissão para atualizar hospitais | - |
|`hospital.list` | Permissão para listar os hospitais, caso o JWT só possua a action `hospital.list` mostra apenas hospitais que ele esteja participando | - |
|`hospital.all` | Permissão para listar **TODOS** os hospitais | `hospital.list` |
|`hospital.delete`| Permissão para um soft delete no hospital | - |
|`hospital.find` | Permissão para encontrar um hospital | - |
|`queue.list` | Permissão para listar a file | - |
|`medical_category.list`| Permissão para listar os medical categories | - |
|`medical_category.create`| Permissão para criar novos medical categories | - |
|`hospital_user.add`| Permissão para adicionar um usuário a um hospital | - |
|`user.resetpassword`| Permissão para solicitar um reset de senha | - |
|`role.list`| Permissão para listar as roles | - |
|`role.delete`| Permissão para fazer um soft delete em uma role | - |
|`role.update`| Permissão para atualizar uma role | - |
|`role.create`| Permissão para criar uma nova role | - |
|`role_action.create` | Permissão para vinculo de action com uma role | - |
|`role_action.delete`| Permissão para deletar um vinculo de action com uma role | - |
|`user_role.delete`| Permissão para deletar um vinculo entre um usuário e uma role | - |
|`user_role.create`| Permissão para fazer um vinculo entre um usuario e uma role | -|
|`action.list` | Permissão para listar todas as actions do sistema | - |
|`appointment.update`| Permissão para atualização de consultas | - |
|`patient.list`| Permissão para listar **TODOS** os pacientes | - |
|`patient.find`| Permissão para Editar pacientes | - |
|`patient.update`| Permissão para atualizar os paciente | - |
|`patient.create`| Permissão para criar  o paciente | - |
|`patient.delete`| Permissão para soft delete de paciente| - |

# Usuarios do sistema

Existem os 5 tipos de usuarios do sistema

| Role | Usuario | Senha |
|--------|-------------|------------|
|ADMIN| admin@helpdoctor.com.br| 123|
|MANAGER|manager@helpdoctor.com.br|123|
|DOCTOR| doctor@helpdoctor.com.br| 123|
|MANAGER| manager@helpdoctor.com.br|123|
|RECEPCIONIST| recepcionist@helpdoctor.com.br | 123 |


# Endpoints

## Carga automática `[GET] /init`
Rota responsavel por criar as tabelas e preencher os dados

## Autorização `[POST] /oauth/authorize`

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
 POST /oauth/authorize HTTP/1.1

 Host: authorization-server.com.br
 &grant_type=password

```

### Exemplo CURL

```curl
curl -X POST -F 'username=admin@helpdoctor.com.br' -F 'password=123' authorization-server.com.br?grant_type=password
```

> Para logar no sistema, existe um usuário teste que é username: `admin@helpdoctor.com.br` e `password` 123


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


## Listar hospitais `[GET] /hospital`

Busca os hospitais

> Essa rota requer a action `hospital.list`

Caso o usuario tenha a action `hospital.all` a rota retorna **TODOS** os hospitais.
Agora, se o usuário tiver só a action `hospital.list` então retorna só os hospitais dos quais o usuário esta participando

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

## Ver hospital `[GET] /hospital/{id}`

### Resposta
```

{
  "id": 1,
  "name": "HOSPITAL ALBERT EINSTEIN",
  "addressId": 1,
  "createdAt": "2018-11-07T10:05:44.369Z",
  "updatedAt": "2018-11-07T10:05:44.369Z",
  "deletedAt": null,
  "addressHospital": {
    "id": 1,
    "formatedaddress": "Avenida Alet Einstein, 627 Moumi | São Paulo Telefone: (11) 2151-1233",
    "address": "teste",
    "neighborhood": "TESTE",
    "state": "SP",
    "zipcode": "9780900",
    "number": "627",
    "complement": "",
    "createdAt": "2018-11-07T10:05:41.700Z",
    "updatedAt": "2018-11-07T10:05:41.700Z"
  }
}

```

## Criar hospitais `[POST] /hospital`

Cria hospitais

> Para essa rota, é necessário que você tenha a action `hospital.create` na sua role

```json
{
    "name": "HOSPITAL ALBERT EINSTEIN",
    "addressId": 1
}
```

ou

```json
{
    "name": "Meu novo hospital",
    "address": {
        "address": "Rua Help doctor",
        "neighborhood": "Bairro help",
        "state": "SP",
        "zipcode": "04174092",
        "number": "9",
        "complement": ""
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


## Atualizar hospitais `[PUT] /hospital/{id}`

Atualizar dados de um hospital, para os dados de endereço ou você passa uma referencia de enderço ou passa os dados do endereço _(Para essa ação irá editar os dados do endereço vinculado ao hospital)_
> Para essa ação é necessário ter a ação `hospital.update` na sua role

### Payload
```json
{
    "name": "HOSPITAL ALBERT EINSTEIN editado",
    "addressId": 2
}
```

ou

```json
{
    "name": "HOSPITAL ALBERT EINSTEIN editado",
    "address": {
        "address": "string editada",
        "neighborhood": "string editada",
        "state": "SP",
        "number": "string editada",
        "complement": "",
        "zipcode": ""
    }
}
```

### Resposta
```json
{
    "id": 1,
    "name": "HOSPITAL ALBERT EINSTEIN editado",
    "addressId": 2,
    "createdAt": "2018-11-06T16:28:30.811Z",
    "updatedAt": "2018-11-06T19:34:32.001Z",
    "deletedAt": null,
    "addressHospital": {
        "id": 2,
        "formatedaddress": null,
        "address": "Rua bla bla ",
        "neighborhood": "Bairro Bla bla",
        "state": "SP",
        "zipcode": "04174092",
        "number": "9",
        "complement": "",
        "createdAt": "2018-11-06T16:29:32.185Z",
        "updatedAt": "2018-11-06T16:29:32.185Z"
    }
}
```


## Deletar hospitais `[DELETE] /hospital/{id}`

### Resposta
```
1 | 0
```


## usuario nos hospitais `[POST] /hospital/user`

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


## usuario nos hospitais `[GET] /medical/category`



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


## cadastrar category medical `[POST] /medical/category`



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


## Listar todas as roles `[GET] /role`



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

## ver actions `[GET] /action`


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


## ver role `[GET] /role/{id}`



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


## cadastrar role `[POST] /role`



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

## atualizar role `[PUT] /role/{id}`



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

## cadastrar action na role `[POST] /role/action/`



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

## remover action na role `[DELETE] /role/action/`



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

## cadastrar user na role `[POST] /role/user/`



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

## remover action na role `[DELETE] /role/user/`



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

## [GET] Listar todos os usuários dos sistema `/user`

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

## Procurar usuario no sistema `[GET] /user/:id`

Procura um usuario no sistema

### Parametros

| Parametro | Tipo | Obrigatorio | Descrição |
|-----------|------|-------------|-----------|
| `id`      | `string` ou `integer` | `true` | Id do usuário |

### Querystring

| Parametro | Descrição |
|-----------|-----------|
| `deleteds`      | Query string que diz se deve retornar os usuários desativados|

### Exemplo Curl
```
 GET /oauth/authorize HTTP/1.1

 Host: authorization-server.com.br
 ?deleted

```

### Erros possíveis

| Status Code |     Error    |  Message  |  Motivo   |
|-------------|--------------|-----------|-----------|
| `500`       |   `Internal Server error`|  `Internal Server error` | Ocorreu um erro no servidor, é necessário debugar |

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
  "address": {
    "address": "Rua teste",
    "neighborhood": "Bairro teste",
    "number": 1,
    "city": "São Paulo",
    "state": "SP",
    "zipcode": "04174090"
    },
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
|`address.address`| `string` | `true` | Rua do endereço |
|`address.neighborhood`| `string` | `true` | Bairro do endereço |
|`address.city`| `string` | `true` | Cidade do endereço |
|`address.state`| `string` | `true` | Estado do endereço |
|`address.zipcode`| `string` | `true` | CEP do endereço |
|`address.number`| `integer` | `true` | número do endereço |
|`address.complement`| `string` | `false` | Complemento do endereço |
|`hospitals`| `Array` | `false` | Lista de hospitais que o usuário esta participando|



### Erros Possíveis

| Status Code |     Error    |  Message  |  Motivo   |
|-------------|--------------|-----------|-----------|
| `403`       |   `Bad Request`|  `CPF Invalido` | O CPF passado é um CPF inválido |

----

## Editar usuario `[PUT] /user/:id`

Edita usuario de acordo com um ID passado
> Essa rota edita também os usuários que estão desativados.

### Atributos

### Atributos

| Atributo | Tipo | Obrigatório | Descrição |
|-----------|------|------|-----------|
|`name`| `string` |`false` | Nome do usuário |
|`email`| `string` | `false` | Email do usuário |
|`password`| `string` | `false` | Senha do usuário, a principio não tem nenhuma validação de minimo de caracteres |
|`personal_document`| `string` | `false` | CPF do usuário |
|`birthday`| `date` | `false` | Data de aniversário do usuário |
|`roles_id`| `array` | `false` | uma lista de roles que o usuário vai ter |
|`genre`| `string` | `false` | Sexo do usuário |
|`address.address`| `string` | `false` | Rua do endereço |
|`address.neighborhood`| `string` | `false` | Bairro do endereço |
|`address.city`| `string` | `false` | Cidade do endereço |
|`address.state`| `string` | `false` | Estado do endereço |
|`address.zipcode`| `string` | `false` | CEP do endereço |
|`address.number`| `integer` | `false` | número do endereço |
|`address.complement`| `string` | `false` | Complemento do endereço |
|`hospitals`| `Array` | `false` | Lista de hospitais que o usuário esta participando|

### URL exemplo
[PUT] `/user/20`
### Payload

```json
  {
  "name": "Guilherme Rodrigues",
  "email": "gp.rodrigues94@gmail.com",
  "deletedAt": null
  }
```
---

## Deletar usuario `[DELETE] /user/{id}`

Deleta um usuário

### Parametros

| Parametro | Tipo | Obrigatorio | Descrição |
|-----------|------|-------------|-----------|
| `id`      | `string` ou `integer` | `true` | Id do usuário |

---


## reset da senha `[POST] /user/reset`


na API, precisa ver a rota para colocar o e-mail de envio

### Enviar
```
    {
        "email": "1"
    }
```

### Resposta
```
    {errors: false ,data: object}
```
---

## Listar Paciente `[GET] /patient`

> Requer a action `patient.list`

Lista os pacientes

### Response

```json
[
    {
        "id": 1,
        "name": "afraates",
        "email": "afraates@gmail.com",
        "personal_document": "13650671816",
        "addressId": 85,
        "phoneNumber": "(11) 99620-2147",
        "birthday": "1962-07-06T03:00:00.000Z",
        "genre": "M",
        "createdAt": "2018-11-11T00:03:15.948Z",
        "updatedAt": "2018-11-11T00:03:15.948Z",
        "deletedAt": null,
        "address": {
            "id": 85,
            "formatedaddress": "Rua Voluntáios da Pátia 2786 Santana – São Paulo Telefone: (11) 2955| 1601",
            "address": "teste",
            "neighborhood": "TESTE",
            "city": null,
            "state": "SP",
            "zipcode": "9780900",
            "number": "2786",
            "complement": "",
            "createdAt": "2018-11-11T00:03:01.176Z",
            "updatedAt": "2018-11-11T00:03:01.176Z"
        }
    }
]
```

---

## Procurar um paciente `[GET] /patient/:id

> Precisa da action `patient.find`

### Parametros da URL
| Parametro | Descrição | Obrigatorio |
|------------------|----------------|-------------------|
|`id`| ID do paciente | `true` |

### Response

```json
{
    "id": 2,
    "name": "airton_neto",
    "email": "airton_neto@hotmail.com",
    "personal_document": "059.884.756-12",
    "addressId": 86,
    "phoneNumber": "(34) 98829-6714",
    "birthday": "1993-03-28T03:00:00.000Z",
    "genre": "M",
    "createdAt": "2018-11-11T00:03:15.983Z",
    "updatedAt": "2018-11-11T00:03:15.983Z",
    "deletedAt": null,
    "address": {
        "id": 86,
        "formatedaddress": "Alameda Santos, Cerqueira César - São Paulo - SP",
        "address": "teste",
        "neighborhood": "TESTE",
        "city": null,
        "state": "SP",
        "zipcode": "01418-100",
        "number": "1126",
        "complement": "ANDAR 3",
        "createdAt": "2018-11-11T00:03:01.198Z",
        "updatedAt": "2018-11-11T00:03:01.198Z"
    }
}
```

---

## Editar paciente `[/PUT] /patient/:id`

> Requer a ação `patient.update`

### Payload

```json
{
  "name": "Airton Neto"
}
```

### Response

```json
[
    1
]
```

mostra a quantidade de registros que foram editados

---

## Criar paciente `[POST] /patient`

> Requer a ação `patient.create`

### Payload

```json
{
    "name": "Fofão",
    "email": "fofao@gmail.com",
    "personal_document": "12332132145",
    "phoneNumber": "(11) 99620-2147",
    "birthday": "1962-07-06T03:00:00.000Z",
    "genre": "M",
    "address": {
        "address": "Rua aractu",
        "neighborhood": "Vila Liviero",
        "city": "São Paulo",
        "state": "SP",
        "zipcode": "9780900",
        "number": "99"
    }
}
```

### Response

```json
{
    "id": 251,
    "name": "Fofão",
    "email": "fofao@gmail.com",
    "personal_document": "12332132145",
    "addressId": 336,
    "phoneNumber": "(11) 99620-2147",
    "birthday": "1962-07-06T03:00:00.000Z",
    "genre": "M",
    "createdAt": "2018-11-11T03:03:05.100Z",
    "updatedAt": "2018-11-11T03:03:05.100Z",
    "deletedAt": null,
    "address": {
        "id": 336,
        "formatedaddress": "Rua aractu, 99 - Vila Liviero, São Paulo - SP",
        "address": "Rua aractu",
        "neighborhood": "Vila Liviero",
        "city": "São Paulo",
        "state": "SP",
        "zipcode": "9780900",
        "number": "99",
        "complement": null,
        "createdAt": "2018-11-11T03:03:04.963Z",
        "updatedAt": "2018-11-11T03:03:04.963Z"
    }
}
```

## Deletar `[DELETE] /patient/:id`

> Requer a ação `patient.delete`

### Response

```json
{
    "deleted": true
}
```

