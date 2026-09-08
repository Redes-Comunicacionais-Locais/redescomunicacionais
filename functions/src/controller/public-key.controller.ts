import { onCall } from "firebase-functions/https";
import { getLoggedUser } from "../utils/auth-utils";
import { User } from "../model/User";
import {CallableRequest, HttpsError} from "firebase-functions/v2/https";
import { PublicKey } from "../model/PublicKey";
import { publicKeyService } from "../service/public-key.service";
import { defineSecret } from "firebase-functions/params";
import {KeysPackage} from "../model/KeysPackage";

const apiPrivateKey = defineSecret("API_PRIVATE_KEY");

export const savePublicKey = onCall<PublicKey>(async (request: CallableRequest<any>): Promise<void> => {
  try {
    let loggedUser: User = getLoggedUser(request.auth);
    let data: PublicKey = request.data;

    await publicKeyService.saveNewKey(data, loggedUser);
  } catch (e) {
    throw new HttpsError(
      "internal",
      "Internal server error."
    );
  }
});

export const getPublicKeysPackage = onCall<void>({ secrets: [apiPrivateKey] },
  async (request: CallableRequest<any>): Promise<KeysPackage> => {
    try {
      getLoggedUser(request.auth);
      const privateKeyStr = apiPrivateKey.value();

      return await publicKeyService.getPublicKeysPackage(privateKeyStr);
    } catch (e) {
      throw new HttpsError(
        "internal",
        "Internal server error."
      );
    }
});
