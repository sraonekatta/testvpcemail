import express from 'express';
import sgMail from '@sendgrid/mail';
import * as dotenv from 'dotenv';
import config from 'config';

const router = express.Router();
sgMail.setApiKey(config.get('sendGridApiKey'))
dotenv.config();

router.get('/', (req, res) => {
  console.log("this is new service vpc")
  res.send('email sent!');
});

export default router;
