function handler (request, h) {
  return { code: 200, status: 'Up and Running' }
}

module.exports = {
  method: 'GET',
  path: '/status',
  handler
}
