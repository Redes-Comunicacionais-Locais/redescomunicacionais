import { onCall } from "firebase-functions/https";
import { getLoggedUser } from "../utils/auth-utils";
import { User } from "../model/User";
import { CallableRequest } from "firebase-functions/v2/https";
import { PublicKey } from "../model/PublicKey";
import { publicKeyService } from "../service/public-key.service";

export const savePublicKey = onCall<PublicKey>(async (request: CallableRequest<any>): Promise<void> => {
  try {
    let loggedUser: User = getLoggedUser(request.auth);
    let data: PublicKey = request.data;

    await publicKeyService.saveNewKey(data, loggedUser);
  } catch (e) {
    // TO DO
  }
});

export const getPublicKeysPackage = onCall<PublicKey>(
  async (request: CallableRequest<any>): Promise<void> => {
    try {
      let loggedUser: User = getLoggedUser(request.auth);
      let data: PublicKey = request.data;

      await publicKeyService.saveNewKey(data, loggedUser);
    } catch (e) {
      // TO DO
    }
});
