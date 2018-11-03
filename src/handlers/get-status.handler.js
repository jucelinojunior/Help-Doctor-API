function handler (request, h) {
  const result = { code: 200, status: 'Up and Running' }
  return h.response(result).code(200)
}

module.exports = {
  method: 'GET',
  path: '/status',
  handler,
  options: {
    cors: {
      origin: ['*']
    }
  }
}
