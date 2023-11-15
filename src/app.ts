import express from 'express';
import emailRoute from './routes/email';
import homeRoute from './routes/home';
import config from 'config';

const app = express();
app.use(express.json());  
const port = config.get('port');

app.use('/email', emailRoute);
app.use('/sendMessage', homeRoute);

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
