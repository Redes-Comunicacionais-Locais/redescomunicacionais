import { HttpsError } from "firebase-functions/v2/https";
import { PublicKey } from "../model/PublicKey";
import { User } from "../model/User";
import { publicKeyRepository } from "../repository/public-key.repository";

export const publicKeyService = {
  saveNewKey: async (data: PublicKey, loggedUser: User): Promise<void> => {
    if (data.email !== loggedUser.email || data.id !== loggedUser.email) {
      throw new HttpsError("permission-denied", "Key does not belong to this user.");
    }
    await publicKeyRepository.save(data,loggedUser);
  }
};