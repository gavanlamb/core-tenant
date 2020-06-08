import Logger from './logger';
import app from './app';

const server = app.listen(process.env.PORT || 8080, () => {
  Logger.info(`Starting server on port:${process.env.PORT || 8080}`);
});

export default server;
