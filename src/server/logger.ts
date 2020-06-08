import pino from 'pino';

const parentLogger = pino({
  name: process.env.APP_ID,
  level: process.env.LOG_LEVEL || 'debug',
});

const logger = parentLogger.child({
  ProjectId: process.env.ProjectId,
  BuildNumber: process.env.BuildNumber,
  ServiceName: process.env.ServiceName,
  Environment: process.env.Environment,
});

export default logger;
