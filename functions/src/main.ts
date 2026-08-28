import { setGlobalOptions } from "firebase-functions/v2/options";
import * as admin from "firebase-admin";
import { save } from "./controller/public-key.controller";

setGlobalOptions({ maxInstances: 10 });
admin.initializeApp();

export const newPublicKey= save;
