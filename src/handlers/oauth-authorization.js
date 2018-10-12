/**
 * Especificação de uma autorização - https://www.oauth.com/oauth2-servers/access-tokens/password-grant/
 * Response de uma token - https://www.oauth.com/oauth2-servers/access-tokens/access-token-response/
 * GERAR TOKEN - https://tools.ietf.org/html/rfc6750
 */
module.exports = {
	method: 'POST',
	path: '/oauth/authorize',
	handler: function(request, h) {
    const {grant_type, username, password} = request.params.query
    if (grant_type === 'password') {

    }
    //  Recupera o usuario pelo username

    //  Criptografa o password passado com o salt do usuario

    //  Se o password passado e criptografado for igual ao password do documento (que ja esta criptografado) então é sucesso
	}
}
