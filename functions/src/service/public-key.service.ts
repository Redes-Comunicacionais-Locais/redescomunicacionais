import {HttpsError} from "firebase-functions/v2/https";
import {PublicKey} from "../model/PublicKey";
import {User} from "../model/User";
import {PublicKeyRepository} from "../repository/public-key.repository";
import {PackageService} from "./package.service";
import {KeysPackageJson, keysPackageToJson} from "../model/KeysPackage";

export const publicKeyService = {

  saveNewKey: async (data: PublicKey, loggedUser: User): Promise<void> => {
    if (data.email !== loggedUser.email || data.id !== loggedUser.email) {
      throw new HttpsError("permission-denied", "Key does not belong to this user.");
    }

    await PublicKeyRepository.save(data,loggedUser);
  },

  getPublicKeysPackage: async (privateKey: string): Promise<KeysPackageJson> => {
    const publicKeys = await PublicKeyRepository.getAll();

    const keysPackage = PackageService.createPackage(
      publicKeys,
      "INTERNAL_API",
      privateKey
    );

    return keysPackageToJson(keysPackage);
  }
};