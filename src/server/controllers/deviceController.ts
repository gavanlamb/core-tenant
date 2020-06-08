import { Request, Response } from 'express';
import Logger from '../logger';

export const createTenant = (req: Request, res: Response) => {
  Logger.info(req.body);
  res.status(200);
  res.send();
};

export const getTenant = (req: Request, res: Response) => {
  Logger.info(req.body);
  res.status(200);
  res.send();
};
