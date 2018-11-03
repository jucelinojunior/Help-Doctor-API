const userService = require('../services/user.service')
const nodemailer = require('nodemailer');
const bcrypt = require('bcrypt-nodejs')

module.exports = {
  method: 'POST',
  path: '/user/reset',
  handler: async (request) => {
    return userService.getUserByEmail(request.payload.email).then(user => {

      if(user == null)
        return {errors: true,data: 'E-mail não encontrado'}

        const transporter = nodemailer.createTransport({
          service: 'gmail',
          auth: {
            user: 'email@gmail.com',
            pass: 'senha'
          }
        });
        
        const pass = Math.floor(Math.random() * 100)+""+Math.floor(Math.random() * 100)+""+Math.floor(Math.random() * 100);
        
        const mailOptions = {
          from: 'email@gmail.com',
          to: user.email,
          subject: 'Reset de senha',
          text: 'Nova senha: '+pass
        };

        const salt = bcrypt.genSaltSync(10);
        user.password = bcrypt.hashSync(pass, salt);

        return user.save().then(()=>{

          transporter.sendMail(mailOptions, function(error, info){
          if (error) {
            console.log(error);
            } else {
              console.log('Email sent: ' + info.response);
            }
          });

          return {errors: false,data: user}
        
        }).catch(error => {
          return {errors: true,data: 'E-mail não encontrado'}
        });

    });

  },
  options: {
    cors: {
      origin: ['*']
    }
  }
}