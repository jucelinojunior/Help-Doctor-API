class FailedToAuthenticateError extends Error {
  constructor () {
    super('Failed to Authenticate')
    this.name = 'FailedToAuthenticateError'
  }
}

module.exports = FailedToAuthenticateError
