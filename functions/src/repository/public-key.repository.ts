import * as admin from "firebase-admin";
import { PublicKey } from "../model/PublicKey";
import { firestore } from "firebase-admin";
import Firestore = firestore.Firestore;
import {User} from "../model/User";

export const publicKeyRepository = {
  save: async (data: PublicKey, loggedUser: User): Promise<string> => {
    const fs: Firestore = admin.firestore();

    const docRef = await fs.collection("public_keys").add({
      ...data,
    });

    return docRef.id;
  }
};