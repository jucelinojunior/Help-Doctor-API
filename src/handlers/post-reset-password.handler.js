const userService = require('../services/user.service')
const nodemailer = require('nodemailer')
const bcrypt = require('bcrypt-nodejs')
const {
  EMAIL_USERNAME,
  EMAIL_SERVICE,
  EMAIL_PASSWORD
} = process.env

module.exports = {
  method: 'POST',
  path: '/user/reset',
  handler: async (request) => {
    return userService.getUserByEmail(request.payload.email).then(user => {
      if (user === null) return {errors: true, data: 'E-mail não encontrado'}
      const transporter = nodemailer.createTransport({
        service: EMAIL_SERVICE,
        auth: {
          user: EMAIL_USERNAME,
          pass: EMAIL_PASSWORD
        }
      })
      //  Gera uma senha randomica
      const pass = Math.floor(`${ Math.floor(Math.random() * 100)}${+Math.floor(Math.random() * 100)}${+Math.floor(Math.random() * 100)}`)

      const mailOptions = {
        from: EMAIL_USERNAME,
        to: user.email,
        subject: 'Nova senha',
        text: `Sua nova senha é: ${pass}`
      }

      const salt = bcrypt.genSaltSync(10)
      user.password = bcrypt.hashSync(pass, salt)

      return user.save().then(() => {
        transporter.sendMail(mailOptions, (error, info) => {
          if (error) {
            console.log(error)
          } else {
            console.log('Email sent: ' + info.response)
          }
        })

        return {errors: false, data: user}
      }).catch(() => {
        return {errors: true, data: 'E-mail não encontrado'}
      })
    })
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['user.resetpassword']
    },
    cors: {
      origin: ['*']
    }
  }
}