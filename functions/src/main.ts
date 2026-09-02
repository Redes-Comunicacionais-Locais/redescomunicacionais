import { setGlobalOptions } from "firebase-functions/v2/options";
import * as admin from "firebase-admin";

setGlobalOptions({ maxInstances: 10 });
admin.initializeApp();

export * from "./controller/health-check";
export * from "./controller/public-key.controller";
