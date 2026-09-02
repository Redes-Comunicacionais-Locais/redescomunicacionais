import * as admin from "firebase-admin";

export interface PublicKey {
  id: string;
  email: string;
  cities: string[];
  publicKey: string;
  oldPublicKeys: string[];
  createdAt: Date | null;
  updatedAt: Date | null;
}

export function firestoreToPublicKey(id: string, data: any): PublicKey {
  return {
    id: id,
    email: data.email || "",
    cities: data.cities || [],
    publicKey: data.publicKey || "",
    oldPublicKeys: data.oldPublicKeys || [],
    createdAt: data.createdAt?.toDate ? data.createdAt.toDate() : null,
    updatedAt: data.lastUpdated?.toDate ? data.lastUpdated.toDate() : null
  };
}

export function toFirestore(data: PublicKey): any {
  return {
    id: data.id,
    email: data.email,
    cities: data.cities || [],
    publicKey: data.publicKey,
    oldPublicKeys: data.oldPublicKeys || [],
    createdAt: data.createdAt
      ? admin.firestore.Timestamp.fromDate(data.createdAt)
      : admin.firestore.FieldValue.serverTimestamp(),
    lastUpdated: admin.firestore.FieldValue.serverTimestamp()
  };
}